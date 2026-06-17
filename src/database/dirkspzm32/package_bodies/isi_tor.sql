create or replace 
package body DIRKSPZM32.isi_tor is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  function c_tor_open_time(in_tor_id            in isi_tor_cfg.tor_id_lesegeraet%type,
                           in_tor_rs485_adresse in isi_tor_cfg.tor_rs485_adresse%type,
                           in_transponder       in isi_user.transponder%type
                          ) return number is

    v_tor_open_time     number;
    v_tor               isi_tor_cfg%rowtype;
    v_tor_user          isi_tor_user%rowtype;
    v_user              isi_user%rowtype;

    v_found             boolean;

    CURSOR c_tor is
      select *
        from isi_tor_cfg tor
       where tor.tor_id_lesegeraet = in_tor_id
         and (tor.tor_rs485_adresse = in_tor_rs485_adresse
          or  tor.tor_rs485_adresse = 255);

    CURSOR c_tor_user is
      select *
        from isi_tor_user tor_user
       where tor_user.login_id = v_user.login_id
         and tor_user.tor_name = v_tor.tor_name;

    CURSOR c_user is
      select *
        from isi_user u
       where u.transponder = in_transponder;
  begin
    v_tor_open_time := 0;

    OPEN c_tor;
    FETCH c_tor into v_tor;                    -- Tordaten lesen
    v_found := c_tor%FOUND;                 -- Gefunden ?
    CLOSE c_tor;

    if not v_found then
      v_err_nr := 10;
      v_err_text := 'Tor Leser ' || in_tor_id || ' Adr. ' || in_tor_rs485_adresse || ' fehlt.';
    end if;

    OPEN c_user;
    FETCH c_user into v_user;                  -- Userdaten lesen
    v_found := c_user%FOUND;                -- Gefunden ?
    CLOSE c_user;

    if not v_found then
      v_err_nr := 20;
      v_err_text := 'Transponder: ' || in_transponder || 'nicht zulässig.';
    else
      if v_tor.tor_alle != 'T' then  -- Hier dürfen alle bekannten User das Tor öffnen
        OPEN c_tor_user;
        FETCH c_tor_user into v_tor_user;                  -- Tordaten lesen
        v_found := c_tor_user%FOUND;               -- Gefunden ?
        CLOSE c_tor_user;

        if not v_found then
          v_err_nr := 30;
          v_err_text := 'Transponder: ' || in_transponder || ' am Tor Leser ' || v_tor.tor_name || 'nicht zulässig.';
        else
          v_tor_open_time := v_tor.tor_offen_zeit;
        end if;
      else
        v_tor_open_time := v_tor.tor_offen_zeit;
      end if;
    end if;

    insert into isi_tor_user_bh t
       values(v_tor.com_name,                        -- COM_NAME     VARCHAR2(15) not null,
              in_transponder,                        -- TRANSPONDER  VARCHAR2(255) not null,
              decode(v_tor_open_time, 0, 'F', 'T'),  -- ZUTRITT      VARCHAR2(1),
              sysdate,                               -- ZUTRITT_ZEIT DATE not null
              v_tor.tor_rs485_adresse);
    commit;
    return(v_tor_open_time);
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

  function tor_check_dauer_open(in_tor_id            in isi_tor_cfg.tor_id_lesegeraet%type,
                                in_tor_rs485_adresse in isi_tor_cfg.tor_rs485_adresse%type
                                ) return number is
    v_tor           isi_tor_cfg%rowtype;

    v_feiertag      number;
    v_s_feiertag    number;

    v_found         boolean;
    v_DayOfWeek      integer;


    CURSOR c_tor is
      select *
        from isi_tor_cfg tor
       where tor.tor_id_lesegeraet = in_tor_id
         and tor.tor_rs485_adresse = in_tor_rs485_adresse;

  begin
    OPEN c_tor;
    FETCH c_tor into v_tor;                    -- Tordaten lesen
    v_found := c_tor%FOUND;                 -- Gefunden ?
    CLOSE c_tor;

    if not v_found then
      v_err_nr := 10;
      v_err_text := 'Tor Leser ' || in_tor_id || ' Adr. ' || in_tor_rs485_adresse || ' fehlt.';
      return (0);
    end if;

    if v_tor.tor_dauer_offen <> 'T'
    then
      return (0);
    end if;

    v_feiertag := ist_feiertag(NULL, NULL, NULL, NULL, sysdate, v_s_feiertag);

    if  v_feiertag <> 1
    or v_tor.tor_dauer_offen_feiertag = 'T'
    then
      v_DayOfWeek := isi_utils.Iso_WeekDay(sysdate); -- INFO: 1 = Mo, 2 = Di, ...
      if  v_DayOfWeek = 1 and v_tor.tor_dauer_offen_mo = 'T'
      or  v_DayOfWeek = 2 and v_tor.tor_dauer_offen_di = 'T'
      or  v_DayOfWeek = 3 and v_tor.tor_dauer_offen_mi = 'T'
      or  v_DayOfWeek = 4 and v_tor.tor_dauer_offen_do = 'T'
      or  v_DayOfWeek = 5 and v_tor.tor_dauer_offen_fr = 'T'
      or  v_DayOfWeek = 6 and v_tor.tor_dauer_offen_sa = 'T'
      or  v_DayOfWeek = 7 and v_tor.tor_dauer_offen_so = 'T'
      then
        if  fraction_of_day(sysdate) >= fraction_of_day(v_tor.tor_dauer_offen_von)
        and fraction_of_day(sysdate) <= fraction_of_day(v_tor.tor_dauer_offen_bis)
        then
          return(255);
        end if;
      end if;
    end if;
    return (0);
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

end;
/



-- sqlcl_snapshot {"hash":"61c193d44dfcabb67515feb0256bccc696158718","type":"PACKAGE_BODY","name":"ISI_TOR","schemaName":"DIRKSPZM32","sxml":""}