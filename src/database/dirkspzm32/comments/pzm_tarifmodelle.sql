comment on table DIRKSPZM32.PZM_TARIFMODELLE is 'PZM Tarifmodelle im ISI-System';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_13W_SCHNITT" is 'Wird hier der 13W Schnitt gerechnet und berücksichtigt?';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_BEMERKUNG" is 'Bemerkung zum Tarifmodell';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_FEST_STD" is 'T=Es dürfen maximal diese Stunden für eine Berechnungs-Periode ausgezahlt werden';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_FEST_STD_AKZ_MINUS" is 'Maximale Stunden, di das Konto ins Minus gehen darf';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_FEST_STD_JE_PERIODE" is 'Maximal Stunden für eine Berechnungs-Periode im Stundenlohn';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_NAME" is 'Tarifmodell-ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_BASIS" is 'Basis der Berechnung ';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_BASIS_ERMITTLUNG" is 'Basis der Ermittlung der Stunden DD = Tageweise, WW Wochenweise oder NULL / MM Monatsweise (Default)';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_BASIS_W_TAGE" is 'Basis WW Wochenweise - Anzahl Tage je Woche für die Berechnung der UE-STD-Prozente';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_LOA" is 'Die Überstunden LOA soll an das ERP übergeben werden';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_PROZ_WIE_UEB_AUSZAHLUNG" is 'Überstundenprozente werden nur auf ausgezahlte Überstunden geleistet (''T'''' hier ist nur möglich, wenn TARIF_UEB_ZEITKONTO_P_ZK = ''F'' und TARIF_UEB_BASIS_ERMITTLUNG = ''MM'')';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_STD" is 'Zur Berechnung der Überstunden auf Monatsbasis, NULL ergibt sich aus Schichtmodell';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_ZEITKONTO_PROZ" is 'Überstundenprozente zur Umrechnung in diesem Tarif';
comment on column DIRKSPZM32.PZM_TARIFMODELLE."TARIF_UEB_ZEITKONTO_P_ZK" is 'Überstundenprozente werden prozentual ausgerechnt und bis zur Grenze des Zeitkontos diesem Zugebucht';



-- sqlcl_snapshot {"hash":"feadd35676bce28ccec1badbbcccb83e3a3184ef","type":"COMMENT","name":"pzm_tarifmodelle","schemaName":"dirkspzm32","sxml":""}