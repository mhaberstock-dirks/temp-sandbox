
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_FAHRZEUG_AU" 
  after update on DIRKSPZM32.lvs_fahrzeuge
  for each row
declare

begin
  if  :new.fahrzeug_ok = 'M'
  and :old.fahrzeug_ok != 'M'
  then
    insert into lvs_fahrz_defekt_dispo_st
    values
    (:new.sid,
     :new.firma_nr,
     :new.res_id,
     sysdate,
     'N');
   elsif :new.fahrzeug_ok != 'M'
   then
     update lvs_fahrz_defekt_dispo_st t
        set t.status = 'X'            -- Abgebrochen
      where t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.res_id = :new.res_id
        and t.status != 'F';
   end if;

end TR_LVS_FAHRZEUG_AU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_FAHRZEUG_AU" ENABLE;


-- sqlcl_snapshot {"hash":"d6a619b1b681c60f45f0a0d88776669ca90a398c","type":"TRIGGER","name":"TR_LVS_FAHRZEUG_AU","schemaName":"DIRKSPZM32","sxml":""}