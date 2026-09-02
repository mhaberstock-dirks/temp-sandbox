
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_SERIE_ID_KOPF_BIU" 
  before insert or update on LVS_SERIE_ID_KOPF
  for each row
begin
  if updating or inserting
  then
    if inserting
    then
      if nvl(:new.serie_id, 0) = 0
      then
        select seq_serie_id.nextval into :new.serie_id from dual;
      end if;
      if :new.created_date is NULL
      then
        :new.created_date := sysdate;
      end if;
      if :new.created_login_id is NULL
      then
        :new.created_login_id := -1;
      end if;
    end if;
    if updating
    then
      if :new.last_change_date = :old.last_change_date or
         :new.last_change_date is NULL
      then
        :new.last_change_date := sysdate;
      end if;
    end if;
  end if;
end TR_LVS_SERIE_ID_KOPF_BIU;


/
ALTER TRIGGER "TR_LVS_SERIE_ID_KOPF_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"43053a12a777c6f64703cc9c6bb79e4213f1e279","type":"TRIGGER","name":"TR_LVS_SERIE_ID_KOPF_BIU","schemaName":"DIRKSPZM32","sxml":""}