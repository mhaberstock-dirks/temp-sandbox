comment on table dirkspzm32.dw_bde_prod_daten is
    'Data-Warehouse BDE-Produktionsdaten';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_anmelde_miniten is
    'In der Zeit angemeldet in Minuten';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_auftragswechsel is
    'Anzahl der Auftragswechsel ';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_datum_ende is
    'Endezeitpunkt für diesen Wert  z.B. 01.01.2008 15:59:59 ';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_datum_start is
    'Startzeitpunkt für diesen Wert  z.B. 01.01.2008 15:00:00';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_menge_b is
    'Menge B (2.Wahl)';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_menge_gut is
    'Menge Gut';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_menge_schrott is
    'Schrottmenge';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_prod_minuten is
    'In der Zeit Produziert in Minuten';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_ruest_minuten is
    'In der Zeit Gerüstet in Minuten';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_stoer_minuten is
    'In der Zeit Geastört in Minuten';

comment on column dirkspzm32.dw_bde_prod_daten.dw_bde_typ is
    'T = Tagesmenge je Stunde, M = Monatssumme je Stunde';

comment on column dirkspzm32.dw_bde_prod_daten.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.dw_bde_prod_daten.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"952f6eedb932caaa288866499cf53487731d3b6f","type":"COMMENT","name":"dw_bde_prod_daten","schemaName":"dirkspzm32","sxml":""}