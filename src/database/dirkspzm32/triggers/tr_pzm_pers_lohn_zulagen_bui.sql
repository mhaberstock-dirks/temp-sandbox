
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_PERS_LOHN_ZULAGEN_BUI" 
  before insert or update on DIRKSPZM32.pzm_pers_lohn_zulagen
  for each row
declare
begin

  if :new.pers_lz_seq is NULL
  then
    :new.pers_lz_seq := SEQ_PZM_PERS_LZ.NEXTVAL;
  end if;

  if inserting
  then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    :new.created_login_id := nvl(current_isi_user_login_id(), -1);
    :new.created_user := current_isi_user();
  else
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    :new.last_change_user := current_isi_user();
  end if;


end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_PERS_LOHN_ZULAGEN_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"c1dc9b25db3863f1bfef35087d33209bb701f33a","type":"TRIGGER","name":"TR_PZM_PERS_LOHN_ZULAGEN_BUI","schemaName":"DIRKSPZM32","sxml":""}