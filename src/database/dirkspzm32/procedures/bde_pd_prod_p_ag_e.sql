create or replace procedure dirkspzm32.bde_pd_prod_p_ag_e
/*
In dieser Procedure wird Produktion Auftrag Ende gebucht

-- Die procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert
-- 10.03.2020 -DTs- Alle MA von der Maschine abmelden außer den Schichtführer. (E20BDE-17)

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_akt_term        in isi_arbeitsplatz.ip_name          Name der Arbeitstation, von der gebucht wird
@param in_menge_a         in bde_pd_prod.Menge_a               Menge A-Qualität Wenn alle Mengen NULL oder 0, dann werden diese aus den Bucungen in der BDE_PD_PROD ermittelt
@param in_menge_b         in bde_pd_prod.Menge_b               Menge B-Qualität - 2te Wahl
@param in_schrott         in bde_pd_prod.schrott               Schrottmenge
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

*/ (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in isi_firma.firma_nr%type,
    in_leitzahl    in bde_fa_auftrag.leitzahl%type,
    in_fa_ag       in bde_fa_auftrag.fa_ag%type,
    in_fa_upos     in bde_fa_auftrag.fa_upos%type,
    in_res_id      in isi_resource.res_id%type,
    in_sysdate     date,
    in_menge_a     in bde_pd_prod.menge_a%type,
    in_menge_b     in bde_pd_prod.menge_b%type,
    in_schrott     in bde_pd_prod.schrott%type,
    in_ls_login_id in isi_user.login_id%type
) is
  --------------------------------------------------------------------------------------------------------------------
  -- In dieser Procedure wird Produktion Auftrag Ende gebucht
  --------------------------------------------------------------------------------------------------------------------

    v_res_zus      isi_resource_zust_akt%rowtype;     --  Aktueller Zustands dieser Maschine
    v_lte          lvs_lte%rowtype;                   --  Aktuelle Transporteinheit
    v_sysdate      date;                              --  Datum und Zeit dieses Vorgangs
    v_menge_a      bde_pd_prod.menge_a%type;          --  Für die Summe der GutStück
    v_menge_b      bde_pd_prod.menge_b%type;          --  Für die Summe der 2.Wahl
    v_schrott      bde_pd_prod.schrott%type;          --  Für die Summe der Schrottmenge
    v_menge        bde_pd_prod.menge_a%type;          --  Menge A die Bereits auf den Auftrag gebucht wurde
    v_menge_ab     bde_pd_prod.menge_a%type;          --  Menge A die Bereits auf den Auftrag gebucht wurde
    v_fa_auftrag   bde_fa_auftrag%rowtype;            --  Fertigungsauftrag

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  -- -AG- Beachtung der Losmengen (neu) R3.4.11
  -- -AG- Speichern, welche Mengen an den Host geschickt wurden
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(255);
    v_bew_id       s_send_bew.bew_id%type;
    v_found        boolean;
    v_prod_zeit    number;
    v_ruest_zeit   number;
    v_stoer_zeit   number;
    v_prod_std_erf number; -- Stunden Mitarbeiter für den aktuellen Preoduktionsvorgang

    v_ruest        number;
    v_auf_status   isi_resource_zust_akt.auftrag_status%type;
    v_res          isi_resource%rowtype; --  Aktuelle Resource

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

  -- Holen des aktuellen Zustands dieser Maschine
    cursor c_bde_res_zus is
    select
        *
    from
        isi_resource_zust_akt zust_akt
    where
            zust_akt.sid = in_sid
        and zust_akt.res_id = in_res_id;

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
        and pd_p_all.vorg_typ = 'PA'
        and pd_p_all.leitzahl = v_res_zus.leitzahl
        and pd_p_all.fa_ag = v_res_zus.fa_ag
        and nvl(pd_p_all.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
        and pd_p_all.res_id = in_res_id
        and pd_p_all.prod_beginn >= v_res_zus.akt_aufgabe_seit
        and pd_p_all.prod_beginn <= v_sysdate
    group by
        pd_p_all.leitzahl;

  -- Lesen des aktuellen PA Eintrags
    cursor c_bde_pd_prod is
    select
        nvl(menge_a, 0),
        nvl(menge_a, 0) + nvl(menge_b, 0)
    from
        bde_pd_prod pd_p
    where
            pd_p.sid = in_sid
        and pd_p.firma_nr = in_firma_nr
        and pd_p.leitzahl = v_res_zus.leitzahl
        and pd_p.fa_ag = v_res_zus.fa_ag
        and nvl(pd_p.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
        and pd_p.res_id = in_res_id
        and pd_p.vorg_typ = 'PA'
        and pd_p.prod_ende is null;

  -- Lesen der aktuellen Transporteinheit, Prüfen ob Material auf der Palette
    cursor c_lte is
    select
        *
    from
        lvs_lte
    where
        lte_id = v_res_zus.lte_id;

    cursor c_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa
    where
            fa.sid = in_sid
        and fa.leitzahl = in_leitzahl
        and fa.fa_ag = in_fa_ag
        and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);

begin
    open c_resource;
    fetch c_resource into v_res;
    close c_resource;
    if v_res.typ = 'LI'   -- Res ist eine Linie
     then
        open c_res_linie;
        loop
            fetch c_res_linie into v_res;
            exit when c_res_linie%notfound;
            bde_pd_prod_p_ag_e(in_sid,                -- in_sid         in isi_sid.sid%type,
             in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
             in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
             in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
             in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                               v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                                in_sysdate,            -- in_sysdate     date,
                                null,                  -- in_menge_a     in bde_pd_prod.Menge_a%type,
                                null,                  -- in_menge_b     in bde_pd_prod.Menge_b%type,
                                null,                  -- in_schrott     in bde_pd_prod.schrott%type,
                               in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type) is
        end loop;

        close c_res_linie;
    end if;

    if v_res.typ = 'MPG'  -- Res ist eien Produktionsgruppe

     then
        open c_res_mpg;
        loop
            fetch c_res_mpg into v_res;
            exit when c_res_mpg%notfound;
            bde_pd_prod_p_ag_e(in_sid,                -- in_sid         in isi_sid.sid%type,
             in_firma_nr,           -- in_firma_nr    in isi_firma.firma_nr%type,
             in_leitzahl,           -- in_leitzahl    in bde_fa_auftrag.leitzahl%type,
             in_fa_ag,              -- in_fa_ag       in bde_fa_auftrag.fa_ag%type,
             in_fa_upos,            -- in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                               v_res.res_id,          -- in_res_id      in isi_resource.res_id%type,
                                in_sysdate,            -- in_sysdate     date,
                                null,                  -- in_menge_a     in bde_pd_prod.Menge_a%type,
                                null,                  -- in_menge_b     in bde_pd_prod.Menge_b%type,
                                null,                  -- in_schrott     in bde_pd_prod.schrott%type,
                               in_ls_login_id);       -- in_ls_login_id in isi_user.login_id%type) is
        end loop;

        close c_res_mpg;
    end if;

  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;
    if in_sysdate is null then
        v_sysdate := sysdate;                          -- Speichern der Zeitpunkts
    else
        v_sysdate := in_sysdate;                       -- Speichern des übergebenen Zeitpunkts
    end if;

  -- Holen des aktuelle Zustands der Maschine
    open c_bde_res_zus;
    fetch c_bde_res_zus into v_res_zus;
  -- Wenn nicht gefunden dann setze Fehlertext !!
    v_found := c_bde_res_zus%found;
    close c_bde_res_zus;
    if not v_found then
        v_err_nr := 10;
        v_err_text := 'Zustand der Maschine ID: '
                      || in_res_id
                      || ' nicht vorhanden';
        raise v_error;
    else
        if nvl(v_res_zus.akt_aufgabe, 0) != 'P' then
            v_err_nr := 20;
            v_err_text := 'Kein FA Auftrag mit Status Produktion der Maschine angemeldet.';
            raise v_error;
        end if;

        if
            in_leitzahl = v_res_zus.leitzahl
            and in_fa_ag = v_res_zus.fa_ag
            and v_res_zus.akt_aufgabe = 'P'
            and nvl(in_fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
        then
            if
                nvl(in_menge_a, 0) = 0
                and nvl(in_menge_b, 0) = 0
                and nvl(in_schrott, 0) = 0
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
            else
                v_menge_a := nvl(in_menge_a, 0);
                v_menge_b := nvl(in_menge_b, 0);
                v_schrott := nvl(in_schrott, 0);
            end if;

            open c_bde_pd_prod;            -- Menge retten, die bereits im Auftrag gebucht wurde
            fetch c_bde_pd_prod into
                v_menge,
                v_menge_ab;
            if c_bde_pd_prod%notfound then
                v_menge := 0;
                v_menge_ab := 0;
            end if;
            close c_bde_pd_prod;
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
                and pd_p.res_id = in_res_id
                and nvl(pd_p.fa_upos, 0) = nvl(v_res_zus.fa_upos, 0)
                and pd_p.vorg_typ = 'PA'
                and pd_p.prod_ende is null;

        end if;

    end if;

    open c_lte; -- Transporteinheit lesen
    fetch c_lte into v_lte;
    v_found := c_lte%found;
    close c_lte;
    if not v_found then
        if nvl(v_lte.lte_akt_lhm, 0) != 0 then
            bde_pd_lte_fertig(in_sid, in_res_id, in_ls_login_id, v_res_zus.lte_id);
        end if;
    end if;

    fls_p_bde_lvs.c_bde_res_print_lte(in_sid, in_res_id);
  -- -AG- Staus ist normalerweise immer Fertig (Absachwaagen in Linien 'WA'->Typ 2 und 3 gehen erst auf beendet
    v_auf_status := 'F';
    if
        v_res.kategorie = 'WA'
        and ( v_res.kategorie_typ = '2'
        or v_res.kategorie_typ = '3' )
    then
        v_auf_status := 'B';
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
        res_akt.auftrag_status = v_auf_status
    where
            res_akt.sid = in_sid
        and res_akt.res_id = in_res_id;

    open c_fa_auftrag;
    fetch c_fa_auftrag into v_fa_auftrag;
    close c_fa_auftrag;

  -- Update des Aktuelle Zustands des Arbeitsgangs
    if v_fa_auftrag.anz_res = 1 then
        if (
            ( nvl(v_fa_auftrag.ag_ist_mg, 0) + nvl(v_menge_a, 0) - v_menge >= nvl(v_fa_auftrag.ag_soll_mg, 0)
            or ( (
                nvl(v_fa_auftrag.ag_ist_mg, 0) + nvl(v_fa_auftrag.ag_ist_mg_b, 0) + nvl(v_menge_a, 0) + nvl(v_menge_b, 0) - v_menge_ab >= nvl
                (v_fa_auftrag.ag_soll_mg, 0)
                and isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'BDE_A_PULS_B_FERTIG_MELDEN',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                   'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                    'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                    'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                    'BOOLEAN') = c.c_true
            )  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
             ) )
            and nvl(v_fa_auftrag.ag_los_ist_mg, 0) >= nvl(v_fa_auftrag.ag_los_mg, 0)
        )
        or v_fa_auftrag.satzart = 'VR'                      -- Rüsten ist auch ohne Menge fertig
         then
            v_fa_auftrag.freig_status := 'F';                 -- Auftrag ist fertig
        else
            v_fa_auftrag.freig_status := 'TF';                 -- Auftrag ist fertig
        end if;

        v_fa_auftrag.ag_los_mg := null;
        v_fa_auftrag.ag_los_ist_mg := null;
    end if;

    commit;
    select
        sum(t.schrott)
    into v_schrott
    from
        bde_pd_prod t
    where
            t.leitzahl = in_leitzahl
        and t.fa_ag = in_fa_ag
        and t.fa_upos = in_fa_upos
        and t.vorg_typ = 'PA';

    select
        sum(t.schrott + t.menge_a + t.menge_b)
    into v_ruest
    from
        bde_pd_prod t
    where
            t.leitzahl = in_leitzahl
        and t.fa_ag = in_fa_ag
        and t.fa_upos = in_fa_upos
        and t.vorg_typ = 'RA';

  -- dieser Auftruf initialisiert die Auswertung neu und darf nicht gelöscht werden
    v_prod_zeit := bde_funktionen.get_fa_zeiten(null, null, null, null, null);
  -- Auswertung der Produktionszeit ermitteln
    v_prod_zeit := bde_funktionen.get_fa_zeiten_upos(in_sid, in_firma_nr, in_leitzahl, in_fa_ag, in_fa_upos,
                                                     null);
  -- Ausgewertete Daten holen
    v_prod_zeit := bde_funktionen.get_prod_std() * 60;
    v_stoer_zeit := bde_funktionen.get_unterbr_std() * 60;
    v_ruest_zeit := bde_funktionen.get_ruest_std() * 60;
  -- -DTs- 20190919 Ermitteln der MA-Zeiten in dem FA für die aktuelle anmeldung
    v_prod_std_erf := bde_funktionen.get_ma_erf_zeiten(v_res_zus.sid, v_res_zus.firma_nr, v_res_zus.res_id, v_res_zus.akt_aufgabe_seit
    , sysdate) * 60;

  -- Zeiten auf den Auftrag/AG buchen
    update bde_fa_auftrag fa
    set --fa.res_id = in_res_id,
        fa.anz_res = fa.anz_res - 1,
        fa.ag_ist_mg = nvl(fa.ag_ist_mg, 0) + nvl(v_menge_a, 0) - v_menge,          -- Mengen addieren
        fa.ag_ist_mg_b = nvl(fa.ag_ist_mg_b, 0) + nvl(v_menge_b, 0),
        fa.ag_ist_mg_schrott = v_schrott,
        fa.ag_ist_mg_ruesten = v_ruest,
        fa.prod_zeit_ist = v_prod_zeit,
        fa.ruest_zeit_ist = v_ruest_zeit,
        fa.stoer_zeit_ist = v_stoer_zeit,
        fa.termin_ende_ist = v_sysdate,
        fa.prod_zeit_erf = nvl(fa.prod_zeit_erf, 0) + v_prod_std_erf,
        fa.freig_status = v_fa_auftrag.freig_status,
        fa.ag_los_mg = v_fa_auftrag.ag_los_mg,
        fa.ag_los_ist_mg = v_fa_auftrag.ag_los_ist_mg
    where
            fa.sid = in_sid
        and fa.firma_nr = in_firma_nr
        and fa.leitzahl = in_leitzahl
        and fa.fa_ag = in_fa_ag
        and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);

    open c_fa_auftrag;
    fetch c_fa_auftrag into v_fa_auftrag;
    close c_fa_auftrag;
    if v_fa_auftrag.anz_res = 0 then
        v_bew_id := s_schnittstelle.write_host_prod_bew(in_sid, v_fa_auftrag.firma_nr, v_fa_auftrag, null, null,
                                                        null, null, 'S_FA', 'UE');
    -- -AG- Auftrag Status hat sich geändert und Mengen und zeit sind zum Host übergeben
        update bde_fa_auftrag fa
        set
            fa.rcv_ag_ist_mg = fa.ag_ist_mg,
            fa.rcv_ag_ist_mg_b = fa.ag_ist_mg_b,
            fa.rcv_ag_ist_mg_schrott = fa.ag_ist_mg_schrott,
            fa.rcv_ag_ist_mg_ruesten = fa.ag_ist_mg_ruesten,
            fa.rcv_ruest_zeit_ist = fa.ruest_zeit_ist,
            fa.rcv_prod_zeit_ist = fa.prod_zeit_ist,
            fa.rcv_stoer_zeit_ist = fa.stoer_zeit_ist
        where
                fa.sid = in_sid
            and fa.firma_nr = in_firma_nr
            and fa.leitzahl = in_leitzahl
            and fa.fa_ag = in_fa_ag
            and nvl(fa.fa_upos, 0) = nvl(in_fa_upos, 0);

    end if;

  ---------------------------------------------------------------------------------------------------------------------
  -- DTs20200311, E20BDE-17
  -- Abmelden Produktion
  -- Der Parameter Wert wird aus "isi_firma_cfg" ermittelt,
  -- bzw. eingetragen wenn diese nicht vorhanden ist
    if isi_allg.c_get_firma_cfg_param(in_sid,                                  -- in_sid
     in_firma_nr,                             -- in_firma_nr
     'BDE',                                   -- in_kategorie
     null,                                    -- in_kategorie_ix
     'BDE_ABMELD_PERS_RES_FA_ABMELDEN_PROD',  -- in_parameter_name (Abmelden Rüsten)
                                      'BDE',                                   -- in_modul_name
                                       'CFG',                                   -- in_typ
                                       'F',                                     -- in_default_param_wert
                                       'BOOLEAN'                                -- in_default_param_typ
                                      ) = c.c_true then
    -- Alle MA von der Maschine abmelden
    -- außer den Schichtverantwortlichen
    -- der noch an der Maschine angemeldet ist
        update bde_pd_kopf_ma t
        set
            t.pd_kopf_ende = sysdate
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_id = in_res_id
            and t.pd_kopf_ende is null
            and t.pers_nr not in (
                select
                    k.pers_nr
                from
                    bde_pd_kopf k
                where
                        k.res_id = in_res_id
                    and k.pd_kopf_ende is null
            );

    end if;
  ---------------------------------------------------------------------------------------------------------------------

    commit;
exception
  -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
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

end bde_pd_prod_p_ag_e;
/


-- sqlcl_snapshot {"hash":"bc80941d43c9e153d39c7c78988eb6a28340dd76","type":"PROCEDURE","name":"BDE_PD_PROD_P_AG_E","schemaName":"DIRKSPZM32","sxml":""}