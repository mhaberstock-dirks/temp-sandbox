create or replace editionable trigger dirkspzm32.tr_sec_action_info_bd before
    delete on dirkspzm32.sec_action_info
    for each row
declare
  -- local variables here
 begin
    delete sec_group_actions t
    where
        t.action_id = :old.action_id;

end tr_sec_action_info_bd;
/

alter trigger dirkspzm32.tr_sec_action_info_bd enable;


-- sqlcl_snapshot {"hash":"2f50618cdfc6d97a4daef09ccf1ed4fb9c135016","type":"TRIGGER","name":"TR_SEC_ACTION_INFO_BD","schemaName":"DIRKSPZM32","sxml":""}