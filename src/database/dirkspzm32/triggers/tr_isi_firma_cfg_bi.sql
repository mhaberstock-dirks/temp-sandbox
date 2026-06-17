
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_FIRMA_CFG_BI" 
  before insert on DIRKSPZM32.ISI_FIRMA_CFG
for each row
declare
  -- local variables here
begin
  if :new.firma_cfg_id is NULL then
     select seq_isi_firma_cfg_ID.nextval into :new.firma_cfg_ID from dual;
  end if;
  if :new.user_edit is NULL
  then
    :new.user_edit := 'F';
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_FIRMA_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"ee6b20f43c47e0e258af0efe2a40ea4681e01c10","type":"TRIGGER","name":"TR_ISI_FIRMA_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}