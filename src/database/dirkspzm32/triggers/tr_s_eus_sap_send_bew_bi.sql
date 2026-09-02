
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_EUS_SAP_SEND_BEW_BI" 
  before insert on s_eus_sap_send_bew  
  for each row
declare
  -- local variables here
begin
  :new.b_date := to_date(:new.b_datum, 'dd.mm.yyyy hh24:mi:ss');
end tr_s_eus_sap_send_bew_bi;


/
ALTER TRIGGER "TR_S_EUS_SAP_SEND_BEW_BI" ENABLE;


-- sqlcl_snapshot {"hash":"6947f498575f09c2868488017f189487cb3ed267","type":"TRIGGER","name":"TR_S_EUS_SAP_SEND_BEW_BI","schemaName":"DIRKSPZM32","sxml":""}