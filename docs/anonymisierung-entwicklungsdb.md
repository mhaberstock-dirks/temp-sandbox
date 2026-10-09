# Anonymisierung von Personal- und Organisationsdaten

> **Zugehörige Dokumente:** [Verzeichnisstruktur](verzeichnisstruktur.md) · [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md)

Skripte unter [`tools/anonymize/`](../tools/anonymize/), um auf einer **individuellen Entwicklungsdatenbank** Personalstammdaten sowie Abteilungen und Produktionsbereiche durch Fantasiewerte zu ersetzen, typischerweise nach einer Datenübertragung aus der Produktion.

> **Nie auf der Produktion oder der gemeinsamen Haupt-Entwicklungsdatenbank ausführen.** Der Guard (siehe unten) verhindert das, solange `00_config.sql` korrekt gepflegt ist.

## Dateien

| Datei | Zweck |
|---|---|
| [`00_config.sql`](../tools/anonymize/00_config.sql) | Erlaubte Datenbanken (`anon_allowed`) und Tabellen für die Trigger-Skripte (`trg_tables`) |
| [`anonymisieren.sql`](../tools/anonymize/anonymisieren.sql) | Anonymisierung inkl. Prüfung; schaltet die nötigen Trigger für die Dauer des Laufs selbst ab |
| [`trigger_aus.sql`](../tools/anonymize/trigger_aus.sql) | Trigger der Tabellen aus `trg_tables` **vor** einer Datenübertragung abschalten, Zustand in Spool-Datei merken |
| [`trigger_ein.sql`](../tools/anonymize/trigger_ein.sql) | Genau diese Trigger **nach** der Übertragung wieder einschalten und prüfen |
| [`namen_vorschau.sql`](../tools/anonymize/namen_vorschau.sql) | Reines `SELECT`: zeigt, welchen Namen jede Personalnummer bekäme; auch auf der Produktion gefahrlos ausführbar |

Die Skripte liegen bewusst unter `tools/` und nicht unter `dist/`: `dist/` wird von `project stage` verwaltet und mit `gen-artifact` ausgeliefert (siehe [Verzeichnisstruktur](verzeichnisstruktur.md)).

## Ablauf

Alle Aufrufe in SQLcl, Arbeitsverzeichnis = Repo-Root.

**Nur anonymisieren** (Daten sind bereits auf der Entwicklungs-DB):

```sql
@tools/anonymize/anonymisieren.sql PROBE    -- alles ausführen und prüfen, dann ROLLBACK
@tools/anonymize/anonymisieren.sql COMMIT
```

**Datenübertragung aus der Produktion mit anschließender Anonymisierung:**

```sql
@tools/anonymize/trigger_aus.sql
--   Daten übertragen (z. B. TOAD Compare Data)
@tools/anonymize/anonymisieren.sql COMMIT
@tools/anonymize/trigger_ein.sql trigger_status_<db_name>_<zeitstempel>.sql   -- Aufruf gibt trigger_aus.sql aus
```

Ohne `trigger_aus.sql` würden bei der Übertragung alle Trigger feuern: Infor-Schnittstelle, Historie, Folge-Inserts in `PZM_KONTEN`, Audit-Spalten, PowerBI.

## Guard: nur freigegebene Datenbanken

Jedes Skript prüft vor jeder Änderung die Verbindung gegen `anon_allowed` in `00_config.sql`:

| Datenbank | Kennung | Grund |
|---|---|---|
| Autonomous Database | `SCHEMA@DB_NAME` | DB-Name eindeutig, Server-Host wechselt |
| alle anderen | `SCHEMA@DB_NAME@SERVER_HOST` | DB-Name nicht unbedingt eindeutig (Klone der Produktion), Host dauerhaft |

Die Skripte erkennen eine ADB selbst (`sys_context('userenv', 'cloud_service')`) und vergleichen die Kennung exakt. Die eigene Kennung steht in der ersten Ausgabezeile („Verbunden mit …“). Schlägt die ADB-Erkennung fehl, passt die Kennung zu keinem Eintrag – das Skript bricht ab, statt versehentlich zu laufen.

## Was `anonymisieren.sql` ändert

| Tabelle | Änderung |
|---|---|
| `PZM_PERSONAL`, `S_PZM_PERS`, `PZM_ZE_AZK_URLAUB`, `PZM_ZE_LOA_EXP_EXT_GUTSCH`, `Z_PZM_PERSONAL_IMPORT` | Vor- und Nachname (je Personalnummer überall derselbe Wert) |
| `S_PZM_PERS` zusätzlich | Username → `u<PERS_NR>`, Passwort und Telefon geleert, Adresse → Musterstrasse/12345/Musterstadt, Kürzel aus neuem Namen, Geburtsdatum → 1. Juli desselben Jahres |
| `PZM_ABWESENHEITS_ANTR` | `AU_BEMERKUNG` geleert (kann Namen oder Krankheitsgründe enthalten) |
| `PZM_ABTEILUNGEN` | „Abteilung <ID>“, Kurzname „A<ID>“, `ABT_INFO` geleert |
| `PZM_PRODUKTIONSBEREICHE` | „Bereich <ID>“, `PB_BEMERKUNGEN` geleert |

