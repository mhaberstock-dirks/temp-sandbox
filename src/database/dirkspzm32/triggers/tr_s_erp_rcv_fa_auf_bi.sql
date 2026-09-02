
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_ERP_RCV_FA_AUF_BI" 
  before insert on S_ERP_RCV_FA_AUF  
  for each row
declare
  -- local variables here
begin
  :new.tsc := sysdate;
end tr_s_ERP_rcv_fa_auf_bi;


/
ALTER TRIGGER "TR_S_ERP_RCV_FA_AUF_BI" ENABLE;


-- sqlcl_snapshot {"hash":"75c7c002f9afda5e97af5496804b43e38e9477db","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_BI","schemaName":"DIRKSPZM32","sxml":""}