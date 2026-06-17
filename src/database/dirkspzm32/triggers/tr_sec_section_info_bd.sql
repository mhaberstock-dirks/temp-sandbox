
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_SEC_SECTION_INFO_BD" 
  before delete on DIRKSPZM32.sec_section_info
  for each row
declare
  -- local variables here
begin
  delete sec_action_info t where t.section_id = :old.section_id;
  delete sec_group_sections t where t.section_id = :old.section_id;
end tr_sec_section_info_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_SEC_SECTION_INFO_BD" ENABLE;


-- sqlcl_snapshot {"hash":"3470c81ae304f4daae392a51003f4dc4ec99a69a","type":"TRIGGER","name":"TR_SEC_SECTION_INFO_BD","schemaName":"DIRKSPZM32","sxml":""}