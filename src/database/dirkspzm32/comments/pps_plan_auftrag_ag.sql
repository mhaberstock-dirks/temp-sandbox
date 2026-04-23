comment on column dirkspzm32.pps_plan_auftrag_ag.ag_name1 is
    'FA_AG Bezeichnung1 (Klartext)';

comment on column dirkspzm32.pps_plan_auftrag_ag.ag_name2 is
    'FA_AG Bezeichnung2 (Klartext)';

comment on column dirkspzm32.pps_plan_auftrag_ag.ag_text1 is
    'Zusatztext1 für die Beschreibung des FA_AG';

comment on column dirkspzm32.pps_plan_auftrag_ag.ag_text2 is
    'Zusatztext2 für die Beschreibung des FA_AG';

comment on column dirkspzm32.pps_plan_auftrag_ag.ag_text3 is
    'Zusatztext3 für die Beschreibung des FA_AG';

comment on column dirkspzm32.pps_plan_auftrag_ag.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_plan_auftrag_ag.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.pps_plan_auftrag_ag.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_plan_auftrag_ag.nio_res_id is
    'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';

comment on column dirkspzm32.pps_plan_auftrag_ag.plan_auf_ag_id is
    'Eindeutige Nummer aus SEQ';

comment on column dirkspzm32.pps_plan_auftrag_ag.plan_auf_id is
    'Auftragsnummer aus PPS_PLAN_AUFTRAG';

comment on column dirkspzm32.pps_plan_auftrag_ag.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_plan_auftrag_ag.prod_params is
    'Produktionsparameter (Aus Bedienereingabe oder pps_arb_plan/Stueckliste)';

comment on column dirkspzm32.pps_plan_auftrag_ag.quitt_gruppe_ag is
    'Quittierungs-Gruppe der quittierenden Pos_Nr, sonst eigene Pos_Nr.';

comment on column dirkspzm32.pps_plan_auftrag_ag.res_id is
    'Resource(ngruppe), die für die Produktion eingesetzt werden soll';

comment on column dirkspzm32.pps_plan_auftrag_ag.satzart is
    '"V" Verrichten, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';

comment on column dirkspzm32.pps_plan_auftrag_ag.sid is
    'SID';

comment on column dirkspzm32.pps_plan_auftrag_ag.soll_menge is
    'Sollmenge für AG';

comment on column dirkspzm32.pps_plan_auftrag_ag.soll_zeit_prod is
    'Geplante netto Produktionszeit  in Minuten';

comment on column dirkspzm32.pps_plan_auftrag_ag.soll_zeit_p_einh is
    'Sollzeit pro gefertigte Einheit / Zyklus in Minuten';

comment on column dirkspzm32.pps_plan_auftrag_ag.soll_zeit_ruest is
    'Geplante netto Rüstzeit  in Minuten';

comment on column dirkspzm32.pps_plan_auftrag_ag.soll_zeit_stoer is
    'Geplante, Berücksichtigte Stillstandszeit  in Minuten';

comment on column dirkspzm32.pps_plan_auftrag_ag.termin_ende_gepl is
    'Geplantes Produktionsende';

comment on column dirkspzm32.pps_plan_auftrag_ag.termin_start_gepl is
    'Geplanter Produktionsbeginn';

comment on column dirkspzm32.pps_plan_auftrag_ag.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.pps_plan_auftrag_ag.vorgangsqualifikation is
    'Qualifikation, die das Personal zur Bedienung des Vorgangs benötigt';


-- sqlcl_snapshot {"hash":"a4bbedbc3dd54364d322053b759d61db6238adad","type":"COMMENT","name":"pps_plan_auftrag_ag","schemaName":"dirkspzm32","sxml":""}