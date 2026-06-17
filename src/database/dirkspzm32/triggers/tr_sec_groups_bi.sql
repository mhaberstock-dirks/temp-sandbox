
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_SEC_GROUPS_BI" 
  before insert on DIRKSPZM32.sec_groups
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

  if :new.group_id is NULL then
    SELECT seq_group_id.nextval INTO :new.group_id FROM dual;
  end if;
end tr_sec_groups_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_SEC_GROUPS_BI" ENABLE;


-- sqlcl_snapshot {"hash":"e3aa6d5b98b1a6fe00987cb41c8c851d59ea1f2a","type":"TRIGGER","name":"TR_SEC_GROUPS_BI","schemaName":"DIRKSPZM32","sxml":""}