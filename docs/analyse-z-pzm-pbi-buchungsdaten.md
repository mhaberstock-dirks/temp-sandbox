# Analyse: View `Z_PZM_PBI_BUCHUNGSDATEN`

> **Quelle:** [`src/database/dirkspzm32/views/z_pzm_pbi_buchungsdaten.sql`](../src/database/dirkspzm32/views/z_pzm_pbi_buchungsdaten.sql)
> **Stand:** 12.10.2026 – Analyse ausschließlich anhand der View-Definition im Repository und der drei aus Produktion bekannten Zugriffs-Statements. Es wurden noch keine Laufzeiten oder Ausführungspläne gemessen.

## Kernaussage

Der View erfüllt heute seinen Zweck und ist über die Zeit mit den fachlichen Anforderungen gewachsen – das sieht man an den auskommentierten Varianten und an den Sonderregeln für externe Mitarbeiter. Gerade dieses Wachstum hat aber dazu geführt, dass er inzwischen fünf fachlich sehr unterschiedliche Datenarten in einer Struktur bündelt. Daraus ergeben sich drei Themen, die wir uns gemeinsam anschauen sollten:

1. **Datenkorrektheit:** Einige Konstellationen liefern vermutlich nicht das, was die Auswertung erwartet (z. B. werden Statusänderungen bei Abwesenheitsanträgen im Delta-Abzug nicht erkannt).
2. **Performance:** Der Delta-Abzug über `LAST_CHANGE_DATE` kann keinen Index nutzen und liest bei jedem Lauf die gesamte Historie. Die Kosten wachsen damit mit jedem Monat Daten, unabhängig davon, wie viel sich tatsächlich geändert hat.
3. **Wartbarkeit:** Struktur und Spaltenbedeutungen sind ohne genaue Kenntnis des Codes schwer nachzuvollziehen. Dokumentation (Kommentare) existiert bisher nicht.

Die heutige Last ist gering (Delta-Abzug alle 10 Minuten, siehe Abschnitt 3). Kritisch wird die Lage dadurch, dass inzwischen weitere Views auf diesem View aufbauen, die von noch unbekannten Programmen genutzt werden sollen (Abschnitt 3a): Sowohl die fachlichen Eigenheiten als auch die Kosten je Abfrage werden damit unkontrolliert weitergegeben. Je früher wir das adressieren, desto weniger Konsumenten sind von späteren Korrekturen betroffen.

## 0. Abweichung Produktion ↔ Repository

Der View wurde in Produktion geändert, ohne dass die Änderung in die Entwicklungsdatenbank bzw. das Repository übernommen wurde. Einzige inhaltliche Änderung (Zweig ZE):

```sql
-- vorher
and ze.ze_calc_ist_ende > ze.ze_calc_ist_start
-- Produktion
and to_date(to_char(ze.ze_calc_ist_ende, 'dd.mm.yyyy hh24:mi'), 'dd.mm.yyyy hh24:mi') > ze.ze_calc_ist_start
```

Wirkung: Die Sekunden des Endes werden abgeschnitten. Dadurch fallen zusätzlich Buchungen weg, deren Ende in **derselben Minute** wie der Start liegt (z. B. Start 08:00:10, Ende 08:00:50) – also genau die Sätze, die im View als `START_ZEIT = ENDE_ZEIT` erscheinen würden. Vermutlich war das der Zweck. Gleichwertig und lesbarer wäre `trunc(ze.ze_calc_ist_ende, 'MI') > ze.ze_calc_ist_start`. Grund der Änderung beim Autor erfragen und als Kommentar festhalten.

Allgemein zeigt der Fall, dass Analysen auf Basis des Repositorys vom tatsächlichen Produktionsstand abweichen können (vgl. [Konsolidierung nach direkten Änderungen](konsolidierung-nach-direktaenderungen.md)).

## 1. Was der View liefert

Der View verbindet per `UNION` fünf Datenquellen zu einer flachen Buchungstabelle. Die Satzart ist am Präfix der Spalte `LNR` erkennbar:

| Satzart (`LNR`-Präfix) | Quelle | Inhalt | Zeitraum | Personenkreis |
|---|---|---|---|---|
| `ZE` | `PZM_ZEITERFASSUNG` + `PZM_ZE_TAGESSATZ` | Anwesenheitsbuchungen ohne Abwesenheitsart, umgerechnet in Arbeitsstunden | Vergangenheit (bis gestern), ohne Untergrenze | alle |
| `LOA` | `PZM_ZE_LOA_AUSW` | berechnete Lohnarten je Tag | Vergangenheit | intern: alle; extern: nur Mo–Fr, Konto-Lohnarten nur bei vollem Tagessoll |
| `PDL` | `PZM_ZE_LOA_EXP_EXT_GUTSCH` | Überstunden-Gutschriften (`UESTD`/`UESTDPROZ`) | Vergangenheit | nur extern |
| `ABW` | `PZM_ABWESENHEITSMELDUNGEN` | Abwesenheitsmeldungen, verdichtet je Art und Beginn | **laufend/zukünftig** | nur intern |
| `ABW-ANT` | `PZM_ABWESENHEITS_ANTR` | Abwesenheitsanträge in **allen** Status (auch abgelehnt/storniert) | **laufend/zukünftig** | nur intern |

