# Entscheidungsvorlage: Einsatz der SQLcl `project`-Werkzeuge im Entwicklungs-Workflow

> **Zugehörige Dokumente:** [CI/CD-Vorgehensmodell](ci-cd-vorgehensmodell.md) (zeigt die volle `project`-Befehlskette als Zielbild sowie den aktuell genutzten manuellen Ersatz) · [Konsolidierung nach direkten Änderungen](konsolidierung-nach-direktaenderungen.md) (Quelle der meisten Belege im Anhang unten)

## Kernaussage

Die SQLcl-`project`-Kommandofamilie (`export`, `stage`, `release`, `deploy`) ist von ihrer Funktionsweise her für ein **striktes Forward-Rollout aus einer einzigen, kontinuierlich in Git gepflegten Quelle** konzipiert – nicht für den Abgleich zwischen mehreren, unabhängig voneinander existierenden Datenbank-Umgebungen. Das zeigt sich an zwei unterschiedlichen, voneinander unabhängigen Problemen:

1. **Strukturelle Einschränkung:** `project stage` vergleicht ausschließlich zwei Git-Branches (Dateien gegen Dateien). Es kann grundsätzlich nicht ermitteln, was sich auf einer *Live-Datenbank* gegenüber dem Git-Stand geändert hat – dafür bräuchte es einen Datenbank-gegen-Git-Vergleich, den es nicht anbietet.
2. **Praktisches Rauschen-Problem:** Selbst dort, wo `project export`/`stage` bestimmungsgemäß eingesetzt werden, erzeugen unterschiedliche Oracle-Datenbank-Versionen, SQLcl-Client-Versionen und Client-Encoding-Konfigurationen zwischen den beteiligten Umgebungen einen so hohen Anteil an nicht-inhaltlichen Unterschieden ("Rauschen"), dass ein manueller Abgleich fehleranfällig und aufwändig wird. Konkrete Zahlen und Beispiele dazu im Anhang.

Beide Punkte zusammen machen einen Abgleich *zwischen* mehreren, unabhängig weiterentwickelten Datenbank-Umgebungen mit den `project`-Werkzeugen unpraktikabel – unabhängig davon, wie diszipliniert man dabei vorgeht.

## Zwei mögliche Vorgehensmodelle

### Option 1: Zentrale Entwicklungsdatenbank

Alle Entwickler arbeiten weiterhin auf **einer** gemeinsamen Entwicklungsdatenbank. Der Rollout Richtung Test- und Produktivdatenbank erfolgt mit `project stage`/`release`/`deploy` – ein echter Forward-Rollout aus einer einzigen Quelle, also genau der Anwendungsfall, für den die Werkzeuge gebaut sind.

**Löst das Rauschen-Problem an der Wurzel:** Es gibt nur eine Quell-Datenbank-Version, mit der `project export` je arbeitet – die Ursache für das beobachtete Rauschen (unterschiedliche Umgebungen) entfällt strukturell.

**Erfordert Disziplin/Absprache:**
1. Keine parallelen Änderungen an denselben DB-Objekten durch verschiedene Kollegen.
2. Alle DB-Änderungen erfolgen innerhalb von Feature-Branches und werden nach Abschluss zeitnah gemerged.

**Offener technischer Punkt:** Der in diesem Dokument beschriebene `generatedFormat: "sql"`-Fehler (siehe Anhang) betrifft auch dieses Modell, sofern weiterhin reines SQL statt Liquibase-XML als Deployment-Format gewünscht ist – das ist unabhängig von der Frage zentral/individuell und müsste vor einem produktiven Einsatz von `stage`/`deploy` geklärt sein.

### Option 2: Individuelle Entwicklungsdatenbanken, Haupt-Entwicklungsdatenbank als erste Deployment-Stufe

Jeder Entwickler behält seine eigene Entwicklungsdatenbank. Die bisherige Haupt-Entwicklungsdatenbank wird zur **ersten Deployment-Ebene** umgewidmet – dort finden ab sofort **keinerlei direkten Software-Änderungen mehr statt**, sie wird nur noch per Deploy aus `main` beschrieben (analog zu Test-/Produktivdatenbank).

**Voraussetzung, die sich aus unseren Erfahrungen ergibt:** Der frühere oder später zwangsläufig nötige Abgleich (Live-DB gegen Git) ist mit den `project`-Werkzeugen nicht handhabbar – siehe die konkreten Probleme im Anhang, auf die wir bei einem einzelnen Konsolidierungs-Durchlauf gestoßen sind.

