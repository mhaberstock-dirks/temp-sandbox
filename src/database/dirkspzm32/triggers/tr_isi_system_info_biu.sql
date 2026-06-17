
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_SYSTEM_INFO_BIU" 
  before insert or update on DIRKSPZM32.isi_system_info
  for each row
declare
  -- local variables here
begin
  :new.last_run_timestamp := sysdate;
  :new.hostname := upper(:new.hostname);
  :new.appl_exe_name := upper(:new.appl_exe_name);
  :new.last_run_os_user := upper(:new.last_run_os_user);
end tr_isi_system_info;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_SYSTEM_INFO_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"2a07ffac5f34b9eb905ca9d0a8eb34058aab30e2","type":"TRIGGER","name":"TR_ISI_SYSTEM_INFO_BIU","schemaName":"DIRKSPZM32","sxml":""}