Damit stehen **Ist-Daten** (ZE, LOA, PDL – je Tag) und **Plandaten** (ABW, ABW-ANT – je Zeitraum) in derselben Ergebnismenge.

### Spaltenbeschreibung

| Spalte | Bedeutung | Hinweis |
|---|---|---|
| `BU_ID`, `BU_NAME` | Business Unit des Mandanten | per Outer Join, kann NULL sein |
| `LNR` | technischer Satzschlüssel: Präfix + Pers.-Nr./Lohnart/Abw.-Art + Datum | nicht garantiert eindeutig (siehe 2.6) |
| `DATUM` | ZE: Schichttag · LOA/PDL: Buchungstag · ABW/ABW-ANT: **Beginn** der Abwesenheit | |
| `FIRMA` | extern: Name des Dienstleisters (`PB_BEMERKUNGEN`), sonst PB-ID als Text | |
| `PD_MANDANT` | Mandant laut Personalstamm: `nvl(pers_pb_id, abt_pb_id)` | immer aktueller Stand |
| `MANDANT` | PB-ID der Abteilung | ZE: Abteilung der **Buchung**; sonst **Stammabteilung** |
| `PERSNR`, `NAME`, `VORNAME` | Person | Namen auf 50 Zeichen gekürzt |
| `ABTEILUNG` | Abteilungsname | Herkunft wie `MANDANT` |
| `ART` | ZE/PDL: `'0'` · LOA: Abwesenheitsart-ID · ABW: `'ABW'` · ABW-ANT: `'ABW-ANT'` | Bedeutung abhängig von Satzart |
| `WERT` | Stunden. ZE: anteilige Arbeitsstunden · LOA/PDL: Lohnart-Stunden · ABW/ABW-ANT: Kalendertage × Tagessoll | |
| `KOSTENSTELLE` | ZE/LOA: aus Buchung · sonst aktuelle KST der Person | |
| `STATUS` | ZE/LOA/PDL: **Lohnart** (externe unbezahlt: `1001`) · ABW/ABW-ANT: **Abwesenheitsart-ID** | zwei Wertebereiche in einer Spalte |
| `STATUS_TEXT` | ZE: Diagnosetext · LOA/PDL: Lohnart-Bemerkung · ABW: Name der Abwesenheitsart | |
| `STATUS_TEXT2` | ZE: `'ZE'` · LOA/PDL: Lohnart-Operator bzw. `'UNB'` · ABW/ABW-ANT: Zeitraum + Kurzname/Antragsstatus | |
| `SAP_ZUORDNUNG` | immer NULL | Platzhalter |
| `START_ZEIT`, `ENDE_ZEIT` | nur ZE: Uhrzeit als Text `HH24:MI`, sonst `'00:00'` | |
| `LAST_CHANGE_DATE` | Kriterium für den Delta-Abzug | bei ABW-ANT kein echtes Änderungsdatum (siehe 2.1) |

Berechnung `WERT` bei ZE: `ze_std / ts_day_anw_std × ts_day_arb_std` – die gestempelte Zeit wird anteilig auf die Arbeitszeit des Tages umgerechnet. Bei Externen mit freigegebenen Überstunden wird statt `ts_day_arb_std` die Summe aus Arbeits-, Überstunden- und Flex-Stunden verwendet.

## 2. Fachliche Beobachtungen

Diese Punkte sollten zuerst geklärt werden, da sie ggf. Auswirkungen auf Berichtszahlen haben. Bei einigen davon kann das Verhalten auch bewusst so gewollt sein – dann sollte es dokumentiert werden.

