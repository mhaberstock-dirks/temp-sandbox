create or replace procedure dirkspzm32.bde_pd_prod_insert
/*
In dieser Procedure werden die Produktionsdaten geschrieben.
--------------------------------------------------------------------------------------------------------------------
-- In dieser Procedure werden die Produktionsdaten geschrieben. Bei Fertigware müssen Alle Rohstoffe an die Maschine
-- gebucht sein. Damit werden alle Rohstoffbezieungen für Fertigware automatisch gebucht.
-- Bei Rohstoffen werden die LAM_ID über den LHM gesucht und eingetragen
-- Nur wenn alle OK sind, dann wird ein COMMIT gemacht, jeder Fehler führt zun ROLLBACK!!!!
--------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------
-- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung)
-- Wenn ein Arbeitsgang begonnen wird, muessen alle hier geschriebenen LAM_ID für diese Maschine (Tabelle
-- bde_resource_lam_akt) die nicht das gleiche Rohmaterial referenzieren wie für den neue Auftrag gefordert
-- gelöscht werden.
-- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung) -- (Achtung)
--------------------------------------------------------------------------------------------------------------------

Die Procedure fuehrt ein Commit durch
-- HISTORY ---
-- 21.10.2013 -MM- Kommentare in JavaDoc-Style geändert
-- 11.02.2015 -AG- Kommentare überarbeitet
-- 20.08.2020 -CMe- Produziertes Material darf nur bei gültigen CFG Eintrag fuer eine
                    ISI Order reserviert werden (Berücksichtigung von Material Versorgung)
                    Vermerk: CMe 20200820

  @author -AG- hans Joachim Gödeke
  @version R3.5.8.1
  @raises v_error Keine Exception aus der Funktion
  @param in_sid             in isi_sid.sid
  @param in_vorg_typ        in bde_pd_prod.vorg_typ            Vorgangstyp 'PP' Produktion, 'PM' Material in die Maschiene (Rohstoffe), 'PR' Produktion Anfahren beim Rüsten
  @param in_firma_nr        in isi_firma.firma_nr
  @param in_barcode         in lvs_lhm.lhm_id                  Barcode, der das Buchen ausgelöst hat
  @param in_leitzahl        in bde_fa_auftrag.leitzahl         Fertigungsauftrag
  @param in_fa_ag           in bde_fa_auftrag.fa_ag            Arbeitsgang
  @param in_fa_upos         in bde_fa_auftrag.fa_upos          Unterposition bzw. Split
  @param in_res_id          in isi_resource.res_id             RES_ID der Maschine
  @param in_pers_nr         in isi_user.pers_nr                Personalnummer (PZM)
  @param in_menge_a         in bde_pd_prod.menge_a             Gutmenge
  @param in_menge_b         in bde_pd_prod.menge_b             2te Wahl Menge
  @param in_schrott         in bde_pd_prod.schrott             Schrottmenge
  @param in_ls_login_id     in isi_user.login_id               LoginId der Buchenden Preson
  @param in_fae_id          in bde_pd_prod.fae_id              Fertigungs Einheit ID
  @param in_fae_id_position in bde_pd_prod.fae_id_position     Position der ID R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten
  @param in_lam_id          in bde_pd_prod.lam_id              Wenn LAM bereits angelegt, sonst NULL -> neues LAM Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)
*/ (
    in_sid             in isi_sid.sid%type,
    in_vorg_typ        in bde_pd_prod.vorg_typ%type,
    in_firma_nr        in isi_firma.firma_nr%type,
    in_barcode         in lvs_lhm.lhm_id%type,
    in_leitzahl        in bde_fa_auftrag.leitzahl%type,
    in_fa_ag           in bde_fa_auftrag.fa_ag%type,
    in_fa_upos         in bde_fa_auftrag.fa_upos%type,
    in_res_id          in isi_resource.res_id%type,
    in_pers_nr         in isi_user.pers_nr%type,
    in_menge_a         in bde_pd_prod.menge_a%type,
    in_menge_b         in bde_pd_prod.menge_b%type,
    in_schrott         in bde_pd_prod.schrott%type,
    in_ls_login_id     in isi_user.login_id%type,
    in_fae_id          in bde_pd_prod.fae_id%type,
    in_fae_id_position in bde_pd_prod.fae_id_position%type,
    in_lam_id          in bde_pd_prod.lam_id%type
) is

  --v_lam_bh      lvs_lam_bh%rowtype;           --  Vorgangs ID für das Veruchen im LAM
    v_vorg_id          bde_pd_prod.vorg_id%type;          --  Vorgangs ID aus SEQ_VOR
    v_vorg_id_lam      lvs_lam_bh.vorg_id%type;           --  Vorgangs ID für das Veruchen im LAM
    v_fa_kopf          bde_fa_kopf%rowtype;
    v_fa_akt           bde_fa_auftrag%rowtype;            --  Lesen FA mit Leitzahl Aktuell
    v_fa_leit          bde_fa_auftrag%rowtype;            --  Lesen FA mit Leitzahl für Rohstoffe
    v_fa_roh           bde_fa_auftrag%rowtype;            --  Lesen FA mit Leitzahl für genau diesen Rohstoff
    v_fa_par           bde_fa_auftrag%rowtype;            --  Lesen FA mit Leitzahl Aktuell (Parallel)
    v_fa_lte_pool      bde_fa_auftrag_lte_pool%rowtype;   --  Lesen FA LTE-Pool
    v_m_lte_lfdn       integer;
    v_fa_stl           bde_fa_auftrag_stl%rowtype;        --  Lesen STL mit Leitzahl für genau diesen Rohstoff
    v_stl_menge        number;                            --  Menge für die Produktion (Gerechnet aus der Stückliste)
    v_res              isi_resource%rowtype;              --  Stammdaten dieser Maschine
    v_res_zus          isi_resource_zust_akt%rowtype;     --  Aktueller Zustands dieser Maschine
    v_res_lam          isi_resource_lam_akt%rowtype;      --  Aktuelle Lager_ID'S Rohstoffe dieser Maschine
    v_artikel          isi_artikel%rowtype;               --  Artikelstammdaten
    v_firma            isi_firma%rowtype;                 -- Firmenstamm
    v_prod_mhd         lvs_lam.lam_mhd%type;              -- MHD fuer die produzierte Ware <= Nin-MHD Rohstof oder Prod-Datum + Artikel MHD-Tage
    v_prod_mhd_a       lvs_lam.lam_mhd%type;              -- MHD fuer die produzierte Ware <= Nin-MHD Rohstof oder Prod-Datum + Artikel MHD-Tage

    v_res_fa_seit      date;                              --  Zeitpunkt der letzten Produktion bzw Beg. des AG
    v_res_fa_bis       date;                              --  Zeitpunkt der letzten Produktion bzw Beg. des AG
    v_res_pp_zeit      number;                            --  Wie lange hat das gedauert
    v_old_charge       lvs_charge.charge_id%type;         --  Alte Charge aus Lagerbestand
    v_new_charge       lvs_charge.charge_id%type;         --  Neue Charge aus Lagerbestand
    v_c_lam_id         lvs_lam.lam_id%type;               --  Lager Artikel Material für Charge
    v_lam_id           lvs_lam.lam_id%type;               --  Lager Artikel Material aus Zugang
    v_lam_qs           lvs_lam.qs_status%type;            --  Lager Artikel Material Merken QS Status aus Firma_CFG
    v_lhm_id           lvs_lhm.lhm_id%type;               --  Lager Hilfsmittel ID
    v_lte              lvs_lte%rowtype;                   --  Lager Transporteinheit ID
    v_lam              lvs_lam%rowtype;                   --  Lager Material
    v_lam_stl          bde_pd_lam_stl_daten%rowtype;      --

    v_fa_upos          bde_fa_auftrag.fa_upos%type;       --  Unterposition des AG bei Gruppenarbeit
    v_fa_ag            bde_fa_auftrag.fa_ag%type;         --  Arbeitsgang für Lagerbuchung
    v_fa_leitzahl      bde_fa_auftrag.leitzahl%type;      --  Leitzahl für Lagerbuchung
    v_menge_a          bde_pd_prod.menge_a%type;          --  Menge der A-Qualität
    v_found            boolean;
    v_artikel_id       bde_fa_auftrag.ag_artikel_id%type; -- Zum Holen und Übergeben der Artikel ID
    v_charge_id        bde_fa_auftrag.charge_id%type;     -- Aktuelle Charge
    v_charge_bez       lvs_charge.charge_bez%type;        -- Aktuelle Charge Bez
    v_barcode          lvs_lhm.lhm_id%type;
    v_min_charge_len   number;                         -- Minimale länge einer charge
    v_bde_buch_lvs     boolean;                        -- Soll das BDE im LVS buchen

    v_order_pos        isi_order_pos%rowtype;             -- Lesen der Order, wenn kunden_ab im FA gefüllt

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr           number;
    v_err_text         varchar2(255);
    v_bew_id           s_send_bew.bew_id%type;
    v_prn_job          integer;
    v_drucker          isi_arbeitsplatz_cfg.modul_parameter%type;
    v_stl_mg           number;
    v_stl_r_mg         number;
    v_stl_lam_id       lvs_lam.lam_id%type;               --  Lager Artikel Material für Stückliste

    v_charge           lvs_charge%rowtype;
    v_hersteller_liste lvs_lam.hersteller_kuerzel_liste%type;

  -- 2020.10.22 Lesen der ISI-Order LTE_POOL für LTE in Resource
    cursor c_bde_fa_auftrag_lte_pool is
    select
        *
    from
        bde_fa_auftrag_lte_pool fa_lte
    where
            fa_lte.sid = in_sid
        and fa_lte.firma_nr = in_firma_nr
        and fa_lte.lte_id = v_res_zus.lte_id;

  -- 2018.05.09 Lesen der ISI-Order über KUNDEN_AB und Auftrag in der Order
    cursor c_order_pos is
    select
        *
    from
        isi_order_pos op
    where
            op.auftrag = v_fa_akt.kunden_ab
        and op.pos_nr = v_fa_akt.kunden_ab_pos
        and op.upos_nr = v_fa_akt.kunden_ab_upos;

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

  -- Holen der Parallel-Auftraege diese Leitzahl - Gleiche LEAD-Auftrag und andrere Leitzahl
    cursor c_par_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa_a
    where
            fa_a.sid = in_sid
        and fa_a.firma_nr = in_firma_nr
        and fa_a.leitzahl != v_fa_akt.leitzahl
        and fa_a.leitzahl in (
            select
                fap.leitzahl
            from
                bde_fa_auftrag fap
            where
                    fap.lead_leitzahl = v_fa_akt.lead_leitzahl
                and fap.leitzahl != in_leitzahl
                and fap.kenz_letzt_ag = 1
        )
        and fa_a.kenz_letzt_ag = 1;

  -- Holen der Stücklistenpositioon genau für diese Leitzahl und AG
    cursor c_bde_fa_auftrag_stl is
    select
        fa_stl.*
    from
        bde_fa_auftrag_stl fa_stl
    where
            fa_stl.sid = in_sid
        and fa_stl.firma_nr = in_firma_nr
        and fa_stl.leitzahl = in_leitzahl
        and fa_stl.fa_ag = in_fa_ag
        and fa_stl.fa_upos = in_fa_upos
    order by
        fa_stl.ma_fa_ag;

  -- Holen aller AG's Rohstoffe für diese Leitzahl an dieser Maschine
    cursor c_leit_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa_leit
    where
            fa_leit.sid = in_sid
        and fa_leit.firma_nr = in_firma_nr
        and fa_leit.leitzahl = in_leitzahl
        and fa_leit.fa_ag < in_fa_ag
        and fa_leit.fa_upos = in_fa_upos
        and fa_leit.satzart != 'VR'
        and ( fa_leit.fa_ag >= nvl((
            select
                max(auf.fa_ag)
            from
                bde_fa_auftrag auf
            where
                    auf.sid = fa_leit.sid
                and auf.firma_nr = fa_leit.firma_nr
                and auf.leitzahl = in_leitzahl
                and auf.fa_ag < in_fa_ag
                and auf.fa_upos = in_fa_upos
                and auf.satzart = 'V'
            group by
                auf.leitzahl
        ),
                                   0) )
    order by
        fa_leit.fa_ag desc;

    cursor c_roh_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag fa
    where
            fa.sid = in_sid
        and fa.firma_nr = in_firma_nr
        and fa.leitzahl = in_leitzahl
        and ( fa.fa_ag < in_fa_ag
              or ( fa.fa_ag = in_fa_ag
                   and fa.satzart = 'MA' ) )
        and fa.ag_artikel_id = v_artikel_id;

  -- Holen des aktuellen Zustands dieser Maschine
    cursor c_bde_res_zus is
    select
        *
    from
        isi_resource_zust_akt zust_akt
    where
            zust_akt.sid = in_sid
        and zust_akt.res_id = in_res_id;

  -- Holen Stammdaten dieser Maschine
    cursor c_res is
    select
        *
    from
        isi_resource res
    where
            res.sid = in_sid
        and res.res_id = in_res_id;

  -- Holen der LAM_ID für eine Artikel_ID auf dieser Maschine
    cursor c_bde_res_lam is
    select
        *
    from
        isi_resource_lam_akt lam_akt
    where
            lam_akt.sid = in_sid
        and lam_akt.res_id = in_res_id
        and lam_akt.artikel_id = v_artikel_id;

  -- Prüfen ob der Barcode ein LHM ist
    cursor c_lhm is
    select
        lhm_id,
        lte_id,
        t.lgr_platz   -- versuche lhm_tabelle mit diesem barcode zu lesen
    from
        lvs_lhm t
    where
        lhm_id = in_barcode;

  -- Prüfen ob der Barcode ein LTE ist
    cursor c_lte is
    select
        *   -- versuche lhm_tabelle mit diesem barcode zu lesen
    from
        lvs_lte
    where
        lte_id = v_barcode;

  -- Lesen des Lagersatz um die Charge zu erkennen
    cursor c_lam is
    select
        charge_id
    from
        lvs_lam
    where
            sid = in_sid
        and firma_nr = in_firma_nr
        and lam_id = v_c_lam_id;

  -- Lesen des Lagersatz Zugang für LTE_ID
    cursor c_lam_bh is
    select
        *
    from
        lvs_lam_bh t
    where
            t.sid = in_sid
        and t.firma_nr = in_firma_nr
        and t.lam_id = v_lam.lam_id
        and t.bus in ( c.lam_bh_bus_zug, c.lam_bh_bus_zug_komm )
    order by
        t.lam_bh_id;

  -- Lesen des Artikelstamms
    cursor c_artikel is
    select
        *
    from
        isi_artikel a
    where
            a.sid = in_sid
        and a.artikel_id = v_artikel_id;

    cursor c_arb_drucker is
    select
        ac.modul_parameter
    from
        isi_arbeitsplatz     ap,
        isi_arbeitsplatz_cfg ac
    where
            ap.ip_name = v_res_zus.akt_terminal
        and ap.arbeitsplatz_id = ac.arbeitsplatz_id
        and ac.modul_name = 'PE'
        and ac.modul_funktion = 'E-DRUCKER';

    cursor c_charge is
    select
        *
    from
        lvs_charge ch
    where
            ch.sid = in_sid
        and ch.charge_id = v_fa_akt.charge_id;

    cursor c_fa_stl is
    select
        fa_stl.*
    from
        bde_fa_auftrag_stl fa_stl
    where
            fa_stl.sid = in_sid
        and fa_stl.firma_nr = in_firma_nr
        and fa_stl.leitzahl = in_leitzahl
        and fa_stl.ma_fa_ag = in_fa_ag
        and fa_stl.ma_fa_upos = in_fa_upos
        and fa_stl.ma_fa_ag = (
            select
                min(t.ma_fa_ag)
            from
                bde_fa_auftrag_stl t
            where
                    t.sid = fa_stl.sid
                and t.firma_nr = fa_stl.firma_nr
                and t.leitzahl = fa_stl.leitzahl
                and t.ma_fa_ag = fa_stl.fa_ag
                and t.ma_fa_upos = fa_stl.fa_upos
        )
    order by
        fa_stl.fa_ag;

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
        and t.fa_ag_stl_id = v_fa_stl.fa_ag_stl_id
        and t.stl_lam_ist_menge < t.stl_lam_ab_menge
    order by
        t.pd_lam_stl_daten_id;

    cursor c_herst_liste is
    select
        stradd_distinct(substr(l.hersteller_kuerzel_liste,
                               1,
                               length(l.hersteller_kuerzel_liste) - 1))
        || ';' hk
    from
        isi_resource_lam_akt t,
        lvs_lam              l
    where
            t.res_id = in_res_id
        and t.lam_id = l.lam_id;

