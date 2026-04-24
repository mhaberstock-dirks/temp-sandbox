create or replace package body dirkspzm32.res_schicht is
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler-Variablen fï¿½r eine Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

 -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling fï¿½r Exceptions
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

  -------------------------------------------------------------------------------------------------------
  -- function check_schicht_vorhanden(...)
  -------------------------------------------------------------------------------------------------------
  /* prï¿½ft ob fï¿½r die Resource in dem angegebenen Zeitfenster schon eine Schicht vorhanden ist. */
    function check_schicht_vorhanden (
        in_start_date in date,
        in_end_date   in date,
        in_isi_res_id in isi_resource.res_id%type
    ) return boolean is

        v_schicht_id isi_res_schicht.schicht_id%type;
        v_found      boolean;
        cursor c_schicht is
        select
            t.schicht_id
        from
            isi_res_schicht t
        where
            ( ( t.start_date_time between in_start_date and in_end_date )
              or ( t.ende_date_time between in_start_date and in_end_date )
              or ( in_end_date between t.start_date_time and t.ende_date_time )
              or ( in_start_date between t.start_date_time and t.ende_date_time ) )
            and t.ende_date_time <> in_start_date
            and t.start_date_time <> in_end_date
            and t.res_id = in_isi_res_id;

    begin
        open c_schicht;
        fetch c_schicht into v_schicht_id;
        v_found := c_schicht%found;
        close c_schicht;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  -- procedure CREATE_ISI_RES_SCHICHT(...)
  -------------------------------------------------------------------------------------------------------
  /* prï¿½gt eine Schicht in ISI_RES_SCHICHT aus dem ISI_RES_SCHICHT_MODELL aus */

    procedure erzeuge_isi_res_schicht (
        in_start_date            in date,
        in_end_date              in date,
        in_isi_res_id            in isi_resource.res_id%type,
        in_schicht_modell_id     in isi_res_schicht_modell.schicht_modell_id%type,
        in_takt_zeit             in isi_res_schicht_modell.takt_zeit_sek%type,
        in_stk_pro_schicht       in isi_res_schicht_modell.stk_pro_schicht%type,
        in_takte_pro_schicht     in isi_res_schicht_modell.takte_pro_schicht%type,
        in_takt_modell_id        in isi_res_schicht_modell.prod_takt_id%type,
        in_schicht_ende_variabel in isi_res_schicht_modell.schicht_ende_variabel%type
    ) is

        v_wochentag              varchar2(20);   -- mo, di,mi,do,fr,sa,so
        v_schicht_id             integer;
        v_pause_id               integer;
        v_curr_date              date;
        v_start_date             date;
        v_ende_date              date;
        i                        integer;
        v_found_schicht          boolean;
        v_found_pause            boolean;
        v_soll_takte_pro_schicht integer;
        v_soll_stk_pro_schicht   integer;
        v_modell_schicht         isi_res_schicht_modell%rowtype;
        v_modell_pause           isi_res_schicht_modell%rowtype;
        v_schicht_modell_id      isi_res_schicht_modell.schicht_modell_id%type;
        cursor c_schicht_modell_schicht is
        select
            t.*
        from
            isi_res_schicht_modell t
        where
                t.schicht_modell_id = v_schicht_modell_id
            and t.schicht_modell_type = 'S';-- 'S'chicht,
        cursor c_schicht_modell_pause is
        select
            t.*
        from
            isi_res_schicht_modell t
        where
                t.parent_id = v_schicht_modell_id
            and t.schicht_modell_type = 'P'  -- 'P'ause
        order by
            t.start_time;

    begin
        v_schicht_modell_id := in_schicht_modell_id;
        open c_schicht_modell_schicht;
        fetch c_schicht_modell_schicht into v_modell_schicht;
        v_found_schicht := c_schicht_modell_schicht%found;
        close c_schicht_modell_schicht;
        if not v_found_schicht then
            v_err_nr := 10;
            v_err_text := 'Fehler Schichtmodel <'
                          || in_schicht_modell_id
                          || '> nicht gefunden.';
            raise v_error;
        end if;

        open c_schicht_modell_pause;
        fetch c_schicht_modell_pause into v_modell_pause;
        v_found_pause := c_schicht_modell_pause%found;
        close c_schicht_modell_pause;

  --if not v_found_schicht then
  --  raise exception('Schicht nicht gefunden');
  --end if;
        for i in to_number ( to_char(in_start_date, 'j') )..to_number ( to_char(in_end_date, 'j') ) loop
            v_curr_date := to_date ( to_char(i),
            'j' );
      ----------------------------
      -- 1. Passt der Tag zu den gï¿½ltigen Wochentagen ?
      ----------------------------
            v_wochentag := substr(
                to_char(v_curr_date, 'FMday', 'NLS_DATE_LANGUAGE = german'),
                1,
                2
            ); -- mo, di,mi,do,fr,sa,so
            if instr(
                lower(v_modell_schicht.wochen_tage),
                v_wochentag
            ) > 0 then
                v_soll_takte_pro_schicht := 1; -- ToDo: Berechnen!!!
                v_soll_stk_pro_schicht := 1; -- ToDo: Berechnen!!!
                v_start_date := trunc(v_curr_date) + extract(hour from cast ( v_modell_schicht.start_time as timestamp )) / 24 + extract
                (minute from cast ( v_modell_schicht.start_time as timestamp )) / 24 / 60 + extract(second from cast ( v_modell_schicht.start_time
                as timestamp )) / 24 / 60 / 60;

                v_ende_date := trunc(v_curr_date) + extract(hour from cast ( v_modell_schicht.ende_time as timestamp )) / 24 + extract
                (minute from cast ( v_modell_schicht.ende_time as timestamp )) / 24 / 60 + extract(second from cast ( v_modell_schicht.ende_time
                as timestamp )) / 24 / 60 / 60;

                if extract(hour from cast ( v_modell_schicht.start_time as timestamp )) > extract(hour from cast ( v_modell_schicht.ende_time
                as timestamp )) then
                    v_ende_date := v_ende_date + 1; -- Das Ende ist am nï¿½chsten Tag!
                end if;

        ----------------------------
        -- 2.A Ist schon eine Schicht vorhanden ?
        ----------------------------
                if check_schicht_vorhanden(v_start_date, v_ende_date, in_isi_res_id) then
                    v_err_nr := 11;
                    v_err_text := 'Fehler: Schicht schon vorhanden am Datum <'
                                  || to_char(v_start_date, 'dd.mm.yyyy hh24:mi')
                                  || '>.';
                    raise v_error;
                end if;
        ----------------------------
        -- 2.B Schicht eintragen !!
        ----------------------------
                v_schicht_id := seq_isi_res_schicht_id.nextval;
                insert into isi_res_schicht (
                    schicht_id,
                    parent_id,
                    sid,
                    firma_nr,
                    schicht_type,
                    schicht_name,
                    start_date_time,
                    ende_date_time,
                    abzug_produktions_zeit_sek,
                    prod_takt_id,
                    takt_zeit_sek,
                    created_date,
                    created_login_id,
                    ist_takte_pro_schicht,
                    ist_stk_pro_schicht,
                    soll_takte_pro_schicht,
                    soll_stk_pro_schicht,
                    status,
                    res_id,
                    schicht_ende_variabel
                ) values ( v_schicht_id,     --Schicht_ID  Sequence
                           v_schicht_id,     --Parent_id
                           v_modell_schicht.sid,
                           v_modell_schicht.firma_nr,
                           v_modell_schicht.schicht_modell_type,
                           v_modell_schicht.schicht_modell_name,
                           v_start_date,    -- start_date_time
                           v_ende_date,
                           v_modell_schicht.abzug_produktions_zeit_sek,
                           in_takt_modell_id,
                           in_takt_zeit,
                           sysdate, -- created_date
                           - 1, -- created_login_id
                           0,   -- ist_takte_pro_schicht
                           0,   -- ist_skt_pro_schicht
                           in_takte_pro_schicht,
                           in_stk_pro_schicht,
                           'N',
                           in_isi_res_id,
                           in_schicht_ende_variabel );
        ----------------------------
        -- 3. Alle Pausen eintragen !!
        -----------------------------
                open c_schicht_modell_pause;
                loop
                    fetch c_schicht_modell_pause into v_modell_pause;
                    v_found_pause := c_schicht_modell_pause%found;
                    if v_found_pause then
                        v_start_date := trunc(v_curr_date) + extract(hour from cast ( v_modell_pause.start_time as timestamp )) / 24 +
                        extract(minute from cast ( v_modell_pause.start_time as timestamp )) / 24 / 60 + extract(second from cast ( v_modell_pause.start_time
                        as timestamp )) / 24 / 60 / 60;

                        v_ende_date := trunc(v_curr_date) + extract(hour from cast ( v_modell_pause.ende_time as timestamp )) / 24 + extract
                        (minute from cast ( v_modell_pause.ende_time as timestamp )) / 24 / 60 + extract(second from cast ( v_modell_pause.ende_time
                        as timestamp )) / 24 / 60 / 60;

                        if extract(hour from cast ( v_modell_schicht.start_time as timestamp )) > extract(hour from cast ( v_modell_pause.start_time
                        as timestamp )) then
                            v_start_date := v_start_date + 1;   -- start der pause ist am Folge Tag
                        end if;

                        if extract(hour from cast ( v_modell_schicht.start_time as timestamp )) > extract(hour from cast ( v_modell_pause.ende_time
                        as timestamp )) then
                            v_ende_date := v_ende_date + 1;   -- Ende der pause ist am Folge Tag
                        end if;

                        v_pause_id := seq_isi_res_schicht_id.nextval;
                        insert into isi_res_schicht (
                            schicht_id,
                            parent_id,
                            sid,
                            firma_nr,
                            schicht_type,
                            schicht_name,
                            start_date_time,
                            ende_date_time,
                            prod_takt_id,
                            status,
                            res_id,
                            schicht_ende_variabel
                        ) values ( v_pause_id,
                                   v_schicht_id,
                                   v_modell_pause.sid,
                                   v_modell_pause.firma_nr,
                                   v_modell_pause.schicht_modell_type,
                                   v_modell_pause.schicht_modell_name,
                                   v_start_date,    -- start_date_time
                                   v_ende_date,
                                   in_takt_modell_id,
                                   'N',
                                   in_isi_res_id,
                                   in_schicht_ende_variabel );

                    else
                        exit;
                    end if;

                end loop;

                close c_schicht_modell_pause;
            end if; -- instr Wochentage
        end loop;

    end;

    procedure c_erzeuge_isi_res_schicht (
        in_start_date            in date,
        in_end_date              in date,
        in_isi_res_id            in isi_resource.res_id%type,
        in_schicht_modell_id     in isi_res_schicht_modell.schicht_modell_id%type,
        in_takt_zeit             in isi_res_schicht_modell.takt_zeit_sek%type,
        in_stk_pro_schicht       in isi_res_schicht_modell.stk_pro_schicht%type,
        in_takte_pro_schicht     in isi_res_schicht_modell.takte_pro_schicht%type,
        in_takt_modell_id        in isi_res_schicht_modell.prod_takt_id%type,
        in_schicht_ende_variabel in isi_res_schicht_modell.schicht_ende_variabel%type
    ) is
    begin
        erzeuge_isi_res_schicht(in_start_date, in_end_date, in_isi_res_id, in_schicht_modell_id, in_takt_zeit,
                                in_stk_pro_schicht, in_takte_pro_schicht, in_takt_modell_id, in_schicht_ende_variabel);

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

    procedure loesche_isi_res_schicht (
        in_schicht_id in isi_res_schicht.schicht_id%type
    ) is
    begin
  -- Schichten und Schichtpausen lï¿½schen !
        delete isi_res_schicht t
        where
            t.parent_id = in_schicht_id;

    end;

    procedure c_loesche_isi_res_schicht (
        in_schicht_id in isi_res_schicht.schicht_id%type
    ) is
    begin
        loesche_isi_res_schicht(in_schicht_id);
        commit;
    end;

    function differenz_nur_zeit_in_sekunden (
        in_start_zeit date,
        in_ende_zeit  date
    ) return integer is
        v_start number;
        v_ende  number;
    begin
        v_start := ( in_start_zeit - trunc(in_start_zeit) );  -- Datumsanteil Lï¿½schen , Vorkomma auf 0.
        v_ende := ( in_ende_zeit - trunc(in_ende_zeit) );       -- Datumsanteil Lï¿½schen , Vorkomma auf 0.
        if v_start > v_ende then
            v_ende := v_ende + 1;  -- Nï¿½chste Tag
        end if;
        return ( ( v_ende - v_start ) * 24 * 60 * 60 );
    end;

    procedure c_setze_schicht_status (
        in_schicht_id in isi_res_schicht.schicht_id%type,
        in_status     in isi_res_schicht.status%type
    ) is
