
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RES_LEISTUNG_CFG_BI" 
  before insert on isi_res_leistung_cfg
  for each row
declare
  -- local variables here
begin
  if :new.res_l_cfg_id is NULL
  then
    select SEQ_ISI_RES_LEISTUNG_CFG.NEXTVAL into :new.res_l_cfg_id from dual;
  end if;
end TR_isi_res_leistung_cfg_BI;


/
ALTER TRIGGER "TR_ISI_RES_LEISTUNG_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"c5f6a16699ff57695d5561d3c5221524244b1197","type":"TRIGGER","name":"TR_ISI_RES_LEISTUNG_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}