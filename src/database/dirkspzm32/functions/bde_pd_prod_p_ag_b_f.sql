create or replace function dirkspzm32.bde_pd_prod_p_ag_b_f (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in isi_firma.firma_nr%type,
    in_leitzahl    in bde_fa_auftrag.leitzahl%type,
    in_fa_ag       in bde_fa_auftrag.fa_ag%type,
    in_fa_upos     in bde_fa_auftrag.fa_upos%type,
    in_res_id      in isi_resource.res_id%type,
    in_akt_term    in isi_arbeitsplatz.ip_name%type,
    in_ls_login_id in isi_user.login_id%type
) return number is
  --------------------------------------------------------------------------------------------------------------------
  -- In dieser Procedure wird der Status der Maschine geändert -- STATUS ist Produktion
  --------------------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------------------------------------
  -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung)
  -- Wenn ein Arbeitsgang begonnen wird, muessen alle geschriebenen LAM_ID für diese Maschine (Tabelle
  -- bde_resource_lam_akt) die nicht das gleiche Rohmaterial referenzieren wie für den neue Auftrag gefordert
  -- gelöscht werden.
  -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung)
  --------------------------------------------------------------------------------------------------------------------

    v_anz_res           number;                 --  Merken ob nur von Ruesten nach Produktion geschaltet wurde; Dann keien zus. Resource
    v_ins_lte_r         lvs_lte.lte_id%type;  --
    v_fa_akt            bde_fa_auftrag%rowtype; --  Lesen FA mit Leitzahl Aktuell
    v_res               isi_resource%rowtype; --  Aktuelle Resource
    v_res_orig          isi_resource%rowtype; --  Aktuelle Resource
    v_lam               lvs_lam%rowtype; --  Lagerbestand
    v_res_zus           isi_resource_zust_akt%rowtype; --  Aktueller Zustands dieser Maschine
    v_sysdate           date; --  Datum und Zeit dieses Vorgangs

    v_s_cfg             isi_res_status_cfg%rowtype; --  Configdaten des Maschinenstatus
    v_pers_nr           isi_resource_zust_akt.pers_nr%type;
    v_menge_a           bde_pd_prod.menge_a%type; --  Für die Summe der GutStück
    v_menge_b           bde_pd_prod.menge_b%type; --  Für die Summe der 2.Wahl
    v_schrott           bde_pd_prod.schrott%type; --  Für die Summe der Schrottmenge

    v_vorg_id           bde_pd_prod.vorg_id%type; --  ID des Vorgangs
    v_found             boolean;
    v_lam_stl           bde_pd_lam_stl_daten%rowtype;      --

    v_lam_lte_waren_typ lvs_lte.waren_typ%type;
    v_lam_lte_leitzahl  lvs_lam.leitzahl%type;
    v_check_funktion    varchar2(28);

  --v_bew_id    s_send_bew.bew_id%type;

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr            number;
    v_err_text          varchar2(255);

  -- Lesen der Resource
    cursor c_resource is
    select
        *
    from
        isi_resource t
    where
        t.res_id = in_res_id;

  -- Lesen der Resource
    cursor c_res_linie is
    select
        *
    from
        isi_resource t
    where
            t.linie_res_id = in_res_id
        and t.typ = 'MS';

  -- Lesen der Resource
    cursor c_res_mpg is
    select
        *
    from
        isi_resource t
    where
            t.gruppe = v_res.gruppe
        and t.typ = 'MS';

  -- Lesen der Statusconfiguration für Rüsten
    cursor c_res_status_cfg is
    select
        *
    from
        isi_res_status_cfg s_cfg
    where
            s_cfg.sid = in_sid
        and s_cfg.firma_nr = in_firma_nr
        and s_cfg.res_st_id = v_res_zus.status_id
        and s_cfg.res_typ = 'MS';

  -- Lesen und Summieren der Produktionsleistung falls der Auftrag nicht von Hand beendet
    cursor c_bde_pd_prod_all is
    select
        sum(menge_a),
        sum(menge_b),
        sum(schrott)
    from
        bde_pd_prod pd_p_all
    where
            pd_p_all.sid = in_sid
        and pd_p_all.res_id = in_res_id
        and pd_p_all.vorg_typ = 'PR'
        and pd_p_all.leitzahl = v_res_zus.leitzahl
        and pd_p_all.fa_ag = v_res_zus.fa_ag
        and nvl(pd_p_all.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
        and pd_p_all.prod_beginn >= v_res_zus.akt_aufgabe_seit
        and pd_p_all.prod_beginn <= v_sysdate
    group by
        pd_p_all.leitzahl;

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

    cursor c_lam_fuer_stl is
    select
        l.*
    from
        lvs_lam l
    where
        l.lam_id = v_lam_stl.stl_lam_id;

  -- Lesen Palette mit Auskunft über Kartons und deren FA's
    cursor c_lam_lte is
    select
        lte.waren_typ,
        decode(
            min(lam.leitzahl),
            max(lam.leitzahl),
            max(lam.leitzahl),
            null
        ) leitzahl
    from
        lvs_lte lte,
        lvs_lam lam
    where
            lte.lte_id = v_res_zus.lte_id
        and lte.lte_id = lam.lte_id (+)
    group by
        lam.lte_id,
        lte.waren_typ;

  -- Holen des aktuellen Zustands dieser Maschine
    cursor c_bde_res_zus is
    select
        *
    from
        isi_resource_zust_akt zust_akt
    where
            zust_akt.sid = in_sid
        and zust_akt.res_id = in_res_id;

    cursor c_lam_stl is
    select
        t.*
    from
        bde_pd_lam_stl_daten t
    where
            t.sid = in_sid
        and t.firma_nr = in_firma_nr
        and t.res_id = in_res_id
        and t.fa_nr = in_leitzahl
        and t.fa_ag = in_fa_ag
        and t.fa_upos = in_fa_upos
        and t.status = 'AP';

begin
  -- -AG- 20210329 - USER-Exit - Prüfen ob Anmeldung möglich
    v_check_funktion := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_FA_AN',           -- in_kategorie             in isi_firma_cfg.kategorie%type,
     null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
     'PRUEFE_BDE_FA_AN_OK', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                       'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                        'NONE',                -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'STRING');             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    if v_check_funktion != 'NONE' -- ggf pruefen ob Aufttrag angemeldet werden kann
     then
        execute immediate 'BEGIN
                '
                          || v_check_funktion
                          || '( :1,  :2,  :3,  :4,  :5);
             END;'
            using in_sid,                     -- :1 in isi_sid.sid%TYPE,
             in_firma_nr,                -- :2 in isi_firma.firma_nr%TYPE,
             in_leitzahl,                -- :3 in bde_fa_auftrag.leitzahl%type,
             in_fa_ag,                   -- :4 in bde_fa_auftrag.fa_ag%type,
             in_fa_upos;                 -- :5 in bde_fa_auftrag.fa_upos%type,
    end if;

    open c_resource;
    fetch c_resource into v_res;
    close c_resource;
    if v_res.typ = 'LI'   -- Res ist eine Linie
     then
    -- -AG- BugFix Original merken
        v_res_orig := v_res;
        open c_res_linie;
        loop
            fetch c_res_linie into v_res;
            exit when c_res_linie%notfound;
            v_res.res_id := bde_pd_prod_p_ag_b_f(in_sid,                -- in_sid         in isi_sid.sid%type,
             in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
             in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
             in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
             in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                                 v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                                                  in_akt_term,           -- in_akt_term    in isi_arbeitsplatz.ip_name%type,
                                                  in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
        end loop;

        close c_res_linie;
        v_res := v_res_orig;
    end if;

    if v_res.typ = 'MPG'  -- Res ist eien Produktionsgruppe

     then
        v_res_orig := v_res;
        open c_res_mpg;
        loop
            fetch c_res_mpg into v_res;
            exit when c_res_mpg%notfound;
            v_res.res_id := bde_pd_prod_p_ag_b_f(in_sid,                -- in_sid         in isi_sid.sid%type,
             in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
             in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
             in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
             in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                                 v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                                                  in_akt_term,           -- in_akt_term    in isi_arbeitsplatz.ip_name%type,
                                                  in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type)
        end loop;

        close c_res_mpg;
        v_res := v_res_orig;
    end if;

    v_anz_res := 1;
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

  -- Gleichen Auftrag ist quatsch!

    if
        in_leitzahl = v_res_zus.leitzahl
        and in_fa_ag = v_res_zus.fa_ag
        and v_res_zus.akt_aufgabe = 'P'
        and nvl(in_fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
    then
        if v_res.typ = 'MS' -- -AG- 27.05.2009 Ist nur dann ein fehler, wenn es sich um eine Maschine handelt
         then
            v_err_nr := 20;
            v_err_text := 'Dieser FA Auftrag ist bereits angemeldet! FA:'
                          || in_leitzahl
                          || '/'
                          || in_fa_ag
                          || '/'
                          || nvl(in_fa_upos, 0);

            raise v_error;
        end if;

        return ( v_vorg_id );
    end if;

    v_menge_a := 0;
    v_menge_b := 0;
    v_schrott := 0;
  -- Ist der letzte Produktionsauftrag nicht abgemeldet
    if v_res_zus.akt_aufgabe = 'P' then
    -- Wegen dem MessageBoard dürfen die Messages nicht so schnell hintereinander kommen.
    -- Deswegen muessen die Aufträge erst abgemeldet werden. Erst nach der Abmeldung darf
    -- der neue Auftrag angemeldet werden
        if v_res.typ = 'MS' -- -AG- 27.05.2009 Ist nur dann ein fehler, wenn es sich um eine Maschine handelt
         then
            v_err_nr := 25;
            v_err_text := 'Dieser FA Auftrag ist noch angemeldet! FA:'
                          || v_res_zus.leitzahl
                          || '/'
                          || v_res_zus.fa_ag
                          || '/'
                          || nvl(v_res_zus.fa_upos, 0);

            raise v_error;
        end if;

        return ( v_vorg_id );
        bde_pd_prod_p_ag_e(in_sid, in_firma_nr, v_res_zus.leitzahl, v_res_zus.fa_ag, v_res_zus.fa_upos,
                           in_res_id, v_sysdate, null, null, null,
                           in_ls_login_id);

    elsif v_res_zus.akt_aufgabe = 'R' then
        if
            v_res_zus.leitzahl = in_leitzahl
            and v_res_zus.fa_ag = in_fa_ag
            and v_res_zus.fa_upos = in_fa_upos
        then
            open c_bde_pd_prod_all;
            fetch c_bde_pd_prod_all into
                v_menge_a,
                v_menge_b,
                v_schrott;
            if c_bde_pd_prod_all%notfound then
                v_menge_a := 0;
                v_menge_b := 0;
                v_schrott := 0;
            end if;

            close c_bde_pd_prod_all;
            update bde_pd_prod pd_p
            set
                pd_p.prod_ende = v_sysdate,
                pd_p.menge_a = v_menge_a,
                pd_p.menge_b = v_menge_b,
                pd_p.schrott = v_schrott
            where
                    pd_p.sid = in_sid
                and pd_p.firma_nr = in_firma_nr
                and pd_p.leitzahl = v_res_zus.leitzahl
                and pd_p.fa_ag = v_res_zus.fa_ag
                and nvl(pd_p.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
                and pd_p.vorg_typ = 'RA'
                and pd_p.prod_ende is null;

            open c_res_status_cfg;
            fetch c_res_status_cfg into v_s_cfg;
            if c_res_status_cfg%notfound then
        -- Nichts gefunden dann auf Undef. setzen
                v_s_cfg.res_st_id := null;
                v_s_cfg.st_gruppe := null;
                v_s_cfg.st_text := null;
            end if;

            close c_res_status_cfg;
            update bde_fa_auftrag fa
            set
                fa.mde_ist_mg = nvl(fa.mde_ist_mg, 0) + nvl(fa.mde_ist_mg_t, 0)
            where
                    fa.sid = in_sid
                and fa.leitzahl = in_leitzahl
                and fa.fa_ag = in_fa_ag
                and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);
      -- Status der Maschine steht auf Rüsen ?
            if v_s_cfg.st_gruppe = 'R' then
        -- Status auf "Maschine läuft" setzen (der aktuelle Status wird automatisch beendet)
                res_status.res_status_beg(in_sid, in_firma_nr, in_res_id, in_ls_login_id, 0,
                                          'MS', null, null, v_sysdate);
            end if;

            v_anz_res := 0;
        else
            v_err_nr := 26;
            v_err_text := 'Der FA Auftrag ist noch zum Rüsten angemeldet! FA:'
                          || v_res_zus.leitzahl
                          || '/'
                          || v_res_zus.fa_ag
                          || '/'
                          || nvl(v_res_zus.fa_upos, 0);

            raise v_error;
            bde_pd_prod_r_ag_e_p(in_sid, in_firma_nr, v_res_zus.leitzahl, v_res_zus.fa_ag, v_res_zus.fa_upos,
                                 in_res_id, v_sysdate, null, null, null,
                                 in_ls_login_id);

        end if;
    end if;

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

  -- Rohstoffzustand wird aus der bde_pd_lam_stl_daten wiederhergestellt
    if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_FA_AN',           -- in_kategorie             in isi_firma_cfg.kategorie%type,
     null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
     'ROHSTOFF_RESTORE',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                      'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                       'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                       'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                       'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                       then
        delete isi_resource_lam_akt lam_akt
        where
                lam_akt.sid = in_sid
            and lam_akt.res_id = in_res_id;

        open c_lam_stl;
        loop
            fetch c_lam_stl into v_lam_stl;
            exit when c_lam_stl%notfound;
      -- Lesen der LAM
            v_lam := null;
            open c_lam_fuer_stl;
            fetch c_lam_fuer_stl into v_lam;
            close c_lam_fuer_stl;
            if v_lam.lam_id = v_lam_stl.stl_lam_id then
                insert into isi_resource_lam_akt values ( in_sid,                   -- SID            VARCHAR2(2) not null,
                                                          in_res_id,                -- RES_ID         NUMBER not null,
                                                          v_lam.artikel_id,         -- ARTIKEL_ID     NUMBER not null,
                                                          v_lam.lam_id,             -- LAM_ID         NUMBER not null,
                                                          null,                     -- LTE_ID         VARCHAR2(20),
                                                          sysdate,                  -- B_DATUM        DATE,
                                                          null );                    -- RES_LAM_PARAMS VARCHAR2(4000)
            end if;

        end loop;

        close c_lam_stl;
    else -- Aktuellen stand halten. Nur nicht benötigte Rohstoffe aus der tabelle löschen
    -- Hier werden alle Rohstoffe die an dieser Maschine gebucht wurden und nicht zum aktuellen Auftrag passen aus der
    -- Maschine gelöscht
        delete isi_resource_lam_akt lam_akt
        where
                lam_akt.sid = in_sid
            and lam_akt.res_id = in_res_id
            and not exists (
                select
                    lam_akt2.artikel_id
                from
                    isi_resource_lam_akt lam_akt2,
                    bde_fa_auftrag       fa_leit
                where
                        lam_akt2.sid = in_sid
                    and lam_akt2.res_id = in_res_id
                    and fa_leit.sid = in_sid
                    and fa_leit.firma_nr = in_firma_nr
                    and fa_leit.leitzahl = in_leitzahl
                    and fa_leit.fa_ag < in_fa_ag
                    and fa_leit.ag_artikel_id = lam_akt.artikel_id
                    and fa_leit.ag_artikel_id = lam_akt2.artikel_id
            );

    end if;

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
        fa.anz_res = nvl(fa.anz_res, 0) + v_anz_res,
        fa.freig_status = 'AP',
        fa.termin_start_ist = nvl(fa.termin_start_ist, v_sysdate),
        fa.status_freigabe = decode(fa.status_freigabe, 900, 900, 500),
        fa.mde_ist_mg = nvl(fa.mde_ist_mg, 0),
        fa.mde_ist_mg_b = nvl(fa.mde_ist_mg_b, 0),
        fa.mde_ist_mg_schrott = nvl(fa.mde_ist_mg_schrott, 0),
        fa.mde_ist_mg_ruesten = nvl(fa.mde_ist_mg_ruesten, 0),
        fa.mde_micro_stop = nvl(fa.mde_micro_stop, 0),
        fa.mde_ist_mg_t = 0,
        fa.mde_ist_mg_b_t = 0,
        fa.mde_ist_mg_schrott_t = v_schrott,
        fa.mde_ist_mg_ruesten_t = 0,
        fa.mde_micro_stop_t = 0
    where
            fa.sid = in_sid
        and fa.leitzahl = in_leitzahl
        and fa.fa_ag = in_fa_ag
        and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);

    if v_fa_akt.lte_name is not null then
        if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'BDE_ANMELD_FA_AUTO_CRT_LEER_LTE',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                          'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                           'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                           'T',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                           'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                           then
            v_lam_lte_leitzahl := null;
            open c_lam_lte;
            fetch c_lam_lte into
                v_lam_lte_waren_typ,
                v_lam_lte_leitzahl;
            close c_lam_lte;
            if v_lam_lte_waren_typ != c.leerpal
            or v_lam_lte_waren_typ is null then
                if nvl(v_lam_lte_leitzahl, 0) != in_leitzahl then
                    v_ins_lte_r := bde_pd_lte_insert(v_fa_akt.sid, in_res_id, 0, v_fa_akt.lte_name);
                end if;
            end if;

        end if;
    end if;
  -- Jetzt noch neuen Auftrag in der Produktionstabelle speichen
    select
        seq_vorg_id.nextval
    into v_vorg_id
    from
        dual;

  -- -AG- 07.06.2006 Wenn dieser Auftrag noch offen ist, dann alle offenen Einträge für diesen Auftrag abschliessen
  -- -WK- 21.08.2008 Performance tuning (primary key darf hier nicht benutzt werden, da nur sid, firma_nr und vorg_typ
  -- geprüft werden. Damit findet der SQL alle 'PA' Datensätze und sortiert anschliessend anhand der anschliessend aus
  -- der Tabelle gelesenen! Daten
    update bde_pd_prod pd
    set
        pd.prod_ende = v_sysdate
    where
            pd.res_id = in_res_id
        and pd.vorg_typ = 'PA'
     --and pd.sid = in_sid -WK-
     --and pd.firma_nr = in_firma_nr -WK-
        and pd.prod_beginn <= v_sysdate
        and ( ( pd.prod_ende is null )
              or ( pd.prod_ende >= v_sysdate ) );

    insert into bde_pd_prod values ( in_sid,
                                     v_vorg_id,
                                     'PA',
                                     in_firma_nr,
                                     v_fa_akt.leitzahl,
                                     v_fa_akt.fa_ag,
                                     v_fa_akt.fa_upos,
                                     v_fa_akt.abnr,
                                     in_res_id,
                                     v_sysdate,
                                     null,
                                     v_res_zus.pers_nr,
                                     null,
                                     v_fa_akt.ag_artikel_id,
                                     null,
                                     null,
                                     null,
                                     in_ls_login_id,
                                     null,
                                     v_fa_akt.abfuell_abschalt_grob,
                                     v_fa_akt.abfuell_abschalt_mittel,
                                     v_fa_akt.abfuell_abschalt_fein,
                                     v_fa_akt.abfuell_toleranz_plus,
                                     v_fa_akt.abfuell_toleranz_minus,
                                     v_fa_akt.abfuell_silo,
                                     v_fa_akt.abfuell_soll,
                                     0,
                                     v_fa_akt.prod_params,
                                     null,
                                     null,
                                     null,
                                     null );

    commit;
    return ( v_vorg_id );
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
    when v_error then  -- Update 2011 show Exception Source Line
        if c_bde_res_zus%isopen then
            close c_bde_res_zus;
        end if;
        rollback;
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        if c_bde_res_zus%isopen then
            close c_bde_res_zus;
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

end bde_pd_prod_p_ag_b_f;
/


-- sqlcl_snapshot {"hash":"e6780265e80e40d53aab6546b087e6b9f0b9105e","type":"FUNCTION","name":"BDE_PD_PROD_P_AG_B_F","schemaName":"DIRKSPZM32","sxml":""}