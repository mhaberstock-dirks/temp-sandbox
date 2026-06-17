create or replace 
package body DIRKSPZM32.ISI_ALLG is
  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  22.09.2004 10:18:15
  __________________________________________________
  Description
  Lagerverwaltung Einlagern
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  21.11.2013   3.5.7.5     (-WK-)   Header added and new release and version handling
  27.11.2009   3.5.0.3     (-BW-)   Minor Release
  22.09.2004   3.3.4.0     (-AG-)   Erstellt
  */


  v_build_number constant number := 5;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
    return(v_release_str);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2
                          ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Function and procedure implementations
  -------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- function holt einen Arbeitsplatzparameter (CFG)
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  function get_arbeitsplatz_cfg (in_arbeitsplatz_id     in       isi_arbeitsplatz_cfg.arbeitsplatz_id%type,
                                 in_modul_name          in       isi_arbeitsplatz_cfg.modul_name%type,
                                 in_modul_funktion      in       isi_arbeitsplatz_cfg.modul_funktion%type,
                                 in_out_modul_parameter in out   isi_arbeitsplatz_cfg.modul_parameter%type
                                ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(255);

    v_arbeitsplatz_cfg               isi_arbeitsplatz_cfg%rowtype;

    v_return                          number;
    v_found                           boolean;

    CURSOR c_arbeitsplatz_cfg is
      select *
        from isi_arbeitsplatz_cfg a
       where a.arbeitsplatz_id = in_arbeitsplatz_id
         and upper(a.modul_name) = upper(in_modul_name)
         and a.modul_funktion = in_modul_funktion;
  begin
    OPEN c_arbeitsplatz_cfg;
    FETCH c_arbeitsplatz_cfg into v_arbeitsplatz_cfg;
    v_found := c_arbeitsplatz_cfg%FOUND;
    CLOSE c_arbeitsplatz_cfg;
    if v_found
    then
      in_out_modul_parameter := v_arbeitsplatz_cfg.modul_parameter;
      v_return := 1;                      -- Gefunden
    else
      in_out_modul_parameter := NULL;
      v_return := 0;                      -- nicht Gefunden
    end if;
    return (v_return);
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
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
 end get_arbeitsplatz_cfg;


  --------------------------------------------------------------------------------
  -- Procedure setzt oder erstellt einen Parameter
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  procedure set_arbeitsplatz_cfg (in_tcpip               in       varchar2,
                                  in_modul_name          in       isi_arbeitsplatz_param.modul_name%type,
                                  in_modul_funktion      in       isi_arbeitsplatz_param.modul_funktion%type,
                                  in_modul_parameter     in       isi_arbeitsplatz_param.modul_parameter%type
                                 ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(255);

    v_arbeitsplatz                    isi_arbeitsplatz%rowtype;
    v_param                           isi_arbeitsplatz_cfg.modul_parameter%type;

    v_found                           boolean;

    CURSOR c_arbeitsplatz_ip is
      select *
        from isi_arbeitsplatz a
       where a.ip_adresse = in_tcpip
          or a.ip_name = in_tcpip;

  begin
    OPEN c_arbeitsplatz_ip;
    FETCH c_arbeitsplatz_ip into v_arbeitsplatz;
    v_found := c_arbeitsplatz_ip%FOUND;
    CLOSE c_arbeitsplatz_ip;

    if v_found
    then
      if get_arbeitsplatz_cfg (v_arbeitsplatz.arbeitsplatz_id, in_modul_name, in_modul_funktion, v_param) = 1
      then
        update isi_arbeitsplatz_cfg a
           set a.modul_parameter = in_modul_parameter
         where a.arbeitsplatz_id = v_arbeitsplatz.arbeitsplatz_id
           and upper(a.modul_name) = upper(in_modul_name)
           and a.modul_funktion = in_modul_funktion;
      else
        insert into isi_arbeitsplatz_cfg a
             values (NULL,                           -- APP_CFG_ID            NUMBER not null,
                     v_arbeitsplatz.arbeitsplatz_id, -- ARBEITSPLATZ_ID       NUMBER not null,
                     in_modul_name,                  -- MODUL_NAME            VARCHAR2(12) not null,
                     in_modul_funktion,              -- MODUL_FUNKTION        VARCHAR2(10) not null,
                     in_modul_parameter,             -- MODUL_PARAMETER       VARCHAR2(120),
                     NULL);                          -- MODUL_START_PARAMETER VARCHAR2(120)
      end if;
    else
      v_err_nr := 10;
      v_err_text := 'Fehler Arbeitsplatz <' || in_tcpip || '> fehlt in der Arbeitsplatzkonfiguration.';
      RAISE v_error;
    end if;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt.
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
  end set_arbeitsplatz_cfg;

  --------------------------------------------------------------------------------
  -- Procedure setzt oder erstellt einen Parameter
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  procedure c_set_arbeitsplatz_cfg (in_tcpip               in       varchar2,
                                    in_modul_name          in       isi_arbeitsplatz_param.modul_name%type,
                                    in_modul_funktion      in       isi_arbeitsplatz_param.modul_funktion%type,
                                    in_modul_parameter     in       isi_arbeitsplatz_param.modul_parameter%type
                                   ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(255);
    -------------------------------------------------------------------------------------------------------

  begin
    set_arbeitsplatz_cfg (in_tcpip, in_modul_name, in_modul_funktion, in_modul_parameter);
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
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
  end c_set_arbeitsplatz_cfg;

  --------------------------------------------------------------------------------
  -- function c_get_global_param
  --------------------------------------------------------------------------------
  function c_get_global_param(
    in_modul_name            in isi_firma_cfg.modul_name%type,
    in_parameter_name        in isi_firma_cfg.parameter_name%type,
    in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
    in_default_param_typ     in isi_firma_cfg.parameter_typ%type default 'BOOLEAN'
  ) return varchar2 is
    v_result isi_firma_cfg.parameter_wert%type;
    -- Isolierte Transaktion (unabhängig vom Aufrufer) einleiten
    pragma autonomous_transaction;
  begin
    v_result := get_global_param(in_modul_name, in_parameter_name,
                                 in_default_param_wert, in_default_param_typ);
    commit;
    return v_result;
  end;

  --------------------------------------------------------------------------------
  -- function get_global_param
  --------------------------------------------------------------------------------
  function get_global_param(
    in_modul_name            in isi_firma_cfg.modul_name%type,
    in_parameter_name        in isi_firma_cfg.parameter_name%type,
    in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
    in_default_param_typ     in isi_firma_cfg.parameter_typ%type default 'BOOLEAN'
  ) return varchar2 is
  begin
    return get_firma_cfg_param('01', 1, 'CFG', null,
                               in_parameter_name, in_modul_name, 'CFG',
                               in_default_param_wert, in_default_param_typ);
  end;

  --------------------------------------------------------------------------------
  -- function gibt einen Parameter aus der Firma CFG zurück, und legt ihn ggf. an
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  function c_get_firma_cfg_param (in_sid                   in isi_firma_cfg.sid%type,
                                  in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                  in_kategorie             in isi_firma_cfg.kategorie%type,
                                  in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                  in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                  in_modul_name            in isi_firma_cfg.modul_name%type,
                                  in_typ                   in isi_firma_cfg.typ%type,
                                  in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                  in_default_param_typ     in isi_firma_cfg.parameter_typ%type
                                 ) return varchar is
    v_result                 isi_firma_cfg.parameter_wert%type;
    -- Isolierte Transaktion (unabhängig vom Aufrufer) einleiten
    pragma autonomous_transaction;
  begin
    v_result := get_firma_cfg_param(in_sid,                  -- in isi_firma_cfg.sid%type,
                                    in_firma_nr,             -- in isi_firma_cfg.firma_nr%type,
                                    in_kategorie,            -- in isi_firma_cfg.kategorie%type,
                                    in_kategorie_ix,         -- in isi_firma_cfg.kategorie_ix%type,
                                    in_parameter_name,       -- in isi_firma_cfg.parameter_name%type,
                                    in_modul_name,           -- in isi_firma_cfg.modul_name%type,
                                    in_typ,                  -- in isi_firma_cfg.typ%type,
                                    in_default_param_wert,   -- in isi_firma_cfg.parameter_wert%type,
                                    in_default_param_typ);   -- in isi_firma_cfg.parameter_typ%type
    commit;
    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- function gibt einen Parameter aus der Firma CFG zurück, und legt ihn ggf. an
  --
  --------------------------------------------------------------------------------
  function get_firma_cfg_param(in_sid                   in isi_firma_cfg.sid%type,
                              in_firma_nr              in isi_firma_cfg.firma_nr%type,
                              in_kategorie             in isi_firma_cfg.kategorie%type,
                              in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                              in_parameter_name        in isi_firma_cfg.parameter_name%type,
                              in_modul_name            in isi_firma_cfg.modul_name%type,
                              in_typ                   in isi_firma_cfg.typ%type,
                              in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                              in_default_param_typ     in isi_firma_cfg.parameter_typ%type
                             ) return varchar is

    v_firma_cfg              isi_firma_cfg%rowtype;
    v_found                  boolean;
    v_result                 isi_firma_cfg.parameter_wert%type;

    -- -AG- 17.12.2010 BugFix wenn der Modulname = NULL
    CURSOR c_firma_cfg is
      select *
        from isi_firma_cfg t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.kategorie = in_kategorie
         and nvl(t.kategorie_ix, 'fehlt;') = nvl(in_kategorie_ix, 'fehlt;')
         and t.parameter_name = in_parameter_name
         and upper(nvl(t.modul_name, 'keins')) = upper(nvl(in_modul_name, 'keins'))
         and t.typ = in_typ;


  begin
    OPEN c_firma_cfg;
    FETCH c_firma_cfg into v_firma_cfg;
    v_found := c_firma_cfg%FOUND;
    CLOSE c_firma_cfg;

    if v_found
    then
      v_result := v_firma_cfg.parameter_wert;
    else
      v_result := in_default_param_wert;

      begin
        insert into isi_firma_cfg t
           (t.sid,                 --  SID            VARCHAR2(2) not null,
            t.firma_nr,            --  FIRMA_NR       NUMBER not null,
            t.kategorie,           --  KATEGORIE      VARCHAR2(40) not null,
            t.kategorie_ix,        --  KATEGORIE_IX   VARCHAR2(40),
            t.parameter_name,      --  PARAMETER_NAME VARCHAR2(40) not null,
            t.parameter_wert,      --  PARAMETER_WERT VARCHAR2(255),
            t.parameter_typ,       --  PARAMETER_TYP  VARCHAR2(15) not null,
            t.modul_name,          --  MODUL_NAME     VARCHAR2(40),
            t.typ)                 --  TYP            VARCHAR2(10) default 'CFG' not null,
          values
           (in_sid,
            in_firma_nr,
            in_kategorie,
            in_kategorie_ix,
            in_parameter_name,
            in_default_param_wert,
            in_default_param_typ,
            in_modul_name,
            in_typ);
      exception
        when others then NULL;
      end;

    end if;
    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt Artikel_CFG zurueck
  --
  --------------------------------------------------------------------------------
  function get_artikel_cfg(in_sid          in isi_artikel_cfg.sid%type,
                           io_artikel_cfg  in out isi_artikel_cfg%rowtype) return boolean is
    v_result boolean;

    cursor c_artikel_cfg is
      select a.*
        from isi_artikel_cfg a
       where a.sid = in_sid;
  begin
    open c_artikel_cfg;
    fetch c_artikel_cfg into io_artikel_cfg;
    v_result := c_artikel_cfg%found;
    close c_artikel_cfg;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Artikeldatensatz anhand der artikel_id zurück
  --
  --------------------------------------------------------------------------------
  function get_artikel_by_artikel_id(in_sid          in isi_artikel.sid%type,
                                     in_artikel_id   in isi_artikel.artikel_id%type,
                                     io_artikel_satz in out isi_artikel%rowtype) return boolean is
    v_result boolean;

    cursor c_artikel is
      select a.*
        from isi_artikel a
       where a.sid = in_sid
         and a.artikel_id = in_artikel_id;
  begin
    open c_artikel;
    fetch c_artikel into io_artikel_satz;
    v_result := c_artikel%found;
    close c_artikel;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Artikeldatensatz anhand der Artikelnummer zurück
  --
  --------------------------------------------------------------------------------
  function get_artikel_by_artikel_nr(in_artikel      in isi_artikel.artikel%type,
                                     io_artikel_satz in out isi_artikel%rowtype) return boolean is
    v_result boolean;

    cursor c_artikel is
      select a.*
        from isi_artikel a
       where a.artikel = in_artikel;
  begin
    open c_artikel;
    fetch c_artikel into io_artikel_satz;
    v_result := c_artikel%found;
    close c_artikel;

    return (v_result);
  end;

  function get_kd_artikel_by_artikel_id(in_sid               in isi_artikel.sid%type,
                                        in_artikel_id        in isi_artikel.artikel_id%type,
                                        in_kunden_nr         in isi_adressen.adr_nr%type,
                                        io_kd_artikel_satz   in out isi_artikel_kunde%rowtype) return boolean is
    v_result boolean;

    cursor c_artikel_kunde is
      select a.*
        from isi_artikel_kunde a
       where a.sid = in_sid
         and a.artikel_id = in_artikel_id
         and a.kunden_nr = in_kunden_nr;
  begin
    io_kd_artikel_satz := NULL;
    open c_artikel_kunde;
    fetch c_artikel_kunde into io_kd_artikel_satz;
    v_result := c_artikel_kunde%found;
    close c_artikel_kunde;

    return (v_result);
  end;


  --------------------------------------------------------------------------------
  -- Function gibt einen Firmadatensatz zurück
  --
  --------------------------------------------------------------------------------
  function get_firma(in_sid      in isi_firma.sid%type,
                     in_firma_nr in isi_firma.firma_nr%type,
                     io_firma    in out isi_firma%rowtype) return boolean is
    v_result boolean;

    cursor c_firma is
      select f.*
        from isi_firma f
       where f.sid = in_sid
         and f.firma_nr = in_firma_nr;
  begin
    open c_firma;
    fetch c_firma into io_firma;
    v_result := c_firma%found;
    close c_firma;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen SID-Datensatz zurück
  --
  --------------------------------------------------------------------------------
  function get_sid(in_sid in isi_sid.sid%type,
                   io_sid in out isi_sid%rowtype) return boolean is
    v_result boolean;

    cursor c_sid is
      select t.*
        from isi_sid t
       where t.sid = in_sid;
  begin
    open c_sid;
    fetch c_sid into io_sid;
    v_result := c_sid%found;
    close c_sid;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen SID-Status zurück
  --
  --------------------------------------------------------------------------------
  function get_sid_status(in_sid in isi_sid.sid%type) return varchar2 is
    v_result varchar2(10);
    v_sid isi_sid%rowtype;
  begin
    if not get_sid(in_sid, v_sid)
    then
      raise_isi_error(-10, 'Für SID ID ' || nvl(in_sid, '(null)') || ' konnten keine Daten gefunden werden.');
    end if;

    v_result := v_sid.sid_status;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand der login_id zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_login_id(in_sid      in isi_user.sid%type,
                                in_login_id in isi_user.login_id%type,
                                io_user    in out isi_user%rowtype) return boolean is
    v_result boolean;

    cursor c_user is
      select u.*
        from isi_user u
       where u.sid = in_sid
         and u.login_id = in_login_id;
  begin
    open c_user;
    fetch c_user into io_user;
    v_result := c_user%found;
    close c_user;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand des Benutzernamens zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_username(in_username in isi_user.username%type,
                                io_user     in out isi_user%rowtype) return boolean is
    v_result boolean;

    cursor c_user is
      select u.*
        from isi_user u
       where u.username = in_username;
  begin
    open c_user;
    fetch c_user into io_user;
    v_result := c_user%found;
    close c_user;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand der personalnummer zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_pers_nr(in_pers_nr  in isi_user.pers_nr%type,
                               io_user     in out isi_user%rowtype) return boolean is
    v_result boolean;

    cursor c_user is
      select u.*
        from isi_user u
       where u.pers_nr = in_pers_nr;
  begin
    open c_user;
    fetch c_user into io_user;
    v_result := c_user%found;
    close c_user;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- Function gibt einen Userdatensatz anhand der TransponderID zurück
  --
  --------------------------------------------------------------------------------
  function get_user_by_transpoder(in_transponder in isi_user.transponder%type,
                                  io_user        in out isi_user%rowtype) return boolean is
    v_result boolean;

    cursor c_user is
      select u.*
        from isi_user u
       where u.transponder = in_transponder;
  begin
    open c_user;
    fetch c_user into io_user;
    v_result := c_user%found;
    close c_user;

    return (v_result);
  end;

  --------------------------------------------------------------------------------
  -- 03.04.08 (-AM-)
  -- Function liest das Feld CLIENT_INFO aus dem 'USERENV'
  --
  --------------------------------------------------------------------------------
  function get_client_info return varchar2 is -- v$session.client_info%type is
    v_cli varchar2(64); --v$session.client_info%type;
  begin
    v_cli := sys_context('USERENV', 'CLIENT_IDENTIFIER');
    --dbms_application_info.read_client_info(v_cli);

    return(v_cli);

  end;

  --------------------------------------------------------------------------------
  -- 03.04.08 (-AM-)
  -- Procedure setzt das Feld CLIENT_INFO im 'USERENV'
  --
  --------------------------------------------------------------------------------
  procedure c_set_client_info(v_cli in varchar2) is -- v$session.client_info%type
  begin
    dbms_session.set_identifier(v_cli);
    --dbms_application_info.set_client_info(v_cli);
  end;

end ISI_ALLG;
/



-- sqlcl_snapshot {"hash":"7f512b2e46592e7aa8462a4cd15dcbb701198193","type":"PACKAGE_BODY","name":"ISI_ALLG","schemaName":"DIRKSPZM32","sxml":""}