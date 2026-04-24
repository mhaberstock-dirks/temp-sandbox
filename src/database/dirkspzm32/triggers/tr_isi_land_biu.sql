create or replace editionable trigger dirkspzm32.tr_isi_land_biu before
    insert or update on dirkspzm32.isi_land
    for each row
declare

  -- local variables here
 begin
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        if :new.created_login_id is null then
            :new.created_login_id := current_isi_user_login_id();
        end if;

    end if;

    if updating then
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        if :new.last_change_login_id is null then
            :new.last_change_login_id := current_isi_user_login_id();
        end if;

    end if;

end;
/

alter trigger dirkspzm32.tr_isi_land_biu enable;


-- sqlcl_snapshot {"hash":"977309721ec275044746aad0baaec807e710bf2c","type":"TRIGGER","name":"TR_ISI_LAND_BIU","schemaName":"DIRKSPZM32","sxml":""}