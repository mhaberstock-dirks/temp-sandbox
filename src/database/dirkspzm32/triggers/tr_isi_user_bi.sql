
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_USER_BI" 
  before insert on DIRKSPZM32.isi_user
  for each row
declare
  -- local variables here
  v_group_id sec_groups.group_id%TYPE;

  CURSOR c_groups IS
    SELECT group_id
      FROM sec_groups
     WHERE default_group = 'T'
           AND sid = :new.sid;
begin
  if :new.sid is NULL then
    :new.sid := '01';
  end if;

  if :new.firma_nr is NULL then
    :new.firma_nr := 1;
  end if;

  if :new.login_id is NULL then
    SELECT seq_login_id.nextval INTO :new.login_id FROM dual;
  end if;

  OPEN c_groups;

  loop
    FETCH c_groups INTO v_group_id;
    EXIT WHEN c_groups%NOTFOUND;
    INSERT INTO sec_user_groups VALUES (
                :new.sid,
                :new.login_id,
                v_group_id,
                :new.firma_nr);
  end loop;
  CLOSE c_groups;

end TR_ISI_USER_BI;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_USER_BI" ENABLE;


-- sqlcl_snapshot {"hash":"1e6aad945fec767f0149bfd97061d0c8ea757231","type":"TRIGGER","name":"TR_ISI_USER_BI","schemaName":"DIRKSPZM32","sxml":""}