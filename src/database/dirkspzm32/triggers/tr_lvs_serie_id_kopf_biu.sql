create or replace editionable trigger dirkspzm32.tr_lvs_serie_id_kopf_biu before
    insert or update on dirkspzm32.lvs_serie_id_kopf
    for each row
begin
    if updating
    or inserting then
        if inserting then
            if nvl(:new.serie_id,
                   0) = 0 then
                select
                    seq_serie_id.nextval
                into :new.serie_id
                from
                    dual;

            end if;

            if :new.created_date is null then
                :new.created_date := sysdate;
            end if;

            if :new.created_login_id is null then
                :new.created_login_id := -1;
            end if;

        end if;

        if updating then
            if :new.last_change_date = :old.last_change_date
            or :new.last_change_date is null then
                :new.last_change_date := sysdate;
            end if;

        end if;

    end if;
end tr_lvs_serie_id_kopf_biu;
/

alter trigger dirkspzm32.tr_lvs_serie_id_kopf_biu enable;


-- sqlcl_snapshot {"hash":"45efc72634c75640240924789c00d1d63b990070","type":"TRIGGER","name":"TR_LVS_SERIE_ID_KOPF_BIU","schemaName":"DIRKSPZM32","sxml":""}