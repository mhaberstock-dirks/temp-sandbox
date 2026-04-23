comment on table dirkspzm32.pps_arb_plan_ag_pers_q_list is
    'PPS Liste der Resourcen, die diesen Arbeitsgang fertigen können.';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.anz_bediener is
    'Anzahl der für diese Vorgangsposition benötigten Bediener';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.firma_nr is
    'Firmennummer (Ist auch die ADR_NR in der Adressentabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.group_id is
    'eindeutige, frei wählbare ID des benötigten Personalbedarfs (Personalbedarfsgruppe), z.B. ''1'', ''Packer'' oder ''Schweißer''. Die Gruppennummer darf
nicht leer sein!
Diese wird benötigt, um unterschiedlichen Personalbedarf unterscheiden zu können (nicht mit ID der Personalgruppe verwechseln!)';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.max_bediener is
    'maximale Anzahl gleichzeitiger Bediener';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.personalwechseltyp is
    'Einstellungen zum Personalwechsel
Personalwechseltyp
Wert Bezeichnung Beschreibung
0 ständiger Wechsel
erlaubt
Mehrschichtbearbeitung ist zugelassen, d.h. dass ein Mitarbeiter aus z.B. einer anderen Schicht die
angemeldete Tätigkeit auf diesem Arbeitsplatz weiterbearbeiten darf
1 kein Wechsel in Vorgangsposition erlaubt Personalwechsel innerhalb von Vorgangspositionen ist nicht erlaubt (keine Mehrschichtbearbeitung), d.h. der/die gleicheMitarbeiter bearbeiten komplett eine Vorgangsposition
2 kein Wechsel in Vorgang erlaubt Personalwechsel innerhalb eines kompletten Vorgangs ist nicht erlaubt, d.h. exakt der/die gleicheMitarbeiter werden für den kompletten Vorgang verwendet (entspricht Bedienzwang)
Achtung: Wird dieser Typ gewählt, dann muss activity_type = 0 (alle) sein';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.proz_bediener is
    'prozentuale Auslastung der Bediener';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.res_id is
    'Arbeitsplätze und/oder Arbeitsplatzgruppen, für die der Personalbedarf gilt
leer = alle Arbeitsplätze';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.sid is
    'Datenbank dieser Firma';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.vorgangsqualifikation is
    'optionale Vorgangsqualifikation (Sonder- oder auch Tätigkeitsqualifikation), die das Personal zur Bedienung des Vorgangs benötigt'
    ;

comment on column dirkspzm32.pps_arb_plan_ag_pers_q_list.vorgangstyp is
    'Für welchen Vorgangspositionstyp gilt der angegeben Personalbedarf
0 = alle (Personalbedarf gilt automatisch für alle Positionen eines Vorgangs)
1 = fertigen
2 = rüsten';


-- sqlcl_snapshot {"hash":"98c0bd44611422a54e1c466a326fa2852d527c1d","type":"COMMENT","name":"pps_arb_plan_ag_pers_q_list","schemaName":"dirkspzm32","sxml":""}