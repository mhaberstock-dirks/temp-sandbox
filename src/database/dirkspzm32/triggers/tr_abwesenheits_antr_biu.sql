
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ABWESENHEITS_ANTR_BIU" 
  before insert or update on "PZM_ABWESENHEITS_ANTR"
  for each row
declare
  -- local variables here
begin
  if inserting then
    :new.au_datum := SYSDATE;
    :new.created_date := SYSDATE;
    :new.created_login_id := nvl(current_isi_user_login_id(), -1);
    :new.last_change_date := NULL;
    :new.last_change_login_id := NULL;
  else
    -- updating
    -- Sicherstellen, dass initiale Werte nicht überschrieben werden!
    :new.au_datum := :old.au_datum;
    :new.created_date := :old.created_date;
    :new.created_login_id := :old.created_login_id;
    :new.last_change_date := sysdate;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
  end if;
  
  -- :new.au_datum := SYSDATE;      HM, 8.9.2026 - KEINE UPDATES auf PK-Felder! Ist tödlich für den Index!
  
  /*
  if inserting  
  then
    --> wird von dotnet mit '01.01.0001' initialisiert - ist also nie NULL. Daher ist die Logik hier wirkungslos. 
    if :new.created_date is NULL    
    then
      :new.created_date := sysdate;
    end if;
    :new.created_login_id := nvl(current_isi_user_login_id(), -1);
    --:new.created_user := current_isi_user();
  else
    --> Der Witz eines "last_change_date" ist, dass es zuverlässig den letzten Änderungszeitstempels setzt.
    -- Bei einer Abfrage auf NULL wird bestenfalls der erste Änderungszeitstempel erfasst. Die Anwendung könnte 
    -- aber auch einen beliebigen anderen Wert eintragen. Das ist aus forensischer Sicht kontraproduktiv! 
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    --:new.last_change_user := current_isi_user();
  end if;
  */
end TR_ANTR_URLAUB_BIU;
/
ALTER TRIGGER "TR_ABWESENHEITS_ANTR_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"f8515906c109c46af9aab940e20eba342f611c83","type":"TRIGGER","name":"TR_ABWESENHEITS_ANTR_BIU","schemaName":"DIRKSPZM32","sxml":""}