-- Der Status wird nur auf die Schicht ausgeprï¿½gt. Die Pausen bleiben wie sie sind.
    begin
        update isi_res_schicht t
        set
            t.status = in_status
        where
            t.schicht_id = in_schicht_id;

        commit;
    end;

    procedure schicht_modell_zeiten (
        in_schicht_modell_id        in isi_res_schicht_modell.schicht_modell_id%type,
        out_schichtzeit_sekunden    out integer,
        out_schicht_pausen_sekunden out integer
    ) is

        v_schicht_arbeits_zeit_sek integer;
        v_pausen_summe_sek         integer;
        cursor c_schicht_modell_zeiten is
        select
            (
                select
                    res_schicht.differenz_nur_zeit_in_sekunden(t.start_time, t.ende_time) schicht_in_sekunden
                from
                    isi_res_schicht_modell t
                where
                        t.schicht_modell_id = in_schicht_modell_id
                    and t.schicht_modell_type = 'S'
            ) schicht_in_sekunden,   -- schicht arbeitszeit
            (
                select
                    sum(res_schicht.differenz_nur_zeit_in_sekunden(t.start_time, t.ende_time)) pause_in_sekunden
                from
                    isi_res_schicht_modell t
                where
                        t.parent_id >= in_schicht_modell_id
                    and t.schicht_modell_type = 'P'
                group by
                    schicht_modell_type
            ) pause_in_sekunden   -- Alle Pausen Aufsummieren)
        from
            dual;

    begin
        open c_schicht_modell_zeiten;
        fetch c_schicht_modell_zeiten into
            out_schichtzeit_sekunden,
            out_schicht_pausen_sekunden;
        close c_schicht_modell_zeiten;
    end;

begin
  -- globale Initialisierung
  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;
end res_schicht;
/


-- sqlcl_snapshot {"hash":"7b217a9e09e4f7e500597a250143db82c7fd54bf","type":"PACKAGE_BODY","name":"RES_SCHICHT","schemaName":"DIRKSPZM32","sxml":""}