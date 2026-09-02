comment on table BDE_FA_AUFTRAG_RES_LISTE is 'Resourcenliste für diesen AG im Planauftrag';
comment on column BDE_FA_AUFTRAG_RES_LISTE."ABNR" is 'Eindeutige Nummer';
comment on column BDE_FA_AUFTRAG_RES_LISTE."FA_AG" is 'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';
comment on column BDE_FA_AUFTRAG_RES_LISTE."FA_UPOS" is 'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';
comment on column BDE_FA_AUFTRAG_RES_LISTE."FIRMA_NR" is 'Firma Nr.';
comment on column BDE_FA_AUFTRAG_RES_LISTE."LEITZAHL" is 'Auftragsnummer aus PPS_PLAN_AUFTRAG';
comment on column BDE_FA_AUFTRAG_RES_LISTE."MINUTEN" is 'Angabe,wie viele Minuten benötigt diese Alternativ-Ressource';
comment on column BDE_FA_AUFTRAG_RES_LISTE."MINUTEN_RUESTEN" is 'Zeitbedarf für Rüsten auf dieser Maschine in Minuten';
comment on column BDE_FA_AUFTRAG_RES_LISTE."RES_ID" is 'Resource(ngruppe), die für die Produktion eingesetzt werden soll';
comment on column BDE_FA_AUFTRAG_RES_LISTE."SID" is 'SID';



-- sqlcl_snapshot {"hash":"9513abc3ccc029dc9b634868a316f9a12f40098b","type":"COMMENT","name":"bde_fa_auftrag_res_liste","schemaName":"dirkspzm32","sxml":""}