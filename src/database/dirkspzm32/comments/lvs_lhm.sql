comment on table dirkspzm32.lvs_lhm is
    'Tabelle der Lagerhilfsmittel';

comment on column dirkspzm32.lvs_lhm.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lhm.komm_neu_lhm_name is
    'Neuer LHM Name, wenn kommissioniert werden soll';

comment on column dirkspzm32.lvs_lhm.komm_quell_lgr_platz is
    'Von diesem Lagerplatz wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';

comment on column dirkspzm32.lvs_lhm.komm_quell_lte_id is
    'Von dieser LTE ID wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';

comment on column dirkspzm32.lvs_lhm.lgr_platz is
    'Lagerplatz auf dem dieses LHM steht';

comment on column dirkspzm32.lvs_lhm.lhm_akt_kg is
    'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';

comment on column dirkspzm32.lvs_lhm.lhm_eti_druck_status is
    'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';

comment on column dirkspzm32.lvs_lhm.lhm_id is
    'Lagerhilfsmittel ID (Als Barcode auf dem Karton)';

comment on column dirkspzm32.lvs_lhm.lhm_letzte_buchung is
    'Datum und Zeit der letzten Buchung';

comment on column dirkspzm32.lvs_lhm.lhm_name is
    'Art der Lagerhilfsmittel Bsp.: K600 = ''Karton 600''';

comment on column dirkspzm32.lvs_lhm.lhm_vol is
    'Volumen in m3';

comment on column dirkspzm32.lvs_lhm.lhm_vol_breite is
    'Gesamtbreite des Lagerhilfsmittel in mm';

comment on column dirkspzm32.lvs_lhm.lhm_vol_hoehe is
    'Gesamthoehe des Lagerhilfsmittel in mm';

comment on column dirkspzm32.lvs_lhm.lhm_vol_tiefe is
    'Gesamttiefe des Lagerhilfsmittel in mm';

comment on column dirkspzm32.lvs_lhm.lte_id is
    'Transporteinheiten ID (Als Barcode auf der Palette)';

comment on column dirkspzm32.lvs_lhm.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"ebeefb79cbc06df7b290b4162c35fc3713e4a7d4","type":"COMMENT","name":"lvs_lhm","schemaName":"dirkspzm32","sxml":""}