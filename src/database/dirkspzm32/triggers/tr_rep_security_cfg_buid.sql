
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_REP_SECURITY_CFG_BUID" 
  before insert or update or delete on rep_security_cfg
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    select nvl(max(rep_security_cfg_id), 0) + 1
      into :new.rep_security_cfg_id
      from rep_security_cfg
     where rep_id = :new.rep_id;
  end if;
end tr_rep_security_cfg_buid;


/
ALTER TRIGGER "TR_REP_SECURITY_CFG_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"c09be3ba7e5c9770428fd213be483f2bd264a29e","type":"TRIGGER","name":"TR_REP_SECURITY_CFG_BUID","schemaName":"DIRKSPZM32","sxml":""}