# DB-Schema-Standard

Dieses Repository definiert die **einheitliche Verzeichnisstruktur**
für Oracle-Datenbankobjekte in allen Kundenprojekten und erprobt sie am Schema `DIRKSPZM32` (PZM).

## Hintergrund

Bisher werden SQL-Dateien flach in `db-src/` abgelegt.
Dieses Modell ersetzt diese Struktur durch eine typenbasierte
Hierarchie, generiert und gepflegt via SQLcl `project export`.

Damit das volle Potenzial der CI/CD-Fähigkeiten von SQLcl ausgeschöpft werden kann, sind einige grundlegende Struktur-Änderungen nötig:

* kundenspezifische Entwicklungsdatenbanken mit einheitlicher Struktur:
  * einheitliche Schemanamen für das Produkt (z. B. ISIPlus)
  * optional: einheitliche Schemanamen für Module des Produkts (z. B. MES, PZM, LVS, …)
  * kundenspezifische Erweiterungen ausschließlich in einem CUST-Schema

In GitHub oder Azure DevOps wird dann ein einheitliches Produkt-Repository verwaltet, sowie ein kundenspezifisches Repository.

## Aufbau

```
<repo>/
├── .dbtools/        SQLcl   Projekt-Konfiguration (Schemas, Export-/Stage-Optionen, Filter)
├── src/database/    SQLcl   project export – eine Datei je Datenbankobjekt, z. B.
│   └── dirkspzm32/          tables/, views/, package_specs/, package_bodies/, triggers/, …
├── dist/            SQLcl   Deployment-Struktur (project stage / release), Inhalt des Artefakts
├── artifact/        SQLcl   project gen-artifact (nicht in Git)
├── docs/            eigen   Dokumentation
└── tools/           eigen   Hilfsskripte, nicht Teil von Export oder Deployment
```

**SQLcl** = von `project …` geschrieben, **eigen** = von Hand gepflegt. In `src/database/` und `dist/` gehören keine eigenen Dateien – Details, Regeln und offene Punkte in [docs/verzeichnisstruktur.md](docs/verzeichnisstruktur.md).

## Dokumentation

| Dokument | Inhalt |
|---|---|
| [Verzeichnisstruktur](docs/verzeichnisstruktur.md) | Was SQLcl verwaltet, was von Hand gepflegt wird, welcher Befehl wohin schreibt |
| [CI/CD-Vorgehensmodell](docs/ci-cd-vorgehensmodell.md) | Ablauf mit individuellen Entwicklungsdatenbanken, Feature-Branches und Haupt-Entwicklungsdatenbank |
| [Konsolidierung nach Direktänderungen](docs/konsolidierung-nach-direktaenderungen.md) | Ausnahmefall: Änderungen an der Haupt-Entwicklungsdatenbank nach Git zurückholen; Kuration von Export-Rauschen |
| [Entscheidungsvorlage SQLcl `project`-Tooling](docs/entscheidungsvorlage-sqlcl-project-tooling.md) | Warum `stage`/`release`/`deploy` derzeit durch einen manuellen Ablauf ersetzt werden |
| [Anonymisierung der Entwicklungsdatenbank](docs/anonymisierung-entwicklungsdb.md) | Personal- und Organisationsdaten nach einer Übertragung aus der Produktion anonymisieren |
| [Fehlerbehandlung PZM_P_LC](docs/fehlerbehandlung-pzm-p-lc.md) | Grundlagen und Codierungs-Richtlinien zur Fehlerbehandlung in `PZM_P_LC` / `PZM_P_LOG` |

## Migration

Zum vereinbarten Stichtag wird die flache Struktur in allen
betroffenen Kunden-Repositories durch diese Struktur ersetzt.

Erstellt mit Claude Sonnet 4.6
