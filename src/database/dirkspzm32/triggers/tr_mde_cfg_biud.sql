create or replace editionable trigger dirkspzm32.tr_mde_cfg_biud before
    insert or update or delete on dirkspzm32.mde_cfg
    for each row
declare
  -- local variables here
 begin
    if inserting then
        update isi_resource_zust_akt t
        set
            t.mde_communication = 'T'
        where
            t.res_id = :new.res_id;

    elsif updating then
        if :old.res_id != :new.res_id then
            update isi_resource_zust_akt t
            set
                t.mde_communication = 'F'
            where
                t.res_id = :old.res_id;

            update isi_resource_zust_akt t
            set
                t.mde_communication = 'T'
            where
                t.res_id = :new.res_id;

        end if;
    else
        update isi_resource_zust_akt t
        set
            t.mde_communication = 'F'
        where
            t.res_id = :old.res_id;

    end if;
end tr_mde_cfg_biud;
/

alter trigger dirkspzm32.tr_mde_cfg_biud enable;


-- sqlcl_snapshot {"hash":"0ce4b0f4078d55c22805d4ced1d2544a961ea943","type":"TRIGGER","name":"TR_MDE_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}