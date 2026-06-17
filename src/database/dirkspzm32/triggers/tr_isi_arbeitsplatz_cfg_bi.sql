
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ARBEITSPLATZ_CFG_BI" 
  before insert on DIRKSPZM32.isi_arbeitsplatz_cfg
  for each row
declare
  -- local variables here
begin
  if :new.app_cfg_id is null
  then
    select seq_isi_arbeitsplatz_cfg_id.nextval
      into :new.app_cfg_id
      from dual;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ARBEITSPLATZ_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"5d7c29f41a6260ef7e4e2981aaba416bf1727d63","type":"TRIGGER","name":"TR_ISI_ARBEITSPLATZ_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}