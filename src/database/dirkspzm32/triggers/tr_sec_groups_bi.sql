create or replace editionable trigger dirkspzm32.tr_sec_groups_bi before
    insert on dirkspzm32.sec_groups
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

    if :new.group_id is null then
        select
            seq_group_id.nextval
        into :new.group_id
        from
            dual;

    end if;

end tr_sec_groups_bi;
/

alter trigger dirkspzm32.tr_sec_groups_bi enable;


-- sqlcl_snapshot {"hash":"56eb9649c9666afd037932f1ebed51f81de070f0","type":"TRIGGER","name":"TR_SEC_GROUPS_BI","schemaName":"DIRKSPZM32","sxml":""}