create or replace editionable trigger dirkspzm32.tr_isi_land_region_biu before
    insert or update on dirkspzm32.isi_land_region
    for each row
declare

  -- local variables here
 begin
    if :new.region_id is null then
        select
            seq_isi_land_region.nextval
        into :new.region_id
        from
            dual;

    end if;

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

alter trigger dirkspzm32.tr_isi_land_region_biu enable;


-- sqlcl_snapshot {"hash":"ae6c58a08c736612139da5ed33e92d7a42c3d417","type":"TRIGGER","name":"TR_ISI_LAND_REGION_BIU","schemaName":"DIRKSPZM32","sxml":""}