# Fehlerbehandlung in PZM_P_LC / PZM_P_LOG — Grundlagen und Codierungs-Richtlinien

Stand: W24120-648. Grundlage für die Team-Präsentation zu den Änderungen in `PZM_P_LC` und deren
Anwendung in `PZM_P_ZEITERFASSUNG`.

## 1. Ausgangslage und Prioritäten

Vor der Überarbeitung war die Fehlerbehandlung in `PZM_P_ZEITERFASSUNG` uneinheitlich: hartkodierte
Modulname-Literale (Ursache mehrerer Copy-Paste-Bugs), keine Garantie, dass jede Exception tatsächlich
in `PZM_LOG` landet, und mehrere leicht unterschiedliche Handler-Muster nebeneinander.

Die Überarbeitung folgt bewusst dieser Prioritätenreihenfolge:

1. **Garantierte, lückenlose Protokollierung** jeder Exception in `PZM_LOG` (Detailtreue der
   Meldung an den Client ist sekundär).
2. **Lesbarkeit/Einfachheit** für Entwickler — nur was einfach zu benutzen ist, wird auch korrekt
   benutzt.
3. **Vermeidung von Redundanz** (Copy-Paste-Code, doppelte Logging-Aufrufe).
4. **Kleine, evidenzbasierte Optimierungen** — nichts wird ohne konkreten Beleg (Code-Analyse,
   Nachrechnen) geändert.

## 2. Grundlagen: PL/SQL-Exception-Handling 

Kurzer Einstieg und Auffrischung für alle, die sich mit dem Exception-Handlung in PL/SQL bisher nicht
intensiver befasst haben:

- `BEGIN...EXCEPTION WHEN...END` 
  entspricht grob try/catch — aber es gibt **kein Exception-Objekt**
  und **keine Klassenhierarchie**. 
  `WHEN OTHERS THEN` entspricht strukturell `catch(Exception ex)`:
  es fängt alles, ohne eingebaute Typunterscheidung.
- Ein nacktes `RAISE;` (ohne Angabe) reicht den ursprünglichen Fehler unverändert weiter — Analogie:
  C#s `throw;` (Stack/Ursprung bleibt erhalten) im Gegensatz zu `throw ex;` (würde zurückgesetzt).
  Genau deshalb wurde das frühere `catch_and_rethrow()`-Wrapping ersatzlos entfernt (siehe Abschnitt 5).
- `RAISE_APPLICATION_ERROR` ist Oracles eingebauter Weg, eigene Fehler mit Code und Message zu
  werfen — der Code-Bereich ist aber hart auf `-20000..-20999` begrenzt (1000 Werte). Es gibt kein
  eigenes Exception-Typsystem wie in .NET; `PZM_P_LC` bildet diese Rolle nach (Katalog aus `cerr_*`-
  Codes und `O_T*`-Meldungskonstanten).
- **Keine automatische Transaktions-Rücknahme:** anders als man vielleicht erwarten würde, rollt
  eine ungefangene Exception die Transaktion NICHT automatisch zurück — bereits ausgeführtes DML
  bleibt bestehen, bis explizit `ROLLBACK` oder `COMMIT` erfolgt. Deshalb das explizite `rollback;`
  im einheitlichen Handler-Muster (Abschnitt 5).
- `PRAGMA AUTONOMOUS_TRANSACTION` erlaubt eine "unabhängige" Mini-Transaktion innerhalb der
  laufenden — genutzt, damit ein Log-Eintrag auch dann bestehen bleibt, wenn die äußere Transaktion
  später zurückgerollt wird. Das ist am ehesten vergleichbar mit einer zweiten, unabhängigen DB-
  Verbindung nur fürs Logging.
  Vorsicht: kann sich selbst blockieren, wenn dieselbe Zeile in der äußeren, noch offenen Transaktion 
  gesperrt ist (siehe Testfall `test_at_self_deadlock_on_locked_row` in `HM_LOG_TESTCASES`).
- `SQLCODE`/`SQLERRM` sind **nur innerhalb des Handlers** gültig — es gibt kein Objekt wie `ex`,
  das man weiterreichen kann. Wer den Wert später braucht, muss ihn sofort in eine lokale Variable
  kopieren.
