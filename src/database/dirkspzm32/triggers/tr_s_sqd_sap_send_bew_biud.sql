
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_SQD_SAP_SEND_BEW_BIUD" 
  before insert or update or delete on s_sqd_sap_send_bew
  for each row
begin

  if inserting
  and :new.herkunft != 'ISI'
  and :new.ts is NULL then
    select seq_s_send_bew_id.nextval into :new.ts from dual;
  end if;
end TR_S_SQD_SAP_SEND_BEW_BIUD;


/
ALTER TRIGGER "TR_S_SQD_SAP_SEND_BEW_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"17b54cace9e60ac61a8be06f5fa989e78eea883d","type":"TRIGGER","name":"TR_S_SQD_SAP_SEND_BEW_BIUD","schemaName":"DIRKSPZM32","sxml":""}