**Bewusst unverändert** – die Daten sind damit **pseudonymisiert, nicht anonymisiert** (mit dem Datenschutz abstimmen):

- `PERS_NR` (Schlüssel in rund 50 Tabellen) und damit alle daran hängenden Zeit-, Abwesenheits- und Lohndaten
- Anrede/Geschlecht, Tätigkeit, Vertrags- und Schichtdaten, Ein-/Austrittsdaten, Staatsangehörigkeit, Familienstand, Schwerbehinderung
- Audit-Spalten `CREATED_USER`/`LAST_CHANGE_USER`, `ISI_USER`, `ISI_CONTACT`, `ISI_ADRESSEN`, `ISI_KOSTENSTELLEN`

Im Code wird kein Abteilungs-, Bereichs- oder Personenname als fester Text verglichen; die Fantasiewerte brechen also keine Logik.

## Wie die Namen entstehen

- **Listen:** 100 weibliche und 100 männliche Vornamen, 250 Nachnamen aus 25 Wortanfängen × 10 Endungen (z. B. Birkenfeld, Lindenhof). Nur ASCII, keine Dubletten (wird geprüft).
- **Zuordnung:** Die Personalnummer wird umkehrbar auf eine Zahl im Namensraum `m = 100 × 250 = 25.000` abgebildet: `idx = PERS_NR × a mod m`, mit `a` teilerfremd zu `m` (das Skript sucht ihn ab `0,618 × m`; derzeit 15451). Daraus: Vorname = `idx mod 100`, Nachname = `idx div 100`.
- **Eigenschaften:**
  - *stabil* – der Name hängt nur an der eigenen Personalnummer; neue oder ausgeschiedene Mitarbeiter verschieben keine anderen Namen, wiederholte Läufe liefern dieselben Namen
  - *eindeutig*, solange die Spanne der Personalnummern kleiner als 25.000 ist; sonst meldet das Skript doppelte Namen als Hinweis (kein Abbruch)
- **Geschlecht:** Vorname passend zur Anrede (`FRAU…`/`HERR…`); bei unbekannter Anrede entscheidet `ora_hash(PERS_NR)`.
- **Technik:** Die Listen werden einmal mit `STRSPLIT` zerlegt und mit fester Breite (12 Zeichen) abgelegt; der n-te Name ist ein `substr` an berechneter Position. Die Updates laufen als ein `UPDATE` je Tabelle, die Anrede kommt per Unterabfrage aus `PZM_PERSONAL`.

`namen_vorschau.sql` zeigt die Zuordnung für den ganzen Personalstamm, inkl. der alternativen Variante „nach Position“ (immer eindeutig, aber nicht stabil). Die Listen dort bei Änderungen in `anonymisieren.sql` mitziehen.

## Sicherheit und Fehlerverhalten

- **Kein `whenever sqlerror exit`.** Jedes Skript ist ein einzelner PL/SQL-Block; ein Fehler bricht nur diesen ab, die SQLcl-Session bleibt offen. Alle Zugriffe auf Schema-Tabellen laufen als dynamisches SQL, damit der Block auch bei falschem Schema kompiliert und der Guard greift.
- **`PROBE`** führt alles aus und prüft, rollt dann zurück.
- **Prüfung am Ende** von `anonymisieren.sql`: Kein Name außerhalb der Fantasie-Listen, Passwort/Telefon leer, Organisationsnamen gesetzt. Schlägt eine Prüfung fehl, wird alles zurückgerollt.
- **Protokoll** mit Zeitstempeln zusätzlich in `anon.log`; der aktuelle Schritt steht während des Laufs in `v$session.action` (`module = 'anonymisieren'`).

### Trigger-Behandlung