begin
  -----------------------------------------------------------------------------------------------------------------
  -- Prüfen ob der Barcode ein LTE oder LHM ist
  -----------------------------------------------------------------------------------------------------------------
    v_lhm_id := null;            -- Barcode erst mal prüfen, ob dieser ein LHM oder LTE ist
    bde_scanner.v_prod_lhm_id := null;
    bde_scanner.v_prod_lte_id := null;
    v_lte.lte_id := null;            -- Dafür erst mal auf NULL
    v_err_nr := null;
    v_err_text := null;
    v_menge_a := in_menge_a;     -- Übergebene Menge merken !!
    v_barcode := in_barcode;
    v_hersteller_liste := null;
    v_order_pos := null;
    v_res := null;
    open c_res;
    fetch c_res into v_res;
    close c_res;
    v_bde_buch_lvs := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_LVS',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
     null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
     'BUCH_IM_LVS',         -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                     'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                      'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                      'T',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                      'BOOLEAN') = c.c_true; -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    if v_bde_buch_lvs then
        open c_lhm;
        fetch c_lhm into
            v_lhm_id,
            v_lte.lte_id,
            v_lte.lgr_platz;   -- Versuche lhm_tabelle mit diesem Barcode zu lesen
        v_found := c_lhm%found;
        close c_lhm;
        if not v_found then
            open c_lte;
            fetch c_lte into v_lte;   -- Versuche lte_tabelle mit diesem Barcode zu lesen
            v_found := c_lte%found;
            close c_lte;
            if
                v_found
                and in_vorg_typ = 'PP'     -- Es darf kein LHM mit der Nummer eines LTE geben !! (Ausnahme SPEZ Barcode)
            then
                if not isi_p_base.get_isi_firma(in_sid, in_firma_nr, v_firma) then
                    v_firma := null; -- Kann eigentlich nicht sein
                end if;

                if v_firma.lte_barcode_type != c.lte_barcode_spez -- Bei Spezialbarcode kann LHM und LTE die gleiche Nummer haben

                 then -- Wenn kein Spezialbarcode im Firmenstamm, dann darf es diese ID nicht als LTE geben
                    v_err_nr := 10;
                    v_err_text := 'Barcode: '
                                  || in_barcode
                                  || ' ist eine Transporteinheit und kann nicht als Ladehilfsmittel verwendet werden.';
                    raise v_error;
                else
                    v_lhm_id := in_barcode;         -- Wenn SPEZ Barcode dann in_barcode verwenden auch wenn LTE_Vorhanden
                end if;

            end if;

            if not v_found then
                v_lhm_id := in_barcode;         -- Wenn nicht vorhanden dann den uebergebenen Barcode verwenden
                if in_vorg_typ = 'PM' then      -- Barcode muss ein LHM oder LTE sein !!!
                    v_err_nr := 15;
                    v_err_text := 'Barcode: '
                                  || in_barcode
                                  || ' ist keiner Transporteinheit und keinem Ladehilfsmittel zugeordnet.';
                    raise v_error;
                end if;

            end if;

        end if;

    end if;

  -- Erst mal kein Fehler
    v_err_nr := null;
    v_err_text := null;

  --------------------------------------------------------------------------------------------------------------------
  -- Holen der Auftragsdaten fuer ABNR und Artikel ID
  --------------------------------------------------------------------------------------------------------------------
    open c_bde_fa_auftrag;
    fetch c_bde_fa_auftrag into v_fa_akt;
    v_found := c_bde_fa_auftrag%found;
    close c_bde_fa_auftrag;
    if not bde_p_base.get_fa_kopf(v_fa_akt.sid, v_fa_akt.firma_nr, v_fa_akt.leitzahl, v_fa_kopf) then
        v_fa_kopf := null;
    end if;

  -- Wenn nicht gefunden dann setze Fehlertext !!
    if not v_found then
        v_err_nr := 20;
        v_err_text := 'FA Auftrag für NR: '
                      || in_leitzahl
                      || '/'
                      || in_fa_ag
                      || '/'
                      || in_fa_upos
                      || ' nicht vorhanden';

        raise v_error;
    end if;

  ---------------------------------------------------------------------------------------------------------------------
  -- Zeitpunkt ende dieser Produktion merken
  ---------------------------------------------------------------------------------------------------------------------
    open c_bde_res_zus;
    fetch c_bde_res_zus into v_res_zus;
  -- Wenn nicht gefunden dann setze Fehlertext !!
    v_found := c_bde_res_zus%found;
    close c_bde_res_zus;
    if not v_found then
        v_err_nr := 30;
        v_err_text := 'Zustand der Maschine ID: '
                      || in_res_id
                      || ' nicht vorhanden';
        raise v_error;
    else
        if v_res_zus.leitzahl != in_leitzahl
        or v_res_zus.fa_ag != in_fa_ag
        or nvl(v_res_zus.fa_upos, 0) != nvl(in_fa_upos, 0) then
            v_err_nr := 35;
            v_err_text := 'An der Maschine RES_ID '
                          || in_res_id
                          || ' ist ein anderer Auftrag '
                          || in_leitzahl
                          || '/'
                          || in_fa_ag
                          || ' angemeldet!';

            raise v_error;
        end if;

        v_res_fa_seit := v_res_zus.fa_seit;      -- Diesen Zeitpunkt merken
        v_res_fa_bis := sysdate;                 -- Zeitpunkt Prodende aktuelle Produktion
        v_err_nr := 40;
        v_err_text := 'Update Fehler für der Maschine ID: ' || in_res_id;
        update isi_resource_zust_akt
        set
            fa_seit = v_res_fa_bis
        where
                sid = in_sid
            and res_id = in_res_id;

        v_err_nr := null;
        v_err_text := null;
    end if;

    if v_fa_akt.kenz_letzt_ag = 1 then
        v_fa_leitzahl := v_fa_akt.leitzahl;
        v_fa_ag := null;  -- Fertigwahre ohne AG im Lagerbestand
        v_fa_upos := null;
    else
        v_fa_leitzahl := v_fa_akt.leitzahl;
        v_fa_ag := v_fa_akt.fa_ag;  -- Zwischenprodukt mit AG und Leitzahl
        v_fa_upos := v_fa_akt.fa_upos;
    end if;

    v_charge_id := v_fa_akt.charge_id;   -- Aktuelle Caharge nerken

  -- Folgende Typen sind immer die führenden Einträge in der Tabelle
    if in_vorg_typ = 'PP'
    or   -- Produktion
     in_vorg_typ = 'PM'
    or   -- Material in die Maschiene (Rohstoffe)
     in_vorg_typ = 'PR' then -- Produktion Anfahren nach dem Rüsten
        select
            seq_vorg_id.nextval
        into v_vorg_id
        from
            dual;

    end if;

    v_res_pp_zeit := null;

  --  Die Produktion muss Ware im LVS gebucht werden  wenn LVS vorghanden !!
