
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_PROD_LINIE_BUID" 
  before insert or update or delete on lvs_prod_linie
  for each row
declare
  cursor c_isi_res_exists_res_name is
  select res.res_id
    from ISI_RESOURCE res
   where res.res_name = TO_CHAR(:new.linie_nr)
     and res.sid = :new.sid;
     --and res.firma_nr = new.firma_nr;

  cursor c_isi_res_exists_res_id is
  select res.res_id
    from ISI_RESOURCE res
   where res.res_id = :old.res_id
     and res.sid = :new.sid;
     --and res.firma_nr = new.firma_nr;

  v_res_id number;
  v_found BOOLEAN;
begin
  if inserting or updating
  then
    if :new.linie_nr is null
    then
      select seq_lvs_prod_linie_nr.nextval into :new.linie_nr from dual;
    end if;

    if isi_allg.get_firma_cfg_param(:new.sid,
                                    :new.firma_nr,
                                    'CFG',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                    NULL,                   -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                    'PROD_LINIE_ERZ_RES_ID',-- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                    'CFG',                  -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                    'CFG',                  -- in_typ                   in isi_firma_cfg.typ%type,
                                    c.C_TRUE,               -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                    'BOOLEAN') = c.C_TRUE   -- in_default_param_typ
    then
      if inserting
      then -- LVS_PROD_LINIE.RES_ID is null
        OPEN c_isi_res_exists_res_name;
        FETCH c_isi_res_exists_res_name
         INTO v_res_id;
         v_found := c_isi_res_exists_res_name%FOUND;
        CLOSE c_isi_res_exists_res_name;
      elsif updating -- LVS_PROD_LINIE.RES_ID is not null
      then
        OPEN c_isi_res_exists_res_id;
        FETCH c_isi_res_exists_res_id
         INTO v_res_id;
         v_found := c_isi_res_exists_res_id%FOUND;
        CLOSE c_isi_res_exists_res_id;
      end if;

      if not v_found
      then
        insert into isi_resource values(
        :new.sid,
        null, --res_id
        :new.firma_nr,
        'LI', -- typ
        :new.linie_nr, -- res_name
        1, -- variante
        null, -- gruppe
        :new.linie_name, -- text
        null, -- lager_roh
        null, -- lager_fertig
        :new.linie_nr, -- res_ext_name
        null, -- fehler_schluessel
        null, -- orts_kz
        null, -- in_res_id (verschachtelung
        null, -- in_res_pos_info)
        null, -- in_res_seit
        null, -- linie_res_id
        null, -- login_id_verantw
        null, -- adress_id
        'LI_' || :new.linie_name, -- VISUNAME          VARCHAR2(15),
        'LINIE',         -- KATEGORIE         VARCHAR2(40),
        null,            -- KATEGORIE_TYP     VARCHAR2(15),
        null,            -- MAX_KG            NUMBER,
        null,            -- COM_NAME          VARCHAR2(15),
        null,            -- POLLMSEK          NUMBER
        null,            -- drucker
        null,            -- res_params_cfg
        NULL)            -- res_kst

        returning isi_resource.res_id into :new.res_id;
      else
        :new.res_id := v_res_id;

        update isi_resource res
           set res.res_name     = :new.linie_nr,
               res.text         = :new.linie_name,
               res.res_ext_name = :new.linie_nr
         where res.sid = :new.sid
           and res.firma_nr = :new.firma_nr
           and res.res_id = :new.res_id;
      end if;
    end if;
  elsif deleting
  then
    delete ISI_RESOURCE res
     where res.sid = :old.sid
       --and res.firma_nr = :old.firma_nr
       and res.res_id = :old.res_id;
  end if; -- if inserting or updating
end tr_lvs_prod_linie_buid;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_PROD_LINIE_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"f3f25e8b52b444ca03e5781d5ec2043ccd65353f","type":"TRIGGER","name":"TR_LVS_PROD_LINIE_BUID","schemaName":"DIRKSPZM32","sxml":""}