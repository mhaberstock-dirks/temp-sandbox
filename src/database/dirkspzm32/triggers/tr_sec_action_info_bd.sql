
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SEC_ACTION_INFO_BD" 
  before delete on sec_action_info
  for each row
declare
  -- local variables here
begin
  delete sec_group_actions t where t.action_id = :old.action_id;
end tr_sec_action_info_bd;


/
ALTER TRIGGER "TR_SEC_ACTION_INFO_BD" ENABLE;


-- sqlcl_snapshot {"hash":"7afbfbde9f2f3b8fca5352a13691496abd2ff040","type":"TRIGGER","name":"TR_SEC_ACTION_INFO_BD","schemaName":"DIRKSPZM32","sxml":""}