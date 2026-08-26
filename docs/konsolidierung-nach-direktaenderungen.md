# Konsolidierung nach direkten Änderungen an der Haupt-Entwicklungsdatenbank

> Dies ist die Ausnahmebehandlung für einen Regelverstoß gegen das [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md): jemand hat die Haupt-Entwicklungsdatenbank direkt geändert, unter Umgehung von Git. Für den normalen Ablauf siehe dort – dieses Dokument ist **kein Teil des normalen Ablaufs** und im Idealfall nach vollständiger Einführung des Modells nicht mehr nötig.

Dadurch spiegelt `main` nicht mehr den tatsächlichen Stand der Haupt-Entwicklungsdatenbank wider. Dieser Prozess holt die Differenz nach Git zurück.

**Wichtiger Befund vorab** (siehe [Grundsatzfrage](#grundsatzfrage-lohnen-sich-individuelle-entwicklungsdatenbanken-noch) am Ende): Bei einem einzigen Durchlauf dieses Prozesses waren von 239 zunächst abweichenden Dateien am Ende nur 5 echte, relevante Änderungen übrig – der Rest war Rauschen, das sich mutmaßlich aus unterschiedlichen Oracle-Datenbank-Versionen zwischen den Umgebungen ergibt. Plane entsprechend Zeit für die Kuration ein.

Die Kurations-Technik in Schritt 3 unten ist nicht nur für diesen Ausnahmefall relevant – sie wird auch bei Schritt a) im normalen Ablauf (individuelle Entwicklungsdatenbank mit `main` synchron halten) gebraucht, da dort dasselbe Rauschen auftritt.

## Voraussetzungen (einmalig prüfen, nicht bei jedem Lauf)

- **SQLcl-Version stimmt mit `.dbtools/project.config.json` (`sqlcl.version`) überein.** Ein Versions-Unterschied erzeugt massenhaft Diffs, die keine echten Änderungen sind (unterschiedliche DDL-/SXML-Serialisierung derselben Objekte).
- **Encoding korrekt konfiguriert**, je nachdem wie du `project export` ausführst:
  - Über die VS-Code-Extension: `JAVA_TOOL_OPTIONS` muss `-Dfile.encoding=UTF-8` (mindestens) enthalten, als *Windows-Umgebungsvariable* (User-Scope) gesetzt, und VS Code muss danach komplett neu gestartet worden sein (nicht nur "Reload Window").
  - Prüfen lässt sich das indirekt: exportiere ein Objekt mit bekannten Umlauten im Kommentar und schau, ob sie korrekt aussehen.

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
| Echter Code-/Struktur-Unterschied | Tatsächliche, bisher nicht in Git erfasste Änderung – von einem Kollegen, oder eigene, noch nicht committete Arbeit | Behalten – prüfen, wem die Änderung zuzuordnen ist und in welchen Branch sie gehört (siehe Schritt 3b) |

#### Praktische Umsetzung bei vielen Dateien

Bei zweistelliger bis dreistelliger Dateizahl lohnt sich, die ersten drei Rauschen-Kategorien automatisiert zu prüfen, bevor man einzelne Dateien von Hand ansieht:

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
```

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

Empirisch bestätigte Ursache: **unterschiedliche Oracle-Datenbank-Versionen** zwischen den Umgebungen (bestätigt z. B. zwischen `<INDIVIDUELLE-ENTWICKLUNGSDATENBANK>` und der Haupt-Entwicklungsdatenbank über `SELECT banner FROM v$version`). `DBMS_METADATA`, worauf `project export` aufbaut, serialisiert Objekte je nach DB-Version teils unterschiedlich – identischer Inhalt, anderer Text. Beobachtete Varianten:

- Groß-/Kleinschreibung und Quoting von Schlüsselwörtern/Bezeichnern (`type ... name` vs. `TYPE ... "NAME"`)
- Implizite vs. explizite Darstellung von PK-/Unique-Indizes (`USING INDEX ENABLE` vs. eigene `CREATE UNIQUE INDEX`-Anweisung plus benannte `USING INDEX "..."`-Klausel)
- Unterschiedliches Trailing-Whitespace-Verhalten auf sonst leeren Zeilen

**Ausdrücklich als Ursache ausgeschlossen** (durch gezielte Tests widerlegt, nicht nur vermutet):
- SQLcl-**Client**-Version – in dem Fall, der zu diesem Befund führte, wurde durchgehend derselbe Extension-Build verwendet.
- `SQLBLANKLINES`-Einstellung – A/B-Test mit ON/OFF bei identischem Client brachte keinen Unterschied.

Praktische Konsequenz: Bevor man ein Diff-Muster einer bestimmten Ursache zuschreibt, lohnt sich ein kurzer Gegentest (z. B. `SELECT banner FROM v$version` auf beiden Datenbanken vergleichen), statt vorschnell auf Client-Tooling zu schließen.

Zur strategischen Einordnung dieses Rauschens (betrifft nicht nur den Ausnahmefall, sondern jeden regulären Datenbank-Abgleich) siehe die [Grundsatzfrage im CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md#grundsatzfrage-lohnen-sich-individuelle-entwicklungsdatenbanken-noch).

### 4. Encoding-Check laufen lassen

```sql
@dist/utils/check-encoding.sql DIRKSPZM32
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

Diese Rohdaten sind die empirische Grundlage für die [Grundsatzfrage im CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md#grundsatzfrage-lohnen-sich-individuelle-entwicklungsdatenbanken-noch) – dort ausführlicher diskutiert, da sie über diesen Ausnahmefall hinaus auch den normalen Ablauf betrifft.
