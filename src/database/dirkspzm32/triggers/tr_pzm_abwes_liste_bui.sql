create or replace editionable trigger dirkspzm32.tr_pzm_abwes_liste_bui before
    insert or update on dirkspzm32.pzm_abwes_liste
    for each row
declare begin
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        :new.created_user := current_isi_user();
    else
        if :new.last_change_date is null then
            :new.last_change_date := sysdate;
        end if;

        :new.last_change_user := current_isi_user();
    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_abwes_liste_bui enable;


-- sqlcl_snapshot {"hash":"220f29a286d77ab18d6b818db20dc5ffd32328f2","type":"TRIGGER","name":"TR_PZM_ABWES_LISTE_BUI","schemaName":"DIRKSPZM32","sxml":""}