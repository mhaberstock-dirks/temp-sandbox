# Konsolidierung nach direkten Änderungen an der Haupt-Entwicklungsdatenbank

> **Zugehörige Dokumente:** [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md) (normaler Ablauf, hierher verlinkt für den Ausnahmefall) · [Entscheidungsvorlage: SQLcl `project`-Tooling](entscheidungsvorlage-sqlcl-project-tooling.md) (nutzt Befunde aus diesem Dokument als Belege im Anhang)

Dies ist die Ausnahmebehandlung für einen Regelverstoß gegen das [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md): jemand hat die Haupt-Entwicklungsdatenbank direkt geändert, unter Umgehung von Git. Für den normalen Ablauf siehe dort – dieses Dokument ist **kein Teil des normalen Ablaufs** und im Idealfall nach vollständiger Einführung des Modells nicht mehr nötig.

Dadurch spiegelt `main` nicht mehr den tatsächlichen Stand der Haupt-Entwicklungsdatenbank wider. Dieser Prozess holt die Differenz nach Git zurück.

**Wichtiger Befund vorab** (siehe [Grundsatzfrage](#grundsatzfrage-lohnen-sich-individuelle-entwicklungsdatenbanken-noch) am Ende): Bei einem einzigen Durchlauf dieses Prozesses waren von 239 zunächst abweichenden Dateien am Ende nur 5 echte, relevante Änderungen übrig – der Rest war Rauschen, das sich mutmaßlich aus unterschiedlichen Oracle-Datenbank-Versionen zwischen den Umgebungen ergibt. Plane entsprechend Zeit für die Kuration ein.

Die Kurations-Technik in Schritt 3 unten ist nicht nur für diesen Ausnahmefall relevant – sie wird auch bei Schritt a) im normalen Ablauf (individuelle Entwicklungsdatenbank mit `main` synchron halten) gebraucht, da dort dasselbe Rauschen auftritt.

## Voraussetzungen (einmalig prüfen, nicht bei jedem Lauf)

- **SQLcl-Version stimmt mit `.dbtools/project.config.json` (`sqlcl.version`) überein.** Ein Versions-Unterschied erzeugt massenhaft Diffs, die keine echten Änderungen sind (unterschiedliche DDL-/SXML-Serialisierung derselben Objekte).
- **Encoding korrekt konfiguriert**, je nachdem wie du `project export` ausführst:
  - Über die VS-Code-Extension: `JAVA_TOOL_OPTIONS` muss `-Dfile.encoding=UTF-8` (mindestens) enthalten, als *Windows-Umgebungsvariable* (User-Scope) gesetzt, und VS Code muss danach komplett neu gestartet worden sein (nicht nur "Reload Window").
  - Prüfen lässt sich das indirekt: exportiere ein Objekt mit bekannten Umlauten im Kommentar und schau, ob sie korrekt aussehen.
- **`NLS_SORT` der Export-Session ist `GERMAN`** (entspricht dem Stand der bisher committeten Dateien). SQLcl gibt Spaltenkommentare in der Sortierreihenfolge der Session aus – bei abweichendem `NLS_SORT` ändert sich die Reihenfolge in praktisch allen Dateien unter `comments/`, ohne inhaltliche Änderung (siehe [Ursache C](#ursache-c-nls_sort-der-export-session-konfiguration-behebbar)). Prüfen in der Session vor dem Export:

  ```sql
  select parameter, value from nls_session_parameters where parameter in ('NLS_LANGUAGE','NLS_SORT');
  alter session set nls_sort = GERMAN;  -- falls abweichend
  ```

## Ablauf

### 1. Sync-Branch anlegen

```powershell
git checkout main
git pull GitHub-Origin main
git checkout -b sync/maindb-<datum>
```

Grund für den eigenen Branch statt direkt auf `main` zu arbeiten: `main` ist protected (siehe `.dbtools/project.config.json` → `git.protectedBranches`), und ein Wegwerf-Branch lässt sich bei Bedarf einfach verwerfen, ohne dass ein unsauberer Zwischenstand je auf `main` sichtbar wird.

### 2. Export gegen die Haupt-Entwicklungsdatenbank

Über die VS-Code-Extension `project export` gegen die Haupt-Entwicklungsdatenbank ausführen. Der Schema-Scope kommt aus `.dbtools/project.config.json` (`schemas: ["DIRKSPZM32"]`) – unabhängig davon, mit welchem DB-User du verbunden bist.

### 3. Diff kuratieren – nicht blind übernehmen

Für jede als geändert markierte Datei prüfen, **welche** der folgenden Kategorien zutrifft:

| Diff-Inhalt | Bedeutung | Aktion |
|---|---|---|
| Nur die `-- sqlcl_snapshot`-Hash-Zeile ändert sich, der Code darüber ist identisch | Recompile-Kaskade (z. B. weil ein zentrales Package wie `PZM_P_LC` geändert wurde und Oracle abhängige Objekte automatisch neu kompiliert hat) – keine echte Änderung | Verwerfen |
| Alter Hash ist ein leerer String (`"hash":""`) | Objekt wurde committet, bevor es je über sqlcl exportiert/kompiliert wurde (z. B. ein reiner Code-Entwurf) – der neue, echte Hash ersetzt nur den Platzhalter | Verwerfen, sofern der Code selbst (ohne die letzte Zeile) identisch ist |
| Nur Zeilenenden-Warnung ("CRLF will be replaced by LF"), `git diff` zeigt sonst nichts | Reines CRLF/LF-Rauschen, wird von `.gitattributes` beim nächsten `git add` ohnehin normalisiert | Verwerfen |
| `git diff -w <datei>` zeigt nach Ausblenden der Hash-Zeile keinen Unterschied mehr | Reine Whitespace-Änderung (z. B. Trailing Spaces auf sonst leeren Zeilen) – ändert trotzdem den Hash, weil der wohl über den literalen Text berechnet wird | Verwerfen |
| Bei Tabellen/Views/Indizes: der `sxml`-Block im `sqlcl_snapshot`-Kommentar ist identisch, nur der sichtbare DDL-Text unterscheidet sich | Reine Darstellungs-Differenz (z. B. PK-Index einmal implizit `USING INDEX ENABLE`, einmal explizit als eigene `CREATE UNIQUE INDEX`-Anweisung ausgegliedert) – die zugrundeliegende Objektstruktur ist laut SQLcls eigener strukturierter Beschreibung identisch | Verwerfen (siehe Abschnitt [Warum so viel Rauschen entsteht](#warum-so-viel-rauschen-entsteht)) |
| Bei `comments/`-Dateien: dieselben `comment on`-Anweisungen, nur in anderer Reihenfolge (Hash ändert sich trotzdem) | Abweichendes `NLS_SORT` der Export-Session (z. B. `BINARY` statt `GERMAN`: `PERSONALTEILBER` vor `PERS_NR` statt umgekehrt) – keine echte Änderung | Verwerfen (siehe [Ursache C](#ursache-c-nls_sort-der-export-session-konfiguration-behebbar)) |
| Hash identisch, `git diff` zeigt nur `\ No newline at end of file` an der Hash-Zeile | Die committete Fassung hat einen Zeilenumbruch nach der Hash-Zeile, den SQLcl nicht schreibt – typischerweise beim Speichern im Editor entstanden, z. B. bei der Auflösung eines Merge-Konflikts | Verwerfen oder einmalig committen (siehe [Ursache D](#ursache-d-editor-änderungen-an-export-dateien-z-b-bei-merge-konflikten-prozess-behebbar)) |
| `git status` meldet die Datei als geändert, `git diff` ist leer; `git ls-files --eol` zeigt `w/mixed` | Gemischte Zeilenenden im Working Tree (Quelltext aus der DB mit CRLF, von SQLcl erzeugte Zeilen mit LF) – wird durch `.gitattributes` (`eol=lf`) normalisiert | Verwerfen, oder `git add` – danach verschwindet die Datei aus dem Status |
| Echter Code-/Struktur-Unterschied | Tatsächliche, bisher nicht in Git erfasste Änderung – von einem Kollegen, oder eigene, noch nicht committete Arbeit | Behalten – prüfen, wem die Änderung zuzuordnen ist und in welchen Branch sie gehört (siehe Schritt 3b) |

#### Praktische Umsetzung bei vielen Dateien

Bei zweistelliger bis dreistelliger Dateizahl lohnt sich, die Rauschen-Kategorien automatisiert zu prüfen, bevor man einzelne Dateien von Hand ansieht. Schleife 1 erfasst dabei auch die Kategorien "Zeilenumbruch am Dateiende" und "gemischte Zeilenenden", da der Hash dort identisch bleibt:

```bash
# 1. Hash-Vergleich: identischer Hash zwischen Working Tree und HEAD → verwerfen
for f in $(git status --short | awk '/^ M/ {print $2}'); do
  new_hash=$(grep -o '"hash":"[a-f0-9]*"' "$f" | head -1)
  old_hash=$(git show "HEAD:$f" 2>/dev/null | grep -o '"hash":"[a-f0-9]*"' | head -1)
  if [ -n "$new_hash" ] && [ "$new_hash" = "$old_hash" ]; then
    git checkout -- "$f"
  fi
done

# 2. SXML-Vergleich (für tables/views/indexes): identischer sxml-Block → verwerfen
for f in $(git status --short | awk '/^ M/ {print $2}'); do
  new_sxml=$(grep -o '"sxml":"[^"]*\(\\.[^"]*\)*"' "$f" | head -1)
  old_sxml=$(git show "HEAD:$f" 2>/dev/null | grep -o '"sxml":"[^"]*\(\\.[^"]*\)*"' | head -1)
  if [ -n "$new_sxml" ] && [ "$new_sxml" = "$old_sxml" ]; then
    git checkout -- "$f"
  fi
done

# 3. Reine Whitespace-Differenz (Vorsicht: git diff -w allein reicht nicht, siehe Hinweis unten)
for f in $(git status --short | awk '/^ M/ {print $2}'); do
  # nur "sicher whitespace-only", wenn git diff -w NICHTS außer der Hash-Zeile zeigt
  rest=$(git diff -w -- "$f" | grep -v "sqlcl_snapshot\|^index \|^---\|^+++\|^diff --git\|^@@\|No newline")
  if [ -z "$rest" ]; then
    git checkout -- "$f"
  fi
done

# 4. Reine Reihenfolge-Differenz (v. a. comments/): zeilenweise sortiert identisch → verwerfen
for f in $(git status --short | awk '/^ M/ {print $2}'); do
  old=$(git show "HEAD:$f" 2>/dev/null | grep -v sqlcl_snapshot | tr -d '\r' | LC_ALL=C sort)
  new=$(grep -v sqlcl_snapshot "$f" | tr -d '\r' | LC_ALL=C sort)
  if [ "$old" = "$new" ]; then
    git checkout -- "$f"
  fi
done
```

Schleife 4 ist bewusst **nach** den anderen angeordnet und nur für Dateien gedacht, bei denen die Zeilen-Reihenfolge keine Bedeutung hat. Für Code-Objekte wäre ein sortierter Vergleich zu grob (zwei vertauschte Anweisungen in einem Package sind eine echte Änderung) – in der Praxis greift sie dort nicht, weil der Code vorher schon von Schleife 1 oder 3 aussortiert wurde oder sich tatsächlich unterscheidet. Wer sichergehen will, beschränkt die Schleife auf `*/comments/*`.

**Wichtiger Stolperstein bei Schritt 3:** `git diff -w --quiet` (Exit-Code-Prüfung) reicht **nicht**, um Whitespace-only-Diffs zu erkennen, wenn zusätzlich noch die Hash-Zeile differiert – das ist so gut wie immer der Fall, da der Hash über den Text inkl. Whitespace berechnet wird. Man muss den tatsächlichen `git diff -w`-Output prüfen und die Hash-Zeile selbst dabei ignorieren (siehe Schleife 3 oben), sonst werden reine Whitespace-Diffs fälschlich als "echt" eingestuft.

Nach diesen drei automatisierten Schritten bleibt üblicherweise nur noch eine kleine, gut überschaubare Restmenge übrig, die man einzeln ansehen muss.

#### 3b. Bei echten Diffs: Zuordnung klären, bevor committet wird

Ein echter Diff kann drei Ursachen haben:
1. **Kollegen-Änderung**, direkt auf der Haupt-Entwicklungsdatenbank vorgenommen → gehört in den Sync-Branch/`main`.
2. **Eigene Arbeit für ein anderes Ticket**, die zufällig über denselben Export mit reinkam (z. B. weil man nebenbei auf der individuellen Entwicklungsdatenbank für ein anderes Ticket gearbeitet hat) → gehört in einen eigenen Branch für das jeweilige Ticket, nicht in den aktuellen Feature-Branch.
3. **Eigene Arbeit für das aktuelle Ticket**, bisher nur direkt auf der Datenbank gemacht, noch nicht committet → gehört in den aktuellen Feature-Branch.

Für Fall 2 lässt sich die Änderung sauber umsortieren, ohne die übrigen unkommittierten Änderungen zu berühren:

```powershell
# Nur die betroffene(n) Datei(en) aus dem Working Tree herauslösen
git stash push -m "<Ticket>: Beschreibung" -- <datei1> <datei2>

# Zielbranch anlegen/wechseln (Ausgangspunkt je nach Bedarf, meist main)
git checkout main
git checkout -b <TICKET-NUMMER>

# Änderungen dort einspielen und committen
git stash pop
git add <datei1> <datei2>
git commit -m "..."

# zurück zum eigentlichen Feature-Branch (übrige uncommitted Changes bleiben unangetastet)
git checkout <feature-branch>
```

## Warum so viel Rauschen entsteht

Mehrere unterschiedliche, unabhängig voneinander wirkende Ursachen wurden identifiziert – wichtig, sie nicht zu vermischen, da sie unterschiedlich behebbar sind.

### Ursache A: `export.format.enable`-Inkonsistenz zwischen Export-Sessions (Konfiguration, behebbar)

`.dbtools/project.sqlformat.xml` legt u. a. `removeDoubleQuotes: true`, `idCase: lower` und `kwCase: lower` fest – das würde Bezeichner unquoten und kleinschreiben. Diese Einstellungen greifen aber nur, wenn `export.format.enable = true` in `project.config.json` steht. Bei uns steht das bewusst auf `false` (siehe Commit *"Export mit Parameter export.format.enable -value false wiederholt"*), um die frühere, noch größere Reformatierungs-Problematik zu vermeiden. `DBMS_METADATA.GET_DDL` quotet Bezeichner ohne diese Formatierungs-Stufe **standardmäßig immer** – unabhängig davon, ob das jeweilige Objekt das nötig hätte. Wurde eine bereits committete Datei ursprünglich mit `format.enable=true` (oder einem anderen Mechanismus) erzeugt, und später mit `format.enable=false` neu exportiert, entsteht ein Diff wie:

```diff
-type DIRKSPZM32.pzm_gueltig_regel_t as object (
+TYPE DIRKSPZM32."PZM_GUELTIG_REGEL_T" as object (
```

Das ist also vermutlich **keine** Datenbank-Versionsfrage, sondern eine Frage, ob die Formatierungs-Einstellung zwischen den beteiligten Export-Sessions konsistent war. **Praktische Konsequenz:** Vor jedem Export prüfen, dass `export.format.enable` unverändert `false` ist (bzw. für alle Beteiligten identisch konfiguriert ist) – das ist eine reine Konfigurationsfrage, kein unveränderliches Umgebungsmerkmal.

### Ursache B: unterschiedliche Oracle-Datenbank-Versionen (Umgebung, strukturell)

Empirisch bestätigt (z. B. zwischen `<INDIVIDUELLE-ENTWICKLUNGSDATENBANK>` und der Haupt-Entwicklungsdatenbank über `SELECT banner FROM v$version`) für Fälle, die sich **nicht** über `format.enable` erklären lassen – insbesondere:

- Implizite vs. explizite Darstellung von PK-/Unique-Indizes (`USING INDEX ENABLE` vs. eigene `CREATE UNIQUE INDEX`-Anweisung plus benannte `USING INDEX "..."`-Klausel) – das ist keine Casing-/Quoting-Frage, sondern eine unterschiedliche strukturelle Klassifizierung des Objekts durch `DBMS_METADATA`/SXML, die keiner der `sqlformat.xml`-Optionen zuzuordnen ist.

Möglicherweise (nicht abschließend geklärt) gehört auch das beobachtete Trailing-Whitespace-Verhalten hierher, statt zu Ursache A – nicht sicher unterscheidbar, da eine volle Reformatierung (`format.enable=true`) Whitespace ebenfalls als Nebeneffekt bereinigen würde.

**Ausdrücklich als Ursache ausgeschlossen** (durch gezielte Tests widerlegt, nicht nur vermutet):
- SQLcl-**Client**-Version – in dem Fall, der zu diesem Befund führte, wurde durchgehend derselbe Extension-Build verwendet.
- `SQLBLANKLINES`-Einstellung – A/B-Test mit ON/OFF bei identischem Client brachte keinen Unterschied.

**Praktische Konsequenz:** Vor jeder Ursachen-Zuschreibung zuerst die Konfigurations-Ursachen A und C prüfen (`format.enable`-Konsistenz, `NLS_SORT`) – sie sind die wahrscheinlicheren und leichter behebbaren Erklärungen. Erst wenn das ausgeschlossen ist, lohnt sich ein Gegentest auf Datenbank-Version (`SELECT banner FROM v$version` auf beiden Datenbanken vergleichen).

### Ursache C: `NLS_SORT` der Export-Session (Konfiguration, behebbar)

SQLcl gibt die `comment on column`-Anweisungen einer Tabelle sortiert nach Spaltenname aus – und zwar in der Sortierreihenfolge der **Session**, nicht der Datenbank. Unterscheidet sich `NLS_SORT` zwischen zwei Exporten, ändert sich die Reihenfolge in praktisch allen Dateien unter `comments/`, bei identischem Inhalt:

```diff
-comment on column S_PZM_PERS."PERS_NR" is '...';
 comment on column S_PZM_PERS."PERSONALTEILBER" is '...';
+comment on column S_PZM_PERS."PERS_NR" is '...';
```

`BINARY` sortiert `_` (0x5F) hinter Buchstaben, `GERMAN` davor. Da sich dabei auch der Hash ändert, fängt Schleife 1 das nicht ab – erst der sortierte Vergleich in Schleife 4.

Beobachtet wurde das sogar bei einem erneuten Export aus **derselben** individuellen Entwicklungsdatenbank ohne zwischenzeitliche DB-Änderung: 81 von 89 geänderten Dateien waren reine Reihenfolge-Differenzen in `comments/`. Alle bis dahin committeten Dateien waren linguistisch (`GERMAN`) sortiert, der neue Export binär (`BINARY`). Nach `alter session set nls_sort = GERMAN` und erneutem Export verschwanden alle 81 Differenzen – damit ist die Ursache bestätigt.

Woher die Session plötzlich `BINARY` hatte, ist noch nicht geklärt – bewusste Umgebungsänderungen gab es nicht. Die Standard-Sortierung leitet sich aus `NLS_LANGUAGE` ab (`AMERICAN` → `BINARY`, `GERMAN` → `GERMAN`). Kandidaten:
- die Umgebungsvariable `NLS_LANG` (auf dem betroffenen Arbeitsplatz `AMERICAN_GERMANY.WE8MSWIN1252`) vs. das Java-/Windows-Locale (`de-DE`) – je nachdem, welches davon der SQLcl-/JDBC-Build für die Session-Sprache heranzieht,
- ein automatisches Update der SQLcl-VS-Code-Extension, das diese Auswertung geändert hat.

**Praktische Konsequenz:** `NLS_SORT` vor jedem Export explizit prüfen bzw. setzen (siehe [Voraussetzungen](#voraussetzungen-einmalig-prüfen-nicht-bei-jedem-lauf)), statt sich auf die Ableitung aus der Umgebung zu verlassen. Welcher Wert kanonisch ist, ist eine Team-Konvention – `GERMAN` entspricht dem aktuellen Git-Stand, `BINARY` wäre unabhängig von Sprach-/Locale-Einstellungen, würde aber einen einmaligen Normalisierungs-Commit über alle `comments/`-Dateien erfordern.

### Ursache D: Editor-Änderungen an Export-Dateien, z. B. bei Merge-Konflikten (Prozess, behebbar)

SQLcl schreibt die `-- sqlcl_snapshot`-Zeile als letzte Zeile **ohne** abschließenden Zeilenumbruch. Wird eine Export-Datei im Editor bearbeitet und gespeichert, kann der Editor (je nach Einstellung, `.editorconfig` oder Extension) einen Zeilenumbruch am Dateiende ergänzen. Beim nächsten Export fällt er wieder weg → Diff nur an der letzten Zeile, bei identischem Hash.

Beobachtet an 5 Dateien (`get_schicht_daten`, `pzm_utils` Spec + Body, `pzm_kontoverwaltung`, `man_update_pers_ze_r55_2`): Beide Eltern des Merge-Commits `a256694` ("Merge branch 'main' into I5-183") hatten keinen Zeilenumbruch am Ende, der Merge-Commit selbst schon – die Dateien wurden im Merge angefasst, sehr wahrscheinlich bei der manuellen Auflösung von Konflikten in der Hash-Zeile. Das ist eine direkte Folge davon, dass praktisch jede parallele Änderung an einem Objekt einen Konflikt in dessen Hash-Zeile erzeugt.

**Praktische Konsequenz:**
- Bei Merge-Konflikten in Export-Dateien möglichst nicht von Hand auflösen, sondern nach dem Merge `project export` wiederholen und dessen Fassung übernehmen.
- Optional für `src/database/**/*.sql` eine `.editorconfig` mit `insert_final_newline = false` hinterlegen.
- Bereits betroffene Dateien einmalig mit der Export-Fassung committen ("Export-Normalisierung, keine inhaltliche Änderung") – danach tauchen sie bei Folge-Exporten nicht mehr auf. Nur zu verwerfen (`git checkout --`) verschiebt das Problem auf den nächsten Export.

Zur strategischen Einordnung dieses Rauschens (betrifft nicht nur den Ausnahmefall, sondern jeden regulären Datenbank-Abgleich) siehe die [Grundsatzfrage im CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md#grundsatzfrage-lohnen-sich-individuelle-entwicklungsdatenbanken-noch).

### 4. Encoding-Check laufen lassen

```sql
@tools/check-encoding.sql DIRKSPZM32
```

Damit stellst du sicher, dass der Export selbst keine Umlaute verstümmelt hat (unabhängig vom eigentlichen Konsolidierungs-Thema, aber ein guter Zeitpunkt für die Prüfung, da du gerade frisch exportierten Text vor dir hast).

### 5. Committen

```powershell
git add <nur die Dateien mit echten Diffs>
git commit -m "Nachträgliche Erfassung von Direkt-Änderungen auf der Haupt-Entwicklungsdatenbank"
```

### 6. In main mergen

```powershell
git checkout main
git merge sync/maindb-<datum>
git push GitHub-Origin main
```

Falls `main` PR-Pflicht hat: PR statt direktem Push.

### 7. Zurück in den normalen Ablauf

Ab hier ist die Ausnahme behoben – `main` spiegelt jetzt wieder den tatsächlichen Stand der Haupt-Entwicklungsdatenbank. Weiter mit [Schritt a) im normalen Ablauf](ci-cd-vorgehensmodell.md#a-individuelle-entwicklungsdatenbank-mit-main-synchron-halten), um die soeben eingefangenen Änderungen auf deine individuelle Entwicklungsdatenbank zu ziehen.

## Bekannte Fallstricke

- **Nicht** `project stage`/`project deploy` für diesen Konsolidierungs-Schritt nutzen – dieses Tool vergleicht zwei Git-Branches (Dateien gegen Dateien), nicht Dateien gegen eine live Datenbank, und eignet sich daher nicht für "was hat sich auf der DB seit dem letzten Abgleich geändert". Es ist eher für "was fügt mein Feature-Branch gegenüber `main` hinzu" gedacht.
- Git Bashs `mv` kann bei Verzeichnisoperationen unter Windows-Systempfaden mit "Permission denied" scheitern, obwohl PowerShells `Move-Item` identisch funktioniert – bei Problemen auf PowerShell-native Befehle ausweichen.
- Zip-Archive/Exporte können eine zusätzliche Verzeichnis-Verschachtelungsebene enthalten – Struktur nach dem Entpacken/Exportieren kurz gegenprüfen, bevor man sich auf einen bestimmten Pfad verlässt.

## Noch offen / bewusst nicht Teil dieses Prozesses

- Eine vollautomatisierte `project stage`/`deploy`-Pipeline mit Baseline pro Umgebung wäre die langfristig sauberere Lösung, ist aber aktuell nicht ausreichend erprobt (unklare Baseline-Mechanik, unverifizierte `dist/`-Altlasten aus `w24120-635`). Bewusst zurückgestellt, bis das separat validiert ist.
- Eine dauerhafte, teamweite Lösung gegen das Encoding-Problem (z. B. Team-Konvention für SQLcl-Version und NLS-Konfiguration) ist noch nicht etabliert – bisher nur für diesen einen Arbeitsplatz gelöst.
- Wie man einen tatsächlichen Regelverstoß (vs. normalen main-Fortschritt anderer Kollegen) zuverlässig *erkennt*, bevor man den ganzen Ausnahmefall-Ablauf durchläuft, ist nicht abschließend geklärt – aktuell nur über konkrete Anhaltspunkte (z. B. Kollegen-Aussage), nicht automatisiert.

## Grundsatzfrage: Lohnen sich individuelle Entwicklungsdatenbanken noch?

Bei einem konkreten Durchlauf dieses Prozesses (Konsolidierung main → `<INDIVIDUELLE-ENTWICKLUNGSDATENBANK>`, `<FEATURE-BRANCH>`) ergab sich folgendes Bild:

| Schritt | Verbleibende Dateien |
|---|---|
| Ausgangspunkt (`project export` gegen `<INDIVIDUELLE-ENTWICKLUNGSDATENBANK>`, Diff gegen Git) | 239 |
| Nach Hash-Vergleich (identisch → verwerfen) | 44 |
| Nach SXML-Vergleich bei Tabellen (identisch → verwerfen) | 13 |
| Nach inhaltlicher Einzelprüfung der restlichen Code-Objekte | 5 echte Änderungen |

**Von 239 Dateien waren am Ende nur 5 (≈ 2 %) tatsächlich relevant** – 2 davon eigene, bisher nicht committete Arbeit für das laufende Ticket, 3 davon fälschlich eingesammelte Arbeit für ein anderes Ticket (P80009-341), die in einen eigenen Branch umsortiert werden musste. Der komplette Rest war Rauschen durch unterschiedliche Oracle-Versionen zwischen den Umgebungen (siehe oben) – nicht durch echte, unentdeckte DB-Drift.

> **Nachtrag:** Die spätere Analyse (Ursachen C und D) zeigt, dass ein erheblicher Teil des Rauschens gar nicht umgebungsbedingt ist, sondern auf Session-Konfiguration (`NLS_SORT`) und Editor-Eingriffe zurückgeht – beides behebbar. Ob die Zuschreibung "unterschiedliche Oracle-Versionen" für diesen Durchlauf in vollem Umfang zutraf, ist damit offen; der Anteil echter Versions-Unterschiede ist vermutlich kleiner als hier angenommen.

Diese Rohdaten sind die empirische Grundlage für die [Grundsatzfrage im CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md#grundsatzfrage-lohnen-sich-individuelle-entwicklungsdatenbanken-noch) – dort ausführlicher diskutiert, da sie über diesen Ausnahmefall hinaus auch den normalen Ablauf betrifft.
