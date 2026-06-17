
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RES_LEISTUNG_CFG_BI" 
  before insert on DIRKSPZM32.isi_res_leistung_cfg
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RES_LEISTUNG_CFG_BI" ENABLE;


-- sqlcl_snapshot {"hash":"a7308b0c2fc1cfb046241945fc07a1abc83b9b4e","type":"TRIGGER","name":"TR_ISI_RES_LEISTUNG_CFG_BI","schemaName":"DIRKSPZM32","sxml":""}