create or replace package body dirkspzm32.lvs_platz_new is

    v_g_err_nr number;

  -------------------------------------------------------------------------
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

  -------------------------------------------------------------------------
  -- -AG- 27.01.2011 Umbau Einl.StratParams im Lagerort
  -- Hierfür mussten alle Funktionen geprüft und überarbeitet werden
  -- Daher ist dieser Stand mit 3.5.1 schwer zu vergleichen
  -------------------------------------------------------------------------

  -- Funktion dient zum Setzten und Ruecksetzen einer Artikelreservierung für eien Lagerplatzgruppe
procedure lvs_transp_suche_einl_platz (
    in_lte_id               in lvs_lte.lte_id%type,
    in_lgr_orte             in varchar2,
    in_fahrzeuge_ids        in varchar2,
    in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
    in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
    in_user_id              in isi_user.login_id%type,
    in_prio                 in isi_transport.prio%type,
    in_progr_nr             in isi_transport.progr_nr%type,
    in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
    in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
    in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
    out_lgr_platz           out lvs_lgr.lgr_platz%type,
    out_transport_id        out number
);
    procedure lvs_c_lgr_platz_reserv_art_id (
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type,
        in_lvs_artikel_id   in isi_artikel.artikel_id%type,
        in_res_statisch     in lvs_lgr.res_art_statisch%type
    ) as
    -------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
    begin
        v_err_nr := null;
        v_err_text := null;
        update lvs_lgr
        set
            res_artikel_id = in_lvs_artikel_id,
            res_art_statisch = in_res_statisch
        where
            lgr_platz_gruppe = in_lgr_platz_gruppe;

        if ( sql%rowcount = 0 ) then
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lgr_platz_gruppe);
            raise v_error;
        end if;

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_lgr_platz_reserv_art_id;
  -------------------------------------------------------------------------
  -- Konfiguriert ABC, Gefahrenklasse, WertKlasse aus dem Dialog indem
  -- von und bisparameter angegeben werden.
    procedure lvs_c_lgr_plaetze_konfig (
        in_abc             in lvs_lgr.abc%type,
        in_gefahren_klasse in lvs_lgr.gefahren_klasse%type,
        in_wert_klasse     in lvs_lgr.wert_klasse%type,
        in_gruppe          in lvs_lgr.gruppe%type, -- noch nicht implementiert
        in_von_lgr_platz   in lvs_lgr.lgr_platz%type,
        in_bis_lgr_platz   in lvs_lgr.lgr_platz%type,
        in_ls_login_id     in isi_user.login_id%type
    )
  -------------------------------------------------------------------------
     as

        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(2550);
        v_update_counter number;
        v_found          boolean; -- Gefunden (CURSOR)
        v_lgr_platz      lvs_lgr.lgr_platz%type;
        v_lgr_sid        lvs_lgr.sid%type;
        v_lgr_firma      lvs_lgr.firma_nr%type;
        cursor c_lvs_lgr_von is -- Lesen des Start Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = in_von_lgr_platz;

        cursor c_lvs_lgr_bis is -- Lesen des End Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = in_bis_lgr_platz;

        v_lgr_von        lvs_lgr%rowtype; -- Lagerplatz von
        v_lgr_bis        lvs_lgr%rowtype; -- Lagerplatz bis
        v_loop_platz     lvs_lgr.lgr_platz%type;
        v_loop_sid       lvs_lgr.sid%type;
        v_loop_firma     lvs_lgr.firma_nr%type;
        v_abc            lvs_lgr.abc%type;
        v_gefahrenklasse lvs_lgr.gefahren_klasse%type;
        v_wertklasse     lvs_lgr.wert_klasse%type;
        cursor c_lvs_loop is -- Lesen des End Lagerplatz
        select
            b.sid,
            b.firma_nr,
            b.lgr_platz,
            b.abc,
            b.gefahren_klasse,
            b.wert_klasse
      /*from lvs_lgr b

      where b.sid     = V_lgr_von.sid
      and   b.firma_nr= v_lgr_von.firma_Nr
      and   b.lgr_dim_platz >= v_lgr_von.lgr_dim_platz
      and   b.lgr_dim_platz <= v_lgr_bis.lgr_dim_platz;
      */
        from
            lvs_lgr a,
            lvs_lgr b
        where
                a.lgr_platz_gruppe = b.lgr_platz_gruppe
            and a.lgr_ort = v_lgr_von.lgr_ort
            and b.lgr_ort = v_lgr_von.lgr_ort
            and a.sid = v_lgr_von.sid
            and b.sid = v_lgr_von.sid
            and a.firma_nr = v_lgr_von.firma_nr
            and a.lgr_dim_g >= v_lgr_von.lgr_dim_g -- gang
            and a.lgr_dim_g <= v_lgr_bis.lgr_dim_g
            and a.lgr_dim_r >= v_lgr_von.lgr_dim_r -- reihe
            and a.lgr_dim_r <= v_lgr_bis.lgr_dim_r
            and a.lgr_dim_p >= v_lgr_von.lgr_dim_p -- platz
            and a.lgr_dim_p <= v_lgr_bis.lgr_dim_p
            and a.lgr_dim_e >= v_lgr_von.lgr_dim_e -- ebene
            and a.lgr_dim_e <= v_lgr_bis.lgr_dim_e
            and a.lgr_dim_t >= v_lgr_von.lgr_dim_t -- tiefe
            and a.lgr_dim_t <= v_lgr_bis.lgr_dim_t;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_lvs_lgr_von;
        fetch c_lvs_lgr_von into v_lgr_von;
        v_found := c_lvs_lgr_von%found;
        close c_lvs_lgr_von;
        if not v_found then
            v_err_nr := c.fmid_quelle_existiert_nicht;
            v_err_text := lc.ec_p1(lc.o_tp1_q_lgr_platz_fehlt, in_von_lgr_platz);
            raise v_error;
        end if;

        open c_lvs_lgr_bis;
        fetch c_lvs_lgr_bis into v_lgr_bis;
        v_found := c_lvs_lgr_bis%found;
        close c_lvs_lgr_bis;
        if not v_found then
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_z_lgr_platz_fehlt, in_bis_lgr_platz);
            raise v_error;
        end if;

        if ( v_lgr_von.sid <> v_lgr_bis.sid )
        or ( v_lgr_von.firma_nr <> v_lgr_bis.firma_nr )
        or ( v_lgr_von.lgr_ort <> v_lgr_bis.lgr_ort ) then
            v_err_nr := 5;
            v_err_text := lc.ec(lc.o_txt_lgr_platz_gleich_bereich);
            raise v_error;
        end if;

        if ( v_lgr_von.lgr_dim_g > v_lgr_bis.lgr_dim_g )
        or ( v_lgr_von.lgr_dim_r > v_lgr_bis.lgr_dim_r )
        or ( v_lgr_von.lgr_dim_e > v_lgr_bis.lgr_dim_e )
        or ( v_lgr_von.lgr_dim_t > v_lgr_bis.lgr_dim_t )
        or ( v_lgr_von.lgr_dim_p > v_lgr_bis.lgr_dim_p ) then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_lgr_platz_von_klein_bis);
            raise v_error;
        end if;

        v_update_counter := 0;
        open c_lvs_loop;
        loop
            fetch c_lvs_loop into
                v_loop_sid,
                v_loop_firma,
                v_loop_platz,
                v_abc,
                v_gefahrenklasse,
                v_wertklasse;
            v_found := c_lvs_loop%found;
            if not v_found then
                exit;
            end if;
            v_update_counter := v_update_counter + 1;
            if in_abc is not null then
                v_abc := in_abc;
            end if;
            if in_wert_klasse is not null then
                v_wertklasse := in_wert_klasse;
            end if;
            if in_gefahren_klasse is not null then
                v_gefahrenklasse := in_gefahren_klasse;
            end if;
            update lvs_lgr
            set
                abc = v_abc,
                gefahren_klasse = v_gefahrenklasse,
                wert_klasse = v_wertklasse
            where
                    sid = v_loop_sid
                and firma_nr = v_loop_firma
                and lgr_platz = v_loop_platz;

            if v_update_counter >= 100 then
                commit;
                v_update_counter := 0;
            end if;
        end loop;

        close c_lvs_loop;
        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_lgr_plaetze_konfig;

    procedure lte_nach_komm_pruef (
        io_lte in out lvs_lte%rowtype
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2550);
    -------------------------------------------------------------------------------------------------------

        v_komm_neu_lhm_name lvs_lhm.komm_neu_lhm_name%type;
        v_lam_kg            lvs_lam.lam_kg%type;
        v_lhm_vol_hoehe     lvs_lhm.lhm_vol_hoehe%type;
        v_lhm_vol_breite    lvs_lhm.lhm_vol_breite%type;
        v_lhm_vol_tiefe     lvs_lhm.lhm_vol_tiefe%type;
        v_lhm_akt_kg        lvs_lhm.lhm_akt_kg%type;
        v_lhm_cfg           lvs_lhm_cfg%rowtype;
        cursor c_lhm_by_lte_id is
        select
            t.komm_neu_lhm_name,
            lam.lam_kg
        from
            lvs_lhm t,
            lvs_lam lam
        where
                t.lte_id = io_lte.lte_id
            and lam.lhm_id = t.lhm_id;

        cursor c_lhm_by_lam_res_lte_id is
        select
            t.komm_neu_lhm_name,
            t.lhm_vol_hoehe,
            t.lhm_vol_breite,
            t.lhm_vol_tiefe,
            t.lhm_akt_kg,
            lam.lam_kg
        from
            lvs_lam lam,
            lvs_lhm t
        where
                lam.res_ziel_lte_id = io_lte.lte_id
            and t.lhm_id = lam.lhm_id;

        v_found             boolean;
    begin
        if io_lte.lte_name = c.keinelte then
      -- Entweder es wird eine LHM Tranportiert, oder es soll eine LHM abgepackt werden und auf dieser
      -- (Buchungs-) LTE transportiert werden.
      -- Diese Prüfung ist nur relevant, wenn der LHM Typ während des Transportes gewechselt wird.
            open c_lhm_by_lte_id;
            fetch c_lhm_by_lte_id into
                v_komm_neu_lhm_name,
                v_lam_kg;
            v_found := c_lhm_by_lte_id%found;
            close c_lhm_by_lte_id;
            if not v_found -- Keine LHM auf LTe gefunden -> also mögl. Komm. Ziel LTE
             then
                open c_lhm_by_lam_res_lte_id;
                fetch c_lhm_by_lam_res_lte_id into
                    v_komm_neu_lhm_name,
                    v_lhm_vol_hoehe,
                    v_lhm_vol_breite,
                    v_lhm_vol_tiefe,
                    v_lhm_akt_kg,
                    v_lam_kg;
                v_found := c_lhm_by_lam_res_lte_id%found;
                close c_lhm_by_lam_res_lte_id;
                if v_found then
          -- Bei Transportfreigabe wird da eine LHM drauf sein, da eine Reservierung vorliegt
                    io_lte.lte_vol_hoehe := v_lhm_vol_hoehe;
                    io_lte.lte_vol_breite := v_lhm_vol_breite;
                    io_lte.lte_vol_tiefe := v_lhm_vol_tiefe;
                    io_lte.lte_akt_kg := v_lhm_akt_kg;
                    io_lte.lte_akt_lhm := 1;
                end if;

            end if;

            if
                v_found
                and v_komm_neu_lhm_name is not null
            then
                if not lvs_p_base.get_lhm_cfg(io_lte.sid, v_komm_neu_lhm_name, v_lhm_cfg) then
                    v_err_nr := 10;
                    v_err_text := lc.ec_p1(lc.o_tp1_lhm_cfg_fehlt, v_komm_neu_lhm_name);
                    raise v_error;
                end if;

        -- In diesem Fall "biegen" wir die Daten der LTE (im Speicher) um, damit die Transportlogik
        -- Mit den neuen Werten rechnet
                io_lte.lte_vol_hoehe := v_lhm_cfg.lhm_vol_hoehe;
                io_lte.lte_vol_breite := v_lhm_cfg.lhm_vol_breite;
                io_lte.lte_vol_tiefe := v_lhm_cfg.lhm_vol_tiefe;
                io_lte.lte_akt_kg := nvl(v_lhm_cfg.lhm_gew_kg, 0) + isi_utils.max_number(v_lam_kg, 0);

            end if;

        end if;
    -- Andere Varianten hier
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

  -------------------------------------------------------------------------
  -- Prüft, ob die Einlagerung auf diesen Platz für diese TE möglich ist
  -- es wird nicht geprüft, ob diese auch strategisch sinnvoll ist.
  -- Bring als return den Fehlertext bzw. NULL wenn allse OK
  -------------------------------------------------------------------------
  --Achtung--Achtung--Achtung--Achtung--Achtung--Achtung--Achtung--Achtung-
  -- Diese Funktion reisst keine Exception im Fehlerfall
  -------------------------------------------------------------------------
    function lvs_platz_einl_pruef_err_text (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_fahrzeuge_ids           in varchar2
    ) return varchar2 is
    begin
        return lvs_platz_einl_pruef_err_t_r30(in_lte, -- in   lvs_lte%ROWTYPE,
         in_basis_lte_name, -- in   lvs_lte_cfg.basis_lte_name%type,
         in_flaechen_stellplatz_erf, -- in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
         in_lgr, -- in   lvs_lgr%ROWTYPE,
         '?', --in_transport_typ      -- in   isi_transport.transp_typ%type,
                                              in_fahrzeuge_ids); -- in   varchar2)
    end;

  --------------------------------------------------------------------------------------------
  -- -AG- 30.01.2019 Erweiterung der Lager-CFG für die Platz-Prüfung ueber PLatz und Lagerort
  -- Hierzu sind diverse Funktionen erweitert worden. Die alten Funktionen wurden als Deckel
  -- erhalten
  --------------------------------------------------------------------------------------------
    function lvs_platz_einl_pruef_err_t_r30 (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_transport_typ           in isi_transport.transp_typ%type,
        in_fahrzeuge_ids           in varchar2
    ) return varchar2 is
    --------------------------------------------------------------------------
        v_found             boolean;
        v_lagertype_ok      boolean;
        v_error exception;
        v_err_start         number := 0;
        v_lgr_ort           lvs_lgr_ort%rowtype;
        v_err_nr            number;
        v_err_text          varchar2(2550);
        v_lte_komm_info     lvs_lte%rowtype;
        v_lgr_cfg           lvs_lgr_cfg%rowtype;
        v_lgr_ort_cfg       lvs_lgr_ort_cfg%rowtype;
        v_labor_status      lvs_lam.labor_status%type;
        v_lgr_max_kg        lvs_lgr.lgr_akt_kg%type;
        v_lgr_akt_kg        lvs_lgr.lgr_max_kg%type;
        v_lgr_dispo_einl_kg lvs_lgr.lgr_dispo_einl_kg%type;
        v_lgr_ziel_grp      lvs_lgr.lgr_platz_gruppe%type;
        cursor c_lgr_ort is
        select
            *
        from
            lvs_lgr_ort l
        where
                l.sid = in_lgr.sid
            and l.firma_nr = in_lgr.firma_nr
            and l.lgr_ort = in_lgr.lgr_ort;

        cursor c_lvs_lgr_kg_grp is
        select
            sum(nvl(t.lgr_max_kg, 0)),
            sum(nvl(t.lgr_akt_kg, 0)),
            sum(nvl(
                decode(t.lgr_platz,
                       nvl(in_lte.ziel_lgr_platz, ' '),
                       0,
                       t.lgr_dispo_einl_kg),
                0
            ))
        from
            lvs_lgr t
        where
                t.lgr_kg_gruppe = in_lgr.lgr_kg_gruppe
            and ( nvl(t.lte_namen_cfg, 'Euro') != 'DueDo;'
                  or t.lgr_dim_t = 1 )
        group by
            t.lgr_kg_gruppe;

        cursor c_lvs_ziel_grp is
        select
            t.lgr_platz_gruppe
        from
            lvs_lgr t
        where
            t.lgr_platz = in_lte.ziel_lgr_platz;

        cursor c_lgr_cfg is
        select
            *
        from
            lvs_lgr_cfg t
        where
            t.lgr_platz = in_lgr.lgr_platz;

        cursor c_lgr_ort_cfg is
        select
            *
        from
            lvs_lgr_ort_cfg t
        where
                t.lgr_ort = in_lgr.lgr_ort
            and not exists (
                select
                    *
                from
                    lvs_lgr_cfg x
                where
                        x.lgr_platz = in_lgr.lgr_platz
                    and x.lgr_platz_cfg_param = t.lgr_ort_cfg_param
            );

        cursor c_lam_labor_status is
        select
            t.labor_status
        from
            lvs_lam t
        where
            t.lte_id = in_lte.lte_id
        group by
            t.labor_status;

    begin
        v_found := true;
        v_lagertype_ok := false;
        v_err_text := null;
        v_lgr_platz_fehler := 1;
        v_lte_komm_info := in_lte; -- Daten in die Zwischenvariable übernehmen
        lte_nach_komm_pruef(v_lte_komm_info);
        if in_lgr.lgr_verwendung = c.lgr_typ_we
        or in_lgr.lgr_verwendung = c.lgr_typ_wa
        or in_lgr.lgr_verwendung = c.lgr_typ_ep then
            return ( v_err_text );
        end if;

        v_lgr_ort := null;
        open c_lgr_ort;
        fetch c_lgr_ort into v_lgr_ort;
        close c_lgr_ort;
        if not v_ignor_inventur then
            if in_lgr.akt_inventur_id is not null then
                v_lgr_platz_fehler := c.fmid_platz_nicht_io;
                v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_in_inventur, in_lgr.lgr_platz);
            end if;

            if v_lgr_ort.akt_inventur_id is not null then
                v_lgr_platz_fehler := c.fmid_platz_nicht_io;
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_ort_in_inventur, in_lgr.lgr_ort, v_lgr_ort.lgr_ort_text);

            end if;

        end if;

        if in_lgr.gesperrt = c.lgr_gesperrt_g then
            v_err_text := lc.ec_p2(lc.o_tp2_lagerplatz_gesperrt, in_lgr.lgr_platz, in_lgr.gesp_grund);

            v_lgr_platz_fehler := c.fmid_lagerplatz_gesperrt;
            return ( v_err_text );
        elsif in_fahrzeuge_ids is not null then
      -- Wenn der Zugang zu diesem Lagerplatz über konfigurierte Fahrzeuge erfolgen soll
      -- wird die Verfuegbarkeit in der Unterfunktion
            v_lgr_platz_fehler := c.fmid_alle_fahrz_ausgelastet;
            v_err_text := lvs_p_lgr_grp_fahrzeuge.chk_lgr_grp_zugriff_ok(in_lgr, in_lte, in_fahrzeuge_ids);
        end if;

        if v_err_text is null then
            if in_flaechen_stellplatz_erf = c.c_true -- Palette benoetigt Flaeche
             then
                if in_lgr.flaechen_stellplatz != c.c_true then
                    v_lgr_platz_fehler := c.fmid_platz_nicht_io;
                    v_err_text := lc.ec_p3(lc.o_tp3_lgr_keine_flaech, in_lte.lte_id, in_lte.lte_name, in_lgr.lgr_platz);

                end if;

            end if;
        end if;

        if v_err_text is null then
      -- erst mal prüfen, ob der LTE_NAME in der liste der LTE_Namen_liste auftaucht
            if
                ( in_lgr.lte_namen is not null )
                and ( not in_lgr.lte_namen like '%'
                                                || in_basis_lte_name
                                                || ';'
                                                || '%' )
                and ( not in_lgr.lte_namen like '%'
                                                || in_lte.lte_name
                                                || ';'
                                                || '%' )
            then
                v_err_text := lc.ec_p3(lc.o_tp3_lgr_fuer_lte_err, in_lte.lte_id, in_lte.lte_name, in_lgr.lgr_platz);

                v_lgr_platz_fehler := c.fmid_falscher_lte_type;
            elsif in_lgr.lgr_temp < in_lte.min_temp then
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_zu_kalt, in_lte.lte_id, in_lte.lte_name);

                v_lgr_platz_fehler := c.fmid_falsche_temperatur;
            elsif in_lgr.lgr_temp > in_lte.max_temp then
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_zu_warm, in_lte.lte_id, in_lte.lte_name);

                v_lgr_platz_fehler := c.fmid_falsche_temperatur;
            elsif in_lte.wert_klasse > in_lgr.wert_klasse then
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_wert_k_zu_gross, in_lgr.lgr_platz, in_lte.lte_id);

                v_lgr_platz_fehler := c.fmid_falsche_wertklasse;
            elsif in_lte.gefahren_klasse > in_lgr.gefahren_klasse then
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_g_klasse_zu_gross, in_lgr.lgr_platz, in_lte.lte_id);

                v_lgr_platz_fehler := c.fmid_falsche_gefahrenklasse;
            elsif in_lte.wert_klasse < in_lgr.wert_klasse then
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_wert_k_zu_klein, in_lgr.lgr_platz, in_lte.lte_id);

                v_lgr_platz_fehler := c.fmid_falsche_wertklasse;
            elsif in_lte.gefahren_klasse < in_lgr.gefahren_klasse then
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_g_klasse_zu_klein, in_lgr.lgr_platz, in_lte.lte_id);

                v_lgr_platz_fehler := c.fmid_falsche_gefahrenklasse;
            elsif ( in_lgr.lgr_typ = c.sat1 )
            or ( in_lgr.lgr_typ = c.epl1 )
            or ( in_lgr.lgr_typ = c.bkl1 )
            or ( in_lgr.lgr_typ = c.kanal1 )
            or ( in_lgr.lgr_typ = c.kanal_bkl1 )
            or ( in_lgr.lgr_typ = c.durchl1 )
            or ( in_lgr.lgr_typ = c.reg_fach1 )
            or ( in_lgr.lgr_typ = c.stap_flae1 )
            or ( in_lgr.lgr_typ = c.stap_flae2 )
            or ( in_lgr.lgr_typ = c.sat_epl1 )
            or ( in_lgr.lgr_typ = c.sat_epl2 )
            or ( in_lgr.lgr_typ = c.seg1 )
            or ( in_lgr.lgr_typ = c.seg_duedo1 )
            or ( in_lgr.lgr_typ = c.pp_epl1 ) then
                open c_lvs_ziel_grp;
                fetch c_lvs_ziel_grp into v_lgr_ziel_grp;
                v_found := c_lvs_ziel_grp%found;
                close c_lvs_ziel_grp;

        -- hier wird geprüft ob diese Ware eingelagert werden darf
                v_lagertype_ok := true;
                if
                    ( v_err_text is null )
                    and ( in_lgr.lgr_akt_te + 1 > in_lgr.lgr_max_te )
                    and ( in_lgr.lgr_max_te != 0 )
                    and -- 0 = Unbegrenzt
                     ( in_lgr.lgr_verwendung != c.lgr_typ_lagerp )
                    and ( in_lte.lte_id not like 'LTE_V%' ) -- Virtuelle Palette zum palettieren
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_platz_voll, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_ziel_voll;
                elsif
                    ( v_err_text is null )
                    and ( in_lgr.lgr_verwendung != c.lgr_typ_lagerp )
                    and ( in_lte.lte_id not like 'LTE_V%' ) -- Virtuelle Palette zum palettieren
                    and ( (
                        ( nvl(in_lgr.lgr_akt_te, 0) + nvl(in_lgr.lgr_dispo_einl_te, 0) + 1 > in_lgr.lgr_max_te )
                        and nvl(in_lte.ziel_lgr_platz, in_lgr.lgr_platz || 'x') <> in_lgr.lgr_platz -- Palette hat diese Reservierung ausgeloest
                        and nvl(v_lgr_ziel_grp, in_lgr.lgr_platz_gruppe || 'x') <> in_lgr.lgr_platz_gruppe
                    )
                    or -- -AG- 2016.10.13 BugFix Wenn überdisponiert wurde, dann immer neuen Platz suchen
                     ( ( nvl(in_lgr.lgr_akt_te, 0) + nvl(in_lgr.lgr_dispo_einl_te, 0) > in_lgr.lgr_max_te ) -- Überdisponiert
                     ) )
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_platz_kompl_res, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_ziel_voll;
                elsif
                    ( v_err_text is null )
                    and ( nvl(in_lgr.lgr_akt_kg, 0) + nvl(in_lgr.lgr_dispo_einl_kg, 0) + nvl(v_lte_komm_info.lte_akt_kg, 0) > nvl(in_lgr.lgr_max_kg
                    , 0) )
                    and ( in_lgr.lgr_max_te != 0 )
                    and ( in_lgr.lgr_typ != c.durchl1 )
                    and (  -- -AG- 20190312 BugFix bei der LTE ERR O_TP2_LGR_LTE_Z_SCHWER
                     ( in_lte.ziel_lgr_platz is null )
                    or (
                        in_lte.ziel_lgr_platz <> in_lgr.lgr_platz -- Palette hat diese Reservierung ausgeloest
                        and v_lgr_ziel_grp <> in_lgr.lgr_platz_gruppe
                    ) )
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_z_schwer, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_lte_ist_zu_schwer;
                elsif
                    ( v_err_text is null )
                    and ( nvl(v_lte_komm_info.lte_akt_kg, 0) > nvl(in_lgr.lgr_max_kg, 0) )
                    and ( in_lgr.lgr_max_te != 0 )
                    and ( in_lgr.lgr_typ = c.durchl1 )
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_z_schwer, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_lte_ist_zu_schwer;
                elsif
                    ( v_err_text is null )
                    and ( in_lgr.lgr_frei_hoehe - nvl(in_lgr.lgr_dispo_einl_frei_hoehe, 0) < v_lte_komm_info.lte_vol_hoehe )
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_z_hoch, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_lte_zu_gross;
                elsif
                    ( v_err_text is null )
                    and ( in_lgr.lgr_frei_breite < v_lte_komm_info.lte_vol_breite )
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_z_breit, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_lte_zu_gross;
                elsif
                    ( v_err_text is null )
                    and ( in_lgr.lgr_frei_tiefe < v_lte_komm_info.lte_vol_tiefe )
                then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_z_tief, in_lgr.lgr_platz, in_lte.lte_id);

                    v_lgr_platz_fehler := c.fmid_lte_zu_gross;
                elsif
                    ( v_err_text is null )
                    and ( v_lgr_ort.lgr_ort_max_kg_proz < 100 )
                    and ( in_lgr.lgr_kg_gruppe is not null )
                then
                    open c_lvs_lgr_kg_grp;
                    fetch c_lvs_lgr_kg_grp into
                        v_lgr_max_kg,
                        v_lgr_akt_kg,
                        v_lgr_dispo_einl_kg;
                    v_found := c_lvs_lgr_kg_grp%found;
                    close c_lvs_lgr_kg_grp;
                    if ( nvl(v_lte_komm_info.lte_akt_kg, 0) > ( v_lgr_max_kg - v_lgr_akt_kg - v_lgr_dispo_einl_kg ) * v_lgr_ort.lgr_ort_max_kg_proz / 100
                    ) then
                        v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_z_schwer, in_lgr.lgr_platz, in_lte.lte_id);

                        v_lgr_platz_fehler := c.fmid_lte_ist_zu_schwer;
                    end if;

                end if;

            end if;

            if in_lgr.lgr_typ = c.sat1
            or in_lgr.lgr_typ = c.kanal1
            or in_lgr.lgr_typ = c.sat_epl1
            or in_lgr.lgr_typ = c.sat_epl2 then
                if v_err_text is null then
                    if
                        ( in_lte.lte_name = c.indu )
                        and ( in_lgr.lgr_dim_fifo_nr > in_lgr.hrl_lag_max_pal_i )
                    then
                        v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_typ_falsch, in_lte.lte_id, in_lte.lte_name);

                        v_lgr_platz_fehler := c.fmid_falscher_lte_type;
                    end if;

                    v_lagertype_ok := true;
                end if;

            end if;

            if v_err_text is null then
                if ( v_lagertype_ok = false ) then
                    v_err_text := lc.ec_p2(lc.o_tp2_lgr_typ_fehlt, in_lgr.lgr_typ, in_lgr.lgr_platz);

                    v_lgr_platz_fehler := c.fmid_lgr_type_unbekannt;
                end if;
            end if;

        end if;

        if v_err_text is null then
            v_labor_status := null; -- INIT
            open c_lgr_cfg;
            loop
                exit when v_err_text is not null;
                fetch c_lgr_cfg into v_lgr_cfg;
                exit when c_lgr_cfg%notfound;
                if (
                    v_lgr_cfg.lgr_platz_cfg_param = 'LABOR_EINL'
                    and in_transport_typ = 'E'
                )
                or (
                    v_lgr_cfg.lgr_platz_cfg_param = 'LABOR_UML'
                    and in_transport_typ = 'U'
                ) then
                    open c_lam_labor_status; -- Lesen alle Labor-Staus in der LTE
                    loop
                        fetch c_lam_labor_status into v_labor_status;
                        exit when c_lam_labor_status%notfound;
                        if v_lgr_cfg.lgr_platz_cfg_param_wert not like '%'
                                                                       || v_labor_status
                                                                       || '%' then
                            v_err_text := lc.ec_p3(lc.o_tp3_lgr_cfg_err, in_lte.lte_id, in_lte.lte_name, in_lgr.lgr_platz);

                            v_lgr_platz_fehler := c.fmid_lager_cfg_nio;
                            exit;
                        end if;

                    end loop;

                    close c_lam_labor_status; -- Lesen alle Labor-Staus in der LTE
                end if;

            end loop;

            close c_lgr_cfg;
        end if;

        if v_err_text is null then
            v_labor_status := null; -- INIT
            open c_lgr_ort_cfg;
            loop
                exit when v_err_text is not null;
                fetch c_lgr_ort_cfg into v_lgr_ort_cfg;
                exit when c_lgr_ort_cfg%notfound;
                if (
                    v_lgr_ort_cfg.lgr_ort_cfg_param = 'LABOR_EINL'
                    and in_transport_typ = 'E'
                )
                or (
                    v_lgr_ort_cfg.lgr_ort_cfg_param = 'LABOR_UML'
                    and in_transport_typ = 'U'
                ) then
                    open c_lam_labor_status; -- Lesen alle Labor-Staus in der LTE
                    loop
                        fetch c_lam_labor_status into v_labor_status;
                        exit when c_lam_labor_status%notfound;
                        if v_lgr_ort_cfg.lgr_ort_cfg_param_default not like '%'
                                                                            || v_labor_status
                                                                            || '%' then
                            v_err_text := lc.ec_p3(lc.o_tp3_lgr_cfg_err, in_lte.lte_id, in_lte.lte_name, in_lgr.lgr_platz);

                            v_lgr_platz_fehler := c.fmid_lager_cfg_nio;
                            exit;
                        end if;

                    end loop;

                    close c_lam_labor_status; -- Lesen alle Labor-Staus in der LTE
                end if;

            end loop;

            close c_lgr_ort_cfg;
        end if;

        return ( v_err_text );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
      --rollback;
            if c_lgr_cfg%isopen then
                close c_lgr_cfg;
            end if;
            if c_lam_labor_status%isopen then
                close c_lam_labor_status;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
      --rollback;
            if c_lgr_cfg%isopen then
                close c_lgr_cfg;
            end if;
            if c_lam_labor_status%isopen then
                close c_lam_labor_status;
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

    end; -- LVS_PLATZ_EINL_PRUEFEN

  -------------------------------------------------------------------------
  -- Prüft, ob die Einlagerung auf diesen Platz für diese TE möglich ist
  -- es wird nicht geprüft, ob diese auch strategisch sinnvoll ist.
  -- Exception wenn der Platz nicht geht
  -------------------------------------------------------------------------
    procedure lvs_platz_einl_pruefen (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_fahrzeuge_ids           in varchar2
    ) is
    --------------------------------------------------------------------------

    begin
        lvs_platz_einl_pruefen_r30(in_lte, -- in lvs_lte%ROWTYPE,
         in_basis_lte_name, -- in   lvs_lte_cfg.basis_lte_name%type,
         in_flaechen_stellplatz_erf, -- in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
         in_lgr, -- in lvs_lgr%ROWTYPE,
         '?', --in_transport_typ             in   isi_transport.transp_typ%type,
                                   in_fahrzeuge_ids); -- in varchar2) is
    end;

    procedure lvs_platz_einl_pruefen_r30 (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr                     in lvs_lgr%rowtype,
        in_transport_typ           in isi_transport.transp_typ%type,
        in_fahrzeuge_ids           in varchar2
    ) is
    --------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
    begin
        v_err_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, in_lgr, in_transport_typ,
                                                     in_fahrzeuge_ids);
        if v_err_text is not null then
            v_err_nr := v_lgr_platz_fehler;
            raise v_error;
        end if;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
      --rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
      --rollback;
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
    end; -- LVS_PLATZ_EINL_PRUEFEN

  -------------------------------------------------------------------------
  -- -CMe- 04.02.2021
  -- Wenn die Einlager TE 0 ist immer Gewicht und und Höhe ebenfalls auf 0 setzen CMe 20210204
  -- -CMe- 08.08.2018
  -- Disponierungen werden auf dem übergeben Zielplatz immer zurückgesetz
  -- sollten Zielplatz LTE und der übergebener Zielplatz ungleich sein wird zusätzlich
  -- der Zielplatz der LTE falls er vorhanden ist ebenfalls zurückgesetzt
  -- Bebuch nur die Einlagerung auf dem Platz. Bucht KEINE Veraenderung in der LTE/LHM/LAN
  -------------------------------------------------------------------------
    procedure lvs_platz_einl_buchen (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr              number;
        v_err_text            varchar2(2550);
        v_typ_verarbeitet     boolean;
        v_transport           isi_transport%rowtype;
        v_transport_to_target isi_transport%rowtype;
        v_lgr_dispo_einl      lvs_lgr.lgr_dispo_einl_te%type;
        v_lgr_dispo_einl_kg   lvs_lgr.lgr_dispo_einl_kg%type;
        v_lgr_dispo_einl_h    lvs_lgr.lgr_dispo_einl_frei_hoehe%type;
        v_lgr_frei_hoehe      lvs_lgr.lgr_frei_hoehe%type;
        v_lgr_frei_breite     lvs_lgr.lgr_frei_breite%type;
        v_lgr_frei_tiefe      lvs_lgr.lgr_frei_tiefe%type;
        v_lgr_ausl_res        lvs_lgr.lgr_order_res_te%type;
        v_lgr_te              lvs_lgr.lgr_akt_te%type;
        v_lgr_ort             lvs_lgr_ort%rowtype;
        v_lgr_ziel_lte        lvs_lgr%rowtype;
        v_found               boolean;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.lte_id = in_lte.lte_id
            and t.lgr_platz_ziel = in_lte.ziel_lgr_platz
            and t.status != 'E'; -- -AG- Temp-Status aus Transport fertig zum Prüfen DISPO

    -- CMe 20210204 Prüfung ob transport auf den Platz für die LTE vorhanden ist
    -- Benoetigt fuer den Fall das auf der LTe der Zielplatz nicht mehr gesetzt ist
        cursor c_check_lte_trans is
        select
            *
        from
            isi_transport t
        where
                t.lte_id = in_lte.lte_id
            and t.lgr_platz_ziel = in_lgr.lgr_platz; -- -AG- Temp-Status aus Transport fertig zum Prüfen DISPO
    begin
        v_err_nr := null;
        v_err_text := null;
        v_lgr_dispo_einl := 0;
        v_lgr_dispo_einl_kg := 0;
        v_lgr_dispo_einl_h := 0;
        v_lgr_frei_hoehe := 0;
        v_lgr_frei_tiefe := 0;
        v_typ_verarbeitet := false;
        open c_check_lte_trans;
        fetch c_check_lte_trans into v_transport_to_target;
        v_found := c_check_lte_trans%found;
        close c_check_lte_trans;

    -- CMe 20210204 Prüfung ob transport auf den Platz für die LTE vorhanden ist
    -- Benoetigt fuer den Fall das auf der LTe der Zielplatz nicht mehr gesetzt ist
        if ( in_lte.ziel_lgr_platz = in_lgr.lgr_platz )
        or (
            in_lte.ziel_lgr_platz is null
            and v_found
        ) then
            v_lgr_dispo_einl := nvl(in_lgr.lgr_dispo_einl_te, 1) - 1;
            if v_lgr_dispo_einl < 0 then
                v_lgr_dispo_einl := 0;
            end if;
            if in_lgr.lgr_typ = c.reg_fach1
            or ( in_lgr.lgr_typ = c.stap_flae1 )
            or ( in_lgr.lgr_typ = c.stap_flae2 ) then
                v_lgr_dispo_einl_h := nvl(in_lgr.lgr_dispo_einl_frei_hoehe, in_lte.lte_vol_hoehe) - in_lte.lte_vol_hoehe;
                if v_lgr_dispo_einl_h < 0 then
                    v_lgr_dispo_einl_h := 0;
                end if;
            else
                v_lgr_dispo_einl_h := 0;
            end if;

            v_lgr_dispo_einl_kg := nvl(in_lgr.lgr_dispo_einl_kg, 0) - nvl(in_lte.lte_akt_kg, 0);

            if v_lgr_dispo_einl_kg < 0 then
                v_lgr_dispo_einl_kg := 0;
            end if;
      -- Wenn die Einlager TE 0 ist immer Gewicht und und Höhe ebenfalls auf 0 setzen CMe 20210204
            if v_lgr_dispo_einl = 0 then
                v_lgr_dispo_einl_kg := 0;
                v_lgr_dispo_einl_h := 0;
            end if;
            update lvs_lgr
            set
                lgr_dispo_einl_te = v_lgr_dispo_einl,
                lgr_dispo_einl_frei_hoehe = v_lgr_dispo_einl_h,
                lgr_dispo_einl_kg = v_lgr_dispo_einl_kg
            where
                    sid = in_lgr.sid
                and firma_nr = in_lgr.firma_nr
                and lgr_platz = in_lgr.lgr_platz;

        end if;

        v_lgr_frei_breite := in_lgr.lgr_frei_breite;
        v_lgr_frei_tiefe := in_lgr.lgr_frei_tiefe;
        if in_lgr.lgr_typ = c.reg_fach1
        or in_lgr.lgr_typ = c.stap_flae1
        or in_lgr.lgr_typ = c.stap_flae2 then
            if
                ( in_lgr.lgr_typ = c.stap_flae1 )
                and ( lvs_p_base.get_lgr_ort(in_lgr.sid, in_lgr.firma_nr, in_lgr.lgr_ort, v_lgr_ort) )
            then
                if ( in_lte.lte_vol_breite < in_lgr.lgr_frei_breite - v_lgr_ort.lgr_ort_raster_x ) then
                    v_lgr_frei_breite := round((in_lte.lte_vol_breite + v_lgr_ort.lgr_ort_raster_x - 1) / v_lgr_ort.lgr_ort_raster_x,
                    0) * v_lgr_ort.lgr_ort_raster_x;
                else
                    v_lgr_frei_breite := in_lgr.lgr_frei_breite;
                end if;

                if ( in_lte.lte_vol_tiefe < in_lgr.lgr_frei_tiefe - v_lgr_ort.lgr_ort_raster_y ) then
                    v_lgr_frei_tiefe := round((in_lte.lte_vol_tiefe +(v_lgr_ort.lgr_ort_raster_y / 2) - 1) / v_lgr_ort.lgr_ort_raster_y
                    , 0) * v_lgr_ort.lgr_ort_raster_y;

                else
                    v_lgr_frei_tiefe := in_lgr.lgr_frei_tiefe;
                end if;

            end if;

            v_lgr_frei_hoehe := nvl(in_lgr.lgr_frei_hoehe, in_lgr.lgr_vol_hoehe) - in_lte.lte_vol_hoehe;
            if v_lgr_frei_hoehe < 0 then
                v_lgr_frei_hoehe := 0;
            end if;
        else
            v_lgr_frei_hoehe := nvl(in_lgr.lgr_frei_hoehe, in_lgr.lgr_vol_hoehe);
        end if;

        v_lgr_ausl_res := nvl(in_lgr.lgr_order_res_te, 0);
        if v_lgr_ausl_res < 0 then
            v_lgr_ausl_res := 0;
        end if;
        if in_lte.order_vorgang_id is not null then
            v_lgr_ausl_res := v_lgr_ausl_res + 1;
        end if;
        if in_lgr.lgr_typ = c.sat1
        or in_lgr.lgr_typ = c.sat_epl1
        or in_lgr.lgr_typ = c.sat_epl2
        or in_lgr.lgr_typ = c.epl1
        or in_lgr.lgr_typ = c.kanal1
        or in_lgr.lgr_typ = c.kanal_bkl1
        or in_lgr.lgr_typ = c.durchl1
        or in_lgr.lgr_typ = c.reg_fach1
        or in_lgr.lgr_typ = c.stap_flae1
        or in_lgr.lgr_typ = c.stap_flae2
        or in_lgr.lgr_typ = c.bkl1
        or in_lgr.lgr_typ = c.seg1
        or in_lgr.lgr_typ = c.seg_duedo1
        or in_lgr.lgr_typ = c.pp_epl1 then
      -- hier werden te mengen gebucht
            v_typ_verarbeitet := true;
            update lvs_lgr
            set
                lgr_akt_te = nvl(lgr_akt_te, 0) + 1,
                lgr_frei_hoehe = v_lgr_frei_hoehe,
                lgr_frei_breite = v_lgr_frei_breite,
                lgr_frei_tiefe = v_lgr_frei_tiefe,
                lgr_einl_te_verfueg = nvl(lgr_max_te, 0) - nvl(lgr_akt_te, 0) - 1 - nvl(lgr_dispo_einl_te, 0),
                lgr_akt_kg = nvl(lgr_akt_kg, 0) + nvl(in_lte.lte_akt_kg, 0),
                lgr_order_res_te = nvl(v_lgr_ausl_res, 0)
            where
                    sid = in_lgr.sid
                and firma_nr = in_lgr.firma_nr
                and lgr_platz = in_lgr.lgr_platz;

        end if;

    -- -AG- 2018.01.28 Prüfung ob Transport STATUS != 'E' auf dem Zielplat zder LTE für die LTE
        open c_transport;
        fetch c_transport into v_transport;
        v_found := c_transport%found;
        close c_transport;

    -- CM 20180808 Wenn beide Ungleich sind muss beim Ziel Platz der LTE die DISPO auch zurückgesetzt werden
        if
            ( in_lte.ziel_lgr_platz != in_lgr.lgr_platz )
            and not v_found -- AG- 2018.01.28 Kein TRansport auf den Platz
        then
            if lvs_p_base.get_lgr_platz(in_lte.ziel_lgr_platz, v_lgr_ziel_lte) then
                v_lgr_dispo_einl := nvl(v_lgr_ziel_lte.lgr_dispo_einl_te, 1) - 1;
                if v_lgr_dispo_einl < 0 then
                    v_lgr_dispo_einl := 0;
                end if;
                if v_lgr_ziel_lte.lgr_typ = c.reg_fach1
                or ( v_lgr_ziel_lte.lgr_typ = c.stap_flae1 )
                or ( v_lgr_ziel_lte.lgr_typ = c.stap_flae2 ) then
                    v_lgr_dispo_einl_h := nvl(v_lgr_ziel_lte.lgr_dispo_einl_frei_hoehe, in_lte.lte_vol_hoehe) - in_lte.lte_vol_hoehe;
                    if v_lgr_dispo_einl_h < 0 then
                        v_lgr_dispo_einl_h := 0;
                    end if;
                else
                    v_lgr_dispo_einl_h := 0;
                end if;

                v_lgr_dispo_einl_kg := nvl(v_lgr_ziel_lte.lgr_dispo_einl_kg, 0) - nvl(in_lte.lte_akt_kg, 0);

                if v_lgr_dispo_einl_kg < 0 then
                    v_lgr_dispo_einl_kg := 0;
                end if;
        -- Wenn die Einlager TE 0 ist immer Gewicht und und Höhe ebenfalls auf 0 setzen CMe 20210204
                if v_lgr_dispo_einl = 0 then
                    v_lgr_dispo_einl_kg := 0;
                    v_lgr_dispo_einl_h := 0;
                end if;
                update lvs_lgr
                set
                    lgr_dispo_einl_te = v_lgr_dispo_einl,
                    lgr_dispo_einl_frei_hoehe = v_lgr_dispo_einl_h,
                    lgr_dispo_einl_kg = v_lgr_dispo_einl_kg
                where
                        sid = in_lgr.sid
                    and firma_nr = in_lgr.firma_nr
                    and lgr_platz = in_lte.ziel_lgr_platz;

            end if;
        end if;

        if not v_typ_verarbeitet then
            v_err_nr := c.fmid_lgr_type_unbekannt;
            v_err_text := lc.ec_p2(lc.o_tp2_lgr_typ_fehlt, in_lgr.lgr_typ, in_lgr.lgr_platz);

            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_platz_einl_buchen;

  -------------------------------------------------------------------------
  -- -CMe- 04.02.2021
  -- Wenn die Akt TE 0 ist immer das Gewicht ebenfalls auf 0 zu setzen CMe 20210204
  -- Bebuch nur die Auslagerung auf dem Platz. Bucht KEINE Veraenderung in der LTE/LHM/LAN
  -------------------------------------------------------------------------
    procedure lvs_platz_ausl_buchen (
        in_lte    in lvs_lte%rowtype,
        inout_lgr in out lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr          number;
        v_err_text        varchar2(2550);
        v_lgr_frei_hoehe  lvs_lgr.lgr_frei_hoehe%type;
        v_lgr_frei_breite lvs_lgr.lgr_frei_breite%type;
        v_lgr_frei_tiefe  lvs_lgr.lgr_frei_tiefe%type;
        v_typ_verarbeitet boolean;
        v_lgr_akt_kg      lvs_lgr.lgr_akt_kg%type;
        v_lgr_te          lvs_lgr.lgr_akt_te%type;
        v_lgr_ausl_res    lvs_lgr.lgr_order_res_te%type;
        v_lgr_ort         lvs_lgr_ort%rowtype;
        v_raster_x        number;
        v_raster_y        number;
        cursor c_lgr_lte_size is
        select
            max(nvl(
                nvl(lte1.lte_vol_breite, lte2.lte_vol_breite),
                lgr.lgr_vol_breite
            )),
            max(nvl(
                nvl(lte1.lte_vol_tiefe, lte2.lte_vol_tiefe),
                lgr.lgr_vol_tiefe
            )),
            ort.lgr_ort_raster_x,
            ort.lgr_ort_raster_y
        from
            lvs_lgr     lgr,
            lvs_lgr_ort ort,
            lvs_lte     lte1,
            lvs_lte     lte2
        where
                lgr.lgr_platz = inout_lgr.lgr_platz
            and lgr.lgr_ort = ort.lgr_ort
            and lte1.lte_id (+) != in_lte.lte_id
            and lgr.lgr_platz = lte1.lgr_platz (+)
            and lte2.lte_id (+) != in_lte.lte_id
            and lgr.lgr_platz = lte2.ziel_lgr_platz (+)
        group by
            lgr.lgr_platz,
            ort.lgr_ort,
            ort.lgr_ort_raster_x,
            ort.lgr_ort_raster_y;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_lgr_te := inout_lgr.lgr_akt_te - 1;
        v_lgr_akt_kg := inout_lgr.lgr_akt_kg - in_lte.lte_akt_kg;
        v_lgr_ausl_res := nvl(inout_lgr.lgr_order_res_te, 0);
        if v_lgr_ausl_res < 0 then
            v_lgr_ausl_res := 0;
        end if;
        if
            in_lte.order_vorgang_id is not null
            and v_lgr_ausl_res > 0
        then
            v_lgr_ausl_res := v_lgr_ausl_res - 1;
        else
            v_lgr_ausl_res := 0;
        end if;

        if v_lgr_te < 0 then
            v_lgr_te := 0;
        end if;
        if inout_lgr.lgr_typ = c.reg_fach1
        or inout_lgr.lgr_typ = c.stap_flae1
        or inout_lgr.lgr_typ = c.stap_flae2 then
            v_lgr_frei_hoehe := nvl(inout_lgr.lgr_frei_hoehe, inout_lgr.lgr_vol_hoehe) + in_lte.lte_vol_hoehe;
            if v_lgr_frei_hoehe > inout_lgr.lgr_vol_hoehe then
                v_lgr_frei_hoehe := inout_lgr.lgr_vol_hoehe;
            end if;
        else
            v_lgr_frei_hoehe := nvl(inout_lgr.lgr_frei_hoehe, inout_lgr.lgr_vol_hoehe);
        end if;

        if v_lgr_akt_kg < 0 then
            v_lgr_akt_kg := 0;
        end if;

    --Wenn die Akt TE 0 ist immer das Gewicht ebenfalls auf 0 zu setzen CMe 20210204
        if ( v_lgr_te = 0 ) then
            v_lgr_akt_kg := 0;
        end if;
        v_lgr_frei_breite := inout_lgr.lgr_frei_breite;
        v_lgr_frei_tiefe := inout_lgr.lgr_frei_tiefe;
        if
            ( inout_lgr.lgr_typ = c.stap_flae1 )
            and ( lvs_p_base.get_lgr_ort(inout_lgr.sid, inout_lgr.firma_nr, inout_lgr.lgr_ort, v_lgr_ort) )
        then
            open c_lgr_lte_size;
            fetch c_lgr_lte_size into
                v_lgr_frei_breite,
                v_lgr_frei_tiefe,
                v_raster_x,
                v_raster_y;
            close c_lgr_lte_size;
            v_lgr_frei_breite := round((v_lgr_frei_breite +((v_raster_x - 1) / 2)) / v_raster_x, 0) * v_raster_x;

            v_lgr_frei_tiefe := round((v_lgr_frei_tiefe +((v_raster_y - 1) / 2)) / v_raster_y, 0) * v_raster_y;

        end if;

    -- hier werden te mengen gebucht
        v_typ_verarbeitet := false;
        if ( inout_lgr.lgr_typ = c.sat1 )
        or ( inout_lgr.lgr_typ = c.sat_epl1 )
        or ( inout_lgr.lgr_typ = c.sat_epl2 )
        or ( inout_lgr.lgr_typ = c.kanal1 )
        or ( inout_lgr.lgr_typ = c.kanal_bkl1 )
        or ( inout_lgr.lgr_typ = c.durchl1 )
        or ( inout_lgr.lgr_typ = c.epl1 )
        or ( inout_lgr.lgr_typ = c.bkl1 )
        or ( inout_lgr.lgr_typ = c.seg1 )
        or ( inout_lgr.lgr_typ = c.seg_duedo1 )
        or ( inout_lgr.lgr_typ = c.reg_fach1 )
        or ( inout_lgr.lgr_typ = c.stap_flae1 )
        or ( inout_lgr.lgr_typ = c.stap_flae2 )
        or ( inout_lgr.lgr_typ = c.pp_epl1 ) then
            v_typ_verarbeitet := true;
            update lvs_lgr
            set
                lgr_akt_te = v_lgr_te,
                lgr_frei_hoehe = v_lgr_frei_hoehe,
                lgr_frei_breite = v_lgr_frei_breite,
                lgr_frei_tiefe = v_lgr_frei_tiefe,
                lgr_einl_te_verfueg = nvl(lgr_max_te, 0) - nvl(v_lgr_te, 0) - nvl(lgr_dispo_einl_te, 0),
                lgr_akt_kg = v_lgr_akt_kg,
                lgr_order_res_te = v_lgr_ausl_res
            where
                    sid = inout_lgr.sid
                and firma_nr = inout_lgr.firma_nr
                and lgr_platz = inout_lgr.lgr_platz;

            inout_lgr.lgr_akt_te := v_lgr_te;
            inout_lgr.lgr_frei_hoehe := v_lgr_frei_hoehe;
            inout_lgr.lgr_einl_te_verfueg := nvl(inout_lgr.lgr_max_te, 0) - nvl(v_lgr_te, 0) - nvl(inout_lgr.lgr_dispo_einl_te, 0);

            inout_lgr.lgr_akt_kg := v_lgr_akt_kg;
            inout_lgr.lgr_order_res_te := v_lgr_ausl_res;
        end if;

    -- ende te mengen buchen

    -- wenn kein bekannter lagertyp
        if not v_typ_verarbeitet then
            v_err_nr := c.fmid_lgr_type_unbekannt;
            v_err_text := lc.ec_p2(lc.o_tp2_lgr_typ_fehlt, inout_lgr.lgr_typ, inout_lgr.lgr_platz);

            raise v_error;
        else
      -- Wenn bekannter Lagertyp dann res_string pruefen und Umschaltung INDU EURO
            lvs_lager_opt.lvs_kanal_kontrolle(in_lte, inout_lgr);
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_ausl_buchen;

  -------------------------------------------------------------------------
  -- Setzt die Dispo zurueck (Nur auf dem Platz)
  -- Ruft am ende die Kanalkontrolle zur Korrektur des Reservierungsstrings
  -- in der Lagerplatzgruppe
  -------------------------------------------------------------------------
    procedure lvs_platz_einl_disp_ruecks (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2550);
        v_lte_komm_info     lvs_lte%rowtype;
        v_typ_verarbeitet   boolean;
        v_lgr_dispo_einl_h  lvs_lgr.lgr_dispo_einl_frei_hoehe%type;
        v_lgr_frei_breite   lvs_lgr.lgr_frei_breite%type;
        v_lgr_frei_tiefe    lvs_lgr.lgr_frei_tiefe%type;
        v_lgr_dispo_einl    lvs_lgr.lgr_dispo_einl_te%type;
        v_lgr_dispo_einl_kg lvs_lgr.lgr_dispo_einl_kg%type;
        v_lgr_ort           lvs_lgr_ort%rowtype;
        v_raster_x          number;
        v_raster_y          number;
        cursor c_lgr_lte_size is
        select
            max(nvl(
                nvl(lte1.lte_vol_breite, lte2.lte_vol_breite),
                lgr.lgr_vol_breite
            )),
            max(nvl(
                nvl(lte1.lte_vol_tiefe, lte2.lte_vol_tiefe),
                lgr.lgr_vol_tiefe
            )),
            ort.lgr_ort_raster_x,
            ort.lgr_ort_raster_y
        from
            lvs_lgr     lgr,
            lvs_lgr_ort ort,
            lvs_lte     lte1,
            lvs_lte     lte2
        where
                lgr.lgr_platz = in_lgr.lgr_platz
            and lgr.lgr_ort = ort.lgr_ort
            and lgr.lgr_platz = lte1.lgr_platz (+)
            and lgr.lgr_platz = lte2.ziel_lgr_platz (+)
        group by
            lgr.lgr_platz,
            ort.lgr_ort,
            ort.lgr_ort_raster_x,
            ort.lgr_ort_raster_y;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_typ_verarbeitet := false;
        v_lte_komm_info := in_lte; -- Daten in die Zwischenvariable übernehmen
        lte_nach_komm_pruef(v_lte_komm_info);
        v_lgr_dispo_einl := in_lgr.lgr_dispo_einl_te - 1;
        if v_lgr_dispo_einl < 0 then
            v_lgr_dispo_einl := 0;
        end if;
        if in_lgr.lgr_typ = c.reg_fach1
        or in_lgr.lgr_typ = c.stap_flae1
        or in_lgr.lgr_typ = c.stap_flae2 then
            v_lgr_dispo_einl_h := nvl(in_lgr.lgr_dispo_einl_frei_hoehe, v_lte_komm_info.lte_vol_hoehe) - v_lte_komm_info.lte_vol_hoehe
            ;
            if v_lgr_dispo_einl_h < 0 then
                v_lgr_dispo_einl_h := 0;
            end if;
        else
            v_lgr_dispo_einl_h := 0;
        end if;

        v_lgr_dispo_einl_kg := in_lgr.lgr_dispo_einl_kg - v_lte_komm_info.lte_akt_kg;
        if v_lgr_dispo_einl_kg < 0 then
            v_lgr_dispo_einl_kg := 0;
        end if;
        if v_lgr_dispo_einl = 0 then
            v_lgr_dispo_einl_h := 0;
            v_lgr_dispo_einl_kg := 0;
        end if;
        v_lgr_frei_breite := in_lgr.lgr_frei_breite;
        v_lgr_frei_tiefe := in_lgr.lgr_frei_tiefe;
        if
            ( in_lgr.lgr_typ = c.stap_flae1 )
            and ( lvs_p_base.get_lgr_ort(in_lgr.sid, in_lgr.firma_nr, in_lgr.lgr_ort, v_lgr_ort) )
        then
            open c_lgr_lte_size;
            fetch c_lgr_lte_size into
                v_lgr_frei_breite,
                v_lgr_frei_tiefe,
                v_raster_x,
                v_raster_y;
            close c_lgr_lte_size;
            v_lgr_frei_breite := round((v_lgr_frei_breite +(v_raster_x / 2)) / v_raster_x, 0) * v_raster_x;

            v_lgr_frei_tiefe := round((v_lgr_frei_tiefe +(v_raster_y / 2)) / v_raster_y, 0) * v_raster_y;

        end if;

    -- hier werden te mengen gebucht
        if ( in_lgr.lgr_typ = c.sat1 )
        or ( in_lgr.lgr_typ = c.sat_epl1 )
        or ( in_lgr.lgr_typ = c.sat_epl2 )
        or ( in_lgr.lgr_typ = c.kanal1 )
        or ( in_lgr.lgr_typ = c.kanal_bkl1 )
        or ( in_lgr.lgr_typ = c.durchl1 )
        or ( in_lgr.lgr_typ = c.reg_fach1 )
        or ( in_lgr.lgr_typ = c.stap_flae1 )
        or ( in_lgr.lgr_typ = c.stap_flae2 )
        or ( in_lgr.lgr_typ = c.epl1 )
        or ( in_lgr.lgr_typ = c.bkl1 )
        or ( in_lgr.lgr_typ = c.seg1 )
        or ( in_lgr.lgr_typ = c.seg_duedo1 )
        or ( in_lgr.lgr_typ = c.pp_epl1 ) then
            v_typ_verarbeitet := true;
            update lvs_lgr
            set
                lgr_dispo_einl_te = v_lgr_dispo_einl,
                lgr_dispo_einl_frei_hoehe = v_lgr_dispo_einl_h,
                lgr_frei_breite = v_lgr_frei_breite,
                lgr_frei_tiefe = v_lgr_frei_tiefe,
                lgr_einl_te_verfueg = lgr_max_te - lgr_akt_te - v_lgr_dispo_einl,
                lgr_dispo_einl_kg = v_lgr_dispo_einl_kg
            where
                    sid = in_lgr.sid
                and firma_nr = in_lgr.firma_nr
                and lgr_platz = in_lgr.lgr_platz;

        end if;

    -- ende te mengen buchen

    -- wenn kein bekannter lagertyp
        if not v_typ_verarbeitet then
            v_err_nr := c.fmid_lgr_type_unbekannt;
            v_err_text := lc.ec_p2(lc.o_tp2_lgr_typ_fehlt, in_lgr.lgr_typ, in_lgr.lgr_platz);

            raise v_error;
        else
      -- Wenn bekannter Lagertyp dann res_string pruefen und Umschaltung INDU EURO
            lvs_lager_opt.lvs_kanal_kontrolle(in_lte, in_lgr);
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_einl_disp_ruecks;
  -------------------------------------------------------------------------
  -- Setzt die Dispo (Nur auf dem Platz)
  -- Ruft am ende die Kanalkontrolle zur Korrektur des Reservierungsstrings
  -- in der Lagerplatzgruppe
  -------------------------------------------------------------------------
    procedure lvs_platz_einl_disp_setzen (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------

        v_lte_komm_info   lvs_lte%rowtype;
        v_lgr             lvs_lgr%rowtype;
        v_lgr_frei_breite lvs_lgr.lgr_frei_breite%type;
        v_lgr_frei_tiefe  lvs_lgr.lgr_frei_tiefe%type;
        v_lgr_ort         lvs_lgr_ort%rowtype;
        v_raster_x        number;
        v_raster_y        number;
    begin
        v_lgr := in_lgr;
        v_lte_komm_info := in_lte; -- Daten in die Zwischenvariable übernehmen
        lte_nach_komm_pruef(v_lte_komm_info);
        v_lgr.lgr_dispo_einl_te := in_lgr.lgr_dispo_einl_te + 1;
        if v_lgr.lgr_dispo_einl_te < 0 then
            v_lgr.lgr_dispo_einl_te := 1;
        end if;
        v_lgr.lgr_dispo_einl_kg := in_lgr.lgr_dispo_einl_kg + v_lte_komm_info.lte_akt_kg;
        if v_lgr.lgr_dispo_einl_kg < 0.0 then
            v_lgr.lgr_dispo_einl_kg := v_lte_komm_info.lte_akt_kg;
        end if;

        if in_lgr.lgr_typ = c.reg_fach1
        or in_lgr.lgr_typ = c.stap_flae1
        or in_lgr.lgr_typ = c.stap_flae2 then
            v_lgr.lgr_dispo_einl_frei_hoehe := nvl(in_lgr.lgr_dispo_einl_frei_hoehe, v_lte_komm_info.lte_vol_hoehe) + v_lte_komm_info.lte_vol_hoehe
            ;

            if v_lgr.lgr_dispo_einl_frei_hoehe < 0 then
                v_lgr.lgr_dispo_einl_frei_hoehe := v_lte_komm_info.lte_vol_hoehe;
            end if;

        else
            v_lgr.lgr_dispo_einl_frei_hoehe := 0;
        end if;

        v_lgr_frei_breite := in_lgr.lgr_frei_breite;
        v_lgr_frei_tiefe := in_lgr.lgr_frei_tiefe;
        if
            ( in_lgr.lgr_typ = c.stap_flae1 )
            and ( lvs_p_base.get_lgr_ort(in_lgr.sid, in_lgr.firma_nr, in_lgr.lgr_ort, v_lgr_ort) )
        then
            if ( in_lte.lte_vol_breite < in_lgr.lgr_frei_breite - v_lgr_ort.lgr_ort_raster_x ) then
                v_lgr_frei_breite := round((in_lte.lte_vol_breite + v_lgr_ort.lgr_ort_raster_x - 1) / v_lgr_ort.lgr_ort_raster_x, 0) * v_lgr_ort.lgr_ort_raster_x
                ;
            else
                v_lgr_frei_breite := in_lgr.lgr_frei_breite;
            end if;

            if ( in_lte.lte_vol_tiefe < in_lgr.lgr_frei_tiefe - v_lgr_ort.lgr_ort_raster_y ) then
                v_lgr_frei_tiefe := round((in_lte.lte_vol_tiefe +(v_lgr_ort.lgr_ort_raster_y / 2) - 1) / v_lgr_ort.lgr_ort_raster_y, 0
                ) * v_lgr_ort.lgr_ort_raster_y;

            else
                v_lgr_frei_tiefe := in_lgr.lgr_frei_tiefe;
            end if;

        end if;

        if ( in_lgr.lgr_typ = c.sat1 ) -- fifp läger
        or ( in_lgr.lgr_typ = c.sat_epl1 )
        or ( in_lgr.lgr_typ = c.sat_epl2 )
        or ( in_lgr.lgr_typ = c.kanal1 )
        or ( in_lgr.lgr_typ = c.kanal_bkl1 )
        or ( in_lgr.lgr_typ = c.durchl1 )
        or ( in_lgr.lgr_typ = c.reg_fach1 )
        or ( in_lgr.lgr_typ = c.stap_flae1 )
        or ( in_lgr.lgr_typ = c.stap_flae2 )
        or ( in_lgr.lgr_typ = c.epl1 )
        or ( in_lgr.lgr_typ = c.bkl1 )
        or ( in_lgr.lgr_typ = c.seg1 )
        or ( in_lgr.lgr_typ = c.seg_duedo1 )
        or ( in_lgr.lgr_typ = c.pp_epl1 ) then
      -- hier werden te mengen gebucht
            update lvs_lgr
            set
                lgr_dispo_einl_te = v_lgr.lgr_dispo_einl_te,
                lgr_einl_te_verfueg = nvl(lgr_max_te - lgr_akt_te - v_lgr.lgr_dispo_einl_te, 0),
                lgr_dispo_einl_frei_hoehe = v_lgr.lgr_dispo_einl_frei_hoehe,
                lgr_frei_breite = v_lgr_frei_breite,
                lgr_frei_tiefe = v_lgr_frei_tiefe,
                lgr_dispo_einl_kg = v_lgr.lgr_dispo_einl_kg
            where
                    sid = in_lgr.sid
                and firma_nr = in_lgr.firma_nr
                and lgr_platz = in_lgr.lgr_platz;

        end if; -- if 'SAT'

    -- res_string pruefen und Umschaltung INDU EURO
        lvs_lager_opt.lvs_kanal_kontrolle(in_lte, v_lgr);
    end lvs_platz_einl_disp_setzen;

  -------------------------------------------------------------------------
  -- Setzt die Auslagerdispo zurueck (Nur auf dem Platz)
  -------------------------------------------------------------------------
    procedure lvs_platz_ausl_disp_ruecks (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2550);
        v_found             boolean; -- Dummy Var für gefunden im CURSOR

        v_typ_verarbeitet   boolean;
        v_lgr_dispo_ausl    lvs_lgr.lgr_dispo_ausl_te%type;
        v_lgr_dispo_ausl_kg lvs_lgr.lgr_dispo_ausl_kg%type;
        v_lgr               lvs_lgr%rowtype; -- Lager für Auslagerdispo

        cursor c_lgr is -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = in_lte.lgr_platz
            and lgr.sid = in_lte.sid;

    begin
        v_err_nr := null;
        v_err_text := null;
        if in_lgr.sid is not null then
            v_lgr := in_lgr;
            v_found := true;
        else
            open c_lgr; --
            fetch c_lgr into v_lgr; -- Lesen den Eintrag des Lagerplatz
            v_found := c_lgr%found;
            close c_lgr;
        end if;

        if not v_found then
            v_err_nr := c.fmid_lgr_type_unbekannt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lte.lgr_platz);
            raise v_error;
        end if;

        v_typ_verarbeitet := false;
        v_lgr_dispo_ausl_kg := in_lgr.lgr_dispo_ausl_kg - in_lte.lte_akt_kg;
        if v_lgr_dispo_ausl_kg < 0 then
            v_lgr_dispo_ausl_kg := 0;
        end if;
        v_lgr_dispo_ausl := in_lgr.lgr_dispo_ausl_te - 1;
        if v_lgr_dispo_ausl <= 0 then
            v_lgr_dispo_ausl := 0;
            v_lgr_dispo_ausl_kg := 0;
        end if;

    -- hier werden te mengen gebucht
        update lvs_lgr
        set
            lgr_dispo_ausl_te = v_lgr_dispo_ausl,
            lgr_dispo_ausl_kg = v_lgr_dispo_ausl_kg
        where
                sid = v_lgr.sid
            and firma_nr = v_lgr.firma_nr
            and lgr_platz = v_lgr.lgr_platz;
    -- ende te mengen buchen
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_ausl_disp_ruecks;
  -------------------------------------------------------------------------
  -- Setzt die Auslagerdispo (Nur auf dem Platz)
  -------------------------------------------------------------------------
    procedure lvs_platz_ausl_disp_setzen (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2550);
        v_lgr_dispo_ausl    lvs_lgr.lgr_dispo_ausl_te%type;
        v_lgr_dispo_ausl_kg lvs_lgr.lgr_dispo_ausl_kg%type;
        v_found             boolean; -- Dummy Var für gefunden im CURSOR

        v_lgr               lvs_lgr%rowtype; -- Lager für Auslagerdispo
        cursor c_lgr is -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = in_lte.lgr_platz
            and lgr.sid = in_lte.sid;

    begin
        v_err_nr := null;
        v_err_text := null;
        if in_lgr.sid is not null then
            v_lgr := in_lgr;
            v_found := true;
        else
            open c_lgr; --
            fetch c_lgr into v_lgr; -- Lesen den Eintrag des Lagerplatz
            v_found := c_lgr%found;
            close c_lgr;
        end if;

        if not v_found then
            v_err_nr := c.fmid_lgr_type_unbekannt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lte.lgr_platz);
            raise v_error;
        end if;

        v_lgr_dispo_ausl_kg := in_lgr.lgr_dispo_ausl_kg + in_lte.lte_akt_kg;
        if v_lgr_dispo_ausl_kg < 0 then
            v_lgr_dispo_ausl_kg := 0;
        end if;
        v_lgr_dispo_ausl := in_lgr.lgr_dispo_ausl_te + 1;
        if v_lgr_dispo_ausl < 0 then
            v_lgr_dispo_ausl := 0;
            v_lgr_dispo_ausl_kg := 0;
        end if;
        if ( in_lgr.lgr_typ = c.sat1 ) -- fifp läger
        or ( in_lgr.lgr_typ = c.sat_epl1 )
        or ( in_lgr.lgr_typ = c.sat_epl2 )
        or ( in_lgr.lgr_typ = c.kanal1 )
        or ( in_lgr.lgr_typ = c.kanal_bkl1 )
        or ( in_lgr.lgr_typ = c.durchl1 )
        or ( in_lgr.lgr_typ = c.reg_fach1 )
        or ( in_lgr.lgr_typ = c.stap_flae1 )
        or ( in_lgr.lgr_typ = c.stap_flae2 )
        or ( in_lgr.lgr_typ = c.epl1 )
        or ( in_lgr.lgr_typ = c.bkl1 )
        or ( in_lgr.lgr_typ = c.seg1 )
        or ( in_lgr.lgr_typ = c.seg_duedo1 )
        or ( in_lgr.lgr_typ = c.pp_epl1 ) then
      -- hier werden te mengen gebucht
            update lvs_lgr
            set
                lgr_dispo_ausl_te = v_lgr_dispo_ausl,
                lgr_dispo_ausl_kg = v_lgr_dispo_ausl_kg
            where
                    sid = in_lgr.sid
                and firma_nr = in_lgr.firma_nr
                and lgr_platz = in_lgr.lgr_platz;

        end if; -- if 'SAT'
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_ausl_disp_setzen;

  -------------------------------------------------------------------------
  -- Setzt und Rücksetzten eine statischen Reservierungsstring für eine
  -- Lagerplatzgruppe. Nach dem setzen wird der reservierungsstring der
  -- Lagerplatzgruppe durch die Kanalkontrolle nicht mehr veraendert
  -------------------------------------------------------------------------

    function lvs_platz_statisch_res (
        in_sid              in isi_sid.sid%type,
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type,
        in_res_string       in lvs_lgr.res_string%type,
        in_res_artikel_id   in lvs_lgr.res_artikel_id%type,
        out_lte_name        out varchar2,
        out_lte_namen       out varchar2
    ) return number is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr            number;
        v_err_text          varchar2(2550);
        v_result            number;
        v_lgr_dispo_ausl    lvs_lgr.lgr_dispo_ausl_te%type;
        v_lgr_dispo_ausl_kg lvs_lgr.lgr_dispo_ausl_kg%type;
        v_found             boolean; -- Dummy Var für gefunden im CURSOR

        v_lgr               lvs_lgr%rowtype; -- Lager für Auslagerdispo
        v_art               isi_artikel%rowtype; -- Artikel Daten
        v_lte               lvs_lte%rowtype;
        v_lte_cfg           lvs_lte_cfg%rowtype;
        v_basis_lte_name    lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_art.sid
            and t.lte_name = v_art.lte_name;

        cursor c_lgr is -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lgr.sid = in_sid
        order by
            lgr.lgr_dim_fifo_nr desc;

        cursor c_art is -- Lesen des Artikels
        select
            *
        from
            isi_artikel art
        where
                art.sid = in_sid
            and art.artikel_id = in_res_artikel_id;

        cursor c_lte_lgr is
        select
            *
        from
            lvs_lte lte
        where
            lte.lgr_platz = v_lgr.lgr_platz;

    begin
        v_err_nr := null;
        v_err_text := null;
        out_lte_name := null;
        out_lte_namen := null;
        v_result := 0; -- Alles OK

        if
            in_res_artikel_id is not null -- Beide Felder gesetzt
            and in_res_string is not null
        then
            v_err_nr := 10;
            v_err_text := lc.ec(lc.o_txt_lgr_stat_res_art_err);
            raise v_error;
        end if;

        if
            in_res_artikel_id is null -- Beide Felder NICHT gesetzt
            and in_res_string is null -----
        then
            update lvs_lgr lgr
            set
                lgr.res_artikel_id = null,
                lgr.res_art_statisch = c.c_false,
                lgr.res_res_string_statisch = c.c_false,
                lgr.res_string = (
                    select
                        decode(
                            min(lte.res_string),
                            max(lte.res_string),
                            min(lte.res_string),
                            null
                        )
                    from
                        lvs_lte lte
                    where
                        lte.lgr_platz = lgr.lgr_platz
                    group by
                        lte.lgr_platz
                )
            where
                    lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
                and lgr.sid = in_sid;

        end if;

        if
            in_res_artikel_id is not null -- Artikel_id soll Statisch reserviert werden
            and in_res_string is null ----------
        then
            open c_art;
            fetch c_art into v_art;
            v_found := c_art%found;
            close c_art;
            if not v_found then
                v_err_nr := c.fmid_artikelnummer_fehlt;
                v_err_text := lc.ec_p1(lc.o_tp1_artikel_id_fehlt, in_res_artikel_id);
                raise v_error;
            end if;

            update lvs_lgr lgr
            set
                lgr.res_artikel_id = in_res_artikel_id,
                lgr.res_art_statisch = c.c_true,
                lgr.res_res_string_statisch = c.c_false,
                lgr.res_string = (
                    select
                        decode(
                            min(lte.res_string),
                            max(lte.res_string),
                            min(lte.res_string),
                            null
                        )
                    from
                        lvs_lte lte
                    where
                        lte.lgr_platz = lgr.lgr_platz
                    group by
                        lte.lgr_platz
                )
            where
                    lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
                and lgr.sid = in_sid;

        end if;

        open c_lgr;
        fetch c_lgr into v_lgr;
        if c_lgr%notfound then
            close c_lgr;
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lgr_platz_grp_fehlt,
                                   nvl(in_lgr_platz_gruppe, 'NULL'));

            raise v_error;
        end if;

        if
            in_res_artikel_id is null -- res_string soll Statisch reserviert werden
            and in_res_string is not null ----------
        then
            if
                ( v_lgr.lgr_typ <> c.sat1 )
                and ( v_lgr.lgr_typ <> c.sat_epl1 )
                and ( v_lgr.lgr_typ <> c.sat_epl2 )
                and ( v_lgr.lgr_typ <> c.kanal1 )
                and ( v_lgr.lgr_typ <> c.kanal_bkl1 )
                and ( v_lgr.lgr_typ <> c.durchl1 )
                and ( v_lgr.lgr_typ <> c.reg_fach1 )
                and ( v_lgr.lgr_typ <> c.stap_flae1 )
                and ( v_lgr.lgr_typ <> c.stap_flae2 )
                and ( v_lgr.lgr_typ <> c.seg1 )
                and ( v_lgr.lgr_typ <> c.seg_duedo1 )
            then
        -- Achtung !! CURSOR ist noch offen für Fehler erst schliessen
                close c_lgr;
                v_err_nr := 25;
                v_err_text := lc.ec(lc.o_txt_lgr_typ_stat_res_err);
                raise v_error;
            end if;

            update lvs_lgr lgr
            set
                lgr.res_artikel_id = null,
                lgr.res_art_statisch = c.c_false,
                lgr.res_res_string_statisch = c.c_true,
                lgr.res_string = in_res_string
            where
                    lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
                and lgr.sid = in_sid;

        end if;

        open c_lte_cfg;
        fetch c_lte_cfg into v_lte_cfg;
        close c_lte_cfg;
        v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_art.lte_name);
        if nvl(v_lgr.lte_namen, v_basis_lte_name) not like ( '%'
                                                             || v_basis_lte_name || '%' ) then
            v_result := 30;
            out_lte_name := v_basis_lte_name;
            out_lte_namen := v_lgr.lte_namen;
        end if;

        if nvl(v_lgr.lte_namen_cfg, v_basis_lte_name) not like ( '%'
                                                                 || v_basis_lte_name || '%' ) then
            close c_lgr;
            v_err_nr := c.fmid_falscher_lte_type;
            v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_tpy_art_err, v_lgr.lte_namen_cfg, v_lgr.lte_namen_cfg);

            raise v_error;
        end if;

        while ( c_lgr%found ) loop
            if v_lgr.lgr_akt_te > 0 then
                open c_lte_lgr;
                fetch c_lte_lgr into v_lte;
                close c_lte_lgr;
                lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
            end if;

            fetch c_lgr into v_lgr;
        end loop;

        close c_lgr;
        return ( v_result );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_statisch_res;

  -------------------------------------------------------------------------
  -- Setzt und Rücksetzten eine statischen Reservierungsstring für eine
  -- Lagerplatzgruppe. Nach dem setzen wird der reservierungsstring der
  -- Lagerplatzgruppe durch die Kanalkontrolle nicht mehr veraendert
  -------------------------------------------------------------------------
    procedure lvs_c_platz_statisch_res (
        in_sid              in isi_sid.sid%type,
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type,
        in_res_string       in lvs_lgr.res_string%type,
        in_res_artikel_id   in lvs_lgr.res_artikel_id%type,
        in_kanal_leer       in varchar2
    ) is
    -------------------------------------------------------------------------

        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_lte_name  varchar2(255);
        v_lte_namen varchar2(255);
        v_result    number;
        v_anz_te    number;
        v_anz_dipo  number;
        cursor c_lagergruppe_leer is
        select
            sum(lgr_akt_te),
            sum(lgr_dispo_einl_te)
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz_gruppe = in_lgr_platz_gruppe
        group by
            lgr.lgr_platz_gruppe;

    begin
        v_err_nr := null;
        v_err_text := null;
        if
            in_kanal_leer = c.c_true
            and in_res_string is not null
            and in_res_artikel_id is not null
        then
            open c_lagergruppe_leer;
            fetch c_lagergruppe_leer into
                v_anz_te,
                v_anz_dipo;
            close c_lagergruppe_leer;
            if v_anz_te != 0 then
                v_err_nr := 1;
                v_err_text := lc.ec(lc.o_txt_lgr_m_dispo_o_lte);
                raise v_error;
            end if;

            if v_anz_dipo != 0 then
                v_err_nr := 2;
                v_err_text := lc.ec(lc.o_txt_lgr_m_dispo);
                raise v_error;
            end if;

        end if;

        v_result := lvs_platz_statisch_res(in_sid, in_lgr_platz_gruppe, in_res_string, in_res_artikel_id, v_lte_name,
                                           v_lte_namen);
        commit;
        if v_result = 30 then
            v_err_nr := c.fmid_falscher_lte_type;
            v_err_text := lc.ec_p2(lc.o_tp2_lgr_lte_tpy_art_err, v_lte_namen, v_lte_name);
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_platz_statisch_res;

  -------------------------------------------------------------------------
  -- Zum Verbuchen der Lagerplatzkorrektur
  -- Bucht auf dem Lagerplatz der LTE, LHM und LAM
  -------------------------------------------------------------------------
    procedure lvs_c_korr_te_disp_ruecksetzen (
        in_te_sid               in lvs_lte.sid%type,
        in_te_firma_nr          in lvs_lte.firma_nr%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_lte_dispo_lagerplatz in lvs_lte.lgr_platz%type,
        in_ls_login_id          in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------
    -- rücksetzen einer Zielplatz Disponierung
    -- Standard Fehler Felder
        v_error exception;
        v_err_nr                 number;
        v_err_text               varchar2(2550);
        v_lgr_sid                lvs_lgr.sid%type;
        v_lgr                    lvs_lgr%rowtype; -- Lagerplatz auf den die lte soll
        v_lte                    lvs_lte%rowtype; -- Lagerplatz auf den die lte soll

        v_ziel_lgr_ort_n_freif   lvs_lte.ziel_lgr_ort_n_freif%type;
        v_ziel_lgr_platz_n_freif lvs_lte.ziel_lgr_platz_n_freif%type;
        v_ziel_lgr_ort           lvs_lte.ziel_lgr_ort%type;
        v_ziel_lgr_platz         lvs_lte.ziel_lgr_platz%type;
        v_found                  boolean; -- Gefunden (CURSOR)
        v_ist_lagerplatz         lvs_lgr.lgr_platz%type;
        v_soll_lagerplatz        lvs_lgr.lgr_platz%type;
        v_ist_lagerort           lvs_lgr.lgr_ort%type;
        v_neuer_status           lvs_lte.lte_status%type; -- neuer status der LTE
        cursor c_lvs_lte is -- Lesen des Lagerhilfsmittel
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

        cursor c_lvs_lgr is -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = in_lte_dispo_lagerplatz;

    begin
        v_err_nr := null;
        v_err_text := null;

    -- lagerplatz aus lvs_lgr lesen
        open c_lvs_lgr;
        fetch c_lvs_lgr into v_lgr;
        v_found := c_lvs_lgr%found;
        close c_lvs_lgr;
        if not v_found then
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lte_dispo_lagerplatz);
            raise v_error;
        end if;

    -- LTE Einlesen
        open c_lvs_lte;
        fetch c_lvs_lte into v_lte;
        v_found := c_lvs_lte%found;
        close c_lvs_lte;
        if not v_found then
            if v_lgr.lgr_dispo_einl_te = 1 then
                update lvs_lgr l
                set
                    l.lgr_dispo_einl_te = 0,
                    l.lgr_dispo_einl_kg = 0,
                    l.lgr_einl_te_verfueg = l.lgr_einl_te_verfueg + 1,
                    l.lgr_einl_te_verfueg_gruppe = l.lgr_einl_te_verfueg_gruppe + 1,
                    l.lgr_dispo_einl_frei_hoehe = 0
                where
                    l.lgr_platz = in_lte_dispo_lagerplatz;

                lvs_lager_opt.lvs_kanal_kontrolle(null, v_lgr);
            else
                v_err_nr := c.fmid_lte_id_fehlt;
                v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
                raise v_error;
            end if;
        end if;

        if
            v_lte.ziel_lgr_ort_n_freif is not null
            and in_lte_dispo_lagerplatz = v_lte.ziel_lgr_platz_n_freif
        then
            v_ziel_lgr_ort_n_freif := v_lte.ziel_lgr_ort_n_freif;
            v_ziel_lgr_platz_n_freif := v_lte.ziel_lgr_platz_n_freif;
            v_ziel_lgr_ort := null;
            v_ziel_lgr_platz := null;
            v_lte.ziel_lgr_ort_n_freif := null;
            v_lte.ziel_lgr_platz_n_freif := null;
            v_lte.ziel_lgr_ort := v_ziel_lgr_ort_n_freif;
            v_lte.ziel_lgr_platz := v_ziel_lgr_platz_n_freif;
        elsif
            v_lte.ziel_lgr_ort_n_freif is not null
            and in_lte_dispo_lagerplatz = v_lte.ziel_lgr_platz
        then
            v_ziel_lgr_ort := v_lte.ziel_lgr_ort;
            v_ziel_lgr_platz := v_lte.ziel_lgr_platz;
            v_ziel_lgr_ort_n_freif := v_lte.ziel_lgr_ort_n_freif;
            v_ziel_lgr_platz_n_freif := v_lte.ziel_lgr_platz_n_freif;
        else
            v_ziel_lgr_ort := null;
            v_ziel_lgr_platz := null;
            v_ziel_lgr_ort_n_freif := null;
            v_ziel_lgr_platz_n_freif := null;
        end if;

    -- Wenn dispo auf einlagerung lagerplatz wieder um LTE Menge ,Gewicht .. Entlasten
        lvs_platz_einl_disp_ruecks(v_lte, v_lgr);
        lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
        v_err_nr := null;
        v_err_text := null;

    -- die transporteinheiten und ihre mengen bekommen nun die aktuellen ist und soll positionen!
        if v_lte.lgr_platz is null then
            v_neuer_status := c.lte_kf_stat; -- Korrektur Lager
        else
            v_neuer_status := c.lte_lf_stat;
        end if;

        if v_ziel_lgr_ort_n_freif is not null then
            if in_lte_dispo_lagerplatz = v_ziel_lgr_platz_n_freif then
                v_lte.ziel_lgr_ort := v_ziel_lgr_ort;
                v_lte.ziel_lgr_platz := v_ziel_lgr_platz;
                v_lte.ziel_lgr_ort_n_freif := null;
                v_lte.ziel_lgr_platz_n_freif := null;
            else
                v_lte.ziel_lgr_ort_n_freif := null;
                v_lte.ziel_lgr_platz_n_freif := null;
                v_lte.ziel_lgr_ort := v_ziel_lgr_ort_n_freif;
                v_lte.ziel_lgr_platz := v_ziel_lgr_platz_n_freif;
            end if;
        end if;

        lvs_p_lte.lvs_te_lagerziel_umbuchen_353(in_te_sid,
                                                in_te_firma_nr,
                                                in_lte_id,
                                                v_lte.lgr_platz,
                                                v_lte.lgr_ort,
                                                v_lte.lgr_platz_gruppe,
                                                v_lte.ziel_lgr_platz,
                                                v_lte.ziel_lgr_ort,
                                                v_neuer_status,
                                                in_lte_status,
                                                v_lte.ziel_lgr_platz,
                                                v_lte.ziel_lgr_ort,
                                                v_lte.lte_letzte_buchung,
                                                v_lte.order_auf_id,
                                                v_lte.order_vorgang_id,
                                                null,
                                                null,
                                                null,
                                                v_lte.lte_offset_x,
                                                v_lte.lte_offset_y,
                                                lvs_platz.lvs_get_lgr_offset_z(v_lte.lgr_platz) + v_lte.lte_vol_hoehe);

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_korr_te_disp_ruecksetzen;

  -------------------------------------------------------------------------
  -- Holt den Status eines lagerplatz und gibt die Lagerplatzgruppe und den
  -- Status zurück.
  -------------------------------------------------------------------------
    procedure lvs_get_lgr_sperr_status (
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        out_lgr_gruppe   out lvs_lgr.lgr_platz_gruppe%type,
        out_sperr_status out lvs_lgr.gesperrt%type,
        out_beschreibung out lvs_lgr.gesp_grund%type
    )
  -------------------------------------------------------------------------
     as

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_found    boolean;
        cursor c_get_lagerplatz_status is
        select
            gesperrt,
            gesp_grund,
            lgr_platz_gruppe
        from
            lvs_lgr
        where
            lgr_platz = in_lgr_platz;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_get_lagerplatz_status;
        fetch c_get_lagerplatz_status into
            out_sperr_status,
            out_beschreibung,
            out_lgr_gruppe;
        v_found := c_get_lagerplatz_status%found;
        close c_get_lagerplatz_status;
        if not v_found then
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lgr_platz);
            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_get_lgr_sperr_status;

  -------------------------------------------------------------------------
  -- Setzt den status je nach Lagerplatztyp für den Platz, die Gruppe oder
  -- eien Teil der Gruppe
  -------------------------------------------------------------------------
    procedure lvs_c_set_lgr_sperr_status (
        in_sperr_status in char,
        in_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_beschreibung in lvs_lgr.gesp_grund%type
    )
  -------------------------------------------------------------------------
     is

        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_lgr       lvs_lgr%rowtype;
        v_lgr_grp   lvs_lgr%rowtype;
        v_transport isi_transport%rowtype;
        v_txt       varchar2(100);
        v_found     boolean;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.lgr_platz_ziel = v_lgr_grp.lgr_platz
            and t.modul_bearbeiter = c.lgr_modul_sls;

        cursor c_lgr_grp is
        select
            l.*
        from
            lvs_lgr l
        where
                l.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
            and ( ( l.lgr_dim_g = v_lgr.lgr_dim_g
                    and l.lgr_dim_r = v_lgr.lgr_dim_r
                    and l.lgr_dim_p = v_lgr.lgr_dim_p
                    and l.lgr_dim_e = v_lgr.lgr_dim_e )
                  or ( l.lgr_typ != c.seg1
                       and l.lgr_typ != c.seg_duedo1 ) );

    begin
        v_ignor_einl_suche_uml := 1;
        v_err_nr := null;
        v_err_text := null;
        if lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr) then
      -- Manuelle Lagerplatz nur setzen wenn Lagerplatz leer.
            if
                ( v_lgr.lgr_akt_te <> 0 )
                and ( v_lgr.lgr_dispo_einl_te <> 0 )
                and ( in_sperr_status = 'M' )
            then
                v_err_nr := c.fmid_lager_platz_fehlt;
                v_err_text := lc.ec_p1(lc.o_tp2_lgr_platz_voll, in_lgr_platz);
                raise v_error;
            end if;

            update lvs_lgr l
            set
                l.gesperrt = in_sperr_status,
                l.gesp_grund = in_beschreibung
            where
                    l.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
                and ( ( l.lgr_dim_g = v_lgr.lgr_dim_g
                        and l.lgr_dim_r = v_lgr.lgr_dim_r
                        and l.lgr_dim_p = v_lgr.lgr_dim_p
                        and l.lgr_dim_e = v_lgr.lgr_dim_e )
                      or ( l.lgr_typ != c.seg1
                           and l.lgr_typ != c.seg_duedo1 ) );

            if in_sperr_status = c.lgr_gesperrt_g then
                open c_lgr_grp;
                loop
                    fetch c_lgr_grp into v_lgr_grp;
                    exit when c_lgr_grp%notfound;

          -- Gibt es noch einen Transporte
                    open c_transport;
                    fetch c_transport into v_transport;
                    v_found := c_transport%found;
                    close c_transport;
                    if v_found then
                        v_txt := lvs_p_lte.lvs_suche_neuen_platz_v349(v_transport, -- in_transport        in isi_transport%rowtype,
                         v_transport.user_id, -- in_user_id         in isi_user.login_id%type,
                         0); -- in_prorgamm_nr     in isi_transport.quelle_leer_progr_nr%type
                    end if;

                end loop;

                close c_lgr_grp;
            end if;

        else
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lgr_platz);
            raise v_error;
        end if;

        v_ignor_einl_suche_uml := 0;
        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
            if c_lgr_grp%isopen then
                close c_lgr_grp;
            end if;
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_lgr_grp%isopen then
                close c_lgr_grp;
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

    end lvs_c_set_lgr_sperr_status;

  -------------------------------------------------------------------------
  -- Setzt den res_string auf VOLL? je nach Lagerplatztyp für den Platz, die
  -- Gruppe oder eien Teil der Gruppe
  -------------------------------------------------------------------------
    procedure lvs_c_set_lgr_voll_res_string (
        in_lgr_platz in lvs_lgr.lgr_platz%type
    )
  -------------------------------------------------------------------------
     is

        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(2550);
        v_lgr        lvs_lgr%rowtype;
        v_lgr_grp    lvs_lgr%rowtype;
        v_transport  isi_transport%rowtype;
        v_txt        varchar2(100);
        v_grp_belegt number;
        v_found      boolean;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.lgr_platz_ziel = v_lgr_grp.lgr_platz
            and t.modul_bearbeiter = c.lgr_modul_sls;

        cursor c_lgr_grp is
        select
            l.*
        from
            lvs_lgr l
        where
                l.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
            and ( ( l.lgr_dim_g = v_lgr.lgr_dim_g
                    and l.lgr_dim_r = v_lgr.lgr_dim_r
                    and l.lgr_dim_p = v_lgr.lgr_dim_p
                    and l.lgr_dim_e = v_lgr.lgr_dim_e )
                  or ( l.lgr_typ != c.seg1
                       and l.lgr_typ != c.seg_duedo1 ) );

        cursor c_lgr_grp_kompl is
        select
            count(*)
        from
            lvs_lgr l
        where
                l.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
            and ( ( l.lgr_dim_g = v_lgr.lgr_dim_g
                    and l.lgr_dim_r = v_lgr.lgr_dim_r
                    and l.lgr_dim_p = v_lgr.lgr_dim_p
                    and l.lgr_dim_e = v_lgr.lgr_dim_e )
                  or ( l.lgr_typ != c.seg1
                       and l.lgr_typ != c.seg_duedo1 ) )
            and l.lgr_akt_te = 1;

    begin
        v_ignor_einl_suche_uml := 1;
        v_err_nr := null;
        v_err_text := null;
        if lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr) then
            open c_lgr_grp_kompl;
            fetch c_lgr_grp_kompl into v_grp_belegt;
            close c_lgr_grp_kompl;
            if nvl(v_grp_belegt, 0) < 1 then
                lvs_c_set_lgr_sperr_status(c.lgr_gesperrt_g,
                                           v_lgr.lgr_platz,
                                           'TOTAL X ' || to_char(sysdate, 'yyyy.mm.dd'));
            else
                update lvs_lgr l
                set
                    l.res_string = 'VOLL?'
                where
                        l.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
                    and ( ( l.lgr_dim_g = v_lgr.lgr_dim_g
                            and l.lgr_dim_r = v_lgr.lgr_dim_r
                            and l.lgr_dim_p = v_lgr.lgr_dim_p
                            and l.lgr_dim_e = v_lgr.lgr_dim_e )
                          or ( l.lgr_typ != c.seg1
                               and l.lgr_typ != c.seg_duedo1 ) )
                    and l.lgr_akt_te = 0;

                open c_lgr_grp;
                loop
                    fetch c_lgr_grp into v_lgr_grp;
                    exit when c_lgr_grp%notfound;

          -- Gibt es noch einen Transporte
                    open c_transport;
                    fetch c_transport into v_transport;
                    v_found := c_transport%found;
                    close c_transport;
                    if v_found then
                        v_txt := lvs_p_lte.lvs_suche_neuen_platz_v349(v_transport, -- in_transport        in isi_transport%rowtype,
                         v_transport.user_id, -- in_user_id         in isi_user.login_id%type,
                         0); -- in_prorgamm_nr     in isi_transport.quelle_leer_progr_nr%type
                    end if;

                end loop;

                close c_lgr_grp;
            end if;

        else
            v_ignor_einl_suche_uml := 0;
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lgr_platz);
            raise v_error;
        end if;

        v_ignor_einl_suche_uml := 0;
        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
            if c_lgr_grp%isopen then
                close c_lgr_grp;
            end if;
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            if c_lgr_grp%isopen then
                close c_lgr_grp;
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

    end lvs_c_set_lgr_voll_res_string;

  -------------------------------------------------------------------------
  -- Hier findet die Bewertung eines Lagepltz für eien Einlagrung statt.
  -- Fuer die Berechnung fliessen
  -- Hat eien Lagerplatzgruppe bereits den gleichen Reservierungsstring
  --     - Max Gewicht des Platz - Palettengewicht
  --     - Max Hoehe, Breite, Tiefe mit der Platellengroesse
  --     - Wo wurde die letzte gleiche Palette eingelagert
  --             und sollen folgende in der Naehe
  --             oder verteilt eingelagert werden
  --     - ABC Aufteilung
  --  Alle Parameter werden nach Kundenspezifischen Vorgaben bewertet
  --
  -------------------------------------------------------------------------
    function lvs_platz_bewerten (
        in_sid                 in lvs_lgr.sid%type,
        in_firma_nr            in lvs_lgr.firma_nr%type,
        in_lgr_ort_typ         in lvs_lgr.lgr_typ%type,
        in_res_string          in lvs_lte.res_string%type,
        in_lte_res_art         in lvs_lte.res_artikel_id%type,
        in_lte_abc             in lvs_lte.abc%type,
        in_lte_waren_typ       in lvs_lte.waren_typ%type,
        in_lgr_platz_gruppe    in lvs_lgr.lgr_platz_gruppe%type,
        in_lgr_res_artikel_id  in lvs_lgr.res_artikel_id%type,
        in_lgr_res_string      in lvs_lgr.res_string%type,
        in_lgr_abc             in lvs_lgr.abc%type,
        in_ref_dim_lager_platz in lvs_lgr.lgr_dim_platz%type,
        in_ref_dim_lager_ort   in lvs_lgr.lgr_ort%type,
        in_lte_lte_akt_kg      in lvs_lte.lte_akt_kg%type,
        in_lte_lte_vol_hoehe   in lvs_lte.lte_vol_hoehe%type,
        in_lte_lte_vol_tiefe   in lvs_lte.lte_vol_tiefe%type,
        in_lte_lte_vol_breite  in lvs_lte.lte_vol_breite%type,
        in_lgr_platz           in lvs_lgr.lgr_platz%type,
        in_lgr_opti            in lvs_lgr_ort.lgr_einl_opti%type,
        in_sych_transport      in isi_transport.lgr_platz_quelle%type,
        in_fahrzeuge_ids       in varchar2,
        in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
        in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
        in_lgr_dim_g           in lvs_lgr.lgr_dim_g%type,
        in_lgr_dim_r           in lvs_lgr.lgr_dim_r%type,
        in_lgr_dim_p           in lvs_lgr.lgr_dim_p%type,
        in_lgr_dim_e           in lvs_lgr.lgr_dim_e%type,
        in_lgr_dim_t           in lvs_lgr.lgr_dim_t%type,
        in_r_g_u_gegenueber    in lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type,
        in_dim_platz           in lvs_lgr.lgr_dim_platz%type,
        in_max_kg              in lvs_lgr.lgr_max_kg%type,
        in_akt_kg              in lvs_lgr.lgr_akt_kg%type,
        in_frei_hoehe          in lvs_lgr.lgr_frei_hoehe%type,
        in_frei_breite         in lvs_lgr.lgr_frei_breite%type,
        in_frei_tiefe          in lvs_lgr.lgr_frei_tiefe%type
    ) return number is
    -------------------------------------------------------------------------
        v_error exception;
        v_err_nr                     number;
        v_err_text                   varchar2(2550);
        v_ref_dim_lager_platz        lvs_lgr.lgr_dim_platz%type;
        v_found                      boolean;
        v_fuellgrad                  number;
        v_fuellgrad_seg              number;
        v_multiplikator              number;
        v_dispo_faktor_seg           number;
        v_lgr_regal_ebene_faktor_seg number;
        v_lgr_dim_platz_seg          lvs_lgr.lgr_dim_platz%type;
    --v_lgr_dim_ort_seg                 lvs_lgr.lgr_ort%type;
        v_max_kg_seg                 lvs_lgr.lgr_max_kg%type;
        v_akt_kg_seg                 lvs_lgr.lgr_akt_kg%type;
        v_frei_hoehe_seg             lvs_lgr.lgr_frei_hoehe%type;
        v_frei_breite_seg            lvs_lgr.lgr_frei_breite%type;
        v_frei_tiefe_seg             lvs_lgr.lgr_frei_tiefe%type;
        v_fuellgrad_seg_akt          number;
        v_sonst_faktor               number;
        v_dispo_faktor               number;
        v_lgr_platz_gegenueber       lvs_lgr.lgr_platz_gruppe_gegenueber%type;
        v_lgr_gruppe                 lvs_lgr.gruppe%type;
        v_lgr_dim_platz              lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_platz_calc         lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_tiefe              lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_p                  lvs_lgr.lgr_dim_p%type;
        v_lgr_dim_t                  lvs_lgr.lgr_dim_platz%type;
    --v_lgr_dim_ort              lvs_lgr.lgr_ort%type;
        v_max_kg                     lvs_lgr.lgr_max_kg%type;
        v_akt_kg                     lvs_lgr.lgr_akt_kg%type;
        v_max_te                     lvs_lgr.lgr_max_te%type;
        v_akt_te                     lvs_lgr.lgr_akt_te%type;
        v_diff                       number;
        v_frei_hoehe                 lvs_lgr.lgr_frei_hoehe%type;
        v_frei_breite                lvs_lgr.lgr_frei_breite%type;
        v_frei_tiefe                 lvs_lgr.lgr_frei_tiefe%type;
        v_lgr_dim_fifo               lvs_lgr.lgr_dim_fifo_nr%type;
        v_lgr_einl_te_v              lvs_lgr.lgr_einl_te_verfueg%type;
        v_lgr_ausl_te_d              lvs_lgr.lgr_einl_te_verfueg%type;
        v_r_g_u_gegenueber           lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type;
        v_lvs_platz_bew_use_dispo    varchar2(1);
        cursor c_lgr_kanal is
        select
            ( ( sum(lgr2.lgr_dispo_ausl_te * v_ort.strat_platz_ausl_dispo /* C.LGR_PLATZ_AUSL_DISPO */) + 1 ) + sum(nvl(lgr2.lgr_order_res_te
            , 0) * v_ort.strat_order_reservierung /*C.LGR_ORDER_RESERVIERUNG*/) ) * ( decode(
                nvl(in_lgr_res_string, ''),
                     -- Jetzt sind die werte im Lagerort
                in_res_string,
                min(v_ort.strat_platz_res_string), -- C.LGR_PLATZ_RES_STRING,
                decode(in_lgr_res_string,
                       null,
                       min(v_ort.strat_platz_leer), -- C.LGR_PLATZ_LEER,
                       decode(in_lgr_res_string,
                              c.lgr_m_k,
                              min(v_ort.strat_platz_misch_kanal), -- C.LGR_PLATZ_MISCH_KANAL,
                              decode(in_lgr_res_string,
                                     c.lgr_m_p,
                                     min(v_ort.strat_platz_falsch), -- C.LGR_PLATZ_MISCH_PAL,
                                     min(v_ort.strat_platz_falsch) -- c.LGR_PLATZ_FALSCH
                                     )))
            ) ) as ausl_dispo_faktor,
            decode(in_lte_waren_typ,
                   c.fertigware,
                   min(v_ort.strat_regal_hoehe_fw), -- C.LGR_HOEHE_FW_WERT,
                   decode(in_lte_waren_typ,
                          c.rohware,
                          min(v_ort.strat_regal_hoehe_rw), -- C.LGR_HOEHE_RW_WERT,
                          decode(in_lte_waren_typ,
                                 c.halbware,
                                 min(v_ort.strat_regal_hoehe_hw), -- C.LGR_HOEHE_HW_WERT,
                                 decode(in_lte_waren_typ,
                                        c.mischpal,
                                        min(v_ort.strat_regal_hoehe_mp), -- C.LGR_HOEHE_MP_WERT,
                                        0)))) * min(lgr2.lgr_dim_e),
            min(lgr2.lgr_dim_platz),
            sum(lgr2.lgr_max_te),
            sum(lgr2.lgr_akt_te),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe),
            max(lgr2.lgr_einl_te_verfueg_gruppe)
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and ( ( lgr2.lgr_dim_g = in_lgr_dim_g
                    and lgr2.lgr_dim_r = in_lgr_dim_r
                    and lgr2.lgr_dim_p = in_lgr_dim_p
                    and lgr2.lgr_dim_e = in_lgr_dim_e )
                  or ( lgr2.lgr_typ != c.seg1
                       and lgr2.lgr_typ != c.seg_duedo1 ) )
        group by
            lgr2.lgr_platz_gruppe,
            lgr2.abc;

        cursor c_lgr_kanal_block is
        select
            max(lte.lte_letzte_buchung),
            min(lgr2.lgr_dim_platz),
            min(lgr2.lgr_dim_p),
            min(lgr2.lgr_dim_t),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe)
        from
            lvs_lte lte,
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lte.res_artikel_id (+) = to_char(in_lte_res_art)
            and lte.lgr_platz (+) = lgr2.lgr_platz
        group by
            lte.lgr_platz_gruppe,
            lgr2.lgr_ort; --,
    --lgr2.lgr_dim_platz,
    --lgr2.lgr_max_kg, lgr2.lgr_akt_kg,
    --lgr2.lgr_frei_hoehe, lgr2.lgr_, lgr2.lgr_frei_tiefe;
        cursor c_lgr_block is
        select
            count(lte.lte_id) + count(lte2.lte_id)      as ausl_dispo_faktor,
            ( decode((power((count(lte.lte_id) + count(lte2.lte_id)) * min(v_ort.strat_lgr_platz_akt_lte) /* C.LGR_PLATZ_AKT_LTE */,
                            2)),
                     0,
                     decode(
                              sum(lgr2.lgr_max_te),
                              sum(lgr2.lgr_einl_te_verfueg),
                              1,
                              0.001
                          ),
                     (power((count(lte.lte_id) + count(lte2.lte_id)) * min(v_ort.strat_lgr_platz_akt_lte) /* C.LGR_PLATZ_AKT_LTE */,
                            2))) * ( sum(lgr2.lgr_einl_te_verfueg) * min(v_ort.strat_lgr_platz_verfueg) /* C.LGR_PLATZ_VERFUEG */ + 1
                            ) ) / ( ( sum(lgr2.lgr_dispo_ausl_te) * min(v_ort.strat_platz_ausl_dispo) /* C.LGR_PLATZ_AUSL_DISPO */ + 1
                            + nvl(
                sum(lgr2.lgr_order_res_te),
                0
            ) * min(v_ort.strat_order_reservierung) /*C.LGR_ORDER_RESERVIERUNG*/ ) ) as ausl_dispo_bestand,
            nvl(
                max(lte2.lte_letzte_buchung),
                max(lte.lte_letzte_buchung)
            )                                           l_buchung,
            min(lgr2.lgr_dim_platz),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe)
        from
            lvs_lgr lgr2,
            lvs_lte lte,
            lvs_lte lte2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lte.sid (+) = in_sid
            and lte.firma_nr (+) = in_firma_nr
            and lte.lgr_platz_gruppe (+) = lgr2.lgr_platz_gruppe
            and lte.res_artikel_id (+) = in_lte_res_art
            and lte2.sid (+) = in_sid
            and lte2.firma_nr (+) = in_firma_nr
            and lte2.ziel_lgr_platz (+) = lgr2.lgr_platz
            and lte2.res_artikel_id (+) = in_lte_res_art
        group by
            lgr2.lgr_ort,
            lgr2.lgr_platz_gruppe,
                -- -AG- --lgr2.lgr_dim_platz,
            lte.lgr_platz_gruppe,
            lte2.lgr_platz_gruppe;

        cursor c_lgr_epl is
        select
            lgr2.lgr_dim_platz,
            lgr2.lgr_max_kg,
            lgr2.lgr_akt_kg,
            lgr2.lgr_frei_hoehe,
            lgr2.lgr_frei_breite,
            lgr2.lgr_frei_tiefe
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe;

        cursor c_lgr_sat_epl_platz is
        select
            lgr.lgr_dim_platz,
            lgr.lgr_dim_p,
            lgr.lgr_max_kg,
            lgr.lgr_akt_kg,
            lgr.lgr_frei_hoehe,
            lgr.lgr_frei_breite,
            lgr.lgr_frei_tiefe,
            lgr.lgr_dim_fifo_nr,
            lgr.gruppe,
            lgr.lgr_platz_gruppe_gegenueber,
            decode(in_lte_waren_typ,
                   c.fertigware,
                   v_ort.strat_regal_hoehe_fw, -- C.LGR_HOEHE_FW_WERT,
                   decode(in_lte_waren_typ,
                          c.rohware,
                          v_ort.strat_regal_hoehe_rw, -- C.LGR_HOEHE_RW_WERT,
                          decode(in_lte_waren_typ,
                                 c.halbware,
                                 v_ort.strat_regal_hoehe_hw, -- C.LGR_HOEHE_HW_WERT,
                                 decode(in_lte_waren_typ, c.mischpal, v_ort.strat_regal_hoehe_mp, -- C.LGR_HOEHE_MP_WERT,
                                  0)))) * lgr.lgr_dim_e,
            lgr.lgr_einl_te_verfueg_gruppe
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.firma_nr = in_firma_nr
            and lgr.lgr_platz = in_lgr_platz;

        cursor c_lgr_sat_epl_gegenueber is
        select
            lgr2.lgr_einl_te_verfueg,
            lgr2.lgr_dispo_ausl_te
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz = v_lgr_platz_gegenueber;

        cursor c_lgr_sat_epl_gruppe is
        select
            sum(lgr2.lgr_einl_te_verfueg),
            sum(lgr2.lgr_dispo_ausl_te)
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.gruppe = v_lgr_gruppe
            and lgr2.lgr_dispo_ausl_te > 0
        group by
            lgr2.gruppe;

    begin
    -- CMe 20220317 (P71141-94): Prüfen in der CFG ob die Disponioerung eines Platzes berücksichtigt wird
        v_lvs_platz_bew_use_dispo := isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'LVS_EINL_PLATZ_SUCHE', 'LVS', 'LVS_PLATZ_BEWERTEN_USE_DISPO'
        ,
                                                                  'LVS', 'CFG', 'F', 'BOOLEAN');

        v_ref_dim_lager_platz := in_ref_dim_lager_platz;
        v_r_g_u_gegenueber := in_r_g_u_gegenueber;
        if v_r_g_u_gegenueber = c.c_true then
            v_ref_dim_lager_platz := v_ref_dim_lager_platz / 1000000000000;
            if mod(
                abs(v_ref_dim_lager_platz),
                2
            ) = 1 -- Regal Ungrade4 auf grade setzen für Abstand
             then
                v_ref_dim_lager_platz := in_ref_dim_lager_platz + 1000000000000;
            else
                v_ref_dim_lager_platz := in_ref_dim_lager_platz;
            end if;

        else
            v_r_g_u_gegenueber := c.c_false;
        end if;

        v_dat_lgr_l_buchung := null;
        v_dat_lgr_bestand_ausl_faktor := null;
        v_lgr_abstand_faktor := 0;
        v_sonst_faktor := 0;
        v_fuellgrad_seg := 1000;

    -- Erst mal die Daten lesen

        if in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.kanal1
        or in_lgr_ort_typ = c.durchl1
      -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
        or in_lgr_ort_typ = c.seg1 -- Segmetlager müssen wie Kanäle betrachtet werden
        or in_lgr_ort_typ = c.seg_duedo1 -- die jedoch eine Gruppe über mehrere Kanaele haben
         then
            open c_lgr_kanal;
            fetch c_lgr_kanal into
                v_dispo_faktor,
                v_dat_lgr_regal_ebene_faktor,
                v_lgr_dim_platz,
                v_max_te,
                v_akt_te,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe,
                v_fuellgrad_seg_akt;

            v_found := c_lgr_kanal%found;
            close c_lgr_kanal;

      -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
            if in_lgr_ort_typ = c.seg1 -- Segmetlager müssen wie Kanäle betrachtet werden
            or in_lgr_ort_typ = c.seg_duedo1 -- die jedoch eine Gruppe über mehrere Kanaele haben
             then
                v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
        --v_dispo_faktor := v_dispo_faktor / 100;
        --v_dispo_faktor := v_dispo_faktor / v_fuellgrad_seg;
            end if;

        elsif in_lgr_ort_typ = c.kanal_bkl1
        or in_lgr_ort_typ = c.reg_fach1
        or in_lgr_ort_typ = c.stap_flae1
        or in_lgr_ort_typ = c.stap_flae2 then
            open c_lgr_kanal_block;
            fetch c_lgr_kanal_block into
                v_dat_lgr_l_buchung,
                v_lgr_dim_platz,
                v_lgr_dim_p,
                v_lgr_dim_t,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe;

            v_found := c_lgr_kanal_block%found;
            close c_lgr_kanal_block;
            if
                v_found
                and v_dat_lgr_l_buchung is not null
            then
                v_dispo_faktor := v_ort.strat_platz_res_string; -- C.LGR_PLATZ_RES_STRING;
            else
                v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
            end if;

            v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
        elsif in_lgr_ort_typ = c.pp_epl1 then
            v_lgr_dim_platz := in_dim_platz;
            v_max_kg := in_max_kg;
            v_akt_kg := in_akt_kg;
            v_frei_hoehe := in_frei_hoehe;
            v_frei_breite := in_frei_breite;
            v_frei_tiefe := in_frei_tiefe;
            v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
      --ToDo Hier den Platz richtig bewerten
            v_found := true;
        elsif in_lgr_ort_typ = c.epl1 then
      -- Bei Einzelplatz kann es nur Leere Plätze geben !!!
            v_lgr_dim_platz := in_dim_platz;
            v_max_kg := in_max_kg;
            v_akt_kg := in_akt_kg;
            v_frei_hoehe := in_frei_hoehe;
            v_frei_breite := in_frei_breite;
            v_frei_tiefe := in_frei_tiefe;
            v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
            v_found := true;
        elsif in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2
    -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
    -- or in_lgr_ort_typ = c.SEG1         -- Segmetlager müssen wie Kanäle betrachtet werden
    -- or in_lgr_ort_typ = c.SEG_DUEDO1   -- die jedoch eine Gruppe über mehrere Kanaele haben
         then
      -- Bei Sateliten Einzelplaetzen ist immer Gut, wen der gegenüberliegende Platz frei ist
            open c_lgr_sat_epl_platz;
            fetch c_lgr_sat_epl_platz into
                v_lgr_dim_platz,
                v_lgr_dim_p,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe,
                v_lgr_dim_fifo,
                v_lgr_gruppe,
                v_lgr_platz_gegenueber,
                v_dat_lgr_regal_ebene_faktor,
                v_fuellgrad_seg_akt;

            v_found := c_lgr_sat_epl_platz%found;
            close c_lgr_sat_epl_platz;
            if in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2 then
                if v_found then
                    open c_lgr_sat_epl_gegenueber;
                    fetch c_lgr_sat_epl_gegenueber into
                        v_lgr_einl_te_v,
                        v_lgr_ausl_te_d;
                    v_found := c_lgr_sat_epl_gegenueber%found;
                    close c_lgr_sat_epl_gegenueber;
                    if in_lgr_ort_typ = c.sat_epl1 then
                        if mod(v_lgr_dim_p, 2) != mod(v_lgr_dim_fifo, 2)
                        or v_lgr_einl_te_v = 0 then
                            v_lgr_einl_te_v := null;
                        end if;
                    else
                        if v_lgr_einl_te_v = 0 then
                            v_lgr_einl_te_v := null;
                        end if;
                    end if;

                else
                    v_lgr_einl_te_v := null;
                end if;

                if v_lgr_einl_te_v is null then
                    v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;  -- Einfach nur eine leerer Platz
                else
                    v_dispo_faktor := ( v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ + v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */
                    ) / 2; -- Dann ist das ein besonder guter Platz
                end if;

                if in_lgr_ort_typ = c.sat_epl2 -- Segment der Einzelplätze füllen Komremieren

                 then
                    open c_lgr_kanal;
                    fetch c_lgr_kanal into
                        v_dispo_faktor_seg,
                        v_lgr_regal_ebene_faktor_seg,
                        v_lgr_dim_platz_seg, --v_lgr_dim_ort_seg,
                        v_max_te,
                        v_akt_te,
                        v_max_kg_seg,
                        v_akt_kg_seg,
                        v_frei_hoehe_seg,
                        v_frei_breite_seg,
                        v_frei_tiefe_seg,
                        v_fuellgrad_seg_akt;

                    v_found := c_lgr_kanal%found;
                    close c_lgr_kanal;
                    v_fuellgrad_seg := ( v_akt_te + 1 ) / v_max_te * 1000;
                end if;

                if in_lgr_opti = c.c_true then
                    if v_lgr_ausl_te_d = 1 then
                        v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ / 100; -- Besser geht nicht (Wechselspiel)
                    else
                        if v_lgr_einl_te_v is not null then
                            open c_lgr_sat_epl_gruppe;
                            fetch c_lgr_sat_epl_gruppe into
                                v_lgr_einl_te_v,
                                v_lgr_ausl_te_d;
                            v_found := c_lgr_sat_epl_gruppe%found;
                            close c_lgr_sat_epl_gruppe;
                            if v_found then
                                v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ / 10; -- Besser geht nicht (Wechselspiel)
                            end if;
                        end if;
                    end if;
                end if;

                if in_sych_transport = v_lgr_platz_gegenueber then
                    v_dispo_faktor := v_dispo_faktor / 100;
                    v_dispo_faktor := v_dispo_faktor / v_fuellgrad_seg;
                end if;

            else
                if in_res_string = in_lgr_res_string then
                    v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */;
                else
                    if in_lgr_res_string is null then
                        v_dispo_faktor := v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */;
                    else
                        v_dispo_faktor := v_ort.strat_platz_falsch /* c.LGR_PLATZ_FALSCH*/;
                    end if;
                end if;

                v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
            end if;

        else
            open c_lgr_block;
            fetch c_lgr_block into
                v_dispo_faktor,
                v_dat_lgr_bestand_ausl_faktor,
                v_dat_lgr_l_buchung,
                v_lgr_dim_platz,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe;

            v_found := c_lgr_block%found;
            close c_lgr_block;
      --if v_dispo_faktor > 0 then
      --  v_dispo_faktor := C.LGR_PLATZ_RES_STRING;
      --else
      --  v_dispo_faktor := C.LGR_PLATZ_LEER;
      --end if;
            if
                v_found
                and v_dat_lgr_l_buchung is not null
            then
                v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */;
            else
                v_dispo_faktor := v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */;
            end if;

        end if;

        v_faktor_belegung_akt := v_dispo_faktor;
    -- Gewicht und Platz berücksichtigen
        if v_ort.strat_gewicht_relevanz /* c.LGR_GEWICHT_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
        -- Differenz bilden + 1 damit 0 (Nuetral wirkt multiplikation)
                v_diff := nvl(nvl(v_max_kg,
                                  nvl(in_lte_lte_akt_kg, 0)) - nvl(v_akt_kg, 0) - nvl(in_lte_lte_akt_kg, 0),
                              0) + 1;
        -- wenn das Gewicht < 1 dann ist die LTE sowiso zu schwer
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := ( ( v_diff ) * v_ort.strat_gewicht_relevanz /* c.LGR_GEWICHT_RELEVANZ */ );
        end if;
    -- Hoehe
        if v_ort.strat_hoehe_relevanz /* c.LGR_HOEHE_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
                v_diff := nvl(v_frei_hoehe - in_lte_lte_vol_hoehe, 0) + 1;
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_hoehe_relevanz /* c.LGR_HOEHE_RELEVANZ */ );
        end if;
    -- Breite
        if v_ort.strat_breite_relevanz /* c.LGR_BREITE_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
                v_diff := nvl(v_frei_breite - in_lte_lte_vol_breite, 0) + 1;
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_breite_relevanz /* c.LGR_BREITE_RELEVANZ */ );
        end if;
    -- Breite
        if v_ort.strat_tiefe_relevanz /* c.LGR_TIEFE_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
                v_diff := nvl(v_frei_tiefe - in_lte_lte_vol_tiefe, 0) + 1;
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_tiefe_relevanz /* c.LGR_TIEFE_RELEVANZ */ );
        end if;

        if v_lgr_abstand_faktor = 0 then
            v_lgr_abstand_faktor := 1;
        end if;
        if v_sonst_faktor = 0 then
            v_sonst_faktor := 1;
        end if;
        if v_found then
      -- jetzt ABC
            v_sonst_faktor := v_sonst_faktor * ( abs(in_lgr_abc * v_ort.strat_abc - in_lte_abc * v_ort.strat_abc) + 1 );
      -- jetzt Artikelres
            if in_lte_res_art = to_char(in_lgr_res_artikel_id) then
                v_dispo_faktor := v_dispo_faktor / v_ort.strat_art_res;
            elsif
                in_lte_res_art != to_char(in_lgr_res_artikel_id)
                and in_lgr_res_artikel_id is not null
            then
                v_dispo_faktor := v_dispo_faktor * v_ort.strat_art_res /* C.LGR_ART_RES */;
            end if;

            if v_ort.strat_ort_abstand_faktor /* c.LGR_ORT_ABSTAND_FAKTOR */ < 0 then
                v_lgr_abstand_faktor := v_lgr_abstand_faktor * abs((nvl(
                    abs(v_ort.lgr_ort - in_ref_dim_lager_ort),
                    0
                )) * v_ort.strat_ort_abstand_faktor /* c.LGR_ORT_ABSTAND_FAKTOR */ + 1);
            end if;

            if v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ <= 0 -- Gleiche Ware möglichtst zusammenstellen
            or v_dispo_faktor = v_ort.strat_platz_res_string -- oder Kanal, Platz hat gleichen Reservirungsstring
            or in_lgr_gruppe_id is null -- oder es gibt keine Guppierung im Lager
             then
                if
                    v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ > 0
                    and v_dispo_faktor = v_ort.strat_platz_res_string -- Gleichverteilung und Kanal, Platz hat gleichen Reservirungsstring
                then
          -- dann in jedem Fall zusammenfahren
                    v_multiplikator := -1;
                else
          -- sonst mach was im Parameter steht
                    v_multiplikator := v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */;
                end if;

                v_lgr_dim_platz_calc := v_lgr_dim_platz / 1000000000000;
                if
                    mod(
                        abs(v_lgr_dim_platz_calc),
                        2
                    ) = 1
                    and v_r_g_u_gegenueber = c.c_true
                then
                    v_lgr_dim_platz := v_lgr_dim_platz + 1000000000000;
                end if;

                if in_lgr_ort_typ = c.stap_flae1
                or in_lgr_ort_typ = c.stap_flae2 then
                    if abs(v_lgr_dim_p - in_lgr_dim_p) > abs(v_lgr_dim_t - in_lgr_dim_t) then
                        v_ref_dim_lager_platz := abs(v_lgr_dim_p - in_lgr_dim_p);
                    else
                        v_ref_dim_lager_platz := abs(v_lgr_dim_t - in_lgr_dim_t);
                    end if;

                    v_lgr_abstand_faktor := v_lgr_abstand_faktor * ( abs(v_ref_dim_lager_platz * v_multiplikator) + 1 );
                else
                    v_lgr_abstand_faktor := v_lgr_abstand_faktor * ( abs(nvl(
                        abs(v_lgr_dim_platz - v_ref_dim_lager_platz),
                        0
                    ) * v_multiplikator) + 1 ) / 100000000; -- Tiefe und Platz Rausnehmen;
                end if;

                v_lgr_abstand_faktor := v_lgr_abstand_faktor + v_sonst_faktor;
            else
                if
                    v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ > 0
                    and v_ort.strat_fuellgrad_relevanz /* c.LGR_FUELLGRAD_RELEVANZ */ > 0
                then
                    if lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab.exists(in_lgr_gruppe_id) then
                        v_fuellgrad := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab(in_lgr_gruppe_id);
                    else
                        v_fuellgrad := lvs_p_lgr_grp_fahrzeuge.lgr_grp_fuellgrad(in_sid, -- in_sid                 in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr            in isi_firma.firma_nr%type,
                         v_ort.lgr_ort, -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                         in_lgr_gruppe_id, -- in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
                         in_ref_dim_lager_ort, -- in_ref_lgr_ort         in lvs_lgr_ort.lgr_ort%type,
                                                                                 in_ref_lgr_gruppe_id, -- in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
                                                                                  in_res_string -- in_res_string          in    lvs_lte.res_string%type
                                                                                 );

                        lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab(in_lgr_gruppe_id) := v_fuellgrad;
                    end if;
          -- BugFix AG 20.09.2010
          -- v_lgr_abstand_faktor := v_lgr_abstand_faktor - v_sonst_faktor;
                    v_lgr_abstand_faktor := v_lgr_abstand_faktor + v_sonst_faktor;
                    v_lgr_abstand_faktor := v_lgr_abstand_faktor + v_fuellgrad * v_ort.strat_fuellgrad_relevanz /* c.LGR_FUELLGRAD_RELEVANZ */
                    ;
                end if;

                v_last_lgr_ort := v_ort.lgr_ort;
            end if;

        end if;

        return ( v_dispo_faktor );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_bewerten;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  --   der beste Platz wird über die Bewertung gefunden, anschliessend
  --   wird geprüft, ob der Platz OK ist, und er mit den mitgegebenen
  --   Fahrzeugen der Platz erreichbar ist.
  -------------------------------------------------------------------------
    procedure lvs_suche_einl_platz (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lgr_orte                in varchar2,
        in_fahrzeuge_ids           in varchar2,
        out_lgr_platz              out lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------
    -- bei einem auto platz ist kein platz der gruppe belegt oder für einlagerung
    -- reserviert !!!
        v_error exception;
        v_err_nr                number;
        v_err_text              varchar2(2550);
        v_lgr_text              varchar2(255);
        v_found                 boolean;
        v_found_lgr             boolean;
        v_weiter_lgr            boolean;
        v_lgr_orte              varchar2(255);
        v_lgr_ort_count         number;
        v_lgr_elem              number;
        v_packschema_lfdn       number;
        v_lgr_ort_nr            lvs_lgr.lgr_ort%type;
        v_lgr                   lvs_lgr%rowtype;
        v_lgr_platz             lvs_lgr.lgr_platz%type;
        v_lte_id                lvs_lte.lte_id%type;
        v_lam                   lvs_lam%rowtype;
        v_charge                lvs_charge%rowtype;
        v_lgr_platz_grp         lvs_lgr.lgr_platz_gruppe%type;
        v_lgr_dim_fifo_nr       lvs_lgr.lgr_dim_fifo_nr%type;
        v_ausl_dispo_faktor     number;
        v_ausl_dispo_bestand    number;
        v_abstand_faktor        number;
        v_abstand_faktor_akt    number;
        v_fuellgrad_seg_akt     number;
        v_dat                   date;
        v_faktor_akt            number;
        v_firma                 isi_firma%rowtype;
        v_lgr_platz_akt         lvs_lgr.lgr_platz%type;
        v_lgr_dim_platz_ref     lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_ort_ref       lvs_lgr.lgr_ort%type;
        v_ausl_dispo_faktor_akt number;
        v_ref_lgr_gruppe_id     lvs_lgr.lgr_gruppe_id%type;
        v_fahrzeuge_rest        number;
        v_ausl_dispo_lte_grp    number;
        v_ausl_res_lte_grp      number;
        v_lgr_verwendung_epl1   lvs_lgr.lgr_verwendung%type;
        v_einl_extern           varchar2(1);

    -- Letzter Lagerplatz fuer diesen Artikel in diesem Lagerort
        cursor c_ref_lgr_platz_fix is /*+ first_rows(1) */
        select
            lgr.lgr_dim_platz,
            lgr.lgr_ort
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = v_lvs_lgr_ref_platz;

    -- Letzter Lagerplatz fuer diesen Artikel in diesem Lagerort
        cursor c_ref_lgr_platz is /*+ first_rows(1) */
        select
            lgr.lgr_dim_platz,
            lgr.lgr_ort
        from
            lvs_lte lte,
            lvs_lgr lgr
        where
                lte.sid = in_lte.sid
            and lte.firma_nr = in_lte.firma_nr
            and lte.res_artikel_id = in_lte.res_artikel_id
            --and lte.lgr_platz_gruppe != in_lte.lgr_platz_gruppe
            and lte.lgr_platz = lgr.lgr_platz
            and ( lgr.lgr_verwendung = c.lgr_typ_lager
                  or lgr.lgr_verwendung = c.lgr_typ_lagerp )
            and in_lgr_orte like ( '%'
                                   || to_char(lgr.lgr_ort) || ';%' )
        order by
            lte.lte_letzte_buchung desc;

        cursor c_ref_lgr_platz_bh is
        select
            lgr.lgr_dim_platz,
            lgr.lgr_ort /*+ first_rows(1) */ /*+ INDEX(bh.artikel_id lvs_lam_bh) */
        from
            lvs_lam_bh bh,
            lvs_lgr    lgr
        where
                bh.sid = in_lte.sid
            and bh.firma_nr = in_lte.firma_nr
            and to_char(bh.artikel_id) = in_lte.res_artikel_id
            --and lte.lgr_platz_gruppe != in_lte.lgr_platz_gruppe
            and lgr.lgr_platz = bh.lgr_platz
            and ( lgr.lgr_verwendung = c.lgr_typ_lager
                  or lgr.lgr_verwendung = c.lgr_typ_lagerp )
            and in_lgr_orte like ( '%'
                                   || to_char(lgr.lgr_ort) || ';%' )
        order by
            bh.buch_datum desc;

    -- fuer Kanaele und Sat-Lager
    -- -AG- BugFix Regal / Platz / Ebene für SEG-Lager zur Findung wichtig
        cursor c_lgr_kanal is
        select /*+ first_rows(25) */
            min(lgr.lgr_dim_fifo_nr),
            lvs_platz_bewerten(v_ort.sid,
                               v_ort.firma_nr,
                               v_ort.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               v_lgr_dim_platz_ref,
                               v_lgr_dim_ort_ref,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               max(lgr.lgr_platz),
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               max(lgr.lgr_gruppe_id),
                               v_ref_lgr_gruppe_id,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               min(lgr.lgr_dim_t),
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               min(lgr.lgr_dim_platz),
                               max(lgr.lgr_max_kg),
                               min(lgr.lgr_akt_kg),
                               max(lgr.lgr_frei_hoehe),
                               max(lgr.lgr_frei_breite),
                               max(lgr.lgr_frei_tiefe))   as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor()  as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor,
            lvs_lager_opt.lvs_platz_faktor_belegung_akt() as faktor_belegung_akt,
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ             = v_ort.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        group by
            lgr.lgr_platz_gruppe,
            lgr.res_string,
            lgr.res_artikel_id,
            lgr.abc,
            lgr.lgr_res_strat,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            regal_ebene_faktor asc,
            lgr.lgr_dim_p * v_ort.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc;

    -- fuer Kanal - Block - Lager
        cursor c_lgr_kanal_block is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(v_ort.sid,
                               v_ort.firma_nr,
                               v_ort.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               v_lgr_dim_platz_ref,
                               v_lgr_dim_ort_ref,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               lgr.lgr_gruppe_id,
                               v_ref_lgr_gruppe_id,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe) as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ             = v_ort.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_p * v_ort.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer Kanal - Durchlauflager
        cursor c_lgr_durchl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(v_ort.sid,
                               v_ort.firma_nr,
                               v_ort.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               v_lgr_dim_platz_ref,
                               v_lgr_dim_ort_ref,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_true,
                               null,
                               in_fahrzeuge_ids,
                               lgr.lgr_gruppe_id,
                               v_ref_lgr_gruppe_id,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe) as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_p * v_ort.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer Einzelplatz - Lager
        cursor c_lgr_epl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(v_ort.sid,
                               v_ort.firma_nr,
                               v_ort.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               v_lgr_dim_platz_ref,
                               v_lgr_dim_ort_ref,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               lgr.lgr_gruppe_id,
                               v_ref_lgr_gruppe_id,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe) as ausl_dispo_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ             = v_ort.lgr_typ
            and ( lgr.lgr_verwendung = c.lgr_typ_lager
                  or lgr.lgr_verwendung = v_lgr_verwendung_epl1 )
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            lgr.lgr_dim_p * v_ort.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc;

    -- fuer Einzelplatz - Palettierung
        cursor c_lgr_pp_epl is
        select /*+ first_rows(25) */
            nvl(lte.ziel_lgr_platz, lte.lgr_platz),
            lte.lte_id
        from
            lvs_lte             lte,
            lvs_packschema_kopf pk,
            lvs_lgr             lgr
        where
                lte.res_string = in_lte.res_string
            and ( lte.lte_status = c.r_lte_bs_stat
                  or lte.lte_status = c.r_lte_bf_stat -- -AG- 2013.07.17 Wenn die Palette auf dem Palettierplatz bereitgestellt wurde, dann hat sie den Status 'BF'
                  or ( lte.lte_status = c.r_lte_lf_stat
                       and lgr.lgr_verwendung = c.r_lgr_typ_lager )
             -- -AG- 2012.01.08 Wegen der Prozesse bei ESSEX Bad Arolsen auch Paletten
             --      berücksichtigen die Eingelagert werder oder werden sollen
                  or lte.lte_status = c.r_lte_ud_stat -- -AG- Auch finden, wenn diese eingelagert werden soll
                  or ( lte.lte_status = c.r_lte_ut_stat -- -AG- und wenn diese eingelagert werden soll auch verwenden
                       and lgr.lgr_verwendung = c.r_lgr_typ_lager -- ween das Zeil ein Lagerplatz ist
                        )
                  or lte.lte_status = c.r_lte_ed_stat -- -AG- Auch finden, wenn diese eingelagert werden soll
                  or ( lte.lte_status = c.r_lte_et_stat -- -AG- und wenn diese eingelagert werden soll auch verwenden
                       and lgr.lgr_verwendung = c.r_lgr_typ_lager -- ween das Zeil ein Lagerplatz ist
                        ) )
            and lte.lte_id not like 'LTE_VL%' -- -AG- 2012.01.08 Niemals eine virtuelle LTE (LAM wird palletiert) nehmen
            and lte.packschema_kopf_id = in_lte.packschema_kopf_id -- -AG- Nur zusammenpacken wenn das Packschema gleich ist (Sonst Anlgendefekt möglich)
            and nvl(lte.ziel_lgr_platz, lte.lgr_platz) is not null -- -BW- manchmal bleibt eine Lte mit Status B ohne Lagerplatz hängen

            and lte.sid = pk.sid
            and lte.firma_nr = pk.firma_nr
            and lte.packschema_kopf_id = pk.packschema_kopf_id
            and lte.lte_akt_lhm < lvs_komm.get_packschema_max_lfdn(lte.sid, lte.firma_nr, lte.packschema_kopf_id) * pk.anz_lagen - (
                select
                    count(tr.transp_id)
                from
                    isi_transport tr,
                    lvs_lam       l
                where
                        l.lte_id = tr.lte_id
                    and l.res_ziel_lte_id = lte.lte_id
            )
            and nvl(lte.ziel_lgr_platz, lte.lgr_platz) = lgr.lgr_platz
            and lgr.lgr_ort = v_ort.lgr_ort
            and lgr.gesperrt = c.r_lgr_gesperrt_f
        order by
            decode(lgr.lgr_typ, c.lgr_typ_lagerp, 0, 1),
            lte.lte_akt_lhm desc;

    -- fuer Sateliten Einzelplatz - Lager
        cursor c_lgr_sat_epl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(v_ort.sid,
                               v_ort.firma_nr,
                               v_ort.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               v_lgr_dim_platz_ref,
                               v_lgr_dim_ort_ref,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               lgr.lgr_gruppe_id,
                               v_ref_lgr_gruppe_id,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe)        as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor()  as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor,
            lgr.lgr_einl_te_verfueg_gruppe                as fuellgrad_seg,
            lvs_lager_opt.lvs_platz_faktor_belegung_akt() as faktor_belegung_akt
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ             = v_ort.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            regal_ebene_faktor asc,
            fuellgrad_seg asc,
            lgr.lgr_dim_p * v_ort.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer sonstige z.B. Blocklager
        cursor c_lgr_block is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
       -- Ermitteln eines idealen Lagerplatz
            lvs_platz_bewerten(v_ort.sid,
                               v_ort.firma_nr,
                               v_ort.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               v_lgr_dim_platz_ref,
                               v_lgr_dim_ort_ref,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               lgr.lgr_gruppe_id,
                               v_ref_lgr_gruppe_id,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe)        as ausl_dispo_faktor,
       -- Ermitteln eines idealen Lagerplatz
            lvs_lager_opt.lvs_platz_bestand_ausl_faktor() as ausl_dispo_bestand,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ             = v_ort.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        order by
            ausl_dispo_faktor asc,
            ausl_dispo_bestand desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr asc;

        cursor c_ort is -- Lesen des Lagerort
        select /*+ first_rows(1) */
            *
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_lte.sid
            and ort.firma_nr = in_lte.firma_nr
            and ort.lgr_ort = v_lgr_ort_nr;

        cursor c_lgr is -- Lesen des Lagerplatz
        select /*+ first_rows(1) */
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = v_lgr_platz_akt
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.sid = in_lte.sid;

        cursor c_lgr_in_grp is -- Lesen des Lagerplatz
        select /*+ first_rows(1) */
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz_gruppe = v_lgr_platz_grp
            and lgr.lgr_dim_fifo_nr = v_lgr_dim_fifo_nr
            and lgr.lgr_dim_g = v_lgr.lgr_dim_g
            and lgr.lgr_dim_r = v_lgr.lgr_dim_r
            and lgr.lgr_dim_e = v_lgr.lgr_dim_e
            and lgr.lgr_dim_p = v_lgr.lgr_dim_p
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.sid = in_lte.sid;

        cursor c_lgr_grp is -- Lesen des Lagerplatz
        select /*+ first_rows(1) */
            sum(lgr.lgr_dispo_ausl_te),
            sum(decode(lte.order_vorgang_id, null, 0, 1))
        from
            lvs_lgr lgr,
            lvs_lte lte
        where
                lgr.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
            and lgr.lgr_dim_g = v_lgr.lgr_dim_g
            and lgr.lgr_dim_r = v_lgr.lgr_dim_r
            and lgr.lgr_dim_e = v_lgr.lgr_dim_e
            and lgr.lgr_dim_p = v_lgr.lgr_dim_p
            and lgr.lgr_platz = lte.lgr_platz
        group by
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e;

        cursor c_firma is
        select
            *
        from
            isi_firma t
        where
                t.sid = in_lte.sid
            and t.firma_nr = in_lte.firma_nr;

        cursor c_transporte is
        select
            l.lgr_gruppe_id,
            l.lgr_ort
        from
            isi_transport t,
            lvs_lgr       l
        where
                t.lgr_platz_ziel = l.lgr_platz
            and l.res_string = in_lte.res_string
        order by
            t.transp_id desc;

    -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
        cursor c_lvs_fahrzeuge is
        select
            sum(decode(
                nvl(t.max_trans_lte, 0),
                0,
                nvl(t.akt_trans_lte, 0) + 1,
                nvl(t.max_trans_lte, 0)
            ) - nvl(t.akt_trans_lte, 0)) rest
        from
            lvs_fahrzeuge        t,
            lvs_lgr_grp_fahrzeug g
        where
                decode(
                    nvl(t.max_trans_lte, 0),
                    0,
                    nvl(t.akt_trans_lte, 0) + 1,
                    nvl(t.max_trans_lte, 0)
                ) > nvl(t.akt_trans_lte, 0)
            and in_fahrzeuge_ids like '%'
                                      || to_char(t.res_id)
                                      || ';%'
            and t.fahrzeug_ok != 'M'
            and t.res_id = g.res_id
            and ( ( ';'
                    || in_lgr_orte
                    || ';' like '%;'
                                || g.lgr_ort
                                || ';%' )
                  or exists (
                select
                    ue.lgr_ort_quelle
                from
                    lvs_lgr_ort_ue_platz ue
                where
                        in_lte.lgr_ort = ue.lgr_ort_quelle
                    and ue.lgr_platz is not null
                    and ( ue.lte_name = in_lte.lte_name
                          or ( in_lte.lte_name is null
                               and ue.lte_name is null )
                          or ue.lte_name is null )
                    and ';'
                        || in_lgr_orte
                        || ';' like '%;'
                                    || ue.lgr_ort_ziel
                                    || ';%'
            ) );
    /*
    and (( ';' || in_lgr_orte like '%;' || g.lgr_ort || ';%')
      or ( g.lgr_ort = u.lgr_ort_quelle
       and u.lgr_platz is not NULL
       and ';' || in_lgr_orte like '%;' || u.lgr_ort_ziel || ';%'));
    */
    begin
        v_err_nr := null;
        v_err_text := null;
        out_lgr_platz := null;
        v_found_lgr := false;
        v_weiter_lgr := false;
        v_lgr_dim_platz_ref := null;
        v_lgr_dim_ort_ref := null;
        v_ref_lgr_gruppe_id := null;
        v_fahrzeuge_rest := 1;
        v_faktor_akt := 0;
        if in_fahrzeuge_ids is not null then
            v_fahrzeuge_rest := null;
            open c_lvs_fahrzeuge;
            fetch c_lvs_fahrzeuge into v_fahrzeuge_rest;
            close c_lvs_fahrzeuge;
        end if;

        if v_fahrzeuge_rest is null then
            v_err_nr := c.r_fmid_kein_fahrz_bereit_orte;
            if v_err_text is null then
                v_err_text := lc.ec_p1(lc.o_tp1_lgr_kein_fahrzeug, in_lte.lte_id);
            end if;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        elsif v_fahrzeuge_rest <= 0 then
            v_err_nr := c.fmid_alle_fahrz_ausgelastet;
            if v_err_text is null then
                v_err_text := lc.ec_p1(lc.o_tp1_lgr_kein_fahrzeug, in_lte.lte_id);
            end if;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        end if;

        if in_lte.lte_voll = c.lte_voll_a then
            open c_firma;
            fetch c_firma into v_firma;
            close c_firma;
        else
            v_firma := null;
        end if;

    -- wir suchen nacheinander in allen lagerorten !!
        v_lgr_orte := lvs_lager_opt.lvs_lort_format(in_lgr_orte);
        if v_lgr_orte is null then
            v_err_nr := c.fmid_keine_lagerorte;
            v_err_text := lc.ec(lc.o_txt_lgr_ort_n_erfasst);
            raise v_error;
        end if;

        v_lgr_ort_count := lvs_lager_opt.lvs_lort_count(v_lgr_orte);

    --lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab := lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab_empty;
        for v_lo_nr in 1..v_lgr_ort_count loop
            lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab_empty;
            v_lgr_ort_nr := lvs_lager_opt.lvs_lort_ix(v_lgr_orte, v_lo_nr);
            open c_ort;
            fetch c_ort into v_ort;
            v_found := c_ort%found;
            close c_ort;
            if in_lte.lgr_platz is null then
                v_einl_extern := c.c_true;
            else
                v_einl_extern := c.c_false;
            end if;

            if lvs_einl.check_lte_name_einl(in_lte.sid, in_lte.firma_nr, v_lo_nr, null, -- lgr_gruppen_id

             in_lte.lte_name,
                                            'F', -- in_einl_extern => :in_einl_extern,
                                             1) -- in_anz_lte => :in_anz_lte);
                                             != c.c_true then
                if v_err_text is null then
                    v_err_nr := c.fmid_kein_platz_fuer_lte;
                    v_err_text := lc.ec_p1(lc.o_tp1_lgr_f_lte_n_gefunden, in_lte.lte_id || ' -> Fuellgradkontrolle <-');

                end if;
            else
                if
                    v_ort.lgr_typ = c.pp_epl1
                    and in_lte.lte_id not like 'LTE_VL%' -- Echte Palette dann über EPL1 Platz suchen
                then
                    v_ort.lgr_typ := c.epl1;
                end if;

                if v_ort.strat_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ < 0 then
                    if v_lvs_lgr_ref_platz is not null then
                        open c_ref_lgr_platz_fix;
                        fetch c_ref_lgr_platz_fix into
                            v_lgr_dim_platz_ref,
                            v_lgr_dim_ort_ref;
                        close c_ref_lgr_platz_fix;
                    end if;

                    if v_lgr_dim_platz_ref is null then
                        open c_ref_lgr_platz;
                        fetch c_ref_lgr_platz into
                            v_lgr_dim_platz_ref,
                            v_lgr_dim_ort_ref;
                        close c_ref_lgr_platz;
                    end if;

                else
                    if v_ort.strat_fuellgrad_relevanz /* c.LGR_FUELLGRAD_RELEVANZ */ > 0 then
                        open c_transporte;
                        fetch c_transporte into
                            v_ref_lgr_gruppe_id,
                            v_lgr_dim_ort_ref;
                        close c_transporte;
                    end if;
                end if;

                if v_found then
                    if v_ort.lgr_typ = c.sat1
                    or v_ort.lgr_typ = c.kanal1
            -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
                    or v_ort.lgr_typ = c.seg1
                    or v_ort.lgr_typ = c.seg_duedo1 then
            -- Kanal oder SAT-Lager
                        open c_lgr_kanal;
                        loop
                            fetch c_lgr_kanal into
                                v_lgr_dim_fifo_nr,
                                v_ausl_dispo_faktor_akt,
                                v_dat_lgr_regal_ebene_faktor,
                                v_abstand_faktor_akt,
                                v_faktor_akt,
                                v_lgr_platz_grp,
                                v_lgr.lgr_dim_g,
                                v_lgr.lgr_dim_r,
                                v_lgr.lgr_dim_p,
                                v_lgr.lgr_dim_e;

                            v_found := c_lgr_kanal%found;
              -- Wenn z.B. nur sortenrein eingelagert werden darf, dann ist nichts mehr Frei
              -- dann ist kein gueltiger Lagerplatz mehr in diesem Lager
                            if v_faktor_akt > v_ort.strat_platz_factor_max -- c.LGR_PLATZ_FACTOR_MAX
                            or (
                                in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                and v_firma.res_string_anbruch is not null
                                and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                            ) then
                                if v_err_text is null then
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                        v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                               in_lte.lte_id,
                                                               to_char(v_faktor_akt),
                                                               to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                               v_lgr.lgr_platz);

                                    else
                                        v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz, v_firma.res_string_anbruch
                                        );
                                    end if;
                                end if;

                                v_found := false;
                            end if;

                            open c_lgr_grp;
                            fetch c_lgr_grp into
                                v_ausl_dispo_lte_grp,
                                v_ausl_res_lte_grp;
                            close c_lgr_grp;
                            if v_ausl_dispo_lte_grp > 0
                            or v_ausl_res_lte_grp > 0 then
                                v_found := false;
                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz, v_lgr_text);

                            end if;

                            if v_found then
                                begin
                                    open c_lgr_in_grp;
                                    fetch c_lgr_in_grp into v_lgr;
                                    v_found := c_lgr_in_grp%found;
                                    close c_lgr_in_grp;
                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_platz_akt := v_lgr.lgr_platz;
                                        v_lgr_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                     in_fahrzeuge_ids);
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            else
                                                v_err_nr := v_lgr_platz_fehler;
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_lgr_text);

                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 10;
                                end;
                            end if;

                            exit when c_lgr_kanal%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_kanal;
                    elsif v_ort.lgr_typ = c.kanal_bkl1
                    or v_ort.lgr_typ = c.reg_fach1
                    or v_ort.lgr_typ = c.stap_flae1
                    or v_ort.lgr_typ = c.stap_flae2 then
            -- Kanal-Blocklager oder Regalfach
                        open c_lgr_kanal_block;
                        loop
                            fetch c_lgr_kanal_block into
                                v_lgr_platz_akt,
                                v_ausl_dispo_faktor_akt,
                                v_dat,
                                v_abstand_faktor_akt;
                            v_found := c_lgr_kanal_block%found;
                            if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                            or (
                                in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                and v_firma.res_string_anbruch is not null
                                and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                            ) then
                                if v_err_text is null then
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                        v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                               in_lte.lte_id,
                                                               to_char(v_faktor_akt),
                                                               to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                               v_lgr.lgr_platz);

                                    else
                                        v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz, v_firma.res_string_anbruch
                                        );
                                    end if;

                                end if;
                            end if;

                            if v_found then
                                begin
                                    open c_lgr;
                                    fetch c_lgr into v_lgr;
                                    v_found := c_lgr%found;
                                    close c_lgr;
                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                     in_fahrzeuge_ids);
                                        if
                                            v_ort.lgr_typ = c.stap_flae1
                                            and ( v_lgr.lgr_frei_breite - v_ort.lgr_ort_raster_x > in_lte.lte_vol_breite
                                            or v_lgr.lgr_frei_tiefe - v_ort.lgr_ort_raster_y > in_lte.lte_vol_tiefe )
                                        then
                                            v_lgr_text := lc.ec_p2(lc.o_tp2_lte_buch_platz_err, in_lte.lte_id, v_lgr.lgr_platz);

                                            v_lgr_platz_fehler := c.fmid_lte_falscher_platz;
                                            v_found := false;
                                        end if;

                                        if ( nvl(v_lgr.lgr_min_lte_hoehe, 0) > in_lte.lte_vol_hoehe
                                        or nvl(v_lgr.lgr_min_lte_breite, 0) > in_lte.lte_vol_breite
                                        or nvl(v_lgr.lgr_min_lte_tiefe, 0) > in_lte.lte_vol_tiefe ) then
                                            v_lgr_text := lc.ec_p2(lc.o_tp2_lte_buch_platz_err, in_lte.lte_id, v_lgr.lgr_platz);

                                            v_lgr_platz_fehler := c.fmid_lte_falscher_platz;
                                            v_found := false;
                                        end if;
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            else
                                                v_err_nr := v_lgr_platz_fehler;
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_lgr_text);

                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 20;
                                end;
                            end if;

                            exit when c_lgr_kanal_block%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_kanal_block;
                    elsif v_ort.lgr_typ = c.durchl1 then
            -- Kanal-Blocklager oder Regalfach
                        open c_lgr_durchl;
                        loop
                            fetch c_lgr_durchl into
                                v_lgr_platz_akt,
                                v_ausl_dispo_faktor_akt,
                                v_dat,
                                v_abstand_faktor_akt;
                            v_found := c_lgr_durchl%found;
                            if v_found then
                                begin
                                    open c_lgr;
                                    fetch c_lgr into v_lgr;
                                    v_found := c_lgr%found;
                                    close c_lgr;
                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                               in_fahrzeuge_ids);
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 20;
                                end;
                            end if;

                            exit when c_lgr_durchl%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_durchl;
                    elsif v_ort.lgr_typ = c.epl1 then
            -- Einzelplatz
                        v_lgr_verwendung_epl1 := c.lgr_typ_lager; -- Nur echte lagerplaetze (Keine Paletierplaetze)
                        open c_lgr_epl;
                        loop
                            fetch c_lgr_epl into
                                v_lgr_platz_akt,
                                v_ausl_dispo_faktor_akt,
                                v_abstand_faktor_akt;
                            v_found := c_lgr_epl%found;
                            if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                            or (
                                in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                and v_firma.res_string_anbruch is not null
                                and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                            ) then
                                if v_err_text is null then
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                        v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                               in_lte.lte_id,
                                                               to_char(v_faktor_akt),
                                                               to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                               v_lgr.lgr_platz);

                                    else
                                        v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz, v_firma.res_string_anbruch
                                        );
                                    end if;

                                end if;
                            end if;

                            if v_found then
                                begin
                                    open c_lgr;
                                    fetch c_lgr into v_lgr;
                                    v_found := c_lgr%found;
                                    close c_lgr;
                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                     in_fahrzeuge_ids);
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            else
                                                v_err_nr := v_lgr_platz_fehler;
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_lgr_text);

                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 30;
                                end;
                            end if;

                            exit when c_lgr_epl%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_epl;
                    elsif v_ort.lgr_typ = c.pp_epl1 then
                        if
                            in_lte.lte_akt_lhm != 1 -- -AG- Palletiueren geht immer nur mit einen LHM
                            and in_lte.packschema_kopf_id is not null -- -AG- Ohne Packschema dann einfach so einlagern
                        then
                            exit;
                        end if;

                        v_einl_ziel_lte_id := null;
                        if in_lte.packschema_kopf_id is not null -- -AG- Ohne Packschema dann einfach so einlagern
                         then
                            open c_lgr_pp_epl;
                            fetch c_lgr_pp_epl into
                                v_lgr_platz_akt,
                                v_einl_ziel_lte_id;
                            v_found := c_lgr_pp_epl%found;
                            close c_lgr_pp_epl;
              -- -AG- Neu Funktion Palettieren
              -- Palette zum Palletieren mit freien Plätzen gefunden
                            if v_found then
                                v_found_lgr := true;
                                v_lgr_platz := v_lgr_platz_akt;
                                v_packschema_lfdn := lvs_komm.get_packschema_lfdn(in_lte.sid, in_lte.firma_nr, v_einl_ziel_lte_id);
                                update lvs_lam l
                                set
                                    l.packschema_lfdn = v_packschema_lfdn,
                                    l.res_ziel_lte_id = v_einl_ziel_lte_id
                                where
                                    l.lte_id = in_lte.lte_id;

                                exit;
                            end if;

                        end if;

                        v_lgr_text := null;

            -- Leeren Einzelplatz suchen wenn kein Palette zum Füllen gefunden
                        v_lgr_verwendung_epl1 := c.lgr_typ_lagerp; -- Auch in Plaetierplätzen suchen
                        open c_lgr_epl;
                        loop
                            fetch c_lgr_epl into
                                v_lgr_platz_akt,
                                v_ausl_dispo_faktor_akt,
                                v_abstand_faktor_akt;
                            v_found := c_lgr_epl%found;
                            if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                            or (
                                in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                and v_firma.res_string_anbruch is not null
                                and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                            ) then
                                if v_err_text is null then
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                        v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                               in_lte.lte_id,
                                                               to_char(v_faktor_akt),
                                                               to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                               v_lgr.lgr_platz);

                                    else
                                        v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz, v_firma.res_string_anbruch
                                        );
                                    end if;

                                end if;
                            end if;

                            if v_found then
                                begin
                                    open c_lgr;
                                    fetch c_lgr into v_lgr;
                                    v_found := c_lgr%found;
                                    close c_lgr;
                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                     in_fahrzeuge_ids);
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            else
                                                v_err_nr := v_lgr_platz_fehler;
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_lgr_text);

                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 30;
                                end;
                            end if;

                            exit when c_lgr_epl%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_epl;
                        if
                            (
                                v_found_lgr
                                and not v_weiter_lgr
                            ) -- -AG- Platz im Palletierer gefunden
                            and in_lte.packschema_kopf_id is not null -- -AG- Ohne Packschema dann einfach so einlagern
                        then
                            if lvs_p_base.get_lam_by_lte_id(in_lte.sid, in_lte.firma_nr, in_lte.lte_id, v_lam) then
                                if lvs_p_base.get_charge(v_lam.charge_id, v_charge) then
                                    v_lte_id := null;
                                    v_lte_id := lvs_p_lte.lvs_lte_insert_v358('01', -- SID
                                     1, -- Firma
                                     in_lte.lte_name, -- Palettemtype Bsp. 'EURO'
                                     v_lte_id, -- ID der Transporteinheit
                                     in_lte.ls_login_id, -- Login ID aktuelle User
                                                                              in_lte.lgr_ort, null, -- Lagerplatz, NULL ist keiner
                                                                               c.lte_pf_stat, -- Status Palletiert Fertig
                                                                               null, in_lte.lte_eti_druck_status, -- Druckstatus
                                                                              v_lam.charge_id, -- Charge ID
                                                                               v_charge.charge_bez, -- Charge
                                                                               v_lam.artikel_id, -- Artikel ID
                                                                               in_lte.packschema_kopf_id, null, -- Auto Depal ist unbekannt
                                                                              null, -- wickelprogramm ist unbekannt,
                                                                               null); -- wickelprogramm_einl ist unbekannt
                                    update lvs_lte t
                                    set
                                        t.ziel_lgr_platz = v_lgr_platz,
                                        t.lte_status = c.lte_bs_stat,
                                        t.packschema_kopf_id = in_lte.packschema_kopf_id,
                                        t.res_string = in_lte.res_string,
                                        t.res_artikel_id = in_lte.res_artikel_id,
                                        t.res_mhd = in_lte.res_mhd,
                                        t.lte_vol_hoehe = in_lte.lte_vol_hoehe,
                                        t.lte_vol = in_lte.lte_vol
                                    where
                                        t.lte_id = v_lte_id;

                                    update lvs_lam l
                                    set
                                        l.packschema_lfdn = 1,
                                        l.res_ziel_lte_id = v_lte_id
                                    where
                                        l.lte_id = in_lte.lte_id;

                                end if;

                            end if;
                        end if;

                    elsif v_ort.lgr_typ = c.sat_epl1
                    or v_ort.lgr_typ = c.sat_epl2
          -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
          -- or v_ort.lgr_typ = c.SEG1
          -- or v_ort.lgr_typ = c.SEG_DUEDO1
                     then
            -- Satelit Einzelplatz
                        open c_lgr_sat_epl;
                        loop
                            fetch c_lgr_sat_epl into
                                v_lgr_platz_akt,
                                v_ausl_dispo_faktor_akt,
                                v_dat_lgr_regal_ebene_faktor,
                                v_abstand_faktor_akt,
                                v_fuellgrad_seg_akt,
                                v_faktor_akt;
                            v_found := c_lgr_sat_epl%found;
                            if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                            or (
                                in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                and v_firma.res_string_anbruch is not null
                                and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                            ) then
                                if v_err_text is null then
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                        v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                               in_lte.lte_id,
                                                               to_char(v_faktor_akt),
                                                               to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                               v_lgr.lgr_platz);

                                    else
                                        v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz, v_firma.res_string_anbruch
                                        );
                                    end if;
                                end if;

                                v_found := false;
                            end if;

                            if v_found then
                                begin
                                    open c_lgr;
                                    fetch c_lgr into v_lgr;
                                    v_found := c_lgr%found;
                                    close c_lgr;
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                                    or (
                                        in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                        and v_firma.res_string_anbruch is not null
                                        and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                                    ) then
                                        if v_err_text is null then
                                            if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                                v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                                       in_lte.lte_id,
                                                                       to_char(v_faktor_akt),
                                                                       to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                                                                       ),
                                                                       v_lgr.lgr_platz);

                                            else
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_firma.res_string_anbruch);
                                            end if;

                                        end if;
                                    end if;

                                    if v_ort.lgr_typ = c.seg1
                                    or v_ort.lgr_typ = c.seg_duedo1 then
                                        open c_lgr_grp;
                                        fetch c_lgr_grp into
                                            v_ausl_dispo_lte_grp,
                                            v_ausl_res_lte_grp;
                                        close c_lgr_grp;
                                        if v_ausl_dispo_lte_grp > 0
                                        or v_ausl_res_lte_grp > 0 then
                                            v_found := false;
                                            v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz, v_lgr_text
                                            );

                                        end if;

                                    end if;

                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                     in_fahrzeuge_ids);
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            else
                                                v_err_nr := v_lgr_platz_fehler;
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_lgr_text);

                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 30;
                                end;
                            end if;

                            exit when c_lgr_sat_epl%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_sat_epl;
                    else
            -- z.B. Blocklager
                        open c_lgr_block;
                        loop
                            fetch c_lgr_block into
                                v_lgr_platz_akt,
                                v_ausl_dispo_faktor_akt,
                                v_ausl_dispo_bestand,
                                v_abstand_faktor_akt;
                            v_found := c_lgr_block%found;
                            if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                            or (
                                in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                                and v_firma.res_string_anbruch is not null
                                and v_faktor_akt > v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */
                            ) then
                                if v_err_text is null then
                                    if v_faktor_akt > v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                        v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                               in_lte.lte_id,
                                                               to_char(v_faktor_akt),
                                                               to_char(v_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                               v_lgr.lgr_platz);

                                    else
                                        v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, v_lgr.lgr_platz, v_firma.res_string_anbruch
                                        );
                                    end if;

                                end if;
                            end if;

                            if v_found then
                                begin
                                    open c_lgr;
                                    fetch c_lgr into v_lgr;
                                    v_found := c_lgr%found;
                                    close c_lgr;
                                    v_weiter_lgr := false;
                                    if v_found then
                                        v_lgr_text := lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                        , v_lgr, 'E',
                                                                                     in_fahrzeuge_ids);
                    -- Ist den dieses ein besserer Platz
                                        if v_ausl_dispo_faktor is null
                                           or ( v_ausl_dispo_faktor > v_ausl_dispo_faktor_akt )
                                        or (
                                            v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                            and v_abstand_faktor > v_abstand_faktor_akt
                                        ) then
                                            v_weiter_lgr := true;
                                            if v_lgr_text is null then
                                                v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                                v_lgr_platz := v_lgr_platz_akt;
                                                v_abstand_faktor := v_abstand_faktor_akt;
                                                v_weiter_lgr := false;
                                                v_found_lgr := true;
                                            else
                                                v_err_nr := v_lgr_platz_fehler;
                                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_f_lte_n_gefunden_tc, in_lte.lte_id, v_lgr.lgr_platz
                                                , v_lgr_text);

                                            end if;

                                        else
                      -- Gefunden jedoch schlechter
                                            v_found_lgr := true;
                                        end if;

                                    end if;

                                exception
                                    when others then
                                        v_err_nr := 40;
                                end;
                            end if;

                            exit when c_lgr_block%notfound
                            or (
                                v_found_lgr
                                and not v_weiter_lgr
                            );
                        end loop;

                        close c_lgr_block;
                    end if;
                end if;

            end if;

        end loop; --for (Ueber alle Lagerorte)

        if not v_found_lgr
        or v_lgr_platz is null then
            if v_err_nr is null then
                v_err_nr := c.fmid_kein_platz_fuer_lte;
                if v_err_text is null then
                    v_err_text := lc.ec_p1(lc.o_tp1_lgr_f_lte_n_gefunden, in_lte.lte_id);
                end if;

            end if;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_lgr_platz_akt := v_lgr_platz;
            open c_lgr;
            fetch c_lgr into v_lgr;
            v_found := c_lgr%found;
            close c_lgr;
            out_lgr_platz := v_lgr;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_suche_einl_platz;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- für individuelle Daten ohne angelegte Palette
  -------------------------------------------------------------------------
    procedure lvs_suche_allg_einl_platz (
        in_sid            in lvs_lte.sid%type,
        in_firma_nr       in lvs_lte.firma_nr%type,
        in_artikel_id     in lvs_lte.res_artikel_id%type,
        in_res_string     in lvs_lte.res_string%type,
        in_lte_vol_hoehe  in lvs_lte.lte_vol_hoehe%type,
        in_lte_vol_breite in lvs_lte.lte_vol_breite%type,
        in_lte_vol_tiefe  in lvs_lte.lte_vol_tiefe%type,
        in_lte_name       in lvs_lte.lte_name%type,
        in_lgr_orte       in varchar2,
        out_lgr_platz     out lvs_lgr.lgr_platz%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr     number;
        v_err_text   varchar2(2550);
    -------------------------------------------------------------------------------------------------------

        v_pseudo_lte lvs_lte%rowtype;
        v_artikel    isi_artikel%rowtype;
        v_lgr        lvs_lgr%rowtype;
        v_lte_cfg    lvs_lte_cfg%rowtype;
    begin
        if not isi_allg.get_artikel_by_artikel_id(in_sid, in_artikel_id, v_artikel) then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_artikel_id_fehlt,
                                   nvl(
                                                to_char(in_artikel_id),
                                                'null'
                                            ));

            raise v_error;
        end if;

        v_pseudo_lte := null;
        v_pseudo_lte.sid := in_sid;
        v_pseudo_lte.firma_nr := in_firma_nr;
        v_pseudo_lte.lte_id := 'NEU EINLAGERN';
        v_pseudo_lte.res_artikel_id := in_artikel_id;
        v_pseudo_lte.res_string := in_res_string; -- ???????

        v_pseudo_lte.waren_typ := 'VP'; -- erstmal Vollpalette, evtl. Anbruchpalette (AP)
        v_pseudo_lte.lte_voll := 'V'; -- evtl. 'A'

        v_pseudo_lte.lte_akt_kg := 0; -- TODO: muss noch aus LTE_CFG, LHM_CFG und Artikelstamm aufsummiert werden
        v_pseudo_lte.lte_vol_hoehe := in_lte_vol_hoehe;
        v_pseudo_lte.lte_vol_breite := in_lte_vol_breite;
        v_pseudo_lte.lte_vol_tiefe := in_lte_vol_tiefe;
        v_pseudo_lte.lte_name := in_lte_name;
        v_pseudo_lte.abc := v_artikel.abc;
        v_pseudo_lte.min_temp := v_artikel.min_temp;
        v_pseudo_lte.max_temp := v_artikel.max_temp;
        v_pseudo_lte.wert_klasse := v_artikel.wert_klasse;
        v_pseudo_lte.gefahren_klasse := v_artikel.gefahren_klasse;
        if not lvs_p_base.get_lte_cfg(in_sid, in_lte_name, v_lte_cfg) then
            v_err_nr := 20;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_cfg_fehlt,
                                   nvl(in_lte_name, 'null'));

            raise v_error;
        end if;

        lvs_suche_einl_platz(v_pseudo_lte,
                             nvl(v_lte_cfg.basis_lte_name, in_lte_name),
                             v_lte_cfg.flaechen_stellplatz_erf,
                             in_lgr_orte,
                             null,
                             v_lgr);

        out_lgr_platz := v_lgr.lgr_platz;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- für Liniendaten ohne angelegte Palette
  -------------------------------------------------------------------------
    procedure lvs_suche_linie_einl_platz (
        in_sid        in lvs_prod_linie.sid%type,
        in_firma_nr   in lvs_prod_linie.firma_nr%type,
        in_linie_nr   in lvs_prod_linie.linie_nr%type,
        out_lgr_platz out lvs_lgr.lgr_platz%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr      number;
        v_err_text    varchar2(2550);
    -------------------------------------------------------------------------------------------------------

        v_linie       lvs_prod_linie%rowtype;
        v_linie_waren lvs_prod_linie_waren%rowtype;
        cursor c_linie is
        select
            *
        from
            lvs_prod_linie l
        where
                l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and l.linie_nr = in_linie_nr;

        cursor c_linie_waren is
        select
            *
        from
            lvs_prod_linie_waren lw
        where
                lw.sid = in_sid
            and lw.firma_nr = in_firma_nr
            and lw.linie_nr = in_linie_nr;

        v_found       boolean;
    begin
        open c_linie;
        fetch c_linie into v_linie;
        v_found := c_linie%found;
        close c_linie;
        if not v_found then
            v_err_nr := 1;
            v_err_text := lc.ec_p1(lc.o_tp1_lvs_prod_linie_fehlt,
                                   nvl(
                                                to_char(in_linie_nr),
                                                'null'
                                            ));

            raise v_error;
        end if;

    -- TODO: Anzahl der Positionen prüfen. Z. Zt. nur mit einer bzw. mit der ersten Position möglich
        open c_linie_waren;
        fetch c_linie_waren into v_linie_waren;
        v_found := c_linie_waren%found;
        close c_linie_waren;
        if not v_found then
            v_err_nr := 2;
            v_err_text := lc.ec_p1(lc.o_tp1_lvs_prod_l_ware_leer,
                                   nvl(
                                                to_char(in_linie_nr),
                                                'null'
                                            ));

            raise v_error;
        end if;

        lvs_suche_allg_einl_platz(in_sid,
                                  in_firma_nr,
                                  v_linie_waren.artikel_id,
                                  v_linie.res_string,
                                  v_linie.lte_vol_hoehe,
                                  v_linie.lte_vol_breite,
                                  v_linie.lte_vol_tiefe,
                                  v_linie.lte_name,
                                  to_char(v_linie.linie_lagerort)
                                  || ';',
                                  out_lgr_platz);

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_suche_linie_einl_platz;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  --   der beste Platz wird über die Bewertung gefunden, anschliessend
  --   wird geprüft, ob der Platz OK ist, und er mit den mitgegebenen
  --   Fahrzeugen der Platz erreichbar ist.
  -------------------------------------------------------------------------
    procedure lvs_suche_lte_einl_platz (
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_orte      in varchar2,
        in_fahrzeuge_ids in varchar2,
        out_lgr_platz    out lvs_lgr.lgr_platz%type
    ) is

        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(2550);
        v_lte            lvs_lte%rowtype;
        v_lgr            lvs_lgr%rowtype;
        v_found          boolean;
        v_lte_cfg        lvs_lte_cfg%rowtype;
        v_basis_lte_name lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.firma_nr = v_lte.firma_nr
            and t.lte_name = v_lte.lte_name;

        cursor c_lte is
        select
            t.*
        from
            lvs_lte t
        where
            t.lte_id = in_lte_id;

    begin
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt,
                                   nvl(in_lte_id, 'NULL'));

            raise v_error;
        end if;

        out_lgr_platz := null;
        open c_lte_cfg;
        fetch c_lte_cfg into v_lte_cfg;
        close c_lte_cfg;
        v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
        lvs_platz_new.lvs_suche_einl_platz(v_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, in_lgr_orte, -- Müssen immer 3-Stellig mit ; getrennt sein auch hinter dem letzten
         in_fahrzeuge_ids,
                                           v_lgr);

        out_lgr_platz := v_lgr.lgr_platz;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_suche_lte_einl_platz;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- jedoch ohne Berücksichtigung von Fahrzeugen
  -------------------------------------------------------------------------
    procedure lvs_c_transp_suche_einl_p_rid (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    ) is
    --
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
    begin
        v_fahrz_res_id := null;
        lvs_c_transp_suche_einl_p_oq(in_lte_id, -- in LVS_LTE.LTE_ID%TYPE,
         in_lgr_orte, -- in varchar2,
         in_fahrzeuge_ids, --        in varchar2,
         in_modul_erzeuger, -- in isi_transport.Modul_Erzeuger%TYPE,
         in_modul_bearbeiter, -- in isi_transport.Modul_Bearbeiter%TYPE,
                                     in_user_id, -- in isi_user.login_id%TYPE,
                                      in_prio, -- in isi_transport.Prio%TYPE,
                                      in_progr_nr, -- in isi_transport.progr_nr%TYPE,
                                      in_quelle_leer_progr_nr, -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                      in_ziel_voll_progr_nr, -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                     in_lgr_platz_quelle, -- in lvs_lgr.lgr_platz%type,
                                      in_aktuelle_position, -- in_aktuelle_position    in lvs_lam.lam_text%type,
                                      out_lgr_platz, -- out lvs_lgr.lgr_platz%TYPE,
                                      out_transport_id); -- out number;
        out_res_id := v_fahrz_res_id;
    -- Achtung das Commit uebernimmt die gerufene Procedure
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_c_transp_suche_einl_p_rid;
  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- jedoch ohne Berücksichtigung von Fahrzeugen
  -- Ohne Commit
  -------------------------------------------------------------------------
    procedure lvs_transp_suche_einl_p_rid (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    ) is
    --
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
    begin
        v_fahrz_res_id := null;
        update lvs_lam lam
        set
            lam.lam_text = nvl(lam.lam_text, in_aktuelle_position)
        where
            lam.lte_id = in_lte_id;

        lvs_transp_suche_einl_platz(in_lte_id, -- in LVS_LTE.LTE_ID%TYPE,

         in_lgr_orte, -- in varchar2,

         in_fahrzeuge_ids, --        in varchar2,

         in_modul_erzeuger, -- in isi_transport.Modul_Erzeuger%TYPE,

         in_modul_bearbeiter, -- in isi_transport.Modul_Bearbeiter%TYPE,
                                    in_user_id, -- in isi_user.login_id%TYPE,
                                     in_prio, -- in isi_transport.Prio%TYPE,
                                     in_progr_nr, -- in isi_transport.progr_nr%TYPE,
                                     in_quelle_leer_progr_nr, -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                     in_ziel_voll_progr_nr, -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                    in_lgr_platz_quelle, -- in lvs_lgr.lgr_platz%type,
                                     out_lgr_platz, -- out lvs_lgr.lgr_platz%TYPE,
                                     out_transport_id); -- out number;
        out_res_id := v_fahrz_res_id;
    -- Achtung das Commit uebernimmt die gerufene Procedure
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_transp_suche_einl_p_rid;

  -------------------------------------------------------------------------
  -- Suchen nach dem Optimalen Einlagerplatz und Auswertung ob der Platz OK
  -- Wobei die aktuelle Position in der LAM als Test gespeichert wird.
  -- Hieduch kann die Quellposition des im MFR für jede Palette gefunden
  -- werden
  -------------------------------------------------------------------------
    procedure lvs_c_transp_suche_einl_p_oq (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number
    ) is
    --
        v_error exception;
        v_err_nr        number;
        v_err_text      varchar2(2550);
        v_lgr           lvs_lgr%rowtype;
        v_lte           lvs_lte%rowtype;
        v_lgr_platz     lvs_lgr_ort_ue_platz%rowtype;
        v_lgr_orte      varchar2(255);
        v_lgr_ort_count number;
        v_lgr_ort_nr    lvs_lgr_ort.lgr_ort%type;

    /*
    CURSOR c_lvs_ue_platz is
      select u.lgr_platz
        from lvs_lgr_ort_ue_platz u
       where u.lgr_ort_quelle = v_lgr.lgr_ort
         and ';' || in_lgr_orte like '%;' || u.lgr_ort_ziel || ';%';
    */
    begin
    -- -AG- Dieser Bereich dient der korrekten Abhandlung von Koppel-Transporten
    -- Erst mal prüfen, ob die aktuelle Position ein Lagerplatz ist
    -- dann Prüfen, ob die Liste der Lagerorte für das Ziel genau 1 Platz ist
    -- Wennn die Bedingungen erfüllt sind, dann prüfen ob es zwischen Quelle und Zielort
    --       ein Übergabepunkt vorhanden ist wenn Ja
    --           dann Muss die Palette auf diie aktuelle Position gebucht werden
    --           damit das System erkenne kann, das ein Koppeltransport notwendig ist
    --           Zus. muss der Übergabeplatz als Zielplatz als Rückgabeplatz eingetragen werden
    --           damit das Transportsystem (z.B. MFR) weiss, wohin er Transportieren muss
        v_lgr_platz := null;
        if lvs_p_base.get_lgr_platz(in_aktuelle_position, v_lgr) then
      -- wir suchen nacheinander in allen lagerorten !!
            v_lgr_orte := in_lgr_orte;
            if upper(v_lgr_orte) = 'ALLE;' -- Dann suche in der Reihenfolge der Entfernung
             then
                select
                    stradd_distinct(lagerorte)
                into v_lgr_orte
                from
                    (
                        select
                            lpad(
                                to_char(l.lgr_ort),
                                3,
                                '0'
                            ) lagerorte
                        from
                            lvs_lgr_ort l
                        order by
                            abs(l.lgr_ort - v_lgr.lgr_ort)
                    );

            end if;

            v_lgr_orte := lvs_lager_opt.lvs_lort_format(v_lgr_orte);
            if v_lgr_orte is not null then
                v_lgr_ort_count := lvs_lager_opt.lvs_lort_count(v_lgr_orte);
                if v_lgr_ort_count = 1 then
                    v_lgr_ort_nr := lvs_lager_opt.lvs_lort_ix(v_lgr_orte, 1);
          -- AG 20170814 Übergabeplatz ggf. nur fuer bestimmte Palettentypen
                    if not lvs_p_base.get_lte(in_lte_id, v_lte) then
                        v_lte.lte_name := null;
                    end if;

                    if lvs_p_base.get_lvs_lgr_ort_ue_platz(v_lgr.sid, v_lgr.firma_nr, v_lgr.lgr_ort, v_lgr_ort_nr, 'Keiner',
                                                           v_lte.lte_name, v_lgr_platz) then
                        lvs_transport.lvs_lte_transport(in_lte_id, null, in_aktuelle_position, -1);
                    end if;

                end if;

            end if;

        end if;

        update lvs_lam lam
        set
            lam.lam_text = nvl(lam.lam_text, in_aktuelle_position)
        where
            lam.lte_id = in_lte_id;

        v_lgr_orte := in_lgr_orte;
        if upper(v_lgr_orte) = 'ALLE;' -- Dann suche in der Reihenfolge der Entfernung
         then
            v_lgr_orte := null;
            v_lgr.lgr_ort := null;
            if in_lgr_platz_quelle is null then
                if lvs_p_base.get_lte(in_lte_id, v_lte) then
                    v_lgr.lgr_ort := v_lte.lgr_ort;
                    if lvs_p_base.get_lgr_platz(v_lte.lgr_platz, v_lgr) then
                        v_lgr_orte := v_lgr.einl_ort_default_liste;
                    end if;

                end if;
            end if;
      /*
      if v_lgr.lgr_ort is NULL
      then
        if not lvs_p_base.get_lgr_platz(in_lgr_platz_quelle, v_lgr)
        then
          v_lgr.lgr_ort := 0;
        end if;
      end if;

      select stradd_distinct(lagerorte) into v_lgr_orte
      from (select
             lpad(to_char(l.lgr_ort), 3, '0') Lagerorte
              from lvs_lgr_ort l
             order by abs(l.lgr_ort - v_lgr.lgr_ort)
           );
    */
        end if;

        lvs_c_transp_suche_einl_platz(in_lte_id, -- in LVS_LTE.LTE_ID%TYPE,

         v_lgr_orte, -- in varchar2,

         in_fahrzeuge_ids, --        in varchar2,

         in_modul_erzeuger, -- in isi_transport.Modul_Erzeuger%TYPE,

         in_modul_bearbeiter, -- in isi_transport.Modul_Bearbeiter%TYPE,
                                      in_user_id, -- in isi_user.login_id%TYPE,
                                       in_prio, -- in isi_transport.Prio%TYPE,
                                       in_progr_nr, -- in isi_transport.progr_nr%TYPE,
                                       in_quelle_leer_progr_nr, -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                       in_ziel_voll_progr_nr, -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                      in_lgr_platz_quelle, -- in lvs_lgr.lgr_platz%type,
                                       out_lgr_platz, -- out lvs_lgr.lgr_platz%TYPE,
                                       out_transport_id); -- out number;
    -- Achtung das Commit uebernimmt die gerufene Procedure
        if v_lgr_platz.lgr_platz is not null then
            out_lgr_platz := v_lgr_platz.lgr_platz;
        end if;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_c_transp_suche_einl_p_oq;

  -------------------------------------------------------------------------
  -- Standardfunktion Einlagern. Sucht einen Lagerplatz (optimal) und trägt
  -- den transport ein.
  -------------------------------------------------------------------------
    procedure lvs_c_transp_suche_einl_platz (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number
    ) is
    begin
        lvs_transp_suche_einl_platz(in_lte_id, -- in LVS_LTE.LTE_ID%TYPE,
         in_lgr_orte, -- in varchar2,
         in_fahrzeuge_ids, --        in varchar2,
         in_modul_erzeuger, -- in isi_transport.Modul_Erzeuger%TYPE,
         in_modul_bearbeiter, -- in isi_transport.Modul_Bearbeiter%TYPE,
                                    in_user_id, -- in isi_user.login_id%TYPE,
                                     in_prio, -- in isi_transport.Prio%TYPE,
                                     in_progr_nr, -- in isi_transport.progr_nr%TYPE,
                                     in_quelle_leer_progr_nr, -- in isi_transport.quelle_leer_progr_nr%TYPE,
                                     in_ziel_voll_progr_nr, -- in isi_transport.ziel_voll_progr_nr%TYPE,
                                    in_lgr_platz_quelle, -- in lvs_lgr.lgr_platz%type,
                                     out_lgr_platz, -- out lvs_lgr.lgr_platz%TYPE,
                                     out_transport_id); -- out number;
        if out_lgr_platz is null then
            rollback;
        else
            commit;
        end if;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when others then
            rollback;
            raise;
    end;
  -------------------------------------------------------------------------
    procedure lvs_transp_suche_einl_platz (
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number
    ) is
    -------------------------------------------------------------------------
    --
        v_error exception;
        v_err_nr           number;
        v_err_text         varchar2(2550);
        v_neuer_status     lvs_lte.lte_status%type;
        v_found            boolean;
        v_lgr_platz        lvs_lgr.lgr_platz%type;
        r_lgr              lvs_lgr%rowtype;
        v_lte              lvs_lte%rowtype; -- LTE
        v_result           number;
        v_transport_gruppe isi_transport.transport_gruppe%type;
        v_lte_cfg          lvs_lte_cfg%rowtype;
        v_basis_lte_name   lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.lte_name = v_lte.lte_name;

        cursor c_lvs_lte is -- Lesen des Lagerhilfsmittel
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        r_lgr := null;
        out_transport_id := 0;

    -- LTE Einlesen
        open c_lvs_lte;
        fetch c_lvs_lte into v_lte;
        v_found := c_lvs_lte%found;
        close c_lvs_lte;
        if not v_found then
            v_err_nr := c.fmid_lte_id_schon_vorhanden;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
            raise v_error;
        end if;

        if
            v_lte.lte_status != c.lte_kf_stat
            and v_lte.lte_status != c.lte_af_stat
            and v_lte.lte_status != c.lte_ag_stat
            and v_lte.lte_status != c.lte_bf_stat
            and v_lte.lte_status != c.lte_pf_stat
        then
            if v_lte.lte_status != c.lte_bs_stat
            or in_modul_erzeuger != 'MFR' then
                v_err_nr := c.fmid_falscher_lte_status;
                v_err_text := lc.ec_p2(lc.o_tp2_lte_id_st_n_einl_bar, in_lte_id, v_lte.lte_status);
                raise v_error;
            end if;
        end if;

        if in_lgr_platz_quelle is null then
            v_lgr_platz := v_lte.lgr_platz;
        else
            v_lgr_platz := in_lgr_platz_quelle;
        end if;

        if r_lgr.sid is null then
            open c_lte_cfg;
            fetch c_lte_cfg into v_lte_cfg;
            close c_lte_cfg;
            v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
            lvs_suche_einl_platz(v_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, in_lgr_orte, in_fahrzeuge_ids,
                                 r_lgr);
        end if;

        if ( r_lgr.sid is not null ) then
            v_transport_gruppe := 0;
            v_result := lvs_transport.lvs_transp_lte(v_lte.sid, v_lte.firma_nr, in_modul_erzeuger, in_modul_bearbeiter, 'F',
                                                     'E', in_user_id, null, null, in_prio,
                                                     in_progr_nr, in_quelle_leer_progr_nr, in_ziel_voll_progr_nr, v_lgr_platz, r_lgr.lgr_platz
                                                     ,
                                                     in_lte_id, null, 'F', null, null,
                                                     null, in_fahrzeuge_ids, null, v_transport_gruppe, out_transport_id);

        end if;

        if v_result = 0 then
            out_lgr_platz := r_lgr.lgr_platz;
        else
            out_lgr_platz := null;
            out_transport_id := null;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt out_lgr_platz := NULL.
        when v_error then
      -- Update 2011 show Exception Source Line
            out_lgr_platz := null;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            out_lgr_platz := null;
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

    end lvs_transp_suche_einl_platz;

  -------------------------------------------------------------------------
  -- Traegt den transport eien Palette ein. Setzt alle DISPOS etc.
  -------------------------------------------------------------------------

    function lvs_c_transp_lte (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_frei_fahren          in varchar2,
        in_trans_typ            in varchar2,
        in_user_id              in isi_user.login_id%type,
        in_auftrag_id           in isi_transport.auf_id%type,
        in_auftrag_id_extern    in isi_transport.auf_id_extern%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_quell_lgr_platz  in lvs_lte.lgr_platz%type,
        in_lgr_ziel_lgr_platz   in lvs_lte.lgr_platz%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_kunde_nr             in lvs_lam.kunden_nr%type,
        in_lieferschein         in isi_transport.lieferschein%type,
        in_li_nr                in isi_transport.li_nr%type,
        in_li_pos_nr            in isi_transport.li_pos_nr%type,
        in_vorgang_id           in isi_transport.vorgang_id%type,
        in_lkw_nr               in isi_transport.lkw_nr%type,
        in_fahrzeuge_ids        in varchar2,
        in_out_transport_gruppe in out isi_transport.transport_gruppe%type
    ) return number is

    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_transp_id isi_transport.transp_id%type;
        v_result    number;
    begin
    -- Lesen der Artikeldaten
        v_err_nr := null;
        v_err_text := null;
        v_result := lvs_transport.lvs_transp_lte(in_sid, in_firma_nr, in_modul_erzeuger, in_modul_bearbeiter, in_frei_fahren,
                                                 in_trans_typ, in_user_id, in_auftrag_id, in_auftrag_id_extern, in_prio,
                                                 in_progr_nr, in_quelle_leer_progr_nr, in_ziel_voll_progr_nr, in_lgr_quell_lgr_platz,
                                                 in_lgr_ziel_lgr_platz,
                                                 in_lte_id, in_kunde_nr, in_lieferschein, in_li_nr, in_li_pos_nr,
                                                 in_vorgang_id, in_fahrzeuge_ids, in_lkw_nr, in_out_transport_gruppe, v_transp_id);

        commit;
        return ( v_result );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_lte;

  --------------------------------------------------------------------------------
  -- Transport und alle DISPOS werden gelöscht
  --------------------------------------------------------------------------------
    function lvs_c_transp_loeschen (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type
    ) return integer is
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_ret_value integer; -- return value
    begin
        v_err_nr := null;
        v_err_text := null;
        v_ret_value := 0; -- Erst mal OK
        v_ret_value := lvs_transport.lvs_transp_loeschen(in_sid, in_firma_nr, in_user_id, in_transport_id, 'T');
        if v_ret_value = 0 then
            commit;
        else
            rollback;
        end if;
        return ( v_ret_value );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_loeschen;

  --------------------------------------------------------------------------------
  -- function lvs_c_transp_check_zugriff
  -- return value:
  --  =  1 Freifahrtauftrag wird erzeugten
  --  =  0 Kein Freiauftrag erzeugt auf LTE kann direkt zugegriffen werden
  --  = -1 LTE im Weg freifahren nicht erlaubt
  --------------------------------------------------------------------------------
    function lvs_c_transp_check_zugriff (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_frei_fahren      in varchar2,
        in_user_id          in isi_user.login_id%type,
        in_transport_id     in isi_transport.transp_id%type,
        in_fahrzeuge_ids    in varchar2
    ) return pls_integer is
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_return   integer;
    begin
    -- Lesen der Artikeldaten
        v_err_nr := null;
        v_err_text := null;
        v_return := lvs_transport.lvs_transp_check_zugriff(in_sid, in_firma_nr, in_modul_erzeuger, in_modul_bearbeiter, in_frei_fahren
        ,
                                                           in_user_id, in_transport_id, in_fahrzeuge_ids);

        commit;
        return ( v_return );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_check_zugriff;

  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_ZUWEISEN
  -- Transport mit der ID xx wird eien RES_ID zugewiesen
  --------------------------------------------------------------------------------
    function lvs_c_transp_zuweisen (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_res_id       in isi_resource.res_id%type
    ) return integer is

        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_found     boolean;
        v_ret_value integer; -- return value
        v_transport isi_transport%rowtype;
        v_res       isi_resource%rowtype;
        cursor c_transport is
        select
            t.*
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.transp_id = in_transport_id;

        cursor c_res is
        select
            *
        from
            isi_resource res
        where
                res.sid = in_sid
            and res.res_id = in_res_id;

    begin
        v_ret_value := 0; -- Erst mal OK

        open c_transport;
        fetch c_transport into v_transport; -- Lesen des Transportauftrags
        v_found := c_transport%found;
        close c_transport;
        if v_found then
            if
                v_transport.status != c.trans_frei
                and v_transport.status != c.trans_gesperrt
                and v_transport.status != c.trans_zugew
            then
                v_ret_value := c.lgr_transp_begonnen;
            else
                open c_res;
                fetch c_res into v_res; -- Resource lesen
                v_found := c_res%found;
                close c_res;
                if v_found then
                    update isi_transport tra
                    set
                        tra.res_id = in_res_id,
                        tra.status = c.trans_zugew
                    where
                            tra.sid = in_sid
                        and tra.firma_nr = in_firma_nr
                        and tra.transp_id = in_transport_id;

                else
                    v_ret_value := c.lgr_res_fehlt;
                end if;

            end if;
        else
            v_ret_value := c.transport_fehlt;
        end if;

        if v_ret_value = 0 then
            commit;
        else
            rollback;
        end if;
        return ( v_ret_value );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_zuweisen;

  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_FREI
  -- Transport mit der ID xx wird eien RES_ID zugewiesen
  --------------------------------------------------------------------------------
    function lvs_c_transp_reset (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_res_id       in isi_resource.res_id%type
    ) return integer is
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_ret_value integer; -- return value
    begin
        v_ret_value := lvs_transport.lvs_transp_reset(in_sid, in_firma_nr, in_user_id, in_transport_id, in_res_id);
        commit;
        return ( v_ret_value );
    end lvs_c_transp_reset;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- Transport-Abbruch
  -- gefüllt seien sollte
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure lvs_c_transport_abbr (
        in_sid    in isi_sid.sid%type,
        in_firma  in isi_firma.firma_nr%type,
        in_res_id in isi_resource.res_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
    begin
        lvs_transport.lvs_transport_abbr(in_sid, in_firma, in_res_id);
    end lvs_c_transport_abbr;

  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_BEGINNEN
  -- Transport mit der ID xx wird begonnen Fahrzeug faehrt zur Palette
  --------------------------------------------------------------------------------
    function lvs_c_transp_beginnen (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_lte_id       in lvs_lte.lte_id%type,
        in_res_id       in isi_resource.res_id%type
    ) return integer is
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_ret_value integer; -- return value
    begin
        v_ret_value := lvs_transport.lvs_transp_beginnen(in_sid, in_firma_nr, in_user_id, in_transport_id, in_lte_id,
                                                         in_res_id);

        if v_ret_value = 0 then
            commit;
        else
            rollback;
        end if;
        return ( v_ret_value );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_beginnen;

  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_TRANSPORT
  -- Transport mit der ID xx wird begonnen Palette ist aufgenommen und wird
  -- Transportiert
  --------------------------------------------------------------------------------
    function lvs_c_transp_transport (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_user_id         in isi_user.login_id%type,
        in_transport_id    in isi_transport.transp_id%type,
        in_lte_id          in lvs_lte.lte_id%type,
        in_res_id          in isi_resource.res_id%type,
        in_out_lam_bh_vorg in out isi_transport.lam_bh_vorgang_id%type
    ) return integer is
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_ret_value integer; -- return value
    begin
        v_ret_value := lvs_transport.lvs_transp_transport(in_sid, in_firma_nr, in_user_id, in_transport_id, in_lte_id,
                                                          in_res_id, in_out_lam_bh_vorg);

        if v_ret_value = 0 then
            commit;
        else
            rollback;
        end if;
        return ( v_ret_value );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_transport;

  --------------------------------------------------------------------------------
  -- procedure LVS_C_TRANSP_NEUES_ZIEL
  -- Transport mit der ID bekommt ein neues Ziel Palette etc wird angepasst
  --------------------------------------------------------------------------------
    function lvs_c_transp_neues_ziel (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_neues_ziel   in isi_transport.lgr_platz_ziel%type,
        out_res_id      out isi_resource.res_id%type
    ) return integer is

        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_found     boolean;
        v_ret_value integer; -- return value
        v_transport isi_transport%rowtype;
        v_lte       lvs_lte%rowtype;
        v_lgr_ziel  lvs_lgr%rowtype;
        v_lgr       lvs_lgr%rowtype;
        v_lgr_platz lvs_lgr.lgr_platz%type;
        cursor c_transport is
        select
            t.*
        from
            isi_transport t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.transp_id = in_transport_id;

        cursor c_lgr is
        select
            *
        from
            lvs_lgr l
        where
                l.sid = in_sid
            and l.firma_nr = in_firma_nr
            and l.lgr_platz = v_lgr_platz;

        cursor c_lte is
        select
            *
        from
            lvs_lte t
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lte_id = v_transport.lte_id;

        cursor c_lvs_lgr_grp_fahrzeug is
        select
            decode(
                min(f.res_id),
                max(f.res_id),
                min(f.res_id),
                null
            ) res_id
        from
            lvs_lgr_grp_fahrzeug f
        where
                f.lgr_gruppe_id = v_lgr_ziel.lgr_gruppe_id
            and f.lgr_ort = v_lgr_ziel.lgr_ort;

    begin
        v_ret_value := 0; -- Erst mal OK

        open c_transport;
        fetch c_transport into v_transport; -- Lesen des Transportauftrags
        v_found := c_transport%found;
        close c_transport;
        if v_found then
            v_lgr_platz := v_transport.lgr_platz_ziel;
            open c_lgr;
            fetch c_lgr into v_lgr;
            v_found := c_lgr%found;
            close c_lgr;
            if v_found then
                open c_lte;
                fetch c_lte into v_lte;
                v_found := c_lte%found;
                close c_lte;
                if v_found then
          -- Bis jetzt alles OK dann Dispo ruecksetzen
                    lvs_platz_einl_disp_ruecks(v_lte, v_lgr);
                    v_lte.ziel_lgr_platz := null;
                    v_lte.ziel_lgr_ort := null;
          -- Jetzt Lagerplatz für neues Ziel lesen
                    v_lgr_platz := in_neues_ziel;
                    open c_lgr;
                    fetch c_lgr into v_lgr_ziel;
                    v_found := c_lgr%found;
                    close c_lgr;
                    if v_found then
                        if v_lgr.lgr_verwendung != v_lgr_ziel.lgr_verwendung then
                            v_lgr_platz := v_transport.lgr_platz_quelle;
                            open c_lgr;
                            fetch c_lgr into v_lgr;
                            v_found := c_lgr%found;
                            close c_lgr;
                            if v_found then
                                if
                                    ( v_lgr.lgr_verwendung = c.lgr_typ_lager
                                    or v_lgr.lgr_verwendung = c.lgr_typ_lagerp
                                    or v_lgr.lgr_verwendung = c.lgr_typ_puffer )
                                    and ( v_lgr_ziel.lgr_verwendung = c.lgr_typ_lager
                                    or v_lgr_ziel.lgr_verwendung = c.lgr_typ_lagerp
                                    or v_lgr_ziel.lgr_verwendung = c.lgr_typ_puffer )
                                then
                                    v_transport.transp_typ := 'U';
                                elsif ( v_lgr_ziel.lgr_verwendung = c.lgr_typ_lager
                                or v_lgr_ziel.lgr_verwendung = c.lgr_typ_lagerp
                                or v_lgr_ziel.lgr_verwendung = c.lgr_typ_puffer ) then
                                    v_transport.transp_typ := 'E';
                                else
                                    v_transport.transp_typ := 'A';
                                end if;
                            end if;

                        end if;

            -- Jetzt wird noch ein Fahrzeug gesucht. Es wird nur dann eingetragen, wenn
            -- ein Eindeutiges Fahrzeug für diesen Lagerplatz gefunden wird
                        out_res_id := v_transport.res_id; -- -AG- 20190212 BugFix Beim MFR wieder aus dem Transport lesen
                        if v_transport.modul_bearbeiter != c.lgr_modul_mfr -- Beim MFR nicht verändern
                        or out_res_id is null then
                            open c_lvs_lgr_grp_fahrzeug;
                            fetch c_lvs_lgr_grp_fahrzeug into out_res_id;
                            close c_lvs_lgr_grp_fahrzeug;
                        end if;

                        update isi_transport tra
                        set
                            tra.res_id = nvl(out_res_id, tra.res_id),
                            tra.lgr_platz_ziel = in_neues_ziel,
                            tra.lgr_ort_ziel = v_lgr_ziel.lgr_ort,
                            tra.lgr_verwendung_ziel = v_lgr_ziel.lgr_verwendung,
                            tra.transp_typ = v_transport.transp_typ
                        where
                                tra.sid = in_sid
                            and tra.firma_nr = in_firma_nr
                            and tra.transp_id = in_transport_id;

                        lvs_platz_einl_disp_setzen(v_lte, v_lgr_ziel);
                        lvs_p_lte.lvs_te_lagerziel_umbuchen_353(in_sid, -- in_sid                    in isi_sid.sid%TYPE,
                                                                in_firma_nr, -- in_firma_nr               in isi_firma.firma_nr%TYPE,
                                                                v_transport.lte_id, -- in_lte_id                 in lvs_lte.lte_id%TYPE,
                                                                v_lte.lgr_platz, -- in_ist_lgr_platz          in lvs_lgr.lgr_platz%TYPE,
                                                                v_lte.lgr_ort, -- in_ist_lgr_ort            in lvs_lgr.lgr_ort%TYPE,
                                                                v_lte.lgr_platz_gruppe, -- in_ist_lgr_platz_gruppe   in lvs_lgr.lgr_platz_gruppe%TYPE,
                                                                v_lgr_ziel.lgr_platz, -- in_soll_lgr_platz         in lvs_lgr.lgr_platz%TYPE,
                                                                v_lgr_ziel.lgr_ort, -- in_soll_lgr_ort           in lvs_lgr.lgr_ort%TYPE,
                                                                c.lte_et_stat, -- in_lte_status             in lvs_lte.lte_status%TYPE,
                                                                v_lte.lte_status, -- in_lte_ist_Status         in lvs_lte.lte_status%TYPE,
                                                                v_lte.ziel_lgr_platz_n_freif,
                                                    -- in_ziel_lgr_platz_n_freif in lvs_lte.ziel_lgr_platz_n_freif%type,
                                                                v_lte.ziel_lgr_ort_n_freif, -- in_ziel_lgr_ort_n_freif   in lvs_lte.ziel_lgr_ort_n_freif%type,
                                                                v_lte.lte_letzte_buchung, -- in_l_buchung              in lvs_lte.lte_letzte_buchung%type,
                                                                v_transport.auf_id, -- in_auf_id                 in isi_order_pos.auf_id%type,
                                                                v_transport.vorgang_id, -- in_vorgang_id             in isi_order_pos.vorgang_id%type,
                                                                null, -- in_artikel_id             in isi_artikel.artikel_id%type) is
                                                                v_transport.transport_gruppe,
                                                                v_transport.lkw_nr,
                                                                v_lte.lte_offset_x,
                                                                v_lte.lte_offset_y,
                                                                lvs_platz.lvs_get_lgr_offset_z(v_lte.lgr_platz) + v_lte.lte_vol_hoehe
                                                                );

                    end if;

                end if;

            end if;

        else
            v_ret_value := c.transport_fehlt;
        end if;

        if v_ret_value = 0 then
            commit;
        else
            rollback;
        end if;
        return ( v_ret_value );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_neues_ziel;

  --------------------------------------------------------------------------------
  -- procedure LVS_c.TRANSP_FERTIG
  -- Transport mit der ID xx ist fertig Palette Platz und evtl. Order wird gebucht
  --------------------------------------------------------------------------------
    function lvs_c_transp_fertig (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_lte_id       in lvs_lte.lte_id%type,
        in_res_id       in isi_resource.res_id%type,
        in_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_ausgelagert  in varchar2
    ) return integer is
        v_ret_value integer; -- return value
    begin
        v_ret_value := lvs_c_transp_fertig_353(in_sid, in_firma_nr, in_user_id, in_transport_id, in_lte_id,
                                               in_res_id, in_lgr_platz, in_ausgelagert, null, null,
                                               null);

        return ( v_ret_value );
    end lvs_c_transp_fertig;

    function lvs_c_transp_fertig_353 (
        in_sid          in isi_sid.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_user_id      in isi_user.login_id%type,
        in_transport_id in isi_transport.transp_id%type,
        in_lte_id       in lvs_lte.lte_id%type,
        in_res_id       in isi_resource.res_id%type,
        in_lgr_platz    in lvs_lgr.lgr_platz%type,
        in_ausgelagert  in varchar2,
        in_offset_x     in lvs_lte.lte_offset_x%type,
        in_offset_y     in lvs_lte.lte_offset_y%type,
        in_offset_z     in lvs_lte.lte_offset_z%type
    ) return integer is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_ret_value integer; -- return value
    begin
        v_ret_value := lvs_transport.lvs_transp_fertig_353(in_sid, in_firma_nr, in_user_id, in_transport_id, in_lte_id,
                                                           in_res_id, in_lgr_platz, in_ausgelagert, in_offset_x, in_offset_y,
                                                           in_offset_z);

        if v_ret_value = 0 then
            commit;
        else
            rollback;
        end if;
        return ( v_ret_value );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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

    end lvs_c_transp_fertig_353;

    procedure c_lvs_lte_transport_353 (
        in_lte_id        in lvs_lte.lte_id%type,
        in_von_lgr_platz in lvs_lgr.lgr_platz%type,
        in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
        in_user_id       in isi_user.login_id%type,
        in_offset_x      in lvs_lte.lte_offset_x%type,
        in_offset_y      in lvs_lte.lte_offset_y%type,
        in_offset_z      in lvs_lte.lte_offset_z%type
    ) is
    begin
        lvs_transport.lvs_lte_transport_353(in_lte_id, in_von_lgr_platz, in_zu_lgr_platz, in_user_id, in_offset_x,
                                            in_offset_y, in_offset_z);

        commit;
    end;

  --------------------------------------------------------------------------------
  -- procedure LVS_SUCHE_UM_PLATZ
  -- suche Umlagerplatz fuer Freifaheren etc.
  --------------------------------------------------------------------------------
    procedure lvs_suche_um_platz (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_lvs_akt_lgr             in lvs_lgr%rowtype,
        in_fahrzeuge_ids           in varchar2,
        out_lvs_lgr                out lvs_lgr%rowtype
    ) is

        v_found              boolean;
        v_error exception;
        v_err_nr             pls_integer;
        v_err_text           varchar2(2550);
        v_reservierung       lvs_lte.res_string%type;
        v_lgr_platz          lvs_lgr.lgr_platz%type;
        v_lgr_dim_platz_ref  lvs_lgr.lgr_dim_platz%type;
        v_ausl_dispo_faktor  number;
        v_ausl_dispo_bestand number;
        v_dat                date;
        v_faktor_akt         number;
        v_firma              isi_firma%rowtype;
        v_lgr_ort            lvs_lgr_ort%rowtype;
        v_fuellgrad_seg_akt  number;
        v_lgr_platz_grp      lvs_lgr.lgr_platz_gruppe%type;
        v_lgr_dim_fifo_nr    lvs_lgr.lgr_dim_fifo_nr%type;

    -- fuer Kanaele und Sat-Lager
        cursor c_um_lgr_kanal is
        select /*+ first_rows(25) */
            min(lgr.lgr_dim_fifo_nr),
       -- Ermitteln eines idealen Lagerplatz
            lvs_platz_bewerten(in_lvs_akt_lgr.sid,
                               in_lvs_akt_lgr.firma_nr,
                               in_lvs_akt_lgr.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               in_lvs_akt_lgr.lgr_dim_platz,
                               in_lvs_akt_lgr.lgr_ort,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               min(lgr.lgr_platz),
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               null,
                               null,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               min(lgr.lgr_dim_t),
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               min(lgr.lgr_dim_platz),
                               max(lgr.lgr_max_kg),
                               min(lgr.lgr_akt_kg),
                               max(lgr.lgr_frei_hoehe),
                               max(lgr.lgr_frei_breite),
                               max(lgr.lgr_frei_tiefe))   as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor()  as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor,
            lvs_lager_opt.lvs_platz_faktor_belegung_akt() as faktor_belegung_akt,
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ = in_lvs_akt_lgr.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and lgr.lgr_platz_gruppe <> in_lvs_akt_lgr.lgr_platz_gruppe
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
            and nvl(lgr.lgr_gruppe_id, -1) = nvl(in_lvs_akt_lgr.lgr_gruppe_id, -1)
            -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
            and ( lgr.lgr_dim_r = in_lvs_akt_lgr.lgr_dim_r
                  or lgr.uml_erlaubt = 'T' )
            and (
                select
                    sum(decode(v_ignor_einl_suche_uml,
                               1,
                               0,
                               decode(t.transp_typ, 'E', lgr_grp.lgr_dispo_einl_te, 0)))
                from
                    lvs_lgr       lgr_grp,
                    isi_transport t
                where
                        lgr_grp.sid = lgr.sid
                    and lgr_grp.lgr_platz_gruppe = lgr.lgr_platz_gruppe
                    and lgr_grp.lgr_platz = t.lgr_platz_ziel (+)
                group by
                    lgr_grp.lgr_platz_gruppe
            ) = 0
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
        group by
            lgr.lgr_platz_gruppe,
            lgr.res_string,
            lgr.res_artikel_id,
            lgr.abc,
            lgr.lgr_res_strat,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e,
            lo.strat_platz_r_faktor
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            regal_ebene_faktor asc,
            lgr.lgr_dim_p * lo.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc;
    -- fuer Kanal - Block-Lager
        cursor c_um_lgr_kanal_block is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
       -- Ermitteln eines idealen Lagerplatz
       -- Ermitteln eines idealen Lagerplatz
            lvs_platz_bewerten(in_lvs_akt_lgr.sid,
                               in_lvs_akt_lgr.firma_nr,
                               in_lvs_akt_lgr.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               in_lvs_akt_lgr.lgr_dim_platz,
                               in_lvs_akt_lgr.lgr_ort,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               null,
                               null,
                               in_lvs_akt_lgr.lgr_dim_g,
                               in_lvs_akt_lgr.lgr_dim_r,
                               in_lvs_akt_lgr.lgr_dim_p,
                               in_lvs_akt_lgr.lgr_dim_e,
                               in_lvs_akt_lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe) as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ = in_lvs_akt_lgr.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and lgr.lgr_platz <> in_lvs_akt_lgr.lgr_platz
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
            and nvl(lgr.lgr_gruppe_id, -1) = nvl(in_lvs_akt_lgr.lgr_gruppe_id, -1)
            -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
            and ( lgr.lgr_dim_r = in_lvs_akt_lgr.lgr_dim_r
                  or lgr.uml_erlaubt = 'T' )
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
        order by
            ausl_dispo_faktor desc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr asc,
            lgr.lgr_dim_p * lo.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc;

        cursor c_lgr_durchl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(in_lvs_akt_lgr.sid,
                               in_lvs_akt_lgr.firma_nr,
                               in_lvs_akt_lgr.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               in_lvs_akt_lgr.lgr_dim_platz,
                               in_lvs_akt_lgr.lgr_ort,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_true,
                               null,
                               in_fahrzeuge_ids,
                               null,
                               null,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe) as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_p * lo.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer Einzelplatz - Lager
        cursor c_lgr_epl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(in_lvs_akt_lgr.sid,
                               in_lvs_akt_lgr.firma_nr,
                               in_lvs_akt_lgr.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               in_lvs_akt_lgr.lgr_dim_platz,
                               in_lvs_akt_lgr.lgr_ort,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               null,
                               null,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe) as ausl_dispo_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ = in_lvs_akt_lgr.lgr_typ
            and ( lgr.lgr_verwendung = c.lgr_typ_lager
                  or lgr.lgr_verwendung = c.lgr_typ_lagerp )
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
            and nvl(lgr.lgr_gruppe_id, -1) = nvl(in_lvs_akt_lgr.lgr_gruppe_id, -1)
            -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
            and ( lgr.lgr_dim_r = in_lvs_akt_lgr.lgr_dim_r
                  or lgr.uml_erlaubt = 'T' )
            and lgr.lgr_platz <> in_lvs_akt_lgr.lgr_platz
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            lgr.lgr_dim_p * lo.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc;

    -- fuer Sateliten Einzelplatz - Lager
        cursor c_lgr_sat_epl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz_bewerten(in_lvs_akt_lgr.sid,
                               in_lvs_akt_lgr.firma_nr,
                               in_lvs_akt_lgr.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               in_lvs_akt_lgr.lgr_dim_platz,
                               in_lvs_akt_lgr.lgr_ort,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               null,
                               null,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe)        as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor()  as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor,
            lgr.lgr_einl_te_verfueg_gruppe                as fuellgrad_seg,
            lvs_lager_opt.lvs_platz_faktor_belegung_akt() as faktor_belegung_akt
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ = in_lvs_akt_lgr.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
            and nvl(lgr.lgr_gruppe_id, -1) = nvl(in_lvs_akt_lgr.lgr_gruppe_id, -1)
            -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
            and ( lgr.lgr_dim_r = in_lvs_akt_lgr.lgr_dim_r
                  or lgr.uml_erlaubt = 'T' )
            and lgr.lgr_platz <> in_lvs_akt_lgr.lgr_platz
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            regal_ebene_faktor asc,
            fuellgrad_seg asc,
            lgr.lgr_dim_p * lo.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer sonstige z.B. Blocklager
        cursor c_um_lgr_block is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
       -- Ermitteln eines idealen Lagerplatz
            lvs_platz_bewerten(in_lvs_akt_lgr.sid,
                               in_lvs_akt_lgr.firma_nr,
                               in_lvs_akt_lgr.lgr_typ,
                               decode(lgr.lgr_res_strat,
                                      'O',
                                      nvl(
                to_char(in_lte.transport_gruppe),
                in_lte.res_string
            ),
                                      in_lte.res_string),
                               in_lte.res_artikel_id,
                               in_lte.abc,
                               in_lte.waren_typ,
                               lgr.lgr_platz_gruppe,
                               lgr.res_artikel_id,
                               lgr.res_string,
                               lgr.abc,
                               in_lvs_akt_lgr.lgr_dim_platz,
                               in_lvs_akt_lgr.lgr_ort,
                               in_lte.lte_akt_kg,
                               in_lte.lte_vol_hoehe,
                               in_lte.lte_vol_tiefe,
                               in_lte.lte_vol_breite,
                               lgr.lgr_platz,
                               c.c_false,
                               null,
                               in_fahrzeuge_ids,
                               null,
                               null,
                               lgr.lgr_dim_g,
                               lgr.lgr_dim_r,
                               lgr.lgr_dim_p,
                               lgr.lgr_dim_e,
                               lgr.lgr_dim_t,
                               v_ort.lgr_dim_r_g_u_gegenueber,
                               lgr.lgr_dim_platz,
                               lgr.lgr_max_kg,
                               lgr.lgr_akt_kg,
                               lgr.lgr_frei_hoehe,
                               lgr.lgr_frei_breite,
                               lgr.lgr_frei_tiefe)        as ausl_dispo_faktor,
       -- Ermitteln eines idealen Lagerplatz
            lvs_lager_opt.lvs_platz_bestand_ausl_faktor() as ausl_dispo_bestand,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor
        from
            lvs_lgr     lgr,
            lvs_lgr_ort lo
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and ( lgr.res_art_statisch = c.c_false
                  or ( lgr.res_art_statisch = c.c_true
                       and lgr.res_artikel_id = in_lte.res_artikel_id ) )
            ---- -AG- 16.01.05 Ausreichend Platz und Tragkraft
            --and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            --and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            --and lgr.lgr_ >= in_lte.lte_vol_breite
            --and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            ---- -AG- 16.01.05 Ende Platz und Tragkraft
            --and lgr.lgr_typ = in_lvs_akt_lgr.lgr_typ
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and lgr.lgr_platz <> in_lvs_akt_lgr.lgr_platz
            and nvl(lgr.lgr_gruppe_id, -1) = nvl(in_lvs_akt_lgr.lgr_gruppe_id, -1)
            -- AG 19.06.2015 Erweiterung Umlagern Nur im gleichen Regal neuer Wert (R)
            and ( lgr.lgr_dim_r = in_lvs_akt_lgr.lgr_dim_r
                  or lgr.uml_erlaubt = 'T' )
            and ( instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
                  or instr(
                nvl(lgr.lte_namen, in_lte.lte_name),
                in_lte.lte_name
            ) > 0 )
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
            and lgr.sid = lo.sid
            and lgr.firma_nr = lo.firma_nr
            and lgr.lgr_ort = lo.lgr_ort
        order by
            ausl_dispo_faktor asc,
            ausl_dispo_bestand desc,
            abstand_faktor asc,
            lgr.lgr_dim_p * lo.strat_platz_r_faktor /* c.LGR_PLATZ_R_FAKTOR */ asc;

        cursor c_lgr_in_grp is -- Lesen des Lagerplatz
        select /*+ first_rows(1) */
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz_gruppe = v_lgr_platz_grp
            and lgr.lgr_dim_fifo_nr = v_lgr_dim_fifo_nr
            and lgr.lgr_dim_g = out_lvs_lgr.lgr_dim_g
            and lgr.lgr_dim_r = out_lvs_lgr.lgr_dim_r
            and lgr.lgr_dim_e = out_lvs_lgr.lgr_dim_e
            and lgr.lgr_dim_p = out_lvs_lgr.lgr_dim_p
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.sid = in_lte.sid;

    -- the good criterion
        cursor c_um_lgr is
        select /*+ first_rows(1) */
            lgr.*
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lvs_akt_lgr.sid
            and lgr.firma_nr = in_lvs_akt_lgr.firma_nr
            and lgr.lgr_ort = in_lvs_akt_lgr.lgr_ort
            and lgr.lgr_platz = v_lgr_platz;

        cursor c_firma is
        select
            *
        from
            isi_firma t
        where
                t.sid = in_lte.sid
            and t.firma_nr = in_lte.firma_nr;

    begin
    -- Lesen der Artikeldaten
        v_err_nr := null;
        v_err_text := null;
        v_faktor_akt := 1;
        if not lvs_p_base.get_lgr_ort(in_lvs_akt_lgr.sid, in_lvs_akt_lgr.firma_nr, in_lvs_akt_lgr.lgr_ort, v_lgr_ort) then
            v_lgr_ort := null;
        end if;

        v_ort := v_lgr_ort;
        lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab_empty;
    --lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab := lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab_empty;

        if in_lte.lte_voll = c.lte_voll_a then
            open c_firma;
            fetch c_firma into v_firma;
            close c_firma;
        else
            v_firma := null;
        end if;

    -- first step suche einen idealen Platz unter Betrachtung vom RES_String und der Auslager_DISPO's auf diesen
        if in_lvs_akt_lgr.lgr_typ = c.sat1
        or in_lvs_akt_lgr.lgr_typ = c.kanal1
      -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
        or in_lvs_akt_lgr.lgr_typ = c.seg1
        or in_lvs_akt_lgr.lgr_typ = c.seg_duedo1 then
      -- Kanal oder SAT-Lager
            open c_um_lgr_kanal;
            loop
                fetch c_um_lgr_kanal into
                    v_lgr_dim_fifo_nr,
                    v_ausl_dispo_faktor,
                    v_dat_lgr_regal_ebene_faktor,
                    v_lgr_dim_platz_ref,
                    v_faktor_akt,
                    v_lgr_platz_grp,
                    out_lvs_lgr.lgr_dim_g,
                    out_lvs_lgr.lgr_dim_r,
                    out_lvs_lgr.lgr_dim_p,
                    out_lvs_lgr.lgr_dim_e;

                begin
                    open c_lgr_in_grp;
                    fetch c_lgr_in_grp into out_lvs_lgr;
                    v_found := c_lgr_in_grp%found;
                    close c_lgr_in_grp;
                    if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                    or (
                        in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                        and v_firma.res_string_anbruch is not null
                        and v_faktor_akt > v_lgr_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING*/
                    ) then
                        if v_err_text is null then
                            if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                       in_lte.lte_id,
                                                       to_char(v_faktor_akt),
                                                       to_char(v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                       out_lvs_lgr.lgr_platz);

                            else
                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, out_lvs_lgr.lgr_platz, v_firma.res_string_anbruch
                                );
                            end if;
                        end if;

                        v_found := false;
                    end if;

                    if v_found then
                        v_found := false;
                        lvs_platz_einl_pruefen_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, out_lvs_lgr, 'U',
                                                   in_fahrzeuge_ids);
                        v_found := true;
                    end if;

                exception
                    when others then
                        v_err_nr := 10;
                end;

                exit when c_um_lgr_kanal%notfound
                or v_found;
            end loop;

            close c_um_lgr_kanal;
        elsif in_lvs_akt_lgr.lgr_typ = c.kanal_bkl1
        or in_lvs_akt_lgr.lgr_typ = c.reg_fach1
        or in_lvs_akt_lgr.lgr_typ = c.stap_flae1
        or in_lvs_akt_lgr.lgr_typ = c.stap_flae2 then
      -- Kanal-Blocklager
            open c_um_lgr_kanal_block;
            loop
                fetch c_um_lgr_kanal_block into
                    v_lgr_platz,
                    v_ausl_dispo_faktor,
                    v_dat,
                    v_lgr_dim_platz_ref;
                begin
                    open c_um_lgr;
                    fetch c_um_lgr into out_lvs_lgr;
                    v_found := c_um_lgr%found;
                    close c_um_lgr;
                    if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                    or (
                        in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                        and v_firma.res_string_anbruch is not null
                        and v_faktor_akt > v_lgr_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING*/
                    ) then
                        if v_err_text is null then
                            if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                       in_lte.lte_id,
                                                       to_char(v_faktor_akt),
                                                       to_char(v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                       out_lvs_lgr.lgr_platz);

                            else
                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, out_lvs_lgr.lgr_platz, v_firma.res_string_anbruch
                                );
                            end if;
                        end if;

                        v_found := false;
                    end if;

                    if v_found then
                        v_found := false;
                        lvs_platz_einl_pruefen_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, out_lvs_lgr, 'U',
                                                   in_fahrzeuge_ids);
                        v_found := true;
                        if
                            v_ort.lgr_typ = c.stap_flae1
                            and ( out_lvs_lgr.lgr_frei_breite - v_lgr_ort.lgr_ort_raster_x > in_lte.lte_vol_breite
                            or out_lvs_lgr.lgr_frei_tiefe - v_lgr_ort.lgr_ort_raster_y > in_lte.lte_vol_tiefe )
                        then
                            v_found := false;
                        end if;

                        if ( nvl(out_lvs_lgr.lgr_min_lte_hoehe, 0) > in_lte.lte_vol_hoehe
                        or nvl(out_lvs_lgr.lgr_min_lte_breite, 0) > in_lte.lte_vol_breite
                        or nvl(out_lvs_lgr.lgr_min_lte_tiefe, 0) > in_lte.lte_vol_tiefe ) then
                            v_found := false;
                        end if;

                    end if;

                exception
                    when others then
                        v_err_nr := 20;
                end;

                exit when c_um_lgr_kanal_block%notfound
                or v_found;
            end loop;

            close c_um_lgr_kanal_block;
        elsif in_lvs_akt_lgr.lgr_typ = c.durchl1 then
      -- Kanal-Blocklager oder Regalfach
            open c_lgr_durchl;
            loop
                fetch c_lgr_durchl into
                    v_lgr_platz,
                    v_ausl_dispo_faktor,
                    v_dat,
                    v_lgr_dim_platz_ref;
                begin
                    open c_um_lgr;
                    fetch c_um_lgr into out_lvs_lgr;
                    v_found := c_um_lgr%found;
                    close c_um_lgr;
                    if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                    or (
                        in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                        and v_firma.res_string_anbruch is not null
                        and v_faktor_akt > v_lgr_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING*/
                    ) then
                        if v_err_text is null then
                            if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                       in_lte.lte_id,
                                                       to_char(v_faktor_akt),
                                                       to_char(v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                       out_lvs_lgr.lgr_platz);

                            else
                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, out_lvs_lgr.lgr_platz, v_firma.res_string_anbruch
                                );
                            end if;
                        end if;

                        v_found := false;
                    end if;

                    if v_found then
                        v_found := false;
                        lvs_platz_einl_pruefen_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, out_lvs_lgr, 'U',
                                                   in_fahrzeuge_ids);
                        v_found := true;
                    end if;

                exception
                    when others then
                        v_err_nr := 20;
                end;

                exit when c_lgr_durchl%notfound
                or ( v_found );
            end loop;

            close c_lgr_durchl;
        elsif in_lvs_akt_lgr.lgr_typ = c.epl1
        or in_lvs_akt_lgr.lgr_typ = c.pp_epl1 then
      -- Einzelplatz
            open c_lgr_epl;
            loop
                fetch c_lgr_epl into
                    v_lgr_platz,
                    v_ausl_dispo_faktor,
                    v_lgr_dim_platz_ref;
                v_found := c_lgr_epl%found;
                begin
                    open c_um_lgr;
                    fetch c_um_lgr into out_lvs_lgr;
                    v_found := c_um_lgr%found;
                    close c_um_lgr;
                    if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                    or (
                        in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                        and v_firma.res_string_anbruch is not null
                        and v_faktor_akt > v_lgr_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING*/
                    ) then
                        if v_err_text is null then
                            if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                                v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                       in_lte.lte_id,
                                                       to_char(v_faktor_akt),
                                                       to_char(v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                       out_lvs_lgr.lgr_platz);

                            else
                                v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, out_lvs_lgr.lgr_platz, v_firma.res_string_anbruch
                                );
                            end if;
                        end if;

                        v_found := false;
                    end if;

                    if v_found then
                        v_found := false;
                        lvs_platz_einl_pruefen_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, out_lvs_lgr, 'U',
                                                   in_fahrzeuge_ids);
                        v_found := true;
                    end if;

                exception
                    when others then
                        v_err_nr := 30;
                end;

                exit when c_lgr_epl%notfound
                or v_found;
            end loop;

            close c_lgr_epl;
        elsif in_lvs_akt_lgr.lgr_typ = c.sat_epl1
        or in_lvs_akt_lgr.lgr_typ = c.sat_epl2
    -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
    -- or in_lvs_akt_lgr.lgr_typ = c.SEG1
    -- or in_lvs_akt_lgr.lgr_typ = c.SEG_DUEDO1
         then
      -- Einzelplatz
            open c_lgr_sat_epl;
            loop
                fetch c_lgr_sat_epl into
                    v_lgr_platz,
                    v_ausl_dispo_faktor,
                    v_dat_lgr_regal_ebene_faktor,
                    v_lgr_dim_platz_ref,
                    v_fuellgrad_seg_akt,
                    v_faktor_akt;
                v_found := c_lgr_sat_epl%found;
                begin
                    open c_um_lgr;
                    fetch c_um_lgr into out_lvs_lgr;
                    v_found := c_um_lgr%found;
                    close c_um_lgr;
                    if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */
                    or (
                        in_lte.res_string = nvl(v_firma.res_string_anbruch, 'x')
                        and v_firma.res_string_anbruch is not null
                        and v_faktor_akt > v_lgr_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING*/
                    ) then
                        if v_faktor_akt > v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */ then
                            v_err_text := lc.ec_p4(lc.o_tp4_lgr_platz_max_fakt_err,
                                                   in_lte.lte_id,
                                                   to_char(v_faktor_akt),
                                                   to_char(v_lgr_ort.strat_platz_factor_max /* c.LGR_PLATZ_FACTOR_MAX */),
                                                   out_lvs_lgr.lgr_platz);
                        else
                            v_err_text := lc.ec_p3(lc.o_tp3_lgr_platz_res_anbr_err, in_lte.lte_id, out_lvs_lgr.lgr_platz, v_firma.res_string_anbruch
                            );
                        end if;

                        v_found := false;
                    end if;

                    if v_found then
                        v_found := false;
                        lvs_platz_einl_pruefen_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, out_lvs_lgr, 'U',
                                                   in_fahrzeuge_ids);
                        v_found := true;
                    end if;

                exception
                    when others then
                        v_err_nr := 30;
                end;

                exit when c_lgr_sat_epl%notfound
                or v_found;
            end loop;

            close c_lgr_sat_epl;
        else
      -- z.B. Blocklager
            open c_um_lgr_block;
            loop
                fetch c_um_lgr_block into
                    v_lgr_platz,
                    v_ausl_dispo_faktor,
                    v_ausl_dispo_bestand,
                    v_lgr_dim_platz_ref;
                begin
                    open c_um_lgr;
                    fetch c_um_lgr into out_lvs_lgr;
                    v_found := c_um_lgr%found;
                    close c_um_lgr;
                    if v_found then
                        v_found := false;
                        lvs_platz_einl_pruefen_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, out_lvs_lgr, 'U',
                                                   in_fahrzeuge_ids);
                        v_found := true;
                    end if;

                exception
                    when others then
                        v_err_nr := 40;
                end;

                exit when c_um_lgr_block%notfound
                or v_found;
            end loop;

            close c_um_lgr_block;
        end if;

        if not v_found then
            v_err_nr := c.fmid_kein_platz_fuer_lte;
            v_err_text := lc.ec_p1(lc.o_tp1_lgr_f_lte_n_gefunden, in_lte.lte_id);
            raise_application_error(-20000 - v_err_nr, v_err_text);
        end if;

    end lvs_suche_um_platz;

    procedure lvs_platz_pruefen (
        in_sid           in isi_sid.sid%type,
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        in_module_bearb  in lvs_lgr_ort.lgr_ort_modul%type,
        in_einl_ausl     in varchar2,
        in_fahrzeuge_ids in varchar2
    ) is

        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(2550);
        v_found          boolean;
        v_lte            lvs_lte%rowtype; -- Daten LTE (Palette)
        v_lgr            lvs_lgr%rowtype; -- Daten Lagerplatz
        v_lgr_ort        lvs_lgr_ort%rowtype; -- Daten Lagerort

        v_lte_cfg        lvs_lte_cfg%rowtype;
        v_basis_lte_name lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.firma_nr = v_lte.firma_nr
            and t.lte_name = v_lte.lte_name;

        cursor c_lgr is
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.lgr_platz = in_lgr_platz;

        cursor c_lgr_ort is
        select
            *
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_sid
            and ort.lgr_ort = v_lgr.lgr_ort;

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
                lte.sid = in_sid
            and lte.lte_id = in_lte_id;

    begin
        v_err_nr := null;
        v_err_text := null;
        open c_lgr;
        fetch c_lgr into v_lgr; -- Lese Lagerplatzdaten
        v_found := c_lgr%found;
        close c_lgr;
        if v_found then
            open c_lgr_ort;
            fetch c_lgr_ort into v_lgr_ort; -- Lese Lagerortdaten
            v_found := c_lgr_ort%found;
            close c_lgr_ort;
            if v_lgr_ort.lgr_ort_modul != in_module_bearb then
                v_err_nr := c.fmid_falscher_bearbmodul;
                v_err_text := lc.ec_p4(lc.o_tp4_lgr_ort_falsches_modul, v_lgr.lgr_ort, in_lgr_platz, v_lgr_ort.lgr_ort_modul, in_module_bearb
                );

                raise v_error;
            end if;

            if v_found then
                open c_lte;
                fetch c_lte into v_lte; -- Lese Lagerortdaten
                v_found := c_lte%found;
                close c_lte;
                if v_found then
                    open c_lte_cfg;
                    fetch c_lte_cfg into v_lte_cfg;
                    close c_lte_cfg;
                    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
                    if in_einl_ausl = c.lte_einl then
                        lvs_platz_einl_pruefen_r30(v_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, v_lgr, 'U',
                                                   in_fahrzeuge_ids);
                    elsif in_einl_ausl = c.lte_ausl then
                        null; -- Immer OK
                    else
                        v_err_nr := c.fmid_falsche_buchungsart;
                        v_err_text := lc.ec_p1(lc.o_tp1_bewegungsart_falsch, in_einl_ausl);
                        raise v_error;
                    end if;

                else
                    v_err_nr := c.fmid_lte_id_fehlt;
                    v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
                    raise v_error;
                end if;

            else
                v_err_nr := c.fmid_keine_lagerorte;
                v_err_text := lc.ec_p2(lc.o_tp2_lgr_ort_fuer_platz_fehlt, v_lgr.lgr_ort, in_lgr_platz);
                raise v_error;
            end if;

        else
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt, in_lgr_platz);
            raise v_error;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_pruefen;

    procedure lvs_c_platz_aendern (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lgr_ort              in lvs_lgr.lgr_ort%type,
        in_lgr_platz_alt        in lvs_lgr.lgr_platz%type,
        in_lgr_platz_neu        in lvs_lgr.lgr_platz%type,
        in_lgr_platz_gruppe_neu in lvs_lgr.lgr_platz_gruppe%type,
        in_pos_x                in lvs_lgr.lgr_pos_x%type,
        in_pos_y                in lvs_lgr.lgr_pos_y%type,
        in_dim_p                in lvs_lgr.lgr_dim_p%type,
        in_dim_t                in lvs_lgr.lgr_dim_t%type,
        in_hoehe                in lvs_lgr.lgr_vol_hoehe%type,
        in_breite               in lvs_lgr.lgr_vol_breite%type,
        in_tiefe                in lvs_lgr.lgr_vol_breite%type,
        in_lte_min_hoehe        in lvs_lgr.lgr_min_lte_hoehe%type,
        in_lte_min_breite       in lvs_lgr.lgr_min_lte_breite%type,
        in_lte_min_tiefe        in lvs_lgr.lgr_min_lte_tiefe%type,
        in_lte_max_te           in lvs_lgr.lgr_max_te%type,
        in_gesperrt             in lvs_lgr.gesperrt%type,
        in_abc                  in lvs_lgr.abc%type,
        login_id                in lvs_lgr.lgr_usr_id_erstellt%type
    ) is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_found    boolean;
        v_lgr      lvs_lgr%rowtype;
        cursor c_lvs_lgr is
        select
            t.*
        from
            lvs_lgr t
        where
                t.lgr_ort = in_lgr_ort
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_platz = in_lgr_platz_alt;

    begin
        open c_lvs_lgr;
        fetch c_lvs_lgr into v_lgr;
        v_found := c_lvs_lgr%found;
        close c_lvs_lgr;
        if not v_found then
            v_err_nr := c.fmid_ziel_voll;
            v_err_text := lc.ec(lc.o_tp1_lagerplatz_fehlt);
            raise v_error;
        end if;

        if ( v_lgr.lgr_akt_te > 0 )
        or ( v_lgr.lgr_dispo_einl_te > 0 ) then
            v_err_nr := c.fmid_ziel_voll;
            v_err_text := lc.ec(lc.o_tp1_lagerplatz_fehlt);
            raise v_error;
        end if;

        if v_lgr.lgr_typ = c.stap_flae1
        or v_lgr.lgr_typ = c.stap_flae2 then
            v_lgr.lgr_dim_g := 1; -- Kann nur gang 1
            v_lgr.lgr_dim_r := 1; -- Kann nur regal 1
            v_lgr.lgr_dim_e := 0; -- Kann nur ebebe 0
        end if;

    -- nur Löschen wenn keine Dispos und keine Inhalte auf einer Lagerplatz Gruppe !!!
        if v_found then
            update lvs_lgr
            set
                sid = in_sid,
                lgr_platz = in_lgr_platz_neu,
                lgr_platz_gruppe = in_lgr_platz_gruppe_neu,
                lgr_pos_x = in_pos_x,
                lgr_pos_y = in_pos_y,
                abc = in_abc,
                gesperrt = in_gesperrt,
                lgr_vol_breite = in_breite,
                lgr_vol_tiefe = in_tiefe,
                lgr_vol_hoehe = in_hoehe, -- Bugfix 18.09.2012
                lgr_max_te = in_lte_max_te,
                lgr_einl_te_verfueg = in_lte_max_te,
                lgr_frei_breite = in_breite,
                lgr_frei_tiefe = in_tiefe,
                lgr_frei_hoehe = in_hoehe,
                lgr_min_lte_breite = in_lte_min_breite,
                lgr_min_lte_tiefe = in_lte_min_tiefe,
                lgr_min_lte_hoehe = in_lte_min_hoehe,
                lgr_dim_g = v_lgr.lgr_dim_g,
                lgr_dim_r = v_lgr.lgr_dim_r,
                lgr_dim_p = in_dim_p,
                lgr_dim_e = v_lgr.lgr_dim_e,
                lgr_dim_t = in_dim_t
            where
                    lgr_platz = in_lgr_platz_alt
                and sid = in_sid
                and firma_nr = in_firma_nr;

            commit;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_c_platz_aendern;

    procedure lvs_c_platz_klonen (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lgr_ort              in lvs_lgr.lgr_ort%type,
        in_klonen_von_lgr_platz in lvs_lgr.lgr_platz%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lgr_platz_gruppe     in lvs_lgr.lgr_platz_gruppe%type,
        in_pos_x                in lvs_lgr.lgr_pos_x%type,
        in_pos_y                in lvs_lgr.lgr_pos_y%type,
        in_dim_p                in lvs_lgr.lgr_dim_p%type,
        in_dim_t                in lvs_lgr.lgr_dim_t%type,
        in_hoehe                in lvs_lgr.lgr_vol_hoehe%type,
        in_breite               in lvs_lgr.lgr_vol_breite%type,
        in_tiefe                in lvs_lgr.lgr_vol_breite%type,
        in_abc                  in lvs_lgr.abc%type,
        login_id                in lvs_lgr.lgr_usr_id_erstellt%type
    ) is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_found    boolean;
        v_lgr      lvs_lgr%rowtype;
        cursor c_lvs_lgr is
        select
            t.*
        from
            lvs_lgr t
        where
                t.lgr_ort = in_lgr_ort
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_platz = in_klonen_von_lgr_platz;

    begin
        open c_lvs_lgr;
        fetch c_lvs_lgr into v_lgr;
        v_found := c_lvs_lgr%found;
        close c_lvs_lgr;
        if not v_found then
            v_err_nr := c.fmid_ziel_voll;
            v_err_text := lc.ec(lc.o_tp1_lagerplatz_fehlt);
            raise v_error;
        end if;

    -- nur Löschen wenn keine Dispos und keine Inhalte auf einer Lagerplatz Gruppe !!!
        if v_found then
            insert into lvs_lgr (
                sid,
                firma_nr,
                lgr_platz,
                lgr_platz_gruppe,
                lgr_ort,
                lgr_dim_g,
                lgr_dim_r,
                lgr_dim_p,
                lgr_dim_e,
                lgr_dim_t,
                lgr_dim_platz,
                lgr_dim_fifo_nr,
                lgr_typ,
                lgr_verwendung,
                lgr_res_strat,
                lgr_vol_hoehe,
                lgr_vol_breite,
                lgr_vol_tiefe,
                lgr_frei_hoehe,
                lgr_frei_breite,
                lgr_frei_tiefe,
                lgr_max_te,
                lgr_einl_te_verfueg,
                uml_erlaubt,
                res_art_statisch,
                lgr_akt_te,
                lgr_dispo_einl_te,
                lgr_dispo_ausl_te,
                lgr_max_kg,
                lgr_akt_kg,
                lgr_dispo_einl_kg,
                lgr_dispo_ausl_kg,
                lgr_dat_erstellt,
                lgr_usr_id_erstellt,
                gesperrt,
                abc,
                gruppe,
                wa_typ,
                wert_klasse,
                gefahren_klasse,
                lgr_pos_x,
                lgr_pos_y,
                lgr_min_lte_hoehe,
                lgr_min_lte_breite,
                lgr_min_lte_tiefe,
                lgr_gruppe_id
            ) values ( in_sid,
                       in_firma_nr,
                       in_lgr_platz,
                       in_lgr_platz_gruppe,
                       in_lgr_ort,
                       v_lgr.lgr_dim_g,
                       v_lgr.lgr_dim_r,
                       in_dim_p, --v_lgr.lgr_dim_p,
                       in_dim_t, --v_lgr.lgr_dim_t,
                       in_hoehe, --lgr_dim_t,
                       v_lgr.lgr_dim_platz,
                       v_lgr.lgr_dim_fifo_nr,
                       v_lgr.lgr_typ,
                       v_lgr.lgr_verwendung,
                       v_lgr.lgr_res_strat,
                       in_hoehe, --lgr_vol_hoehe,
                       in_breite, --lgr_vol_breite,
                       in_tiefe, -- lgr_vol_tiefe,
                       in_hoehe, -- lgr_frei_hoehe,
                       in_breite, -- lgr_,
                       in_tiefe, --lgr_frei_tiefe,
                       v_lgr.lgr_max_te,
                       v_lgr.lgr_max_te, --lgr_einl_te_verfueg,
                       v_lgr.uml_erlaubt, --uml_erlaubt
                       v_lgr.res_art_statisch, --res_art_statisch
                       0, -- lgr_akt_te,
                       0, -- lgr_dispo_einl_te,
                       0, --lgr_dispo_ausl_te,
                       v_lgr.lgr_max_kg,
                       0, --lgr_akt_kg,
                       0, --lgr_dispo_einl_kg,
                       0, --lgr_dispo_ausl_kg,
                       sysdate, --lgr_dat_erstellt,
                       login_id, --lgr_usr_id_erstellt,
                       v_lgr.gesperrt, -- gesperrt,
                       in_abc,
                       v_lgr.gruppe,
                       v_lgr.wa_typ,
                       v_lgr.wert_klasse,
                       v_lgr.gefahren_klasse,
                       in_pos_x,
                       in_pos_y,
                       v_lgr.lgr_min_lte_hoehe,
                       v_lgr.lgr_min_lte_breite,
                       v_lgr.lgr_min_lte_tiefe,
                       v_lgr.lgr_gruppe_id );

            commit;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_c_platz_klonen;

    procedure lvs_c_platz_gruppe_loeschen (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_lgr_ort          in lvs_lgr.lgr_ort%type,
        in_lgr_platz_gruppe in lvs_lgr.lgr_platz_gruppe%type
    ) is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_found    boolean;
        v_lgr      lvs_lgr%rowtype;
        cursor c_lvs_lgr is
        select
            t.*
        from
            lvs_lgr t
        where
                t.lgr_ort = in_lgr_ort
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_platz_gruppe = in_lgr_platz_gruppe
            and ( t.lgr_akt_te > 0
                  or t.lgr_dispo_einl_te > 0 );

    begin
        open c_lvs_lgr;
        fetch c_lvs_lgr into v_lgr;
        v_found := c_lvs_lgr%found;
        close c_lvs_lgr;
        if v_found then
            v_err_nr := c.fmid_ziel_voll;
            v_err_text := lc.ec(lc.o_txt_lgr_m_dispo_o_lte);
            raise v_error;
        end if;
    -- nur Löschen wenn keine Dispos und keine Inhalte auf einer Lagerplatz Gruppe !!!
        if not v_found then
            delete lvs_lgr t
            where
                    t.lgr_ort = in_lgr_ort
                and t.sid = in_sid
                and t.firma_nr = in_firma_nr
                and t.lgr_platz_gruppe = in_lgr_platz_gruppe;

            commit;
        end if;

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_c_platz_gruppe_loeschen;

    procedure lvs_c_platz_loeschen (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_lgr_ort       in lvs_lgr.lgr_ort%type,
        in_von_lgr_dim_g in lvs_lgr.lgr_dim_g%type,
        in_bis_lgr_dim_g in lvs_lgr.lgr_dim_g%type,
        in_von_lgr_dim_r in lvs_lgr.lgr_dim_r%type,
        in_bis_lgr_dim_r in lvs_lgr.lgr_dim_r%type,
        in_von_lgr_dim_p in lvs_lgr.lgr_dim_p%type,
        in_bis_lgr_dim_p in lvs_lgr.lgr_dim_p%type,
        in_von_lgr_dim_e in lvs_lgr.lgr_dim_e%type,
        in_bis_lgr_dim_e in lvs_lgr.lgr_dim_e%type,
        in_von_lgr_dim_t in lvs_lgr.lgr_dim_t%type,
        in_bis_lgr_dim_t in lvs_lgr.lgr_dim_t%type
    ) is

        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_lgr      lvs_lgr%rowtype;
        cursor c_lvs_lgr is
        select
            t.*
        from
            lvs_lgr t
        where
                t.lgr_ort = in_lgr_ort
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_dim_g between in_von_lgr_dim_g and in_bis_lgr_dim_g
            and t.lgr_dim_r between in_von_lgr_dim_r and in_bis_lgr_dim_r
            and t.lgr_dim_p between in_von_lgr_dim_p and in_bis_lgr_dim_p
            and t.lgr_dim_e between in_von_lgr_dim_e and in_bis_lgr_dim_e
            and t.lgr_dim_t between in_von_lgr_dim_t and in_bis_lgr_dim_t
        order by
            t.lgr_platz;

    begin
        open c_lvs_lgr;
        fetch c_lvs_lgr into v_lgr;
        loop
            exit when c_lvs_lgr%notfound;
            if v_lgr.lgr_akt_te != 0 then
                v_err_text := lc.ec_p1(lc.o_tp1_lgr_platz_n_leer, v_lgr.lgr_platz);
                v_err_nr := 10;
                close c_lvs_lgr;
                raise v_error;
            end if;

            if v_lgr.lgr_dispo_einl_te != 0 then
                v_err_text := lc.ec_p1(lc.o_txt_lgr_m_dispo, v_lgr.lgr_platz);
                v_err_nr := 20;
                close c_lvs_lgr;
                raise v_error;
            end if;

            fetch c_lvs_lgr into v_lgr;
        end loop;

        close c_lvs_lgr;
        delete lvs_lgr t
        where
                t.lgr_ort = in_lgr_ort
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.lgr_dim_g between in_von_lgr_dim_g and in_bis_lgr_dim_g
            and t.lgr_dim_r between in_von_lgr_dim_r and in_bis_lgr_dim_r
            and t.lgr_dim_p between in_von_lgr_dim_p and in_bis_lgr_dim_p
            and t.lgr_dim_e between in_von_lgr_dim_e and in_bis_lgr_dim_e
            and t.lgr_dim_t between in_von_lgr_dim_t and in_bis_lgr_dim_t;

        commit;
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_c_platz_loeschen;

    function lvs_suche_flaechenplatz (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_lgr_ort   in lvs_lgr.lgr_ort%type,
        in_out_pos_x in out lvs_lgr.lgr_pos_x%type,
        in_out_pos_y in out lvs_lgr.lgr_pos_y%type,
        out_breite   out lvs_lgr.lgr_vol_breite%type,
        out_tiefe    out lvs_lgr.lgr_vol_tiefe%type
    ) return varchar2 is

        v_error exception;
        v_err_nr    number;
        v_err_text  varchar2(2550);
        v_found     boolean;
        v_lgr_platz lvs_lgr.lgr_platz%type;
        v_lgr       lvs_lgr%rowtype;
        cursor c_lvs_lgr is
        select
            t.*
        from
            lvs_lgr t
        where
                t.lgr_ort = in_lgr_ort
            and t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and ( t.lgr_pos_x - ( t.lgr_vol_breite / 2 ) < in_out_pos_x ) -- X Pos ist die Mitte des Lagerplatzes
            and ( t.lgr_pos_x + ( t.lgr_vol_breite / 2 ) > in_out_pos_x ) -- X Pos ist die Mitte des Lagerplatzes
            and ( t.lgr_pos_y - ( t.lgr_vol_tiefe / 2 ) < in_out_pos_y )
            and ( t.lgr_pos_y + ( t.lgr_vol_tiefe / 2 ) > in_out_pos_y )
            and t.lgr_verwendung = 'Lager';

    begin
        v_lgr_platz := '';
        open c_lvs_lgr;
        fetch c_lvs_lgr into v_lgr;
        v_found := c_lvs_lgr%found;
        close c_lvs_lgr;
        if v_found then
            v_lgr_platz := v_lgr.lgr_platz;
        end if;
        in_out_pos_x := v_lgr.lgr_pos_x;
        in_out_pos_y := v_lgr.lgr_pos_y;
        return ( v_lgr_platz );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_suche_flaechenplatz;

    function lvs_get_lgr_offset_z (
        in_lgr_platz in lvs_lgr.lgr_platz%type
    ) return number is
        v_error exception;
        v_err_nr   number;
        v_err_text varchar2(2550);
        v_lgr      lvs_lgr%rowtype;
        v_ret_val  number;
    begin
        if lvs_p_base.get_lgr_platz(in_lgr_platz, v_lgr) then
            v_ret_val := null;
            if v_lgr.lgr_typ = c.stap_flae1
            or v_lgr.lgr_typ = c.stap_flae2 then
                select
                    nvl(
                        max(t.lte_offset_z),
                        0
                    )
                into v_ret_val
                from
                    lvs_lte t
                where
                    t.lgr_platz = in_lgr_platz;

            end if;

        end if;

        return ( v_ret_val );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_get_lgr_offset_z;

    function lvs_platz_bewerten_ext (
        in_sid                 in lvs_lgr.sid%type,
        in_firma_nr            in lvs_lgr.firma_nr%type,
        in_lgr_ort_typ         in lvs_lgr.lgr_typ%type,
        in_res_string          in lvs_lte.res_string%type,
        in_lte_res_art         in lvs_lte.res_artikel_id%type,
        in_lte_abc             in lvs_lte.abc%type,
        in_lte_waren_typ       in lvs_lte.waren_typ%type,
        in_lgr_platz_gruppe    in lvs_lgr.lgr_platz_gruppe%type,
        in_lgr_res_artikel_id  in lvs_lgr.res_artikel_id%type,
        in_lgr_res_string      in lvs_lgr.res_string%type,
        in_lgr_abc             in lvs_lgr.abc%type,
        in_ref_dim_lager_platz in lvs_lgr.lgr_dim_platz%type,
        in_ref_dim_lager_ort   in lvs_lgr.lgr_ort%type,
        in_lte_lte_akt_kg      in lvs_lte.lte_akt_kg%type,
        in_lte_lte_vol_hoehe   in lvs_lte.lte_vol_hoehe%type,
        in_lte_lte_vol_tiefe   in lvs_lte.lte_vol_tiefe%type,
        in_lte_lte_vol_breite  in lvs_lte.lte_vol_breite%type,
        in_lgr_platz           in lvs_lgr.lgr_platz%type,
        in_lgr_opti            in lvs_lgr_ort.lgr_einl_opti%type,
        in_sych_transport      in isi_transport.lgr_platz_quelle%type,
        in_fahrzeuge_ids       in varchar2,
        in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
        in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
        in_lgr_dim_g           in lvs_lgr.lgr_dim_g%type,
        in_lgr_dim_r           in lvs_lgr.lgr_dim_r%type,
        in_lgr_dim_p           in lvs_lgr.lgr_dim_p%type,
        in_lgr_dim_e           in lvs_lgr.lgr_dim_e%type,
        in_lgr_dim_t           in lvs_lgr.lgr_dim_t%type,
        in_r_g_u_gegenueber    in lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type,
        in_dim_platz           in lvs_lgr.lgr_dim_platz%type,
        in_max_kg              in lvs_lgr.lgr_max_kg%type,
        in_akt_kg              in lvs_lgr.lgr_akt_kg%type,
        in_frei_hoehe          in lvs_lgr.lgr_frei_hoehe%type,
        in_frei_breite         in lvs_lgr.lgr_frei_breite%type,
        in_frei_tiefe          in lvs_lgr.lgr_frei_tiefe%type,
        in_lgr_ort             in lvs_lgr.lgr_ort%type
    ) return number is
    -------------------------------------------------------------------------
        v_error exception;
        v_err_nr                     number;
        v_err_text                   varchar2(2550);
        v_ref_dim_lager_platz        lvs_lgr.lgr_dim_platz%type;
        v_found                      boolean;
        v_fuellgrad                  number;
        v_fuellgrad_seg              number;
        v_multiplikator              number;
        v_sum_lgr_dispo_ausl_te      lvs_lgr.lgr_dispo_ausl_te%type;
        v_sum_lgr_order_res_te       lvs_lgr.lgr_order_res_te%type;
        v_res_string_faktor          number;
        v_dispo_faktor_seg           number;
        v_lgr_regal_ebene_faktor_seg number;
        v_lgr_dim_platz_seg          lvs_lgr.lgr_dim_platz%type;
    --v_lgr_dim_ort_seg                 lvs_lgr.lgr_ort%type;
        v_max_kg_seg                 lvs_lgr.lgr_max_kg%type;
        v_akt_kg_seg                 lvs_lgr.lgr_akt_kg%type;
        v_frei_hoehe_seg             lvs_lgr.lgr_frei_hoehe%type;
        v_frei_breite_seg            lvs_lgr.lgr_frei_breite%type;
        v_frei_tiefe_seg             lvs_lgr.lgr_frei_tiefe%type;
        v_fuellgrad_seg_akt          number;
        v_sonst_faktor               number;
        v_dispo_faktor               number;
        v_lgr_platz_gegenueber       lvs_lgr.lgr_platz_gruppe_gegenueber%type;
        v_lgr_gruppe                 lvs_lgr.gruppe%type;
        v_lgr_dim_platz              lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_platz_calc         lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_tiefe              lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_p                  lvs_lgr.lgr_dim_p%type;
        v_lgr_dim_t                  lvs_lgr.lgr_dim_platz%type;
    --v_lgr_dim_ort              lvs_lgr.lgr_ort%type;
        v_max_kg                     lvs_lgr.lgr_max_kg%type;
        v_akt_kg                     lvs_lgr.lgr_akt_kg%type;
        v_max_te                     lvs_lgr.lgr_max_te%type;
        v_akt_te                     lvs_lgr.lgr_akt_te%type;
        v_diff                       number;
        v_frei_hoehe                 lvs_lgr.lgr_frei_hoehe%type;
        v_frei_breite                lvs_lgr.lgr_frei_breite%type;
        v_frei_tiefe                 lvs_lgr.lgr_frei_tiefe%type;
        v_lgr_dim_fifo               lvs_lgr.lgr_dim_fifo_nr%type;
        v_lgr_einl_te_v              lvs_lgr.lgr_einl_te_verfueg%type;
        v_lgr_ausl_te_d              lvs_lgr.lgr_einl_te_verfueg%type;
        v_r_g_u_gegenueber           lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type;
        v_lvs_platz_bew_use_dispo    varchar2(1);
        cursor c_ort is -- Lesen des Lagerort
        select /*+ first_rows(1) */
            *
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_sid
            and ort.firma_nr = in_firma_nr
            and ort.lgr_ort = in_lgr_ort;

        cursor c_lgr_kanal_o_dispo is
        select
            sum(nvl(lgr2.lgr_dispo_ausl_te, 0)),
            sum(nvl(lgr2.lgr_order_res_te, 0)),
            ( decode(
                nvl(in_lgr_res_string, ''),
                     -- Jetzt sind die werte im Lagerort
                in_res_string,
                min(v_ort.strat_platz_res_string), -- C.LGR_PLATZ_RES_STRING,
                decode(in_lgr_res_string,
                       null,
                       min(v_ort.strat_platz_leer), -- C.LGR_PLATZ_LEER,
                       decode(in_lgr_res_string,
                              c.lgr_m_k,
                              min(v_ort.strat_platz_misch_kanal), -- C.LGR_PLATZ_MISCH_KANAL,
                              decode(in_lgr_res_string,
                                     c.lgr_m_p,
                                     min(v_ort.strat_platz_falsch), -- C.LGR_PLATZ_MISCH_PAL,
                                     min(v_ort.strat_platz_falsch) -- c.LGR_PLATZ_FALSCH
                                     )))
            ) ) as res_string_faktor,
            decode(in_lte_waren_typ,
                   c.fertigware,
                   min(v_ort.strat_regal_hoehe_fw), -- C.LGR_HOEHE_FW_WERT,
                   decode(in_lte_waren_typ,
                          c.rohware,
                          min(v_ort.strat_regal_hoehe_rw), -- C.LGR_HOEHE_RW_WERT,
                          decode(in_lte_waren_typ,
                                 c.halbware,
                                 min(v_ort.strat_regal_hoehe_hw), -- C.LGR_HOEHE_HW_WERT,
                                 decode(in_lte_waren_typ,
                                        c.mischpal,
                                        min(v_ort.strat_regal_hoehe_mp), -- C.LGR_HOEHE_MP_WERT,
                                        0)))) * min(lgr2.lgr_dim_e),
            min(lgr2.lgr_dim_platz),
            sum(lgr2.lgr_max_te),
            sum(lgr2.lgr_akt_te),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe),
            max(lgr2.lgr_einl_te_verfueg_gruppe)
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and ( ( lgr2.lgr_dim_g = in_lgr_dim_g
                    and lgr2.lgr_dim_r = in_lgr_dim_r
                    and lgr2.lgr_dim_p = in_lgr_dim_p
                    and lgr2.lgr_dim_e = in_lgr_dim_e )
                  or ( lgr2.lgr_typ != c.seg1
                       and lgr2.lgr_typ != c.seg_duedo1 ) )
        group by
            lgr2.lgr_platz_gruppe,
            lgr2.abc;

        cursor c_lgr_kanal is
        select
            ( ( sum(lgr2.lgr_dispo_ausl_te * v_ort.strat_platz_ausl_dispo /* C.LGR_PLATZ_AUSL_DISPO */) + 1 ) + sum(nvl(lgr2.lgr_order_res_te
            , 0) * v_ort.strat_order_reservierung /*C.LGR_ORDER_RESERVIERUNG*/) ) * ( decode(
                nvl(in_lgr_res_string, ''),
                     -- Jetzt sind die werte im Lagerort
                in_res_string,
                min(v_ort.strat_platz_res_string), -- C.LGR_PLATZ_RES_STRING,
                decode(in_lgr_res_string,
                       null,
                       min(v_ort.strat_platz_leer), -- C.LGR_PLATZ_LEER,
                       decode(in_lgr_res_string,
                              c.lgr_m_k,
                              min(v_ort.strat_platz_misch_kanal), -- C.LGR_PLATZ_MISCH_KANAL,
                              decode(in_lgr_res_string,
                                     c.lgr_m_p,
                                     min(v_ort.strat_platz_falsch), -- C.LGR_PLATZ_MISCH_PAL,
                                     min(v_ort.strat_platz_falsch) -- c.LGR_PLATZ_FALSCH
                                     )))
            ) ) as ausl_dispo_faktor,
            decode(in_lte_waren_typ,
                   c.fertigware,
                   min(v_ort.strat_regal_hoehe_fw), -- C.LGR_HOEHE_FW_WERT,
                   decode(in_lte_waren_typ,
                          c.rohware,
                          min(v_ort.strat_regal_hoehe_rw), -- C.LGR_HOEHE_RW_WERT,
                          decode(in_lte_waren_typ,
                                 c.halbware,
                                 min(v_ort.strat_regal_hoehe_hw), -- C.LGR_HOEHE_HW_WERT,
                                 decode(in_lte_waren_typ,
                                        c.mischpal,
                                        min(v_ort.strat_regal_hoehe_mp), -- C.LGR_HOEHE_MP_WERT,
                                        0)))) * min(lgr2.lgr_dim_e),
            min(lgr2.lgr_dim_platz),
            sum(lgr2.lgr_max_te),
            sum(lgr2.lgr_akt_te),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe),
            max(lgr2.lgr_einl_te_verfueg_gruppe)
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and ( ( lgr2.lgr_dim_g = in_lgr_dim_g
                    and lgr2.lgr_dim_r = in_lgr_dim_r
                    and lgr2.lgr_dim_p = in_lgr_dim_p
                    and lgr2.lgr_dim_e = in_lgr_dim_e )
                  or ( lgr2.lgr_typ != c.seg1
                       and lgr2.lgr_typ != c.seg_duedo1 ) )
        group by
            lgr2.lgr_platz_gruppe,
            lgr2.abc;

        cursor c_lgr_kanal_block is
        select
            max(lte.lte_letzte_buchung),
            min(lgr2.lgr_dim_platz),
            min(lgr2.lgr_dim_p),
            min(lgr2.lgr_dim_t),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe)
        from
            lvs_lte lte,
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lte.res_artikel_id (+) = to_char(in_lte_res_art)
            and lte.lgr_platz (+) = lgr2.lgr_platz
        group by
            lte.lgr_platz_gruppe,
            lgr2.lgr_ort; --,
    --lgr2.lgr_dim_platz,
    --lgr2.lgr_max_kg, lgr2.lgr_akt_kg,
    --lgr2.lgr_frei_hoehe, lgr2.lgr_, lgr2.lgr_frei_tiefe;
        cursor c_lgr_block is
        select
            count(lte.lte_id) + count(lte2.lte_id)      as ausl_dispo_faktor,
            ( decode((power((count(lte.lte_id) + count(lte2.lte_id)) * min(v_ort.strat_lgr_platz_akt_lte) /* C.LGR_PLATZ_AKT_LTE */,
                            2)),
                     0,
                     decode(
                              sum(lgr2.lgr_max_te),
                              sum(lgr2.lgr_einl_te_verfueg),
                              1,
                              0.001
                          ),
                     (power((count(lte.lte_id) + count(lte2.lte_id)) * min(v_ort.strat_lgr_platz_akt_lte) /* C.LGR_PLATZ_AKT_LTE */,
                            2))) * ( sum(lgr2.lgr_einl_te_verfueg) * min(v_ort.strat_lgr_platz_verfueg) /* C.LGR_PLATZ_VERFUEG */ + 1
                            ) ) / ( ( sum(lgr2.lgr_dispo_ausl_te) * min(v_ort.strat_platz_ausl_dispo) /* C.LGR_PLATZ_AUSL_DISPO */ + 1
                            + nvl(
                sum(lgr2.lgr_order_res_te),
                0
            ) * min(v_ort.strat_order_reservierung) /*C.LGR_ORDER_RESERVIERUNG*/ ) ) as ausl_dispo_bestand,
            nvl(
                max(lte2.lte_letzte_buchung),
                max(lte.lte_letzte_buchung)
            )                                           l_buchung,
            min(lgr2.lgr_dim_platz),
            max(lgr2.lgr_max_kg),
            min(lgr2.lgr_akt_kg),
            max(lgr2.lgr_frei_hoehe),
            max(lgr2.lgr_frei_breite),
            max(lgr2.lgr_frei_tiefe)
        from
            lvs_lgr lgr2,
            lvs_lte lte,
            lvs_lte lte2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
            and lte.sid (+) = in_sid
            and lte.firma_nr (+) = in_firma_nr
            and lte.lgr_platz_gruppe (+) = lgr2.lgr_platz_gruppe
            and lte.res_artikel_id (+) = in_lte_res_art
            and lte2.sid (+) = in_sid
            and lte2.firma_nr (+) = in_firma_nr
            and lte2.ziel_lgr_platz (+) = lgr2.lgr_platz
            and lte2.res_artikel_id (+) = in_lte_res_art
        group by
            lgr2.lgr_ort,
            lgr2.lgr_platz_gruppe,
                -- -AG- --lgr2.lgr_dim_platz,
            lte.lgr_platz_gruppe,
            lte2.lgr_platz_gruppe;

        cursor c_lgr_epl is
        select
            lgr2.lgr_dim_platz,
            lgr2.lgr_max_kg,
            lgr2.lgr_akt_kg,
            lgr2.lgr_frei_hoehe,
            lgr2.lgr_frei_breite,
            lgr2.lgr_frei_tiefe
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe;

        cursor c_lgr_sat_epl_platz is
        select
            lgr.lgr_dim_platz,
            lgr.lgr_dim_p,
            lgr.lgr_max_kg,
            lgr.lgr_akt_kg,
            lgr.lgr_frei_hoehe,
            lgr.lgr_frei_breite,
            lgr.lgr_frei_tiefe,
            lgr.lgr_dim_fifo_nr,
            lgr.gruppe,
            lgr.lgr_platz_gruppe_gegenueber,
            decode(in_lte_waren_typ,
                   c.fertigware,
                   v_ort.strat_regal_hoehe_fw, -- C.LGR_HOEHE_FW_WERT,
                   decode(in_lte_waren_typ,
                          c.rohware,
                          v_ort.strat_regal_hoehe_rw, -- C.LGR_HOEHE_RW_WERT,
                          decode(in_lte_waren_typ,
                                 c.halbware,
                                 v_ort.strat_regal_hoehe_hw, -- C.LGR_HOEHE_HW_WERT,
                                 decode(in_lte_waren_typ, c.mischpal, v_ort.strat_regal_hoehe_mp, -- C.LGR_HOEHE_MP_WERT,
                                  0)))) * lgr.lgr_dim_e,
            lgr.lgr_einl_te_verfueg_gruppe
        from
            lvs_lgr lgr
        where
                lgr.sid = in_sid
            and lgr.firma_nr = in_firma_nr
            and lgr.lgr_platz = in_lgr_platz;

        cursor c_lgr_sat_epl_gegenueber is
        select
            lgr2.lgr_einl_te_verfueg,
            lgr2.lgr_dispo_ausl_te
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.lgr_platz = v_lgr_platz_gegenueber;

        cursor c_lgr_sat_epl_gruppe is
        select
            sum(lgr2.lgr_einl_te_verfueg),
            sum(lgr2.lgr_dispo_ausl_te)
        from
            lvs_lgr lgr2
        where
                lgr2.sid = in_sid
            and lgr2.firma_nr = in_firma_nr
            and lgr2.gruppe = v_lgr_gruppe
            and lgr2.lgr_dispo_ausl_te > 0
        group by
            lgr2.gruppe;

    begin
        open c_ort;
        fetch c_ort into v_ort;
        v_found := c_ort%found;
        close c_ort;
        v_sum_lgr_dispo_ausl_te := 0;
    -- CMe 20220317 (P71141-94): Prüfen in der CFG ob die Disponioerung eines Platzes berücksichtigt wird
        v_lvs_platz_bew_use_dispo := isi_allg.get_firma_cfg_param(in_sid, in_firma_nr, 'LVS_PLATZ_BEWERTEN', 'LVS', 'LVS_PLATZ_BEWERTEN_USE_DISPO'
        ,
                                                                  'LVS', 'CFG', 'T', 'BOOLEAN');

        v_ref_dim_lager_platz := in_ref_dim_lager_platz;
        v_r_g_u_gegenueber := in_r_g_u_gegenueber;
        if v_r_g_u_gegenueber = c.c_true then
            v_ref_dim_lager_platz := v_ref_dim_lager_platz / 1000000000000;
            if mod(
                abs(v_ref_dim_lager_platz),
                2
            ) = 1 -- Regal Ungrade4 auf grade setzen für Abstand
             then
                v_ref_dim_lager_platz := in_ref_dim_lager_platz + 1000000000000;
            else
                v_ref_dim_lager_platz := in_ref_dim_lager_platz;
            end if;

        else
            v_r_g_u_gegenueber := c.c_false;
        end if;

        v_dat_lgr_l_buchung := null;
        v_dat_lgr_bestand_ausl_faktor := null;
        v_lgr_abstand_faktor := 0;
        v_sonst_faktor := 0;
        v_fuellgrad_seg := 1000;

    -- Erst mal die Daten lesen

        if in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.kanal1
        or in_lgr_ort_typ = c.durchl1
      -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
        or in_lgr_ort_typ = c.seg1 -- Segmetlager müssen wie Kanäle betrachtet werden
        or in_lgr_ort_typ = c.seg_duedo1 -- die jedoch eine Gruppe über mehrere Kanaele haben
         then
            if ( v_lvs_platz_bew_use_dispo = 'T' ) then
                open c_lgr_kanal;
                fetch c_lgr_kanal into
                    v_dispo_faktor,
                    v_dat_lgr_regal_ebene_faktor,
                    v_lgr_dim_platz,
                    v_max_te,
                    v_akt_te,
                    v_max_kg,
                    v_akt_kg,
                    v_frei_hoehe,
                    v_frei_breite,
                    v_frei_tiefe,
                    v_fuellgrad_seg_akt;

                v_found := c_lgr_kanal%found;
                close c_lgr_kanal;
            else
                open c_lgr_kanal_o_dispo;
                fetch c_lgr_kanal_o_dispo into
                    v_sum_lgr_dispo_ausl_te,
                    v_sum_lgr_order_res_te,
                    v_res_string_faktor,
                    v_dat_lgr_regal_ebene_faktor,
                    v_lgr_dim_platz,
                    v_max_te,
                    v_akt_te,
                    v_max_kg,
                    v_akt_kg,
                    v_frei_hoehe,
                    v_frei_breite,
                    v_frei_tiefe,
                    v_fuellgrad_seg_akt;

                v_found := c_lgr_kanal_o_dispo%found;
                close c_lgr_kanal_o_dispo;
                v_dispo_faktor := 1;
            end if;
      -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
            if in_lgr_ort_typ = c.seg1 -- Segmetlager müssen wie Kanäle betrachtet werden
            or in_lgr_ort_typ = c.seg_duedo1 -- die jedoch eine Gruppe über mehrere Kanaele haben
             then
                v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
        --v_dispo_faktor := v_dispo_faktor / 100;
        --v_dispo_faktor := v_dispo_faktor / v_fuellgrad_seg;
            end if;

        elsif in_lgr_ort_typ = c.kanal_bkl1
        or in_lgr_ort_typ = c.reg_fach1
        or in_lgr_ort_typ = c.stap_flae1
        or in_lgr_ort_typ = c.stap_flae2 then
            open c_lgr_kanal_block;
            fetch c_lgr_kanal_block into
                v_dat_lgr_l_buchung,
                v_lgr_dim_platz,
                v_lgr_dim_p,
                v_lgr_dim_t,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe;

            v_found := c_lgr_kanal_block%found;
            close c_lgr_kanal_block;
            if
                v_found
                and v_dat_lgr_l_buchung is not null
            then
                v_dispo_faktor := v_ort.strat_platz_res_string; -- C.LGR_PLATZ_RES_STRING;
            else
                v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
            end if;

            v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
        elsif in_lgr_ort_typ = c.pp_epl1 then
            v_lgr_dim_platz := in_dim_platz;
            v_max_kg := in_max_kg;
            v_akt_kg := in_akt_kg;
            v_frei_hoehe := in_frei_hoehe;
            v_frei_breite := in_frei_breite;
            v_frei_tiefe := in_frei_tiefe;
            v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
      --ToDo Hier den Platz richtig bewerten
            v_found := true;
        elsif in_lgr_ort_typ = c.epl1 then
      -- Bei Einzelplatz kann es nur Leere Plätze geben !!!
            v_lgr_dim_platz := in_dim_platz;
            v_max_kg := in_max_kg;
            v_akt_kg := in_akt_kg;
            v_frei_hoehe := in_frei_hoehe;
            v_frei_breite := in_frei_breite;
            v_frei_tiefe := in_frei_tiefe;
            v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
            v_found := true;
        elsif in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2
    -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
    -- or in_lgr_ort_typ = c.SEG1         -- Segmetlager müssen wie Kanäle betrachtet werden
    -- or in_lgr_ort_typ = c.SEG_DUEDO1   -- die jedoch eine Gruppe über mehrere Kanaele haben
         then
      -- Bei Sateliten Einzelplaetzen ist immer Gut, wen der gegenüberliegende Platz frei ist
            open c_lgr_sat_epl_platz;
            fetch c_lgr_sat_epl_platz into
                v_lgr_dim_platz,
                v_lgr_dim_p,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe,
                v_lgr_dim_fifo,
                v_lgr_gruppe,
                v_lgr_platz_gegenueber,
                v_dat_lgr_regal_ebene_faktor,
                v_fuellgrad_seg_akt;

            v_found := c_lgr_sat_epl_platz%found;
            close c_lgr_sat_epl_platz;
            if in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2 then
                if v_found then
                    open c_lgr_sat_epl_gegenueber;
                    fetch c_lgr_sat_epl_gegenueber into
                        v_lgr_einl_te_v,
                        v_lgr_ausl_te_d;
                    v_found := c_lgr_sat_epl_gegenueber%found;
                    close c_lgr_sat_epl_gegenueber;
                    if in_lgr_ort_typ = c.sat_epl1 then
                        if mod(v_lgr_dim_p, 2) != mod(v_lgr_dim_fifo, 2)
                        or v_lgr_einl_te_v = 0 then
                            v_lgr_einl_te_v := null;
                        end if;
                    else
                        if v_lgr_einl_te_v = 0 then
                            v_lgr_einl_te_v := null;
                        end if;
                    end if;

                else
                    v_lgr_einl_te_v := null;
                end if;

                if v_lgr_einl_te_v is null then
                    v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;  -- Einfach nur eine leerer Platz
                else
                    v_dispo_faktor := ( v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ + v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */
                    ) / 2; -- Dann ist das ein besonder guter Platz
                end if;

                if in_lgr_ort_typ = c.sat_epl2 -- Segment der Einzelplätze füllen Komremieren

                 then
                    open c_lgr_kanal;
                    fetch c_lgr_kanal into
                        v_dispo_faktor_seg,
                        v_lgr_regal_ebene_faktor_seg,
                        v_lgr_dim_platz_seg, --v_lgr_dim_ort_seg,
                        v_max_te,
                        v_akt_te,
                        v_max_kg_seg,
                        v_akt_kg_seg,
                        v_frei_hoehe_seg,
                        v_frei_breite_seg,
                        v_frei_tiefe_seg,
                        v_fuellgrad_seg_akt;

                    v_found := c_lgr_kanal%found;
                    close c_lgr_kanal;
                    v_fuellgrad_seg := ( v_akt_te + 1 ) / v_max_te * 1000;
                end if;

                if in_lgr_opti = c.c_true then
                    if v_lgr_ausl_te_d = 1 then
                        v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ / 100; -- Besser geht nicht (Wechselspiel)
                    else
                        if v_lgr_einl_te_v is not null then
                            open c_lgr_sat_epl_gruppe;
                            fetch c_lgr_sat_epl_gruppe into
                                v_lgr_einl_te_v,
                                v_lgr_ausl_te_d;
                            v_found := c_lgr_sat_epl_gruppe%found;
                            close c_lgr_sat_epl_gruppe;
                            if v_found then
                                v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ / 10; -- Besser geht nicht (Wechselspiel)
                            end if;
                        end if;
                    end if;
                end if;

                if in_sych_transport = v_lgr_platz_gegenueber then
                    v_dispo_faktor := v_dispo_faktor / 100;
                    v_dispo_faktor := v_dispo_faktor / v_fuellgrad_seg;
                end if;

            else
                if in_res_string = in_lgr_res_string then
                    v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */;
                else
                    if in_lgr_res_string is null then
                        v_dispo_faktor := v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */;
                    else
                        v_dispo_faktor := v_ort.strat_platz_falsch /* c.LGR_PLATZ_FALSCH*/;
                    end if;
                end if;

                v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
            end if;

        else
            open c_lgr_block;
            fetch c_lgr_block into
                v_dispo_faktor,
                v_dat_lgr_bestand_ausl_faktor,
                v_dat_lgr_l_buchung,
                v_lgr_dim_platz,
                v_max_kg,
                v_akt_kg,
                v_frei_hoehe,
                v_frei_breite,
                v_frei_tiefe;

            v_found := c_lgr_block%found;
            close c_lgr_block;
      --if v_dispo_faktor > 0 then
      --  v_dispo_faktor := C.LGR_PLATZ_RES_STRING;
      --else
      --  v_dispo_faktor := C.LGR_PLATZ_LEER;
      --end if;
            if
                v_found
                and v_dat_lgr_l_buchung is not null
            then
                v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */;
            else
                v_dispo_faktor := v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */;
            end if;

        end if;

        v_faktor_belegung_akt := v_dispo_faktor;
    -- Gewicht und Platz berücksichtigen
        if v_ort.strat_gewicht_relevanz /* c.LGR_GEWICHT_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
        -- Differenz bilden + 1 damit 0 (Nuetral wirkt multiplikation)
                v_diff := nvl(nvl(v_max_kg,
                                  nvl(in_lte_lte_akt_kg, 0)) - nvl(v_akt_kg, 0) - nvl(in_lte_lte_akt_kg, 0),
                              0) + 1;
        -- wenn das Gewicht < 1 dann ist die LTE sowiso zu schwer
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := ( ( v_diff ) * v_ort.strat_gewicht_relevanz /* c.LGR_GEWICHT_RELEVANZ */ );
        end if;
    -- Hoehe
        if v_ort.strat_hoehe_relevanz /* c.LGR_HOEHE_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
                v_diff := nvl(v_frei_hoehe - in_lte_lte_vol_hoehe, 0) + 1;
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_hoehe_relevanz /* c.LGR_HOEHE_RELEVANZ */ );
        end if;
    -- Breite
        if v_ort.strat_breite_relevanz /* c.LGR_BREITE_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
                v_diff := nvl(v_frei_breite - in_lte_lte_vol_breite, 0) + 1;
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_breite_relevanz /* c.LGR_BREITE_RELEVANZ */ );
        end if;
    -- Breite
        if v_ort.strat_tiefe_relevanz /* c.LGR_TIEFE_RELEVANZ */ is not null then
            if in_lgr_ort_typ = c.sat1
            or in_lgr_ort_typ = c.sat_epl1
            or in_lgr_ort_typ = c.sat_epl2
            or in_lgr_ort_typ = c.kanal1
            or in_lgr_ort_typ = c.durchl1
            or in_lgr_ort_typ = c.epl1
            or in_lgr_ort_typ = c.reg_fach1
            or in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2
            or in_lgr_ort_typ = c.seg1
            or in_lgr_ort_typ = c.seg_duedo1
            or in_lgr_ort_typ = c.pp_epl1 then
                v_diff := nvl(v_frei_tiefe - in_lte_lte_vol_tiefe, 0) + 1;
                if v_diff < 1 then
                    v_diff := 5000;
                end if;
            elsif in_lgr_ort_typ = c.kanal_bkl1
            or in_lgr_ort_typ = c.bkl1 then
                v_diff := 1;
            end if;

            v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_tiefe_relevanz /* c.LGR_TIEFE_RELEVANZ */ );
        end if;

        if v_lgr_abstand_faktor = 0 then
            v_lgr_abstand_faktor := 1;
        end if;
        if v_sonst_faktor = 0 then
            v_sonst_faktor := 1;
        end if;
        if v_found then
      -- jetzt ABC
            v_sonst_faktor := v_sonst_faktor * ( abs(in_lgr_abc * v_ort.strat_abc - in_lte_abc * v_ort.strat_abc) + 1 );
      -- jetzt Artikelres
            if in_lte_res_art = to_char(in_lgr_res_artikel_id) then
                v_dispo_faktor := v_dispo_faktor / v_ort.strat_art_res;
            elsif
                in_lte_res_art != to_char(in_lgr_res_artikel_id)
                and in_lgr_res_artikel_id is not null
            then
                v_dispo_faktor := v_dispo_faktor * v_ort.strat_art_res /* C.LGR_ART_RES */;
            end if;

            if v_ort.strat_ort_abstand_faktor /* c.LGR_ORT_ABSTAND_FAKTOR */ < 0 then
                v_lgr_abstand_faktor := v_lgr_abstand_faktor * abs((nvl(
                    abs(v_ort.lgr_ort - in_ref_dim_lager_ort),
                    0
                )) * v_ort.strat_ort_abstand_faktor /* c.LGR_ORT_ABSTAND_FAKTOR */ + 1);
            end if;

            if v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ <= 0 -- Gleiche Ware möglichtst zusammenstellen
            or v_dispo_faktor = v_ort.strat_platz_res_string -- oder Kanal, Platz hat gleichen Reservirungsstring
            or in_lgr_gruppe_id is null -- oder es gibt keine Guppierung im Lager
             then
                if
                    v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ > 0
                    and v_dispo_faktor = v_ort.strat_platz_res_string -- Gleichverteilung und Kanal, Platz hat gleichen Reservirungsstring
                then
          -- dann in jedem Fall zusammenfahren
                    v_multiplikator := -1;
                else
          -- sonst mach was im Parameter steht
                    v_multiplikator := v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */;
                end if;

                v_lgr_dim_platz_calc := v_lgr_dim_platz / 1000000000000;
                if
                    mod(
                        abs(v_lgr_dim_platz_calc),
                        2
                    ) = 1
                    and v_r_g_u_gegenueber = c.c_true
                then
                    v_lgr_dim_platz := v_lgr_dim_platz + 1000000000000;
                end if;

                if in_lgr_ort_typ = c.stap_flae1
                or in_lgr_ort_typ = c.stap_flae2 then
                    if abs(v_lgr_dim_p - in_lgr_dim_p) > abs(v_lgr_dim_t - in_lgr_dim_t) then
                        v_ref_dim_lager_platz := abs(v_lgr_dim_p - in_lgr_dim_p);
                    else
                        v_ref_dim_lager_platz := abs(v_lgr_dim_t - in_lgr_dim_t);
                    end if;

                    v_lgr_abstand_faktor := v_lgr_abstand_faktor * ( abs(v_ref_dim_lager_platz * v_multiplikator) + 1 );
                else
                    v_lgr_abstand_faktor := v_lgr_abstand_faktor * ( abs(nvl(
                        abs(v_lgr_dim_platz - v_ref_dim_lager_platz),
                        0
                    ) * v_multiplikator) + 1 ) / 100000000; -- Tiefe und Platz Rausnehmen;
                end if;

                v_lgr_abstand_faktor := v_lgr_abstand_faktor + v_sonst_faktor;
            else
                if
                    v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ > 0
                    and v_ort.strat_fuellgrad_relevanz /* c.LGR_FUELLGRAD_RELEVANZ */ > 0
                then
                    if lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab.exists(in_lgr_gruppe_id) then
                        v_fuellgrad := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab(in_lgr_gruppe_id);
                    else
                        v_fuellgrad := lvs_p_lgr_grp_fahrzeuge.lgr_grp_fuellgrad(in_sid, -- in_sid                 in isi_sid.sid%type,
                         in_firma_nr, -- in_firma_nr            in isi_firma.firma_nr%type,
                         v_ort.lgr_ort, -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                         in_lgr_gruppe_id, -- in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
                         in_ref_dim_lager_ort, -- in_ref_lgr_ort         in lvs_lgr_ort.lgr_ort%type,
                                                                                 in_ref_lgr_gruppe_id, -- in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
                                                                                  in_res_string -- in_res_string          in    lvs_lte.res_string%type
                                                                                 );

                        lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab(in_lgr_gruppe_id) := v_fuellgrad;
                    end if;
          -- BugFix AG 20.09.2010
          -- v_lgr_abstand_faktor := v_lgr_abstand_faktor - v_sonst_faktor;
                    v_lgr_abstand_faktor := v_lgr_abstand_faktor + v_sonst_faktor;
                    v_lgr_abstand_faktor := v_lgr_abstand_faktor + v_fuellgrad * v_ort.strat_fuellgrad_relevanz /* c.LGR_FUELLGRAD_RELEVANZ */
                    ;
                end if;

                v_last_lgr_ort := v_ort.lgr_ort;
            end if;

        end if;

        if ( in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.kanal1 )
        or ( in_lgr_ort_typ = c.durchl1
        or in_lgr_ort_typ = c.seg1
        or in_lgr_ort_typ = c.seg_duedo1 ) then
            if ( v_lvs_platz_bew_use_dispo = 'F' ) then
                if ( v_sum_lgr_dispo_ausl_te > 0 ) then
                    v_dispo_faktor := v_dispo_faktor + ( ( v_sum_lgr_dispo_ausl_te * v_ort.strat_platz_ausl_dispo ) / 100000 );
                end if;

                if ( v_sum_lgr_order_res_te > 0 ) then
                    v_dispo_faktor := v_dispo_faktor + ( ( v_sum_lgr_order_res_te * v_ort.strat_order_reservierung ) / 100000 );
                end if;

                v_dispo_faktor := v_dispo_faktor * v_res_string_faktor;
            end if;
        end if;

        return ( v_dispo_faktor );
    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then
      -- Update 2011 show Exception Source Line
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
    end lvs_platz_bewerten_ext;

begin
    v_lvs_lgr_ref_platz := null;
end lvs_platz_new;
/


-- sqlcl_snapshot {"hash":"2dfc1f55dec8723006a25281a0567a8ea96d7ff3","type":"PACKAGE_BODY","name":"LVS_PLATZ_NEW","schemaName":"DIRKSPZM32","sxml":""}