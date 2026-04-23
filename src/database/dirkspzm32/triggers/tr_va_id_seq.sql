create or replace editionable trigger dirkspzm32.tr_va_id_seq before
    insert on dirkspzm32.pzm_vertragsarten
    for each row
declare
  -- local variables here
 begin
    if :new.va_id is null then
        select
            seq_va_id.nextval
        into :new.va_id
        from
            dual;

    end if;
end tr_va_id_seq;
/

alter trigger dirkspzm32.tr_va_id_seq enable;


-- sqlcl_snapshot {"hash":"2bc30b4e8842658c297db57395dce3b1ebac89ac","type":"TRIGGER","name":"TR_VA_ID_SEQ","schemaName":"DIRKSPZM32","sxml":""}