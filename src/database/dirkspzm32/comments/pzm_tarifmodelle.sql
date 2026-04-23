comment on table dirkspzm32.pzm_tarifmodelle is
    'PZM Tarifmodelle im ISI-System';

comment on column dirkspzm32.pzm_tarifmodelle.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_tarifmodelle.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_tarifmodelle.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_tarifmodelle.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_13w_schnitt is
    'Wird hier der 13W Schnitt gerechnet und berücksichtigt?';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_bemerkung is
    'Bemerkung zum Tarifmodell';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_fest_std is
    'T=Es dürfen maximal diese Stunden für eine Berechnungs-Periode ausgezahlt werden';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_fest_std_akz_minus is
    'Maximale Stunden, di das Konto ins Minus gehen darf';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_fest_std_je_periode is
    'Maximal Stunden für eine Berechnungs-Periode im Stundenlohn';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_name is
    'Tarifmodell-ID (Primary-Key)';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_basis is
    'Basis der Berechnung ';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_basis_ermittlung is
    'Basis der Ermittlung der Stunden DD = Tageweise, WW Wochenweise oder NULL / MM Monatsweise (Default)';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_basis_w_tage is
    'Basis WW Wochenweise - Anzahl Tage je Woche für die Berechnung der UE-STD-Prozente';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_loa is
    'Die Überstunden LOA soll an das ERP übergeben werden';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_proz_wie_ueb_auszahlung is
    'Überstundenprozente werden nur auf ausgezahlte Überstunden geleistet (''T'''' hier ist nur möglich, wenn TARIF_UEB_ZEITKONTO_P_ZK = ''F'' und TARIF_UEB_BASIS_ERMITTLUNG = ''MM'')'
    ;

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_std is
    'Zur Berechnung der Überstunden auf Monatsbasis, NULL ergibt sich aus Schichtmodell';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_zeitkonto_proz is
    'Überstundenprozente zur Umrechnung in diesem Tarif';

comment on column dirkspzm32.pzm_tarifmodelle.tarif_ueb_zeitkonto_p_zk is
    'Überstundenprozente werden prozentual ausgerechnt und bis zur Grenze des Zeitkontos diesem Zugebucht';


-- sqlcl_snapshot {"hash":"f7b22b8b7b38d3fe8552cc6330be9b21d148b027","type":"COMMENT","name":"pzm_tarifmodelle","schemaName":"dirkspzm32","sxml":""}