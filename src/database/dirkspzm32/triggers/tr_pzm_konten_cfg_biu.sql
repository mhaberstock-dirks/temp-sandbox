
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_CFG_BIU" 
  before insert or update on DIRKSPZM32.PZM_KONTEN_CFG
  for each row
declare

  v_pzm_personal pzm_personal%rowtype;
  v_allg_pb_id   pzm_allg_parameter.ap_pb_id%type;
  
  CURSOR c_chk_allg is
      select ap.ap_pb_id    -- Konfiguration in den allg parametern suchen
        from pzm_allg_parameter ap
       where (((    (ap.ap_name = 'FLEXSTUNDEN_KONTO' and :new.name_kurz = ap.ap_value and ap.ap_pb_id = 0)
                 and not exists (select apx.ap_pb_id from pzm_allg_parameter apx where apx.ap_name = 'FLEXSTUNDEN_KONTO' and apx.ap_pb_id = v_pzm_personal.pers_pb_id)
                 
                )
                or (ap.ap_name = 'FLEXSTUNDEN_KONTO' and :new.name_kurz = ap.ap_value and ap.ap_pb_id = v_pzm_personal.pers_pb_id)
               )
             or
              ((    (ap.ap_name = 'URLAUBS_KONTO' and :new.name_kurz = ap.ap_value and ap.ap_pb_id = 0)
                 and not exists (select apx.ap_pb_id from pzm_allg_parameter apx where apx.ap_name = 'URLAUBS_KONTO' and  apx.ap_pb_id = v_pzm_personal.pers_pb_id)
                 
                )
                or (ap.ap_name = 'URLAUBS_KONTO' and :new.name_kurz = ap.ap_value and ap.ap_pb_id = v_pzm_personal.pers_pb_id)
               )           
             or
              ((    (ap.ap_name = 'FLEXSTUNDEN_KONTO_ZUSAETZLICH' and ap.ap_value like '%' || :new.name_kurz || ';%' and ap.ap_pb_id = 0)
                 and not exists (select apx.ap_pb_id from pzm_allg_parameter apx where apx.ap_name = 'FLEXSTUNDEN_KONTO_ZUSAETZLICH' and apx.ap_pb_id = v_pzm_personal.pers_pb_id)
                 
                )
                or (ap.ap_name = 'FLEXSTUNDEN_KONTO_ZUSAETZLICH' and ap.ap_value like '%' || :new.name_kurz || ';%' and ap.ap_pb_id = v_pzm_personal.pers_pb_id)
               )           
              );

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
      
      v_allg_pb_id := NULL;
      OPEN c_chk_allg;
      FETCH c_chk_allg into v_allg_pb_id;   -- Prüfen in der KONFIG
      CLOSE c_chk_allg;
      
      if v_allg_pb_id = 0 or v_allg_pb_id = v_pzm_personal.pers_pb_id -- Nur mit gültiger Konfiguration
      then
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
      end if;

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


-- sqlcl_snapshot {"hash":"d4905e9db130e56ae23b1d04f35880fd30225178","type":"TRIGGER","name":"TR_PZM_KONTEN_CFG_BIU","schemaName":"DIRKSPZM32","sxml":""}