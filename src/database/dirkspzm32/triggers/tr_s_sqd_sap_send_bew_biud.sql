create or replace editionable trigger dirkspzm32.tr_s_sqd_sap_send_bew_biud before
    insert or update or delete on dirkspzm32.s_sqd_sap_send_bew
    for each row
begin
    if
        inserting
        and :new.herkunft != 'ISI'
        and :new.ts is null
    then
        select
            seq_s_send_bew_id.nextval
        into :new.ts
        from
            dual;

    end if;
end tr_s_sqd_sap_send_bew_biud;
/

alter trigger dirkspzm32.tr_s_sqd_sap_send_bew_biud enable;


-- sqlcl_snapshot {"hash":"8ff66be1b7a3258aabd66676f8321cc6e8f7b28d","type":"TRIGGER","name":"TR_S_SQD_SAP_SEND_BEW_BIUD","schemaName":"DIRKSPZM32","sxml":""}