
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RECOURCE_BIU" 
  before insert or update on DIRKSPZM32.isi_resource
  for each row
declare
  -- local variables here
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen für eine Exception
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  v_res_plan_date              isi_res_plan_data%rowtype;
  v_res_kosten                 isi_res_kosten%rowtype;
  v_mde_res_akt                mde_res_akt%rowtype;

  v_found                      boolean;

  v_schicht_modell             number;

  CURSOR c_res_plan_data is
    select *
      from isi_res_plan_data t
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.res_id = :new.res_id;

  CURSOR c_res_kosten is
    select *
      from isi_res_kosten t
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.res_id = :new.res_id;

  CURSOR c_mde_res_akt is
    select *
      from mde_res_akt t
     where t.sid = :new.sid
       and t.firma_nr = :new.firma_nr
       and t.res_id = :new.res_id;

begin
  -- Erst mal kein Fehler
  v_err_nr   := null;
  v_err_text := null;

  if :new.res_id is NULL
  then
    select seq_res_id.nextval into :new.res_id from dual;
  end if;

  if :new.parent_res_id is not null
  then
    if :new.parent_res_id = :new.res_id
    then
      v_err_nr := 10;
      v_err_text := 'Die aktuelle Recource kann nicht die Übergeordnete für sich selbst sein.';
      raise v_error;
    end if;
  end if;

  if INSERTING then
    if :new.com_name is not NULL then
      UPDATE isi_com_server
         SET com_geraet_typ = 'RES_' || :new.typ,
             com_geraet_name = :new.res_name
       WHERE com_name = :new.com_name;
    end if;
    if :new.typ = 'MS'
    then
      OPEN c_res_kosten;
      FETCH c_res_kosten into v_res_kosten;
      v_found := c_res_kosten%FOUND;
      CLOSE c_res_kosten;
      if not v_found
      and isi_allg.get_firma_cfg_param(:new.sid,
                                       :new.firma_nr,
                                        'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'PPS_MODUL',              -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PPS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
      then
        insert into isi_res_kosten t
          (t.sid,
           t.firma_nr,
           t.res_id,
           t.created_date,
           t.created_login_id)
        values
          (:new.sid,
           :new.firma_nr,
           :new.res_id,
           sysdate,
           -1);

      end if;
      OPEN c_mde_res_akt;
      FETCH c_mde_res_akt into v_mde_res_akt;
      v_found := c_mde_res_akt%FOUND;
      CLOSE c_mde_res_akt;
      if not v_found
      and isi_allg.get_firma_cfg_param(:new.sid,
                                       :new.firma_nr,
                                        'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'MDE_MODUL',              -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'MDE',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
      then
         insert into mde_res_akt
           (sid,
            firma_nr,
            res_name,
            res_id,
            status,
            create_date)
         values
           (:new.sid,
            :new.firma_nr,
            :new.res_name,
            :new.res_id,
            'N',
            sysdate);
      end if;
    end if;

    if :new.typ = 'MS'
    or :new.typ = 'MPG'
    then
      OPEN c_res_plan_data;
      FETCH c_res_plan_data into v_res_plan_date;
      v_found := c_res_plan_data%FOUND;
      CLOSE c_res_plan_data;
      if not v_found
      and isi_allg.get_firma_cfg_param(:new.sid,
                                       :new.firma_nr,
                                        'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'PPS_MODUL',              -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PPS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
       then
         -- Eine Ressource benötigt ein zugeordnetes Schichtmodell in PZM_SCHICHT_MODELLE über ISI_RES_PLAN_DATA.
         -- Falls kein passendes Schichtmodell in PZM_SCHICHT_MODELLE exisitert, wird dies hier angelegt und kann über den DEFAULT aus ISI_RES_PLAN_DATA referenziert werden.
         select count(*) into v_schicht_modell from pzm_schicht_modelle m
                where m.sm_name = '24Std';
         if v_schicht_modell=0
           then
             insert into pzm_schicht_modelle pzm
             (pzm.sm_name)
             values
             (
             '24Std');   -- Default in ISI_RES_PLAN_DATA
         end if;
         -- Zuordnung zum Schichtmodell
         insert into isi_res_plan_data t
           (t.sid,
            t.firma_nr,
            t.res_id,
            t.created_date,
            t.created_login_id,
            t.arbeitszeitmodellnr)                                 -- hier gibt es eine Fremdschlüsselverletzung wenn das PZM_Schichtmodell nicht bereits existiert
         values
           (:new.sid,
            :new.firma_nr,
            :new.res_id,
            sysdate,
            -1,
            'R' || :new.res_name);

       end if;
     end if;
  elsif UPDATING then
    if :old.com_name is not NULL then
      UPDATE isi_com_server
         SET com_geraet_typ = '',
             com_geraet_name = NULL
       WHERE com_name = :old.com_name;
    end if;
    if :new.com_name is not NULL then
      UPDATE isi_com_server
       SET com_geraet_typ = 'RES_' || :new.typ,
           com_geraet_name = :new.res_name
       WHERE com_name = :new.com_name;
    end if;
    if :new.typ = 'MS'
    then
      OPEN c_res_kosten;
      FETCH c_res_kosten into v_res_kosten;
      v_found := c_res_kosten%FOUND;
      CLOSE c_res_kosten;
      if not v_found
      and isi_allg.get_firma_cfg_param(:new.sid,
                                       :new.firma_nr,
                                        'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'PPS_MODUL',              -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'PPS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
       then
         insert into isi_res_kosten t
           (t.sid,
            t.firma_nr,
            t.res_id,
            t.created_date,
            t.created_login_id)
         values
           (:new.sid,
            :new.firma_nr,
            :new.res_id,
            sysdate,
            -1);

       end if;
       OPEN c_mde_res_akt;
       FETCH c_mde_res_akt into v_mde_res_akt;
       v_found := c_mde_res_akt%FOUND;
       CLOSE c_mde_res_akt;
       if not v_found
       and isi_allg.get_firma_cfg_param(:new.sid,
                                        :new.firma_nr,
                                         'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                         NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                         'MDE_MODUL',              -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                         'MDE',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                         'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                         'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                         'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
       then
         insert into mde_res_akt
           (sid,
            firma_nr,
            res_name,
            res_id,
            status,
            create_date)
         values
           (:new.sid,
            :new.firma_nr,
            :new.res_name,
            :new.res_id,
            'N',
            sysdate);
       end if;
     end if;
   if :new.typ = 'MS'
   or :new.typ = 'MPG'
   then
     OPEN c_res_plan_data;
     FETCH c_res_plan_data into v_res_plan_date;
     v_found := c_res_plan_data%FOUND;
     CLOSE c_res_plan_data;
     if not v_found
     and isi_allg.get_firma_cfg_param(:new.sid,
                                      :new.firma_nr,
                                       'CFG',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                       NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                       'PPS_MODUL',              -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                       'PPS',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                       'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                       'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                       'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
      then
        insert into isi_res_plan_data t
          (t.sid,
           t.firma_nr,
           t.res_id,
           t.created_date,
           t.created_login_id,
           t.arbeitszeitmodellnr)
        values
          (:new.sid,
           :new.firma_nr,
           :new.res_id,
           sysdate,
           -1,
           'R' || :new.res_name);

      end if;
    end if;
  elsif DELETING then
    if :old.com_name is not NULL then
      UPDATE isi_com_server
         SET com_geraet_typ = '',
             com_geraet_name = NULL
       WHERE com_name = :old.com_name;
    end if;
  end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
end tr_isi_recource_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RECOURCE_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"af9f192b5c3a200f4e3f09eedc67b44ad2697736","type":"TRIGGER","name":"TR_ISI_RECOURCE_BIU","schemaName":"DIRKSPZM32","sxml":""}