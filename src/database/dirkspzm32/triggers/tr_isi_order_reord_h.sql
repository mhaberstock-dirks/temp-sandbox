create or replace editionable trigger dirkspzm32.tr_isi_order_reord_h before
    insert on dirkspzm32.isi_order_reord_h
    for each row
declare
  -- local variables here
 begin
    if inserting then
        if :new.reord_id is null then
            select
                seq_reord_id.nextval
            into :new.reord_id
            from
                dual;

        end if;

    end if;
end tr_isi_order_reord_h;
/

alter trigger dirkspzm32.tr_isi_order_reord_h enable;


-- sqlcl_snapshot {"hash":"ebadcdeb522edf5db4a83b4c1caa232555e2b46e","type":"TRIGGER","name":"TR_ISI_ORDER_REORD_H","schemaName":"DIRKSPZM32","sxml":""}