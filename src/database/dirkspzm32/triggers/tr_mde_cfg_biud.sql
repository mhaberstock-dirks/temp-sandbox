
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_MDE_CFG_BIUD" 
  before Insert or Update or Delete on DIRKSPZM32.mde_cfg
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    update isi_resource_zust_akt t
       set t.mde_communication = 'T'
     where t.res_id = :new.res_id;
  elsif updating
  then
    if :old.res_id != :new.res_id
    then
      update isi_resource_zust_akt t
         set t.mde_communication = 'F'
       where t.res_id = :old.res_id;

      update isi_resource_zust_akt t
         set t.mde_communication = 'T'
       where t.res_id = :new.res_id;
    end if;
  else
    update isi_resource_zust_akt t
       set t.mde_communication = 'F'
     where t.res_id = :old.res_id;
  end if;
end tr_mde_cfg_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_MDE_CFG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"d2cd420017a05cc9115fbb012e12e07575fb1a53","type":"TRIGGER","name":"TR_MDE_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}