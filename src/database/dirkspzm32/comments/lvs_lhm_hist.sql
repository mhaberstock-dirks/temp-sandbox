comment on table dirkspzm32.lvs_lhm_hist is
    'Tabelle der Lagerhilfsmittel HISTORY';

comment on column dirkspzm32.lvs_lhm_hist.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lhm_hist.komm_neu_lhm_name is
    'Neuer LHM Name, wenn kommissioniert werden soll';

comment on column dirkspzm32.lvs_lhm_hist.komm_quell_lgr_platz is
    'Von diesem Lagerplatz wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';

comment on column dirkspzm32.lvs_lhm_hist.komm_quell_lte_id is
    'Von dieser LTE ID wurde die Menge in dieser LHM oder die ganze LHM abkommissioniert';

comment on column dirkspzm32.lvs_lhm_hist.lgr_platz is
    'Lagerplatz auf dem dieses LHM steht';

comment on column dirkspzm32.lvs_lhm_hist.lhm_akt_kg is
    'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';

comment on column dirkspzm32.lvs_lhm_hist.lhm_eti_druck_status is
    'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';

comment on column dirkspzm32.lvs_lhm_hist.lhm_id is
    'Lagerhilfsmittel ID (Als Barcode auf dem Karton)';

comment on column dirkspzm32.lvs_lhm_hist.lhm_letzte_buchung is
    'Datum und Zeit der letzten Buchung';

comment on column dirkspzm32.lvs_lhm_hist.lhm_name is
    'Art der Lagerhilfsmittel Bsp.: K600 = ''Karton 600''';

comment on column dirkspzm32.lvs_lhm_hist.lhm_vol is
    'Volumen in m3';

comment on column dirkspzm32.lvs_lhm_hist.lhm_vol_breite is
    'Gesamtbreite des Lagerhilfsmittel in mm';

comment on column dirkspzm32.lvs_lhm_hist.lhm_vol_hoehe is
    'Gesamthoehe des Lagerhilfsmittel in mm';

comment on column dirkspzm32.lvs_lhm_hist.lhm_vol_tiefe is
    'Gesamttiefe des Lagerhilfsmittel in mm';

comment on column dirkspzm32.lvs_lhm_hist.lte_id is
    'Transporteinheiten ID (Als Barcode auf der Palette)';

comment on column dirkspzm32.lvs_lhm_hist.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"7053419b4cab3af5def3c31a292df55cf0795951","type":"COMMENT","name":"lvs_lhm_hist","schemaName":"dirkspzm32","sxml":""}