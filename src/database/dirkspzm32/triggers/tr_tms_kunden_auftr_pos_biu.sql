create or replace editionable trigger dirkspzm32.tr_tms_kunden_auftr_pos_biu before
    insert or update on dirkspzm32.tms_kunden_auftr_pos
    for each row
declare
  -- local variables here
 begin
    if updating
    or inserting then
        if inserting then
            if :new.erz_datum is null then
                :new.erz_datum := sysdate;
            end if;

            if :new.erz_login_id is null then
                :new.erz_login_id := -1;
            end if;

        end if;

        if updating then
            if :new.aend_datum = :old.aend_datum
            or :new.aend_datum is null then
                :new.aend_datum := sysdate;
            end if;

        end if;

    end if;
end;
/

alter trigger dirkspzm32.tr_tms_kunden_auftr_pos_biu enable;


-- sqlcl_snapshot {"hash":"0c77a0b46079e4a958d5947788d05d190f643954","type":"TRIGGER","name":"TR_TMS_KUNDEN_AUFTR_POS_BIU","schemaName":"DIRKSPZM32","sxml":""}