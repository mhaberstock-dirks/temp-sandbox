comment on table BDE_FA_AUFTRAG_LTE_POOL is 'Reservierte LTE_NR für diesen Auftag - Losgoesse 1 LTE';
comment on column BDE_FA_AUFTRAG_LTE_POOL."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column BDE_FA_AUFTRAG_LTE_POOL."LEITZAHL" is 'Leitzahl Fertigungsauftragsnummer ';
comment on column BDE_FA_AUFTRAG_LTE_POOL."LTE_ID" is 'LTE Nummer';
comment on column BDE_FA_AUFTRAG_LTE_POOL."LTE_LFDN" is 'Laufende Nummer im Auftag -- Ggf. für Pärchenbildung';
comment on column BDE_FA_AUFTRAG_LTE_POOL."LTE_VERWENDET" is 'Wird die Nummer Verwendet ''F''rei, ''R''eserviert , ''V''erbraucht als echtes LTE gebucht, ''A'' = abgeschlossen';
comment on column BDE_FA_AUFTRAG_LTE_POOL."SID" is 'Datenbank für Konsolidierung';
comment on column BDE_FA_AUFTRAG_LTE_POOL."STATUS" is 'N = Neu, D = Gedruckt, UE = Übertragen an z.B. QS System';



-- sqlcl_snapshot {"hash":"358800f6d3b6940699c829706a1865772aea9858","type":"COMMENT","name":"bde_fa_auftrag_lte_pool","schemaName":"dirkspzm32","sxml":""}