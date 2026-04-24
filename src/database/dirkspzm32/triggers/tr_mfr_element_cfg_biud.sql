
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_MFR_ELEMENT_CFG_BIUD" 
  before insert or update or delete on mfr_element_cfg
  for each row
declare
  -- local variables here
begin
  if inserting or (updating and :old.res_id is null and :new.res_id is null)
  then
    if :new.is_rbg = 'T' then
      insert into isi_resource
      values
        (:new.sid,
         :new.res_id, --res_id
         :new.firma_nr,
         'RBG', -- typ
         :new.fahrzeug, -- res_name
         1, -- variante
         null, -- gruppe
         null, -- text
         null, -- lager_roh
         null, -- lager_fertig
         :new.fahrzkurz, -- res_ext_name
         null, -- fehler_schluessel
         null, -- orts_kz
         null, -- in_res_id (verschachtelung
         null, -- in_res_pos_info)
         null, -- in_res_seit
         null, -- linie_res_id
         null, -- login_id_verantw
         null, -- adress_id
         'MFR_' || :new.fahrzeug,   -- VISUBAME,
         'MFR',   -- KATEGORIE         VARCHAR2(40),
         null,    -- KATEGORIE_TYP     VARCHAR2(15),
         null,    -- MAX_KG            NUMBER,
         null,    -- COM_NAME          VARCHAR2(15),
         null,    -- POLLMSEK          NUMBER
         null,    -- drucker
         null,    -- res_params_cfg
         null)    -- res_kst
      returning isi_resource.res_id into :new.res_id;
    end if;
  --elsif updating
  --then
    /*if :old.res_id is not null then
      update isi_resource res
         set res.res_name     = :new.fahrzeug,
             res.res_ext_name = :new.fahrzkurz
       where res.sid = :new.sid
         and res.firma_nr = :new.firma_nr
         and res.res_id = :new.res_id;*/
    --end if;
  elsif deleting
  then
    if :old.res_id is not null then
      delete from isi_resource t
       where t.sid = :old.sid
         and t.firma_nr = :old.firma_nr
         and t.res_id = :old.res_id;
    end if;
  end if;
end tr_mfr_element_cfg_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_MFR_ELEMENT_CFG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"9e6b2dc3728f02f445df27ef40166c6fd2576579","type":"TRIGGER","name":"TR_MFR_ELEMENT_CFG_BIUD","schemaName":"DIRKSPZM32","sxml":""}