--if keine ##LVS## dann hier Schnittstelle
--   Hier Code bzw Funktion der Schnittstelle
--else
    --  Die Produktion neuer Ware muss im LVS gebucht werden !!
    if in_vorg_typ = 'PP' then -- Produktion

        open c_fa_stl;
        loop
            fetch c_fa_stl into v_fa_stl;
            exit when c_fa_stl%notfound;
            v_stl_menge := 0;
            if v_fa_stl.prod_menge_p_einheit_op = 'ABS' then
                v_stl_menge := nvl(v_fa_stl.prod_menge_p_einheit, 0);
            elsif v_fa_stl.prod_menge_p_einheit_op = 'DIV' then
                v_stl_menge := v_menge_a / nvl(v_fa_stl.prod_menge_p_einheit, 0);
            elsif v_fa_stl.prod_menge_p_einheit_op = 'MUL' then
                v_stl_menge := v_menge_a * nvl(v_fa_stl.prod_menge_p_einheit, 0);
            end if;

            open c_lam_stl;
            loop
                fetch c_lam_stl into v_lam_stl;
                exit when c_lam_stl%notfound
                or v_stl_menge <= v_lam_stl.stl_lam_ab_menge - v_lam_stl.stl_lam_ist_menge;
          -- Es müssen mehr als 1 LAM bebucht werden
                if v_lam_stl.stl_lam_ab_menge - v_lam_stl.stl_lam_ist_menge < v_stl_menge then
                    update bde_pd_lam_stl_daten t
                    set
                        t.stl_lam_ist_menge = v_lam_stl.stl_lam_ab_menge,
                        t.status = 'F'
                    where
                        t.pd_lam_stl_daten_id = v_lam_stl.pd_lam_stl_daten_id;

                    v_stl_menge := v_stl_menge - ( v_lam_stl.stl_lam_ab_menge - v_lam_stl.stl_lam_ist_menge );
                end if;

            end loop;

            update bde_pd_lam_stl_daten t
            set
                t.stl_lam_ist_menge = t.stl_lam_ist_menge + v_stl_menge,
                t.status = 'AP'
            where
                t.pd_lam_stl_daten_id = v_lam_stl.pd_lam_stl_daten_id;

            close c_lam_stl;
        end loop;

        close c_fa_stl;
        if v_bde_buch_lvs then
            v_barcode := v_res_zus.lte_id;
            open c_lte;
            fetch c_lte into v_lte;   -- Versuche lte_tabelle mit diesem Barcode zu lesen
            v_found := c_lte%found;
            close c_lte;
            if v_lte.lgr_platz is null      -- Produktion nur auf Paletten mit Lagerplatz
             then
                if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_LTE_ERZ',            -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'BDE_LTE_LGR_PLATZ_MUSS', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                  'BDE_DB',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                   'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                   'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                   'BOOLEAN') = c.c_true     -- in_default_param_typ
                                                   then
                    v_err_nr := 36;
                    v_err_text := 'LTE: '
                                  || in_barcode
                                  || ' hat keinen Lagerplatz.';
                    raise v_error;
                end if;
            end if;

            v_artikel_id := v_fa_akt.ag_artikel_id;        -- Artikel ID übergeben
            v_bew_id := s_schnittstelle.write_host_prod_bew(v_fa_akt.sid, v_fa_akt.firma_nr, v_fa_akt, null, null,
                                                            c.lam_bh_bus_zug, c.lam_bh_zugagng, 'S_FA', null);

            if
                v_menge_a is null
                and v_fa_akt.lhm_menge > 0
            then
                v_menge_a := v_fa_akt.lhm_menge;
            end if;

            v_artikel := null;
            open c_artikel;
            fetch c_artikel into v_artikel;
            close c_artikel;
            open c_herst_liste;    -- Holer der der Herstellerliste aller Hohstoffe
            fetch c_herst_liste into v_hersteller_liste;
            close c_herst_liste;
            if v_hersteller_liste = ';' then
                v_hersteller_liste := null;
            end if;
            select
                nvl(
                    max(x.lte_lfdn),
                    0
                )
            into v_m_lte_lfdn
            from
                bde_fa_auftrag_lte_pool x
            where
                    x.sid = in_sid
                and x.firma_nr = in_firma_nr
                and x.leitzahl = in_leitzahl
                and x.lte_id != v_res_zus.lte_id;

            open c_bde_fa_auftrag_lte_pool;
            fetch c_bde_fa_auftrag_lte_pool into v_fa_lte_pool;
            close c_bde_fa_auftrag_lte_pool;
            if v_m_lte_lfdn = 0
            or v_m_lte_lfdn > v_fa_lte_pool.lte_lfdn then
                if v_m_lte_lfdn = 0 then
                    v_m_lte_lfdn := 1; -- Jetzt mit der 1 beginnen
                else
                    v_m_lte_lfdn := v_fa_lte_pool.lte_lfdn + 1; -- Jetzt die lfdn setzen
                end if;

                update bde_fa_auftrag_lte_pool t
                set
                    t.lte_verwendet = 'V', -- Ist jetzt in verwendung
                    t.leitzahl = v_fa_leitzahl,
                    t.lte_lfdn = v_m_lte_lfdn
                where
                        t.sid = in_sid
                    and t.firma_nr = in_firma_nr
                    and t.lte_id = v_res_zus.lte_id
                    and t.lte_verwendet in ( 'F', 'R' );

                if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,

                 'UPDATE_PARTNER_FA',      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,

                 'BDE_FA_GEN_LTE_ID',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                  'BDE',                    -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                   'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                   'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                   'BOOLEAN') = c.c_true     -- in_default_param_typ
                                                   then
                    open c_par_fa_auftrag;
                    fetch c_par_fa_auftrag into v_fa_par;
                    loop
                        exit when c_par_fa_auftrag%notfound;
                        update bde_fa_auftrag_lte_pool t
                        set
                            t.lte_verwendet = 'V', -- Ist jetzt in Verwendung Parallelauftrag
                            t.lte_lfdn = v_m_lte_lfdn
                        where
                                t.sid = in_sid
                            and t.firma_nr = in_firma_nr
                            and t.leitzahl = v_fa_par.leitzahl
                            and t.lte_verwendet in ( 'F', 'R' );

                        fetch c_par_fa_auftrag into v_fa_par;
                    end loop;

                    close c_par_fa_auftrag;
                end if;

            end if;

            v_lam_id := lvs_einl.lvs_lam_zugang_db31(
                                   --in_sid, in_firma_nr,

            v_artikel_id,
                                                     v_res_zus.lte_id,
                                                     v_lhm_id,
                                                     v_charge_id,
                                                     null,
                                                     v_fa_leitzahl,
                                                     v_fa_ag,
                                                     v_fa_upos,
                                                     v_fa_akt.abnr,
                                                     null,
                                                     null,
                                                     in_res_id,
                                                     v_res_fa_bis,
                                                     v_res_fa_bis,
                                                     in_ls_login_id,
                                                     v_menge_a,
                                                     v_fa_leit.lhm_name,
                                                     v_fa_akt.kunden_nr,
                                                     v_fa_akt.kd_art_nr,
                                                     null,
                                                     v_fa_akt.zeichnung,
                                                     v_fa_akt.zeichnung_index,
                                                     v_bew_id,
                                                     null,
                                                     null,
                                                     null,
                                                     null,
                                                     null,
                                                     null,
                                                     null,
                                                     null,     -- v_artikel.artikel_p1,
                                                     null,     -- v_artikel.artikel_p2,
                                                     null,     -- v_artikel.artikel_p3,
                                                     null,     -- v_artikel.artikel_p4,
                                                     null,     -- v_artikel.artikel_p5,
                                                     null,     -- v_artikel.artikel_p6,
                                                     null,     -- v_artikel.artikel_p7,
                                                     null,     -- v_artikel.artikel_p8,
                                                     null,     -- v_artikel.artikel_p9,
                                                     null,     -- v_artikel.artikel_p10
                                                     isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_LHM',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                      null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                      'BDE_LHM_DEFAULT_ETI_STATUS',
                                                                                          -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                                    'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                                     'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                                                     null,                  -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                                     'STRING'),             -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                   -- -AG- Paramter Einstellbar in Firma_CFG
                                   --'D',      -- -WK- SD=Etikett muss noch gedruckt werden, D=Etikett ist vorhanden
                                                     null,     -- Kein lam_text
                                                     null,     -- Kein Labortext
                                                     in_fae_id,-- FAE ID
                                                     in_fae_id_position,
                                                     in_lam_id,-- Falls die LAM bereits erzeugt wurde
                                                     '1',      -- menge_a = 1. Wahl -> QS-Status = 1
                                                     (nvl(v_fa_akt.lhm_anz_ist, 0) + 1), -- lam.lhm_lfd_nr aus FA-Auftrag
                                                     v_fa_akt.adress_id,  -- no owner_adress_id > our product / material,
                                                     null,                -- in_hoehe                in lvs_lhm.lhm_vol_hoehe%type,
                                                     null,                -- in_breite               in lvs_lhm.lhm_vol_breite%type,
                                                     null,                -- in_tiefe                in lvs_lhm.lhm_vol_tiefe%type
                                                     v_fa_kopf.lam_sel1,  -- LAM_SEL1 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel2,  -- LAM_SEL2 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel3,  -- LAM_SEL3 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel4,  -- LAM_SEL4 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel5,  -- LAM_SEL5 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel6,  -- LAM_SEL6 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel7,  -- LAM_SEL7 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel8,  -- LAM_SEL8 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel9,  -- LAM_SEL9 N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_fa_kopf.lam_sel10, -- LAM_SEL10  N VARCHAR2(15)  Y     Parameter zusätzliche Selectionsparameter
                                                     v_hersteller_liste,  -- HERSTELLER_KUERZEL_LISTE N VARCHAR2(100) Y     Liste der Hersteller als Kürzel mit Semikolon getrennt
                                                     v_fa_akt.nr_pruefung); -- Nummer der Prüfung (Auftragsnummer aus QS)
        -- 2018.05.09 AG Produkt ist fertig und es ist Auftragsbezogene Fertigung
        -- CMe 20200820: Produziertes Material darf nur bei gültigen CFG Eintrag fuer eine
        --               ISI Order reserviert werden (Berücksichtigung von Material Versorgung)
            if
                v_fa_akt.kenz_letzt_ag = 1
                and v_fa_akt.kunden_ab is not null
                and isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE',                    -- in_kategorie             in isi_firma_cfg.kategorie%type,
                 null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                 'BDE_RES_FOR_ORDER',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                   'BDE_PROD',               -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                    'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                    'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                    'BOOLEAN') = c.c_true     -- in_default_param_typ
            then
          -- 2018.05.09 Lesen der ISI-Order über KUNDEN_AB und Auftrag in der Order
                v_order_pos.auf_id := null;
                open c_order_pos;
                fetch c_order_pos into v_order_pos;
                close c_order_pos;
                if v_order_pos.auf_id is not null -- Auftrag mit AUF_ID gefunden, dan LAM auf diese reservieren
                 then
                    begin
                        if
                            not lvs_p_base.get_lte(v_res_zus.lte_id, v_lte) -- Noch keine Reservierung auf der LTE
                            and ( v_lte.order_vorgang_id is null
                                  or v_order_pos.status = 'N' )
                        then
                            isi_p_order.res_lief_pos_359(
                                in_sid      => v_order_pos.sid,
                                in_firma_nr => v_order_pos.firma_nr,
                                in_lief_nr  => v_order_pos.li_nr,
                                in_lief_pos => v_order_pos.li_pos_nr,
                                in_user_id  => - 1,
                                in_typ      => v_order_pos.vorgang_typ,
                                in_satzart  => v_order_pos.satzart,
                                in_tour_nr  => v_order_pos.vorgang_id,
                                in_lte_id   => v_res_zus.lte_id
                            );

                        else
                            update lvs_lam l
                            set
                                l.order_pos_auf_id = v_order_pos.auf_id,
                                l.res_menge = l.menge,
                                l.res_login_id = - 1
                            where
                                l.lam_id = v_lam_id;

                            update lvs_lte lte
                            set
                                lte.order_vorgang_id = v_order_pos.vorgang_id,
                                lte.order_auf_id = v_order_pos.auf_id,
                                lte.res_login_id = - 1
                            where
                                lte.lte_id = v_res_zus.lte_id;

                        end if;

                    exception
                        when others then
                            isi_p_log.c_isi_system_meldung(v_lam.sid,
                                                           v_lam.firma_nr,
                                                           'BDE_Order_Reservieren',
                                                           'BDE',
                                                           'Log',
                                                           null,
                                                           null,
                                                           null,
                                                           null,
                                                           null,
                                                           substr('Reservieren von: ('
                                                                  || v_res_zus.lte_id
                                                                  || ' LAM '
                                                                  || v_lam_id
                                                                  || ' für '
                                                                  || v_order_pos.auftrag
                                                                  || ') nicht möglich'
                                                                  || dbms_utility.format_error_backtrace, 1, 1000),
                                                           'ERR',
                                                           '5');
                    end;
                end if;

            end if;

            if lvs_p_base.get_lam(in_sid, in_firma_nr, v_lam_id, v_lam) then
                v_prod_mhd := v_lam.lam_mhd;
                v_prod_mhd_a := v_lam.lam_mhd_ausgabe;
            end if;

            bde_scanner.v_prod_lte_id := v_res_zus.lte_id;
            bde_scanner.v_prod_lhm_id := v_lhm_id;
        end if; -- v_bde_buch_lvs
        if v_fa_akt.kenz_lhm_druck = c.c_true
        or v_res.kategorie = 'PRMSD' then
            if v_res.drucker is null -- Wenn in der Maschine kein Drucker hinterlegt ist
             then
                open c_arb_drucker;
                fetch c_arb_drucker into v_drucker;
                close c_arb_drucker;
                v_drucker := substr(v_drucker,
                                    1,
                                    length(v_drucker) - 1);
            else
                v_drucker := v_res.drucker;
            end if;

            if v_drucker is not null then
                v_prn_job := lvs_p_lte.lvs_lte_drucken(v_lhm_id, v_fa_akt.kunden_nr, v_drucker);
            end if;

        end if;

        v_res_pp_zeit := bde_get_netto_pp_zeit(v_res_fa_seit, v_res_fa_bis, in_res_id) * 60;
        bde_pd_prod_p_pa_u(in_sid, in_firma_nr, in_leitzahl, in_fa_ag, in_fa_upos,
                           in_res_id, v_menge_a, v_res_fa_bis, v_res_pp_zeit, v_res_zus.abfuell_ist);

    else
        if v_bde_buch_lvs then
        -- Material in die Maschiene gescannt (Rohstoffe)
            if in_vorg_typ = 'PM' then
                if
                    v_lte.lgr_platz is null
                    and isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_LVS',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                     'LGR_PLATZ_PFLICHT',   -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                     'BUCH_IM_LVS',         -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                       'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                        'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'BOOLEAN') = c.c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                then
                    v_err_nr := 44;
                    v_err_text := 'Fehler: Rohstoff nicht Eingelagert. ';
                    raise v_error;
                end if;

                if not bde_pruefe_rohstoffe(v_lte.lte_id, v_lhm_id, v_fa_akt) then
                    v_lam_qs := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_ERR_NOTE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                     null,                       -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                     'BDE_BARCODE_ZUORDNUNG_ROH',-- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                               'BDE_DB',                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                'CFG',                      -- in_typ                   in isi_firma_cfg.typ%type,
                                                                null,                       -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                'STRING');                  -- in_default_param_typ
                    if v_lam_qs is not null -- Falsche Zuordnung soll vermerkt werden.
                     then
                        lvs_util.c_set_lam_qs_status(in_sid, in_firma_nr, in_barcode, v_lam_qs);
                    end if;

                    v_err_nr := 45;
                    v_err_text := 'Fehler: Rohstoff nicht für den FA-Auftrag '
                                  || v_fa_akt.leitzahl
                                  || '/'
                                  || v_fa_akt.fa_ag
                                  || '. ';

                    raise v_error;
                end if;

                if
                    v_menge_a is null
                    and v_fa_akt.lhm_menge > 0
                then
                    v_menge_a := v_fa_akt.lhm_menge;
                end if;

                v_artikel_id := v_fa_akt.ag_artikel_id;        -- Artikel ID übergeben
                v_vorg_id_lam := null;
                v_bew_id := s_schnittstelle.write_host_prod_bew(v_fa_akt.sid, v_fa_akt.firma_nr, v_fa_akt, null, null,
                                                                c.lam_bh_bus_abg, c.lam_bh_abgagng, 'S_FA', null);
          -- 23.02.2008 -AG- In den Abgangsbuchungen werden jetzt auch Lieferscheinnummer und Pos. gespeichert
                v_lam_id := lvs_ausl.lvs_lam_abgang_r_menge(in_sid, in_firma_nr, v_artikel_id, v_lte.lte_id, v_lhm_id,
                                                            v_fa_akt.abnr, in_res_id, v_res_fa_bis, in_ls_login_id, v_vorg_id_lam,
                                                            v_bew_id, v_fa_akt.leitzahl, v_fa_akt.fa_ag, v_fa_akt.fa_upos, v_fa_akt.ag_id
                                                            ,
                                                            c.lam_bh_bus_abg, null, null, null, v_menge_a);

                bde_scanner.v_prod_lte_id := v_lte.lte_id;
                bde_scanner.v_prod_lhm_id := v_lhm_id;
                if v_lam_id > 0 then
                    open c_roh_fa_auftrag;
                    fetch c_roh_fa_auftrag into v_fa_roh;
                    v_found := c_roh_fa_auftrag%found;
                    close c_roh_fa_auftrag;
                    if v_found then
              -- -AG- BugFix: Menge darf nur bei Materialanforderungen gebucht werden
              --              Alle anderen werden durch Fertigmeldung gebucht
                        update bde_fa_auftrag fa
                        set
                            fa.ag_ist_mg = nvl(fa.ag_ist_mg, 0) + v_menge_a
                        where
                                fa.sid = v_fa_roh.sid
                            and fa.firma_nr = v_fa_roh.firma_nr
                            and fa.satzart = 'MA'
                            and fa.leitzahl = v_fa_roh.leitzahl
                            and fa.fa_ag = v_fa_roh.fa_ag
                            and fa.fa_upos = v_fa_roh.fa_upos;

              -- Wenn die FE-EWinheit bereits gebucht, dann hierfür wenn Möglich die STL für dei rohstoffe bauen
                        if v_res_zus.fert_lam_id is not null then
                            open c_bde_res_lam;
                            fetch c_bde_res_lam into v_res_lam;
                            v_found := c_bde_res_lam%found;
                            close c_bde_res_lam;
                            v_stl_lam_id := v_lam_id;
                            open c_bde_fa_auftrag_stl;
                            fetch c_bde_fa_auftrag_stl into v_fa_stl;
                            close c_bde_fa_auftrag_stl;
                            update bde_pd_lam_stl_daten
                            set
                                stl_lam_ab_menge = stl_lam_ab_menge + v_menge_a
                                                                  -- STL_LAM_AB_MENGE    NUMBER,
                            where
                                    sid = in_sid                             -- SID                 VARCHAR2(2) not null,
                                and firma_nr = in_firma_nr                   -- FIRMA_NR            NUMBER not null,
                                and fert_lam_id = v_res_zus.fert_lam_id      -- FERT_LAM_ID         NUMBER,
                                and fa_nr = in_leitzahl                      -- FA_NR               NUMBER not null,
                                and fa_nr = in_fa_ag                         -- FA_AG               NUMBER not null,
                                and fa_upos = in_fa_upos                     -- FA_UPOS             NUMBER not null,
                                and fa_ag_stl_id = v_fa_stl.fa_ag_stl_id     -- FA_AG_STL_ID        NUMBER,
                                and stl_lam_id = v_stl_lam_id                -- STL_LAM_ID          NUMBER,
                                and res_id = v_res_zus.res_id;               -- RES_ID              NUMBER,
                -- Keine Update, dann anlegen
                            if sql%rowcount = 0 then
                                insert into bde_pd_lam_stl_daten values ( in_sid,                     -- SID                 VARCHAR2(2) not null,
                                                                          in_firma_nr,                -- FIRMA_NR            NUMBER not null,
                                                                          null,                       -- PD_LAM_STL_DATEN_ID NUMBER not null,
                                                                          v_res_zus.fert_lam_id,      -- FERT_LAM_ID         NUMBER,
                                                                          in_leitzahl,                -- FA_NR               NUMBER not null,
                                                                          in_fa_ag,                   -- FA_AG               NUMBER not null,
                                                                          in_fa_upos,                 -- FA_UPOS             NUMBER not null,
                                                                          v_fa_stl.fa_ag_stl_id,      -- FA_AG_STL_ID        NUMBER,
                                                                          v_stl_lam_id,               -- STL_LAM_ID          NUMBER,
                                                                          v_menge_a,                  -- STL_LAM_AB_MENGE    NUMBER,
                                                                          0,                          -- STL_LAM_IST_MENGE   NUMBER,
                                                                          'N',                        -- STATUS              VARCHAR2(10) default 'N' not null,
                                                                          sysdate,                    -- AEND_DATUM          DATE not null,
                                                                          in_ls_login_id,             -- AEND_LOGIN_ID       NUMBER,
                                                                          v_res_zus.res_id,           -- RES_ID              NUMBER,
                                                                          null,                       -- RES_STATUS_ID       NUMBER,
                                                                          null );                      -- RESULT_PARAMS       VARCHAR2(4000)
                            end if;

                        end if;

                    end if;

                    open c_bde_res_lam;
                    fetch c_bde_res_lam into v_res_lam;
                    v_found := c_bde_res_lam%found;
                    close c_bde_res_lam;
                    if v_found then -- Lam-Akt existiert bereits für diesen Artikel
                        v_err_nr := 50;
                        v_err_text := 'Update Fehler für Artikel ID: ' || v_artikel_id;
                        update isi_resource_lam_akt t
                        set
                            t.lam_id = v_lam_id,
                            t.lte_id = v_lte.lte_id,
                            t.b_datum = v_res_fa_bis
                        where
                                sid = in_sid
                            and res_id = in_res_id
                            and artikel_id = v_artikel_id;
              -- Pruefen ob eine neue Charge zu bilden ist --
                        if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'BDE_CHARGE',             -- in_kategorie             in isi_firma_cfg.kategorie%type,
                         null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                         'BDE_UNTERCHARGE_ERZ',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                          'BDE_DB',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                           'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                                           'T',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                           'BOOLEAN') = c.c_true     -- in_default_param_typ
                                                           then
                            v_c_lam_id := v_res_lam.lam_id; -- Holen der ID des letzten Bestandssatz
                            open c_lam;      -- Lesen der Lagerbestands um die Charge zu erkennen
                            fetch c_lam into v_old_charge;  -- Letzte Charge merken
                            close c_lam;
                            if
                                v_old_charge is null         -- Keine Charge für den Artikel gefunden
                                and v_fa_akt.ag_ist_mg > 0      -- Aber schon menge Produziert
                            then                            -- dann wurde der Rohstoff Artikel geändert
                                v_old_charge := 0;            -- Die Charge muss dann in jedem Fall geändert werden
                            end if;

                            v_c_lam_id := v_lam_id; -- Holen der ID des neuen Bestandssatz
                            open c_lam;      -- Lesen der Lagerbestands um die Charge zu erkennen
                            fetch c_lam into v_new_charge;  -- Letzte Charge merken
                            close c_lam;
                            if v_new_charge != v_old_charge then
                  -- v_charge := v_fa_leitzahl || '/' || v_fa_akt.fa_ag;
                  -- Es soll immer die Charge aus dem FA genommen und weitergezählt werden

                                open c_charge;
                                fetch c_charge into v_charge;
                                close c_charge;

                  -- Da es bei Seaquist Chargen mit einem '-' gibt, und diese nicht
                  -- verändert werden dürfen, werden die Chargenbezeichnung ueber eine
                  -- min_länge geschützt. Diese stehen dann in der Firma_cfg
                                v_charge_bez := v_charge.charge_bez;
                                v_min_charge_len := isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                 null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                 'CHARGE_MIN_LENGTH',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                                   'CFG',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                                    'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                                                    '1',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                                    'INTEGER');            -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                if instr(v_charge.charge_bez, '-', v_min_charge_len, 1) > 0 then
                                    v_charge_bez := substr(v_charge.charge_bez,
                                                           1,
                                                           instr(v_charge.charge_bez, '-', v_min_charge_len, 1) - 1);
                                end if;

                                v_charge_bez := nvl(v_charge_bez, v_fa_leitzahl
                                                                  || '/'
                                                                  || v_fa_akt.fa_ag);
                                v_charge_id := get_charge_next_id(in_sid, null, v_charge_bez, v_fa_akt.ag_artikel_id, v_charge_id);
                  -- -AG- BugFix die Untercharge muss dann in den 'V%' Satz eingetragen werden
                                update bde_fa_auftrag fa
                                set
                                    fa.charge_id = v_charge_id
                                where
                                        fa.sid = in_sid
                                    and fa.leitzahl = v_fa_leitzahl
                                    and fa.fa_ag = v_fa_akt.fa_ag
                                    and nvl(fa.fa_upos, 0) = nvl(v_fa_akt.fa_upos, 0)
                                    and fa.satzart != 'MA';

                            end if;

                        end if;

                    else
                        v_err_nr := 60;
                        v_err_text := 'Insert Fehler für Artikel ID: ' || v_artikel_id;
                        insert into isi_resource_lam_akt values ( in_sid,
                                                                  in_res_id,
                                                                  v_artikel_id,
                                                                  v_lam_id,
                                                                  v_lte.lte_id,
                                                                  v_res_fa_bis,
                                                                  null );

                    end if;

                    v_err_nr := null;
                    v_err_text := null;
                else
                    v_err_nr := 65;
                    v_err_text := 'Fehler: Gesperrte Ware kann darf nicht in die Maschine gebucht werden! ';
                    raise v_error;
                    v_lam_id := null;       -- Fehler, dann lam_id auf NULL setzen
                end if;

            else
                v_lam_id := null;         -- Alle anderen haben keinen zu buchenden Lagerbestand
            end if;

        else
            v_lam_id := null;         -- Alle anderen haben keinen zu buchenden Lagerbestand
        end if;
    end if;
