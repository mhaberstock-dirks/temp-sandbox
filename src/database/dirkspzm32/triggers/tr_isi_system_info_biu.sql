create or replace editionable trigger dirkspzm32.tr_isi_system_info_biu before
    insert or update on dirkspzm32.isi_system_info
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

alter trigger dirkspzm32.tr_isi_system_info_biu enable;


-- sqlcl_snapshot {"hash":"ccdc4597063658d8bcd095c54a2df065293a6196","type":"TRIGGER","name":"TR_ISI_SYSTEM_INFO_BIU","schemaName":"DIRKSPZM32","sxml":""}