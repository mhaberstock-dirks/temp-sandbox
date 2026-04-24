comment on table dirkspzm32.meldung_cfg is
    'MeldungslKopf der Fehlergenierenden Aggregate mit Kümmerer ';

comment on column dirkspzm32.meldung_cfg.active is
    '(T) Active = True (F) Active = False Hiermit kann die Benutzung abgeschaltet werden. spez. MFR_Server';

comment on column dirkspzm32.meldung_cfg.auftrag_fehler_cfg_nr is
    'Zeigt auf die MELDUNG_CFG Row, die die Nr (FEHLER_TEXT_GRUPPE)  NQ enthält.';

comment on column dirkspzm32.meldung_cfg.auto_quittierung is
    'Automatische Quittierung  ''T''rue Wenn letzte Meldung gegangen, ist der Bereich wieder in Auto.  ''F'' = Default Es wird auf ein AT91/PQ benötigt. '
    ;

comment on column dirkspzm32.meldung_cfg.created_date is
    'Erstellungsdatum';

comment on column dirkspzm32.meldung_cfg.created_login_id is
    'Ersteller ID';

comment on column dirkspzm32.meldung_cfg.data_tel_start is
    'Startposition der Datenbits im Telegramm';

comment on column dirkspzm32.meldung_cfg.details is
    'Details';

comment on column dirkspzm32.meldung_cfg.engine_id is
    'Welcher Server benutzt diese Daten';

comment on column dirkspzm32.meldung_cfg.fehler_text_gruppe is
    'Nr. der Gruppe, Gruppe mit Meldungen, z.B. alle Meldungen für RFZ2';

comment on column dirkspzm32.meldung_cfg.file_name is
    'Dateiname des letzten Imports.';

comment on column dirkspzm32.meldung_cfg.firma_nr is
    'FIRMA_NR';

comment on column dirkspzm32.meldung_cfg.gruppen_init_name is
    'Kapselt über den Namen Alle meldungsgruppen die  auf einmal quittiert werden können';

comment on column dirkspzm32.meldung_cfg.imp_exp_fields is
    'welche Felder sind bei Import und Export angegeben. z.B. I;F;T;M;Q;    I = IX, F= Fehlernr, T= FehlerText, M= MeldType, Q=Quittieren, G=Gruppe; R = Regelwerk; X= FehlerNr als String '
    ;

comment on column dirkspzm32.meldung_cfg.init_timeout_msek is
    'WarteZeit für eine Quittierung Init bis Timeout';

comment on column dirkspzm32.meldung_cfg.isi_fehler_cfg_nr is
    'Zeigt auf die MELDUNG_CFG Row, die die Nr (FEHLER_TEXT_GRUPPE) für Modulfehler z.B. MFR enthält';

comment on column dirkspzm32.meldung_cfg.last_change_date is
    'Änderungsdatum';

comment on column dirkspzm32.meldung_cfg.last_change_login_id is
    'ID der den Datensatz geändert hat';

comment on column dirkspzm32.meldung_cfg.lieferant is
    'Lieferant Maschinenbauer des Anlagebereichs';

comment on column dirkspzm32.meldung_cfg.max_bits is
    'Anzahl an  Worten bzw. Bytes die Fehlerbits enthalten';

comment on column dirkspzm32.meldung_cfg.max_bits_einheit is
    '(W) =WordArray (B) = ByteArray (0)=BitArray Start bei 0 (1)= Bitarray Start bei 1';

comment on column dirkspzm32.meldung_cfg.modul_name is
    'welches Modul verwendet diese Meldungen';

comment on column dirkspzm32.meldung_cfg.name is
    'NAME z.B. RFZ 1';

comment on column dirkspzm32.meldung_cfg.nr is
    'eindeutige Nummer für diesen Konfigurationseintrag ';

comment on column dirkspzm32.meldung_cfg.res_id is
    'Zeigt auf ISI_RESOURCE, wenn gesetzt, werden Fehler auch in Tabelle_isi_res_status geschrieben';

comment on column dirkspzm32.meldung_cfg.sid is
    'SID';

comment on column dirkspzm32.meldung_cfg.strateg_text_gruppe is
    'Depricated Zeigt auf die  Meldung Texte in der die StrategieTexte liegen ';

comment on column dirkspzm32.meldung_cfg.typ is
    'SPS= SPS-Meldungen; ISI_MFR, ISI_BDE =Modul MFR, BDE -Meldungen; BDE= Bde-Meldungen;  NQ= SPS Auftragsfehlermeldingen; ZA=Zustandsautomat'
    ;


-- sqlcl_snapshot {"hash":"eaadbd49f7ed45355cb82bb17dd22fb778633281","type":"COMMENT","name":"meldung_cfg","schemaName":"dirkspzm32","sxml":""}