- Was sich in den letzten ~20 Jahren tatsächlich getan hat: `DBMS_UTILITY.FORMAT_ERROR_BACKTRACE`
  (ab 10g, ~2004) liefert erstmals die tatsächliche Fehlerzeile statt nur die Catch-Stelle;
  `UTL_CALL_STACK` (ab 12c, ~2013) liefert erstmals programmatischen Zugriff auf den Aufruf-Stack —
  Grundlage für `current_unit_name()` (Abschnitt 4).
- Drei-wertige Logik: `IF NULL THEN` wird stillschweigend wie `FALSE` behandelt und übersprungen —
  es gibt kein Äquivalent zu einer `NullReferenceException`. Grund für die `NVL()`-Absicherungen bei
  `assert()`-Bedingungen, die auf möglicherweise NULL-wertigen Ausdrücken beruhen (`assert()`
  protokolliert wie `raise_app_error*()` automatisch **vor** dem Werfen, siehe Abschnitt 6).

## 3. Architektur-Trennung: PZM_P_LC ↔ PZM_P_LOG

| Package | Zuständigkeit |
|---|---|
| **PZM_P_LC** | *Wie* und *wann* eine Anwendungsexception geworfen wird. Fehlercode-/Message-Katalog (`cerr_*`, `O_T*`-Konstanten). Die dafür genutzten Prozeduren `raise_app_error()`/`raise_app_error_p()`/`assert()` (Abschnitt 6) protokollieren dabei **einmalig und automatisch**, **bevor** die Exception den Aufrufer erreicht — der Aufrufer selbst muss dafür nichts weiter tun. |
| **PZM_P_LOG** | *Wie* und *wo* tatsächlich protokolliert wird: Tabelle vs. Session-Puffer, Level-Filterung (`g_table_log_level`), vollständige Aufbereitung echter Systemfehler inkl. Backtrace. |

`PZM_P_LC` persistiert selbst nichts — jeder Schreibzugriff auf `PZM_LOG` läuft über `PZM_P_LOG`.

> **Merksatz:** Wer `pzm_p_lc.raise_app_error*()` oder `pzm_p_lc.assert()` aufruft, hat den Fehler damit
> bereits protokolliert — unabhängig davon, ob und wo die Exception später gefangen wird.

## 4. `current_unit_name()` statt hartkodierter Modulnamen

```sql
c_module_name constant varchar2(50) := current_unit_name();
```

In der Deklarationssektion jeder Prozedur/Funktion. Ersetzt manuell eingetippte String-Literale wie
`'c_live_stempeln'` — genau diese Literale waren mehrfach falsch (kopiert aus einer anderen
Prozedur) oder wurden bei Umbenennungen vergessen.

Implementierung: `UTL_CALL_STACK.SUBPROGRAM(2)` — Tiefe 2, da die Konstante innerhalb der
aufrufenden Prozedur deklariert wird. **Funktioniert nur, wenn direkt in der Ziel-Prozedur
aufgerufen** — nicht aus einer gemeinsamen Hilfsfunktion heraus auslagerbar.

## 5. Das einheitliche Handler-Muster

```sql
procedure irgendeine_prozedur(...) is
  c_module_name constant varchar2(50) := current_unit_name();
begin
  ...
exception
  when others then
    rollback; -- nur falls die Prozedur eigenes DML durchgefuehrt hat
    if not pzm_p_lc.is_app_code(sqlcode) then
      pzm_p_log.log_exception(
        p_category => pzm_p_log.CAT_ZEITERFASSUNG,
        p_module   => c_module_name,
        ...
      );
    end if;
    raise;
end;
```

**Warum das funktioniert:** `raise_app_error()`/`raise_app_error_p()` protokollieren bereits VOR
dem Werfen (siehe Abschnitt 6). Der `IF NOT is_app_code(sqlcode)`-Guard verhindert, dass solche
bereits protokollierten Anwendungsfehler ein zweites Mal geloggt werden — während echte
Systemfehler (`is_app_code = FALSE`) hier garantiert erfasst werden. Kein Wrapping mehr: der
Aufrufer sieht immer den unveränderten Original-`SQLCODE`/`SQLERRM` (das frühere
`catch_and_rethrow()` wurde ersatzlos entfernt).

