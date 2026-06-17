comment on table DIRKSPZM32.MELDUNG_CFG is 'MeldungslKopf der Fehlergenierenden Aggregate mit Kümmerer ';
comment on column DIRKSPZM32.MELDUNG_CFG."ACTIVE" is '(T) Active = True (F) Active = False Hiermit kann die Benutzung abgeschaltet werden. spez. MFR_Server';
comment on column DIRKSPZM32.MELDUNG_CFG."AUFTRAG_FEHLER_CFG_NR" is 'Zeigt auf die MELDUNG_CFG Row, die die Nr (FEHLER_TEXT_GRUPPE)  NQ enthält.';
comment on column DIRKSPZM32.MELDUNG_CFG."AUTO_QUITTIERUNG" is 'Automatische Quittierung  ''T''rue Wenn letzte Meldung gegangen, ist der Bereich wieder in Auto.  ''F'' = Default Es wird auf ein AT91/PQ benötigt. ';
comment on column DIRKSPZM32.MELDUNG_CFG."CREATED_DATE" is 'Erstellungsdatum';
comment on column DIRKSPZM32.MELDUNG_CFG."CREATED_LOGIN_ID" is 'Ersteller ID';
comment on column DIRKSPZM32.MELDUNG_CFG."DATA_TEL_START" is 'Startposition der Datenbits im Telegramm';
comment on column DIRKSPZM32.MELDUNG_CFG."DETAILS" is 'Details';
comment on column DIRKSPZM32.MELDUNG_CFG."ENGINE_ID" is 'Welcher Server benutzt diese Daten';
comment on column DIRKSPZM32.MELDUNG_CFG."FEHLER_TEXT_GRUPPE" is 'Nr. der Gruppe, Gruppe mit Meldungen, z.B. alle Meldungen für RFZ2';
comment on column DIRKSPZM32.MELDUNG_CFG."FILE_NAME" is 'Dateiname des letzten Imports.';
comment on column DIRKSPZM32.MELDUNG_CFG."FIRMA_NR" is 'FIRMA_NR';
comment on column DIRKSPZM32.MELDUNG_CFG."GRUPPEN_INIT_NAME" is 'Kapselt über den Namen Alle meldungsgruppen die  auf einmal quittiert werden können';
comment on column DIRKSPZM32.MELDUNG_CFG."IMP_EXP_FIELDS" is 'welche Felder sind bei Import und Export angegeben. z.B. I;F;T;M;Q;    I = IX, F= Fehlernr, T= FehlerText, M= MeldType, Q=Quittieren, G=Gruppe; R = Regelwerk; X= FehlerNr als String ';
comment on column DIRKSPZM32.MELDUNG_CFG."INIT_TIMEOUT_MSEK" is 'WarteZeit für eine Quittierung Init bis Timeout';
comment on column DIRKSPZM32.MELDUNG_CFG."ISI_FEHLER_CFG_NR" is 'Zeigt auf die MELDUNG_CFG Row, die die Nr (FEHLER_TEXT_GRUPPE) für Modulfehler z.B. MFR enthält';
comment on column DIRKSPZM32.MELDUNG_CFG."LAST_CHANGE_DATE" is 'Änderungsdatum';
comment on column DIRKSPZM32.MELDUNG_CFG."LAST_CHANGE_LOGIN_ID" is 'ID der den Datensatz geändert hat';
comment on column DIRKSPZM32.MELDUNG_CFG."LIEFERANT" is 'Lieferant Maschinenbauer des Anlagebereichs';
comment on column DIRKSPZM32.MELDUNG_CFG."MAX_BITS" is 'Anzahl an  Worten bzw. Bytes die Fehlerbits enthalten';
comment on column DIRKSPZM32.MELDUNG_CFG."MAX_BITS_EINHEIT" is '(W) =WordArray (B) = ByteArray (0)=BitArray Start bei 0 (1)= Bitarray Start bei 1';
comment on column DIRKSPZM32.MELDUNG_CFG."MODUL_NAME" is 'welches Modul verwendet diese Meldungen';
comment on column DIRKSPZM32.MELDUNG_CFG."NAME" is 'NAME z.B. RFZ 1';
comment on column DIRKSPZM32.MELDUNG_CFG."NR" is 'eindeutige Nummer für diesen Konfigurationseintrag ';
comment on column DIRKSPZM32.MELDUNG_CFG."RES_ID" is 'Zeigt auf ISI_RESOURCE, wenn gesetzt, werden Fehler auch in Tabelle_isi_res_status geschrieben';
comment on column DIRKSPZM32.MELDUNG_CFG."SID" is 'SID';
comment on column DIRKSPZM32.MELDUNG_CFG."STRATEG_TEXT_GRUPPE" is 'Depricated Zeigt auf die  Meldung Texte in der die StrategieTexte liegen ';
comment on column DIRKSPZM32.MELDUNG_CFG."TYP" is 'SPS= SPS-Meldungen; ISI_MFR, ISI_BDE =Modul MFR, BDE -Meldungen; BDE= Bde-Meldungen;  NQ= SPS Auftragsfehlermeldingen; ZA=Zustandsautomat';



-- sqlcl_snapshot {"hash":"65146a7e1d9e8309d4bb682adc40b5ef0bd940cb","type":"COMMENT","name":"meldung_cfg","schemaName":"dirkspzm32","sxml":""}