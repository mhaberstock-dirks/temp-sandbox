create or replace package dirkspzm32.lvs_p_lte is
/*
  Sammlung von Funktionen und Prozeduren für das LVS

  @author -AG- Hans Joachim Gödeke

-- HISTORY
--__________________________________________________
-- Datum       Version     AUTOR    Comment
--11.02.2015   3.5.8.x     (-AG-)   Kommentare in JavaDoc-Style geändert
--21.11.2013   3.5.7       (-WK-)   Erweiterungen für Eigentümer (Konsignationsware)
--27.11.2009   3.5.0.5     (-BW-)   Minor Release
--             3.4.8.4     (-WK-)   20080923: lvs_lhm_drucken public gemacht
--             3.4.4.3     (-AG-)   Erweiterung für Sasol Spez_Barcode
--             3.3.4.2     (-AG-)   Erweiterung für [2232] SLS Expressanforderungen mit Zeitrahmen
--             3.3.4.1     (-WK-)   Bugfix in "lvs_lte_delete" -> löschen einer LTE löscht auch bei Ausgelagerten LTE alle LAM/LHM mit
--                                  Bugfix in "lvs_c_lte_del_leer" -> löschen der LTE, auch wenn "korr_te_ausbuchen" fehlschlägt
--                                                       -> Cursor hatte "Full Tablescan" (Join mit LAM_ID fehlte
--              3.3.4.0              Einbau der Versionierung und neue Funktion für die Anlage einer Palette mit
--                                  Artikel und Lageror

  @date 26.04.2004 09:06:35

  type t_res_rec is record
        (
          order_pos_auf_id          lvs_lam.order_pos_auf_id%type,
          res_menge                 lvs_lam.res_menge%type,
          res_login_id              lvs_lam.res_login_id%type,
          menge                     lvs_lam.menge%type
        );
  type t_res is table of t_res_rec
      index by binary_integer;

  v_res_tab                             t_res;
  v_res_tab_init                        t_res;
*/
  -------------------------------------------------------------------------------------------------------
  -- Release handling
  -------------------------------------------------------------------------------------------------------
    v_release_major constant number := 3;
    v_release_minor constant number := 5;
    v_revision constant number := 7;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '21.11.2013';
    v_release_str constant varchar2(20) := to_char(v_release_major)
                                           || '.'
                                           || to_char(v_release_minor)
                                           || '.'
                                           || to_char(v_revision)
                                           || ' / '
                                           || v_rev_date;

  -- v_version_str    constant  varchar2(20) := '3.5.7.5 / 21.11.2013';
/*
  Die Funktion gibt das Release des Package zurueck
  @author -WK- Wilheln Kröker
  @return v_release_str
*/
    function get_release return varchar2;
/*
  Die Funktion gibt die Version des Package zurueck
  @author -AG- Hans Joachim Gödeke
  @return v_version_str
*/
    function get_version return varchar2;

    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    );

  -------------------------------------------------------------------------------------------------------
  -- Public declarations
  -------------------------------------------------------------------------------------------------------

  -- public global variable
    v_lvs_lte_id lvs_lte.lte_id%type;

