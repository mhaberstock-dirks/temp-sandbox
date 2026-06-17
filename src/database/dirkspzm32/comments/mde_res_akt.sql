comment on table DIRKSPZM32.MDE_RES_AKT is 'Maschinentabelle und aktueller Zustand';
comment on column DIRKSPZM32.MDE_RES_AKT."AKT_AUFGABE" is 'Akt. Aufgabe P=Produzieren R=Rüsten NULL=Kein Auftrag angemeldtet sonst P oder R Produktion oder Ruesten';
comment on column DIRKSPZM32.MDE_RES_AKT."AUFTRAG" is 'Aufragsnummer FA_NR+FA_AG+UPOS (Systemnummer) aktuell';
comment on column DIRKSPZM32.MDE_RES_AKT."CHANGE_DATE" is 'Geändert Datum / Zeit Trigger';
comment on column DIRKSPZM32.MDE_RES_AKT."CREATE_DATE" is 'Erstellt Datum / Zeit Trigger';
comment on column DIRKSPZM32.MDE_RES_AKT."FA_AG" is 'Arbeitsgang aktuell';
comment on column DIRKSPZM32.MDE_RES_AKT."FA_UPOS" is 'Pos / Folge (Splitt) aktuell';
comment on column DIRKSPZM32.MDE_RES_AKT."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.MDE_RES_AKT."LEITZAHL" is 'Fertigungsauftrag aktuell';
comment on column DIRKSPZM32.MDE_RES_AKT."LHM_ID_AKT" is 'Aktuelle Spule Produktion';
comment on column DIRKSPZM32.MDE_RES_AKT."LHM_ID_NEXT" is 'Nächste Spule FK_spulen_lhm_id';
comment on column DIRKSPZM32.MDE_RES_AKT."LHM_ID_RW_AKT" is 'Aktuelle Spule Leitermaterial';
comment on column DIRKSPZM32.MDE_RES_AKT."LHM_ID_RW_NEXT" is 'Nächste Spule Leitermaterial';
comment on column DIRKSPZM32.MDE_RES_AKT."MDE_BSTD_MIN" is 'Betriebsstunden in Min. gesamt';
comment on column DIRKSPZM32.MDE_RES_AKT."MDE_MENGE" is 'Menge in Meter aktueller FA';
comment on column DIRKSPZM32.MDE_RES_AKT."MDE_MENGE_T" is 'Menge in Meter (Tageszähler)';
comment on column DIRKSPZM32.MDE_RES_AKT."MDE_PROD_MIN" is 'Produktionszeit in Min.';
comment on column DIRKSPZM32.MDE_RES_AKT."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column DIRKSPZM32.MDE_RES_AKT."RES_NAME" is 'Maschinenname incl. Gang Bsp. F10_001';
comment on column DIRKSPZM32.MDE_RES_AKT."RES_STATUS" is '0 = Maschine läuft, -1 unbegründete Störung sonst Störungsnr';
comment on column DIRKSPZM32.MDE_RES_AKT."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.MDE_RES_AKT."STATUS" is 'N = Neu
								I = ISI hat geändert
								M = MDE Manager hat geändert
								UE = Änderung ist übernommen';



-- sqlcl_snapshot {"hash":"b72f58a94c159ec8a9ae25a7ceadf86f758af4b6","type":"COMMENT","name":"mde_res_akt","schemaName":"dirkspzm32","sxml":""}