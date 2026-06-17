
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_CFG_BIU" 
  before insert or update on DIRKSPZM32.PZM_KONTEN_CFG
  for each row
declare

  v_pzm_personal pzm_personal%rowtype;

  cursor c_pzm_personal is
    select *
      from pzm_personal
     where pers_austrittdatum > sysdate
        or pers_austrittdatum is null;
begin

  if inserting then
    open c_pzm_personal;

    loop
      fetch c_pzm_personal
        into v_pzm_personal;

      exit when c_pzm_personal%notfound;

      insert into pzm_konten
      values
        (:new.sid,
         :new.firma_nr,
         v_pzm_personal.pers_nr,
         null,
         :new.name,
         :new.name_kurz,
         :new.typ,
         :new.buch_einheit,
         0,
         null,
         null,
         null,
         :new.info,
         :new.def_max_saldo,
         :new.def_min_saldo,
         :new.aktiv,
         0);

    end loop;
    close c_pzm_personal;

  elsif updating then

    update pzm_konten
       set name         = :new.name,
           name_kurz    = :new.name_kurz,
           typ          = :new.typ,
           buch_einheit = :new.buch_einheit,
           info         = :new.info,
           max_saldo    = :new.def_max_saldo,
           min_saldo    = :new.def_min_saldo,
           aktiv        = :new.aktiv
     where sid = :old.sid
       and firma_nr = :old.firma_nr
       and name = :old.name
       and name_kurz = :old.name_kurz
       and typ = :old.typ
       and buch_einheit = :old.buch_einheit
       and info = :old.info
       and aktiv = :old.aktiv;

  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_CFG_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"56b076bc2896269baf3c4feb6d9b9d1188dc62dd","type":"TRIGGER","name":"TR_PZM_KONTEN_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}