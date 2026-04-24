create or replace editionable trigger dirkspzm32.tr_sec_section_info_bd before
    delete on dirkspzm32.sec_section_info
    for each row
declare
  -- local variables here
 begin
    delete sec_action_info t
    where
        t.section_id = :old.section_id;

    delete sec_group_sections t
    where
        t.section_id = :old.section_id;

end tr_sec_section_info_bd;
/

alter trigger dirkspzm32.tr_sec_section_info_bd enable;


-- sqlcl_snapshot {"hash":"086444ee8c3f1439315d837d634cc64832f2c781","type":"TRIGGER","name":"TR_SEC_SECTION_INFO_BD","schemaName":"DIRKSPZM32","sxml":""}