/*
  Die Procedure erzeugt eine LTE oder verwendet eine mit Status PF oder eine leere

  Deckel zu LVS_LTE_ARTIKEL_ERZEUGEN_V3412

  @author -AG- Hans Joachim Gödeke

  @param in_sid                 in isi_sid.sid%type,
  @param in_firma_nr            in isi_firma.firma_nr%type,
  @param in_lte_id              in lvs_lte.lte_id%type,                 ID Des Gebindes
  @param in_artikel             in isi_artikel.artikel%type,            Artikelnummer (Nicht Artikel ID)
  @param in_menge_basis         in lvs_lam.menge_basis%type,            Defaut = LKE Hier wird hinterlegt, welche Einheit zugrunde liegt
                                                                        1 LTE = Eine Palette mit Standard LTE-Menge
                                                                        1 LHM = Ein karton mit LHM-Standard-Menge
                                                                        1 LKE = Default Menge in Mengenheiheit z.B. Stück
  @param in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,    Basismengeneinheit Stk, M, L, KG, ...
  @param in_charge              in lvs_charge.charge_bez%type,          Charge Wert muss gesetzt sein. Ohnen Charge im ISI nicht möglich
  @param in_menge               in lvs_lam.menge%type,                  Menge (NULL Wert wird aus Artikelstamm übernommen) Siehe auch in_menge_basis
  @param in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,          Hoehe des Gebindes Brutto (Wert sollte immer mitgegeben werden - NULL Wert wird aus den Stammdaten berechnet)
  @param in_lte_breite          in lvs_lte.lte_vol_breite%type,         Breite des Gebindes Brutto (Wert sollte immer mitgegeben werden - NULL Wert wird aus den Stammdaten berechnet)
  @param in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,          Tiefe des Gebindes Brutto (Wert sollte immer mitgegeben werden - NULL Wert wird aus den Stammdaten berechnet)
  @param in_lte_name            in lvs_lte.lte_name%type,               LTE-Name (NULL Wert wird aus Artikelstamm übernommen)
  @param in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,             Gewicht Brutto (NULL Wert wird aus Artikelstamm übernommen)
  @param in_prod_datum          in lvs_lam.prod_datum%type,             Produktionsdatum für MHD etc. NULL = Sysdate
  @param in_zug_datum           in lvs_lam.zug_datum%type,              Zugangsdatum NULL = SYSDATE
  @param in_mhd                 in lvs_lam.lam_mhd%type,                MHD des Materials (NULL Wert wird aus Artikelstamm übernommen)
  @param in_sep_nve             in lvs_lte.nve_nr%type,                 Seperate NVE (Gebinde-ID)
  @param in_prod_nr             in lvs_lam.leitzahl%type,               Produktionsauftragsnummer
  @param in_fa_ag               in lvs_lam.fa_ag%type,                  Arbeitsgang - produktionsvortschritt NULL = Fertig
  @param in_fa_upos             in lvs_lam.fa_upos%type,                Produktion UPOS (Split)
  @param in_wa_status           in lvs_lam.labor_status%type,           F = Frei, G = Gesperrt ...
  @param in_lief_auftragnr      in lvs_lte.res_string_statisch%type,    Diese LTE soll diesen Reservierungsstring verwenden
  @param in_login_id            in isi_user.login_id%type,              User ID des prozessverantwortlichen -1 = Automatik
  @param in_lgr_ort             in lvs_lgr_ort.lgr_ort%type);           Lagerort, an den diese LTE eingelagert werdn soll
*/
    procedure lvs_c_lte_artikel_erz_lgr_ort (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
    );

    procedure c_lvs_lhm_drucken (
        in_lhm_id       in lvs_lte.lte_id%type,
        in_kunden_nr    in isi_adressen.adr_nr%type,
        in_drucker_name in pe_drucker_cfg.drucker_name%type
    );

    procedure lvs_lhm_drucken (
        in_lhm_id       in lvs_lte.lte_id%type,
        in_kunden_nr    in isi_adressen.adr_nr%type,
        in_drucker_name in pe_drucker_cfg.drucker_name%type
    );

    function get_barcode_lfdn (
        in_sid     in lvs_charge.sid%type,
        in_format  in varchar2,
        in_barcode in varchar
    ) return number;

    function format_barcode (
        in_sid        in lvs_charge.sid%type,
        in_format     in varchar2,
        in_nummer     in number,
        in_laenge     in number,
        in_seq_basis  in varchar2,
        in_charge     in lvs_charge.charge_bez%type,
        in_artikel_id in isi_artikel.artikel_id%type,
        in_basis_id   in varchar2,
        in_menge      in number,
        in_typ        in varchar2,
        in_h_tag      in isi_hersteller.tag%type
    ) return varchar2;

    procedure lvs_c_lte_art_erz_einlag (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_artikel              in isi_artikel.artikel%type,
        in_menge_basis          in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis  in lvs_lam.mengeneinheit_basis%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_menge                in lvs_lam.menge%type,
        in_lte_hoehe            in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite           in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe            in lvs_lte.lte_vol_tiefe%type,
        in_lte_name             in lvs_lte.lte_name%type,
        in_lte_gew_kg           in lvs_lte.lte_akt_kg%type,
        in_prod_datum           in lvs_lam.prod_datum%type,
        in_zug_datum            in lvs_lam.zug_datum%type,
        in_mhd                  in lvs_lam.lam_mhd%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_prod_nr              in lvs_lam.leitzahl%type,
        in_fa_ag                in lvs_lam.fa_ag%type,
        in_fa_upos              in lvs_lam.fa_upos%type,
        in_wa_status            in lvs_lam.labor_status%type,
        in_lief_auftragnr       in lvs_lte.res_string_statisch%type,
        in_lgr_platz            in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type,
        in_login_id             in isi_user.login_id%type
    );

    procedure lvs_c_lte_artikel_erzeugen (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type
    );

    procedure lvs_lte_artikel_erzeugen (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type
    );

    procedure lvs_lte_artikel_erzeugen_v3412 (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lieferant           in lvs_lam.lieferant_nr%type
    );

/*******************************************************************************
 * procedure LVS_LTE_ARTIKEL_ERZEUGEN(...)   ohne COMMIT
 * Artikelnummer und Charge werden übergeben
 *******************************************************************************/
