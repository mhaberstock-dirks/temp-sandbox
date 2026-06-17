comment on table DIRKSPZM32.S_ERP_RCV_ART_KD is 'Kundenartikel Beschreibung  aus SAP';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."AKTIV" is 'Status Aktiv T = Artikelnummer ist gültig, F = Artikelnummer ist ungültig (Aktivkennzeichen wird von SAP generiert)
';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."ARTIKEL" is 'Artikelnummer aus Schnittstelle';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."B_DATUM" is 'Buchungszeitpunkt als String';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz erstellt wurde';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."CREATED_LOGIN_ID" is '  Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."EAN" is 'EAN je kleinster Einheit (z.B. Je Becher, Päckchen, Stück etc.)';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."FIRMA_NR" is 'Mandant z.B. 01
';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."KD_ART_NR" is 'Kundenartikelnummer';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."KD_ART_TEXT1" is 'Bezeichnung 1';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."KD_ART_TEXT2" is 'Bezeichnung 2';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."KUNDEN_NR" is 'Kundennummer für Artikel (Kondition)';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LHM_EAN" is 'EAN für LHM';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LHM_GEWICHT_KG" is 'LHM Gewicht incl. Verpackung';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LHM_MENGE" is 'LHM = Kleinste Gebindemenge';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LHM_NAME" is 'Name des LHM z.B. K600 = Karton 600 aus LVS_LHM_CFG';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_BREITE_MAX" is 'Max Breite incl. Überstand';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_EAN" is 'EAN für eine Transporteinheit';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_GEWICHT_KG" is 'Max Gewicht der Transporteinheit (Gilt nur für Artikelreine Ttransporteinheit)';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_HOEHE_LAGE" is 'Höhe einer Lage (LHM''s)';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_HOEHE_MAX" is 'Max Höhe incl. Transporteinheit';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_LHM_LAGEN" is 'Anzahl Lagen (LHM''s) je LTE';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_LHM_MENGE" is 'Anzahl LHM je Transporteinheit';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_LHM_PRO_LAGE" is 'Anzahl LHM je Lage';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_MENGE" is 'Menge je Mengeneinheit pro. Transporteinheit';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_NAME" is 'EURO = Europalette, INDU = INDU-Palette, CHEPEURO = Chep-Europalette ... aus LVS_LTE_CFG';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."LTE_TIEFE_MAX" is 'Max Tiefe incl. Überstand';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."PACK_VORSCHR" is 'Verpackungsvorschrift';
comment on column DIRKSPZM32.S_ERP_RCV_ART_KD."SID" is 'SID';



-- sqlcl_snapshot {"hash":"5b2f15bada794b2fa6645b91228665d20335f41b","type":"COMMENT","name":"s_erp_rcv_art_kd","schemaName":"dirkspzm32","sxml":""}