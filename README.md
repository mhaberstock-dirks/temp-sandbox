# DB-Schema-Standard

Dieses Repository definiert die **einheitliche Verzeichnisstruktur**
für Oracle-Datenbankobjekte in allen Kundenprojekten.

## Hintergrund
Bisher werden SQL-Dateien flach in `db-src/` abgelegt.
Dieses Modell ersetzt diese Struktur durch eine typenbasierte
Hierarchie, generiert und gepflegt via SQLCL `project export`.

Damit das volle Potenzial der CI/CD-Fähigkeiten von SQLCL ausgeschöpft werden kann, sind einige grundlegende Struktur-Änderungen nötig:

* kundenspezifische Entwicklungsdatenbanken mit einheitlicher Struktur:
** einheitliche Schemanamen für das Produkt (z.B. ISIPlus)
** optional: einheitliche Schemanamen für Module des Produkts (z.B. MES, PZM, LVS, ...) 
** kundenspezifische Erweiterungen ausschließlich in einem CUST-Schema.

In GitHub oder Azure Devops wird dann ein einheitliches Produkt-Repository verwaltet, sowie ein kundenspezifisches Repository.

## Zielstruktur

standortIN-a/
├── db-src/
│   ├── tables/
│   ├── views/
│   ├── procedures/
│   └── ...
└── shared/

## Migration
Zum vereinbarten Stichtag wird die flache Struktur in allen
betroffenen Kunden-Repositories durch diese Struktur ersetzt.
Die README ist damit gleichzeitig deine Präsentationsgrundlage – wer das Repo öffnet, versteht sofort den Zweck.

Erstellt mit Claude Sonnet 4.6


