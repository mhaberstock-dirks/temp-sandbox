create or replace package body dirkspzm32.reports is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(2550);
  -------------------------------------------------------------------------------------------------------

    procedure raise_isi_error (
        in_err_nr   in number,
        in_err_text in varchar2
    ) is
    begin
        v_err_nr := in_err_nr;
        v_err_text := in_err_text;
        raise v_error;
    end;

    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

  /* obsolete, will be replaced by SET_REP_USER_TOP_PARAMS
  */
    procedure c_abfrage_ausgefuehrt (
        in_sid      in isi_user.sid%type,
        in_firma_nr in isi_user.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        in_rep_id   in rep_abfragen.rep_id%type
    ) is

        v_rep_user_top_abfragen rep_user_top_abfragen%rowtype;
        cursor c_rep_user_top_abfragen is
        select
            *
        from
            rep_user_top_abfragen
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id
        for update of counter;

    begin
        open c_rep_user_top_abfragen;
        fetch c_rep_user_top_abfragen into v_rep_user_top_abfragen;
        if c_rep_user_top_abfragen%found then
            update rep_user_top_abfragen
            set
                counter = v_rep_user_top_abfragen.counter + 1
            where
                current of c_rep_user_top_abfragen;

        else
            insert into rep_user_top_abfragen values ( in_sid,                      -- SID              VARCHAR2(2) default '01' not null,
                                                       in_firma_nr,                 -- FIRMA_NR         NUMBER default 1 not null,
                                                       in_login_id,                 -- LOGIN_ID         NUMBER not null,
                                                       in_rep_id,                   -- REP_ID           NUMBER not null,
                                                       1,                           -- COUNTER          NUMBER default 0 not null,
                                                       null,                        -- EXEC_MS_MIN      NUMBER default 0,
                                                       null,                        -- EXEC_MS_MAX      NUMBER default 0,
                                                       null,                        -- EXEC_MS_LAST     NUMBER default 0,
                                                       null,                        -- EXEC_DATE_MIN    DATE,
                                                       null,                        -- EXEC_DATE_MAX    DATE,
                                                       null,                        -- EXEC_DATE_LAST   DATE,
                                                       null,                        -- EXEC_PARAMS_MIN  CLOB,
                                                       null,                        -- EXEC_PARAMS_MAX  CLOB,
                                                       null                         -- EXEC_PARAMS_LAST CLOB
                                                        );

        end if;

        close c_rep_user_top_abfragen;
        commit;
    end;

  -- (-TS-) new: SET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061108
    procedure c_set_rep_user_top_params (
        in_sid              in isi_user.sid%type,
        in_firma_nr         in isi_user.firma_nr%type,
        in_login_id         in isi_user.login_id%type,
        in_rep_id           in rep_abfragen.rep_id%type,
        in_exec_ms_last     in integer,
        in_exec_params_last in clob
    ) is

        v_rep_user_top_abfragen rep_user_top_abfragen%rowtype;
        v_exec_ms_min           number;
        v_exec_ms_max           number;
        v_exec_date_min         date;
        v_exec_date_max         date;
        v_exec_date_last        date;
        v_exec_params_min       clob;
        v_exec_params_max       clob;
        v_found                 boolean;
        cursor c_rep_user_top_abfragen is
        select
            *
        from
            rep_user_top_abfragen
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id;

    begin
    -- get oracle time
        v_exec_date_last := sysdate;

    -- get v_exec_ms_min from table
        select
            nvl(
                min(exec_ms_min),
                0
            )
        into v_exec_ms_min
        from
            rep_user_top_abfragen
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id;

    -- get v_exec_ms_max from table
        select
            nvl(
                max(exec_ms_max),
                0
            )
        into v_exec_ms_max
        from
            rep_user_top_abfragen
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id;

        open c_rep_user_top_abfragen;
        fetch c_rep_user_top_abfragen into v_rep_user_top_abfragen;
        v_found := c_rep_user_top_abfragen%found;
        close c_rep_user_top_abfragen;
        if v_found then
            begin
                update rep_user_top_abfragen
                set
                    counter = v_rep_user_top_abfragen.counter + 1,
                    exec_ms_last = in_exec_ms_last,
                    exec_date_last = v_exec_date_last,
                    exec_params_last = in_exec_params_last
                where
                        sid = in_sid
                    and firma_nr = in_firma_nr
                    and login_id = in_login_id
                    and rep_id = in_rep_id;

        -- check if current values are new min values
                if in_exec_ms_last < v_exec_ms_min
                or v_exec_ms_min = 0 then
                    v_exec_ms_min := in_exec_ms_last;
                    v_exec_date_min := sysdate;
                    v_exec_params_min := in_exec_params_last;
          -- update min values
                    update rep_user_top_abfragen
                    set
                        exec_ms_min = v_exec_ms_min,
                        exec_date_min = v_exec_date_min,
                        exec_params_min = v_exec_params_min
                    where
                            sid = in_sid
                        and firma_nr = in_firma_nr
                        and login_id = in_login_id
                        and rep_id = in_rep_id;

                end if;
        -- check if current values are new max values
                if in_exec_ms_last > v_exec_ms_max then
                    v_exec_ms_max := in_exec_ms_last;
                    v_exec_date_max := sysdate;
                    v_exec_params_max := in_exec_params_last;
          -- update max values
                    update rep_user_top_abfragen
                    set
                        exec_ms_max = v_exec_ms_max,
                        exec_date_max = v_exec_date_max,
                        exec_params_max = v_exec_params_max
                    where
                            sid = in_sid
                        and firma_nr = in_firma_nr
                        and login_id = in_login_id
                        and rep_id = in_rep_id;

                end if;

            end;
        else
            begin
        -- this is a new entry, set min/max values to last
                v_exec_ms_min := in_exec_ms_last;
                v_exec_ms_max := in_exec_ms_last;
                v_exec_date_min := v_exec_date_last;
                v_exec_date_max := v_exec_date_last;
                v_exec_params_min := in_exec_params_last;
                v_exec_params_max := in_exec_params_last;
                insert into rep_user_top_abfragen values ( in_sid,
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
                                                           in_exec_params_last );

            end;
        end if;

        commit;
    end;
  -- (-TS-) end: SET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061108

  -- (-TS-) new: GET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061109
    procedure get_rep_user_top_params (
        in_sid               in isi_user.sid%type,
        in_firma_nr          in isi_user.firma_nr%type,
        in_login_id          in isi_user.login_id%type,
        in_rep_id            in rep_abfragen.rep_id%type,
        out_counter          out integer,
        out_exec_ms_min      out integer,
        out_exec_ms_max      out integer,
        out_exec_ms_last     out integer,
        out_exec_date_min    out date,
        out_exec_date_max    out date,
        out_exec_date_last   out date,
        out_exec_params_min  out clob,
        out_exec_params_max  out clob,
        out_exec_params_last out clob
    ) is

        v_rep_user_top_abfragen rep_user_top_abfragen%rowtype;
        cursor c_rep_user_top_abfragen is
        select
            *
        from
            rep_user_top_abfragen
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and login_id = in_login_id
            and rep_id = in_rep_id;

    begin
        open c_rep_user_top_abfragen;
        fetch c_rep_user_top_abfragen into v_rep_user_top_abfragen;
        if c_rep_user_top_abfragen%found then
            begin
        -- record found
                out_counter := nvl(v_rep_user_top_abfragen.counter, 0);
                out_exec_ms_min := nvl(v_rep_user_top_abfragen.exec_ms_min, 0);
                out_exec_ms_max := nvl(v_rep_user_top_abfragen.exec_ms_max, 0);
                out_exec_ms_last := nvl(v_rep_user_top_abfragen.exec_ms_last, 0);
                out_exec_date_min := nvl(v_rep_user_top_abfragen.exec_date_min, sysdate);
                out_exec_date_max := nvl(v_rep_user_top_abfragen.exec_date_max, sysdate);
                out_exec_date_last := nvl(v_rep_user_top_abfragen.exec_date_last, sysdate);
                out_exec_params_min := nvl(v_rep_user_top_abfragen.exec_params_min, '');
                out_exec_params_max := nvl(v_rep_user_top_abfragen.exec_params_max, '');
                out_exec_params_last := nvl(v_rep_user_top_abfragen.exec_params_last, '');
            end;
        else
            begin
        -- record not found
                out_counter := 0;
                out_exec_ms_min := 0;
                out_exec_ms_max := 0;
                out_exec_ms_last := 0;
                out_exec_date_min := sysdate;
                out_exec_date_max := sysdate;
                out_exec_date_last := sysdate;
                out_exec_params_min := '';
                out_exec_params_max := '';
                out_exec_params_last := '';
            end;
        end if;

        close c_rep_user_top_abfragen;
    end;
  -- (-TS-) end: GET_REP_USER_TOP_PARAMS (Reportlaufzeit, benutzte Parameter, Ausführungszeitpunkt) TS20061109

    procedure get_report_gruppen (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_isi_module_cs      in varchar2,
        in_security_level     in integer,
        out_report_gruppen_cs out varchar2
    ) is

        v_rep_gruppe rep_abfragen.rep_gruppe%type;
        cursor c_rep_abfragen is
        select distinct
            rep_gruppe
        from
            rep_abfragen
        where
            ( rep_abfragen.mod_id is null
              or in_isi_module_cs like '%'
                                       || rep_abfragen.mod_id
                                       || '%' )
            and security_level <= in_security_level
            and rep_intern = 'F';

    begin
        out_report_gruppen_cs := null;
        open c_rep_abfragen;
        loop
            fetch c_rep_abfragen into v_rep_gruppe;
            exit when c_rep_abfragen%notfound;
            if out_report_gruppen_cs is null then
                out_report_gruppen_cs := v_rep_gruppe;
            else
                out_report_gruppen_cs := out_report_gruppen_cs
                                         || ','
                                         || v_rep_gruppe;
            end if;

        end loop;

        close c_rep_abfragen;
    end;

    procedure get_report_liste (
        out_report_liste out clob
    ) is
        v_contexthandle dbms_xmlgen.ctxhandle;
    begin
        v_contexthandle := dbms_xmlgen.newcontext('SELECT rep_id, rep_name, rep_gruppe, rep_info FROM rep_abfragen');
        dbms_xmlgen.setrowsettag(v_contexthandle, 'report_liste');
        dbms_xmlgen.setrowtag(v_contexthandle, 'rep_abfragen');
        out_report_liste := dbms_xmlgen.getxml(v_contexthandle);
        dbms_xmlgen.closecontext(v_contexthandle);
    end;

    procedure get_report_liste (
        in_gruppe        in varchar2,
        out_report_liste out clob
    ) is
        v_sql           varchar2(255);
        v_contexthandle dbms_xmlgen.ctxhandle;
    begin
        v_sql := 'SELECT rep_id, rep_name, rep_gruppe, rep_info '
                 || '  FROM rep_abfragen'
                 || ' WHERE rep_gruppe = '''
                 || in_gruppe
                 || '''';
        v_contexthandle := dbms_xmlgen.newcontext(v_sql);
        dbms_xmlgen.setrowsettag(v_contexthandle, 'report_liste');
        dbms_xmlgen.setrowtag(v_contexthandle, 'rep_abfragen');
        out_report_liste := dbms_xmlgen.getxml(v_contexthandle);
        dbms_xmlgen.closecontext(v_contexthandle);
    end;

    procedure execute_report (
        in_report_id         in rep_abfragen.rep_id%type,
        in_report_parameters in varchar2,
        out_result           out clob
    ) is

        v_contexthandle dbms_xmlgen.ctxhandle;
        v_query         rep_abfragen.rep_sql_clob%type;
        v_rep_name      rep_abfragen.rep_name%type;
        cursor c_report is
        select
            rep_abfragen.rep_sql_clob,
            rep_abfragen.rep_name
        from
            rep_abfragen
        where
            rep_abfragen.rep_id = in_report_id;

    begin
        out_result := '';
        open c_report;
        fetch c_report into
            v_query,
            v_rep_name;
        if
            c_report%found
            and v_query is not null
        then
            v_contexthandle := dbms_xmlgen.newcontext(v_query);
            dbms_xmlgen.setrowsettag(v_contexthandle, v_rep_name);
      --dbms_xmlgen.SetRowTag(v_ContextHandle, 'row');
            out_result := dbms_xmlgen.getxml(v_contexthandle);
            dbms_xmlgen.closecontext(v_contexthandle);
        end if;

        close c_report;
    end;

    function get_report_data (
        in_report_name           in varchar2,
        in_report_gruppe         in varchar2,
        out_abfrage_daten        out rep_abfragen%rowtype,
        out_abfrage_parameter_cs out varchar2
    ) return boolean is

        v_result     boolean;
        cursor c_report_daten is
        select
            *
        from
            rep_abfragen
        where
                upper(rep_name) = upper(in_report_name)
            and upper(rep_gruppe) = upper(in_report_gruppe);

        v_param_name rep_sql_parameter.param_name%type;
        cursor c_report_parameter is
        select
            param_name
        from
            rep_sql_parameter
        where
            rep_id = out_abfrage_daten.rep_id;

    begin
        v_result := false;
        out_abfrage_parameter_cs := null;
        open c_report_daten;
        fetch c_report_daten into out_abfrage_daten;
        if c_report_daten%found then
            v_result := true;
            open c_report_parameter;
            loop
                fetch c_report_parameter into v_param_name;
                exit when c_report_parameter%notfound;
                if out_abfrage_parameter_cs is null then
                    out_abfrage_parameter_cs := v_param_name;
                else
                    out_abfrage_parameter_cs := out_abfrage_parameter_cs
                                                || ','
                                                || v_param_name;
                end if;

            end loop;

            close c_report_parameter;
        end if;

        close c_report_daten;
        if not v_result then
      -- Geändert WK: wenn Report nicht gefunden wurde, soll eine Exception gerissen werden.
            raise_application_error(-20010, 'Report nicht gefunden: '
                                            || in_report_name
                                            || '/'
                                            || in_report_gruppe);
        end if;

        return ( v_result );
    end;

end reports;
/


-- sqlcl_snapshot {"hash":"f19ec45aef8f16ce6c81f89f3fc3275d3f0d483e","type":"PACKAGE_BODY","name":"REPORTS","schemaName":"DIRKSPZM32","sxml":""}