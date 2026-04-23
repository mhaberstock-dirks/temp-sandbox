create or replace editionable trigger dirkspzm32.tr_isi_user_bd before
    delete on dirkspzm32.isi_user
    for each row
declare
  -- local variables here
 begin

  -- Wenn ein User gelöscht wird muss auch der Eintrag dem entsprechend aus der sec_user_groups gelöscht werden.
    delete sec_user_groups t
    where
            t.sid = :old.sid
        and t.login_id = :old.login_id
        and t.firma_nr = :old.firma_nr;

end tr_isi_user_bd;
/

alter trigger dirkspzm32.tr_isi_user_bd enable;


-- sqlcl_snapshot {"hash":"ce0cc5db6c642123d255cb60d1c59e17cc3d8b33","type":"TRIGGER","name":"TR_ISI_USER_BD","schemaName":"DIRKSPZM32","sxml":""}