--end if; -- Ende LVS Abhandlung

  -----------------------------------------------------------------
  -- Hier wird die Buchung in die Produktionstabelle eingetragen --
  -----------------------------------------------------------------
    v_err_nr := 70;
    v_err_text := 'Fehler beim Eintragen der Produktionsmeldung FA Auftrag: '
                  || in_leitzahl
                  || '/'
                  || in_fa_ag
                  || '/'
                  || in_fa_upos;

    insert into bde_pd_prod values ( in_sid,
                                     v_vorg_id,
                                     in_vorg_typ,
                                     in_firma_nr,
                                     in_leitzahl,
                                     in_fa_ag,
                                     in_fa_upos,
                                     v_fa_akt.abnr,
                                     in_res_id,
                                     nvl(v_res_fa_seit, sysdate),
                                     nvl(v_res_fa_bis, sysdate),
                                     in_pers_nr,
                                     v_lam_id,
                                     v_artikel_id,
                                     v_menge_a,
                                     in_menge_b,
                                     in_schrott,
                                     in_ls_login_id,
                                     v_res_pp_zeit,
                                     v_res_zus.abfuell_abschalt_grob,
                                     v_res_zus.abfuell_abschalt_mittel,
                                     v_res_zus.abfuell_abschalt_fein,
                                     v_res_zus.abfuell_toleranz_plus,
                                     v_res_zus.abfuell_toleranz_minus,
                                     v_res_zus.abfuell_silo,
                                     v_res_zus.abfuell_soll,
                                     v_res_zus.abfuell_ist,
                                     v_res_zus.prod_params,
                                     in_fae_id,
                                     in_fae_id_position,
                                     v_res_zus.abfuell_tara,
                                     v_res_zus.abfuell_brutto );

    v_err_nr := null;
    v_err_text := null;

