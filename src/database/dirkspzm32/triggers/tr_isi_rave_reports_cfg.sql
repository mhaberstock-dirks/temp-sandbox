
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RAVE_REPORTS_CFG" 
  before insert on DIRKSPZM32.isi_rave_reports_cfg
  for each row
declare
  -- local variables here
begin
  if :new.sid is NULL then
    :new.sid := '01';
  end if;

  if :new.firma_nr is NULL then
    :new.firma_nr := 1;
  end if;
end tr_isi_rave_reports_cfg;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RAVE_REPORTS_CFG" ENABLE;


-- sqlcl_snapshot {"hash":"835f19e34f3d55fc01cfbc5cf113f448ac0b7bdc","type":"TRIGGER","name":"TR_ISI_RAVE_REPORTS_CFG","schemaName":"DIRKSPZM32","sxml":""}