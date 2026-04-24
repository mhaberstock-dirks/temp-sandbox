comment on table dirkspzm32.pps_arb_plan_ag is
    'Arbeitsgang im Arbeitsplan';

comment on column dirkspzm32.pps_arb_plan_ag.ag_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_arb_plan_ag.ag_name1 is
    'FA_AG Bezeichnung (Klartext)';

comment on column dirkspzm32.pps_arb_plan_ag.ag_name2 is
    'FA_AG Bezeichnung Name 2';

comment on column dirkspzm32.pps_arb_plan_ag.ag_text1 is
    'Zusatztext für die Beschreibung des FA_AG';

comment on column dirkspzm32.pps_arb_plan_ag.ag_text2 is
    'Zusatztext - 2';

comment on column dirkspzm32.pps_arb_plan_ag.ag_text3 is
    'Zusatztext - 3';

comment on column dirkspzm32.pps_arb_plan_ag.ag_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.pps_arb_plan_ag.arb_plan_id is
    'Arbeitsplan, dem dieser AG zugeordnet werden soll';

comment on column dirkspzm32.pps_arb_plan_ag.arb_plan_pos_id is
    'Eindeutige ID der Position für die Verbindung zur STL';

comment on column dirkspzm32.pps_arb_plan_ag.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_arb_plan_ag.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_arb_plan_ag.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_arb_plan_ag.nio_res_id is
    'Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden';

comment on column dirkspzm32.pps_arb_plan_ag.plan_menge_faktor is
    'Faktor Bedarfsmenge zur AG Planmenge';

comment on column dirkspzm32.pps_arb_plan_ag.plan_menge_faktor_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.pps_arb_plan_ag.pos_nr is
    'Bei Aufteilung des Vorgangs in mehrere Positionen (z.B. rüsten, fertigen = 1 Vorgang und 2 Positionen)';

comment on column dirkspzm32.pps_arb_plan_ag.prod_params is
    'Produktionsparameter zum Steuern von Prozessen oder Maschinenparametern oder Werkzeugen etc.';

comment on column dirkspzm32.pps_arb_plan_ag.quitt_gruppe_ag is
    'Quittierungs-Gruppe der quittierenden Pos_Nr, sonst eigene Pos_Nr.';

comment on column dirkspzm32.pps_arb_plan_ag.res_id is
    'Resource(ngruppe), die für die Produktion eingesetzt werden soll';

comment on column dirkspzm32.pps_arb_plan_ag.satzart is
    '"V" Verrichten, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';

comment on column dirkspzm32.pps_arb_plan_ag.soll_zeit_liegen is
    'Geplante netto Liegezeit (Dauer in Min). Vormaterial muss soviel Zeit Reifen (Liegen), bis es weiterverarbeitet werden kann';

comment on column dirkspzm32.pps_arb_plan_ag.soll_zeit_p_einh is
    'Sollzeit pro gefertigte Einheit / Zyklus in Minuten';

comment on column dirkspzm32.pps_arb_plan_ag.soll_zeit_ruest is
    'Geplante netto Rüstzeit (Dauer in Min)';

comment on column dirkspzm32.pps_arb_plan_ag.soll_zeit_stoer_p_std is
    'Geplante, Berücksichtigte Stillstandszeit pro Stunde';

comment on column dirkspzm32.pps_arb_plan_ag.vorgang is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.pps_arb_plan_ag.vorgangsqualifikation is
    'Qualifikation, die das Personal zur Bedienung des Vorgangs benötigt';


-- sqlcl_snapshot {"hash":"f7d9d4d81d5b8caf1d6072b5eabc26efaab143d9","type":"COMMENT","name":"pps_arb_plan_ag","schemaName":"dirkspzm32","sxml":""}