1. **Delta-Abzug erkennt Statusänderungen bei Anträgen nicht.** Für `ABW-ANT` ist `LAST_CHANGE_DATE = nvl(max(au_datum), max(au_ende))`, wobei `AU_DATUM` das Antragsdatum ist. Wird ein Antrag später genehmigt oder storniert, ändert sich dieses Datum nicht – ein inkrementeller Abzug übernimmt den neuen Status nicht.
2. **Stammdatenänderungen erreichen bereits geladene Sätze nicht.** Name, Abteilung, Kostenstelle oder Mandant werden in `LAST_CHANGE_DATE` nicht berücksichtigt; bei PDL/ABW/ABW-ANT werden Kostenstelle und Mandant zudem immer mit dem *aktuellen* Stand ermittelt.
3. **Outer Joins wirken teilweise als Inner Join.** In LOA, ABW und ABW-ANT steht `pb.pb_extern != 'T'` zusammen mit einem `(+)`-Join. Fehlt der Produktionsbereich oder ist `PB_EXTERN` NULL, fällt der Satz stillschweigend weg.
4. **`STATUS` mischt Lohnarten und Abwesenheitsarten.** Eine Abfrage wie `status = '503'` (siehe Statement 2 unten) trifft auch ABW-Sätze, falls eine Abwesenheitsart mit ID 503 existiert.
5. **Abgelehnte und stornierte Anträge sind enthalten** und gehen in Summen ein, sofern der Bericht sie nicht filtert.
6. **`LNR` ist nicht eindeutig.** Bestandteile werden ohne Trennzeichen verkettet (`LOA` + Lohnart `12` + Pers.-Nr. `3456` = `LOA` + `123` + `456`), Reihenfolge der Bestandteile unterscheidet sich zwischen LOA und PDL.
7. **Ausfallrisiken des gesamten Views:**
   - Division durch `ts_day_anw_std` im ZE-Zweig – ist der Wert 0, bricht der komplette View mit ORA-01476 ab.
   - Die Scalar Subquery für die Lohnart `ARBSTD` führt zu ORA-01427, sobald mehr als eine Lohnart diesen Operator trägt.
8. **ABW-Stunden zählen Kalendertage** (inkl. Wochenenden/Feiertage) × Tagessoll.

## 3. Performance

### Allgemeine Ursachen

| Ursache | Wirkung |
|---|---|
| `UNION` statt `UNION ALL` | Das gesamte Ergebnis wird sortiert und dedupliziert, obwohl die Satzarten durch das `LNR`-Präfix ohnehin disjunkt sind. |
| Keine zeitliche Untergrenze (`-61` auskommentiert) | Jeder Zugriff liest die vollständige Historie von Zeiterfassung, Lohnarten-Auswertung und Tagessatz. Laufzeit wächst stetig. |
| PL/SQL-Funktionen je Zeile (`get_pers_pb_id` bis zu 5×, `get_pers_kst_id`, `get_pers_schicht_d_std`, `isi_utils.Iso_WeekDay`) | Kontextwechsel SQL ↔ PL/SQL plus je eine eigene Abfrage pro Aufruf. Die Logik ist größtenteils als einfacher Join abbildbar. |
| Funktion als Join-Bedingung (`pb.pb_id(+) = get_pers_pb_id(p.pers_nr)` in ABW/ABW-ANT) | kein Index nutzbar, Funktion läuft für jede Kandidatenzeile |
| `LAST_CHANGE_DATE` ist ein berechneter Ausdruck | Filter darauf kann keinen Index nutzen (siehe Statement 1) |

### Einschätzung der bekannten Zugriffe aus Produktion

**Statement 1 – Delta-Abzug** (`SELECT 'BUCHUNGSDATEN', … WHERE LAST_CHANGE_DATE >= :1`)
**Einschätzung:** Delta-Filter wird in die Zweige geschoben, kann aber mangels Index die großen Tabellen nicht eingrenzen.
**Gemessen (Prod):** 1 Ausführung je 10 Minuten, 0–500 Zeilen, ca. 30.000–100.000 Buffer Gets je Ausführung. Die *aktuelle* Last ist damit unkritisch.

**Ausführungsplan (Prod, Gesamtkosten 10.623):**

| Zweig | Plan-IDs | Zugriff | Kosten | Bewertung |
|---|---|---|---|---|
| ZE | 11–17 | Full Scan `PZM_ZE_TAGESSATZ` + Full Scan `PZM_ZEITERFASSUNG`, Delta-Filter erst **am Hash Join** (ID 14) | 5.266 (≈ 50 %) | Der Filter vergleicht Spalten aus zwei Tabellen (`CASE` über ZE- und TS-Änderungsdatum) und kann deshalb vor dem Join keine Zeilen aussortieren. Beide Tabellen werden über die gesamte Historie gelesen. |
| LOA | 18–32 | Full Scan `PZM_ZE_TAGESSATZ` (Delta-Filter dort, ID 31) + Full Scan `PZM_ZE_LOA_AUSW` (~391.000 Zeilen) | 3.001 (≈ 28 %) | Filter wird korrekt auf den Tagessatz geschoben, mangels Index aber per Full Scan. `PZM_ZE_TAGESSATZ` wird damit im selben Statement **zweimal komplett** gelesen. |
| PDL | 33–47 | Index-Range-Scan über **Lohnart** (~24.500 ROWIDs), danach Tabellenzugriff je Zeile und erst dann Delta-Filter (ID 46) | 368 | Der Index passt nicht zum Filter; je ROWID ein Blockzugriff → potenziell bis zu ~24.000 Gets für wenige Treffer. |
| ABW / ABW-ANT | 48–77 | kleine Mengen (`ende > heute`), Delta-Filter nach `GROUP BY` | 185 | unkritisch; `GET_PERS_PB_ID` als Join-Bedingung (ID 57, 73) bestätigt, wirkt hier aber nur auf wenige Zeilen |
| gesamt | 2 | `SORT UNIQUE` (6 MB Temp, geschätzt) | – | entfällt mit `UNION ALL` |

