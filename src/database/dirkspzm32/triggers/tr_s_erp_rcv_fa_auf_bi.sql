
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_BI" 
  before insert on DIRKSPZM32.S_ERP_RCV_FA_AUF  
  for each row
declare
  -- local variables here
begin
  :new.tsc := sysdate;
end tr_s_ERP_rcv_fa_auf_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_FA_AUF_BI" ENABLE;


-- sqlcl_snapshot {"hash":"344cdfc87492439583e1a60a9891c0a1da9cd32a","type":"TRIGGER","name":"TR_S_ERP_RCV_FA_AUF_BI","schemaName":"DIRKSPZM32","sxml":""}