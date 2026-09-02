comment on table DW_LVS_BESTAND is 'Data-Warehouse Lager-Bestand';
comment on column DW_LVS_BESTAND."ANZ_LAM" is 'Anzahl der Behälter';
comment on column DW_LVS_BESTAND."ANZ_LTE" is 'Anzahl der LTEs. Bei Mischpal. z.B. zwei Artikel auf einer LTE SUM_LTE = 0,5';
comment on column DW_LVS_BESTAND."ARTIKEL_ID" is 'Artikel';
comment on column DW_LVS_BESTAND."BASIS_LTE_NAME" is 'Basistyp der LTE';
comment on column DW_LVS_BESTAND."CHARGE_ID" is 'Chargen-Nr.';
comment on column DW_LVS_BESTAND."DW_STAT_ID" is 'Laufende Nummer';
comment on column DW_LVS_BESTAND."ERFASST_AM" is 'Zeitpunkt der Erfassung';
comment on column DW_LVS_BESTAND."FA_AG" is 'Arbeitsgang';
comment on column DW_LVS_BESTAND."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DW_LVS_BESTAND."LABOR_STATUS" is 'Laborstatus';
comment on column DW_LVS_BESTAND."LEITZAHL" is 'Leitzahl';
comment on column DW_LVS_BESTAND."LGR_ORT" is 'Lagerort';
comment on column DW_LVS_BESTAND."LTE_NAME" is 'Beschreibung / Text der LTE';
comment on column DW_LVS_BESTAND."LTE_STATUS" is 'Status der LTE (z.B. LF)';
comment on column DW_LVS_BESTAND."MENGE_BASIS" is 'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';
comment on column DW_LVS_BESTAND."MENGENEINHEIT_BASIS" is 'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';
comment on column DW_LVS_BESTAND."MHD" is 'Mindest-Haltbarkeits-Datum';
comment on column DW_LVS_BESTAND."SID" is 'Datenbank für Konsolidierung';
comment on column DW_LVS_BESTAND."STAT_NAME" is 'Name der Statistik z.B. HUF_DW_STATISITIK';
comment on column DW_LVS_BESTAND."SUM_MENGE" is 'Anzahl der Teile';
comment on column DW_LVS_BESTAND."WERT_DATUM" is 'Wert Datum nicht verwechseln mit Erfasst_am';
comment on column DW_LVS_BESTAND."WERT_DATUM_ENDE" is 'Wert Datum ende falls eine Zeitraum von Buchungen gemeint sind';



-- sqlcl_snapshot {"hash":"46769736ce4b6fc537a3190db80907515f3b4bb6","type":"COMMENT","name":"dw_lvs_bestand","schemaName":"dirkspzm32","sxml":""}