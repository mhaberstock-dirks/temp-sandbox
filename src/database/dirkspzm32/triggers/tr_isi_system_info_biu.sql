
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_SYSTEM_INFO_BIU" 
  before insert or update on isi_system_info
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
ALTER TRIGGER "TR_ISI_SYSTEM_INFO_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"bd08ef11a7bba0088a90abbaae505e68677457c0","type":"TRIGGER","name":"TR_ISI_SYSTEM_INFO_BIU","schemaName":"DIRKSPZM32","sxml":""}