Gegenüber der ersten Einschätzung ist zu korrigieren: Oracle schiebt den Delta-Filter durchaus in die einzelnen Zweige (Predicate Pushdown). Mangels passender Indizes führt das aber trotzdem zu Full Scans der großen Tabellen; rund 80 % der Kosten entfallen auf vier Full Scans (2× Tagessatz, Zeiterfassung, Lohnarten-Auswertung). Die Funktionen in der SELECT-Liste laufen dagegen nur für die tatsächlich gelieferten 0–500 Zeilen – das ist der Grund, warum Statement 1 vergleichsweise günstig ist.

Weitere Beobachtungen aus dem Plan:
- `GET_PERS_SCHICHT_D_STD` und `ISI_UTILS.ISO_WEEKDAY` werden als Filter im LOA-Join je Kandidatenzeile ausgewertet (ID 24).
- Die Prädikate `ABT_ID <> -1` / `PB_ID <> -1` stammen aus Check-Constraints auf `PZM_PERSONAL` und sind unproblematisch.
- ID 16 zeigt für die Bedingung „Ende nach Start“ eine Konvertierung `TO_DATE(TO_CHAR(ZE_CALC_IST_ENDE, 'dd.mm.yyyy hh24:mi'))`. Ursache: Der View wurde **direkt in Produktion geändert** (siehe Abschnitt 0); dort lautet die Bedingung `to_date(to_char(ze.ze_calc_ist_ende, 'dd.mm.yyyy hh24:mi'), 'dd.mm.yyyy hh24:mi') > ze.ze_calc_ist_start`. Performance-relevant ist das nicht (die Tabelle wird ohnehin per Full Scan gelesen).

**Konkrete Maßnahmen für Statement 1:**
1. Function-based Indizes auf `nvl(last_change_date, created_date)` für `PZM_ZE_TAGESSATZ` und `PZM_ZE_LOA_EXP_EXT_GUTSCH` – damit werden LOA- und PDL-Zweig indexgestützt.
2. ZE-Zweig: `max(a, b) >= :1` ist gleichbedeutend mit `a >= :1 OR b >= :1`. Ließe sich der Zweig entsprechend aufteilen (bzw. ist fachlich sichergestellt, dass jede ZE-Änderung den Tagessatz aktualisiert), könnte auch hier ein Index greifen. Innerhalb eines Views ist das nur über Umbau oder Staging-Tabelle sauber lösbar.
3. Zeitliche Untergrenze auf `ze_schicht_tag` / `zeaw_datum` (Index `IX_ZE_SCHICHT_TAG` bzw. `IX_ZEAW_DATUM` vorhanden).
4. `UNION ALL`.

Für belastbare Zahlen je Planschritt: Statement einmal mit `/*+ gather_plan_statistics */` ausführen und `dbms_xplan.display_cursor(sql_id, null, 'ALLSTATS LAST')` auswerten (tatsächliche Zeilen und Buffer Gets je Schritt).
**Gemessen (Prod):** 1 Ausführung je 10 Minuten, 0–500 Zeilen, ca. 30.000–100.000 Buffer Gets je Ausführung. Die *aktuelle* Last ist damit unkritisch. Bemerkenswert ist das Verhältnis: Für wenige hundert Zeilen werden zehntausende Blöcke gelesen. Das ist ein Richtwert dafür, was jede Abfrage auf den View mindestens kostet, unabhängig davon, wie selektiv sie ist (per Ausführungsplan zu bestätigen).

**Statement 2** (`mandant in (651, 652) and status = '503'`)
**Einschätzung: mittel.** `MANDANT` ist eine einfache Spalte und kann in alle Zweige geschoben werden. Im ZE-Zweig erfolgt der Zugriff jedoch über `ZE_ABT_ID`, wofür im Repository kein Index existiert – vermutlich Full Scan über die Zeiterfassung. `STATUS` ist je Zweig ein Ausdruck und nur als Nachfilter auswertbar.

**Statement 3** (`bu_id = 2`, `art = '0'`, `lnr not like 'ABW%'`, `persnr >= 10000`)
**Einschätzung: mittel bis hoch.** Positiv: Über `art = '0'` kann der Optimizer die Zweige ABW/ABW-ANT (dort ist `ART` eine Konstante) vollständig eliminieren. Da der Datumsfilter auskommentiert ist, wird im ZE-Zweig jedoch die volle Historie gelesen. Mit aktivem Datumsfilter würde der vorhandene Index `IX_ZE_SCHICHT_TAG` greifen.

Statements 2 und 3 wären als gelegentliche Ad-hoc-Abfragen vertretbar. Sie wurden inzwischen jedoch als eigene Views angelegt – siehe Abschnitt 3a.

## 3a. Neues Risiko: abgeleitete Views mit unbekannten Konsumenten

