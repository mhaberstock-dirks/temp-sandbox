
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_SEC_ACTION_INFO_BD" 
  before delete on DIRKSPZM32.sec_action_info
  for each row
declare
  -- local variables here
begin
  delete sec_group_actions t where t.action_id = :old.action_id;
end tr_sec_action_info_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_SEC_ACTION_INFO_BD" ENABLE;


-- sqlcl_snapshot {"hash":"5c0c1992c5e95bde09671384fe6cc23ec716cebd","type":"TRIGGER","name":"TR_SEC_ACTION_INFO_BD","schemaName":"DIRKSPZM32","sxml":""}