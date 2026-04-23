create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_fa_auf_bi before
    insert on dirkspzm32.s_erp_rcv_fa_auf
    for each row
declare
  -- local variables here
 begin
    :new.tsc := sysdate;
end tr_s_erp_rcv_fa_auf_bi;
/

alter trigger dirkspzm32.tr_s_erp_rcv_fa_auf_bi enable;


-- sqlcl_snapshot {"hash":"22b880263e2db3e5b78ba46ef93f129b507632e2","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_BI","schemaName":"DIRKSPZM32","sxml":""}