/*
  Die Procedure erzeugt eine LTE oder verwendet eine mit Status PF oder eine leere

  Deckel zu LVS_LTE_ARTIKEL_ERZEUGEN_V3412

  @author -AG- Hans Joachim Gödeke

  @param in_sid                 in isi_sid.sid%type,
  @param in_firma_nr            in isi_firma.firma_nr%type,
  @param in_lte_id              in lvs_lte.lte_id%type,                 ID Des Gebindes
  @param in_artikel             in isi_artikel.artikel%type,            Artikelnummer (Nicht Artikel ID)
  @param in_menge_basis         in lvs_lam.menge_basis%type,            Defaut = LKE Hier wird hinterlegt, welche Einheit zugrunde liegt
                                                                        1 LTE = Eine Palette mit Standard LTE-Menge
                                                                        1 LHM = Ein karton mit LHM-Standard-Menge
                                                                        1 LKE = Default Menge in Mengenheiheit z.B. Stück
  @param in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,    Basismengeneinheit Stk, M, L, KG, ...
  @param in_charge              in lvs_charge.charge_bez%type,          Charge Wert muss gesetzt sein. Ohnen Charge im ISI nicht möglich
  @param in_menge               in lvs_lam.menge%type,                  Menge (NULL Wert wird aus Artikelstamm übernommen) Siehe auch in_menge_basis
  @param in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,          Hoehe des Gebindes Brutto (Wert sollte immer mitgegeben werden - NULL Wert wird aus den Stammdaten berechnet)
  @param in_lte_breite          in lvs_lte.lte_vol_breite%type,         Breite des Gebindes Brutto (Wert sollte immer mitgegeben werden - NULL Wert wird aus den Stammdaten berechnet)
  @param in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,          Tiefe des Gebindes Brutto (Wert sollte immer mitgegeben werden - NULL Wert wird aus den Stammdaten berechnet)
  @param in_lte_name            in lvs_lte.lte_name%type,               LTE-Name (NULL Wert wird aus Artikelstamm übernommen)
  @param in_lhm_name            in lvs_lhm.lhm_name%type,               LHM-Name (NULL Wert wird aus Artikelstamm übernommen)
  @param in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,             Gewicht Brutto (NULL Wert wird aus Artikelstamm übernommen)
  @param in_prod_datum          in lvs_lam.prod_datum%type,             Produktionsdatum für MHD etc. NULL = Sysdate
  @param in_zug_datum           in lvs_lam.zug_datum%type,              Zugangsdatum NULL = SYSDATE
  @param in_mhd                 in lvs_lam.lam_mhd%type,                MHD des Materials (NULL Wert wird aus Artikelstamm übernommen)
  @param in_sep_nve             in lvs_lte.nve_nr%type,                 Seperate NVE (Gebinde-ID)
  @param in_prod_nr             in lvs_lam.leitzahl%type,               Produktionsauftragsnummer
  @param in_fa_ag               in lvs_lam.fa_ag%type,                  Arbeitsgang - produktionsvortschritt NULL = Fertig
  @param in_fa_upos             in lvs_lam.fa_upos%type,                Produktion UPOS (Split)
  @param in_wa_status           in lvs_lam.labor_status%type,           F = Frei, G = Gesperrt ...
  @param in_lief_auftragnr      in lvs_lte.res_string_statisch%type,    Diese LTE soll diesen Reservierungsstring verwenden
  @param in_login_id            in isi_user.login_id%type,              User ID des prozessverantwortlichen -1 = Automatik
  @param in_lgr_ort             in lvs_lgr_ort.lgr_ort%type);           Lagerort, an den diese LTE eingelagert werdn soll
*/
    procedure lvs_c_lte_artikel_erz_v358 (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lhm_name            in lvs_lhm.lhm_name%type,
        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
        in_lhm_menge           in lvs_lam.menge%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lieferant           in lvs_lam.lieferant_nr%type,
        in_auto_depal          in lvs_lte.auto_depal%type,
        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
        in_lam_sel1            in lvs_lam.lam_sel1%type,
        in_lam_sel2            in lvs_lam.lam_sel2%type,
        in_lam_sel3            in lvs_lam.lam_sel3%type,
        in_lam_sel4            in lvs_lam.lam_sel4%type,
        in_lam_sel5            in lvs_lam.lam_sel5%type,
        in_lam_sel6            in lvs_lam.lam_sel6%type,
        in_lam_sel7            in lvs_lam.lam_sel7%type,
        in_lam_sel8            in lvs_lam.lam_sel8%type,
        in_lam_sel9            in lvs_lam.lam_sel9%type,
        in_lam_sel10           in lvs_lam.lam_sel10%type
    );

    procedure lvs_c_lte_artikel_erz_v358_v2 (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lhm_name            in lvs_lhm.lhm_name%type,
        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
        in_lhm_menge           in lvs_lam.menge%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lieferant           in lvs_lam.lieferant_nr%type,
        in_auto_depal          in lvs_lte.auto_depal%type,
        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
        in_lam_sel1            in lvs_lam.lam_sel1%type,
        in_lam_sel2            in lvs_lam.lam_sel2%type,
        in_lam_sel3            in lvs_lam.lam_sel3%type,
        in_lam_sel4            in lvs_lam.lam_sel4%type,
        in_lam_sel5            in lvs_lam.lam_sel5%type,
        in_lam_sel6            in lvs_lam.lam_sel6%type,
        in_lam_sel7            in lvs_lam.lam_sel7%type,
        in_lam_sel8            in lvs_lam.lam_sel8%type,
        in_lam_sel9            in lvs_lam.lam_sel9%type,
        in_lam_sel10           in lvs_lam.lam_sel10%type,
        in_best_nr             in lvs_lam.best_nr%type,
        in_best_pos            in lvs_lam.best_pos%type,
        in_li_nr_lief          in lvs_lam.li_nr_lief%type
    );

    procedure lvs_lte_artikel_erz_v358 (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lhm_name            in lvs_lhm.lhm_name%type,
        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
        in_lhm_menge           in lvs_lam.menge%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lieferant           in lvs_lam.lieferant_nr%type,
        in_auto_depal          in lvs_lte.auto_depal%type,
        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
        in_lam_sel1            in lvs_lam.lam_sel1%type,
        in_lam_sel2            in lvs_lam.lam_sel2%type,
        in_lam_sel3            in lvs_lam.lam_sel3%type,
        in_lam_sel4            in lvs_lam.lam_sel4%type,
        in_lam_sel5            in lvs_lam.lam_sel5%type,
        in_lam_sel6            in lvs_lam.lam_sel6%type,
        in_lam_sel7            in lvs_lam.lam_sel7%type,
        in_lam_sel8            in lvs_lam.lam_sel8%type,
        in_lam_sel9            in lvs_lam.lam_sel9%type,
        in_lam_sel10           in lvs_lam.lam_sel10%type
    );

    procedure lvs_lte_artikel_erz_v358_v2 (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lhm_name            in lvs_lhm.lhm_name%type,
        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
        in_lhm_menge           in lvs_lam.menge%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lieferant           in lvs_lam.lieferant_nr%type,
        in_auto_depal          in lvs_lte.auto_depal%type,
        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
        in_lam_sel1            in lvs_lam.lam_sel1%type,
        in_lam_sel2            in lvs_lam.lam_sel2%type,
        in_lam_sel3            in lvs_lam.lam_sel3%type,
        in_lam_sel4            in lvs_lam.lam_sel4%type,
        in_lam_sel5            in lvs_lam.lam_sel5%type,
        in_lam_sel6            in lvs_lam.lam_sel6%type,
        in_lam_sel7            in lvs_lam.lam_sel7%type,
        in_lam_sel8            in lvs_lam.lam_sel8%type,
        in_lam_sel9            in lvs_lam.lam_sel9%type,
        in_lam_sel10           in lvs_lam.lam_sel10%type,
        in_best_nr             in lvs_lam.best_nr%type,
        in_best_pos            in lvs_lam.best_pos%type,
        in_li_nr_lief          in lvs_lam.li_nr_lief%type
    );

    procedure lvs_lte_artikel_erz_v359 (
        in_sid                 in isi_sid.sid%type,
        in_firma_nr            in isi_firma.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_artikel             in isi_artikel.artikel%type,
        in_menge_basis         in lvs_lam.menge_basis%type,
        in_mengeneinheit_basis in lvs_lam.mengeneinheit_basis%type,
        in_charge              in lvs_charge.charge_bez%type,
        in_menge               in lvs_lam.menge%type,
        in_lte_hoehe           in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite          in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe           in lvs_lte.lte_vol_tiefe%type,
        in_lte_name            in lvs_lte.lte_name%type,
        in_lhm_name            in lvs_lhm.lhm_name%type,
        in_lhm_hoehe           in lvs_lhm.lhm_vol_hoehe%type,
        in_lhm_breite          in lvs_lhm.lhm_vol_breite%type,
        in_lhm_tiefe           in lvs_lhm.lhm_vol_tiefe%type,
        in_lhm_lagen           in lvs_packschema_kopf.anz_lagen%type,
        in_lhm_pro_lage        in isi_artikel.lte_lhm_pro_lage%type,
        in_lhm_menge           in lvs_lam.menge%type,
        in_lte_gew_kg          in lvs_lte.lte_akt_kg%type,
        in_prod_datum          in lvs_lam.prod_datum%type,
        in_zug_datum           in lvs_lam.zug_datum%type,
        in_mhd                 in lvs_lam.lam_mhd%type,
        in_sep_nve             in lvs_lte.nve_nr%type,
        in_prod_nr             in lvs_lam.leitzahl%type,
        in_fa_ag               in lvs_lam.fa_ag%type,
        in_fa_upos             in lvs_lam.fa_upos%type,
        in_wa_status           in lvs_lam.labor_status%type,
        in_lief_auftragnr      in lvs_lte.res_string_statisch%type,
        in_login_id            in isi_user.login_id%type,
        in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
        in_lieferant           in lvs_lam.lieferant_nr%type,
        in_auto_depal          in lvs_lte.auto_depal%type,
        in_packschema_kopf_id  in lvs_lte.packschema_kopf_id%type,
        in_wickelprogramm      in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl in lvs_lte.wickelprogramm_einl%type,
        in_lam_sel1            in lvs_lam.lam_sel1%type,
        in_lam_sel2            in lvs_lam.lam_sel2%type,
        in_lam_sel3            in lvs_lam.lam_sel3%type,
        in_lam_sel4            in lvs_lam.lam_sel4%type,
        in_lam_sel5            in lvs_lam.lam_sel5%type,
        in_lam_sel6            in lvs_lam.lam_sel6%type,
        in_lam_sel7            in lvs_lam.lam_sel7%type,
        in_lam_sel8            in lvs_lam.lam_sel8%type,
        in_lam_sel9            in lvs_lam.lam_sel9%type,
        in_lam_sel10           in lvs_lam.lam_sel10%type,
        in_best_nr             in lvs_lam.best_nr%type,
        in_best_pos            in lvs_lam.best_pos%type,
        in_li_nr_lief          in lvs_lam.li_nr_lief%type,
        in_hersteller_liste    in lvs_lam.hersteller_kuerzel_liste%type
    );

    procedure lvs_c_lte_dummy_erzeugen (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_lte_id     in lvs_lte.lte_id%type,
        in_lte_hoehe  in lvs_lte.lte_vol_hoehe%type,
        in_lte_breite in lvs_lte.lte_vol_breite%type,
        in_lte_tiefe  in lvs_lte.lte_vol_tiefe%type,
        in_lte_name   in lvs_lte.lte_name%type,
        in_lte_gew_kg in lvs_lte.lte_akt_kg%type,
        in_login_id   in isi_user.login_id%type,
        in_sep_nve    in lvs_lte.nve_nr%type
    );

    function lvs_c_lte_erzeugen (
        in_sid       in isi_sid.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_linie     in lvs_prod_linie.linie_nr%type,
        in_lgr_platz in lvs_lgr.lgr_platz_gruppe%type,
        in_login_id  in isi_user.login_id%type
    ) return varchar2;

    function lvs_lte_erzeugen (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_linie           in lvs_prod_linie.linie_nr%type,
        in_lgr_platz       in lvs_lgr.lgr_platz_gruppe%type,
        in_login_id        in isi_user.login_id%type,
        in_drucker_name    in pe_drucker_cfg.drucker_name%type,
        in_et_drucker_name in pe_drucker_cfg.drucker_name%type
    ) return varchar2;

    function lvs_c_lte_insert_v34 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type
    ) return varchar2;

    function lvs_lte_insert_v34 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type
    ) return varchar2;

    function lvs_c_lte_insert_v35 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type,
        in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type
    ) return varchar2;

    function lvs_lte_insert_v35 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type,
        in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type
    ) return varchar2;

    function lvs_c_lte_insert_v358 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type,
        in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
        in_auto_depal           in lvs_lte.auto_depal%type,
        in_wickelprogramm       in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type
    ) return varchar2;

    function lvs_lte_insert_v358 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type,
        in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
        in_auto_depal           in lvs_lte.auto_depal%type,
        in_wickelprogramm       in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type
    ) return varchar2;

    function lvs_c_lte_insert_v359 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type,
        in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
        in_auto_depal           in lvs_lte.auto_depal%type,
        in_wickelprogramm       in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type,
        in_typ                  in varchar2,
        in_h_tag                in isi_hersteller.tag%type
    ) return varchar2;

    function lvs_lte_insert_v359 (
        in_sid                  in isi_sid.sid%type,
        in_firma_nr             in isi_firma.firma_nr%type,
        in_lte_name             in lvs_lhm_cfg.lhm_name%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_ls_login_id          in isi_user.login_id%type,
        in_lgr_ort              in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz            in lvs_lgr.lgr_platz%type,
        in_lte_status           in lvs_lte.lte_status%type,
        in_sep_nve              in lvs_lte.nve_nr%type,
        in_lte_eti_druck_status in lvs_lte.lte_eti_druck_status%type,
        in_charge_id            in lvs_charge.charge_id%type,
        in_charge               in lvs_charge.charge_bez%type,
        in_artikel_id           in isi_artikel.artikel_id%type,
        in_packschema_kopf_id   in lvs_packschema_kopf.packschema_kopf_id%type,
        in_auto_depal           in lvs_lte.auto_depal%type,
        in_wickelprogramm       in lvs_lte.wickelprogramm%type,
        in_wickelprogramm_einl  in lvs_lte.wickelprogramm_einl%type,
        in_typ                  in varchar2,
        in_h_tag                in isi_hersteller.tag%type
    ) return varchar2;

    procedure lvs_c_lte_delete (
        in_sid         in isi_sid.sid%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_ls_login_id in isi_user.login_id%type
    );

    procedure lvs_lte_delete (
        in_sid         in isi_sid.sid%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_ls_login_id in isi_user.login_id%type,
        in_status      in lvs_lte.lte_status%type
    );

    procedure lvs_c_lte_delete_359 (
        in_sid         in isi_sid.sid%type,
        in_lte_id      in lvs_lte.lte_id%type,
        in_ls_login_id in isi_user.login_id%type,
        in_status      in lvs_lte.lte_status%type
    );

