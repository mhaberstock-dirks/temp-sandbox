create or replace editionable trigger dirkspzm32.tr_rep_security_cfg_buid before
    insert or update or delete on dirkspzm32.rep_security_cfg
    for each row
declare
  -- local variables here
 begin
    if inserting then
        select
            nvl(
                max(rep_security_cfg_id),
                0
            ) + 1
        into :new.rep_security_cfg_id
        from
            rep_security_cfg
        where
            rep_id = :new.rep_id;

    end if;
end tr_rep_security_cfg_buid;
/

alter trigger dirkspzm32.tr_rep_security_cfg_buid enable;


-- sqlcl_snapshot {"hash":"ee6a0cf7e43d67d7b6cc173129c914516a4da5f9","type":"TRIGGER","name":"TR_REP_SECURITY_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}