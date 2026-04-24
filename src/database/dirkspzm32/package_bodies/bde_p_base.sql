create or replace package body dirkspzm32.bde_p_base is

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr   number;
    v_err_text varchar2(255);

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

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_fa_kopf (
        in_sid          in bde_fa_kopf.sid%type,
        in_firma_nr     in bde_fa_kopf.firma_nr%type,
        in_fa_nr        in bde_fa_kopf.fa_nr%type,
        out_bde_fa_kopf out bde_fa_kopf%rowtype
    ) return boolean is
        v_found boolean;
        cursor c_bde_fa_kopf is
        select
            t.*
        from
            bde_fa_kopf t
        where
            t.fa_nr = in_fa_nr;

    begin
        open c_bde_fa_kopf;
        fetch c_bde_fa_kopf into out_bde_fa_kopf;
        v_found := c_bde_fa_kopf%found;
        close c_bde_fa_kopf;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_fa_ag (
        in_sid        in bde_fa_auftrag.sid%type,
        in_firma_nr   in bde_fa_auftrag.firma_nr%type,
        in_fa_nr      in bde_fa_auftrag.leitzahl%type,
        in_fa_ag      in bde_fa_auftrag.fa_ag%type,
        in_fa_upos    in bde_fa_auftrag.fa_upos%type,
        out_bde_fa_ag out bde_fa_auftrag%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_bde_fa_ag is
        select
            t.*
        from
            bde_fa_auftrag t
        where
                t.leitzahl = in_fa_nr
            and t.fa_ag = in_fa_ag
            and t.fa_upos = in_fa_upos;

        cursor c_bde_fa_ag_last is
        select
            t.*
        from
            bde_fa_auftrag t
        where
                t.leitzahl = in_fa_nr
            and t.kenz_letzt_ag = 1;

    begin
        if in_fa_ag is not null then
            open c_bde_fa_ag;
            fetch c_bde_fa_ag into out_bde_fa_ag;
            v_found := c_bde_fa_ag%found;
            close c_bde_fa_ag;
        else
            open c_bde_fa_ag_last;
            fetch c_bde_fa_ag_last into out_bde_fa_ag;
            v_found := c_bde_fa_ag_last%found;
            close c_bde_fa_ag_last;
        end if;

        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_fa_by_auf_id (
        in_sid        in bde_fa_auftrag.sid%type,
        in_firma_nr   in bde_fa_auftrag.firma_nr%type,
        in_auf_id     in bde_fa_auftrag.auf_id%type,
        out_bde_fa_ag out bde_fa_auftrag%rowtype
    ) return boolean is
        v_found boolean;
        cursor c_bde_fa_ag is
        select
            t.*
        from
            bde_fa_auftrag t
        where
            t.auf_id = in_auf_id;

    begin
        open c_bde_fa_ag;
        fetch c_bde_fa_ag into out_bde_fa_ag;
        v_found := c_bde_fa_ag%found;
        close c_bde_fa_ag;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_pd_kopf (
        in_sid            in bde_pd_kopf.sid%type,
        in_firma_nr       in bde_pd_kopf.firma_nr%type,
        in_res_id         in bde_pd_kopf.res_id%type,
        in_pd_kopf_beginn in bde_pd_kopf.pd_kopf_beginn%type,
        out_bde_pd_kopf   out bde_pd_kopf%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_bde_pd_kopf is
        select
            *
        from
            bde_pd_kopf t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_id = in_res_id
            and t.pd_kopf_beginn = in_pd_kopf_beginn;

    begin
        open c_bde_pd_kopf;
        fetch c_bde_pd_kopf into out_bde_pd_kopf;
        v_found := c_bde_pd_kopf%found;
        close c_bde_pd_kopf;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_pd_pers_zeit_kst (
        in_sid                   in bde_pd_pers_zeit_kst.sid%type,
        in_firma_nr              in bde_pd_pers_zeit_kst.firma_nr%type,
        in_res_id                in bde_pd_pers_zeit_kst.res_id%type,
        in_pres_nr               in bde_pd_pers_zeit_kst.pers_nr%type,
        in_pd_pres_beginn        in bde_pd_pers_zeit_kst.pd_pers_beginn%type,
        out_bde_pd_pers_zeit_kst out bde_pd_pers_zeit_kst%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_bde_pd_pers_zeit_kst is
        select
            *
        from
            bde_pd_pers_zeit_kst t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_id = in_res_id
            and t.pers_nr = in_pres_nr
            and t.pd_pers_beginn = in_pd_pres_beginn;

    begin
        open c_bde_pd_pers_zeit_kst;
        fetch c_bde_pd_pers_zeit_kst into out_bde_pd_pers_zeit_kst;
        v_found := c_bde_pd_pers_zeit_kst%found;
        close c_bde_pd_pers_zeit_kst;
        return ( v_found );
    end;

    procedure c_set_fa_ag_mg (
        in_sid               in bde_fa_auftrag.sid%type,
        in_firma_nr          in bde_fa_auftrag.firma_nr%type,
        in_fa_nr             in bde_fa_auftrag.leitzahl%type,
        in_fa_ag             in bde_fa_auftrag.fa_ag%type,
        in_fa_upos           in bde_fa_auftrag.fa_upos%type,
        in_pd_ende           in bde_pd_prod.prod_ende%type,
        in_ag_ist_mg         in bde_fa_auftrag.ag_ist_mg%type,
        in_ag_ist_mg_b       in bde_fa_auftrag.ag_ist_mg_b%type,
        in_ag_ist_mg_schrott in bde_fa_auftrag.ag_ist_mg_schrott%type,
        in_ag_ist_mg_ruesten in bde_fa_auftrag.ag_ist_mg_ruesten%type,
        in_ruest_zeit_ist    in bde_fa_auftrag.ruest_zeit_ist%type,
        in_prod_zeit_ist     in bde_fa_auftrag.prod_zeit_ist%type,
        in_stoer_zeit_ist    in bde_fa_auftrag.stoer_zeit_ist%type
    ) is
        v_bde_fa_auftrag bde_fa_auftrag%rowtype;
        v_found          boolean;
    begin
        if get_fa_ag(in_sid, in_firma_nr, in_fa_nr, in_fa_ag, in_fa_upos,
                     v_bde_fa_auftrag) then
            update bde_pd_prod t
            set
                t.menge_a = t.menge_a + nvl((in_ag_ist_mg - v_bde_fa_auftrag.ag_ist_mg), t.menge_a),
                t.menge_b = t.menge_b + nvl((in_ag_ist_mg_b - v_bde_fa_auftrag.ag_ist_mg_b), t.menge_b),
                t.schrott = t.schrott + nvl((in_ag_ist_mg_schrott - v_bde_fa_auftrag.ag_ist_mg_schrott), t.schrott)
            where
                    t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.vorg_typ = 'PA'
                and t.leitzahl = in_fa_nr
                and t.fa_ag = in_fa_ag
                and t.fa_upos = in_fa_upos
                and t.prod_ende = nvl(in_pd_ende, v_bde_fa_auftrag.termin_ende_ist);

            if nvl(in_ag_ist_mg, v_bde_fa_auftrag.ag_ist_mg) >= v_bde_fa_auftrag.ag_soll_mg then
                v_bde_fa_auftrag.freig_status := 'F';
            else
                v_bde_fa_auftrag.freig_status := 'TF';
            end if;

            update bde_fa_auftrag t
            set
                t.ag_ist_mg = nvl(in_ag_ist_mg, t.ag_ist_mg),
                t.ag_ist_mg_b = nvl(in_ag_ist_mg_b, t.ag_ist_mg_b),
                t.ag_ist_mg_schrott = nvl(in_ag_ist_mg_schrott, t.ag_ist_mg_schrott),
                t.ag_ist_mg_ruesten = nvl(in_ag_ist_mg_ruesten, t.ag_ist_mg_ruesten),
                t.ruest_zeit_ist = nvl(in_ruest_zeit_ist, t.ruest_zeit_ist),
                t.prod_zeit_ist = nvl(in_prod_zeit_ist, t.prod_zeit_ist),
                t.stoer_zeit_ist = nvl(in_stoer_zeit_ist, t.stoer_zeit_ist),
                t.freig_status = v_bde_fa_auftrag.freig_status,
                t.status_freigabe = 10000
            where
                    t.leitzahl = in_fa_nr
                and t.fa_ag = in_fa_ag
                and t.fa_upos = in_fa_upos;

        else
            raise_application_error(-20010,
                                    lc.ec_p3(lc.o_tp3_fa_auftrg_fehlt,
                                             to_char(in_fa_nr),
                                             to_char(in_fa_ag),
                                             to_char(in_fa_upos)),
                                    true);
        end if;

        commit;
    end;

    function get_bde_pd_prozess_data (
        in_sid                     in bde_pd_prozess_data.sid%type,
        in_firma_nr                in bde_pd_prozess_data.firma_nr%type,
        in_vorg_id                 in bde_pd_prozess_data.vorg_id%type,
        in_res_prozess_data_res_id in bde_pd_prozess_data.res_prozess_data_res_id%type,
        in_res_prozess_data_date   in bde_pd_prozess_data.res_prozess_data_date%type,
        in_res_prozess_data_nr     in bde_pd_prozess_data.res_prozess_data_nr%type,
        out_bde_pd_prozess_data    out bde_pd_prozess_data%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_bde_pd_prozess_data is
        select
            t.*
        from
            bde_pd_prozess_data t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_prozess_data_res_id = in_res_prozess_data_res_id
            and t.res_prozess_data_date = in_res_prozess_data_date
            and t.res_prozess_data_nr = in_res_prozess_data_nr;

    begin
        open c_bde_pd_prozess_data;
        fetch c_bde_pd_prozess_data into out_bde_pd_prozess_data;
        v_found := c_bde_pd_prozess_data%found;
        close c_bde_pd_prozess_data;
        return ( v_found );
    end;

    procedure c_bde_pd_set_aktiv_ag (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_leitzahl    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag       in bde_fa_auftrag.fa_ag%type,
        in_fa_upos     in bde_fa_auftrag.fa_upos%type,
        in_res_id      in isi_resource.res_id%type,
        in_akt_term    in isi_arbeitsplatz.ip_name%type,
        in_ls_login_id in isi_user.login_id%type
    ) is
    --------------------------------------------------------------------------------------------------------------------
    -- In dieser procedure wird der Status der Maschine geändert -- STATUS ist Aktive
    --------------------------------------------------------------------------------------------------------------------

        v_fa_akt   bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl Aktuell
        v_res      isi_resource%rowtype; --  Aktuelle Resource
        v_res_zus  isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
        v_sysdate  date; --  Datum und Zeit dieses Vorgangs

        v_pers_nr  isi_resource_zust_akt.pers_nr%type;
        v_vorg_id  bde_pd_prod.vorg_id%type; --  ID des Vorgangs
        v_found    boolean;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);

    -- Lesen der Resource
        cursor c_resource is
        select
            *
        from
            isi_resource t
        where
            t.res_id = in_res_id;

    -- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
        cursor c_bde_fa_auftrag is
        select
            *
        from
            bde_fa_auftrag fa_a
        where
                fa_a.sid = in_sid
            and fa_a.firma_nr = in_firma_nr
            and fa_a.leitzahl = in_leitzahl
            and fa_a.fa_ag = in_fa_ag
            and nvl(fa_a.fa_upos, 0) = nvl(in_fa_upos, 0);

    -- Holen des aktuellen Zustands dieser Maschine
        cursor c_bde_res_zus is
        select
            *
        from
            isi_resource_zust_akt zust_akt
        where
                zust_akt.sid = in_sid
            and zust_akt.res_id = in_res_id;

    begin
    --------------------------------------------------------------------------------------------------------------------
    -- Holen der Auftragsdaten fuer ABNR und Artikel ID
    --------------------------------------------------------------------------------------------------------------------
        open c_bde_fa_auftrag;
        fetch c_bde_fa_auftrag into v_fa_akt;
        v_found := c_bde_fa_auftrag%found;
        close c_bde_fa_auftrag;
    -- Wenn nicht gefunden dann setze Fehlertext !!
        if not v_found then
            v_err_nr := 30;
            v_err_text := 'FA Auftrag für NR: '
                          || in_leitzahl
                          || '/'
                          || in_fa_ag
                          || '/'
                          || in_fa_upos
                          || ' nicht vorhanden';

            raise v_error;
        end if;

        open c_resource;
        fetch c_resource into v_res;
        close c_resource;
        if ( v_res.typ = 'MS'
        or v_res.typ = 'LI'
        or v_res.typ = 'MPG' ) then
            if v_fa_akt.satzart = 'MA' then
                v_err_nr := 10;
                v_err_text := 'Auf der Res. '
                              || v_res.res_ext_name
                              || ' kann FA Auftrag:'
                              || in_leitzahl
                              || '/'
                              || in_fa_ag
                              || '/'
                              || nvl(in_fa_upos, 0)
                              || ' nicht aktiviert werden. Bitte Auftrag korrekt anmelden';

                raise v_error;
            end if;
        end if;

        if
            v_res.typ != 'MS'
            and v_res.typ != 'LI'
            and v_res.typ != 'MPG'
        then
            if v_fa_akt.satzart != 'MA' then
                v_err_nr := 20;
                v_err_text := 'Auf der Res. '
                              || v_res.res_ext_name
                              || ' kann FA Auftrag:'
                              || in_leitzahl
                              || '/'
                              || in_fa_ag
                              || '/'
                              || nvl(in_fa_upos, 0)
                              || ' nicht aktiviert werden, der der Arbeitgang keine Materialanforderung ist. Bitte Auftrag korrekt anmelden'
                              ;

                raise v_error;
            end if;
        end if;

    -- Erst mal kein Fehler
        v_err_nr := null;
        v_err_text := null;
        v_sysdate := sysdate; -- Speichern der Zeitpunkts

    -- Holen des aktuelle Zustands der Maschine
        open c_bde_res_zus;
        fetch c_bde_res_zus into v_res_zus;
        v_found := c_bde_res_zus%found;
        close c_bde_res_zus;

    -- Wenn nicht gefunden dann setze Fehlertext !!
        if not v_found then
            v_err_nr := 10;
            v_err_text := 'Zustand der Maschine ID: '
                          || in_res_id
                          || ' nicht vorhanden';
            raise v_error;
        end if;

        if v_fa_akt.satzart = 'MA' then
            if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'BDE_ANMELD_PERS_RES_MUSS',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'BDE',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                               'T',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'BOOLEAN') = c.c_false  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                               then
                v_pers_nr := 0;
            else
                v_pers_nr := null;
            end if;

      -- Update des Aktuelle Zustands der Maschine
            update isi_resource_zust_akt res_akt
            set
                res_akt.leitzahl = in_leitzahl,
                res_akt.akt_aufgabe = 'P',
                res_akt.akt_aufgabe_seit = v_sysdate,
                res_akt.fa_ag = in_fa_ag,
                res_akt.fa_upos = in_fa_upos,
                res_akt.akt_terminal = nvl(in_akt_term, res_akt.akt_terminal),
                res_akt.fa_seit = v_sysdate,
                res_akt.abfuell_abschalt_grob = v_fa_akt.abfuell_abschalt_grob,
                res_akt.abfuell_abschalt_mittel = v_fa_akt.abfuell_abschalt_mittel,
                res_akt.abfuell_abschalt_fein = v_fa_akt.abfuell_abschalt_fein,
                res_akt.abfuell_toleranz_plus = v_fa_akt.abfuell_toleranz_plus,
                res_akt.abfuell_toleranz_minus = v_fa_akt.abfuell_toleranz_minus,
                res_akt.abfuell_silo = v_fa_akt.abfuell_silo,
                res_akt.abfuell_soll = v_fa_akt.abfuell_soll,
                res_akt.abfuell_ist = 0,
                res_akt.pers_nr = nvl(res_akt.pers_nr, v_pers_nr),
                res_akt.prod_params = v_fa_akt.prod_params,
                res_akt.auftrag_status = decode(
                    nvl(res_akt.auftrag_status, 'F'),
                    'F',
                    'D',
                    res_akt.auftrag_status
                )
            where
                    res_akt.sid = in_sid
                and res_akt.res_id = in_res_id;

      -- Update des Aktuelle Zustands des Arbeitsgangs
            update bde_fa_auftrag fa
            set
                fa.freig_status = 'A',
                fa.termin_start_ist = nvl(fa.termin_start_ist, v_sysdate)
            where
                    fa.sid = in_sid
                and fa.leitzahl = in_leitzahl
                and fa.fa_ag = in_fa_ag
                and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);

            update bde_fa_auftrag fa
            set
                fa.freig_status = 'A'
            where
                    fa.sid = in_sid
                and fa.leitzahl = in_leitzahl
                and fa.satzart = 'MA'
                and fa.freig_status = 'N';

        else
      -- Update des Aktuelle Zustands des Arbeitsgangs
            update bde_fa_auftrag fa
            set
                fa.freig_status = 'A'
            where
                    fa.sid = in_sid
                and fa.leitzahl = in_leitzahl
                and fa.fa_ag = in_fa_ag
                and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0)
                and fa.freig_status = 'N';

        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            if c_bde_res_zus%isopen then
                close c_bde_res_zus;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if c_bde_res_zus%isopen then
                close c_bde_res_zus;
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

    end c_bde_pd_set_aktiv_ag;

    procedure c_bde_pd_set_deaktiv_ag (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_akt_term    in isi_arbeitsplatz.ip_name%type,
        in_ls_login_id in isi_user.login_id%type
    ) is
    --------------------------------------------------------------------------------------------------------------------
    -- In dieser procedure wird der Status der Maschine geändert -- STATUS ist Aktive
    --------------------------------------------------------------------------------------------------------------------

        v_res      isi_resource%rowtype; --  Aktuelle Resource
        v_res_zus  isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
        v_sysdate  date; --  Datum und Zeit dieses Vorgangs

        v_pers_nr  isi_resource_zust_akt.pers_nr%type;
        v_vorg_id  bde_pd_prod.vorg_id%type; --  ID des Vorgangs
        v_found    boolean;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);

    -- Lesen der Resource
        cursor c_resource is
        select
            *
        from
            isi_resource t
        where
            t.res_id = in_res_id;

    -- Holen des aktuellen Zustands dieser Maschine
        cursor c_bde_res_zus is
        select
            *
        from
            isi_resource_zust_akt zust_akt
        where
                zust_akt.sid = in_sid
            and zust_akt.res_id = in_res_id;

    begin
        open c_resource;
        fetch c_resource into v_res;
        close c_resource;
        if v_res.typ = 'MS'
        or v_res.typ = 'LI'
        or v_res.typ = 'MPG' then
            v_err_nr := 10;
            v_err_text := 'Auf der Res. '
                          || v_res.res_ext_name
                          || ' kann nicht deaktiviert werden. Bitte Auftrag korrekt anmelden';
            raise v_error;
        end if;

    -- Erst mal kein Fehler
        v_err_nr := null;
        v_err_text := null;
        v_sysdate := sysdate; -- Speichern der Zeitpunkts

    -- Holen des aktuelle Zustands der Maschine
        open c_bde_res_zus;
        fetch c_bde_res_zus into v_res_zus;
        v_found := c_bde_res_zus%found;
        close c_bde_res_zus;

    -- Wenn nicht gefunden dann setze Fehlertext !!
        if not v_found then
            v_err_nr := 10;
            v_err_text := 'Zustand der Maschine ID: '
                          || in_res_id
                          || ' nicht vorhanden';
            raise v_error;
        end if;

    --------------------------------------------------------------------------------------------------------------------
    -- Holen der Auftragsdaten fuer ABNR und Artikel ID
    --------------------------------------------------------------------------------------------------------------------

    -- Update des Aktuelle Zustands der Maschine
        update isi_resource_zust_akt res_akt
        set
            res_akt.leitzahl = null,
            res_akt.akt_aufgabe = null,
            res_akt.fa_ag = null,
            res_akt.fa_upos = null,
            res_akt.fa_seit = null,
            res_akt.lte_id = null,
            res_akt.abfuell_abschalt_grob = null,
            res_akt.abfuell_abschalt_mittel = null,
            res_akt.abfuell_abschalt_fein = null,
            res_akt.abfuell_toleranz_plus = null,
            res_akt.abfuell_toleranz_minus = null,
            res_akt.abfuell_silo = null,
            res_akt.abfuell_soll = null,
            res_akt.abfuell_ist = null,
            res_akt.prod_params = null,
            res_akt.auftrag_status = 'F'
        where
                res_akt.sid = in_sid
            and res_akt.res_id = in_res_id;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            if c_bde_res_zus%isopen then
                close c_bde_res_zus;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if c_bde_res_zus%isopen then
                close c_bde_res_zus;
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

    end c_bde_pd_set_deaktiv_ag;

    procedure c_bde_pd_set_reset_ag (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_leitzahl    in bde_fa_auftrag.leitzahl%type,
        in_fa_ag       in bde_fa_auftrag.fa_ag%type,
        in_fa_upos     in bde_fa_auftrag.fa_upos%type,
        in_res_id      in isi_resource.res_id%type,
        in_akt_term    in isi_arbeitsplatz.ip_name%type,
        in_ls_login_id in isi_user.login_id%type
    ) is
    --------------------------------------------------------------------------------------------------------------------
    -- In dieser procedure wird der Status der Maschine geändert -- STATUS ist Aktive
    --------------------------------------------------------------------------------------------------------------------

        v_fa_akt   bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl Aktuell
        v_res      isi_resource%rowtype; --  Aktuelle Resource
        v_res_zus  isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
        v_sysdate  date; --  Datum und Zeit dieses Vorgangs

        v_pers_nr  isi_resource_zust_akt.pers_nr%type;
        v_vorg_id  bde_pd_prod.vorg_id%type; --  ID des Vorgangs
        v_found    boolean;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);

    -- Lesen der Resource
        cursor c_resource is
        select
            *
        from
            isi_resource t
        where
            t.res_id = nvl(v_fa_akt.res_id, in_res_id);

    -- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
        cursor c_bde_fa_auftrag is
        select
            *
        from
            bde_fa_auftrag fa_a
        where
                fa_a.sid = in_sid
            and fa_a.firma_nr = in_firma_nr
            and fa_a.leitzahl = in_leitzahl
            and fa_a.fa_ag = in_fa_ag
            and nvl(fa_a.fa_upos, 0) = nvl(in_fa_upos, 0);

    -- Holen des aktuellen Zustands dieser Maschine
        cursor c_bde_res_zus is
        select
            *
        from
            isi_resource_zust_akt zust_akt
        where
                zust_akt.sid = in_sid
            and zust_akt.res_id = nvl(v_fa_akt.res_id, in_res_id);

    begin
    --------------------------------------------------------------------------------------------------------------------
    -- Holen der Auftragsdaten fuer ABNR und Artikel ID
    --------------------------------------------------------------------------------------------------------------------
        open c_bde_fa_auftrag;
        fetch c_bde_fa_auftrag into v_fa_akt;
        v_found := c_bde_fa_auftrag%found;
        close c_bde_fa_auftrag;
    -- Wenn nicht gefunden dann setze Fehlertext !!
        if not v_found then
            v_err_nr := 30;
            v_err_text := 'FA Auftrag für NR: '
                          || in_leitzahl
                          || '/'
                          || in_fa_ag
                          || '/'
                          || in_fa_upos
                          || ' nicht vorhanden';

            raise v_error;
        end if;

        open c_resource;
        fetch c_resource into v_res;
        close c_resource;
        if ( v_res.typ = 'MS'
        or v_res.typ = 'LI'
        or v_res.typ = 'MPG' ) then
            if v_fa_akt.satzart = 'MA' then
                v_err_nr := 10;
                v_err_text := 'Auf der Res. '
                              || v_res.res_ext_name
                              || ' kann FA Auftrag:'
                              || in_leitzahl
                              || '/'
                              || in_fa_ag
                              || '/'
                              || nvl(in_fa_upos, 0)
                              || ' nicht deaktiviert werden. Bitte Auftrag korrekt anmelden';

                raise v_error;
            end if;
        end if;

        if
            v_res.typ != 'MS'
            and v_res.typ != 'LI'
            and v_res.typ != 'MPG'
        then
            if v_fa_akt.satzart = 'MA' then
                v_err_nr := 20;
                v_err_text := 'Auf der Res. '
                              || v_res.res_ext_name
                              || ' kann FA Auftrag:'
                              || in_leitzahl
                              || '/'
                              || in_fa_ag
                              || '/'
                              || nvl(in_fa_upos, 0)
                              || ' nicht deaktiviert werden, der der Arbeitgang keine Materialanforderung ist. Bitte Auftrag korrekt anmelden'
                              ;

                raise v_error;
            end if;
        end if;

    -- Erst mal kein Fehler
        v_err_nr := null;
        v_err_text := null;
        v_sysdate := sysdate; -- Speichern der Zeitpunkts

    -- Holen des aktuelle Zustands der Maschine
        open c_bde_res_zus;
        fetch c_bde_res_zus into v_res_zus;
        v_found := c_bde_res_zus%found;
        close c_bde_res_zus;

    -- Wenn nicht gefunden dann setze Fehlertext !!
        if not v_found then
            v_err_nr := 10;
            v_err_text := 'Zustand der Maschine ID: '
                          || in_res_id
                          || ' nicht vorhanden';
            raise v_error;
        end if;
    -- Update des Aktuelle Zustands der Maschine
        update isi_resource_zust_akt res_akt
        set
            res_akt.leitzahl = null,
            res_akt.akt_aufgabe = null,
            res_akt.fa_ag = null,
            res_akt.fa_upos = null,
            res_akt.fa_seit = null,
            res_akt.lte_id = null,
            res_akt.abfuell_abschalt_grob = null,
            res_akt.abfuell_abschalt_mittel = null,
            res_akt.abfuell_abschalt_fein = null,
            res_akt.abfuell_toleranz_plus = null,
            res_akt.abfuell_toleranz_minus = null,
            res_akt.abfuell_silo = null,
            res_akt.abfuell_soll = null,
            res_akt.abfuell_ist = null,
            res_akt.prod_params = null,
            res_akt.auftrag_status = 'F'
        where
                res_akt.sid = in_sid
            and res_akt.res_id = nvl(v_fa_akt.res_id, in_res_id)
            and res_akt.leitzahl = in_leitzahl;

        if v_fa_akt.satzart != 'MA' then
            update bde_fa_auftrag_lte_pool lte
            set
                lte.lte_verwendet = 'A'
            where
                    lte.sid = v_fa_akt.sid
                and lte.firma_nr = v_fa_akt.firma_nr
                and lte.leitzahl = v_fa_akt.leitzahl
                and lte.lte_verwendet = 'V';

        end if;
    -- Update des Aktuelle Zustands des Arbeitsgangs
        update bde_fa_auftrag fa
        set
            fa.freig_status = 'N',
            fa.ag_ist_mg_schrott = fa.ag_ist_mg_schrott + fa.ag_ist_mg,
            fa.ag_ist_mg = 0
        where
                fa.sid = v_fa_akt.sid
            and fa.firma_nr = v_fa_akt.firma_nr
            and fa.leitzahl = v_fa_akt.leitzahl;

        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            if c_bde_res_zus%isopen then
                close c_bde_res_zus;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if c_bde_res_zus%isopen then
                close c_bde_res_zus;
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

    end c_bde_pd_set_reset_ag;

    function bde_pd_check_aktiv_ag (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_leitzahl in bde_fa_auftrag.leitzahl%type,
        in_fa_ag    in bde_fa_auftrag.fa_ag%type,
        in_fa_upos  in bde_fa_auftrag.fa_upos%type
    ) return varchar is

    --------------------------------------------------------------------------------------------------------------------
    -- In dieser procedure wird der Status der Maschine geändert -- STATUS ist Aktive
    --------------------------------------------------------------------------------------------------------------------

        v_fa_akt   bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl Aktuell
        v_pers_nr  isi_resource_zust_akt.pers_nr%type;
        v_found    boolean;

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(255);

    -- Lesen der Resource
    -- Holen des Auftrags genau für diese Leitzahl an dieser Maschine
        cursor c_bde_fa_auftrag is
        select
            *
        from
            bde_fa_auftrag fa_a
        where
                fa_a.sid = in_sid
            and fa_a.firma_nr = in_firma_nr
            and fa_a.leitzahl = in_leitzahl
            and fa_a.fa_ag = in_fa_ag
            and nvl(fa_a.fa_upos, 0) = nvl(in_fa_upos, 0);

    begin

    --------------------------------------------------------------------------------------------------------------------
    -- Holen der Auftragsdaten fuer ABNR und Artikel ID
    --------------------------------------------------------------------------------------------------------------------
        open c_bde_fa_auftrag;
        fetch c_bde_fa_auftrag into v_fa_akt;
        v_found := c_bde_fa_auftrag%found;
        close c_bde_fa_auftrag;
    -- Wenn nicht gefunden dann setze Fehlertext !!
        if not v_found
        or v_fa_akt.freig_status = 'N' then
            return ( c.c_false );
        end if;

        return ( c.c_true );
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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
    end bde_pd_check_aktiv_ag;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
    function get_pd_prod_by_lam_id (
        in_sid          in bde_pd_prod.sid%type,
        in_firma_nr     in bde_pd_prod.firma_nr%type,
        in_lam_id       in bde_pd_prod.lam_id%type,
        out_bde_pd_prod out bde_pd_prod%rowtype
    ) return boolean is

        v_found boolean;
        cursor c_bde_pd_prod is
        select
            t.*
        from
            bde_pd_prod t
        where
            t.lam_id = in_lam_id
        order by
            t.prod_ende desc;

    begin
        open c_bde_pd_prod;
        fetch c_bde_pd_prod into out_bde_pd_prod;
        v_found := c_bde_pd_prod%found;
        close c_bde_pd_prod;
        return ( v_found );
    end;

  -------------------------------------------------------------------------------------------------------
  -- Die Funktion liefert zu die Leitzahl (FA) zu einer LTE zurueck
  -------------------------------------------------------------------------------------------------------
    function get_leitzahl_by_lte_id (
        in_sid      in lvs_lte.sid%type,
        in_firma_nr in lvs_lte.firma_nr%type,
        in_lte_id   in lvs_lte.lte_id%type
    ) return number is

        v_error exception;
        v_err_nr      number;
        v_err_text    varchar2(255);
        v_lam         lvs_lam%rowtype;
        v_lte         lvs_lte%rowtype;
        v_bde_pd_prod bde_pd_prod%rowtype;
        v_bde_fa      bde_fa_auftrag%rowtype;
    begin
        v_err_nr := null;
        v_err_text := null;
        if not lvs_p_base.get_lte(in_lte_id, v_lte)
        or not lvs_p_base.get_lam_by_lte_id(in_sid, in_firma_nr, in_lte_id, v_lam) then
            v_err_nr := c.fmid_lte_id_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
            raise v_error;
        end if;

        if not bde_p_base.get_pd_prod_by_lam_id(in_sid, in_firma_nr, v_lam.lam_id, v_bde_pd_prod) then
            if bde_p_base.get_fa_by_auf_id(in_sid, in_firma_nr, v_lam.order_pos_auf_id, v_bde_fa) then
                return ( v_bde_fa.leitzahl );
            else
                return ( null );
            end if;
        else
            return ( v_bde_pd_prod.leitzahl );
        end if;

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
    end get_leitzahl_by_lte_id;

end;
/


-- sqlcl_snapshot {"hash":"cdc7e5ce80b270fa067448e3d6ed98adedbcde91","type":"PACKAGE_BODY","name":"BDE_P_BASE","schemaName":"DIRKSPZM32","sxml":""}