
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_USER_BD" 
  before delete on DIRKSPZM32.isi_user
  FOR each row
declare
  -- local variables here
begin

  -- Wenn ein User gelöscht wird muss auch der Eintrag dem entsprechend aus der sec_user_groups gelöscht werden.
  delete sec_user_groups t
   where t.sid = :old.sid
     and t.login_id = :old.login_id
     and t.firma_nr = :old.firma_nr;

end tr_isi_user_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_USER_BD" ENABLE;


-- sqlcl_snapshot {"hash":"e06ad38d2fc5b19505749131ddf08d4e9710fe36","type":"TRIGGER","name":"TR_ISI_USER_BD","schemaName":"DIRKSPZM32","sxml":""}