
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RAVE_PROJEKTE_CFG" 
  before insert on isi_rave_projekte_cfg
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
ALTER TRIGGER "TR_ISI_RAVE_PROJEKTE_CFG" ENABLE;


-- sqlcl_snapshot {"hash":"1c8f405ac4608e7727e284e8f47b7232e1ed7602","type":"TRIGGER","name":"TR_ISI_RAVE_PROJEKTE_CFG","schemaName":"DIRKSPZM32","sxml":""}