## 6. `raise_app_error` / `raise_app_error_p` / `assert()`

Drei Signaturen, alle mit automatischer Vor-Protokollierung:

```sql
-- Freitext
pzm_p_lc.raise_app_error(in_code, in_message);

-- Katalog-Konstante + 1-2 Parameter
pzm_p_lc.raise_app_error_p(in_code, in_const_name, in_p1, in_p2 default null);

-- Katalog-Konstante + beliebig viele Parameter
pzm_p_lc.raise_app_error_p(in_code, in_const_name, in_plist);
```

**`assert()`** — lesbarer Ersatz für `IF NOT <Bedingung> THEN raise_app_error*(...); END IF;`,
in denselben drei Signaturvarianten, jeweils mit vorangestelltem `in_condition`:

```sql
-- vorher
if in_ze_context.pers_nr is null then
  pzm_p_lc.raise_app_error(pzm_p_lc.cerr_pzm_ze_daten_invalid, pzm_p_lc.O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR);
end if;

-- nachher
pzm_p_lc.assert(
    in_condition => in_ze_context.pers_nr is not null
  , in_code      => pzm_p_lc.cerr_pzm_ze_daten_invalid
  , in_message   => pzm_p_lc.O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR);
```

Deckt sowohl Eingabevalidierung als auch interne Zustands-Assertions ab — die Unterscheidung
ergibt sich allein aus dem gewählten Fehlercode/der Meldung, nicht aus unterschiedlicher
Infrastruktur.

**`in_already_logged`** (Default `FALSE`): Für die seltenen Fälle, in denen der Aufrufer selbst
schon eine reichhaltigere, kontextspezifische Meldung geloggt hat (z. B. mit `p_pers_nr`/`p_ze_id`),
unterdrückt dieser Schalter die automatische, generische Vor-Protokollierung — vermeidet einen
redundanten zweiten `PZM_LOG`-Eintrag. Bewusst **kein** Parameter an `assert()` — wer manuell
vorprotokollieren will, braucht ohnehin ein eigenes `IF`, dann direkt `raise_app_error*()` mit
`in_already_logged` verwenden.

### Leitsatz für Unsicherheiten

> Bei jeder Zweifelsfrage (NULL-Werte, unklare Defaults, interne Fehler in Hilfsfunktionen) wird
> das Verhalten so gewählt, dass der schlimmste Fall ein **redundanter** Log-Eintrag ist — niemals
> ein **fehlender**.

Beispiel: `nvl(in_condition, ...)`-Absicherungen bei `assert()`-Aufrufen, deren Bedingung sonst bei
NULL-Werten stillschweigend nie auslösen würde (`NOT NULL` ergibt `NULL`, ein `IF NULL THEN`-Block
wird übersprungen wie bei `FALSE`).

## 7. Alternative: benannte Exceptions (`excp_*`) statt `raise_app_error*()`

`PZM_P_LC` deklariert zu jedem `cerr_*`-Fehlercode zusätzlich eine benannte Exception samt
`PRAGMA EXCEPTION_INIT`, die den PL/SQL-Namen mit dem numerischen Oracle-Fehlercode verknüpft:

```sql
excp_pzm_abt_id_404  EXCEPTION;
PRAGMA EXCEPTION_INIT(excp_pzm_abt_id_404, -20003);
```

Das ermöglicht grundsätzlich einen alternativen, nativen PL/SQL-Weg:

```sql
-- werfen:
RAISE pzm_p_lc.excp_pzm_abt_id_404;

-- fangen, typsicher statt ueber SQLCODE-Zahlenwerte:
EXCEPTION
  WHEN pzm_p_lc.excp_pzm_abt_id_404 OR pzm_p_lc.excp_kst_id_404 THEN ...
```

**Aktuell nirgends verwendet** — im gesamten Schema wird ausschließlich über die numerischen
`cerr_*`-Konstanten via `raise_app_error()`/`raise_app_error_p()`/`assert()` geworfen. Die
Exceptions bleiben trotzdem bewusst deklariert (siehe Kommentar im Package-Header), weil sie einen
denkbaren Vorteil böten:

