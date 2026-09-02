
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_TMS_KUNDEN_AUFTR_POS_BIU" 
  before insert or update
  on TMS_KUNDEN_AUFTR_POS
  for each row
declare
  -- local variables here
begin
  if updating or inserting then
    if inserting
    then
      if :new.erz_datum is NULL
      then
        :new.erz_datum := sysdate;
      end if;
      if :new.erz_login_id is NULL
      then
        :new.erz_login_id := -1;
      end if;
    end if;
    if updating
    then
      if :new.aend_datum = :old.aend_datum
      or :new.aend_datum is NULL
      then
        :new.aend_datum := sysdate;
      end if;
    end if;
  end if;
end;


/
ALTER TRIGGER "TR_TMS_KUNDEN_AUFTR_POS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"22087962cbc3852270a9194db85fac59ed6aeb70","type":"TRIGGER","name":"TR_TMS_KUNDEN_AUFTR_POS_BIU","schemaName":"DIRKSPZM32","sxml":""}