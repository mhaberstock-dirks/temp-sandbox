create or replace force editionable view dirkspzm32.bde_v_fa_auftrag_ware (
    sid,
    firma_nr,
    leitzahl,
    fa_ag,
    ag_ist_mg,
    ag_ist_mg_b,
    ag_ist_mg_schrott,
    ag_ist_mg_ruesten,
    gutware
) as
    select
        t.sid,
        t.firma_nr,
        t.leitzahl,
        t.fa_ag,
        t.ag_ist_mg,
        t.ag_ist_mg_b,
        t.ag_ist_mg_schrott,
        t.ag_ist_mg_ruesten,
        t.ag_ist_mg - ( t.ag_ist_mg_b + t.ag_ist_mg_schrott + t.ag_ist_mg_ruesten ) as gutware
    from
        bde_fa_auftrag t;


-- sqlcl_snapshot {"hash":"61b5dc8960f28bbb0226cff841910c34a309d9ba","type":"VIEW","name":"BDE_V_FA_AUFTRAG_WARE","schemaName":"DIRKSPZM32","sxml":""}