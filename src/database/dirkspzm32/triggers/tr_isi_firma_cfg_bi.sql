
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_FIRMA_CFG_BI" 
  before insert on ISI_FIRMA_CFG
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
ALTER TRIGGER "TR_ISI_FIRMA_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"a281d722e045cc96acaa404726cc7b65443f8064","type":"TRIGGER","name":"TR_ISI_FIRMA_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}