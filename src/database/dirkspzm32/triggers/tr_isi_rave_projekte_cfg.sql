
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RAVE_PROJEKTE_CFG" 
  before insert on DIRKSPZM32.isi_rave_projekte_cfg
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
end tr_isi_rave_projekte_cfg;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RAVE_PROJEKTE_CFG" ENABLE;


-- sqlcl_snapshot {"hash":"bcb89d0b47619f6a77d018ce68d4314d1892a93e","type":"TRIGGER","name":"TR_ISI_RAVE_PROJEKTE_CFG","schemaName":"DIRKSPZM32","sxml":""}