create or replace editionable trigger dirkspzm32.tr_s_erp_send_bew_bi before
    insert on dirkspzm32.s_erp_send_bew
    for each row
declare begin
    if inserting then
        if :new.herkunft is null then
            :new.herkunft := 'ISI';
        end if;

    end if;
end tr_s_erp_send_bew_bi;
/

alter trigger dirkspzm32.tr_s_erp_send_bew_bi enable;


-- sqlcl_snapshot {"hash":"565d3c45ca0486596710c9cec403bb8337dd5407","type":"TRIGGER","name":"TR_S_ERP_SEND_BEW_BI","schemaName":"DIRKSPZM32","sxml":""}