--if keine ##LVS## dann hier Schnittstelle
--   Hier Code bzw Funktion der Schnittstelle
--else
    if v_bde_buch_lvs then
        if in_vorg_typ = 'PP' then -- Produktion
        -- Hier die Abhandlung Suchen der Einträge für die Rohstoffe aller vorgelagerten AG's
            if isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                   -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                    -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'BDE_CHK_RW+RVERFOLGUNG',-- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                              'BDE',                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG',                   -- in_typ                   in isi_firma_cfg.typ%type,
                                               'T',                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'BOOLEAN') = c.c_true    -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                               then
                open c_leit_fa_auftrag;
                loop
                    fetch c_leit_fa_auftrag into v_fa_leit;
                    exit when c_leit_fa_auftrag%notfound;      -- Letzter eintrag (Kein Fehler)
                    v_artikel_id := v_fa_leit.ag_artikel_id;  -- Für Cursor den Artikel übernehmen
                    v_found := c_leit_fa_auftrag%found;
                    if not v_found then
                        v_err_nr := 80;
                        v_err_text := 'Arbeitsgang für Rohstoff fehlt für Arbeitsgang FA: '
                                      || in_leitzahl
                                      || '/'
                                      || in_fa_ag
                                      || '/'
                                      || in_fa_upos
                                      || '.';
              -- raise v_error;
                    else
                        if v_artikel_id is not null then
              -- Suche der LAM_ID für diesen Rohstoff
                            open c_bde_res_lam;
                            fetch c_bde_res_lam into v_res_lam;
                            if lvs_p_base.get_lam(in_sid, in_firma_nr, v_res_lam.lam_id, v_lam) then
                                if v_prod_mhd > v_lam.lam_mhd then
                                    v_prod_mhd := v_lam.lam_mhd;
                                end if;
                                if v_prod_mhd_a > v_lam.lam_mhd_ausgabe then
                                    v_prod_mhd_a := v_lam.lam_mhd_ausgabe;
                                end if;
                            else
                                v_lam.fae_id := null;
                            end if;

                            v_found := c_bde_res_lam%found;
                            close c_bde_res_lam;
                            if not v_found then
                                v_err_nr := 90;
                                v_err_text := 'Fehlender Rohstoff für '
                                              || in_leitzahl
                                              || '/'
                                              || in_fa_ag
                                              || '/'
                                              || in_fa_upos
                                              || ' aus Arbeitsgang FA: '
                                              || v_fa_leit.leitzahl
                                              || '/'
                                              || v_fa_leit.fa_ag
                                              || '/'
                                              || v_fa_leit.fa_upos
                                              || '. Bitte Rohstoff in die Maschine scannen';

                                raise v_error;
                            end if;

                    -- Eifacher Insert, Folgearbeitsgang (Weiterbearbeitung) eines vorgelagerten AG
                            if v_fa_leit.satzart != 'MA' then
                                v_err_nr := 100;
                                v_err_text := 'Fehler beim Einfügen des Arbeitsgang '
                                              || in_leitzahl
                                              || '/'
                                              || in_fa_ag
                                              || '/'
                                              || in_fa_upos
                                              || ' für Rohstoff Arbeitsgang FA: '
                                              || v_fa_leit.leitzahl
                                              || '/'
                                              || v_fa_leit.fa_ag
                                              || '/'
                                              || v_fa_leit.fa_upos;

                                insert into bde_pd_prod values ( in_sid,
                                                                 v_vorg_id,
                                                                 'PB',
                                                                 in_firma_nr,
                                                                 in_leitzahl,
                                                                 v_fa_leit.fa_ag,
                                                                 v_fa_leit.fa_upos,
                                                                 v_fa_leit.abnr,
                                                                 in_res_id,
                                                                 v_res_fa_seit,
                                                                 v_res_fa_bis,
                                                                 in_pers_nr,
                                                                 v_res_lam.lam_id,
                                                                 v_fa_leit.ag_artikel_id,
                                                                 null,
                                                                 null,
                                                                 null,
                                                                 in_ls_login_id,
                                                                 null,
                                                                 v_res_zus.abfuell_abschalt_grob,
                                                                 v_res_zus.abfuell_abschalt_mittel,
                                                                 v_res_zus.abfuell_abschalt_fein,
                                                                 v_res_zus.abfuell_toleranz_plus,
                                                                 v_res_zus.abfuell_toleranz_minus,
                                                                 v_res_zus.abfuell_silo,
                                                                 v_res_zus.abfuell_soll,
                                                                 v_res_zus.abfuell_ist,
                                                                 v_res_zus.prod_params,
                                                                 in_fae_id,
                                                                 in_fae_id_position,
                                                                 v_res_zus.abfuell_tara,
                                                                 v_res_zus.abfuell_brutto );

                                v_err_nr := null;
                                v_err_text := null;
                            end if;
                    -- Wenn gefunden dann prüfen ob Folge AG (nicht Satzart MA) !!
                    -- TODO Achtung, hier muss noch die LAGERBUCHUNG des Rohstoffs eingetragen werden !!!!!!!!!!!
                            if v_fa_leit.satzart = 'MA' then
                                v_err_nr := 110;
                                v_err_text := 'Fehler beim Einfügen des Arbeitsgang '
                                              || in_leitzahl
                                              || '/'
                                              || in_fa_ag
                                              || '/'
                                              || in_fa_upos
                                              || ' für Rohstoff Arbeitsgang FA: '
                                              || v_fa_leit.leitzahl
                                              || '/'
                                              || v_fa_leit.fa_ag
                                              || '/'
                                              || v_fa_leit.fa_upos;

                                insert into bde_pd_prod values ( in_sid,
                                                                 v_vorg_id,
                                                                 'PB',
                                                                 in_firma_nr,
                                                                 in_leitzahl,
                                                                 v_fa_leit.fa_ag,
                                                                 v_fa_leit.fa_upos,
                                                                 v_fa_leit.abnr,
                                                                 in_res_id,
                                                                 v_res_fa_seit,
                                                                 v_res_fa_bis,
                                                                 in_pers_nr,
                                                                 v_res_lam.lam_id,
                                                                 v_fa_leit.ag_artikel_id,
                                                                 null,
                                                                 null,
                                                                 null,
                                                                 in_ls_login_id,
                                                                 null,
                                                                 v_res_zus.abfuell_abschalt_grob,
                                                                 v_res_zus.abfuell_abschalt_mittel,
                                                                 v_res_zus.abfuell_abschalt_fein,
                                                                 v_res_zus.abfuell_toleranz_plus,
                                                                 v_res_zus.abfuell_toleranz_minus,
                                                                 v_res_zus.abfuell_silo,
                                                                 v_res_zus.abfuell_soll,
                                                                 v_res_zus.abfuell_ist,
                                                                 v_res_zus.prod_params,
                                                                 in_fae_id,
                                                                 in_fae_id_position,
                                                                 v_res_zus.abfuell_tara,
                                                                 v_res_zus.abfuell_brutto );

                                v_err_nr := null;
                                v_err_text := null;
                                begin
                                    if lvs_p_base.get_lam(in_sid, in_firma_nr, v_res_lam.lam_id, v_lam) then
                          --OPEN c_lam_bh;
                          --FETCH c_lam_bh into v_lam_bh;
                          --CLOSE c_lam_bh;

                                        if v_lam.fae_id is not null then
                                            insert into bde_pd_prozess_data
                                                (
                                                    select
                                                        t.sid,
                                                        t.firma_nr,
                                                        v_vorg_id,
                                                        in_leitzahl,
                                                        in_fa_ag,
                                                        in_fa_upos,
                                                        in_res_id,
                                                        in_fae_id,
                                                        in_fae_id_position,
                                                        t.res_prozess_data_res_id,
                                                        v_res_fa_bis - ( 1 / 86400 ), --t.res_prozess_data_date, Produktion - 1 SEC
                                                        t.res_prozess_data_nr,
                                                        t.res_prozess_data_value,
                                                        v_res_fa_bis - ( 1 / 86400 ), -- Produktion - 1 SEC,
                                                        in_ls_login_id,
                                                        null,
                                                        null,
                                                        null,
                                                        t.io
                                                    from
                                                        bde_pd_prozess_data t
                                                    where
                                                            t.fae_id = v_lam.fae_id
                                                        and t.leitzahl is null
                                                        and t.res_prozess_data_date = (
                                                            select
                                                                max(x.res_prozess_data_date)
                                                            from
                                                                bde_pd_prozess_data x
                                                            where
                                                                    x.fae_id = v_lam.fae_id
                                                                and x.leitzahl is null
                                                        )
                                                );

                                        end if;

                                    end if;
                                exception
                                    when others then
                                        isi_p_log.c_isi_system_meldung(v_lam.sid, v_lam.firma_nr, 'BDE_Q_Daten', 'BDE', 'Log',
                                                                       null, null, null, null, null,
                                                                       'Buchen von: ('
                                                                       || v_lam.fae_id
                                                                       || ' für '
                                                                       || in_fae_id
                                                                       || ') nicht möglich', '5');
                                end;

                            end if;

                        end if;
                    end if;

                end loop;

                close c_leit_fa_auftrag;
            end if;

            if
                v_lam_id is not null
                and ( v_prod_mhd is not null
                      or v_prod_mhd_a is not null )
            then
                update lvs_lam t
                set
                    t.lam_mhd = nvl(v_prod_mhd, t.lam_mhd),
                    t.lam_mhd_ausgabe = nvl(v_prod_mhd_a, t.lam_mhd_ausgabe)
                where
                        t.lam_id = v_lam_id
                    and t.sid = in_sid
                    and t.firma_nr = in_firma_nr;

            end if;

        end if;
    end if;
--end if;
    commit;
    return;
exception
    when v_error then  -- Update 2011 show Exception Source Line
        if c_leit_fa_auftrag%isopen then
            close c_leit_fa_auftrag;
        end if;
        rollback;
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        if c_leit_fa_auftrag%isopen then
            close c_leit_fa_auftrag;
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

end bde_pd_prod_insert;
/


-- sqlcl_snapshot {"hash":"7df7f7ce2c9530d6cb48f61d676ba93454fed37c","type":"PROCEDURE","name":"BDE_PD_PROD_INSERT","schemaName":"DIRKSPZM32","sxml":""}