**Wichtige Einschränkung, unabhängig von dieser Entscheidung:** Diese Option verlagert das Rauschen-Problem, sie beseitigt es nicht. Der Schritt "individuelle Entwicklungsdatenbank mit main synchron halten" (`ci-cd-vorgehensmodell.md`, Normaler Ablauf → Punkt a) ist kein Sonderfall, sondern **fester, wiederkehrender Bestandteil des Lebenszyklus jedes einzelnen Features** – jeder Entwickler muss ihn bei jedem Feature erneut durchlaufen. Sofern die individuellen Entwicklungsdatenbanken nicht dieselbe Oracle-Version wie die Haupt-Entwicklungsdatenbank verwenden, hätten wir das in diesem Dokument beschriebene Rauschen-Problem also nicht einmalig oder ausnahmsweise, sondern **dauerhaft bei jedem Abgleich, für jeden Entwickler**. Anders als bei Option 1, wo die Ursache (mehrere unterschiedlich versionierte Quell-Datenbanken) strukturell entfällt, bliebe sie bei Option 2 vollständig bestehen – nur ihr Auftreten würde von "gelegentlicher Ausnahmefall" auf "Normalbetrieb" verschoben. Ob Option 2 den Aufwand tatsächlich reduziert, hängt deshalb entscheidend davon ab, ob eine Oracle-Versionsgleichheit über alle individuellen Entwicklungsdatenbanken hinweg praktisch durchsetzbar ist – ist das nicht der Fall, dürfte der Gesamtaufwand über die Zeit eher höher liegen als bei einer zentralen Entwicklungsdatenbank.

**Unerprobter, möglicher Milderungsansatz:** Statt Punkt a) im normalen Ablauf per Export-und-Diff durchzuführen, könnte man dort stattdessen – analog zum Haupt-Entwicklungsdatenbank-Deploy – die aus Git bekannte Änderungsliste direkt vorwärts einspielen, ganz ohne Live-Abgleich (siehe entsprechender Hinweis in `ci-cd-vorgehensmodell.md`, Punkt a). Das würde die Notwendigkeit der Versionsgleichheit an dieser Stelle entschärfen, da nie exportiert und verglichen wird. **Das ist aber reine Theorie, kein geprüftes Verfahren, und hat eine entscheidende Schwäche:** Es funktioniert nur, solange wirklich jeder Entwickler diszipliniert ausschließlich über diesen Weg arbeitet. Sobald auch nur einmal jemand die Workflow-Disziplin bricht (z. B. eine vergessene Ad-hoc-Änderung direkt auf der eigenen Entwicklungsdatenbank), kommt der volle, hier beschriebene Konsolidierungsaufwand für den betroffenen Fall zurück – nur eben unbemerkt, bis er auffällt. Dieser Ansatz sollte deshalb nicht als Lösung vorausgesetzt, sondern allenfalls als zu erprobende Option behandelt werden.

## Diskussionspunkte für das Gespräch

- Ist eine zentrale Entwicklungsdatenbank (Option 1) mit den beschriebenen Disziplin-Regeln im Team praktikabel, oder ist der Wunsch nach individuellen Entwicklungsdatenbanken (Autonomous DB pro Entwickler) wichtiger als die damit verbundenen Abgleich-Kosten?
- Falls Option 2: Ist eine Vereinheitlichung der Oracle-Version über alle individuellen Entwicklungsdatenbanken hinweg organisatorisch/lizenztechnisch **dauerhaft** machbar – nicht nur einmalig herstellbar, sondern bei jedem künftigen Oracle-Versionswechsel erneut synchron zu halten? Das ist keine Nebenbedingung, sondern die Voraussetzung dafür, dass Option 2 das Rauschen-Problem überhaupt löst statt es nur zum Dauerzustand zu machen (siehe oben).
- Soll der `generatedFormat: "sql"`-Fehler bei Oracle gemeldet/nachverfolgt werden, bevor `stage`/`deploy` für echte Rollouts genutzt wird (siehe Anhang, Punkt 4)?
- Unabhängig von der Grundsatzentscheidung: Der bereits dokumentierte manuelle Workflow (`project export` + Diff-Kuration, siehe `ci-cd-vorgehensmodell.md` und `konsolidierung-nach-direktaenderungen.md`) funktioniert nachweislich und erfüllt zusätzlich das Prinzip "im Fehlerfall nicht ausschließlich auf ein Tool angewiesen sein" – er bleibt in jedem der beiden Modelle eine sinnvolle Grundlage, unabhängig davon, ob/wann `stage`/`deploy` ergänzt werden.

## Anhang: Konkrete Befunde aus der Untersuchung

### 1. Umfang des Rauschens bei einem realen Konsolidierungs-Durchlauf

Beim Abgleich einer individuellen Entwicklungsdatenbank gegen den Git-Stand (main → Feature-Branch, nach Einspielen von Kollegen-Änderungen):

| Schritt | Verbleibende Dateien |
|---|---|
| Ausgangspunkt (`project export`, Diff gegen Git) | 239 |
| Nach Hash-Vergleich (identisch → Rauschen) | 44 |
| Nach SXML-Vergleich bei Tabellen (identisch → Rauschen) | 13 |
| Nach inhaltlicher Einzelprüfung | 5 echte Änderungen |

**Von 239 abweichenden Dateien waren am Ende nur 5 (≈ 2 %) tatsächlich relevant.**

### 2. Beispiel: Oracle-Versions-bedingtes Formatierungs-Rauschen (Type Spec)

Dieselbe, inhaltlich unveränderte Objektdefinition, exportiert von zwei unterschiedlichen Oracle-Datenbank-Versionen:

