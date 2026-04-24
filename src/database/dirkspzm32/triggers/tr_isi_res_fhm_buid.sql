create or replace editionable trigger dirkspzm32.tr_isi_res_fhm_buid before
    insert or delete on dirkspzm32.isi_res_fhm
    for each row
declare
    v_found boolean;
begin
    if inserting then
        null;
    else -- delete
        delete isi_res_fhm_list t
        where
            t.fhm = :old.fhm;

    end if;
end;
/

alter trigger dirkspzm32.tr_isi_res_fhm_buid enable;


-- sqlcl_snapshot {"hash":"69b261ff20c1ca651431f4baf58d8f9a7bfb3e3b","type":"TRIGGER","name":"TR_ISI_RES_FHM_BUID","schemaName":"DIRKSPZM32","sxml":""}