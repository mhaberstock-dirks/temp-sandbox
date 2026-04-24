create or replace package body dirkspzm32.print_engine is

	/*******************************************************************************
  * procedure C_INSERT_NEW_JOB(...)
  *******************************************************************************/
    procedure c_insert_new_job (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_rave_datei       in pe_jobs.rave_datei%type,
        in_rave_report_name in pe_jobs.rave_report_name%type,
        in_job_daten_typ    in pe_jobs.job_daten_typ%type,
        in_job_daten        in pe_jobs.job_daten%type,
        in_drucker_name     in pe_jobs.drucker_name%type,
        in_anzahl           in pe_jobs.anzahl%type,
        out_job_nr          out pe_jobs.job_nr%type
    ) is
		-------------------------------------------------------------------------------------------------------
		-- Standard Fehler Felder für Exception
		-------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    begin
        insert_new_job(in_sid, in_firma_nr, in_rave_datei, in_rave_report_name, in_job_daten_typ,
                       in_job_daten, in_drucker_name, in_anzahl, out_job_nr);

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end;

	/*******************************************************************************
  * procedure C_INSERT_NEW_JOB(...)
  *******************************************************************************/
    procedure insert_new_job (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_rave_datei       in pe_jobs.rave_datei%type,
        in_rave_report_name in pe_jobs.rave_report_name%type,
        in_job_daten_typ    in pe_jobs.job_daten_typ%type,
        in_job_daten        in pe_jobs.job_daten%type,
        in_drucker_name     in pe_jobs.drucker_name%type,
        in_anzahl           in pe_jobs.anzahl%type,
        out_job_nr          out pe_jobs.job_nr%type
    ) is
		-------------------------------------------------------------------------------------------------------
		-- Standard Fehler Felder für Exception
		-------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(255);
        cursor c_pe_jobs is
        select
            t.status
        from
            pe_jobs t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.job_nr = out_job_nr;

        v_current_status pe_jobs.status%type;
        v_layout_name    pe_jobs.rave_report_name%type;
        v_layout_datei   pe_jobs.rave_datei%type;
        v_anzahl         pe_jobs.anzahl%type;
        v_dr_layout_cfg  pe_drucker_layout_cfg%rowtype;
        v_found          boolean;
    begin
        v_layout_name := in_rave_report_name;
        v_layout_datei := in_rave_datei;
        v_anzahl := in_anzahl;

    -- -WK- 20090630: Layoutmapping für den aktuellen Drucker
        if print_allg.get_drucker_layout_cfg(in_sid, in_firma_nr, in_drucker_name, v_layout_name, v_layout_datei,
                                             v_dr_layout_cfg) then
            v_layout_name := v_dr_layout_cfg.dest_layout_name;
            v_layout_datei := v_dr_layout_cfg.dest_layout_datei;

      -- -WK- 20090701: Einige Drucker können selbst automatisch n Ausdrucke generieren
      -- dann kann die Soll-Azanhl übersteuert werden
            if v_dr_layout_cfg.dest_anzahl is not null then
                v_anzahl := v_dr_layout_cfg.dest_anzahl;
            end if;
        end if;

    -- Printengine kann die Anzahl noch nicht verarbeiten darum in LOOP
        select
            pe_seq_pe_jobs.nextval
        into out_job_nr
        from
            dual;

        open c_pe_jobs;
        fetch c_pe_jobs into v_current_status;
        v_found := c_pe_jobs%found;
        close c_pe_jobs;
        if v_found then
      -- da die Sequence immer in die Runde zählt, und von vorne beginnt
      -- können alte jobs gelöscht werden
            delete from pe_jobs t
            where
                    t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.job_nr = out_job_nr;

        end if;

        v_err_nr := 10;
        v_err_text := 'Einfügen des Druckjobs: '
                      || out_job_nr
                      || ' nicht möglich';
        insert into pe_jobs values ( in_sid,
                                     in_firma_nr,
                                     out_job_nr,
                                     null, -- job_timestamp
                                     job_status_neu, -- status
                                     null, -- status_text
                                     sysdate, -- status_time
                                     v_layout_name,
                                     v_layout_datei,
                                     in_job_daten,
                                     in_job_daten_typ,
                                     in_drucker_name,
                                     v_anzahl );

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;
    end;

	/*******************************************************************************
  * function GET_JOB_DATEN(...) return boolean
  *******************************************************************************/
    function get_job_status (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_job_nr           in pe_jobs.job_nr%type,
        out_job_status      out pe_jobs.status%type,
        out_job_status_text out pe_jobs.status_text%type
    ) return boolean is

        v_result boolean;
        cursor c_print_job is
        select
            pe_jobs.status,
            pe_jobs.status_text
        from
            pe_jobs
        where
                pe_jobs.sid = in_sid
            and pe_jobs.firma_nr = in_firma_nr
            and pe_jobs.job_nr = in_job_nr;

    begin
        open c_print_job;
        fetch c_print_job into
            out_job_status,
            out_job_status_text;
        v_result := c_print_job%found;
        close c_print_job;
        return ( v_result );
    end;

	/*******************************************************************************
  * function GET_JOB_DATEN(...) return boolean
  *******************************************************************************/
    function get_job_daten (
        in_sid          in varchar2,
        in_firma_nr     in number,
        in_job_nr       in pe_jobs.job_nr%type,
        out_job_data    out pe_jobs%rowtype,
        out_drucker_typ out pe_drucker_cfg.drucker_typ%type
    ) return boolean is

        v_result boolean;
        cursor c_print_job is
        select
            pe_jobs.*
        from
            pe_jobs
        where
                pe_jobs.sid = in_sid
            and pe_jobs.firma_nr = in_firma_nr
            and pe_jobs.job_nr = in_job_nr;

        cursor c_drucker_typ is
        select
            pe_drucker_cfg.drucker_typ
        from
            pe_drucker_cfg
        where
                pe_drucker_cfg.sid = in_sid
            and pe_drucker_cfg.firma_nr = in_firma_nr
            and pe_drucker_cfg.drucker_name = out_job_data.drucker_name;

    begin
        open c_print_job;
        fetch c_print_job into out_job_data;
        v_result := c_print_job%found;
        close c_print_job;
        if
            v_result
            and out_job_data.drucker_name is not null
        then
            open c_drucker_typ;
            out_drucker_typ := null;
            fetch c_drucker_typ into out_drucker_typ;
            close c_drucker_typ;
        end if;

        return ( v_result );
    end;

	/*******************************************************************************
  * function GET_NEXT_JOB(...) return boolean
  *******************************************************************************/
    function get_next_job (
        in_sid          in varchar2,
        in_firma_nr     in number,
        out_job_data    out pe_jobs%rowtype,
        out_drucker_typ out pe_drucker_cfg.drucker_typ%type
    ) return boolean is

        v_result boolean;
    -- -AG- Anpassung der Sortierung für die Abarbeitung (Nach Problemen mit Sasol)
        cursor c_print_job is
        select
            p.*
        from
            pe_jobs p
        where
                p.status = job_status_neu
            and p.sid = in_sid
            and p.firma_nr = in_firma_nr
            and not exists (
                select
                    p2.drucker_name -- Nur Jobs von druckern berücksichtigen
                from
                    pe_jobs p2      -- die noch nicht drucken
                where
                        p2.status = job_status_drucken
                    and p2.drucker_name = p.drucker_name
            )
        order by
            decode(p.status_text, null, 0, 1), -- Erst mal die noch kein Problem hatten
            p.job_timestamp; -- FIFO
        cursor c_drucker_typ is
        select
            pe_drucker_cfg.drucker_typ
        from
            pe_drucker_cfg
        where
                pe_drucker_cfg.sid = in_sid
            and pe_drucker_cfg.firma_nr = in_firma_nr
            and pe_drucker_cfg.drucker_name = out_job_data.drucker_name;

    begin
        open c_print_job;
        fetch c_print_job into out_job_data;
        v_result := c_print_job%found;
        close c_print_job;
        if
            v_result
            and out_job_data.drucker_name is not null
        then
            open c_drucker_typ;
            out_drucker_typ := null;
            fetch c_drucker_typ into out_drucker_typ;
            close c_drucker_typ;
        end if;

        return ( v_result );
    end;

	/*******************************************************************************
  * procedure C_SET_JOB_STATUS((...)
  *******************************************************************************/
    procedure c_set_job_status (
        in_sid             in varchar2,
        in_firma_nr        in number,
        in_job_nr          in pe_jobs.job_nr%type,
        in_job_status      in varchar2,
        in_job_status_text in varchar2
    ) is
    begin
        update pe_jobs
        set
            status = in_job_status,
            status_text = in_job_status_text
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and job_nr = in_job_nr;

        if in_job_status = job_status_neu then
            update pe_jobs t
            set
                t.job_timestamp = sysdate
            where
                    sid = in_sid
                and firma_nr = in_firma_nr
                and job_nr = in_job_nr;

        end if;

        commit;
    end;

	/*******************************************************************************
  * procedure C_SET_JOB_STATUS((...)
  *******************************************************************************/
    procedure c_reset_jobs (
        in_sid      in varchar2,
        in_firma_nr in number
    ) is
    begin
        update pe_jobs
        set
            status = job_status_fehler,
            status_text = 'Reset',
            status_time = sysdate
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and status = job_status_drucken;

        commit;
    end;

	/*******************************************************************************
  * procedure c_reprint_last_job((...)
  *******************************************************************************/
    procedure c_reprint_last_job (
        in_sid          in varchar2,
        in_firma_nr     in number,
        in_printer_name in pe_jobs.drucker_name%type
    ) is
    begin
        update pe_jobs j
        set
            status = 'N'
        where
                j.sid = in_sid
            and j.firma_nr = in_firma_nr
            and j.job_nr = (
                select
                    max(j.job_nr)
                from
                    pe_jobs j
                where
                        j.sid = in_sid
                    and j.firma_nr = in_firma_nr
                    and j.drucker_name = in_printer_name
            );

        commit;
    end;

end print_engine;
/


-- sqlcl_snapshot {"hash":"461ba740e3e26c5652a4298546aa482f26abece8","type":"PACKAGE_BODY","name":"PRINT_ENGINE","schemaName":"DIRKSPZM32","sxml":""}