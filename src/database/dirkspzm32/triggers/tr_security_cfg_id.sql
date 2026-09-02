
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SECURITY_CFG_ID" 
  before insert on isi_security_cfg
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

  if :new.SECURITY_CFG_ID is NULL then
    SELECT seq_security_cfg_id.nextval INTO :new.SECURITY_CFG_ID FROM dual;
  end if;
end tr_security_cfg_id;


/
ALTER TRIGGER "TR_SECURITY_CFG_ID" ENABLE;


-- sqlcl_snapshot {"hash":"23930842d47f0871161e148cdb1555c7ac2d613d","type":"TRIGGER","name":"TR_SECURITY_CFG_ID","schemaName":"DIRKSPZM32","sxml":""}