create or replace 
package body DIRKSPZM32.security is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);
  -------------------------------------------------------------------------------------------------------

  /*******************************************************************************
  * procedure raise_isi_error (...)
  *******************************************************************************/
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  /*******************************************************************************
  * function get_version (...)
  *******************************************************************************/
  function get_version return varchar2 is
  begin
    return(v_version_str);
  end;

  /*******************************************************************************
  * function get_version (...)
  *******************************************************************************/
  function get_section_id(in_mod_id              in number,
                          in_section_name        in varchar2
                         ) return number is
    v_section_id number;
    v_section_name sec_section_info.name%type;

    cursor c_section_info is
      select t.section_id
        from sec_section_info t
       where t.mod_id = in_mod_id
         and t.name = v_section_name;

    cursor c_module_info is
      select t.name
        from sec_module_info t
       where t.mod_id = in_mod_id;
  begin
    v_section_name := in_section_name;
    open c_section_info;
    fetch c_section_info into v_section_id;
    close c_section_info;

    if in_section_name is null or v_section_id is null
    then
      /* für die default section eines Moduls */
      open c_module_info;
      fetch c_module_info into v_section_name;
      close c_module_info;

      open c_section_info;
      fetch c_section_info into v_section_id;
      close c_section_info;
    end if;

    return(v_section_id);
  end;

  -- Für version 3.3 --------------------------------------------------------------
  -- Ab hier sind Funktionen die nötig sind, um Applikationen der version 3.3 starten
  -- zu können. (Erstellt 20.04.2007 loeschen Ende 2007)
  -- Für version 3.3 --------------------------------------------------------------
  function get_const_reset_captions return boolean is
  begin
    return(const_reset_captions);
  end;

  /*******************************************************************************
  * procedure C_CHECK_MODULE_EXISTENSE (in_module_name in varchar2,
  *                                     io_module_description in out varchar2,
  *                                     out_module_caption out varchar2,
  *                                     out_module_help_file out varchar2,
  *                                     out_module_id out number) is
  *******************************************************************************/
  procedure c_check_module_existense(in_module_name        in varchar2,
                                     io_module_description in out varchar2,
                                     out_module_caption    out varchar2,
                                     out_module_help_file  out varchar2,
                                     out_module_id         out number) is
    v_module_info sec_module_info%rowtype;

    cursor c_module_info is
      select *
        from sec_module_info
       where name = in_module_name;
  begin
    out_module_help_file := '';
    out_module_caption   := in_module_name;

    open c_module_info;

    fetch c_module_info
      into v_module_info;

    if c_module_info%found
    then
      out_module_id         := v_module_info.mod_id;
      out_module_caption    := v_module_info.caption;
      out_module_help_file  := v_module_info.help_file;
      io_module_description := v_module_info.description;
    else
      select seq_sec_module_id.nextval into out_module_id from dual;
      if out_module_id < 900
      then
        raise_application_error(-20001,'Applikationen der Version 3.3 dürfen keine neuen Module mit ID < 900 eintragen. Modul: ' || in_module_name);
      end if;
      insert into sec_module_info
      values
        (out_module_id,
         in_module_name,
         out_module_caption,
         io_module_description,
         '',
         NULL,
         NULL);

      commit;
    end if;

    close c_module_info;
  end;

  /*******************************************************************************
  * SCHREIBFEHLER !!!! Diese Funktion existiert nur für alte Programme
  * procedure C_CHECK_SECTION_EXEISTENCE (...) is
  *                             ^
  *******************************************************************************/
  procedure c_check_section_exeistence(in_module_id           in number,
                                       in_section_name        in varchar2,
                                       io_section_description in out varchar2,
                                       out_section_caption    out varchar2,
                                       out_section_help_file  out varchar2,
                                       out_section_id         out number) is
  begin
    c_check_section_existence(in_module_id,
                              in_section_name,
                              io_section_description,
                              out_section_caption,
                              out_section_help_file,
                              out_section_id);
  end;
  /*******************************************************************************
  * procedure C_CHECK_SECTION_EXISTENCE (in_module_id in number,
  *                                      in_section_name in varchar2,
  *                                      io_section_description in out varchar2,
  *                                      out_section_caption out varchar2,
  *                                      out_section_help_file out varchar2,
  *                                      out_section_id out number) is
  *******************************************************************************/
  procedure c_check_section_existence(in_module_id           in number,
                                      in_section_name        in varchar2,
                                      io_section_description in out varchar2,
                                      out_section_caption    out varchar2,
                                      out_section_help_file  out varchar2,
                                      out_section_id         out number) is
    v_section_info sec_section_info%rowtype;

    cursor c_section_info is
      select *
        from sec_section_info
       where name = in_section_name
         and mod_id = in_module_id;
  begin
    out_section_help_file := '';
    out_section_caption   := in_section_name;

    open c_section_info;

    fetch c_section_info
      into v_section_info;
    if c_section_info%found
    then
      out_section_id         := v_section_info.section_id;
      out_section_caption    := v_section_info.caption;
      out_section_help_file  := v_section_info.help_file;
      io_section_description := v_section_info.description;
    else
      select seq_sec_section_id.nextval into out_section_id from dual;
      if out_section_id < 900
      then
        raise_application_error(-20001,'Applikationen der Version 3.3 dürfen keine neuen Sections mit ID < 900 eintragen.');
      end if;

      insert into sec_section_info
      values
        (out_section_id,
         in_module_id,
         in_section_name,
         out_section_caption,
         io_section_description,
         '',
         NULL,
         NULL);

    end if;

    close c_section_info;
  end;

  /*******************************************************************************
  * procedure C_CHECK_ACTION_EXISTENCE (in_section_id in number,
  *                                     in_action_name in varchar2,
  *                                     io_action_description in out varchar2,
  *                                     io_action_caption in out varchar2,
  *                                     out_action_help_file out varchar2,
  *                                     out_action_id out number) is
  *******************************************************************************/
  procedure c_check_action_existence(in_section_id         in number,
                                     in_action_name        in varchar2,
                                     io_action_description in out varchar2,
                                     io_action_caption     in out varchar2,
                                     out_action_help_file  out varchar2,
                                     out_action_id         out number) is
    v_action_info sec_action_info%rowtype;
    v_found       boolean;

    cursor c_action_info is
      select *
        from sec_action_info
       where name = in_action_name
         and section_id = in_section_id;
  begin
    out_action_help_file := '';
    --if io_action_caption = ''
    --then
    --  io_action_caption := in_action_name;
    --end if;

    open c_action_info;

    fetch c_action_info
      into v_action_info;
    v_found := c_action_info%found;

    close c_action_info;

    if v_found
    then
      out_action_id         := v_action_info.action_id;
      out_action_help_file  := v_action_info.help_file;
      io_action_description := v_action_info.description;
      io_action_caption     := v_action_info.caption;
    else
      out_action_id := null;
      if io_action_caption is not null
      then
        select seq_sec_action_id.nextval into out_action_id from dual;

        if out_action_id < 900
        then
          raise_application_error(-20001,'Applikationen der Version 3.3 dürfen keine neuen Actions mit ID < 900 eintragen.');
        end if;
        insert into sec_action_info
        values
          (out_action_id,
           in_section_id,
           in_action_name,
           io_action_caption,
           io_action_description,
           '',
           NULL,
           NULL,
           NULL,
           NULL,
           sysdate);

        commit;
      end if;

      -- raise_application_error(-20001,'Applikationen der Version 3.3 dürfen keine neuen Sections eintragen.');
    end if;
  exception
    when others then
      rollback;
      raise;
  end;

  procedure get_firma_daten(in_sid                    in  isi_sid.sid%type,
                            in_firma_nr               in  isi_firma.firma_nr%type,
                            out_firma_daten           out isi_firma%rowtype) is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  v_found boolean;

  CURSOR c_firma is
    select t.*
      from isi_firma t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr;
  begin
    OPEN c_firma;
    FETCH c_firma into out_firma_daten;
    v_found := c_firma%FOUND;
    CLOSE c_firma;

    if not v_found
    then
      v_err_nr := 10;
      v_err_text := 'Fehler: Firma mit SID: ' || in_sid || ' Firma Nr.: ' || to_char(in_firma_nr) || ' fehlt.';
      raise v_error;
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
  end;

  -- Ende Version 3.3


  /*******************************************************************************
  * procedure c_check_module_existense (...)
  *******************************************************************************/
  procedure c_check_module_existense_34 (in_module_name         in varchar2,
                                         in_module_description  in varchar2,
                                         in_module_caption      in varchar2,
                                         out_module_help_file   out varchar2,
                                         in_module_id           in number,
                                         in_lang_cn_caption     in sec_module_info.lang_cn_caption%type,
                                         in_lang_cn_description in sec_module_info.lang_cn_description%type) is
    v_module_info sec_module_info%rowtype;

    cursor c_module_info is
      select *
        from sec_module_info
       where name = in_module_name;

    cursor c_module_info_alt is
      select t.*
        from sec_module_info t
       where t.caption = in_module_caption;

    v_found boolean;
  begin
    out_module_help_file := '';

    open c_module_info;

    fetch c_module_info
      into v_module_info;
    v_found := c_module_info%found;

    close c_module_info;

    if not v_found
    then
      open c_module_info_alt;
      fetch c_module_info_alt into v_module_info;
      v_found := c_module_info_alt%found;
      close c_module_info_alt;
    end if;

    if v_found
    then
      out_module_help_file  := v_module_info.help_file;
      if in_module_id <> v_module_info.mod_id
      then
        -- erst mal schauen, ob die ID bereits vergeben ist
        update sec_module_info t
           set t.mod_id = in_module_id + 700
         where t.mod_id = in_module_id;

        update sec_group_modules t
           set t.mod_id = in_module_id + 700
         where t.mod_id = in_module_id;

        update sec_section_info t
           set t.mod_id = in_module_id + 700
         where t.mod_id = in_module_id;

        update sec_module_info t
           set t.mod_id = in_module_id,
               t.name = in_module_name,
               t.caption = in_module_caption,
               t.description = in_module_description,
               t.lang_cn_caption = in_lang_cn_caption,
               t.lang_cn_description = in_lang_cn_description
         where t.mod_id = v_module_info.mod_id;

        update sec_group_modules t
           set t.mod_id = in_module_id
         where t.mod_id = v_module_info.mod_id;

        update sec_section_info t
           set t.mod_id = in_module_id
         where t.mod_id = v_module_info.mod_id;

        commit;
      end if;
    else
      insert into sec_module_info
      values
        (in_module_id,
         in_module_name,
         in_module_caption,
         in_module_description,
         out_module_help_file,
         in_lang_cn_caption,
         in_lang_cn_description
        );

      commit;
    end if;
  end;

  /*******************************************************************************
  * procedure C_CHECK_SECTION_EXISTENCE (...) is
  *******************************************************************************/
  procedure c_check_section_existence_34 (in_mod_id              in number,
                                          in_section_name        in varchar2,
                                          in_section_description in varchar2,
                                          in_section_caption     in varchar2,
                                          out_section_help_file  out varchar2,
                                          out_section_id         out number,
                                          in_lang_cn_caption     in sec_section_info.lang_cn_caption%type,
                                          in_lang_cn_description in sec_section_info.lang_cn_description%type) is
    v_section_info sec_section_info%rowtype;

    cursor c_section_info is
      select *
        from sec_section_info
       where name = in_section_name
         and mod_id = in_mod_id;

    cursor c_section_info_alt is
      select t.*
        from sec_section_info t
       where t.caption = in_section_caption
         and t.mod_id = in_mod_id;

    v_found boolean;
  begin
    out_section_help_file := '';

    open c_section_info;

    fetch c_section_info
      into v_section_info;
    v_found := c_section_info%found;

    close c_section_info;

    if not v_found
    then
      open c_section_info_alt;
      fetch c_section_info_alt into v_section_info;
      v_found := c_section_info_alt%found;
      close c_section_info_alt;
    end if;

    if v_found
    then
      out_section_id         := v_section_info.section_id;
      out_section_help_file  := v_section_info.help_file;

      --if nvl(v_section_info.caption, 'NULL') != in_section_caption
      --then
        update sec_section_info t
           set t.name = in_section_name,
               t.caption = in_section_caption,
               t.description = in_section_description,
               t.lang_cn_caption = in_lang_cn_caption,
               t.lang_cn_description = in_lang_cn_description
         where t.section_id = v_section_info.section_id;

        commit;
      --end if;
    else
      select seq_sec_section_id.nextval into out_section_id from dual;

      insert into sec_section_info
      values
        (out_section_id,
         in_mod_id,
         in_section_name,
         in_section_caption,
         in_section_description,
         out_section_help_file,
         in_lang_cn_caption,
         in_lang_cn_description);

      commit;
    end if;
  end;

  /*******************************************************************************
  * procedure C_CHECK_ACTION_EXISTENCE (...) is
  *******************************************************************************/
  procedure c_check_action_existence_34 (in_mod_id              in number,
                                         in_action_name         in varchar2,
                                         in_action_description  in varchar2,
                                         in_action_caption      in varchar2,
                                         in_category            in varchar2,
                                         out_action_help_file   out varchar2,
                                         out_action_id          out number,
                                         in_lang_cn_caption     in sec_action_info.lang_cn_caption%type,
                                         in_lang_cn_description in sec_action_info.lang_cn_description%type) is
    v_action_info sec_action_info%rowtype;
    v_found       boolean;
    v_section_id  number;

    cursor c_action_info is
      select t.*
        from sec_action_info t
       where t.name = in_action_name
         and t.mod_id = in_mod_id;

    cursor c_action_info_alt is
      select t.*
        from sec_action_info t,
             sec_section_info si
       where (t.caption = in_action_caption or t.name = in_action_name)
         and t.section_id = si.section_id
         and (si.name = in_category
              or (si.mod_id = in_mod_id and si.lang_cn_caption like '_MOD_%')
             );
  begin
    out_action_help_file := '';
    v_section_id := get_section_id(in_mod_id, in_category);
    v_section_id := nvl(v_section_id, -1);

    open c_action_info;

    fetch c_action_info
      into v_action_info;
    v_found := c_action_info%found;

    close c_action_info;

    /* AG 26.06.2014 nicht mehr nötig
    if not v_found
    then
      open c_action_info_alt;
      fetch c_action_info_alt into v_action_info;
      v_found := c_action_info_alt%found;
      close c_action_info_alt;
    end if;
    */


    if v_found
    then
      out_action_id        := v_action_info.action_id;
      out_action_help_file := v_action_info.help_file;

      --if (v_action_info.section_id != v_section_id)
      --   or (nvl(v_action_info.caption, 'NULL') != in_action_caption)
      --then
        update sec_action_info t
           set t.section_id = v_section_id,
               t.name = in_action_name,
               t.caption = in_action_caption,
               t.description = in_action_description,
               t.mod_id = in_mod_id,
               t.category = in_category,
               t.lang_cn_caption = in_lang_cn_caption,
               t.lang_cn_description = in_lang_cn_description
         where t.action_id = v_action_info.action_id;

        commit;
      --end if;
    else
      select seq_sec_action_id.nextval into out_action_id from dual;

      insert into sec_action_info
      values
        (out_action_id,
         v_section_id,
         in_action_name,
         in_action_caption,
         in_action_description,
         out_action_help_file,
         in_mod_id,
         in_category,
         in_lang_cn_caption,
         in_lang_cn_description,
         sysdate                       -- ab version 3.5 -BW-
        );

      commit;
    end if;
  exception
    when others then
      rollback;
      raise_application_error(-20001, 'ModID: ' || nvl(to_char(in_mod_id), '(NULL)') ||
                                      ' ActionName: ' || nvl(in_action_name, '(NULL)') ||
                                      ' Category: ' || nvl(in_category, '(KEINE)'), true);
  end;

  /*******************************************************************************
  * procedure GET_ENABLED_MODULES(...)
  *******************************************************************************/
  procedure get_enabled_modules(in_sid                in varchar2,
                                in_login_id           in number,
                                out_cs_module_id_list out varchar2,
                                in_separator          in varchar2 default ',') is

    v_module_id sec_group_modules.mod_id%type;

    cursor c_enabled_modules is
      select distinct sec_group_modules.mod_id
        from isi_user,
             sec_user_groups,
             sec_group_modules
       where isi_user.sid = in_sid
         and isi_user.login_id = in_login_id
         and sec_user_groups.login_id = isi_user.login_id
         and sec_user_groups.sid = isi_user.sid
         and sec_user_groups.firma_nr = isi_user.firma_nr
         and sec_group_modules.group_id = sec_user_groups.group_id
         and sec_group_modules.sid = sec_user_groups.sid
         and sec_group_modules.firma_nr = sec_user_groups.firma_nr;
  begin
    out_cs_module_id_list := null;

    open c_enabled_modules;

    loop
      fetch c_enabled_modules
        into v_module_id;
      exit when c_enabled_modules%notfound;

      if out_cs_module_id_list is null
      then
        out_cs_module_id_list := to_char(v_module_id);
      else
        out_cs_module_id_list := out_cs_module_id_list || in_separator ||
                                 to_char(v_module_id);
      end if;

    end loop;

    close c_enabled_modules;

    if out_cs_module_id_list is null
    then
      out_cs_module_id_list := '';
    end if;
  end;

  /*******************************************************************************
  * procedure GET_ENABLED_SECTIONS(...)
  *******************************************************************************/
  procedure get_enabled_sections(in_sid                 in varchar2,
                                 in_login_id            in number,
                                 in_module_id           in number,
                                 out_cs_section_id_list out varchar2,
                                 in_separator           in varchar2 default ',') is

    v_section_id sec_group_sections.section_id%type;

    cursor c_enabled_sections is
      select distinct sec_group_sections.section_id
        from isi_user,
             sec_user_groups,
             sec_group_sections,
             sec_section_info
       where isi_user.sid = in_sid
         and isi_user.login_id = in_login_id
         and sec_section_info.mod_id = in_module_id
         and sec_user_groups.login_id = isi_user.login_id
         and sec_user_groups.sid = isi_user.sid
         and sec_user_groups.firma_nr = isi_user.firma_nr
         and sec_group_sections.group_id = sec_user_groups.group_id
         and sec_group_sections.sid = sec_user_groups.sid
         and sec_group_sections.firma_nr = sec_user_groups.firma_nr
         and sec_group_sections.section_id = sec_section_info.section_id;
  begin
    out_cs_section_id_list := null;
    open c_enabled_sections;

    loop
      fetch c_enabled_sections
        into v_section_id;
      exit when c_enabled_sections%notfound;

      if out_cs_section_id_list is null
      then
        out_cs_section_id_list := to_char(v_section_id);
      else
        out_cs_section_id_list := out_cs_section_id_list || in_separator ||
                                  to_char(v_section_id);
      end if;

    end loop;

    close c_enabled_sections;

    if out_cs_section_id_list is null
    then
      out_cs_section_id_list := '';
    end if;
  end;

  /*******************************************************************************
  * procedure GET_ENABLED_ACTIONS(...)
  *******************************************************************************/
  procedure get_enabled_actions(in_sid                in varchar2,
                                in_login_id           in number,
                                in_section_id         in number,
                                out_cs_action_id_list out varchar2,
                                in_separator          in varchar2 default ',') is

    v_action_id sec_group_actions.action_id%type;

    cursor c_enabled_actions is
      select distinct sec_group_actions.action_id
        from isi_user,
             sec_user_groups,
             sec_group_actions,
             sec_action_info
       where isi_user.sid = in_sid
         and isi_user.login_id = in_login_id
         and sec_action_info.section_id = in_section_id
         and sec_user_groups.login_id = isi_user.login_id
         and sec_user_groups.sid = isi_user.sid
         and sec_user_groups.firma_nr = isi_user.firma_nr
         and sec_group_actions.group_id = sec_user_groups.group_id
         and sec_group_actions.sid = sec_user_groups.sid
         and sec_group_actions.firma_nr = sec_user_groups.firma_nr
         and sec_group_actions.action_id = sec_action_info.action_id;
  begin
    out_cs_action_id_list := null;
    open c_enabled_actions;

    loop
      fetch c_enabled_actions
        into v_action_id;
      exit when c_enabled_actions%notfound;

      if out_cs_action_id_list is null
      then
        out_cs_action_id_list := to_char(v_action_id);
      else
        out_cs_action_id_list := out_cs_action_id_list || in_separator ||
                                 to_char(v_action_id);
      end if;

    end loop;

    close c_enabled_actions;

    if out_cs_action_id_list is null
    then
      out_cs_action_id_list := '';
    end if;
  end;

  /*******************************************************************************
  * function IS_USER_VALID(...) return boolean
  *******************************************************************************/
  function is_user_valid(in_username  in varchar2,
                         in_password  in varchar2,
                         out_sid      out varchar2,
                         out_login_id out number,
                         out_firma_nr out number,
                         out_pers_nr  out number) return boolean is
    v_result boolean;
    v_user   isi_user%rowtype;
    cursor c_isi_user is
      select *
        from isi_user
       where lower(username) = lower(in_username)
         and lower(passwort) = lower(in_password);
  begin
    v_result     := false;
    out_login_id := -1;
    out_pers_nr  := -1;

    open c_isi_user;

    fetch c_isi_user
      into v_user;
    if c_isi_user%found
    then
      v_result     := true;
      out_sid      := v_user.sid;
      out_login_id := v_user.login_id;
      out_firma_nr := v_user.firma_nr;
      if v_user.pers_nr is not null
      then
        out_pers_nr := v_user.pers_nr;
      end if;
    end if;

    close c_isi_user;

    return(v_result);
  end;

  /*******************************************************************************
  * function IS_USER_VALID(...) return boolean
  *******************************************************************************/
  function is_user_valid(in_username    in varchar2,
                         in_password    in varchar2,
                         out_user_daten out isi_user%rowtype) return boolean is
    v_result boolean;
    cursor c_isi_user is
      select *
        from isi_user
       where lower(username) = lower(in_username)
         and lower(passwort) = lower(in_password);

    cursor c_group_security_level is
      select max(security_level)
        from sec_groups,
             sec_user_groups
       where sec_groups.sid = sec_user_groups.sid
         and sec_groups.firma_nr = sec_user_groups.firma_nr
         and sec_groups.group_id = sec_user_groups.group_id
         and sec_user_groups.sid = out_user_daten.sid
         and sec_user_groups.firma_nr = out_user_daten.firma_nr
         and sec_user_groups.login_id = out_user_daten.login_id;
  begin
    open c_isi_user;

    fetch c_isi_user
      into out_user_daten;
    v_result := c_isi_user%found;

    close c_isi_user;

    if v_result
    then
      if out_user_daten.security_level is null
      then
        open c_group_security_level;

        fetch c_group_security_level
          into out_user_daten.security_level;
        if c_group_security_level%notfound
        then
          out_user_daten.security_level := 0;
        end if;

        close c_group_security_level;
      end if;
    end if;

    return(v_result);
  end;

  /*******************************************************************************
  * function IS_TRANSPONDER_VALID(...) return boolean
  * (neue Implementierung für die Rückgabe aller Benutzerdaten)
  *******************************************************************************/
  function is_transponder_valid(in_transponder_key in varchar2,
                                out_user_daten     out isi_user%rowtype)
    return boolean is
    v_result boolean;

    cursor c_isi_user is
      select * from isi_user where transponder = in_transponder_key;

    cursor c_group_security_level is
      select max(security_level)
        from sec_groups,
             sec_user_groups
       where sec_groups.sid = sec_user_groups.sid
         and sec_groups.firma_nr = sec_user_groups.firma_nr
         and sec_groups.group_id = sec_user_groups.group_id
         and sec_user_groups.sid = out_user_daten.sid
         and sec_user_groups.firma_nr = out_user_daten.firma_nr
         and sec_user_groups.login_id = out_user_daten.login_id;
  begin
    open c_isi_user;

    fetch c_isi_user
      into out_user_daten;
    v_result := c_isi_user%found;

    close c_isi_user;

    if v_result
    then
      if out_user_daten.security_level is null
      then
        open c_group_security_level;

        fetch c_group_security_level
          into out_user_daten.security_level;
        if c_group_security_level%notfound
        then
          out_user_daten.security_level := 0;
        end if;

        close c_group_security_level;
      end if;
    end if;

    return(v_result);
  end;

  /*******************************************************************************
  * function IS_TRANSPONDER_VALID(...) return boolean
  *******************************************************************************/
  function is_transponder_valid(in_transponder_key in varchar2,
                                out_sid            out varchar2,
                                out_login_id       out number,
                                out_firma_nr       out number,
                                out_username       out varchar2,
                                out_pers_nr        out number) return boolean is
    v_result boolean;
    v_user   isi_user%rowtype;
    cursor c_isi_user is
      select * from isi_user where transponder = in_transponder_key;
  begin
    v_result     := false;
    out_login_id := -1;
    out_username := '';
    out_pers_nr  := -1;

    open c_isi_user;

    fetch c_isi_user
      into v_user;

    if c_isi_user%found
    then
      v_result     := true;
      out_sid      := v_user.sid;
      out_login_id := v_user.login_id;
      out_firma_nr := v_user.firma_nr;

      if v_user.pers_nr is not null
      then
        out_pers_nr := v_user.pers_nr;
      end if;

      if v_user.username is not null
      then
        out_username := v_user.username;
      end if;
    end if;

    close c_isi_user;

    return(v_result);
  end;

  procedure alles_freigeben_fuer_gruppe(in_sid      in varchar2,
                                        in_firma_nr in number,
                                        in_group_id in sec_groups.group_id%type) is
  begin
    delete from sec_group_modules
     where sid = in_sid
       and firma_nr = in_firma_nr
       and group_id = in_group_id;

    delete from sec_group_sections
     where sid = in_sid
       and firma_nr = in_firma_nr
       and group_id = in_group_id;

    delete from sec_group_actions
     where sid = in_sid
       and firma_nr = in_firma_nr
       and group_id = in_group_id;

    commit;

    insert into sec_group_modules
      select in_sid,
             in_group_id,
             mod_id,
             in_firma_nr
        from sec_module_info;
    commit;

    insert into sec_group_sections
      select in_sid,
             in_group_id,
             section_id,
             in_firma_nr
        from sec_section_info;
    commit;

    insert into sec_group_actions
      select in_sid,
             in_group_id,
             action_id,
             in_firma_nr
        from sec_action_info;
    commit;

  end;

  procedure c_delete_action_info(in_action_id in sec_action_info.action_id%type) is
  begin
    delete from sec_action_info t where t.action_id = in_action_id;

    delete from sec_group_actions t where t.action_id = in_action_id;

    commit;
  exception
    when others then
      rollback;
      raise;
  end;

end security;
/



-- sqlcl_snapshot {"hash":"76b974148e9bd1ce7d3747990049b2e3f757d632","type":"PACKAGE_BODY","name":"SECURITY","schemaName":"DIRKSPZM32","sxml":""}