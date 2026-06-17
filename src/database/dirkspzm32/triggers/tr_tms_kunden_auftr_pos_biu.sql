
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_TMS_KUNDEN_AUFTR_POS_BIU" 
  before insert or update
  on DIRKSPZM32.TMS_KUNDEN_AUFTR_POS
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
ALTER TRIGGER "DIRKSPZM32"."TR_TMS_KUNDEN_AUFTR_POS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"e8a8a97b538558af5e8c97363755c5b4356a06dd","type":"TRIGGER","name":"TR_TMS_KUNDEN_AUFTR_POS_BIU","schemaName":"DIRKSPZM32","sxml":""}