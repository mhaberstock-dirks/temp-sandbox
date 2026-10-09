# Verzeichnisstruktur des Repositorys

> **Zugehörige Dokumente:** [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md) · [Entscheidungsvorlage: SQLcl `project`-Tooling](entscheidungsvorlage-sqlcl-project-tooling.md) · [Anonymisierung](anonymisierung-entwicklungsdb.md)

Ein Teil des Repositorys wird von der SQLcl-Kommandofamilie `project` geschrieben, der Rest ist von Hand gepflegt. Wer eigene Dateien in einen von SQLcl verwalteten Baum legt, riskiert, dass sie überschrieben werden oder – im Fall von `dist/` – mit jedem Deployment-Artefakt ausgeliefert werden.

## Übersicht

Legende: **SQLcl** = von `project …` geschrieben · **eigen** = von Hand gepflegt · **lokal** = nicht in Git

```
<repo>/
├── .dbtools/                      SQLcl   Projekt-Konfiguration
│   ├── project.config.json                 Schemas, Export-/Stage-Optionen, SQLcl-Version
│   ├── project.sqlformat.xml               Formatierung (greift nur bei export.format.enable = true)
│   └── filters/project.filters             Filter für project export (Liquibase-Tabellen, DM$-Objekte, …)
│
├── src/database/                  SQLcl   project export – eine Datei je Datenbankobjekt
│   ├── dirkspzm32/<objekttyp>/             das Projekt-Schema (schemas in project.config.json)
│   │   └── tests/                 eigen   Testskripte (runstats) – von .gitignore erfasst, siehe unten
│   ├── sys/, stats_ext/           SQLcl   Grants dieser Schemas an DIRKSPZM32 (object_grants_as_grantor…)
│   └── mhaberstock/               ?       privates Schema, nicht in "schemas" – nicht deployen
│
├── dist/                          SQLcl   Deployment-Struktur – Inhalt des Artefakts von gen-artifact
│   ├── install.sql                         Einstieg für project deploy
│   ├── env/                                Properties (von stage aktualisiert)
│   ├── releases/                           Changelogs und Changesets – von .gitignore erfasst, siehe unten
│   └── utils/
│       ├── prechecks.sql                   Vorlage; stage ersetzt %CURRENT_VERSION% durch die SQLcl-Version
│       └── recompile.sql                   in install.sql referenziert (derzeit auskommentiert)
│
├── artifact/                      SQLcl   project gen-artifact – ZIP für project deploy        (lokal)
│
├── docs/                          eigen   Dokumentation
├── tools/                         eigen   Hilfsskripte, nicht Teil von export/stage/deploy
│   ├── check-encoding.sql                  Umlaute nach einem Export prüfen
│   └── anonymize/                          Anonymisierung der Entwicklungs-DB, siehe docs/anonymisierung-entwicklungsdb.md
│
├── README.md, .gitignore, .gitattributes   eigen
├── .claude/, .vscode/             eigen   Werkzeug-Einstellungen
└── .sqlcl/, var/                  lokal   laut .gitignore von SQLcl bzw. der VS-Code-Extension angelegt
```

## Welcher Befehl schreibt wohin

| Befehl | schreibt nach | Bemerkung |
|---|---|---|
| `project init` | `.dbtools/`, Grundgerüst von `dist/` (`install.sql`, `env/`, `utils/`, `releases/`) | einmalig; `prechecks.sql` und `recompile.sql` stammen aus dem ersten Commit zusammen mit `install.sql` und `env/` |
| `project config set …` | `.dbtools/project.config.json` | |
| `project export` | `src/database/<schema>/<objekttyp>/` | Umfang aus `schemas` und `filters/project.filters`; Grants landen unter dem Schema des Grantors |
| `project stage` | `dist/releases/next/changes/<branch>/…`, `dist/releases/next/release.changelog.sql`, `dist/utils/prechecks.sql`, `dist/env/` | vergleicht zwei Git-Branches, nicht Dateien gegen eine Datenbank |
| `project release` | `dist/releases/<version>/`, `dist/releases/main.changelog.sql` | macht aus `next` eine Version (laut Oracle-Dokumentation; bei uns noch nicht genutzt) |
| `project gen-artifact` | `artifact/<name>.zip` | packt den Inhalt von `dist/` |
| `project deploy` | – | liest das ZIP, schreibt nichts ins Repository |

`stage`, `release`, `gen-artifact` und `deploy` sind bei uns derzeit nicht im regulären Einsatz – Hintergrund im [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md#die-vollständige-project-befehlskette-zielbild).

## Regeln

- **`src/database/`** entsteht per `project export` aus der Datenbank. Von Hand geänderte Dateien überschreibt der nächste Export; Änderungen gehören in die Datenbank und kommen per Export ins Repository. Zur Kuration von Export-Rauschen siehe [Konsolidierung nach Direktänderungen](konsolidierung-nach-direktaenderungen.md#3-diff-kuratieren--nicht-blind-übernehmen).
- **`dist/`** enthält keine eigenen Dateien. Alles darin gelangt über `gen-artifact` in das Deployment-Artefakt und damit potenziell auf Test- und Produktivdatenbanken.
- **Eigene Skripte** gehören nach `tools/`, **Dokumentation** nach `docs/`.
- **`.dbtools/`** nur bewusst ändern: `project.config.json` und `filters/project.filters` wirken auf jeden Export aller Beteiligten.

## Auffälligkeiten (offen)

1. **`dist/releases/` ist nicht versioniert.** Die Zeile `[Rr]eleases/` in `.gitignore` stammt aus der Visual-Studio-Vorlage und erfasst auch `dist/releases/`. Die Ausgabe von `project stage` (z. B. das lokal vorhandene `dist/releases/next/changes/main-merge-260827/`) landet deshalb nicht in Git; früher war `dist/releases/main.changelog.xml` noch versioniert. Sobald `stage` regulär genutzt wird, müsste das korrigiert werden, z. B. mit einer Zeile `!dist/releases/` nach `[Rr]eleases/`.
2. **`src/database/dirkspzm32/tests/` ist nicht versioniert.** `.gitignore` enthält `**/Tests/*`; weil das Repository `core.ignorecase = true` hat, greift das auch für `tests`. Ob die Testskripte bewusst lokal bleiben sollen, ist nicht dokumentiert.
3. **`src/database/mhaberstock/`** liegt im Export-Baum, obwohl `mhaberstock` nicht in `schemas` steht – vermutlich aus einem früheren Export mit anderer Konfiguration. Das CI/CD-Vorgehensmodell schließt es beim Deploy ausdrücklich aus.
