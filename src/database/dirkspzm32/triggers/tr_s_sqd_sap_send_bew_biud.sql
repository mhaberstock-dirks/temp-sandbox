
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_SQD_SAP_SEND_BEW_BIUD" 
  before insert or update or delete on DIRKSPZM32.s_sqd_sap_send_bew
  for each row
begin

  if inserting
  and :new.herkunft != 'ISI'
  and :new.ts is NULL then
    select seq_s_send_bew_id.nextval into :new.ts from dual;
  end if;
end TR_S_SQD_SAP_SEND_BEW_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_SQD_SAP_SEND_BEW_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"12bc04d393bcb21641aeb8d192e1711a85f6b1bf","type":"TRIGGER","name":"TR_S_SQD_SAP_SEND_BEW_BIUD","schemaName":"DIRKSPZM32","sxml":""}