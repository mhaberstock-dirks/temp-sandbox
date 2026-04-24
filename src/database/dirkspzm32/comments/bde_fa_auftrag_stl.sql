comment on table dirkspzm32.bde_fa_auftrag_stl is
    'Relation Arbeitsgang - Stückliste';

comment on column dirkspzm32.bde_fa_auftrag_stl.fa_ag is
    'Arbeitsgang des Auftrags';

comment on column dirkspzm32.bde_fa_auftrag_stl.fa_ag_stl_id is
    'Eindeutige Nummer aus Sequence für diese Zuordnung (AG -> STL)';

comment on column dirkspzm32.bde_fa_auftrag_stl.fa_upos is
    'Unterposition des Arbeitsgangs';

comment on column dirkspzm32.bde_fa_auftrag_stl.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_fa_auftrag_stl.leitzahl is
    'Leitzahl Fertigungsauftragsnummer ';

comment on column dirkspzm32.bde_fa_auftrag_stl.ma_fa_ag is
    'Arbeitsgang des Auftrags des Stücklisteneintrags (MA-Eintrag)';

comment on column dirkspzm32.bde_fa_auftrag_stl.ma_fa_upos is
    'Unterposition des Arbeitsgangs des Stücklisteneintrags (MA-Eintrag)';

comment on column dirkspzm32.bde_fa_auftrag_stl.ma_res_id is
    'RES_ID der Magazinressource oder Magazingruppe (RES_TYP: MA, MAG)';

comment on column dirkspzm32.bde_fa_auftrag_stl.prod_menge_ix is
    'Index, falls die STL-Position vereinzelt werden soll';

comment on column dirkspzm32.bde_fa_auftrag_stl.prod_menge_p_einheit is
    'Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG';

comment on column dirkspzm32.bde_fa_auftrag_stl.prod_menge_p_einheit_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.bde_fa_auftrag_stl.prod_reihenfolge is
    'Produktionsreihenfolge (In dieser Reihenfolge wird diese Stücklisteneintrag in der Produktion verarbeitet)';

comment on column dirkspzm32.bde_fa_auftrag_stl.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_fa_auftrag_stl.stueckliste_pos_id is
    'Stückliste Pos ID aus Plan oder PPS-Auftrag';

comment on column dirkspzm32.bde_fa_auftrag_stl.stueckliste_pos_nr is
    'Stückliste Pos NR aus Plan oder PPS-Auftrag';


-- sqlcl_snapshot {"hash":"6193ba98b3ef39cb88b4dae5ff41c3a5b42778a0","type":"COMMENT","name":"bde_fa_auftrag_stl","schemaName":"dirkspzm32","sxml":""}