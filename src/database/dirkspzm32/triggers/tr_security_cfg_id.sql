create or replace editionable trigger dirkspzm32.tr_security_cfg_id before
    insert on dirkspzm32.isi_security_cfg
    for each row
declare
  -- local variables here
 begin
    if :new.sid is null then
        :new.sid := '01';
    end if;

    if :new.firma_nr is null then
        :new.firma_nr := 1;
    end if;

    if :new.security_cfg_id is null then
        select
            seq_security_cfg_id.nextval
        into :new.security_cfg_id
        from
            dual;

    end if;

end tr_security_cfg_id;
/

alter trigger dirkspzm32.tr_security_cfg_id enable;


-- sqlcl_snapshot {"hash":"7157df9e17f0eb9667bde4e0f6854a7112d95dd3","type":"TRIGGER","name":"TR_SECURITY_CFG_ID","schemaName":"DIRKSPZM32","sxml":""}