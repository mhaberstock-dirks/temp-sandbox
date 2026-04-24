create or replace editionable trigger dirkspzm32.tr_s_rcv_fa_auf_fhm_buid before
    insert or delete on dirkspzm32.s_rcv_fa_auf_fhm
    for each row
declare
    v_found boolean;
begin
    if inserting then
        insert into bde_fa_auftrag_fhm values ( :new.sid,          -- v_sid,
                                                :new.firma_nr,     -- v_firma_nr,
                                                :new.auf_id,       -- v_abnr,
                                                :new.leitzahl,     -- v_leitzahl,
                                                :new.fa_ag,        -- v_fa_ag,
                                                :new.fa_upos,      -- v_fa_upos,
                                                :new.prod_fhm,     -- v_prod_fhm
                                                :new.fhm_grp,     -- v_fhm_grp
                                                :new.anz_benoetigt );    -- Anzahl der benötigten FHMs
    else -- delete
        delete bde_fa_auftrag_fhm t
        where
                t.sid = :old.sid
            and t.firma_nr = :old.firma_nr
            and t.leitzahl = :old.leitzahl
            and t.fa_ag = :old.fa_ag
            and t.fa_upos = :old.fa_upos
            and t.prod_fhm = :old.prod_fhm;

        delete isi_res_fhm t
        where
                t.sid = :old.sid
            and t.firma_nr = :old.firma_nr
            and t.fhm = :old.prod_fhm
            and t.dyn_gen = c.c_true
            and not exists (
                select
                    x.prod_fhm
                from
                    bde_fa_auftrag_fhm x
                where
                        x.sid = :old.sid
                    and x.firma_nr = :old.firma_nr
                    and x.prod_fhm = :old.prod_fhm
            );

    end if;
end;
/

alter trigger dirkspzm32.tr_s_rcv_fa_auf_fhm_buid enable;


-- sqlcl_snapshot {"hash":"8f2382805d32d1c571ccacb73e5cae22e0ca201d","type":"TRIGGER","name":"TR_S_RCV_FA_AUF_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}