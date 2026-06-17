create or replace 
package body DIRKSPZM32.isi_p_log is
  -- Funktions und Prozedur-Deklaration

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  procedure c_isi_system_meldung(in_sid                       in isi_sid.sid%type,
                                 in_firma                     in isi_firma.firma_nr%type,
                                 in_programm                  in isi_log.log_programm%type,
                                 in_modul                     in isi_log.log_modul%type,
                                 in_category                  in isi_log.log_category%type,
                                 in_computer                  in isi_arbeitsplatz.ip_adresse%type,
                                 in_arbeitsplatz_id           in isi_arbeitsplatz.arbeitsplatz_id%type,
                                 in_user_login_id             in isi_user.login_id%type,
                                 in_meldung_engine_id         in meldung_cfg.engine_id%type,
                                 in_meldung_nr                in meldung_texte.mt_fehlernr%type,
                                 in_details                   in isi_log.log_details%type,
                                 in_log_type                  in isi_log.log_typ%type,
                                 in_log_level                 in isi_log.log_level%type default 4) is
  begin
    isi_system_meldung(in_sid,                                -- in_sid                       in isi_sid.sid%type,
                       in_firma,                              -- in_firma                     in isi_firma.firma_nr%type,
                       in_programm,                           -- in_programm                  in isi_log.log_programm%type,
                       in_modul,                              -- in_modul                     in isi_log.log_modul%type,
                       in_category,                           -- in_category                  in isi_log.log_category%type,
                       in_computer,                           -- in_computer                  in isi_arbeitsplatz.ip_adresse%type,
                       in_arbeitsplatz_id,                    -- in_arbeitsplatz_id           in isi_arbeitsplatz.arbeitsplatz_id%type,
                       in_user_login_id,                      -- in_user_login_id             in isi_user.login_id%type,
                       in_meldung_engine_id,                  -- in_meldung_engine_id         in meldung_cfg.engine_id%type,
                       in_meldung_nr,                         -- in_meldung_nr                in meldung_texte.mt_fehlernr%type,
                       in_details,                            -- in_details                   in isi_log.log_details%type,
                       in_log_type,                           -- in_log_type                  in isi_log.log_typ%type,
                       in_log_level);                         -- in_log_level                 in isi_log.log_level%type default 4) is

    commit;
  exception
    -- Wenn das Fehlerloggen einen Fehler macht, dann machen wir hier kene Exception (Rekursive Aufrufe vermeiden)
    when others then
      null;
  end c_isi_system_meldung;

  procedure isi_system_meldung(in_sid                       in isi_sid.sid%type,
                               in_firma                     in isi_firma.firma_nr%type,
                               in_programm                  in isi_log.log_programm%type,
                               in_modul                     in isi_log.log_modul%type,
                               in_category                  in isi_log.log_category%type,
                               in_computer                  in isi_arbeitsplatz.ip_adresse%type,
                               in_arbeitsplatz_id           in isi_arbeitsplatz.arbeitsplatz_id%type,
                               in_user_login_id             in isi_user.login_id%type,
                               in_meldung_engine_id         in meldung_cfg.engine_id%type,
                               in_meldung_nr                in meldung_texte.mt_fehlernr%type,
                               in_details                   in isi_log.log_details%type,
                               in_log_type                  in isi_log.log_typ%type,
                               in_log_level                 in isi_log.log_level%type default 4) is

  v_isi_log                    isi_log%rowtype;             -- Letzter Logeintrag diese Meldung
  v_log_status                 isi_log.log_status%type;     -- Logstatus zum Eintragen in der Tabelle
  v_mc_typ                     number;
  v_log_id                     number;

  v_found                      boolean;

  CURSOR c_isi_log is
    select l.*
      from isi_log l
     where (nvl(l.log_error_code, -1) = nvl(in_meldung_nr, -1)
         or l.log_details = in_details)
       and l.log_time > systimestamp - 1 / 1440
       and nvl(l.log_programm, 'x_fehlt') = nvl(in_programm, 'x_fehlt')
       and nvl(l.log_modul, 'x_fehlt') = nvl(in_modul, 'x_fehlt')
       and nvl(l.log_computer, 'x_fehlt') = nvl(in_computer, 'x_fehlt')
     order by l.log_time desc;

  begin

    OPEN c_isi_log;
    FETCH c_isi_log into v_isi_log;
    v_found := c_isi_log%FOUND;
    CLOSE c_isi_log;

    v_mc_typ := 0;

    if in_log_type = 'I'
    then
      v_mc_typ := c.MSG_MC_INFO;
      v_log_status := NULL;
    elsif in_log_type = 'W'
    then
      v_mc_typ := c.MSG_MC_WARNING;
      v_log_status := NULL;
    elsif in_log_type = 'E'
    then
      v_mc_typ := c.MSG_MC_ERROR;
      v_log_status := 'WQ';
    end if;

    if v_found and in_log_type not like '%L'
    then
      update isi_log l
         set l.log_msg_count = l.log_msg_count + 1
       where (nvl(l.log_error_code, -1) = nvl(in_meldung_nr, -1)
           or l.log_details = in_details)
         and l.log_time > systimestamp - 1 / 1440
         and nvl(l.log_programm, 'x_fehlt') = nvl(in_programm, 'x_fehlt')
         and nvl(l.log_modul, 'x_fehlt') = nvl(in_modul, 'x_fehlt')
         and nvl(l.log_computer, 'x_fehlt') = nvl(in_computer, 'x_fehlt');
    else
      if in_log_type not like '%L'
      then
        isi_message_board.send_message(NULL,                 -- in_sender_name                 in     varchar2,
                                       NULL,                 -- in_sender_module_name          in     varchar2,
                                       NULL,                 -- in_sender_application_handle   in     varchar2,
                                       NULL,                 -- in_recipient_name              in     varchar2,
                                       NULL,                 -- in_recipient_module_name       in     varchar2,
                                       NULL,                 -- in_response_required           in     boolean,
                                       c.MSG_MT_SYSTEM_MELD, -- in_message_type                in     number,
                                       v_mc_typ,             -- in_message_command             in     number,
                                       0,                    -- in_data_type                   in     number,
                                       in_details);          -- in_data                        in     varchar2)
      end if;

      select seq_isi_log_id.nextval into v_log_id from dual;
      insert into isi_log
      values (systimestamp,
              in_category,
              in_meldung_nr,
              in_details,
              in_log_type,
              in_log_level,
              'WQ',
              in_programm,
              in_modul,
              in_computer,
              1,
              in_sid,
              in_firma,
              v_log_id);
    end if;
  exception
    -- Wenn das Fehlerloggen einen Fehler macht, dann machen wir hier kene Exception (Rekursive Aufrufe vermeiden)
    when others then
      null;
  end isi_system_meldung;

  --------------------------------------------------------------------------------
  -- 05.04.2008 (-WK-)
  -- procedure loggt Aktivitäten in Tabellen und speichert die Umgebungsinformationen
  --
  --------------------------------------------------------------------------------
  procedure db_act_log(in_act_table     in isi_db_act_log.act_table%type,
                       in_act_pk_cols   in isi_db_act_log.act_pk_cols%type,
                       in_act_pk_values in isi_db_act_log.act_pk_values%type,
                       in_act_command   in isi_db_act_log.act_command%type,
                       in_act_info      in isi_db_act_log.act_info%type
                      ) is
    v_act_log_id isi_db_act_log.db_act_log_id%type;
    v_found_act_log_id isi_db_act_log.db_act_log_id%type;

    v_bg_job_id isi_db_act_log.bg_job_id%type;
    v_audsid isi_db_act_log.audsid%type;
    v_client_info isi_db_act_log.client_info%type;
    v_client_ident isi_db_act_log.client_identifier%type;
    v_client_host isi_db_act_log.client_host%type;
    v_client_module_info isi_db_act_log.client_module_info%type;
    v_client_action_info isi_db_act_log.client_action_info%type;
    v_client_os_user isi_db_act_log.client_os_user%type;
    v_terminal isi_db_act_log.terminal%type;

    v_isiusr isi_db_act_log.isiusr%type;

    cursor c_db_act_log is
      select t.db_act_log_id
        from isi_db_act_log t
       where t.db_act_log_id = v_act_log_id;

    v_found boolean;
  begin
    -- BG_JOB_ID: Job ID of the current session if it was established by an Oracle Database background
    -- process. Null if the session was not established by a background process.
    v_bg_job_id := sys_context('USERENV', 'BG_JOB_ID');

    -- SESSIONID: The auditing session identifier.
    v_audsid := sys_context('USERENV', 'SESSIONID');

    -- CLIENT_INFO: Returns up to 64 bytes of user session information that can be stored by an application
    -- using the DBMS_APPLICATION_INFO package.
    v_client_info := sys_context('USERENV', 'CLIENT_INFO');

    -- CLIENT_IDENTIFIER: Returns an identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER
    -- procedure, the OCI attribute OCI_ATTR_CLIENT_IDENTIFIER, or the Java class
    -- Oracle.jdbc.OracleConnection.setClientIdentifier. This attribute is used by various database
    -- components to identify lightweight application users who authenticate as the same database user.
    v_client_ident := sys_context('USERENV', 'CLIENT_IDENTIFIER');

    -- HOST: Name of the host machine from which the client has connected.
    v_client_host := sys_context('USERENV', 'HOST');

    -- MODULE: The application name (module) set through the DBMS_APPLICATION_INFO package or OCI.
    --v_client_module_info := sys_context('USERENV', 'MODULE');

    -- ACTION: Identifies the position in the module (application name) and is set through the
    -- DBMS_APPLICATION_INFO package or OCI.
    --v_client_action_info := sys_context('USERENV', 'ACTION');

    -- OS_USER: Operating system user name of the client process that initiated the database session.
    v_client_os_user := sys_context('USERENV', 'OS_USER');

    -- TERMINAL: The operating system identifier for the client of the current session.
    v_terminal := sys_context('USERENV', 'TERMINAL');

    v_isiusr := isi_utils.get_csv_value(v_client_ident, 'isiusr');

    select seq_db_act_log_id.nextval into v_act_log_id from dual;

    open c_db_act_log;
    fetch c_db_act_log into v_found_act_log_id;
    v_found := c_db_act_log%found;
    close c_db_act_log;

    if v_found
    then
      -- falls wir in die Runde loggen
      delete isi_db_act_log t
       where t.db_act_log_id = v_found_act_log_id;
    end if;

    insert into isi_db_act_log t (
      db_act_log_id,
      log_date,
      audsid,
      bg_job_id,
      client_os_user,
      client_host,
      terminal,
      program,
      client_module_info,
      client_action_info,
      client_info,
      client_identifier,
      isiusr,
      act_table,
      act_pk_cols,
      act_pk_values,
      act_command,
      act_info
    ) values (
      v_act_log_id,
      sysdate,
      v_audsid,
      v_bg_job_id,
      v_client_os_user,
      v_client_host,
      v_terminal,
      null, -- ??? program
      v_client_module_info,
      v_client_action_info,
      v_client_info,
      v_client_ident,
      v_isiusr,
      in_act_table,
      in_act_pk_cols,
      in_act_pk_values,
      in_act_command,
      in_act_info
    );
  end;

end isi_p_log;
/



-- sqlcl_snapshot {"hash":"1dacf4a4b2937b6bacae72aba304d31d901d58cb","type":"PACKAGE_BODY","name":"ISI_P_LOG","schemaName":"DIRKSPZM32","sxml":""}