```diff
-type DIRKSPZM32.pzm_gueltig_regel_t as object (
+TYPE DIRKSPZM32."PZM_GUELTIG_REGEL_T" as object (
     schluessel varchar2(255),
     gueltig    number(1)
 );
```

Reine Groß-/Kleinschreibungs- und Quoting-Konvention – keine inhaltliche Änderung. Dieses exakte Diff-Muster trat bei zwei völlig unabhängigen Anlässen mit identischen Hash-Werten auf, was die systematische (nicht zufällige) Natur der Ursache bestätigt.

### 3. Beispiel: Index-Darstellungs-Rauschen bei Tabellen

Bei 30 von 30 betroffenen Tabellen unterschied sich ausschließlich, ob ein Primary-Key-Index implizit oder explizit dargestellt wurde:

```diff
    ) ;
+  CREATE UNIQUE INDEX "DIRKSPZM32"."PZM_KONTEN_CFG" ON "DIRKSPZM32"."PZM_KONTEN_CFG" ("SID", "FIRMA_NR", "TYP", "NAME") 
+  ;
 ALTER TABLE "DIRKSPZM32"."PZM_KONTEN_CFG" ADD CONSTRAINT "PZM_KONTEN_CFG" PRIMARY KEY ("SID", "FIRMA_NR", "TYP", "NAME")
-  USING INDEX  ENABLE;
+  USING INDEX "DIRKSPZM32"."PZM_KONTEN_CFG"  ENABLE;
```

Die strukturierte SXML-Objektbeschreibung, die SQLcl selbst mitliefert, war in allen 30 Fällen identisch – ein eindeutiger Beleg, dass die zugrundeliegende Datenbankstruktur unverändert war und es sich um reine Darstellungs-Differenz handelt.

### 4. Beispiel: `generatedFormat: "sql"`-Fehler bei `project stage`

Mit `"stage": {"generatedFormat": "sql", ...}` in `.dbtools/project.config.json` (bewusst gewählt, damit Deployment-Skripte als reines, direkt ausführbares SQL vorliegen und man im Fehlerfall nicht ausschließlich auf das Tool angewiesen ist) erkennt `project stage` reale Unterschiede korrekt:

```
Stage is Comparing:
Old Branch      refs/heads/main
New Branch      refs/heads/main-merge-260827

src/database/dirkspzm32/functions/get_schicht_daten.sql -> ...
src/database/dirkspzm32/package_bodies/pzm_kontoverwaltung.sql -> ...
[4 weitere Objekte]
=============== SORTED OBJECTS =================


Completed executing stage command on branch: main-merge-260827
```

Der Abschnitt "SORTED OBJECTS" – vermutlich der Schritt, der aus dem erkannten Diff tatsächliche Changelog-Dateien erzeugt – bleibt leer, es wird nichts unter `dist/` geschrieben. Ein identischer, in einem komplett neuen, unbelasteten Testprojekt nachgestellter Ablauf mit `generatedFormat: "liquibase"` (dem Standardformat) funktionierte dagegen einwandfrei über die komplette Kette inklusive `deploy`. Der Fehler tritt also spezifisch im `"sql"`-Formatpfad auf.

Ein öffentlich gemeldetes, thematisch passendes Problem existiert bereits im Oracle-Forum: ["SQLcl project release fails with missing main.changelog.xml when using SQL format"](https://forums.oracle.com/ords/r/apexds/community/q?question=sqlcl-project-release-fails-with-missing-main-changelog-xml-7908) (gemeldet für SQLcl 25.1.1).

### 5. Beispiel: Verstümmelte Umlaute durch drei unterschiedliche Ursachen

Im Rahmen dieser Untersuchung wurden drei unabhängige, unterschiedliche Verstümmelungsmuster für deutsche Sonderzeichen (ä, ö, ü, Ä, Ö, Ü, ß) identifiziert – alle mit derselben UTF-8-Leadbyte-Ursache (`0xC3`), aber unterschiedlicher Fehlinterpretation:

| Ursache | Symptom | Beispiel |
|---|---|---|
| Lokales Datei-Encoding falsch (CP850/437) | "├" (U+251C) | `m├╝ssten` statt `müssten` |
| Lokales Datei-Encoding falsch (CP1252) bzw. Zeichensatz-Doppel-Encoding | "Ã" (U+00C3) | `verstÃ¼mmelt` statt `verstümmelt` |
| Fehlendes `NLS_LANG` beim DB-Client (Fallback auf US7ASCII) | "¿¿" (paarweise) | `m¿¿ssten` statt `müssten` |

Alle drei entstanden bei unterschiedlichen Kombinationen aus Tool (sqlcl/sqlplus), Konsolen-Codepage und Zielsystem-Zeichensatz (`AL32UTF8` vs. `WE8MSWIN1252`) – ein Beleg dafür, wie viele unabhängige Fehlerquellen allein beim reinen Datentransport zwischen Umgebungen mit unterschiedlicher Werkzeug-/Zeichensatz-Konfiguration zusammenkommen können.
