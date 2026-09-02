
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_BEREITSCHAFT_CFG_BUI" 
  before insert or update on pzm_bereitschaft_cfg
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
ALTER TRIGGER "TR_PZM_BEREITSCHAFT_CFG_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"1618e3c81d35a30e6501aa6ad446feddfb4a4a84","type":"TRIGGER","name":"TR_PZM_BEREITSCHAFT_CFG_BUI","schemaName":"DIRKSPZM32","sxml":""}