- **Vorteil:** typsicheres Fangen einzelner Fehler ohne numerische `SQLCODE`-Werte im Code, inkl.
  Tippfehler-Erkennung durch den Compiler statt stiller Fehlklassifikation bei einem falschen
  Zahlenwert.

Dem stehen zwei Nachteile gegenüber, die bislang gegen eine Nutzung sprechen:

- **Nachteil 1:** Ein blankes `RAISE excp_pzm_xxx;` trägt keinen eigenen, parametrisierten
  Meldungstext — der entsteht erst, wenn vorher (z. B. über `raise_app_error_p()`)
  `RAISE_APPLICATION_ERROR` mit Code und Text aufgerufen wurde. Die Exceptions können
  `raise_app_error*()` also nicht ersetzen, sondern höchstens ergänzen.
- **Nachteil 2:** Ein per `WHEN excp_x THEN` gefangener Fehler hängt nicht automatisch am
  Logging-Mechanismus (`log_before_raise`/`is_app_code`) — ein so gebauter Handler müsste sich
  wieder selbst um vollständige Protokollierung kümmern, was genau die in Abschnitt 2 priorisierte
  Garantie unterläuft.

Es ist bewusst offen, ob es einen Anwendungsfall gibt, in dem dieser Weg gegenüber
`raise_app_error*()`/`assert()` vorzuziehen wäre — bislang wurde keiner identifiziert. Punkt zur
Diskussion im Team, analog zu `is_app_code()` (nächster Abschnitt).

## 8. `is_app_code()` — bewusste Team-Entscheidung, offen für Diskussion

```sql
function is_app_code(p_code pls_integer) return boolean is
begin
  return p_code in (cerr_pzm_pers_nr_404, cerr_pzm_rfid_pers_nr_404, ... /* alle 14 aktuellen Codes */);
end;
```

Prüft explizit gegen die tatsächlich deklarierten Fehlercodes, **nicht** pauschal den Bereich
`-20999..-20000`. Grund: Ein Systemfehler mit zufällig passendem `SQLCODE` in diesem Bereich (z. B.
aus einem Fremdpackage) würde bei der Bereichsprüfung fälschlich als "bereits protokolliert"
erkannt und **nie** in `PZM_LOG` landen. Nachteil: manuelle Pflege bei jedem neuen `cerr_*`-Code.

Die alte Bereichsprüfung steht als Kommentar im Code — bewusst nicht gelöscht, sondern als
Alternative offengehalten, falls der Pflegeaufwand sich als zu hoch erweist.

## 9. Weitere Konventionen

- **`-- OEFFENTLICH`/`-- PRIVAT`-Kommentar** an jeder Top-Level-Routine in Package-Bodies — Sichtbarkeit ist in Oracle durch die Spec bestimmt, aber bei großen Packages praktisch schwer auf einen Blick erkennbar.
- **Benannte Parameter** bei `assert()`/`raise_app_error_p()`-Aufrufen — lesbarer, analog zu den meisten `pzm_p_log`-Aufrufen.
- **Kein `return;` mitten im Ablauf** — stattdessen Werte je Fall vorab ermitteln (bevorzugt über die vorhandene `t_buchung_context`-Record-Struktur, nicht einzelne lose Variablen) und am Ende einen einzigen, konsolidierten Schreibzugriff mit einem Ausstiegspunkt. Siehe `c_change_ze_pers_kst_id()` als Referenzbeispiel für die Umstellung.
- **Alle Berechnungen vor dem INSERT/UPDATE**, nicht reaktiv als SQL-Ausdruck im `SET`.

## 10. Referenzbeispiel

`PZM_P_ZEITERFASSUNG.c_change_ze_pers_kst_id()` demonstriert die meisten Punkte in Kombination:
`current_unit_name()`, `assert()` in allen drei Varianten, `t_buchung_context` statt loser
Variablen, ein einziger konsolidierter `UPDATE` statt mehrerer sich teilweise widersprechender
Anweisungen, ausgelagerte Hilfsfunktionen (`kst_id_existiert()`, `ist_einziger_anwesend_eintrag()`)
statt Inline-`SELECT`s.
