create or replace editionable trigger dirkspzm32.tr_lvs_serie_id_pos_biu before
    insert or update on dirkspzm32.lvs_serie_id_pos
    for each row
begin
    if updating
    or inserting then
        if inserting then
            if nvl(:new.serie_id_lfdn,
                   0) = 0 then
                select
                    seq_serie_id_lfdn.nextval
                into :new.serie_id_lfdn
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
end tr_lvs_serie_id_pos_biu;
/

alter trigger dirkspzm32.tr_lvs_serie_id_pos_biu enable;


-- sqlcl_snapshot {"hash":"40f3b819a24c1a1b680e836f5db634d433cc9c65","type":"TRIGGER","name":"TR_LVS_SERIE_ID_POS_BIU","schemaName":"DIRKSPZM32","sxml":""}