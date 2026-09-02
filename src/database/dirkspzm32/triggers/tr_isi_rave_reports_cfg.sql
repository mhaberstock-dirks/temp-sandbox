
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_RAVE_REPORTS_CFG" 
  before insert on isi_rave_reports_cfg
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
ALTER TRIGGER "TR_ISI_RAVE_REPORTS_CFG" ENABLE;


-- sqlcl_snapshot {"hash":"ce5c9c28b01231de875293410c551fe429ddc923","type":"TRIGGER","name":"TR_ISI_RAVE_REPORTS_CFG","schemaName":"DIRKSPZM32","sxml":""}