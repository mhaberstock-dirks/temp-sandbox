
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_SEC_SECTION_INFO_BD" 
  before delete on sec_section_info
  for each row
declare
  -- local variables here
begin
  delete sec_action_info t where t.section_id = :old.section_id;
  delete sec_group_sections t where t.section_id = :old.section_id;
end tr_sec_section_info_bd;


/
ALTER TRIGGER "TR_SEC_SECTION_INFO_BD" ENABLE;


-- sqlcl_snapshot {"hash":"257d6c0117e77a162d1f0d17e60a48a1cb546b16","type":"TRIGGER","name":"TR_SEC_SECTION_INFO_BD","schemaName":"DIRKSPZM32","sxml":""}