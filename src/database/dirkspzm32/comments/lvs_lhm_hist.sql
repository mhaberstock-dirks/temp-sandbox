comment on table DIRKSPZM32.LVS_LHM_HIST is 'Tabelle der Lagerhilfsmittel HISTORY';
comment on column DIRKSPZM32.LVS_LHM_HIST."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LHM_HIST."KOMM_NEU_LHM_NAME" is 'Neuer LHM Name, wenn kommissioniert werden soll';
comment on column DIRKSPZM32.LVS_LHM_HIST."KOMM_QUELL_LGR_PLATZ" is 'Von diesem Lagerplatz wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';
comment on column DIRKSPZM32.LVS_LHM_HIST."KOMM_QUELL_LTE_ID" is 'Von dieser LTE ID wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';
comment on column DIRKSPZM32.LVS_LHM_HIST."LGR_PLATZ" is 'Lagerplatz auf dem dieses LHM steht';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_AKT_KG" is 'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_ETI_DRUCK_STATUS" is 'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_ID" is 'Lagerhilfsmittel ID (Als Barcode auf dem Karton)';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_LETZTE_BUCHUNG" is 'Datum und Zeit der letzten Buchung';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_NAME" is 'Art der Lagerhilfsmittel Bsp.: K600 = ''Karton 600''';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_VOL" is 'Volumen in m3';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_VOL_BREITE" is 'Gesamtbreite des Lagerhilfsmittel in mm';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_VOL_HOEHE" is 'Gesamthoehe des Lagerhilfsmittel in mm';
comment on column DIRKSPZM32.LVS_LHM_HIST."LHM_VOL_TIEFE" is 'Gesamttiefe des Lagerhilfsmittel in mm';
comment on column DIRKSPZM32.LVS_LHM_HIST."LTE_ID" is 'Transporteinheiten ID (Als Barcode auf der Palette)';
comment on column DIRKSPZM32.LVS_LHM_HIST."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"5e24c45ca927a5e6d8f360689676b530fc317c5b","type":"COMMENT","name":"lvs_lhm_hist","schemaName":"dirkspzm32","sxml":""}