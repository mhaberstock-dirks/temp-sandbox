create or replace editionable trigger dirkspzm32.tr_abwesenheits_antr_biu before
    insert or update on dirkspzm32.pzm_abwesenheits_antr
    for each row
declare
  -- local variables here
 begin
    :new.au_datum := sysdate;
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        :new.created_login_id := nvl(
            current_isi_user_login_id(), -1
        );
    --:new.created_user := current_isi_user();
    else
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        :new.last_change_login_id := nvl(
            current_isi_user_login_id(), -1
        );
    --:new.last_change_user := current_isi_user();
    end if;

end tr_antr_urlaub_biu;
/

alter trigger dirkspzm32.tr_abwesenheits_antr_biu enable;


-- sqlcl_snapshot {"hash":"d01d9b3d0eef7aba1f614b3edbd3774f8601b304","type":"TRIGGER","name":"TR_ABWESENHEITS_ANTR_BIU","schemaName":"DIRKSPZM32","sxml":""}