Die Statements 2 und 3 existieren inzwischen als Views auf `Z_PZM_PBI_BUCHUNGSDATEN`: [`Z_PZM_POLEN`](../src/database/dirkspzm32/views/z_pzm_polen.sql) (Statement 2) und [`Z_PZM_BU_DIS`](../src/database/dirkspzm32/views/z_pzm_bu_dis.sql) (Statement 3). Sie sollen künftig von noch nicht bekannten Programmen mit noch nicht bekannten Filtern in noch nicht bekannter Häufigkeit abgefragt werden. Damit verschiebt sich das Thema von „aktuelle Last“ zu „unkontrollierte Weiterverwendung“:

**Qualität der Auswertungen**
- Alle in Abschnitt 2 beschriebenen Eigenheiten werden an jeden neuen Konsumenten **weitervererbt** – ohne dass dieser sie kennt, da es weder Kommentare noch eine Dokumentation gibt. Beispiele:
  - `status = '503'` in Statement 2 trifft ggf. auch Abwesenheitssätze (Punkt 2.4).
  - Abgelehnte und stornierte Anträge sowie Kalendertage-Stunden gehen in Summen ein (2.5, 2.8).
  - `substr(persnr, 1, 3) pers_nr` in Statement 3 liefert unter dem Namen „pers_nr“ nur die ersten drei Ziffern der Personalnummer.
- Jede künftige Änderung am Basis-View ändert **stillschweigend** die Ergebnisse aller abgeleiteten Views und aller Programme dahinter. Ohne bekannte Konsumenten lässt sich die Auswirkung einer Änderung nicht mehr abschätzen – damit wird auch jede Korrektur der Punkte aus Abschnitt 2 riskanter, je länger wir warten.

**Konkrete Beobachtungen an den beiden Views**

`Z_PZM_BU_DIS`
- `art = '0'` liefert nicht nur Anwesenheiten (ZE), sondern auch **alle Lohnarten-Sätze (LOA, ohne Abwesenheitsbezug) und PDL-Sätze**. Diese haben immer `START_ZEIT`/`ENDE_ZEIT = '00:00'`. Da `WERT` und `STATUS` nicht ausgegeben werden, erscheinen sie als **inhaltlich identische Zeilen** (je Lohnart eine) mit 00:00–00:00 neben den echten Kommt/Geht-Zeiten. Vermutlich gewollt ist nur ZE.
- `lnr not like 'ABW%'` ist durch `art = '0'` bereits abgedeckt.
- `PERS_NR` enthält nur die **ersten drei Ziffern** der Personalnummer (`substr(persnr, 1, 3)`); Spaltenname und Inhalt passen nicht zusammen. Falls das eine Pseudonymisierung sein soll, ist sie weder eindeutig noch dokumentiert – das sollte geklärt werden.
- `bu_id = 2` ist ein fest codierter Wert ohne Erläuterung.
- Datumseingrenzung ist auskommentiert → jede Abfrage liest die gesamte Historie.

`Z_PZM_POLEN`
- `status = '503'` setzt voraus, dass 503 eine Lohnart ist; für ABW-Sätze ist `STATUS` die Abwesenheitsart-ID (Punkt 2.4). Ob 503 der Lohnart `ARBSTD` entspricht (dann ZE-Zeilen + LOA-Zeilen dieser Lohnart), ist zu klären.
- `MANDANT in (651, 652)` bedeutet für ZE die Abteilung der **Buchung**, für alle anderen Satzarten die **Stammabteilung** der Person.
- `KOMMT` wird aus `DATUM` (Schichttag) + `START_ZEIT` (Text) zusammengesetzt. Bei Schichten, die am Vortag des Schichttags beginnen (Nachtschicht), ergibt das ein falsches Datum; bei Nicht-ZE-Sätzen Mitternacht. Die exakte Uhrzeit (`ZE_IST_START`) ist in der Quelle vorhanden, geht im Basis-View aber verloren. Ein `GEHT` fehlt.
- Gibt alle Spalten inkl. Namen aus – bei unbekannten Konsumenten ist zu klären, wer diese personenbezogenen Daten erhält.

Beide Views
- `ORDER BY` im View: wird bei jeder Abfrage ausgeführt, auch wenn der Aufrufer anders sortiert oder nur zählt.
- Die Filterwerte (`2`, `651/652`, `503`) machen die Views zu **Spezialauswertungen für einen Standort bzw. eine Business Unit**; Namen und Zweck sollten das widerspiegeln und kommentiert sein.

