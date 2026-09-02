
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_SERIE_ID_POS_BIU" 
  before insert or update on LVS_SERIE_ID_POS
  for each row
begin
  if updating or inserting
  then
    if inserting
    then
      if nvl(:new.serie_id_lfdn, 0) = 0
      then
        select seq_serie_id_lfdn.nextval into :new.serie_id_lfdn from dual;
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
end TR_LVS_SERIE_ID_POS_BIU;


/
ALTER TRIGGER "TR_LVS_SERIE_ID_POS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"e19a40366a1a368cca8a7ceca4766d97d5f2e476","type":"TRIGGER","name":"TR_LVS_SERIE_ID_POS_BIU","schemaName":"DIRKSPZM32","sxml":""}