/*
  function LVS_LTE_LHM_NEXT_ID (in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_barcode_ref in varchar2
                               ) return varchar2;
*/

    function lvs_lte_lhm_next_id_v34 (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_barcode_ref in varchar2,
        in_charge      in lvs_charge.charge_bez%type,
        in_artikel_id  in isi_artikel.artikel_id%type
    ) return varchar2;

    function lvs_lte_lhm_next_id_v35 (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_barcode_ref in varchar2,
        in_charge      in lvs_charge.charge_bez%type,
        in_artikel_id  in isi_artikel.artikel_id%type,
        in_adr_nr      in isi_adressen.adr_nr%type,
        in_typ         in varchar2,
        in_h_tag       in isi_hersteller.tag%type
    ) return varchar2;

    procedure lvs_lte_get_druck_daten (
        in_lte_id            in lvs_lte.lte_id%type,
        in_kunden_nr         in isi_adressen.adr_nr%type,
        out_lte_sid          out lvs_lte.sid%type,
        out_lte_firma_nr     out lvs_lte.firma_nr%type,
        out_rave_datei       out pe_jobs.rave_datei%type,
        out_rave_report_name out pe_jobs.rave_report_name%type,
        out_job_daten_typ    out pe_jobs.job_daten_typ%type,
        out_job_daten        out pe_jobs.job_daten%type,
        out_anz_drucke       out isi_artikel.anz_etikett_je_lte%type
    );

    procedure lvs_get_druck_daten (
        in_id                in lvs_lte.lte_id%type,
        in_kunden_nr         in isi_adressen.adr_nr%type,
        in_fuer_artikel_id   in isi_artikel.artikel_id%type,
        out_lte_sid          out lvs_lte.sid%type,
        out_lte_firma_nr     out lvs_lte.firma_nr%type,
        out_rave_datei       out pe_jobs.rave_datei%type,
        out_rave_report_name out pe_jobs.rave_report_name%type,
        out_job_daten_typ    out pe_jobs.job_daten_typ%type,
        out_job_daten        out pe_jobs.job_daten%type,
        out_anz_drucke       out isi_artikel.anz_etikett_je_lte%type
    );

    function lvs_c_lte_drucken_bde (
        in_lte_id       in lvs_lte.lte_id%type,
        in_drucker_name in pe_drucker_cfg.drucker_name%type
    ) return integer;

    function lvs_c_lte_drucken (
        in_lte_id       in lvs_lte.lte_id%type,
        in_kunden_nr    in isi_adressen.adr_nr%type,
        in_drucker_name in pe_drucker_cfg.drucker_name%type
    ) return integer;

    function lvs_lte_drucken (
        in_lte_id       in lvs_lte.lte_id%type,
        in_kunden_nr    in isi_adressen.adr_nr%type,
        in_drucker_name in pe_drucker_cfg.drucker_name%type
    ) return integer;

    function lvs_c_lte_erzeugen_drucken (
        in_sid             in isi_sid.sid%type,
        in_firma_nr        in isi_firma.firma_nr%type,
        in_linie           in lvs_prod_linie.linie_nr%type,
        in_lte_anzahl      in number,
        in_lgr_platz       in lvs_lgr.lgr_platz_gruppe%type,
        in_kunden_nr       in isi_adressen.adr_nr%type,
        in_drucker         in pe_drucker_cfg.drucker_name%type,
        in_et_drucker_name in pe_drucker_cfg.drucker_name%type default null,
        in_login_id        in isi_user.login_id%type
    ) return integer;

    procedure lvs_c_lte_transport (
        in_lte_id        in lvs_lte.lte_id%type,
        in_von_lgr_platz in lvs_lgr.lgr_platz%type,
        in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
        in_user_id       in isi_user.login_id%type
    );

    procedure lvs_lte_transport (
        in_lte_id        in lvs_lte.lte_id%type,
        in_von_lgr_platz in lvs_lgr.lgr_platz%type,
        in_zu_lgr_platz  in lvs_lgr.lgr_platz%type,
        in_user_id       in isi_user.login_id%type
    );

    procedure lvs_c_lte_lief_loeschen (
        in_lte_id in lvs_lte.lte_id%type
    );

    procedure lvs_lte_lief_erzeugen (
        in_lte_id  in lvs_lte.lte_id%type,
        in_liefers in isi_liefs.li_nr%type,
        in_kunde   in isi_liefs.adress_nr%type
    );

    procedure lvs_c_lte_lief_erzeugen (
        in_lte_id  in lvs_lte.lte_id%type,
        in_liefers in isi_liefs.li_nr%type,
        in_kunde   in isi_liefs.adress_nr%type
    );

    procedure lvs_lte_trans_h_get_lief_kd (
        in_lte_id   in lvs_lte.lte_id%type,
        out_liefers out isi_liefs.li_nr%type,
        out_kunde   out isi_liefs.adress_nr%type
    );

    procedure lvs_c_lte_lief_status (
        in_lte_id  in lvs_lte.lte_id%type,
        in_lief_nr in isi_liefs.li_nr%type,
        in_grund   in isi_liefs.inaktiv_grund%type
    );

    procedure lvs_lte_transp_gen (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_modul_erzeuger in isi_transport.modul_erzeuger%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_zu_lgr_platz   in lvs_lgr.lgr_platz%type,
        in_prio           in number,
        in_user_id        in isi_user.login_id%type,
        in_fetig_bis      in date default null
    );

    procedure lvs_c_lte_transp_gen (
        in_sid            in isi_sid.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_modul_erzeuger in isi_transport.modul_erzeuger%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_zu_lgr_platz   in lvs_lgr.lgr_platz%type,
        in_prio           in number,
        in_user_id        in isi_user.login_id%type,
        in_fetig_bis      in date default null
    );

    function lvs_lte_pruefe_platz (
        in_lte_id    in lvs_lte.lte_id%type,
        in_lgr_platz in lvs_lgr.lgr_platz%type
    ) return varchar2;

    function lvs_c_lte_auslagern (
        in_lte_id  in lvs_lte.lte_id%type,
        in_tour_nr in isi_order_pos.vorgang_id%type,
        in_user_id in isi_user.login_id%type
    ) return varchar2;

    function lvs_suche_neuen_platz_v349 (
        in_transport   in isi_transport%rowtype,
        in_user_id     in isi_user.login_id%type,
        in_prorgamm_nr in isi_transport.quelle_leer_progr_nr%type
    ) return varchar2;

    function lvs_suche_neue_lte_transp_id (
        in_sid          in isi_sid.sid%type,
        in_transport_id in isi_transport.transp_id%type,
        in_user_id      in isi_user.login_id%type
    ) return varchar2;

    function lvs_suche_neue_lte (
        in_transport in isi_transport%rowtype,
        in_user_id   in isi_user.login_id%type
    ) return varchar2;

    function lvs_suche_neue_lte_old_crtl (
        in_transport in isi_transport%rowtype,
        in_user_id   in isi_user.login_id%type,
        in_lte_crtl  in varchar2,
        in_lte_id    in lvs_lte.lte_id%type
    ) return varchar2;

    function lvs_neue_lte_res_nio_transp (
        in_transport_id in isi_transport.transp_id%type,
        in_user_id      in isi_user.login_id%type,
        in_lte_id       in lvs_lte.lte_id%type
    ) return varchar2;

    function lvs_neue_lte_res_nio_dispo (
        in_user_id in isi_user.login_id%type,
        in_lte_id  in lvs_lte.lte_id%type
    ) return varchar2;

    function lvs_c_suche_neuen_platz (
        in_transport   in isi_transport%rowtype,
        in_user_id     in isi_user.login_id%type,
        in_prorgamm_nr in isi_transport.quelle_leer_progr_nr%type
    ) return varchar2;

    function lvs_c_suche_neuen_platz_v349 (
        in_transport   in isi_transport%rowtype,
        in_user_id     in isi_user.login_id%type,
        in_prorgamm_nr in isi_transport.quelle_leer_progr_nr%type
    ) return varchar2;

    function lvs_lte_lhm_mg (
        in_vorgang_nr in isi_order_pos.vorgang_id%type
    ) return varchar2;

    procedure lvs_c_lte_del_leer (
        in_login_id in isi_user.login_id%type
    );

    function lvs_check_lte_name_format (
        in_lte_id       in lvs_lte.lte_id%type,
        in_chk_lte_name in lvs_lte.lte_name%type,
        in_chk_hoehe    in lvs_lte.lte_vol_hoehe%type,
        in_chk_breite   in lvs_lte.lte_vol_breite%type,
        in_chk_tiefe    in lvs_lte.lte_vol_tiefe%type
    ) return boolean;

    procedure lvs_set_lte_name_format (
        in_lte_id       in lvs_lte.lte_id%type,
        in_chk_lte_name in lvs_lte.lte_name%type,
        in_chk_hoehe    in lvs_lte.lte_vol_hoehe%type,
        in_chk_breite   in lvs_lte.lte_vol_breite%type,
        in_chk_tiefe    in lvs_lte.lte_vol_tiefe%type
    );

    procedure lvs_te_lagerziel_umbuchen_353 (
        in_sid                    in isi_sid.sid%type,
        in_firma_nr               in isi_firma.firma_nr%type,
        in_lte_id                 in lvs_lte.lte_id%type,
        in_ist_lgr_platz          in lvs_lgr.lgr_platz%type,
        in_ist_lgr_ort            in lvs_lgr.lgr_ort%type,
        in_ist_lgr_platz_gruppe   in lvs_lgr.lgr_platz_gruppe%type,
        in_soll_lgr_platz         in lvs_lgr.lgr_platz%type,
        in_soll_lgr_ort           in lvs_lgr.lgr_ort%type,
        in_lte_status             in lvs_lte.lte_status%type,
        in_lte_ist_status         in lvs_lte.lte_status%type,
        in_ziel_lgr_platz_n_freif in lvs_lte.ziel_lgr_platz_n_freif%type,
        in_ziel_lgr_ort_n_freif   in lvs_lte.ziel_lgr_ort_n_freif%type,
        in_l_buchung              in lvs_lte.lte_letzte_buchung%type,
        in_auf_id                 in isi_order_pos.auf_id%type,
        in_vorgang_id             in isi_order_pos.vorgang_id%type,
        in_artikel_id             in isi_artikel.artikel_id%type,
        in_transport_gruppe       in lvs_lte.transport_gruppe%type,
        in_lkw_nr                 in lvs_lte.lkw_nr%type,
        in_offset_x               in lvs_lte.lte_offset_x%type,
        in_offset_y               in lvs_lte.lte_offset_y%type,
        in_offset_z               in lvs_lte.lte_offset_z%type
    );

    procedure lvs_c_korr_te_ausbuchen (
        in_te_sid         in lvs_lte.sid%type,
        in_te_firma_nr    in lvs_lte.firma_nr%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_status     in lvs_lte.lte_status%type,
        in_lgr_sid        in lvs_lgr.sid%type,
        in_lgr_firma_nr   in lvs_lgr.firma_nr%type,
        in_lgr_ort        in lvs_lgr.lgr_ort%type,
        in_lgr_lagerplatz in lvs_lte.lgr_platz%type,
        in_ls_login_id    in isi_user.login_id%type
    );

    procedure lvs_korr_te_ausbuchen (
        in_te_sid         in lvs_lte.sid%type,
        in_te_firma_nr    in lvs_lte.firma_nr%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_lte_status     in lvs_lte.lte_status%type,
        in_lgr_sid        in lvs_lgr.sid%type,
        in_lgr_firma_nr   in lvs_lgr.firma_nr%type,
        in_lgr_ort        in lvs_lgr.lgr_ort%type,
        in_lgr_lagerplatz in lvs_lte.lgr_platz%type,
        in_ls_login_id    in isi_user.login_id%type
    );

    procedure lvs_c_korr_te_einbuchen (
        in_te_sid              in lvs_lte.sid%type,
        in_te_firma_nr         in lvs_lte.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_lte_status          in lvs_lte.lte_status%type,
        in_lgr_sid             in lvs_lgr.sid%type,
        in_lgr_firma_nr        in lvs_lgr.firma_nr%type,
        in_lgr_einl_ort        in lvs_lgr.lgr_ort%type,
        in_lgr_einl_lagerplatz in lvs_lte.lgr_platz%type,
        in_ls_login_id         in isi_user.login_id%type,
        in_lgr_platz_pruefen   in boolean default true
    );

    procedure lvs_korr_te_einbuchen (
        in_te_sid              in lvs_lte.sid%type,
        in_te_firma_nr         in lvs_lte.firma_nr%type,
        in_lte_id              in lvs_lte.lte_id%type,
        in_lte_status          in lvs_lte.lte_status%type,
        in_lgr_sid             in lvs_lgr.sid%type,
        in_lgr_firma_nr        in lvs_lgr.firma_nr%type,
        in_lgr_einl_ort        in lvs_lgr.lgr_ort%type,
        in_lgr_einl_lagerplatz in lvs_lte.lgr_platz%type,
        in_ls_login_id         in isi_user.login_id%type,
        in_lgr_platz_pruefen   in boolean default true
    );

    function lvs_get_lte_id_by_ort_x_y (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_lgr_ort  in lvs_lgr_ort.lgr_ort%type,
        in_x_pos    in lvs_lgr.lgr_pos_x%type,
        in_y_pos    in lvs_lgr.lgr_pos_y%type
    ) return varchar2;

    function lvs_c_lte_rest_einl (
        in_lte_id in lvs_lte.lte_id%type,
        io_menge  in out lvs_lam.menge%type
    ) return number;

    function lvs_suche_neue_lte_old_crtl_31 (
        in_transport in isi_transport%rowtype,
        in_user_id   in isi_user.login_id%type,
        in_lte_crtl  in varchar2,
        in_lte_id    in lvs_lte.lte_id%type
    ) return varchar2;

    function lvs_suche_neue_lte_old_crtl_fa (
        in_transport in isi_transport%rowtype,
        in_user_id   in isi_user.login_id%type,
        in_lte_crtl  in varchar2,
        in_lte_id    in lvs_lte.lte_id%type
    ) return varchar2;

    function lvs_suche_neue_lte_old_crtl_or (
        in_transport in isi_transport%rowtype,
        in_user_id   in isi_user.login_id%type,
        in_lte_crtl  in varchar2,
        in_lte_id    in lvs_lte.lte_id%type
    ) return varchar2;

end lvs_p_lte;
/


-- sqlcl_snapshot {"hash":"136f6651559b2f7d828a357b4d4a36f1d3a27484","type":"PACKAGE_SPEC","name":"LVS_P_LTE","schemaName":"DIRKSPZM32","sxml":""}