
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_EUS_SAP_SEND_BEW_BI" 
  before insert on DIRKSPZM32.s_eus_sap_send_bew  
  for each row
declare
  -- local variables here
begin
  :new.b_date := to_date(:new.b_datum, 'dd.mm.yyyy hh24:mi:ss');
end tr_s_eus_sap_send_bew_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_EUS_SAP_SEND_BEW_BI" ENABLE;


-- sqlcl_snapshot {"hash":"a9dd3c46be31af6c528f1aa647278f38a989f01e","type":"TRIGGER","name":"TR_S_EUS_SAP_SEND_BEW_BI","schemaName":"DIRKSPZM32","sxml":""}