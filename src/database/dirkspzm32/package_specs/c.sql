create or replace package dirkspzm32.c is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  03.02.2006 15:08:06
  __________________________________________________
  Description
  Konstanten für DB
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

    v_isi_product_release constant varchar2(10) := '3.5';
    function get_isi_product_release return varchar2;

  --************************************************************************************************
  -- message_definitions;

  -- Message types
    msg_mt_application constant number := 1;
    msg_mt_notification constant number := 2;
    msg_mt_betriebsart constant number := 3;             -- Betriebsart Host Umschalten
    msg_mt_messageboard constant number := 4;             -- Zur internen Verwendung für das MessageBoard
    msg_mt_scanner constant number := 5;             -- Zur internen Verwendung für die ScannerEngine
    msg_mt_print_engine constant number := 6;             -- Zur internen Verwendung für die PrintEngine
    msg_mt_mfr_server constant number := 7;             -- Zur internen Verwendung für den MFR
    msg_mt_mfr_base_befehl constant number := 8;             -- Standard befehle zwischen MFR und MFR Visu
    msg_mt_meld_engine constant number := 9;             -- Zur internen Verwendung für die Meldung-Engine

    msg_mt_host_imp_exp constant number := 10;            -- Zur internen Verwendung für Host DatenÜbernahme, Daten Abgabe
    msg_mt_transponder constant number := 11;
    msg_mt_mde_server constant number := 12;            -- MDE OPC Server zum mmeldern von Auftragswechsel etc.
    msg_mt_system_meld constant number := 13;            -- ISIPlus System Meldungen
    msg_mt_watchdog constant number := 14;
    msg_mt_fls_server constant number := 15;
    msg_mt_fls_befehle constant number := 16;
    msg_mt_res_zust_chg constant number := 17;
    msg_mt_user constant number := 1000;
    msg_mt_cerealia constant number := 1001;

  -- Message commands
    msg_mc_error constant number := 1;
    msg_mc_warning constant number := 2;
    msg_mc_info constant number := 3;
    msg_mc_ma_sla constant number := 4;


  -- Alle nummern > $1000 sind modulspezifisch (keine Sonderlösungen)
    msg_mc_print_job_ready constant number := 1001;
    msg_mc_print_job_error constant number := 1002;
    msg_mc_mfr_neuer_transport constant number := 4416;
    msg_mc_mfr_del_transport constant number := 4417;
    msg_mc_mfr_neue_lhm constant number := 4418;
    msg_mc_mfr_event constant number := 4419;
    msg_mc_mfr_n_resid_transport constant number := 4420;

  -- Ab der nummer $1000 0000 können freie Messages definiert werden
  -- Die lokale definition kann dann so aussehen:
  --MSG_MC_MY_COMMAND = MSG_MC_USER + $0001; // daraus entsteht $1000 0001
    msg_mc_user constant number := 10000000;

  -- ********************* fuer MSG_MT_MDE_SERVER ********************************
    c_msg_mde_res_id constant varchar2(25) := 'MDE_RES_ID';                 -- Maschine ISI_RESOURCE.RES_ID
    c_msg_mde_masch_name constant varchar2(25) := 'MDE_MASCH_NAME';             -- Name der Maschine ISI_RESOURCE.RES_NAME
    c_msg_mde_leitzahl constant varchar2(25) := 'MDE_LEITZAHL';               -- Fertigungsauftragsnummer
    c_msg_mde_fa_ag constant varchar2(25) := 'MDE_FA_AG';                  -- Fertigungsauftrag Arbeitsgang
    c_msg_mde_fa_upos constant varchar2(25) := 'MDE_FA_UPOS';                -- Fertigungsauftrag Unterposition fuer Gruppenarbeit
    c_msg_mde_fa_soll_mg constant varchar2(25) := 'MDE_FA_SOLL_MG';             -- Fertigungsauftrag Sollmenge des gesamten Auftrags
    c_msg_mde_fa_soll_lhm_mg constant varchar2(25) := 'MDE_FA_SOLL_LHM_MG';         -- Fertigungsauftrag Sollmenge Stk je LHM
    c_msg_mde_fa_ist_mg constant varchar2(25) := 'MDE_FA_IST_MG';              -- Fertigungsauftrag Istmenge des gesamten Auftrags als Initialwert Auftragswechsel
    c_msg_mde_fa_ist_mg_b constant varchar2(25) := 'MDE_FA_IST_MG_B';            -- Fertigungsauftrag Istmenge B des gesamten Auftrags als Initialwert Auftragswechsel
    c_msg_mde_fa_ist_mg_s constant varchar2(25) := 'MDE_FA_IST_MG_S';            -- Fertigungsauftrag Istmenge Schrott des gesamten Auftrags als Initialwert Auftragswechsel
    c_msg_mde_res_status_id constant varchar2(25) := 'MSG_MDE_RES_STATUS_ID';      -- Bei Statusänderung der Resource (Maschine)

    c_msg_res_id constant varchar2(25) := 'MSG_RES_ID';                 -- Resource (Maschine)
    c_msg_lte_id constant varchar2(25) := 'MSG_LTE_ID';                 -- LTE_ID
    c_msg_lhm_id constant varchar2(25) := 'MSG_LHM_ID';                 -- LHM_ID
    c_msg_ziel_lte_id constant varchar2(25) := 'MSG_ZIEL_LTE_ID';            -- LTE_ID der Ziel LTE (Packen)
    c_msg_transport_id constant varchar2(25) := 'MSG_TRANSPORT_ID';           -- ID des Transports
    c_msg_lgr_platz constant varchar2(25) := 'MSG_MSG_LGR_PLATZ';          -- Ziel Lagerplatz
    c_msg_artikel_id constant varchar2(25) := 'MSG_ARTIKEL_ID';             -- Artikel ID
    c_msg_artikel constant varchar2(25) := 'MSG_ARTIKEL';                -- Artikel Nr
    c_msg_artikel_bez constant varchar2(25) := 'MSG_ARTIKEL_BEZ';            -- Artikel Bezeichnung
    c_msg_ziel constant varchar2(25) := 'MSG_ZIEL';                   -- Nächstes Ziel
    c_msg_command constant varchar2(25) := 'MSG_COMMAND';                -- Kommando
    c_msg_quelle constant varchar2(25) := 'MSG_QUELLE';                 -- Quellplatz Quellelement
    c_msg_element constant varchar2(25) := 'MSG_ELEMENT';                -- Ziel Lagerplatz
    c_msg_id constant varchar2(25) := 'MSG_ID';
    msg_mc_mde_auf_stat_ruesten constant number := 1; -- Auftrags- Statuswechsel DB -> OPC
    msg_mc_mde_auf_stat_r_ende constant number := 2; -- Auftrags- Statuswechsel DB -> OPC
    msg_mc_mde_auf_stat_produktion constant number := 3; -- Auftrags- Statuswechsel DB -> OPC
    msg_mc_mde_auf_stat_p_ende constant number := 4; -- Auftrags- Statuswechsel DB -> OPC
    msg_mc_mde_res_status_wechsel constant number := 5; -- ResStatus- Statuswechsel DB -> OPC (Ausloesende Stoerung)
    msg_mc_mde_schicht_anfang constant number := 6; -- ResStatus- Statuswechsel DB -> OPC
    msg_mc_mde_schicht_ende constant number := 7; -- ResStatus- Statuswechsel DB -> OPC
    msg_mc_mde_schicht_wechsel constant number := 8; -- ResStatus- Statuswechsel DB -> OPC

    c_msg_res_res_id constant varchar2(25) := 'RES_RES_ID';                 -- Maschine ISI_RESOURCE.RES_ID
    c_msg_res_masch_name constant varchar2(25) := 'RES_MASCH_NAME';             -- Name der Maschine ISI_RESOURCE.RES_NAME
    c_msg_res_leitzahl constant varchar2(25) := 'RES_LEITZAHL';               -- Fertigungsauftragsnummer
    c_msg_res_fa_ag constant varchar2(25) := 'RES_FA_AG';                  -- Fertigungsauftrag Arbeitsgang
    c_msg_res_fa_upos constant varchar2(25) := 'RES_FA_UPOS';                -- Fertigungsauftrag Unterposition fuer Gruppenarbeit
    c_msg_res_fa_soll_mg constant varchar2(25) := 'RES_FA_SOLL_MG';             -- Fertigungsauftrag Sollmenge des gesamten Auftrags
    c_msg_res_fa_soll_lhm_mg constant varchar2(25) := 'RES_FA_SOLL_LHM_MG';         -- Fertigungsauftrag Sollmenge Stk je LHM
    c_msg_res_fa_ist_mg constant varchar2(25) := 'RES_FA_IST_MG';              -- Fertigungsauftrag Istmenge des gesamten Auftrags als Initialwert Auftragswechsel
    c_msg_res_fa_ist_mg_b constant varchar2(25) := 'RES_FA_IST_MG_B';            -- Fertigungsauftrag Istmenge B des gesamten Auftrags als Initialwert Auftragswechsel
    c_msg_res_fa_ist_mg_s constant varchar2(25) := 'RES_FA_IST_MG_S';            -- Fertigungsauftrag Istmenge Schrott des gesamten Auftrags als Initialwert Auftragswechsel
    c_msg_res_res_status_id constant varchar2(25) := 'MSG_RES_RES_STATUS_ID';      -- Bei Statusänderung der Resource (Maschine)

    msg_mc_res_auf_stat_ruesten constant number := 1; -- Auftrags- Statuswechsel
    msg_mc_res_auf_stat_r_ende constant number := 2; -- Auftrags- Statuswechsel
    msg_mc_res_auf_stat_produktion constant number := 3; -- Auftrags- Statuswechsel
    msg_mc_res_auf_stat_p_ende constant number := 4; -- Auftrags- Statuswechsel
    msg_mc_res_status_wechsel constant number := 5; -- ResStatus- Statuswechsel
    msg_mc_res_schicht_anfang constant number := 6; -- ResStatus- Statuswechsel
    msg_mc_res_schicht_ende constant number := 7; -- ResStatus- Statuswechsel
    msg_mc_res_schicht_wechsel constant number := 8; -- ResStatus- Statuswechsel
    msg_mc_res_reset constant number := 9; -- Res Reset
    msg_mc_res_auf_stat_stop constant number := 10; -- Auftrags- Statuswechsel Stop
    msg_mc_res_init constant number := 11; -- Init Resource

    msc_mc_cerealia_og_einlagern constant number := msg_mc_user + 1;
    msc_mc_cerealia_og_auslagern constant number := msg_mc_user + 2;

  -- Ende message_definitions;
  --************************************************************************************************

    eti_status_soll_drucken constant varchar2(3) := 'SD';
    eti_status_gedruckt constant varchar2(3) := 'D';
    eti_status_neu_drucken constant varchar2(3) := 'ND';
    lte_komm_gleich_lte constant varchar2(30) := 'GleicheLteBenutzen';
    lte_barcode_ccg constant varchar2(3) := 'CCG';
    lte_barcode_nve constant varchar2(3) := 'NVE';
    lte_barcode_vda constant varchar2(3) := 'VDA';
    lte_barcode_std constant varchar2(3) := 'STD';
    lte_barcode_spez constant varchar2(4) := 'SPEZ';
    lgr_modul_dlg constant varchar2(10) := 'DLG';
    lgr_modul_bde constant varchar2(10) := 'BDE';
    lgr_modul_mfr constant varchar2(10) := 'MFR';
    lgr_modul_lvs constant varchar2(10) := 'LVS';
    lgr_modul_sls constant varchar2(10) := 'SLS';
    lgr_modul_order constant varchar2(10) := 'ORD';
    lgr_modul_papier constant varchar2(10) := 'PAP';
    lgr_modul_host constant varchar2(10) := 'HST';  -- HST über ISI-Order
    lgr_modul_isiplus constant varchar2(10) := 'ISI';  -- z.B. durch Automatisches Optimieren

    lte_id_gueltig_tage constant number := 7;  -- Wie lange bleibt einen LTE_ID gültig wenn sie LEER oder den Status KF oder PF hat.
    lhm_id_gueltig_tage constant number := 7;  -- Wie lange bleibt einen LHM_ID gültig wenn sie LEER ist.
    lam_id_gueltig_tage constant number := 30; -- Wie lange bleibt einen LAM_ID gültig wenn sie LEER ist.
    lte_kf_pf_gueltig constant number := 30;
    lte_voll_a constant varchar2(1) := 'A'; -- Anbruch
    lte_voll_v constant varchar2(1) := 'V'; -- Std. Menge auf der Palette

    lte_voll_txt_a constant varchar2(20) := 'Anbruch'; -- Anbruch
    lte_voll_txt_v constant varchar2(20) := 'Vollpal.'; -- Std. Menge auf der Palette

    lgr_strategie_fifo constant varchar2(10) := 'FIFO';
    lgr_strategie_lifo constant varchar2(10) := 'LIFO';
    mhd_berechnen_tag constant varchar2(2) := 'TA';
    mhd_berechnen_woche_a constant varchar2(2) := 'WA';
    mhd_berechnen_woche_e constant varchar2(2) := 'WE';
    mhd_berechnen_monat_a constant varchar2(2) := 'MA';
    mhd_berechnen_monat_e constant varchar2(2) := 'ME';
    mhd_berechnen_jahr_a constant varchar2(2) := 'YA';
    mhd_berechnen_jahr_e constant varchar2(2) := 'YE';
    mhd_berechnen_tag_ constant varchar2(2) := 'AT';
    mhd_berechnen_woche_a_ constant varchar2(2) := 'AW';
    mhd_berechnen_woche_e_ constant varchar2(2) := 'EW';
    mhd_berechnen_monat_a_ constant varchar2(2) := 'AM';
    mhd_berechnen_monat_e_ constant varchar2(2) := 'EM';
    mhd_berechnen_jahr_a_ constant varchar2(2) := 'AY';
    mhd_berechnen_jahr_e_ constant varchar2(2) := 'EY';

  --FM_SUCHE_PLATZ_TE_KO     constant number :=   1; -- Ora -20001
  --FM_SUCHE_PLATZ_TE_EINLAG constant number :=   2;
  --FM_SUCHE_PLATZ_TE_SATUS  constant number :=   3;

    basis_lhm constant varchar2(3) := 'LHM';
    basis_lte constant varchar2(3) := 'LTE';
    basis_lte_vl constant varchar2(6) := 'LTE_VL';
    te_trenner constant varchar2(1) := ';'; --Euro;Indu;

  -- LGR_VERWENDUNG
    lgr_typ_lager constant varchar2(8) := 'Lager';
    lgr_typ_we constant varchar2(8) := 'WE';
    lgr_typ_wa constant varchar2(8) := 'WA';
    lgr_typ_puffer constant varchar2(8) := 'Puffer';
    lgr_typ_ep constant varchar2(8) := 'EP';
    lgr_typ_wep constant varchar2(8) := 'WEP';
    lgr_typ_lagerp constant varchar2(8) := 'LagerP';
    c_true constant varchar2(1) := 'T';
    c_false constant varchar2(1) := 'F';
    leer constant varchar2(1) := '_';
    c_anbruch_vorzug constant varchar2(1) := 'V';
    c_anbruch_ausnahme constant varchar2(1) := 'A';
    c_anbruch_ignore constant varchar2(1) := 'I';
    c_volle_behaelter constant varchar2(1) := 'B';
  -- Decode True / False in Ja / Nein
    c_txt_true constant varchar2(10) := 'Ja';
    c_txt_false constant varchar2(10) := 'Nein';
    hilfs_charge constant varchar2(1) := 'H';
    leerpal constant varchar2(2) := 'LP';
    mischpal constant varchar2(2) := 'MP';
    mischkanal constant varchar2(2) := 'MK';
    fertigware constant varchar2(2) := 'FW';
    halbware constant varchar2(2) := 'HW';
    rohware constant varchar2(2) := 'RW';

  -- welche Transporteinheiten  werden von der Software unterstützt
    ltetypenmischen constant integer := 1;              -- 0 = Nein, 1 Nur Grundtypen
    euro constant varchar2(10) := 'Euro';
    duedo constant varchar2(10) := 'DueDo';
    eurok constant varchar2(10) := 'Euro-K';
    eurokh1 constant varchar2(10) := 'Euro-KH1';
    chepeuro constant varchar2(10) := 'ChepEuro';
    indu constant varchar2(10) := 'Indu';
    chepindu constant varchar2(10) := 'ChepIndu';
    gibo constant varchar2(10) := 'GiBo';
    ewegk constant varchar2(10) := 'EWegK';
    ewegg constant varchar2(10) := 'EWegG';
    ewegi constant varchar2(10) := 'EWegI';
    keinelte constant varchar2(10) := '-Keine LTE';
    virtuallte constant varchar2(10) := '-Virtual'; -- WK ? mit "-" ok? -> wegen Sortierung (werden immer oben angezeigt)

  -- LVS Lagerort max. 3 stellen Trenner Lagerorte ist ..
    lort_format constant varchar2(1) := '0';
    lort_trenner constant varchar2(1) := ';';
    lort_laenge constant number := 4;

  -- Welche lagertypen werden IN der Software unterstützt
    sat1 constant varchar2(10) := 'SAT1';
    sat_epl1 constant varchar2(10) := 'SAT_EPL1'; -- Sateliten Einzelplatzlager opti auf Leistung
    sat_epl2 constant varchar2(10) := 'SAT_EPL2'; -- Segmentlager opti auf Kompremierung
    epl1 constant varchar2(10) := 'EPL1';
    kanal1 constant varchar2(10) := 'KANAL1';
    kanal_bkl1 constant varchar2(10) := 'KANBKL1'; -- Kanal als Blocklager mit Reservierung
    bkl1 constant varchar2(10) := 'BKL1';
    reg_fach1 constant varchar2(10) := 'REG_FACH1'; -- Regalfach mit freiher höhe (Wie HUF)
    seg1 constant varchar2(10) := 'SEG1';      -- Segmentlager
    seg_duedo1 constant varchar2(10) := 'SEG_DUEDO1';-- Segmentlager, in dem in der Tiefe zu Plätze freigeschaltet werden können
    pp_epl1 constant varchar2(10) := 'PP_EPL1';   -- Einzelplatzlager fürd Palettierer
    durchl1 constant varchar2(10) := 'DURCHL1';   -- Durchlauflager
    stap_flae1 constant varchar2(10) := 'STAP_FLAE1'; -- Dynamische Fläche zum Stapeln von Platten
    stap_flae2 constant varchar2(10) := 'STAP_FLAE2'; -- Dynamische Fläche zum Stapeln von Platten mit festen MIN und Max Werten

    we constant varchar2(10) := 'WE';
    wa constant varchar2(10) := 'WA';
    mfr_auul_kompl constant varchar2(1) := 'F';

  -- Verwendung der Kanaele und Sat_lager
    lgr_m_k constant varchar2(11) := 'MischKANAL;';     -- Mischkanal
    lgr_m_p constant varchar2(11) := 'MischPal;';       -- Kanal für Mischpalletten

  -- Statustypen für LTS's
    lte_ff_stat constant varchar2(3) := 'FF'; -- Palette ist im Status Freifahren
    lte_pf_stat constant varchar2(3) := 'PF'; -- Palettiert frei
    lte_kf_stat constant varchar2(3) := 'KF'; -- Korrekturstatus
    lte_bs_stat constant varchar2(3) := 'B';  -- Wird befüllt
    lte_bf_stat constant varchar2(3) := 'BF'; -- Wird fertig
    lte_ed_stat constant varchar2(3) := 'ED'; -- TE soll eingelagert werden
    lte_et_stat constant varchar2(3) := 'ET'; -- TE wird eingelagert und ist aufgenommen
    lte_lf_stat constant varchar2(3) := 'LF'; -- TE ist eingelagert am Ziel
    lte_ad_stat constant varchar2(3) := 'AD'; -- TE soll ausgelagert werden
    lte_at_stat constant varchar2(3) := 'AT'; -- TE wird ausgelagert Und TE ist aufgenommen
    lte_af_stat constant varchar2(3) := 'AF'; -- TE ist ausgelagert im Lager
    lte_ag_stat constant varchar2(3) := 'AG'; -- TE ist ausgelagert und weg
    lte_ar_stat constant varchar2(3) := 'AR'; -- TE ist ausgelagert und Rueckgelagert
    lte_ud_stat constant varchar2(3) := 'UD'; -- TE soll umgelagert werden
    lte_ut_stat constant varchar2(3) := 'UT'; -- TE wird umgelagertund  TE ist aufgenommen
    lte_uf_stat constant varchar2(3) := 'UF'; -- TE Umlagerung Fertig (Steht zum weitertransport auf einem WA)

  -- Vorgangstypen für Lagerbewegungen (LAM_BH)

    lam_bh_zugagng constant varchar2(2) := 'LZ';  -- Lagerzugang
    lam_bh_abgagng constant varchar2(2) := 'LA';  -- Lagerabgang
    lam_bh_umlag constant varchar2(2) := 'LU';  -- Umlagerung
    lam_bh_sprere constant varchar2(2) := 'SP';  -- Sperren
    lam_bh_umpacken constant varchar2(2) := 'UP';  -- Umpacken (Aufpacken auf eine Palette)
    lam_bh_inv constant varchar2(2) := 'IV';  -- Inventur
    lam_bh_wke constant varchar2(2) := 'KE';  -- Konsi-Entnahme

    lam_bh_bus_inv constant number := 1;     -- Inventur
    lam_bh_bus_zug constant number := 2;     -- Lagerzugang
    lam_bh_bus_abg constant number := 3;     -- Lagerabgang
    lam_bh_bus_uml constant number := 4;     -- Umlagerung
    lam_bh_bus_sp constant number := 5;     -- Warenbestand sperren
    lam_bh_bus_up constant number := 6;     -- Pick und Put Umpacken
    lam_bh_bus_q constant number := 7;     -- Quarantäne mit abbuchung
    lam_bh_bus_zug_komm constant number := 12;    -- Lagerzugang KommDirekt
    lam_bh_bus_abg_komm constant number := 13;    -- Lagerabgang KommDirekt
    lam_bh_bus_ivz constant number := 14;    -- geZaehlte InVentur (wo auch ein Zaehl-Datum geschrieben wird)
    lam_bh_bus_zug_konsi constant number := 22;    -- Lagerzugang KONSI-LAGER (KWE aus ISI-Order BK)
    lam_bh_bus_abg_konsi constant number := 23;    -- Lagerabgang KONSI-LAGER (KWA aus ISI-Order LK)
    lam_bh_bus_wke_konsi constant number := 24;    -- Warenentnahme KONSI-LAGER (WKE aus KONSI wird freier Bestand)

    lte_einl constant varchar2(10) := 'EINL';-- Einlagern
    lte_ausl constant varchar2(10) := 'AUSL';-- Auslagern

  -- Status für Transporte
    trans_frei constant varchar2(1) := 'F';  -- Auftrag ist frei, kann vergeben werden
    trans_gesperrt constant varchar2(1) := 'G';  -- Auftrag ist gesperrt, darf keinem Zugewiesen und von keinem begonnen werden
    trans_zugew constant varchar2(1) := 'Z';  -- Auftrag ist einem Fahrzeug zugewiesen
    trans_begin constant varchar2(1) := 'B';  -- Fahrzeug ist auf dem Weg zur LTE
    trans_transport constant varchar2(1) := 'T';  -- Palette wird Transportiert
    trans_sort_sperre constant varchar2(1) := 'S';  -- Auftrag ist gesperrt, soll sortiert werden

  -- 20081211: Anpassung für Smithuis
    mhd_ms_min_tage constant integer := -1;   -- Cer 60 -- Min MHD für Ware die an einer Maschine weiterverarbeitet wird
    mhd_rw_min_tage constant integer := -1;   -- Cer 30 -- Min MHD für Rohware zum Ausliefern
    mhd_hw_min_tage constant integer := -1;   -- Cer 30 -- Min MHD für Halbfertigware zum Ausliefern
    mhd_fw_min_tage constant integer := -1;   -- Cer 30 -- Min MHD für Fertigware zum Ausliefern

    fmid_bestand_reicht_nicht constant integer := 800;
    fmid_resource_fehlt constant integer := 801;
    fmid_lte_id_res constant integer := 802;
    fmid_seq_fehler constant integer := 803;
    fmid_buch_fehler constant integer := 804;
    fmid_quelle_existiert_nicht constant integer := 950;
    fmid_ziel_existiert_nicht constant integer := 951;
    fmid_lte_id_null constant integer := 952;
    fmid_lte_id_schon_vorhanden constant integer := 953;
    fmid_quellkanal_leer constant integer := 954;
    fmid_quelle_nicht_belegt constant integer := 955;
    fmid_ziel_voll constant integer := 956;
    fmid_artikelnummer_fehlt constant integer := 957;
    fmid_palettetyp_fehlt constant integer := 958;
    fmid_lagerplatz_gesperrt constant integer := 959;
    fmid_platz_kein_we constant integer := 960;
    fmid_lte_id_fehlt constant integer := 961;
    fmid_lager_platz_fehlt constant integer := 962;
    fmid_falscher_lte_status constant integer := 963;
    fmid_platz_nicht_io constant integer := 964;
    fmid_lte_hat_transport constant integer := 965;
    fmid_lte_falscher_platz constant integer := 966;
    fmid_weg_von_nach_falsch constant integer := 967;
    fmid_falscher_lte_type constant integer := 968;
    fmid_falsche_temperatur constant integer := 969;
    fmid_falsche_wertklasse constant integer := 970;
    fmid_falsche_gefahrenklasse constant integer := 971;
    fmid_lte_ist_zu_schwer constant integer := 972;
    fmid_lte_zu_gross constant integer := 973;
    fmid_lgr_type_unbekannt constant integer := 974;
    fmid_keine_lagerorte constant integer := 975;
    fmid_kein_platz_fuer_lte constant integer := 976;
    fmid_falscher_bearbmodul constant integer := 977;
    fmid_falsche_buchungsart constant integer := 978;
    fmid_zuggang_buchen constant integer := 979;
    fmid_alle_fahrz_ausgelastet constant integer := 980;
    fmid_kein_fahrz_bereit_orte constant integer := 981;
    fmid_inventur_artikel constant integer := 982;
    fmid_inventur_platz constant integer := 983;
    fmid_inventur_ort constant integer := 984;
    fmid_inventur constant integer := 985;
    fmid_transp_grp_falsch constant integer := 986;
    fmid_param_fehlen constant integer := 987;
    fmid_transp_grp_vorhanden constant integer := 988;
    fmid_transp_id_fehlt constant integer := 989;
    fmid_transp_grp_fehlt constant integer := 990;
    fmid_lager_cfg_nio constant integer := 991;


  -- Status für Transporte
    max_anz_liefs_tage constant integer := 31;   -- Maximal angezeigte Tage für Lieferscheindruck

  -- Status Decoder !!!
    lab_stat_q constant varchar2(1) := 'Q';  -- Quarantäne
    lab_stat_u constant varchar2(1) := 'U';  -- Unfrei
    lab_stat_b constant varchar2(1) := 'B';  -- Bedingt Frei
    lab_stat_g constant varchar2(1) := 'G';  -- Gesperrt
    lab_stat_f constant varchar2(1) := 'F';  -- Frei
    lab_stat_m constant varchar2(1) := 'M';  -- Muster
    lab_stat_w constant varchar2(1) := 'W';  -- Warenausgangsprüfung
    lab_stat_s constant varchar2(1) := 'S';  -- Sonderprüfung

    lab_stat_txt_q constant varchar2(10) := 'Quarantäne';
    lab_stat_txt_u constant varchar2(10) := 'Unfrei';
    lab_stat_txt_b constant varchar2(10) := 'Bed. Frei';
    lab_stat_txt_g constant varchar2(10) := 'Gesperrt';
    lab_stat_txt_f constant varchar2(10) := 'Frei';
    lab_stat_txt_m constant varchar2(10) := 'Muster';
    lab_stat_col_q constant varchar2(10) := '@@00E100E1';
    lab_stat_col_u constant varchar2(10) := '@@008D8D8D';
    lab_stat_col_b constant varchar2(10) := '';
    lab_stat_col_g constant varchar2(10) := '@@000000D7';
    lab_stat_col_f constant varchar2(10) := '@@00007D00';
    lgr_gesperrt_g constant varchar2(1) := 'G';
    lgr_gesperrt_f constant varchar2(1) := 'F';
    lgr_gesperrt_txt_f constant varchar2(10) := 'Frei';
    lgr_gesperrt_txt_g constant varchar2(10) := 'Gesperrt';
    lgr_gesperrt_col_g constant varchar2(10) := '@@000000D7';
    lgr_gesperrt_col_f constant varchar2(10) := '@@00007D00';

  -- Returns fuer Transport Quittung
    transport_fehlt constant integer := -1;
    lte_fehlt constant integer := -2;
    lgr_fehlt constant integer := -3;
    lgr_lte_fehlt constant integer := -4;
    lgr_q_fehlt constant integer := -5;
    lgr_z_fehlt constant integer := -6;
    lgr_transp_begonnen constant integer := -7;
    lgr_res_fehlt constant integer := -8;
    lgr_reihenfolge_falsch constant integer := -9;
    lgr_voll constant integer := -10;
    lgr_dispo_voll constant integer := -11;
    lgr_res_string constant integer := -20;
    lgr_ziel_typ_falsch constant integer := -50;
    transport_txt_fehlt constant varchar2(30) := 'Transportauftrag fehlt';
    lte_txt_fehlt constant varchar2(30) := 'LTE fehlt';
    lgr_txt_fehlt constant varchar2(30) := 'Lagerplatz fehlt';
    lgr_lte_txt_fehlt constant varchar2(30) := '???';
    lgr_q_txt_fehlt constant varchar2(30) := 'Quellelagerplatz fehlt';
    lgr_z_txt_fehlt constant varchar2(30) := 'Ziellagerplatz fehlt';
    lgr_transp_txt_begonnen constant varchar2(30) := 'Transport bereits begonnen';
    lgr_res_txt_fehlt constant varchar2(30) := 'Resource fehlt';
    lgr_reihenf_txt_falsch constant varchar2(30) := 'Transport Reihenfolge Falsch';
    lgr_txt_voll constant varchar2(30) := 'Lager ist voll';
    lgr_dispo_txt_voll constant varchar2(30) := 'Lagergruppe ist voll';
    lgr_res_txt_string constant varchar2(30) := 'Res-string ist falsch';

  -- LGR_RES_TXT_STRING      constant varchar2(30) := 'Lagergruppe ist voll';

    lgr_ziel_typ_txt_falsch constant varchar2(30) := 'Transportstatus ist falsch';
    lgr_transp_std_prio_ms constant number := 5;            -- Std Prio für Transporte an eine Maschine
    lgr_transp_std_prio_wa constant number := 3;            -- Std Prio für Transporte Auslagerung
    lgr_transp_std_prio_we constant number := 4;            -- Std Prio für Transporte Einlagerung
    lgr_transp_std_prio_ul constant number := 1;            -- Std Prio für Transporte Umlagerung
    lgr_transp_std_prio_ff constant number := 10;           -- Std Prio für Transporte Freifahren

  -- Werte für Lagerplatzfindung
  -- Gilt für alle Typen (Achtung, im Blocklager ist der Res.String nicht gesetzt. Der Wert ist dann immer LGR_PLATZ_LEER)
    lgr_platz_res_string constant number := 1;           -- Multiplikator für gleichen Reservirungsstring
    lgr_platz_leer constant number := 1.1;         -- Multiplikator für leeren Platz
    lgr_platz_misch_kanal constant number := 1.3;         -- Multiplikator für Mischkanäle
    lgr_platz_misch_pal constant number := 1.4;         -- Multiplikator für Kanäle mit Mischpaletten
    lgr_platz_falsch constant number := 99;          -- Multiplikator für Kanäle die mit anderen Artikeln gefüllt sind
  -- 20081211: Anpassung für Smithuis
    lgr_platz_factor_max constant number := 99999999;    -- Schlechter darf der Platz in der Bewertung nicht sein (Nur Belegung)

  -- Nur Regallager (Einzelplatz, Kanal oder Sat-Lager)
                                                                 -- Diese Einstellung sagt RW unten FW u. HW oben, MP egal
    lgr_hoehe_fw_wert constant integer := 0;           -- Welchen Einfluss soll (FW) auf die hoehe im Regal haben
    lgr_hoehe_rw_wert constant integer := 0;           -- Welchen Einfluss soll (RW) auf die hoehe im Regal haben
    lgr_hoehe_hw_wert constant integer := 0;           -- Welchen Einfluss soll (HW) auf die hoehe im Regal haben
    lgr_hoehe_mp_wert constant integer := 0;           -- Welchen Einfluss soll (MP) auf die hoehe im Regal haben

    lgr_abc_wert constant integer := 1;           -- Faktor besser, schlechter für ABC-Abgleich
    lgr_art_res constant integer := 20;          -- Faktor besser, schlechter wenn für einen Kanal eine Artikelreservierung vorgenommen wurde

    lgr_ort_abstand_faktor constant integer := -1;          -- Abstand der Lagerorte nach LGR_ORT
  -- 20081211: Anpassung für Smithuis
    lgr_abstand_faktor constant integer := -1;         -- Abstand der Lagerplaetze nach LGR_DIM_PLATZ
                                                                 -- 0 = Abstand egal 1 = Gorsser Abstand gut -1 kleiner Abstand gut
    lgr_platz_r_faktor constant integer := 1;          -- 0 = Egal, -1 = Große Platznummer gut, 1 = kleine gut

  -- Hier sind die Faktoren, mit dem man freihe Hoehen Gewicht etc fuer die Lagerplatzfindung genutzt werden kann
  -- (Faktor Abstand wird mit diesem Produkt multiliziert)
    lgr_gewicht_relevanz constant integer := null;        -- Faktor mit dem das Differenzgewicht multpliziert wird um der Lagerplatz zu bewerten
    lgr_hoehe_relevanz constant integer := null;        -- Faktor mit dem die freihe Hoehe multpliziert wird um der Lagerplatz zu bewerten
  -- Tiefe und Breite wird z.Zt. nicht beruecksichtigt.
    lgr_breite_relevanz constant integer := null;        -- Faktor mit dem die freihe Tiefe multpliziert wird um der Lagerplatz zu bewerten
    lgr_tiefe_relevanz constant integer := null;        -- Faktor mit dem die freihe breite multpliziert wird um der Lagerplatz zu bewerten

  -- (Faktor Abstand wird mit diesem Produkt multiliziert bei Gleichverteilung in Lagergruppen)
    lgr_fuellgrad_relevanz constant integer := 1000000000;   -- Faktor mit dem der Füllgrad in Prozent multipliziert wird, wenn im Lager gleichverteilung gewünscht ist

  -- Keine Relevanz bei Kanal-Blocklager
    lgr_platz_ausl_dispo constant integer := 100;         -- Um wieviel schlechter wird der PLatz bei je Auslagerung
    lgr_order_reservierung constant integer := 0.5;         -- Um wieviel schlechter wird der PLatz bei je Auslagerreservirung
  -- Nur Blocklager
    lgr_platz_verfueg constant integer := 1;           -- Um wieviel besser wird der PLatz bei je Verfügbaren Platz
    lgr_platz_akt_lte constant integer := 1;           -- Um wieviel besser wird der PLatz bei je power(LTE, 2)
  -- LGR_PLATZ_VERFUEG        constant integer      := 1;           -- Um wieviel schlechter wird der PLatz bei je Auslagerung

    v_nr integer;
    v_ts timestamp;
    v_gleich varchar2(4096);
    function decode_function_fehler (
        return_value in integer
    ) return varchar2;

    function decode_lte_voll (
        return_value in varchar2
    ) return varchar2;

    function decode_true_false (
        return_value in varchar2
    ) return varchar2;

    function r_sat1 return varchar2;

    function r_sat_epl1 return varchar2;

    function r_sat_epl2 return varchar2;

    function r_epl1 return varchar2;

    function r_kanal1 return varchar2;

    function r_kanal_bkl1 return varchar2;

    function r_bkl1 return varchar2;

    function r_reg_fach1 return varchar2;

    function r_seg1 return varchar2;

    function r_seg_duedo1 return varchar2;

    function r_pp_epl1 return varchar2;

    function r_durchl1 return varchar2;

    function r_stap_flae1 return varchar2;

    function r_stap_flae2 return varchar2;

    function r_c_false return varchar2;

    function r_c_true return varchar2;

    function r_lte_voll_v return varchar2;

    function r_lte_voll_a return varchar2;

    function r_c_anbruch_ausnahme return varchar2;

    function r_c_anbruch_vorzug return varchar2;

    function r_c_anbruch_ignore return varchar2;

    function r_lgr_gesperrt_f return varchar2;

    function r_lgr_abstand_faktor return integer;

    function r_lgr_platz_r_faktor return integer;

    function r_mhd_ms_min_tage return integer;

    function r_mhd_rw_min_tage return integer;

    function r_mhd_hw_min_tage return integer;

    function r_mhd_fw_min_tage return integer;

    function r_lgr_typ_we return varchar2;

    function r_lgr_typ_wa return varchar2;

    function r_lgr_typ_lager return varchar2;

    function r_lgr_typ_puffer return varchar2;

    function r_lgr_typ_lagerp return varchar2;

    function r_lam_bh_bus_inv return integer;

    function r_lam_bh_bus_zug return integer;

    function r_lam_bh_bus_abg return integer;

    function r_lam_bh_bus_uml return integer;

    function r_lam_bh_bus_sp return integer;

    function r_lam_bh_bus_up return integer;

    function r_lam_bh_bus_q return integer;

    function r_lam_bh_bus_zug_komm return integer;

    function r_lam_bh_bus_abg_komm return integer;

    function r_lam_bh_bus_gezae_inv return integer;

    function r_lam_bh_bus_zug_konsi return integer;

    function r_lam_bh_bus_abg_konsi return integer;

    function r_lam_bh_bus_uml_konsi return integer;

    function r_lte_ff_stat return varchar2;

    function r_lte_pf_stat return varchar2;

    function r_lte_kf_stat return varchar2;

    function r_lte_bs_stat return varchar2;

    function r_lte_bf_stat return varchar2;

    function r_lte_ed_stat return varchar2;

    function r_lte_et_stat return varchar2;

    function r_lte_lf_stat return varchar2;

    function r_lte_ad_stat return varchar2;

    function r_lte_af_stat return varchar2;

    function r_lte_ag_stat return varchar2;

    function r_lte_ud_stat return varchar2;

    function r_lte_ut_stat return varchar2;

    function r_lab_stat_q return varchar2;

    function r_lab_stat_u return varchar2;

    function r_lab_stat_b return varchar2;

    function r_lab_stat_g return varchar2;

    function r_lab_stat_f return varchar2;

    function r_lort_laenge return number;

    function r_lgr_platz_res_string return number;

    function r_lgr_platz_leer return number;

    function r_lgr_platz_misch_kanal return number;

    function r_lgr_platz_misch_pal return number;

    function r_lgr_platz_falsch return number;

    function r_max_anz_liefs_tage return number;

    function r_fmid_quelle_existiert_nicht return integer;

    function r_fmid_ziel_existiert_nicht return integer;

    function r_fmid_lte_id_null return integer;

    function r_fmid_lte_id_schon_vorhanden return integer;

    function r_fmid_quellkanal_leer return integer;

    function r_fmid_quelle_nicht_belegt return integer;

    function r_fmid_ziel_voll return integer;

    function r_fmid_artikelnummer_fehlt return integer;

    function r_fmid_palettetyp_fehlt return integer;

    function r_fmid_lagerplatz_gesperrt return integer;

    function r_fmid_platz_kein_we return integer;

    function r_fmid_lte_id_fehlt return integer;

    function r_fmid_lager_platz_fehlt return integer;

    function r_fmid_falscher_lte_status return integer;

    function r_fmid_platz_nicht_io return integer;

    function r_fmid_lte_hat_transport return integer;

    function r_fmid_lte_falscher_platz return integer;

    function r_fmid_weg_von_nach_falsch return integer;

    function r_fmid_falscher_lte_type return integer;

    function r_fmid_falsche_temperatur return integer;

    function r_fmid_falsche_wertklasse return integer;

    function r_fmid_falsche_gefahrenklasse return integer;

    function r_fmid_lte_ist_zu_schwer return integer;

    function r_fmid_lte_zu_gross return integer;

    function r_fmid_lgr_type_unbekannt return integer;

    function r_fmid_keine_lagerorte return integer;

    function r_fmid_kein_platz_fuer_lte return integer;

    function r_fmid_falscher_bearbmodul return integer;

    function r_fmid_falsche_buchungsart return integer;

    function r_fmid_zuggang_buchen return integer;

    function r_fmid_alle_fahrz_ausgelastet return integer;

    function r_fmid_kein_fahrz_bereit_orte return integer;

    function sql_count (
        in_nr     in integer,
        in_gleich in varchar2,
        in_ts     in timestamp
    ) return integer;

    function decode_labor_status (
        labor_status in lvs_lam.labor_status%type
    ) return varchar2;

    function decode_labor_status_farbe (
        labor_status in lvs_lam.labor_status%type
    ) return varchar2;

    function decode_lgr_sperre (
        gesperrt in lvs_lgr.gesperrt%type
    ) return varchar2;

    function decode_lgr_sperre_farbe (
        gesperrt in lvs_lgr.gesperrt%type
    ) return varchar2;

end c;
/


-- sqlcl_snapshot {"hash":"d50758bdf72127032a5cba809c3f255d775df19a","type":"PACKAGE_SPEC","name":"C","schemaName":"DIRKSPZM32","sxml":""}