**Last**
- Statement 1 ist der **günstige** Fall: Der Delta-Filter reduziert die Zeilen, bevor die PL/SQL-Funktionen der SELECT-Liste (`GET_PERS_PB_ID` bis zu 5×, `GET_PERS_KST_ID`, `GET_PERS_SCHICHT_D_STD` – jede mit eigener Abfrage) ausgeführt werden. Die abgeleiteten Views haben keinen solchen Filter: Dieselben Full Scans fallen an, **und** die Funktionen laufen für jede Ergebniszeile über die gesamte Historie (zehn- bis hunderttausende Zeilen). Je Abfrage ist daher ein Vielfaches der 30.000–100.000 Gets des Delta-Abzugs zu erwarten. Zusätzlich fällt je Abfrage das `ORDER BY` an.
- Die Kosten **skalieren nicht mit dem Ergebnis, sondern mit der Historie** (keine zeitliche Untergrenze) und **multiplizieren sich mit der unbekannten Abfragehäufigkeit**. Ein Programm, das z. B. jede Minute pollt, oder ein Dashboard mit mehreren Kacheln je Seitenaufruf, erzeugt schnell ein Vielfaches der heutigen Last.
- Filter der neuen Konsumenten auf berechnete Spalten (`STATUS`, `ART`, `LAST_CHANGE_DATE`, `KOSTENSTELLE`, `FIRMA`) sind nicht indexierbar; eine Index-Strategie kann es ohne Kenntnis der Filter nicht geben.

**Empfehlung – bevor die abgeleiteten Views in Gebrauch kommen**
1. Abgeleitete Views ins Repository aufnehmen und kommentieren; Zweck und Konsumenten je View festhalten.
2. Zugriff nur per expliziter Berechtigung je Konsument (eigener DB-User bzw. gesetztes `MODULE`), damit Aufrufer und Häufigkeit über `v$sql`/`v$session` nachvollziehbar bleiben.
3. In den abgeleiteten Views eine **zeitliche Untergrenze** und den Filter auf die benötigte **Satzart** fest einbauen, `ORDER BY` entfernen (Sortierung ist Sache des Aufrufers).
4. Mittelfristig abgeleitete Views nicht auf den Gesamt-View, sondern auf die Teil-Views bzw. eine Staging-Tabelle setzen (Abschnitt 4).
5. Regelmäßige Überwachung der Gets/Ausführungen je View (Abfrage aus Abschnitt 3), mit vereinbartem Schwellwert.

### Empfohlene Messung vor jeder Entscheidung

Die obigen Aussagen sind Einschätzungen. Um sie mit echten Zahlen zu belegen (und um herauszufinden, welche Anwendung Statement 1 ausführt), bietet sich folgende Abfrage in Produktion an:

```sql
select s.sql_id, s.module, s.action, s.parsing_schema_name, s.executions,
       round(s.elapsed_time/1e6/nullif(s.executions,0),1) sek_pro_ausf,
       s.buffer_gets/nullif(s.executions,0) gets_pro_ausf,
       s.last_active_time, substr(s.sql_text,1,120) sql_text
  from v$sql s
 where upper(s.sql_text) like '%Z_PZM_PBI_BUCHUNGSDATEN%'
   and s.sql_text not like '%v$sql%';
```

Ergänzend: Ausführungsplan von Statement 1 (`dbms_xplan.display_cursor(sql_id)`). Für die Entwicklung über die Zeit (ohne AWR-Lizenz) nutzen wir **Statspack**:
- `stats$sql_summary` enthält je Snapshot die SQL-Statistiken (u. a. `executions`, `buffer_gets`, `elapsed_time`) – darüber lässt sich der Verlauf je `sql_id` für Statement 1 und für Abfragen auf `Z_PZM_POLEN`/`Z_PZM_BU_DIS` verfolgen (Voraussetzung: Snapshot-Level ≥ 5 und das Statement überschreitet die SQL-Schwellwerte).
- Mit `@?/rdbms/admin/sprepsql` gibt es einen Bericht je Statement inkl. gespeicherter Ausführungspläne (Level ≥ 6), womit sich Planwechsel erkennen lassen.
- Einschränkung gegenüber AWR: keine Session-Historie (wer hat abgefragt), Erfassung nur oberhalb der Schwellwerte. Für die Frage nach dem Konsumenten bleiben daher `v$session` bzw. Unified Auditing.

## 4. Verbesserungsvorschläge

### Schnelle, risikoarme Maßnahmen (Ergebnis unverändert)

1. `UNION` → `UNION ALL` (vorher prüfen, ob innerhalb eines Zweigs exakte Duplikate vorkommen, die bisher entfernt wurden).
2. Funktionsaufrufe durch Joins ersetzen, z. B. `PD_MANDANT = nvl(p.pers_pb_id, a.abt_pb_id)`, Kostenstelle analog `get_pers_kst_id`. Wo nicht möglich: `(select f(...) from dual)` zur Nutzung des Scalar-Subquery-Cachings.
3. `isi_utils.Iso_WeekDay(d) < 6` durch `d - trunc(d, 'IW') < 5` ersetzen.
4. Kommentare für View und Spalten anlegen (Entwurf im Anhang).

### Strukturelle Maßnahmen (Lesbarkeit)

