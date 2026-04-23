create or replace package body dirkspzm32.sls_terminal is

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

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Holt den naechsten Auftrag und gibt diesen im out_transport zurück
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    function get_next_auftrag (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_modul_erzeuger   in isi_transport.modul_bearbeiter%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_freifahren       in isi_transport.freifahrauftrag%type,
        in_user_id          in isi_user.login_id%type,
        in_res_id           in isi_resource.res_id%type,
        out_transport       out isi_transport%rowtype
    ) return number is

        v_error exception;
        v_err_nr             number;
        v_err_text           varchar2(255);
        v_fahrzeuge          lvs_fahrzeuge%rowtype;
        v_std_transport_zeit number;
        v_theo_fertig_zeit   date;
        v_transport          isi_transport%rowtype;
        v_found              boolean;
        v_max_id             lvs_fahrzeuge.stapler_ls_id%type;
        v_min_id             lvs_fahrzeuge.stapler_ls_id%type;
        v_stapler_ls_id      lvs_fahrzeuge.stapler_ls_id%type;
        v_fahrzeuge_ids      varchar2(20);
        v_return             number;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.modul_bearbeiter = in_modul_bearbeiter
            and ( t.soll_fertig_bis <= nvl(v_theo_fertig_zeit, t.soll_fertig_bis)
                  or t.res_id = in_res_id )
            and ( ( t.status = 'F'
                    and t.res_id is null )
                  or t.res_id = in_res_id )
        order by
            abs(nvl(t.res_id, -1) - in_res_id) asc,
            t.freifahrauftrag desc,
            t.transport_reihenfolge,
            t.prio desc,
            nvl(t.soll_fertig_bis - v_theo_fertig_zeit, 0),
            t.transp_id;

        cursor c_fahrzeuge is
        select
            *
        from
            lvs_fahrzeuge f
        where
                f.sid = in_sid
            and f.res_id = in_res_id;

        cursor c_lgr_ort is
        select
            min(ort.stapler_ls_id) min_id,
            max(ort.stapler_ls_id) max_id
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_sid
            and ort.firma_nr = in_firma_nr
            and ( ort.lgr_ort = v_transport.lgr_ort_quelle
                  or ort.lgr_ort = v_transport.lgr_ort_ziel );

    begin
        v_std_transport_zeit := to_number ( isi_allg.get_firma_cfg_param(in_sid,                                        -- in_sid                   in isi_firma_cfg.sid%type,
         in_firma_nr,                                   -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
         'CFG',                                         -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                                          -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'STD_TRANSPORT_ZEIT_MIN',                      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                         'TRANSPORT',                                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                          'CFG',                                         -- in_typ                   in isi_firma_cfg.typ%type,
                                                                          '15',                                          -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                          'INTEGER') );                                   -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
    -- Erst mal die Aufträge nehmen die jetzt transportiert werden müssen
        v_theo_fertig_zeit := sysdate + ( v_std_transport_zeit + 5 ) / 1440;
        v_return := 2;
        open c_fahrzeuge;
        fetch c_fahrzeuge into v_fahrzeuge;
        v_found := c_fahrzeuge%found;
        close c_fahrzeuge;
        if not v_found then
            v_fahrzeuge.stapler_ls_id := null;
        end if;
        open c_transport;
        loop
            fetch c_transport into v_transport;
            v_found := c_transport%found;
            open c_lgr_ort;
            fetch c_lgr_ort into
                v_min_id,
                v_max_id;
            close c_lgr_ort;
            if
                not v_found
                and v_theo_fertig_zeit is not null
            then
                close c_transport;
                v_theo_fertig_zeit := null;
                open c_transport;
                fetch c_transport into v_transport;
                v_found := c_transport%found;
                open c_lgr_ort;
                fetch c_lgr_ort into
                    v_min_id,
                    v_max_id;
                close c_lgr_ort;
            end if;

            v_return := -10000;
            v_stapler_ls_id := nvl(v_fahrzeuge.stapler_ls_id,
                                   nvl(v_max_id, v_min_id));
            if v_stapler_ls_id is null
               or v_stapler_ls_id = nvl(v_min_id,
                                        nvl(v_max_id, v_stapler_ls_id))
            or v_stapler_ls_id = nvl(v_max_id,
                                     nvl(v_min_id, v_stapler_ls_id)) then
                if v_found then
                    v_fahrzeuge_ids := ';'
                                       || to_char(in_res_id)
                                       || ';';
                    v_return := lvs_platz.lvs_c_transp_check_zugriff(v_transport.sid, v_transport.firma_nr, v_transport.modul_erzeuger
                    , v_transport.modul_bearbeiter, in_freifahren,
                                                                     in_user_id, v_transport.transp_id, v_fahrzeuge_ids);

                end if;
            end if;

            exit when v_return >= 0
            or not v_found;
        end loop;

        close c_transport;
        if
            v_found
            and v_return = 0
        then
            out_transport := v_transport;
        else
            if v_return = -10000 then
                v_return := 2;
            end if;
            out_transport := null;
        end if;

        return ( v_return );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            if c_transport%isopen then
                close c_transport;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_transport%isopen then
                close c_transport;
            end if;
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

    end get_next_auftrag;

  --******************************************************************************

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Erstellt eine neuer LTE und git deren Nummer zurueck
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    function c_lte_insert (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_user.login_id%type,
        in_ls_login_id in isi_user.login_id%type,
        in_lte_name    in lvs_lte_cfg.lte_name%type
    ) return varchar2 is

        v_result    lvs_lte.lte_id%type;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(255);
        v_charge_id lvs_charge.charge_id%type;
        v_artikel   isi_artikel%rowtype;
        v_firma     isi_firma%rowtype;
    begin
        v_err_nr := null;
        v_err_text := null;
        v_result := null;
        v_result := lvs_p_lte.lvs_lte_insert_v358(in_sid,                  -- SID der Maschine
         in_firma_nr,              -- Firma der Maschine
         in_lte_name,              -- Palettemtype Bsp. 'EURO'
         v_result,                 -- ID der Transporteinheit
         in_ls_login_id,           -- Login ID aktuelle User
                                                  null,                     -- Kein Lager
                                                   null,                     -- Fertigwarenlager der Maschine
                                                   'PF',                     -- Status ist auf befüllen gesetzt
                                                   null, null,
                                                  null, 'KOMM',                     -- Charge nicht bekannt
                                                   null, null,                      -- Packschema nicht bekannt
                                                   null,                    -- Auto Depal ist unbekannt
                                                  null,                    -- wickelprogramm ist unbekannt,
                                                   null);                   -- wickelprogramm_einl ist unbekannt
        commit;
        return ( v_result );
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

    end c_lte_insert;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Stellt eien LHM auf eien Palette
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_lhm_umpacken (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_user_id  in isi_user.login_id%type,
        in_res_id   in isi_resource.res_id%type,
        in_lhm_id   in lvs_lhm.lhm_id%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    begin
        v_err_nr := null;
        v_err_text := null;
        lvs_p_lte_lhm.lvs_c_lhm_umpacken(in_sid,                      -- in_sid                  in isi_sid.sid%type,
         in_firma_nr,                 -- in_firma_nr             in isi_firma.firma_nr%type,
         in_user_id,                  -- in_user_id              in isi_user.login_id%type,
         in_res_id,                   -- in_res_id               in isi_resource.res_id%type,
         in_lhm_id,                   -- in_lhm_id               in lvs_lhm.Lhm_Id%TYPE,
                                         in_lte_id);                  -- in_lte_id               in lvs_lte.lte_id%type
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

    end c_lhm_umpacken;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Fehlerabhandlung für eien leeren Lagerplatz wenn dieser Buchungstechnisch
  -- gefüllt seien sollte
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_platz_leer (
        in_sid       in isi_sid.sid%type,
        in_firma     in isi_firma.firma_nr%type,
        in_user_id   in isi_user.login_id%type,
        in_transport in isi_transport%rowtype
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_ret      varchar2(500);
    begin
        v_ret := lvs_p_lte.lvs_suche_neue_lte(in_transport, in_user_id);
        commit;
        if v_ret != 'OK'  -- Ein Fehler, aber keine Exception
         then
            v_err_nr := 10;
            v_err_text := v_ret;
            raise v_error;
        end if;

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

    end c_platz_leer;
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Fehlerabhandlung für eien leeren Lagerplatz wenn dieser Buchungstechnisch
  -- gefüllt seien sollte
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_platz_voll (
        in_sid       in isi_sid.sid%type,
        in_firma     in isi_firma.firma_nr%type,
        in_user_id   in isi_user.login_id%type,
        in_transport in isi_transport%rowtype
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
        v_ret      varchar2(500);
    begin
        v_ret := lvs_p_lte.lvs_c_suche_neuen_platz(in_transport, in_user_id, in_transport.ziel_voll_progr_nr);
        commit;
        if v_ret != 'OK'  -- Ein Fehler, aber keine Exception
         then
            v_err_nr := 10;
            v_err_text := v_ret;
            raise v_error;
        end if;

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

    end c_platz_voll;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Fehlerabhandlung für eien leeren Lagerplatz wenn dieser Buchungstechnisch
  -- gefüllt seien sollte
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_transport_abbr (
        in_sid    in isi_sid.sid%type,
        in_firma  in isi_firma.firma_nr%type,
        in_res_id in isi_resource.res_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);
    begin
        update isi_transport t
        set
            t.res_id = null,
            t.status = c.trans_frei
        where
                t.sid = in_sid
            and t.firma_nr = in_firma
            and t.res_id = in_res_id
            and ( t.status = c.trans_begin
                  or t.status = c.trans_zugew );

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

    end c_transport_abbr;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Prüfung ob Transporte und Paletten gewechselt werden dürfen
  -- Paletten auf dem gleichen WE Stehen, dürfen getauscht werden
  --
  -- ohne COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    function c_transport_pal_tauschen (
        in_sid          in isi_sid.sid%type,
        in_firma        in isi_firma.firma_nr%type,
        in_res_id       in isi_resource.res_id%type,
        in_user_id      in isi_user.login_id%type,
        in_soll_lte_id  in lvs_lte.lte_id%type,
        in_scann_lte_id in lvs_lte.lte_id%type
    ) return varchar2 is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(255);
        v_lte_id    lvs_lte.lte_id%type;
        v_soll_lte  lvs_lte%rowtype;
        v_scann_lte lvs_lte%rowtype;
        v_transport isi_transport%rowtype;
        v_soll_lgr  lvs_lgr%rowtype;
        v_scann_lgr lvs_lgr%rowtype;
        v_lgr_platz lvs_lgr.lgr_platz%type;
        v_found     boolean;
        v_ret       varchar2(500);
        cursor c_lte is
        select
            lte.*
        from
            lvs_lte lte
        where
            lte.lte_id = v_lte_id;

        cursor c_transport is
        select
            tr.*
        from
            isi_transport tr
        where
                tr.sid = in_sid
            and tr.firma_nr = in_firma
            and tr.lte_id = v_lte_id;

        cursor c_lgr is
        select
            lgr.*
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = v_lgr_platz;

    begin
        v_lte_id := in_soll_lte_id;
        open c_lte;
        fetch c_lte into v_soll_lte;
        v_found := c_lte%found;
        close c_lte;
        if not v_found then
            v_ret := null;
            c_transport_abbr(in_sid,       -- in_sid                  in isi_sid.sid%type,
             in_firma,     -- in_firma                in isi_firma.firma_nr%type,
             in_res_id);   -- in_res_id               in isi_resource.res_id%type
        end if;

        v_lte_id := in_scann_lte_id;
        open c_lte;
        fetch c_lte into v_scann_lte;
        v_found := c_lte%found;
        close c_lte;
        if not v_found then
            v_ret := 'Paletten können nicht getauscht werden, gescannte Palette fehlt im Bestand';
        else
            open c_transport;
            fetch c_transport into v_transport;
            v_found := c_transport%found;
            close c_transport;
            if v_found then
                if v_transport.status != 'F' then
                    v_ret := 'Transport dieser Palette bereits vergeben.';
                    return v_ret;
                end if;

                if v_soll_lte.lgr_platz != v_scann_lte.lgr_platz then
                    v_ret := 'Es dürfen nur Paletten mit gleichen Lagerplatz getauscht werden.';
                    return v_ret;
                end if;

                c_transport_abbr(in_sid,       -- in_sid                  in isi_sid.sid%type,

                 in_firma,     -- in_firma                in isi_firma.firma_nr%type,

                 in_res_id);   -- in_res_id               in isi_resource.res_id%type
                v_err_nr := lvs_platz.lvs_c_transp_beginnen(in_sid,                   -- in_sid          IN isi_sid.sid%TYPE,
                 in_firma,                 -- in_firma_nr     IN isi_firma.firma_nr%TYPE,
                 in_user_id,               -- in_user_id      IN isi_user.login_id%TYPE,
                 v_transport.transp_id,    -- in_transport_id IN isi_transport.transp_id%TYPE,
                 in_soll_lte_id,           -- in_lte_id       in lvs_lte.lte_id%type,
                                                            in_res_id);               -- in_res_id       in isi_resource.res_id%type)
                if v_err_nr = 0 then
                    v_ret := null;
                else
                    v_ret := c.decode_function_fehler(v_err_nr);
                    v_err_nr := 0;
                end if;

            else
        -- Im ersteb Schritt nur Paletten tauschen, die auch einen Transport haben
                v_ret := 'Paletten können nicht getauscht werden, kein Transport vorgesehen!';
                return ( v_ret );
        -- Jetzt erst mal die Lagerplätze lesen
                v_lgr_platz := v_soll_lte.lgr_platz;
                open c_lgr;
                fetch c_lgr into v_soll_lgr;
                close c_lgr;
                v_lgr_platz := v_scann_lte.lgr_platz;
                open c_lgr;
                fetch c_lgr into v_scann_lgr;
                close c_lgr;
                if v_soll_lgr.lgr_verwendung = c.lgr_typ_lager
                or v_soll_lgr.lgr_verwendung = c.lgr_typ_lagerp
                or v_soll_lgr.lgr_verwendung = c.lgr_typ_puffer
                or v_soll_lgr.lgr_verwendung = c.lgr_typ_ep then
                    if
                        v_soll_lte.res_string = v_scann_lte.res_string
                        and v_soll_lte.lte_akt_lhm = v_scann_lte.lte_akt_lhm
                        and v_soll_lte.lte_akt_kg = v_scann_lte.lte_akt_kg
                    then
            -- ToDo Hier muss alles richtig ausformuliert werden
            -- Prüfung auf Verfügbar, Transportreihenfolge etc.
                        v_ret := null;
                    end if;
                else
                    v_ret := 'Paletten können nicht getauscht werden, kein Transport vorgesehen!';
                end if;

            end if;

        end if;

        commit;
        return ( v_ret );
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

    end c_transport_pal_tauschen;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Loggen einer Prüfungsaktivität für einen Transport im SLS.
  -- Bei erfolgreicher Prüfung wir die LoginID des Benutzers (Prüfer) in den Transport geschrieben.
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_log_transport_check (
        in_sid             in isi_transport_log.sid%type,
        in_firma_nr        in isi_transport_log.firma_nr%type,
        in_transp_id       in isi_transport_log.transp_id%type,
        in_login_id        in isi_transport_log.login_id%type,
        in_arbeitsplatz_id in isi_transport_log.arbeitsplatz_id%type,
        in_check_typ       in isi_transport_log.check_typ%type,
        in_scan_data       in isi_transport_log.scan_data%type,
        in_check_q_eti_typ in isi_transport_log.check_q_eti_typ%type,
        in_check_passed    in isi_transport_log.check_passed%type
    ) is
        v_transport isi_transport%rowtype;
    begin
        if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport) then
            raise_isi_error(10,
                            'Die Daten für Transport ID '
                            || nvl(
                to_char(in_transp_id),
                '(null)'
            )
                            || ' konnten nicht gefunden werden.');
        end if;

        insert into isi_transport_log values ( in_sid,
                                               in_firma_nr,
                                               seq_transp_log_id.nextval,
                                               in_transp_id,
                                               v_transport.status,
                                               in_login_id,
                                               systimestamp,
                                               'CHECK', -- log_typ
                                               in_arbeitsplatz_id, -- arbeitsplatz_id
                                               in_check_typ, -- check_typ
                                               in_scan_data, -- scan_data
                                               in_check_q_eti_typ,  --check_q_eti_typ
                                               in_check_passed, -- check_passed
                                               null,
                                               null,
                                               v_transport.res_id,
                                               v_transport.parent_transp_id,
                                               v_transport.lte_id );

        if
            in_check_passed = c.c_true
            and in_check_typ in ( 'waren', 'we_waren', 'wa_waren' )
        then
            update isi_transport t
            set
                t.check_ware_login_id = in_login_id
            where
                    t.sid = in_sid
                and t.transp_id = in_transp_id;

        elsif
            in_check_passed = c.c_true
            and in_check_typ in ( 'einl_lgr', 'einl_lgr_z', 'ausl_lgr', 'ausl_lgr_z' )
        then
            update isi_transport t
            set
                t.check_platz_z_login_id = in_login_id
            where
                    t.sid = in_sid
                and t.transp_id = in_transp_id;

        elsif in_check_typ in ( 'ausl_lgr_q' ) then
      -- auch wenn die richtige Palette vom falschen Lagerplatz geholt wurde,
      -- kann der Transoprt quittiert werden. Es wird lediglich festgehalten das
      -- eine Prüfung ausgeführt wurde
            update isi_transport t
            set
                t.check_platz_q_login_id = in_login_id
            where
                    t.sid = in_sid
                and t.transp_id = in_transp_id;

        end if;

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

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Prüft, ob eine LHM ID von der angegebenen LTE ID (in_old_id) oder der LTE ID
  -- der angegebenen LHM ID (in_old_id) kommissioniert wurde. (Warenprüfung bei
  -- Etikettenaustausch)
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure transp_check_ausl_ware (
        in_sid               in isi_transport_log.sid%type,
        in_firma_nr          in isi_transport_log.firma_nr%type,
        in_transp_id         in isi_transport_log.transp_id%type,
        in_lhm_id            in lvs_lam.lhm_id%type,
        in_old_id            in lvs_lam.lte_id%type,
        out_check_passed     out isi_transport_log.check_passed%type,
        out_fail_reason_id   out number,
        out_lgr_platz_quelle out lvs_lam.lgr_platz%type
    ) is

        v_transport    isi_transport%rowtype;
        v_transp_lam   lvs_lam%rowtype;
        v_transp_lhm   lvs_lhm%rowtype;
        v_old_lam      lvs_lam%rowtype;
        v_old_lhm      lvs_lhm%rowtype;
        v_lte          lvs_lte%rowtype;
        v_old_lte_id   lvs_lte.lte_id%type;

    -- Alle LAMs, die dieser Transport auf der LTE enthält
        cursor c_transp_lam is
        select
            *
        from
            lvs_lam t
        where
            t.lte_id = v_transport.lte_id;

    -- alle noch ausstehende Kommissionierungen
    -- TODO: muss noch entwickelt werden.
        cursor c_komm_transp_lam is
        select
            *
        from
            lvs_lam t
        where
            t.res_ziel_lte_id = v_transport.lte_id;

        v_found        boolean;
        v_check_passed boolean;
        v_found_new    boolean;
    begin
        out_check_passed := c.c_false;
        out_fail_reason_id := 0;

    -- Transportdaten
        if not lvs_p_base.get_transport(in_sid, in_transp_id, v_transport) then
            raise_isi_error(10,
                            'Die Daten für Transport ID '
                            || nvl(
                to_char(in_transp_id),
                '(null)'
            )
                            || ' konnten nicht gefunden werden.');
        end if;

    -- prüfen, ob die "alte" ID eine LHM ID ist
        if not lvs_p_base.get_lam_by_lhm_id(in_sid, in_firma_nr, in_old_id, v_old_lam) then
      -- in_old_id ist keine LHM ID also prüfen, ob es eine LTE ID ist
            if not lvs_p_base.get_lte(in_old_id, v_lte) then
        -- es ist auch keine LTE ID, also Fehler
                out_fail_reason_id := 10;
                return;
            end if;
      -- Es ist eine LTE ID
            v_old_lte_id := v_lte.lte_id;
        else
      -- in_old_id ist eine gültige LHM ID
            if not lvs_p_base.get_lhm(in_old_id, v_old_lhm) then
                raise_isi_error(20,
                                'Die Daten für LHM ID '
                                || nvl(
                    to_char(in_old_id),
                    '(null)'
                )
                                || ' konnten nicht gefunden werden.');
            end if;

            v_old_lte_id := nvl(v_old_lhm.komm_quell_lte_id, v_old_lam.lte_id);
            if v_old_lte_id is null then
        -- es ist keine LTE ID verfügbar, also Fehler
                out_fail_reason_id := 20;
                return;
            end if;
        end if;

        out_lgr_platz_quelle := null;
        v_found_new := false;

    -- Prüfen, ob LAMs auf der transportierten (Ziel) LTE
    -- von der aktuell gescannten (Quell-) LTE kommen, dann CheckPassed = T
        open c_transp_lam;
        loop
            fetch c_transp_lam into v_transp_lam;
            exit when c_transp_lam%notfound;
            if not lvs_p_base.get_lhm(v_transp_lam.lhm_id, v_transp_lhm) then
                v_transp_lhm.komm_quell_lte_id := null;
            end if;

      -- Prüfen, ob eine LAM des aktuellen Transports auf der alten LTE steht oder stand
            if nvl(v_transp_lhm.komm_quell_lte_id, v_transp_lam.lte_id) = v_old_lte_id then
        -- Die alte LTE ID stimmt mit der neuen LHM ID überein, also ok und fertig
                if v_transp_lam.check_ware_transp_id is null then
                    update lvs_lam t
                    set
                        t.check_ware_transp_id = v_transport.transp_id
                    where
                            t.sid = v_transp_lam.sid
                        and t.firma_nr = v_transp_lam.firma_nr
                        and t.lam_id = v_transp_lam.lam_id;

                    v_found_new := true;
                    commit;
                end if;

                if out_lgr_platz_quelle is null then
                    out_lgr_platz_quelle := nvl(v_transp_lhm.komm_quell_lgr_platz, v_transp_lam.lgr_platz);
                end if;

            end if;

        end loop;

        close c_transp_lam;

/*
    if not v_found_new
    then
      out_check_passed := 'F';
      out_fail_reason_id := 30;
    end if;
*/

    -- gesamter Transport ok?
        v_check_passed := true;
        open c_transp_lam;
        loop
            fetch c_transp_lam into v_transp_lam;
            exit when c_transp_lam%notfound;
            v_check_passed :=
                v_check_passed
                and v_transp_lam.check_ware_transp_id is not null;
        end loop;

        close c_transp_lam;
        out_check_passed := 'F';
        out_fail_reason_id := 50;
        if v_check_passed then
            out_check_passed := 'T';
        end if;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            if c_transp_lam%isopen then
                close c_transp_lam;
            end if;
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_transp_lam%isopen then
                close c_transp_lam;
            end if;
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

end sls_terminal;
/


-- sqlcl_snapshot {"hash":"b62d2287041049bfecd475d4a88e966d3c3f82f7","type":"PACKAGE_BODY","name":"SLS_TERMINAL","schemaName":"DIRKSPZM32","sxml":""}