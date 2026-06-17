create or replace 
package body DIRKSPZM32.REPORTS is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error          exception;
  v_err_nr         number;
  v_err_text       varchar2(2550);
  -------------------------------------------------------------------------------------------------------

  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end get_version;

  /* obsolete, will be replaced by SET_REP_USER_TOP_PARAMS
  */
  procedure C_ABFRAGE_AUSGEFUEHRT(in_sid in isi_user.sid%TYPE,
                                  in_firma_nr in isi_user.firma_nr%TYPE,
                                  in_login_id in isi_user.login_id%TYPE,
                                  in_rep_id in rep_abfragen.rep_id%TYPE) is

    v_rep_user_top_abfragen rep_user_top_abfragen%ROWTYPE;

    CURSOR c_rep_user_top_abfragen IS
      SELECT *
        FROM rep_user_top_abfragen
       WHERE sid = in_sid
             AND firma_nr = in_firma_nr
             AND login_id = in_login_id
             AND rep_id = in_rep_id
         FOR UPDATE OF counter;
  begin
    OPEN c_rep_user_top_abfragen;

    FETCH c_rep_user_top_abfragen INTO v_rep_user_top_abfragen;

    if c_rep_user_top_abfragen%FOUND then
      UPDATE rep_user_top_abfragen
         SET counter = v_rep_user_top_abfragen.counter + 1
       WHERE CURRENT OF c_rep_user_top_abfragen;
    else
      INSERT INTO rep_user_top_abfragen
           VALUES (in_sid,                      -- SID              VARCHAR2(2) default '01' not null,
                   in_firma_nr,                 -- FIRMA_NR         NUMBER default 1 not null,
                   in_login_id,                 -- LOGIN_ID         NUMBER not null,
                   in_rep_id,                   -- REP_ID           NUMBER not null,
                   1,                           -- COUNTER          NUMBER default 0 not null,
                   NULL,                        -- EXEC_MS_MIN      NUMBER default 0,
                   NULL,                        -- EXEC_MS_MAX      NUMBER default 0,
                   NULL,                        -- EXEC_MS_LAST     NUMBER default 0,
                   NULL,                        -- EXEC_DATE_MIN    DATE,
                   NULL,                        -- EXEC_DATE_MAX    DATE,
                   NULL,                        -- EXEC_DATE_LAST   DATE,
                   NULL,                        -- EXEC_PARAMS_MIN  CLOB,
                   NULL,                        -- EXEC_PARAMS_MAX  CLOB,
                   NULL                         -- EXEC_PARAMS_LAST CLOB
                   );
    end if;

    CLOSE c_rep_user_top_abfragen;

    COMMIT;
  end;


  -- (-TS-) new: SET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061108
  procedure C_SET_REP_USER_TOP_PARAMS(in_sid in isi_user.sid%TYPE,
                                      in_firma_nr in isi_user.firma_nr%TYPE,
                                      in_login_id in isi_user.login_id%TYPE,
                                      in_rep_id in rep_abfragen.rep_id%TYPE,
                                      in_exec_ms_last in integer,
                                      in_exec_params_last in clob) is

    v_rep_user_top_abfragen rep_user_top_abfragen%ROWTYPE;
    v_exec_ms_min           number;
    v_exec_ms_max           number;
    v_exec_date_min         date;
    v_exec_date_max         date;
    v_exec_date_last        date;
    v_exec_params_min       clob;
    v_exec_params_max       clob;

    v_found                 boolean;

    CURSOR c_rep_user_top_abfragen IS
      SELECT *
        FROM rep_user_top_abfragen
       WHERE sid = in_sid
             AND firma_nr = in_firma_nr
             AND login_id = in_login_id
             AND rep_id = in_rep_id;
  begin
    -- get oracle time
    v_exec_date_last := sysdate;

    -- get v_exec_ms_min from table
    select nvl(min(exec_ms_min), 0) into v_exec_ms_min
      from rep_user_top_abfragen
     where sid = in_sid
       and firma_nr = in_firma_nr
       and login_id = in_login_id
       and rep_id = in_rep_id;

    -- get v_exec_ms_max from table
    select nvl(max(exec_ms_max), 0) into v_exec_ms_max
      from rep_user_top_abfragen
     where sid = in_sid
       and firma_nr = in_firma_nr
       and login_id = in_login_id
       and rep_id = in_rep_id;


    OPEN c_rep_user_top_abfragen;

    FETCH c_rep_user_top_abfragen INTO v_rep_user_top_abfragen;
    v_found := c_rep_user_top_abfragen%FOUND;
    CLOSE c_rep_user_top_abfragen;

    if v_found then
      begin
        update rep_user_top_abfragen
          set counter          = v_rep_user_top_abfragen.counter + 1,
              exec_ms_last     = in_exec_ms_last,
              exec_date_last   = v_exec_date_last,
              exec_params_last = in_exec_params_last
        where sid = in_sid
          and firma_nr = in_firma_nr
          and login_id = in_login_id
          and rep_id = in_rep_id;

        -- check if current values are new min values
        if in_exec_ms_last < v_exec_ms_min or
          v_exec_ms_min   = 0
        then
          v_exec_ms_min     := in_exec_ms_last;
          v_exec_date_min   := sysdate;
          v_exec_params_min := in_exec_params_last;
          -- update min values
          update rep_user_top_abfragen
            set exec_ms_min      = v_exec_ms_min,
                exec_date_min    = v_exec_date_min,
                exec_params_min  = v_exec_params_min
          where sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id;
        end if;
        -- check if current values are new max values
        if in_exec_ms_last > v_exec_ms_max then
          v_exec_ms_max     := in_exec_ms_last;
          v_exec_date_max   := sysdate;
          v_exec_params_max := in_exec_params_last;
          -- update max values
          update rep_user_top_abfragen
            set exec_ms_max      = v_exec_ms_max,
                exec_date_max    = v_exec_date_max,
                exec_params_max  = v_exec_params_max
          where sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id;
        end if;
      end;
    else
      begin
        -- this is a new entry, set min/max values to last
        v_exec_ms_min     := in_exec_ms_last;
        v_exec_ms_max     := in_exec_ms_last;

        v_exec_date_min   := v_exec_date_last;
        v_exec_date_max   := v_exec_date_last;

        v_exec_params_min := in_exec_params_last;
        v_exec_params_max := in_exec_params_last;

        insert into rep_user_top_abfragen
             values (in_sid,
                     in_firma_nr,
                     in_login_id,
                     in_rep_id,
                     1,
                     v_exec_ms_min,
                     v_exec_ms_max,
                     in_exec_ms_last,
                     v_exec_date_min,
                     v_exec_date_max,
                     v_exec_date_last,
                     v_exec_params_min,
                     v_exec_params_max,
                     in_exec_params_last);
      end;
    end if;

    commit;
  end;
  -- (-TS-) end: SET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061108

  -- (-TS-) new: GET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061109
  procedure GET_REP_USER_TOP_PARAMS(in_sid in isi_user.sid%TYPE,
                                    in_firma_nr in isi_user.firma_nr%TYPE,
                                    in_login_id in isi_user.login_id%TYPE,
                                    in_rep_id in rep_abfragen.rep_id%TYPE,
                                    out_counter out integer,
                                    out_exec_ms_min out integer,
                                    out_exec_ms_max out integer,
                                    out_exec_ms_last out integer,
                                    out_exec_date_min out date,
                                    out_exec_date_max out date,
                                    out_exec_date_last out date,
                                    out_exec_params_min out clob,
                                    out_exec_params_max out clob,
                                    out_exec_params_last out clob) is

    v_rep_user_top_abfragen rep_user_top_abfragen%ROWTYPE;


    CURSOR c_rep_user_top_abfragen IS
      SELECT *
        FROM rep_user_top_abfragen
       WHERE sid = in_sid
             AND firma_nr = in_firma_nr
             AND login_id = in_login_id
             AND rep_id = in_rep_id;
  begin
    OPEN c_rep_user_top_abfragen;

    FETCH c_rep_user_top_abfragen INTO v_rep_user_top_abfragen;

    if c_rep_user_top_abfragen%FOUND then
      begin
        -- record found
        out_counter            := nvl(v_rep_user_top_abfragen.counter, 0);
        out_exec_ms_min        := nvl(v_rep_user_top_abfragen.exec_ms_min, 0);
        out_exec_ms_max        := nvl(v_rep_user_top_abfragen.exec_ms_max, 0);
        out_exec_ms_last       := nvl(v_rep_user_top_abfragen.exec_ms_last, 0);
        out_exec_date_min      := nvl(v_rep_user_top_abfragen.exec_date_min, sysdate);
        out_exec_date_max      := nvl(v_rep_user_top_abfragen.exec_date_max, sysdate);
        out_exec_date_last     := nvl(v_rep_user_top_abfragen.exec_date_last, sysdate);
        out_exec_params_min    := nvl(v_rep_user_top_abfragen.exec_params_min, '');
        out_exec_params_max    := nvl(v_rep_user_top_abfragen.exec_params_max, '');
        out_exec_params_last   := nvl(v_rep_user_top_abfragen.exec_params_last, '');
      end;
    else
      begin
        -- record not found
        out_counter            := 0;
        out_exec_ms_min        := 0;
        out_exec_ms_max        := 0;
        out_exec_ms_last       := 0;
        out_exec_date_min      := sysdate;
        out_exec_date_max      := sysdate;
        out_exec_date_last     := sysdate;
        out_exec_params_min    := '';
        out_exec_params_max    := '';
        out_exec_params_last   := '';
      end;
    end if;

    CLOSE c_rep_user_top_abfragen;
  end;
  -- (-TS-) end: GET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061109

  procedure GET_REPORT_GRUPPEN(in_sid in isi_sid.sid%TYPE,
                               in_firma_nr in isi_firma.firma_nr%TYPE,
                               in_isi_module_cs in varchar2,
                               in_security_level in integer,
                               out_report_gruppen_cs out varchar2) is

    v_rep_gruppe rep_abfragen.rep_gruppe%TYPE;
    CURSOR c_rep_abfragen IS
      SELECT DISTINCT rep_gruppe
        FROM rep_abfragen
       WHERE (rep_abfragen.mod_id is NULL or in_isi_module_cs LIKE '%' || rep_abfragen.mod_id || '%')
             AND security_level <= in_security_level
             AND rep_intern = 'F';
  begin
    out_report_gruppen_cs := NULL;
    OPEN c_rep_abfragen;

    loop
      FETCH c_rep_abfragen INTO v_rep_gruppe;
      EXIT WHEN c_rep_abfragen%NOTFOUND;

      if out_report_gruppen_cs is NULL then
        out_report_gruppen_cs := v_rep_gruppe;
      else
        out_report_gruppen_cs := out_report_gruppen_cs || ',' || v_rep_gruppe;
      end if;
    end loop;


    CLOSE c_rep_abfragen;
  end;

  procedure GET_REPORT_LISTE(out_report_liste out clob) is
    v_ContextHandle    DBMS_XMLGEN.ctxHandle;
  begin
    v_ContextHandle := dbms_xmlgen.NewContext('SELECT rep_id, rep_name, rep_gruppe, rep_info FROM rep_abfragen');
    dbms_xmlgen.SetRowsetTag(v_ContextHandle, 'report_liste');
    dbms_xmlgen.SetRowTag(v_ContextHandle, 'rep_abfragen');
    out_report_liste := dbms_xmlgen.GetXML(v_ContextHandle);
    dbms_xmlgen.CloseContext(v_ContextHandle);
  end;

  procedure GET_REPORT_LISTE(in_gruppe in varchar2,
                             out_report_liste out clob) is
    v_sql varchar2(255);
    v_ContextHandle    DBMS_XMLGEN.ctxHandle;
  begin
    v_sql := 'SELECT rep_id, rep_name, rep_gruppe, rep_info ' ||
             '  FROM rep_abfragen' ||
             ' WHERE rep_gruppe = ''' || in_gruppe || '''';
    v_ContextHandle := dbms_xmlgen.NewContext(v_sql);
    dbms_xmlgen.SetRowsetTag(v_ContextHandle, 'report_liste');
    dbms_xmlgen.SetRowTag(v_ContextHandle, 'rep_abfragen');
    out_report_liste := dbms_xmlgen.GetXML(v_ContextHandle);
    dbms_xmlgen.CloseContext(v_ContextHandle);
  end;

  procedure EXECUTE_REPORT(in_report_id in rep_abfragen.rep_id%TYPE,
                           in_report_parameters in varchar2,
                           out_result out clob) is

    v_ContextHandle    DBMS_XMLGEN.ctxHandle;
    v_query            rep_abfragen.rep_sql_clob%TYPE;
    v_rep_name         rep_abfragen.rep_name%TYPE;

    CURSOR c_report IS
      SELECT rep_abfragen.rep_sql_clob, rep_abfragen.rep_name
        FROM rep_abfragen
       WHERE rep_abfragen.rep_id = in_report_id;
  begin
    out_result := '';
    OPEN c_report;

    FETCH c_report INTO v_query, v_rep_name;
    if c_report%FOUND AND v_query is not NULL then
      v_ContextHandle := dbms_xmlgen.NewContext(v_query);
      dbms_xmlgen.SetRowsetTag(v_ContextHandle, v_rep_name);
      --dbms_xmlgen.SetRowTag(v_ContextHandle, 'row');
      out_result := dbms_xmlgen.GetXML(v_ContextHandle);
      dbms_xmlgen.CloseContext(v_ContextHandle);
    end if;

    CLOSE c_report;
  end;

  function GET_REPORT_DATA(in_report_name in varchar2,
                           in_report_gruppe in varchar2,
                           out_abfrage_daten out rep_abfragen%rowtype,
                           out_abfrage_parameter_cs out varchar2) return boolean is
    v_result boolean;

    CURSOR c_report_daten IS
      SELECT *
        FROM rep_abfragen
       WHERE upper(rep_name) = upper(in_report_name)
             AND upper(rep_gruppe) = upper(in_report_gruppe);

    v_param_name rep_sql_parameter.param_name%TYPE;

    CURSOR c_report_parameter IS
      SELECT param_name
        FROM rep_sql_parameter
       WHERE rep_id = out_abfrage_daten.rep_id;
  begin
    v_result := false;
    out_abfrage_parameter_cs := NULL;
    OPEN c_report_daten;

    FETCH c_report_daten INTO out_abfrage_daten;
    if c_report_daten%FOUND then
      v_result := true;
      OPEN c_report_parameter;

      loop
        FETCH c_report_parameter INTO v_param_name;
        EXIT WHEN c_report_parameter%NOTFOUND;

        if out_abfrage_parameter_cs is NULL then
          out_abfrage_parameter_cs := v_param_name;
        else
          out_abfrage_parameter_cs := out_abfrage_parameter_cs || ',' || v_param_name;
        end if;
      end loop;

      CLOSE c_report_parameter;
    end if;

    CLOSE c_report_daten;

    if not v_result then
      -- Geändert WK: wenn Report nicht gefunden wurde, soll eine Exception gerissen werden.
      RAISE_APPLICATION_ERROR(-20010, 'Report nicht gefunden: ' || in_report_name || '/' || in_report_gruppe);
    end if;

    return (v_result);
  end;

end REPORTS;
/



-- sqlcl_snapshot {"hash":"448123b828883e16c1c481a7fb785ded5a3c1095","type":"PACKAGE_BODY","name":"REPORTS","schemaName":"DIRKSPZM32","sxml":""}