create or replace editionable trigger dirkspzm32.tr_s_eus_sap_send_bew_bi before
    insert on dirkspzm32.s_eus_sap_send_bew
    for each row
declare
  -- local variables here
 begin
    :new.b_date := to_date ( :new.b_datum,
    'dd.mm.yyyy hh24:mi:ss' );
end tr_s_eus_sap_send_bew_bi;
/

alter trigger dirkspzm32.tr_s_eus_sap_send_bew_bi enable;


-- sqlcl_snapshot {"hash":"f0cc9ad7773b0aba57dff7561dcc4493391db985","type":"TRIGGER","name":"TR_S_EUS_SAP_SEND_BEW_BI","schemaName":"DIRKSPZM32","sxml":""}