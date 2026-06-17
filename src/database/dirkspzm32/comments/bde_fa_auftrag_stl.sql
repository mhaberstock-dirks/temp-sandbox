comment on table DIRKSPZM32.BDE_FA_AUFTRAG_STL is 'Relation Arbeitsgang - Stückliste';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."FA_AG" is 'Arbeitsgang des Auftrags';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."FA_AG_STL_ID" is 'Eindeutige Nummer aus Sequence für diese Zuordnung (AG -> STL)';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."FA_UPOS" is 'Unterposition des Arbeitsgangs';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."LEITZAHL" is 'Leitzahl Fertigungsauftragsnummer ';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."MA_FA_AG" is 'Arbeitsgang des Auftrags des Stücklisteneintrags (MA-Eintrag)';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."MA_FA_UPOS" is 'Unterposition des Arbeitsgangs des Stücklisteneintrags (MA-Eintrag)';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."MA_RES_ID" is 'RES_ID der Magazinressource oder Magazingruppe (RES_TYP: MA, MAG)';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."PROD_MENGE_IX" is 'Index, falls die STL-Position vereinzelt werden soll';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."PROD_MENGE_P_EINHEIT" is 'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."PROD_MENGE_P_EINHEIT_OP" is '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."PROD_REIHENFOLGE" is 'Produktionsreihenfolge (In dieser Reihenfolge wird diese Stücklisteneintrag in der Produktion verarbeitet)';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."STUECKLISTE_POS_ID" is 'Stückliste Pos ID aus Plan oder PPS-Auftrag';
comment on column DIRKSPZM32.BDE_FA_AUFTRAG_STL."STUECKLISTE_POS_NR" is 'Stückliste Pos NR aus Plan oder PPS-Auftrag';



-- sqlcl_snapshot {"hash":"a10d92088918d4665411cf6df6296bffaf4cad8b","type":"COMMENT","name":"bde_fa_auftrag_stl","schemaName":"dirkspzm32","sxml":""}