create or replace editionable trigger dirkspzm32.tr_pzm_bereitschaft_cfg_bui before
    insert or update on dirkspzm32.pzm_bereitschaft_cfg
    for each row
declare begin
    if inserting then
        :new.created_date := sysdate;
        :new.created_user := current_isi_user();
    else
        :new.last_change_date := sysdate;
        :new.last_change_user := current_isi_user();
    end if;
end;
/

alter trigger dirkspzm32.tr_pzm_bereitschaft_cfg_bui enable;


-- sqlcl_snapshot {"hash":"296a25d517b5c9a0a19ef29354f3fe672f5ec35d","type":"TRIGGER","name":"TR_PZM_BEREITSCHAFT_CFG_BUI","schemaName":"DIRKSPZM32","sxml":""}