1. ANSI-Joins statt `(+)`-Syntax – macht Punkt 2.3 sofort sichtbar.
2. **Ein Teil-View je Satzart** (`…_ZE`, `…_LOA`, `…_PDL`, `…_ABW`, `…_ABW_ANT`), `Z_PZM_PBI_BUCHUNGSDATEN` als dünner `UNION ALL` darüber. Für bestehende Konsumenten ändert sich nichts, jeder Teil ist einzeln test- und dokumentierbar.
   *Hinweis:* Das allein bringt **keinen** Performancegewinn, da Oracle verschachtelte Views beim Parsen auflöst. Einen Gewinn gibt es erst, wenn Abfragen direkt den passenden Teil-View nutzen.
3. Gemeinsame Personen-/Organisationsbasis (Person → Abteilung → Produktionsbereich → Business Unit) einmal zentral definieren statt fünfmal.
4. Neue Spalte `SATZART` statt Filterung über `LNR`-Präfix; `LNR` mit Trennzeichen bilden.
5. Auskommentierten Code und Diagnose-Texte entfernen, Sonderwerte (`1001`, `F`/`SF`/`K`, `UESTD%`) benennen bzw. kommentieren.

### Mittelfristig (Performance des Delta-Abzugs)

- Zeitliche Untergrenze fachlich klären und ggf. wieder aktivieren.
- Staging-Tabelle oder Materialized View, die per DB-Job inkrementell befüllt wird und eine echte, indexierte Änderungsspalte besitzt. Der Delta-Abzug liest dann nur noch geänderte Sätze.

### Zielbild für Auswertungen (z. B. Power BI)

Für ein Auswertungswerkzeug wie Power BI wäre ein Sternschema besser geeignet als eine flache Gesamttabelle:

- **Faktentabellen** mit einheitlicher Granularität: Ist-Stunden je Person/Tag (ZE + LOA + PDL), geplante Abwesenheiten je Zeitraum (ABW), Abwesenheitsanträge mit Status (ABW-ANT).
- **Dimensionen:** Person, Abteilung/Mandant, Business Unit, Kostenstelle, Lohnart, Abwesenheitsart, Kalender.

Das verhindert versehentliches Aufsummieren von Ist- und Plandaten, Stammdatenänderungen wirken automatisch, und jede Faktentabelle kann ein eigenes, indexierbares Delta-Kriterium haben. Der bestehende View kann als Kompatibilitätsschicht erhalten bleiben, bis alle Konsumenten umgestellt sind.

*Stand der Klärung:* In Produktion existiert ein DB-User `POWERBI` mit SELECT-Recht auf den View. Die regelmäßigen Abfragen kommen jedoch vom Modul **„JDBC Thin Client“**, nicht von der Power-BI-Mashup-Engine (die Oracle über .NET/ODP.NET anspricht). Zusammen mit dem Literal `'BUCHUNGSDATEN'` in Statement 1 spricht das für einen **zwischengeschalteten Java-basierten Ladeprozess** (ETL), der die Daten in ein Zielsystem schreibt, aus dem Power BI liest. Wer dieser Ladeprozess ist und welche Struktur er erwartet, sollte vor jeder Umstellung geklärt werden. Hinweise liefern Rechner und Programm der Sitzungen. Da kein Diagnostics Pack lizenziert ist (keine ASH/AWR; Statspack liefert keine Session-Informationen), bieten sich lizenzfreie Wege an:

1. **`v$session`** – JDBC-Anwendungen halten meist einen Connection-Pool offen, die Sitzung ist dann jederzeit sichtbar:
   ```sql
   select username, osuser, machine, program, module, client_identifier, logon_time, status
     from v$session
    where username = 'POWERBI' or program like '%JDBC%' or module like '%JDBC%';
   ```
2. **Unified Auditing** (im Lieferumfang enthalten) – protokolliert jeden Zugriff auf den View mit Rechner und Programm; bei 1 Abfrage je 10 Minuten ist das Volumen gering:
   ```sql
   create audit policy pbi_buchungsdaten_sel actions select on DIRKSPZM32.Z_PZM_PBI_BUCHUNGSDATEN;
   audit policy pbi_buchungsdaten_sel;
   -- Auswertung
   select event_timestamp, dbusername, os_username, userhost, client_program_name
     from unified_audit_trail
    where unified_audit_policies like '%PBI_BUCHUNGSDATEN_SEL%'
    order by event_timestamp desc;
   -- danach wieder entfernen
   noaudit policy pbi_buchungsdaten_sel;
   drop audit policy pbi_buchungsdaten_sel;
   ```
   Dieselbe Policy für `Z_PZM_POLEN` und `Z_PZM_BU_DIS` würde auch deren künftige Konsumenten sichtbar machen.
3. **Listener-Log** – enthält bei jedem Verbindungsaufbau Host und Programm des Clients (sofern der Pool nicht dauerhaft verbunden bleibt).

## 5. Vorgeschlagenes Vorgehen

