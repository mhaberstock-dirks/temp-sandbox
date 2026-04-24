create or replace editionable trigger dirkspzm32.tr_tms_loading_carrier before
    insert or update or delete on dirkspzm32.tms_loading_carrier
    for each row
begin
    if inserting then
        if :new.arrival_time is null then
            :new.arrival_time := sysdate;
        end if;

    end if;
end tr_s_sqd_sap_send_bew_biud;
/

alter trigger dirkspzm32.tr_tms_loading_carrier enable;


-- sqlcl_snapshot {"hash":"8263cc9b041d20f54223065b26f1524396bde35a","type":"TRIGGER","name":"TR_TMS_LOADING_CARRIER","schemaName":"DIRKSPZM32","sxml":""}