- **Vorher:** Ist ein Trigger der betroffenen Tabellen nicht `VALID`, bricht das Skript ab, bevor etwas geändert wird.
- **Abschalten:** nur aktive Trigger; bereits deaktivierte bleiben unberührt und bleiben aus.
- **Reihenfolge am Ende:** erst `COMMIT`/`ROLLBACK`, dann Trigger wieder einschalten – `ALTER TRIGGER` ist DDL und würde offene Änderungen sonst mitcommitten. Auch im Fehlerfall werden die Trigger wieder eingeschaltet.
- **Danach:** ungültige Trigger neu kompilieren, dann prüfen, dass jeder wieder `ENABLED`/`VALID` ist und die Zahl ungültiger Objekte nicht gestiegen ist.
- **`FOLLOWS`/`PRECEDES`:** Ein Trigger mit dieser Klausel hängt vom referenzierten Trigger ab; dessen `ALTER TRIGGER` macht ihn ungültig, obwohl sein Code unverändert ist. Deshalb das Neukompilieren. Betrifft derzeit nur `TR_Z_ISI_USER_TO_INFOR_BIUD` und `TR_Z_PZM_VERTRAGSARTEN_TO_INFOR_BIUD`, nicht die Tabellen der Anonymisierung.
- **Andere Sessions:** Solange die Trigger aus sind, laufen deren Änderungen auf diesen Tabellen ohne Trigger – ein weiterer Grund, nur auf einer allein genutzten Datenbank zu arbeiten.

### `trigger_aus.sql` / `trigger_ein.sql`

- Jeder Lauf von `trigger_aus.sql` schreibt eine **eigene** Datei `trigger_status_<db_name>_<zeitstempel>.sql` ins Arbeitsverzeichnis (in `.gitignore`). Sie ist Protokoll (Kommentarzeilen) und Zustand zugleich: Am Ende steht ein PL/SQL-Block, der Datenbank-Kennung und Triggerliste an Bind-Variablen übergibt – geschrieben erst, nachdem alle Trigger erfolgreich abgeschaltet sind.
- `trigger_aus.sql` bricht ab, wenn kein Trigger aktiv ist (lief vermutlich schon). Scheitert das Abschalten mittendrin, werden die bereits abgeschalteten sofort wieder eingeschaltet.
- `trigger_ein.sql` prüft, dass die Datei zur aktuellen Verbindung gehört, schaltet genau die gemerkten Trigger ein, kompiliert ungültige neu und prüft alle in einer Abfrage. Mehrfacher Aufruf mit derselben Datei ist unkritisch.

## Laufzeit

Auf einer Always-Free-ADB rund 2 Sekunden, überwiegend für DDL (`ALTER TRIGGER`) und Data-Dictionary-Abfragen. Zwei Lehren aus der Optimierung:

- **Kein `regexp_substr(liste, '[^,]+', 1, n)` pro Zeile oder in Schleifen** – es sucht für jedes `n` wieder vom Anfang. Das kostete 16 s im Update und weitere 4 s beim Aufbereiten der Listen.
- **`v$session.event` zeigt auch während CPU-Arbeit das letzte Warte-Ereignis.** Ob eine Session wirklich wartet, steht in `state` (`WAITING`).

## Offene Punkte

- **Datenschutz:** Klären, ob Pseudonymisierung (Personalnummer bleibt) für Entwicklungsdatenbanken ausreicht.
- **Spanne der Personalnummern in der Produktion:** Mit der Zusammenfassung am Ende von `namen_vorschau.sql` prüfen, ob die stabile Zuordnung dort ohne doppelte Namen auskommt (`doppelt_stabil = 0`).
- **Reihenfolge von `STRSPLIT`:** Die Zuordnung setzt voraus, dass `table(strsplit(...))` die Elemente in Listenreihenfolge liefert – praktisch gegeben, von SQL aber nicht zugesichert.
- **Außerhalb des Umfangs dieser Skripte**, aber bei Übertragungen aus der Produktion zu beachten:
  - Sequenzen auf den Stand der Produktion bringen (sonst `ORA-00001` bei neuen Datensätzen)
  - Jobs (`dbms_job`, Scheduler) während und nach der Übertragung
  - Fremdschlüssel und Reihenfolge der Übertragung
  - Konfigurationstabellen (`*_CFG`) und Schnittstellen-Warteschlangen (`ISI_MAIL_QUEUE`, `Z_PZM_STAMMDATEN_TO_INFOR`, `S_ERP_*`, …) nicht übertragen oder danach bereinigen
  - Personendaten in weiteren Tabellen (Stempelzeiten, Abwesenheiten, `ISI_USER`, `ISI_CONTACT`, `ISI_ADRESSEN`)
- **Vorhandene Prozeduren `ISI_DISABLE`/`ISI_ENABLE`:** schalten Trigger, Fremdschlüssel und `dbms_job`-Jobs schemaweit ab bzw. **alle** wieder ein – ohne gemerkten Zustand und mit Abbruch beim ersten Fremdschlüssel-Verstoß.
- **Getestet:** `anonymisieren.sql` im Modus `PROBE` auf der ADB; `trigger_aus.sql`/`trigger_ein.sql` einmal mit `trg_tables = '*'`. Die letzten Änderungen (Neukompilieren ungültiger Trigger, Einschränkung von `trg_tables`) sind noch ungetestet.
