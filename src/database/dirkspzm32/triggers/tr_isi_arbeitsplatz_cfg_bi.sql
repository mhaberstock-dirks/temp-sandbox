
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_ARBEITSPLATZ_CFG_BI" 
  before insert on isi_arbeitsplatz_cfg
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
ALTER TRIGGER "TR_ISI_ARBEITSPLATZ_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"8085545e6f7156e4c19fe9d31504ac81c406a261","type":"TRIGGER","name":"TR_ISI_ARBEITSPLATZ_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}