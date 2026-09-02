
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_USER_BD" 
  before delete on isi_user
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
ALTER TRIGGER "TR_ISI_USER_BD" ENABLE;


-- sqlcl_snapshot {"hash":"e66301239657038e29dd37420e9e7074d7d5431d","type":"TRIGGER","name":"TR_ISI_USER_BD","schemaName":"DIRKSPZM32","sxml":""}