1. **Vorrangig:** Abgeleitete Views absichern, bevor weitere Konsumenten angebunden werden (Empfehlungen in Abschnitt 3a).
1. Statements 2 und 3 (bzw. die daraus erzeugten Views) einmal mit `gather_plan_statistics` ausführen, um die tatsächlichen Kosten je Abfrage zu belegen.
2. Fachliche Klärung der Punkte 2.1, 2.3 und 2.5 mit den Berichtsverantwortlichen – gewolltes Verhalten dokumentieren, ungewolltes korrigieren.
3. Risikoarme Maßnahmen umsetzen und Ergebnisgleichheit gegen den bisherigen View prüfen (`MINUS` in beide Richtungen).
4. Aufteilung in Teil-Views, danach Entscheidung über Staging/Materialized View und Zielbild.

## Anhang: Entwurf Kommentare

```sql
comment on table Z_PZM_PBI_BUCHUNGSDATEN is 'Auswertungs-Schnittstelle: Buchungsdaten je Person als Union aus 5 Satzarten (Präfix in LNR): ZE = Anwesenheit (Arbeitsstunden, Vergangenheit), LOA = Lohnarten aus PZM_ZE_LOA_AUSW (Vergangenheit), PDL = Überstunden-Gutschriften externer MA (Vergangenheit), ABW = laufende/zukünftige Abwesenheitsmeldungen (nur interne MA), ABW-ANT = laufende/zukünftige Abwesenheitsanträge aller Status (nur interne MA). Delta-Ladung über LAST_CHANGE_DATE.';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."BU_ID" is 'Business-Unit-ID des Mandanten (PZM_PROD_BUSINESS_UNITS_BEREICHE), NULL wenn nicht zugeordnet';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."BU_NAME" is 'Name der Business Unit';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."LNR" is 'Technischer Satzschlüssel: Präfix (ZE/LOA/PDL/ABW/ABW-ANT) + Personalnr./Lohnart bzw. Abwesenheitsart + Datum (ZE zusätzlich Startzeit). Nicht garantiert eindeutig.';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."DATUM" is 'ZE: Schichttag; LOA/PDL: Buchungstag; ABW/ABW-ANT: Beginn der Abwesenheit';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."FIRMA" is 'Bei externen MA Name des Dienstleisters (PB_BEMERKUNGEN), sonst Produktionsbereichs-ID als Text';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."PD_MANDANT" is 'Mandant (PB-ID) laut Personalstamm: nvl(PERS_PB_ID, ABT_PB_ID), aktueller Stand';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."MANDANT" is 'Mandant (PB-ID) der Abteilung; ZE: Abteilung der Buchung, übrige Satzarten: Stammabteilung der Person';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."PERSNR" is 'Personalnummer';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."NAME" is 'Nachname (max. 50 Zeichen)';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."VORNAME" is 'Vorname (max. 50 Zeichen)';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."ABTEILUNG" is 'Abteilungsname (max. 50 Zeichen), Herkunft wie MANDANT';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."ART" is 'ZE/PDL: ''0''; LOA: Abwesenheitsart-ID, aus der die Lohnart entstand (0 = keine); ABW: ''ABW''; ABW-ANT: ''ABW-ANT''';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."WERT" is 'Stunden. ZE: anteilige Arbeitsstunden (bei Externen mit freigegebenen Überstunden inkl. Überstunden/Flex); LOA/PDL: Lohnart-Stunden; ABW/ABW-ANT: Kalendertage x Tagessoll';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."KOSTENSTELLE" is 'Kostenstellen-ID; ZE/LOA: aus der Buchung, PDL/ABW/ABW-ANT: aktuelle Kostenstelle der Person';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."STATUS" is 'ZE/LOA/PDL: Lohnart (ZE: Lohnart mit Operator ARBSTD; Externe unbezahlt: 1001); ABW/ABW-ANT: Abwesenheitsart-ID';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."STATUS_TEXT" is 'ZE: Diagnosetext Anwesenheit/Arbeitszeit/Pause; LOA/PDL: Lohnart-Bemerkung; ABW/ABW-ANT: Name der Abwesenheitsart (+ Antragsbemerkung)';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."STATUS_TEXT2" is 'ZE: ''ZE''; LOA/PDL: Lohnart-Operator bzw. ''UNB'' (unbezahlt); ABW: Zeitraum + Kurzname; ABW-ANT: Zeitraum + Antragsstatus (beantragt/genehmigt/abgelehnt/storniert)';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."SAP_ZUORDNUNG" is 'Nicht belegt (immer NULL), Platzhalter';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."START_ZEIT" is 'Nur ZE: Beginn (Ist, ersatzweise berechnet) als HH24:MI, sonst ''00:00''';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."ENDE_ZEIT" is 'Nur ZE: Ende (Ist, ersatzweise berechnet) als HH24:MI, sonst ''00:00''';
comment on column Z_PZM_PBI_BUCHUNGSDATEN."LAST_CHANGE_DATE" is 'Kriterium für die Delta-Ladung (jüngste Änderung an Buchung/Tagessatz bzw. Meldung); ABW-ANT: nur Antragsdatum, Statusänderungen nicht erfasst';
```
