comment on table LVS_LHM is 'Tabelle der Lagerhilfsmittel';
comment on column LVS_LHM."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column LVS_LHM."KOMM_NEU_LHM_NAME" is 'Neuer LHM Name, wenn kommissioniert werden soll';
comment on column LVS_LHM."KOMM_QUELL_LGR_PLATZ" is 'Von diesem Lagerplatz wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';
comment on column LVS_LHM."KOMM_QUELL_LTE_ID" is 'Von dieser LTE ID wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';
comment on column LVS_LHM."LGR_PLATZ" is 'Lagerplatz auf dem dieses LHM steht';
comment on column LVS_LHM."LHM_AKT_KG" is 'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';
comment on column LVS_LHM."LHM_ETI_DRUCK_STATUS" is 'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';
comment on column LVS_LHM."LHM_ID" is 'Lagerhilfsmittel ID (Als Barcode auf dem Karton)';
comment on column LVS_LHM."LHM_LETZTE_BUCHUNG" is 'Datum und Zeit der letzten Buchung';
comment on column LVS_LHM."LHM_NAME" is 'Art der Lagerhilfsmittel Bsp.: K600 = ''Karton 600''';
comment on column LVS_LHM."LHM_VOL" is 'Volumen in m3';
comment on column LVS_LHM."LHM_VOL_BREITE" is 'Gesamtbreite des Lagerhilfsmittel in mm';
comment on column LVS_LHM."LHM_VOL_HOEHE" is 'Gesamthoehe des Lagerhilfsmittel in mm';
comment on column LVS_LHM."LHM_VOL_TIEFE" is 'Gesamttiefe des Lagerhilfsmittel in mm';
comment on column LVS_LHM."LTE_ID" is 'Transporteinheiten ID (Als Barcode auf der Palette)';
comment on column LVS_LHM."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"46769c409c2f559ad32f461263127f8224d97c1a","type":"COMMENT","name":"lvs_lhm","schemaName":"dirkspzm32","sxml":""}