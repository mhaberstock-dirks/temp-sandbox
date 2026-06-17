
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_BEREITSCHAFT_CFG_BUI" 
  before insert or update on DIRKSPZM32.pzm_bereitschaft_cfg
  for each row
declare
begin

  if inserting
  then
    :new.created_date := sysdate;
    :new.created_user := current_isi_user();
  else
    :new.last_change_date := sysdate;
    :new.last_change_user := current_isi_user();
  end if;


end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_BEREITSCHAFT_CFG_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"ade9420820c4d65235a3effdc2fbe51ad3a79bf9","type":"TRIGGER","name":"TR_PZM_BEREITSCHAFT_CFG_BUI","schemaName":"DIRKSPZM32","sxml":""}