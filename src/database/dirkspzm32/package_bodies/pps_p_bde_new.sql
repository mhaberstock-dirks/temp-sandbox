create or replace 
package body DIRKSPZM32.pps_p_bde_new is

  -- Record Struktur als Basis für die erstellung von BDE und PPS daten


  -- BDE Struktur und Tabelle zur Erstellung der Relationen zwischen AG und STL
  -- für das Beziehungswissen welche Teile sind in diesem AG relevant
  type t_stl_tab is table of bde_fa_auftrag_stl%rowtype index by binary_integer;

  v_stl_tab_ix    number;
  v_stl_tab_i     number;
  v_stl_tab       t_stl_tab;
  v_stl_tab_empty t_stl_tab;

  -- PPS-Auftrag Struktur und Tabelle zur Erstellung der Relationen zwischen
  -- AG und STL für das Beziehungswissen welche Teile sind in diesem AG relevant
  type t_pps_stl_tab is table of pps_plan_auftrag_ag_stl%rowtype index by binary_integer;

  v_pps_stl_tab_ix    number;
  v_pps_stl_tab_i     number;
  v_pps_stl_tab       t_pps_stl_tab;
  v_pps_stl_tab_empty t_pps_stl_tab;

  v_plan_auf_ag_id pps_plan_auftrag_ag.plan_auf_ag_id%type;
  v_ag_max         number;

  ---------------------------------------------------------------------------------------
  -- procedure create_bde_fa_auftrag
  -- Erzeugt eine Eintrag in der BDE_FA_AUFTRAG
  ---------------------------------------------------------------------------------------
  procedure create_bde_fa_auftrag(in_ag_satzart              in bde_fa_auftrag.satzart%type,
                                  in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                  in_artikel_id              in isi_artikel.artikel_id%type,
                                  in_zeichnung               in isi_artikel.zeichnung%type,
                                  in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                  in_charge_bez              in lvs_charge.charge_bez%type,
                                  in_login_id                in isi_user.login_id%type,
                                  in_menge                   in lvs_lam.menge%type,
                                  in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                  in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                  in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                  in_lte_name                in bde_fa_auftrag.lte_name%type,
                                  in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                  in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                  in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                  in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                  in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                  in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                  in_abnr                    in bde_fa_auftrag.abnr%type,
                                  in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                  in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                  in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                  in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                  in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                  in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                  in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                  in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                  in_bde_fa_plan             in t_bde_fa_plan);

  ---------------------------------------------------------------------------------------
  -- procedure create_pps_auftrag_ag
  -- Erzeugt eine Eintrag in der PPS_PLAN_AUFTRAG_AG
  ---------------------------------------------------------------------------------------
  procedure create_pps_auftrag_ag(in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                  in_artikel_id              in isi_artikel.artikel_id%type,
                                  in_zeichnung               in isi_artikel.zeichnung%type,
                                  in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                  in_charge_bez              in lvs_charge.charge_bez%type,
                                  in_login_id                in isi_user.login_id%type,
                                  in_menge                   in lvs_lam.menge%type,
                                  in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                  in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                  in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                  in_lte_name                in bde_fa_auftrag.lte_name%type,
                                  in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                  in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                  in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                  in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                  in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                  in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                  in_abnr                    in bde_fa_auftrag.abnr%type,
                                  in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                  in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                  in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                  in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                  in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                  in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                  in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                  in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                  in_bde_fa_plan             in t_bde_fa_plan);

  ---------------------------------------------------------------------------------------
  -- procedure create_pps_auftrag_stl
  -- Erzeugt eine Eintrag in der PPS_PLAN_AUFTRAG_STL
  ---------------------------------------------------------------------------------------
  procedure create_pps_auftrag_stl(in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                   in_artikel_id              in isi_artikel.artikel_id%type,
                                   in_zeichnung               in isi_artikel.zeichnung%type,
                                   in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                   in_charge_bez              in lvs_charge.charge_bez%type,
                                   in_login_id                in isi_user.login_id%type,
                                   in_menge                   in lvs_lam.menge%type,
                                   in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                   in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                   in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                   in_lte_name                in bde_fa_auftrag.lte_name%type,
                                   in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                   in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                   in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                   in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                   in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                   in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                   in_abnr                    in bde_fa_auftrag.abnr%type,
                                   in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                   in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                   in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                   in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                   in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                   in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                   in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                   in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                   in_bde_fa_plan             in t_bde_fa_plan);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(2550);
  -------------------------------------------------------------------------------------------------------

  procedure raise_isi_error(in_err_nr in number, in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  function get_version return varchar2 is
  begin
    return(v_version_str);
  end;

  ---------------------------------------------------------------------------------------
  -- procedure c_create_bde_fa_auftrag_a_plan
  -- Erzeugt Eintraege in der BDE_FA_AUFTRAG auf der Grundlage der PPS_ARB_PLAN Daten.
  -- Mit dem CURSOR c_bde_fa_plan werden die Daten so zusammengestellt, dass die max.
  -- Auspraegung der Kombinationen aus 'V'errichetn und 'MA'terialanforderung entsteht.
  -- Der Letzte Satz, der in der Stückliste den gleichen Arbeitsgang beschreibt, wird zur
  -- Erzeugung des 'V'erichten Satz benutzt. Hierfür wird der aktuelle Satz immer in die
  -- Recordstruktur v_bde_fa_plan_crt kopiert, die dann für die Erzeugung genutzt wird.
  --
  -- ACHTUNG: Wenn eine Leitzahl übergeben wird, dann wird dieser Auftrag in der
  --          BDE_FA_AUFTRAG Tabelle gelöscht
  ---------------------------------------------------------------------------------------
  procedure c_create_bde_fa_auftrag_a_plan(in_sid              in isi_sid.sid%type,
                                           in_firma_nr         in isi_firma.firma_nr%type,
                                           in_artikel_id       in isi_artikel.artikel_id%type,
                                           in_charge_bez       in lvs_charge.charge_bez%type,
                                           in_res_id           in isi_resource.res_id%type,
                                           in_login_id         in isi_user.login_id%type,
                                           in_menge            in lvs_lam.menge%type,
                                           in_ab_text1         in bde_fa_auftrag.ab_text1%type,
                                           in_ab_text2         in bde_fa_auftrag.ab_text2%type,
                                           in_ab_text3         in bde_fa_auftrag.ab_text3%type,
                                           in_soll_betriebsart in bde_fa_kopf.soll_betriebsart%type,
                                           in_kunden_nr        in bde_fa_auftrag.kunden_nr%type,
                                           in_kd_art_nr        in bde_fa_auftrag.kd_art_nr%type,
                                           in_ag_name1         in bde_fa_auftrag.ag_bez1%type,
                                           in_ag_name2         in bde_fa_auftrag.ag_bez2%type,
                                           in_ag_text1         in bde_fa_auftrag.ag_text1%type,
                                           in_ag_text2         in bde_fa_auftrag.ag_text2%type,
                                           in_ag_text3         in bde_fa_auftrag.ag_text3%type,
                                           in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck%type,
                                           in_anz_lte          in bde_fa_auftrag.lte_anz%type,
                                           in_anz_lhm          in bde_fa_auftrag.lhm_anz%type,
                                           in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde%type,
                                           in_abnr             in bde_fa_auftrag.abnr%type,
                                           in_serie_id         in bde_fa_kopf.serie_id%type,
                                           in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc%type,
                                           in_fa_gruppe        in bde_fa_kopf.fa_gruppe%type,
                                           in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type) is
    pragma autonomous_transaction;

  begin
    create_bde_fa_auftrag_a_plan(in_sid, -- in isi_sid.sid%type,
                                 in_firma_nr, -- in isi_firma.firma_nr%type,
                                 in_artikel_id, -- in isi_artikel.artikel_id%type,
                                 in_charge_bez, -- in lvs_charge.charge_bez%type,
                                 in_res_id, -- in isi_resource.res_id%type,
                                 in_login_id, -- in isi_user.login_id%type,
                                 in_menge, -- in lvs_lam.menge%type,
                                 in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                                 in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                                 in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                                 in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                                 in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                                 in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                                 in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                                 in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                                 in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                                 in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                                 in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                                 in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                 in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                                 in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                                 in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                                 in_abnr, -- in bde_fa_auftrag.abnr%type,
                                 in_serie_id, -- in bde_fa_kopf.serie_id%type,
                                 in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                                 in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                                 in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type)
    commit;
  end;

  procedure create_bde_fa_auf_a_plan_dispo(in_sid               in isi_sid.sid%type,
                                           in_firma_nr          in isi_firma.firma_nr%type,
                                           in_artikel_id        in isi_artikel.artikel_id%type,
                                           in_charge_bez        in lvs_charge.charge_bez%type,
                                           in_res_id            in isi_resource.res_id%type,
                                           in_login_id          in isi_user.login_id%type,
                                           in_menge             in lvs_lam.menge%type,
                                           in_ab_text1          in bde_fa_auftrag.ab_text1%type,
                                           in_ab_text2          in bde_fa_auftrag.ab_text2%type,
                                           in_ab_text3          in bde_fa_auftrag.ab_text3%type,
                                           in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
                                           in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
                                           in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
                                           in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
                                           in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
                                           in_ag_text1          in bde_fa_auftrag.ag_text1%type,
                                           in_ag_text2          in bde_fa_auftrag.ag_text2%type,
                                           in_ag_text3          in bde_fa_auftrag.ag_text3%type,
                                           in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
                                           in_anz_lte           in bde_fa_auftrag.lte_anz%type,
                                           in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
                                           in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
                                           in_abnr              in bde_fa_auftrag.abnr%type,
                                           in_serie_id          in bde_fa_kopf.serie_id%type,
                                           in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
                                           in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
                                           in_dispo_charge_rein in varchar2, -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                           in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type) is
  begin
    create_bde_fa_auf_a_plan_dis_h(in_sid, -- in isi_sid.sid%type,
                                   in_firma_nr, -- in isi_firma.firma_nr%type,
                                   in_artikel_id, -- in isi_artikel.artikel_id%type,
                                   in_charge_bez, -- in lvs_charge.charge_bez%type,
                                   in_res_id, -- in isi_resource.res_id%type,
                                   in_login_id, -- in isi_user.login_id%type,
                                   in_menge, -- in lvs_lam.menge%type,
                                   in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                                   in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                                   in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                                   in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                                   in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                                   in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                                   in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                                   in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                                   in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                                   in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                                   in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                                   in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                   in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                                   in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                                   in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                                   in_abnr, -- in bde_fa_auftrag.abnr%type,
                                   in_serie_id, -- in bde_fa_kopf.serie_id%type,
                                   in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                                   in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                                   in_dispo_charge_rein, -- in varchar2,      -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                   NULL, -- in pps_simple_fa.hersteller_kuerzel_liste%type,
                                   in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type)
  end;

  procedure create_bde_fa_auf_a_plan_dis_h(in_sid               in isi_sid.sid%type,
                                           in_firma_nr          in isi_firma.firma_nr%type,
                                           in_artikel_id        in isi_artikel.artikel_id%type,
                                           in_charge_bez        in lvs_charge.charge_bez%type,
                                           in_res_id            in isi_resource.res_id%type,
                                           in_login_id          in isi_user.login_id%type,
                                           in_menge             in lvs_lam.menge%type,
                                           in_ab_text1          in bde_fa_auftrag.ab_text1%type,
                                           in_ab_text2          in bde_fa_auftrag.ab_text2%type,
                                           in_ab_text3          in bde_fa_auftrag.ab_text3%type,
                                           in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
                                           in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
                                           in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
                                           in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
                                           in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
                                           in_ag_text1          in bde_fa_auftrag.ag_text1%type,
                                           in_ag_text2          in bde_fa_auftrag.ag_text2%type,
                                           in_ag_text3          in bde_fa_auftrag.ag_text3%type,
                                           in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
                                           in_anz_lte           in bde_fa_auftrag.lte_anz%type,
                                           in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
                                           in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
                                           in_abnr              in bde_fa_auftrag.abnr%type,
                                           in_serie_id          in bde_fa_kopf.serie_id%type,
                                           in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
                                           in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
                                           in_dispo_charge_rein in varchar2, -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                           in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                           in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type) is
  begin
    crt_bde_fa_auf_a_plan_h_35_11(in_sid, -- in isi_sid.sid%type,
                                  in_firma_nr, -- in isi_firma.firma_nr%type,
                                  in_artikel_id, -- in isi_artikel.artikel_id%type,
                                  in_charge_bez, -- in lvs_charge.charge_bez%type,
                                  in_res_id, -- in isi_resource.res_id%type,
                                  in_login_id, -- in isi_user.login_id%type,
                                  in_menge, -- in lvs_lam.menge%type,
                                  in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                                  in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                                  in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                                  in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                                  in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                                  in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                                  in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                                  in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                                  in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                                  in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                                  in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                                  in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                  in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                                  in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                                  in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                                  in_abnr, -- in bde_fa_auftrag.abnr%type,
                                  in_serie_id, -- in bde_fa_kopf.serie_id%type,
                                  in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                                  in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                                  in_dispo_charge_rein, -- in_dispo_charge_rein in varchar2,
                                  in_hersteller_liste, -- in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                  NULL, -- in_lam_sel1          in lvs_lam.LAM_SEL1%type,
                                  NULL, -- in_lam_sel2          in lvs_lam.LAM_SEL2%type,
                                  NULL, -- in_lam_sel3          in lvs_lam.LAM_SEL3%type,
                                  NULL, -- in_lam_sel4          in lvs_lam.LAM_SEL4%type,
                                  NULL, -- in_lam_sel5          in lvs_lam.LAM_SEL5%type,
                                  NULL, -- in_lam_sel6          in lvs_lam.LAM_SEL6%type,
                                  NULL, -- in_lam_sel7          in lvs_lam.LAM_SEL7%type,
                                  NULL, -- in_lam_sel8          in lvs_lam.LAM_SEL8%type,
                                  NULL, -- in_lam_sel9          in lvs_lam.LAM_SEL9%type,
                                  NULL, -- in_lam_sel10         in lvs_lam.LAM_SEL10%type,
                                  NULL, -- in_adress_id         in bde_fa_auftrag.adress_id%type,
                                  'F', -- in_lohn_arbeit
                                  in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type)

  end;
  --
  procedure crt_bde_fa_auf_a_plan_h_35_11(in_sid               in isi_sid.sid%type,
                                          in_firma_nr          in isi_firma.firma_nr%type,
                                          in_artikel_id        in isi_artikel.artikel_id%type,
                                          in_charge_bez        in lvs_charge.charge_bez%type,
                                          in_res_id            in isi_resource.res_id%type,
                                          in_login_id          in isi_user.login_id%type,
                                          in_menge             in lvs_lam.menge%type,
                                          in_ab_text1          in bde_fa_auftrag.ab_text1%type,
                                          in_ab_text2          in bde_fa_auftrag.ab_text2%type,
                                          in_ab_text3          in bde_fa_auftrag.ab_text3%type,
                                          in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
                                          in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
                                          in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
                                          in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
                                          in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
                                          in_ag_text1          in bde_fa_auftrag.ag_text1%type,
                                          in_ag_text2          in bde_fa_auftrag.ag_text2%type,
                                          in_ag_text3          in bde_fa_auftrag.ag_text3%type,
                                          in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
                                          in_anz_lte           in bde_fa_auftrag.lte_anz%type,
                                          in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
                                          in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
                                          in_abnr              in bde_fa_auftrag.abnr%type,
                                          in_serie_id          in bde_fa_kopf.serie_id%type,
                                          in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
                                          in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
                                          in_dispo_charge_rein in varchar2,
                                          in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                          in_lam_sel1          in lvs_lam.LAM_SEL1%type,
                                          in_lam_sel2          in lvs_lam.LAM_SEL2%type,
                                          in_lam_sel3          in lvs_lam.LAM_SEL3%type,
                                          in_lam_sel4          in lvs_lam.LAM_SEL4%type,
                                          in_lam_sel5          in lvs_lam.LAM_SEL5%type,
                                          in_lam_sel6          in lvs_lam.LAM_SEL6%type,
                                          in_lam_sel7          in lvs_lam.LAM_SEL7%type,
                                          in_lam_sel8          in lvs_lam.LAM_SEL8%type,
                                          in_lam_sel9          in lvs_lam.LAM_SEL9%type,
                                          in_lam_sel10         in lvs_lam.LAM_SEL10%type,
                                          in_adress_id         in bde_fa_auftrag.adress_id%type,
                                          in_lohn_arbeit       in bde_fa_auftrag.lohn_arbeit%type,
                                          in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type) is

  begin
    crt_bde_fa_auft_a_plan_35_11(in_sid, -- in isi_sid.sid%type,
                                 in_firma_nr, -- in isi_firma.firma_nr%type,
                                 in_artikel_id, -- in isi_artikel.artikel_id%type,
                                 in_charge_bez, -- in lvs_charge.charge_bez%type,
                                 in_res_id, -- in isi_resource.res_id%type,
                                 in_login_id, -- in isi_user.login_id%type,
                                 in_menge, -- in lvs_lam.menge%type,
                                 in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                                 in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                                 in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                                 in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                                 in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                                 in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                                 in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                                 in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                                 in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                                 in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                                 in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                                 in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                 in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                                 in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                                 in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                                 in_abnr, -- in bde_fa_auftrag.abnr%type,
                                 in_serie_id, -- in bde_fa_kopf.serie_id%type,
                                 in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                                 in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                                 in_dispo_charge_rein,
                                 in_hersteller_liste, --in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                 in_lam_sel1, -- in lvs_lam.LAM_SEL1%type,
                                 in_lam_sel2, -- in lvs_lam.LAM_SEL2%type,
                                 in_lam_sel3, -- in lvs_lam.LAM_SEL3%type,
                                 in_lam_sel4, -- in lvs_lam.LAM_SEL4%type,
                                 in_lam_sel5, -- in lvs_lam.LAM_SEL5%type,
                                 in_lam_sel6, -- in lvs_lam.LAM_SEL6%type,
                                 in_lam_sel7, -- in lvs_lam.LAM_SEL7%type,
                                 in_lam_sel8, -- in lvs_lam.LAM_SEL8%type,
                                 in_lam_sel9, -- in lvs_lam.LAM_SEL9%type,
                                 in_lam_sel10, -- in lvs_lam.LAM_SEL10%type,
                                 in_adress_id, -- in_adress_id        in bde_fa_auftrag.adress_id%type,
                                 in_lohn_arbeit, -- in_lohn_arbeit      in bde_fa_auftrag.lohn_arbeit%type,
                                 in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type)
    create_bde_fa_dispo(in_sid, -- in isi_sid.sid%type,
                        in_firma_nr, -- in isi_firma.firma_nr%type,
                        in_dispo_charge_rein, -- in varchar2,
                        in_hersteller_liste, -- in pps_simple_fa.hersteller_kuerzel_liste%type,
                        in_out_leitzahl, -- in bde_fa_auftrag.leitzahl%type,
                        NULL, -- in bde_fa_auftrag.fa_ag%type,
                        NULL, -- in bde_fa_auftrag.fa_upos%type,
                        c.C_TRUE, -- Mengen muessen komplett vorhanden sein
                        in_login_id, -- in isi_user.login_id%type);
                        c.C_FALSE); -- In_ice

  end;

  procedure create_bde_fa_auftrag_a_plan(in_sid              in isi_sid.sid%type,
                                         in_firma_nr         in isi_firma.firma_nr%type,
                                         in_artikel_id       in isi_artikel.artikel_id%type,
                                         in_charge_bez       in lvs_charge.charge_bez%type,
                                         in_res_id           in isi_resource.res_id%type,
                                         in_login_id         in isi_user.login_id%type,
                                         in_menge            in lvs_lam.menge%type,
                                         in_ab_text1         in bde_fa_auftrag.ab_text1%type,
                                         in_ab_text2         in bde_fa_auftrag.ab_text2%type,
                                         in_ab_text3         in bde_fa_auftrag.ab_text3%type,
                                         in_soll_betriebsart in bde_fa_kopf.soll_betriebsart%type,
                                         in_kunden_nr        in bde_fa_auftrag.kunden_nr%type,
                                         in_kd_art_nr        in bde_fa_auftrag.kd_art_nr%type,
                                         in_ag_name1         in bde_fa_auftrag.ag_bez1%type,
                                         in_ag_name2         in bde_fa_auftrag.ag_bez2%type,
                                         in_ag_text1         in bde_fa_auftrag.ag_text1%type,
                                         in_ag_text2         in bde_fa_auftrag.ag_text2%type,
                                         in_ag_text3         in bde_fa_auftrag.ag_text3%type,
                                         in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck%type,
                                         in_anz_lte          in bde_fa_auftrag.lte_anz%type,
                                         in_anz_lhm          in bde_fa_auftrag.lhm_anz%type,
                                         in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde%type,
                                         in_abnr             in bde_fa_auftrag.abnr%type,
                                         in_serie_id         in bde_fa_kopf.serie_id%type,
                                         in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc%type,
                                         in_fa_gruppe        in bde_fa_kopf.fa_gruppe%type,
                                         in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type) is
  begin
    crt_bde_fa_auft_a_plan_35_11(in_sid, -- in isi_sid.sid%type,
                                 in_firma_nr, -- in isi_firma.firma_nr%type,
                                 in_artikel_id, -- in isi_artikel.artikel_id%type,
                                 in_charge_bez, -- in lvs_charge.charge_bez%type,
                                 in_res_id, -- in isi_resource.res_id%type,
                                 in_login_id, -- in isi_user.login_id%type,
                                 in_menge, -- in lvs_lam.menge%type,
                                 in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                                 in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                                 in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                                 in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                                 in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                                 in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                                 in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                                 in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                                 in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                                 in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                                 in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                                 in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                 in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                                 in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                                 in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                                 in_abnr, -- in bde_fa_auftrag.abnr%type,
                                 in_serie_id, -- in bde_fa_kopf.serie_id%type,
                                 in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                                 in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                                 NULL, --in_dispo_charge_rein in varchar2
                                 NULL, --in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                 NULL, -- in_lam_sel1          in lvs_lam.LAM_SEL1%type,
                                 NULL, -- in_lam_sel2          in lvs_lam.LAM_SEL2%type,
                                 NULL, -- in_lam_sel3          in lvs_lam.LAM_SEL3%type,
                                 NULL, -- in_lam_sel4          in lvs_lam.LAM_SEL4%type,
                                 NULL, -- in_lam_sel5          in lvs_lam.LAM_SEL5%type,
                                 NULL, -- in_lam_sel6          in lvs_lam.LAM_SEL6%type,
                                 NULL, -- in_lam_sel7          in lvs_lam.LAM_SEL7%type,
                                 NULL, -- in_lam_sel8          in lvs_lam.LAM_SEL8%type,
                                 NULL, -- in_lam_sel9          in lvs_lam.LAM_SEL9%type,
                                 NULL, -- in_lam_sel10         in lvs_lam.LAM_SEL10%type,
                                 NULL, -- in_adress_id        in bde_fa_auftrag.adress_id%type,
                                 'F', -- in_lohn_arbeit
                                 in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type)

  end;

  procedure crt_bde_fa_auft_a_plan_35_11(in_sid               in isi_sid.sid%type,
                                         in_firma_nr          in isi_firma.firma_nr%type,
                                         in_artikel_id        in isi_artikel.artikel_id%type,
                                         in_charge_bez        in lvs_charge.charge_bez%type,
                                         in_res_id            in isi_resource.res_id%type,
                                         in_login_id          in isi_user.login_id%type,
                                         in_menge             in lvs_lam.menge%type,
                                         in_ab_text1          in bde_fa_auftrag.ab_text1%type,
                                         in_ab_text2          in bde_fa_auftrag.ab_text2%type,
                                         in_ab_text3          in bde_fa_auftrag.ab_text3%type,
                                         in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
                                         in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
                                         in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
                                         in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
                                         in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
                                         in_ag_text1          in bde_fa_auftrag.ag_text1%type,
                                         in_ag_text2          in bde_fa_auftrag.ag_text2%type,
                                         in_ag_text3          in bde_fa_auftrag.ag_text3%type,
                                         in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
                                         in_anz_lte           in bde_fa_auftrag.lte_anz%type,
                                         in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
                                         in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
                                         in_abnr              in bde_fa_auftrag.abnr%type,
                                         in_serie_id          in bde_fa_kopf.serie_id%type,
                                         in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
                                         in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
                                         in_dispo_charge_rein in varchar2,
                                         in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                         in_lam_sel1          in lvs_lam.LAM_SEL1%type,
                                         in_lam_sel2          in lvs_lam.LAM_SEL2%type,
                                         in_lam_sel3          in lvs_lam.LAM_SEL3%type,
                                         in_lam_sel4          in lvs_lam.LAM_SEL4%type,
                                         in_lam_sel5          in lvs_lam.LAM_SEL5%type,
                                         in_lam_sel6          in lvs_lam.LAM_SEL6%type,
                                         in_lam_sel7          in lvs_lam.LAM_SEL7%type,
                                         in_lam_sel8          in lvs_lam.LAM_SEL8%type,
                                         in_lam_sel9          in lvs_lam.LAM_SEL9%type,
                                         in_lam_sel10         in lvs_lam.LAM_SEL10%type,
                                         in_adress_id         in bde_fa_auftrag.adress_id%type,
                                         in_lohn_arbeit       in bde_fa_auftrag.lohn_arbeit%type,
                                         in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type) is
  begin
    pps_p_bde.crt_bde_fa_auft_a_plan_DB31 (in_sid,              -- isi_sid.sid%type,
                                           in_firma_nr,         -- isi_firma.firma_nr%type,
                                           in_artikel_id,       -- isi_artikel.artikel_id%type,
                                           in_charge_bez,       -- lvs_charge.charge_bez%type,
                                           in_res_id,           -- isi_resource.res_id%type,
                                           in_login_id,         -- isi_user.login_id%type,
                                           in_menge,            -- lvs_lam.menge%type,
                                           in_ab_text1,         -- bde_fa_auftrag.ab_text1%type,
                                           in_ab_text2,         -- bde_fa_auftrag.ab_text2%type,
                                           in_ab_text3,         -- bde_fa_auftrag.ab_text3%type,
                                           in_soll_betriebsart, -- bde_fa_kopf.soll_betriebsart%type,
                                           in_kunden_nr,        -- bde_fa_auftrag.kunden_nr%type,
                                           in_kd_art_nr,        -- bde_fa_auftrag.kd_art_nr%type,
                                           in_ag_name1,         -- bde_fa_auftrag.ag_bez1%type,
                                           in_ag_name2,         -- bde_fa_auftrag.ag_bez2%type,
                                           in_ag_text1,         -- bde_fa_auftrag.ag_text1%type,
                                           in_ag_text2,         -- bde_fa_auftrag.ag_text2%type,
                                           in_ag_text3,         -- bde_fa_auftrag.ag_text3%type,
                                           in_kenz_lhm_druck,   -- bde_fa_auftrag.kenz_lhm_druck%type,
                                           in_anz_lte,          -- bde_fa_auftrag.lte_anz%type,
                                           in_anz_lhm,          -- bde_fa_auftrag.lhm_anz%type,
                                           in_bestnr_kd,        -- bde_fa_auftrag.best_nr_kunde%type,
                                           in_abnr,             -- bde_fa_auftrag.abnr%type,
                                           in_serie_id,         -- bde_fa_kopf.serie_id%type,
                                           in_serie_auto_inc,   -- bde_fa_kopf.serie_auto_inc%type,
                                           in_fa_gruppe,        -- bde_fa_kopf.fa_gruppe%type,
                                           in_dispo_charge_rein,-- in_dispo_charge_rein in varchar2,
                                           in_hersteller_liste, -- in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                           in_lam_sel1,         -- lvs_lam.LAM_SEL1%type,
                                           in_lam_sel2,         -- lvs_lam.LAM_SEL2%type,
                                           in_lam_sel3,         -- lvs_lam.LAM_SEL3%type,
                                           in_lam_sel4,         -- lvs_lam.LAM_SEL4%type,
                                           in_lam_sel5,         -- lvs_lam.LAM_SEL5%type,
                                           in_lam_sel6,         -- lvs_lam.LAM_SEL6%type,
                                           in_lam_sel7,         -- lvs_lam.LAM_SEL7%type,
                                           in_lam_sel8,         -- lvs_lam.LAM_SEL8%type,
                                           in_lam_sel9,         -- lvs_lam.LAM_SEL9%type,
                                           in_lam_sel10,        -- lvs_lam.LAM_SEL10%type,
                                           in_adress_id,        -- bde_fa_auftrag.adress_id%type,
                                           in_lohn_arbeit,      -- bde_fa_auftrag.lohn_arbeit%type,
                                           NULL,                -- bde_fa_auftrag.seq_nr%type,
                                           NULL,                -- bde_fa_auftrag.lead_leitzahl%type,
                                           NULL,                -- bde_fa_auftrag.primaer_leitzahl%type,
                                           in_out_leitzahl);    -- out bde_fa_auftrag.leitzahl%type
  end;

  procedure crt_bde_fa_auft_a_plan_DB31 (in_sid               in isi_sid.sid%type,
                                         in_firma_nr          in isi_firma.firma_nr%type,
                                         in_artikel_id        in isi_artikel.artikel_id%type,
                                         in_charge_bez        in lvs_charge.charge_bez%type,
                                         in_res_id            in isi_resource.res_id%type,
                                         in_login_id          in isi_user.login_id%type,
                                         in_menge             in lvs_lam.menge%type,
                                         in_ab_text1          in bde_fa_auftrag.ab_text1%type,
                                         in_ab_text2          in bde_fa_auftrag.ab_text2%type,
                                         in_ab_text3          in bde_fa_auftrag.ab_text3%type,
                                         in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
                                         in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
                                         in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
                                         in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
                                         in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
                                         in_ag_text1          in bde_fa_auftrag.ag_text1%type,
                                         in_ag_text2          in bde_fa_auftrag.ag_text2%type,
                                         in_ag_text3          in bde_fa_auftrag.ag_text3%type,
                                         in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
                                         in_anz_lte           in bde_fa_auftrag.lte_anz%type,
                                         in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
                                         in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
                                         in_abnr              in bde_fa_auftrag.abnr%type,
                                         in_serie_id          in bde_fa_kopf.serie_id%type,
                                         in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
                                         in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
                                         in_dispo_charge_rein in varchar2,
                                         in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                         in_lam_sel1          in lvs_lam.LAM_SEL1%type,
                                         in_lam_sel2          in lvs_lam.LAM_SEL2%type,
                                         in_lam_sel3          in lvs_lam.LAM_SEL3%type,
                                         in_lam_sel4          in lvs_lam.LAM_SEL4%type,
                                         in_lam_sel5          in lvs_lam.LAM_SEL5%type,
                                         in_lam_sel6          in lvs_lam.LAM_SEL6%type,
                                         in_lam_sel7          in lvs_lam.LAM_SEL7%type,
                                         in_lam_sel8          in lvs_lam.LAM_SEL8%type,
                                         in_lam_sel9          in lvs_lam.LAM_SEL9%type,
                                         in_lam_sel10         in lvs_lam.LAM_SEL10%type,
                                         in_adress_id         in bde_fa_auftrag.adress_id%type,
                                         in_lohn_arbeit       in bde_fa_auftrag.lohn_arbeit%type,
                                         in_seq_nr            in bde_fa_auftrag.seq_nr%type,
                                         in_lead_leitzahl     in bde_fa_auftrag.lead_leitzahl%type,
                                         in_primaer_leitzahl  in bde_fa_auftrag.primaer_leitzahl%type,
                                         in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type
                                         ) is
    v_found boolean;

    v_bde_fa_plan          t_bde_fa_plan;
    v_bde_fa_plan_crt      t_bde_fa_plan;
    v_artikel              isi_artikel%rowtype;
    v_artikel_kd           isi_artikel_kunde%rowtype;
    v_artikel_arb_plan     pps_artikel_arb_plan%rowtype;
    v_artikel_grp_arb_plan pps_artikel_grp_arb_plan%rowtype;
    v_hersteller_liste     bde_fa_auftrag.ma_hersteller_kuerzel_liste%type;

    v_arb_plan_id        pps_arb_plan.arb_plan_id%type;
    v_ag_schrittweite    number;
    v_fa_ag              number;
    v_menge              number;
    v_fa_ag_stl          number;
    v_ag_menge           number;
    v_stueckliste_pos_id number;

    v_anz_bde_beg        number;
    v_mit_quitt_gruppe   boolean;
    v_quitt_gruppe       bde_fa_auftrag.quitt_gruppe_ag%type;
    v_fa_ag_quitt_gruppe bde_fa_auftrag.fa_ag%type;

    CURSOR c_artikel is
      select *
        from isi_artikel t
       where t.sid = in_sid
         and t.artikel_id = in_artikel_id;

    CURSOR c_artikel_kd is
      select *
        from isi_artikel_kunde t
       where t.sid = in_sid
         and t.artikel_id = in_artikel_id
         and t.kunden_nr = in_kunden_nr
         and ((   t.kd_art_nr = nvl(in_kd_art_nr, t.kd_art_nr)
              )
             or(   t.kd_art_nr is NULL
               and in_kd_art_nr is NULL
               )
              );

    CURSOR c_artikel_arb_plan is
      select *
        from pps_artikel_arb_plan t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.artikel_id = in_artikel_id;

    CURSOR c_artikel_grp_arb_plan is
      select *
        from pps_artikel_grp_arb_plan t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.art_gruppe_id = v_artikel.art_gruppe_id;

    -- AG 2021.01.12 - Bug in der Brechnung / Ermittlung der Produktionszeit, wenn der AG für
    -- mehr als ene RESOURCE gilt die unterschiedliche Taktzeiten haben
    CURSOR c_bde_fa_plan is
      select p.sid,
             p.firma_nr,
             p.arb_plan_id,
             p.arb_plan_name,
             nvl(in_ab_text1, p.text1),
             nvl(in_ab_text3, p.text2),
             nvl(in_ab_text2, p.text3),
             nvl(in_soll_betriebsart, p.soll_betriebsart),
             in_fa_gruppe,
             pag.arb_plan_pos_id,
             pag.pos_nr,
             pag.ag_upos,
             pag.satzart,
             nvl(in_ag_name1, pag.ag_name1),
             nvl(in_ag_name2, pag.ag_name2),
             nvl(in_ag_text1, pag.ag_text1),
             nvl(in_ag_text2, pag.ag_text2),
             nvl(in_ag_text3, pag.ag_text3),
             pag.plan_menge_faktor,
             pag.plan_menge_faktor_op,
             nvl(in_res_id, pag.res_id),
             pag.nio_res_id,
             nvl(pag.prod_params,
                 nvl(v_artikel_arb_plan.prod_params,
                     v_artikel_grp_arb_plan.prod_params)),
             pag.quitt_gruppe_ag,
             pag.soll_zeit_ruest,
             nvl((select pagrl.maschinenzeitfaktor
                  from pps_arb_plan_ag_res_id_liste pagrl
                 where pag.arb_plan_id = pagrl.arb_plan_id
                   and pag.arb_plan_pos_id = pagrl.arb_plan_pos_id
                   and (  pagrl.res_id = nvl(in_res_id, pag.res_id)
                       or pagrl.res_id = (select xrg.res_id
                                            from isi_resource xrg,
                                                 isi_resource xr
                                           where xrg.typ = 'MPG'
                                             and xrg.gruppe = xr.gruppe
                                             and xr.typ = 'MS'
                                             and xr.res_id = nvl(in_res_id, pag.res_id))
                       )), pag.soll_zeit_p_einh) soll_zeit_p_einh,
             pag.soll_zeit_stoer_p_std,
             NULL,
             NULL,
             pags.prod_reihenfolge,
             pags.prod_menge_p_einheit,
             pags.prod_menge_p_einheit_op,
             pags.prod_menge_ix,
             s.stueckliste_id,
             s.stueckliste_name,
             s.text1,
             s.text2,
             s.text3,
             sp.stueckliste_pos_id,
             sp.pos_nr,
             sp.artikel_id,
             sp.zeichnung,
             sp.zeichnung_index,
             sp.prod_params,
             sp.plan_menge_p_einheit,
             sp.plan_menge_p_einheit_op,
             pag.vorgangsqualifikation,
             pag.ag_alternative
        from pps_arb_plan        p,
             pps_arb_plan_ag     pag,
             pps_arb_plan_ag_stl pags,
             pps_stueckliste     s,
             pps_stueckliste_pos sp
       where p.arb_plan_id = v_arb_plan_id
         and p.sid = pag.sid
         and p.firma_nr = pag.firma_nr
         and p.arb_plan_id = pag.arb_plan_id
         and pag.sid = pags.sid(+)
         and pag.firma_nr = pags.firma_nr(+)
         and pag.arb_plan_pos_id = pags.arb_plan_pos_id(+)
         and pags.sid = sp.sid(+)
         and pags.firma_nr = sp.firma_nr(+)
         and pags.stueckliste_pos_id = sp.stueckliste_pos_id(+)
         and sp.sid = s.sid(+)
         and sp.firma_nr = s.firma_nr(+)
         and sp.stueckliste_id = s.stueckliste_id(+)
         and s.aktiv(+) = c.c_true
       order by pag.arb_plan_pos_id,
                pags.prod_reihenfolge;

    CURSOR c_stl_pos_fuer_ma_in_ag is
      select t.stueckliste_pos_id
        from pps_arb_plan_ag_stl t, pps_arb_plan_ag t2
       where v_bde_fa_plan.sid = t2.sid
         and v_bde_fa_plan.firma_nr = t2.firma_nr
         and v_bde_fa_plan.arb_plan_id = t2.arb_plan_id
         and v_bde_fa_plan.arb_plan_pos_id = t.arb_plan_pos_id
         and v_bde_fa_plan.stueckliste_pos_id = t.stueckliste_pos_id
         and t2.sid = t.sid
         and t2.arb_plan_pos_id = t.arb_plan_pos_id
         and t.stueckliste_pos_id not in
             (select t.stueckliste_pos_id
                from pps_arb_plan_ag_stl t, pps_arb_plan_ag t2
               where v_bde_fa_plan.sid = t2.sid
                 and v_bde_fa_plan.firma_nr = t2.firma_nr
                 and v_bde_fa_plan.arb_plan_id = t2.arb_plan_id
                 and v_bde_fa_plan.arb_plan_pos_id > t.arb_plan_pos_id
                 and t2.sid = t.sid
                 and t2.arb_plan_pos_id = t.arb_plan_pos_id);

    CURSOR c_bde_begonnen is
      select count(t.freig_status)
        from bde_fa_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.leitzahl = in_out_leitzahl
         and t.freig_status != 'N';

    CURSOR c_bde_fa_quitt_grp is
      select max(t.fa_ag), t.quitt_gruppe_ag
        from bde_fa_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.leitzahl = in_out_leitzahl
         and t.quitt_gruppe_ag is not NULL
       group by t.quitt_gruppe_ag
       order by t.quitt_gruppe_ag desc;

  begin
    v_mit_quitt_gruppe := False;
    -- Lesen der Schrrittweite der Arbeitsgaenge
    v_ag_schrittweite := isi_allg.c_get_firma_cfg_param(in_sid,
                                                        in_firma_nr,
                                                        'BDE_FA', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                        NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                        'BDE_FA_AG_SCHRITTWEITE', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                        'BDE', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                                        '10', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'INTEGER'); -- in_default_param_typ

    -- Lesen des Maxwert der Arbeitsgaenge
    v_ag_max := isi_allg.c_get_firma_cfg_param(in_sid,
                                               in_firma_nr,
                                               'BDE_FA', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                               NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                               'BDE_FA_AG_MAX', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'BDE', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                               '1000', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'INTEGER'); -- in_default_param_typ

    -- Alte Variante
    -- Pruefen ob der Auftrag breits begonnen ist
    /*OPEN c_bde_begonnen;
    FETCH c_bde_begonnen
      into v_anz_bde_beg;
    CLOSE c_bde_begonnen;

    if v_anz_bde_beg > 0 then
      raise_isi_error(5,
                      lc.ec_p2(lc.O_TP2_ARB_PPS_AG_BDE_BEG,
                               in_out_leitzahl,
                               v_anz_bde_beg));
    end if;*/
    if not check_bde_fa_for_delete(in_sid, in_firma_nr, in_out_leitzahl, v_anz_bde_beg) then
      raise_isi_error(5,
                      lc.ec_p2(lc.O_TP2_ARB_PPS_AG_BDE_BEG,
                      in_out_leitzahl,
                      v_anz_bde_beg));
    end if;
    -- Loeschen derBDE-Daten fuer diesen FA_Auftrag
    delete bde_fa_kopf t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.fa_nr = in_out_leitzahl;
    -- Einbau der Tabelle wenn eine FA erstellt wurde
    delete bde_fa_auftrag_rel t
     where t.leitzahl = in_out_leitzahl;

    -- Lesen der Artikeldaten
    OPEN c_artikel;
    FETCH c_artikel
      into v_artikel;
    v_found := c_artikel%found;
    CLOSE c_artikel;

    if not v_found then
      raise_isi_error(10,
                      lc.ec_p1(lc.O_TP1_ARTIKEL_ID_FEHLT, in_artikel_id));
    end if;

    v_artikel_kd := NULL;
    OPEN c_artikel_kd;
    FETCH c_artikel_kd
      into v_artikel_kd;
    CLOSE c_artikel_kd;

    -- Übertragen der Artikeldaten für LHM-Name etc. aus Artikel oder KD-Artikel
    if v_artikel_kd.lhm_name is not NULL
    then
      if  nvl(v_artikel_kd.lhm_menge, 0) = 0
      and nvl(v_artikel_kd.lte_lhm_menge, 0) > 0
      then
        v_artikel_kd.lhm_menge := v_artikel_kd.lte_menge / v_artikel_kd.lte_lhm_menge;
      end if;
      if  nvl(v_artikel_kd.lhm_menge, 0) = 0
      and nvl(v_artikel_kd.lte_lhm_pro_lage, 0) > 0
      and nvl(v_artikel_kd.lte_lhm_lagen, 0) > 0
      then
        v_artikel_kd.lhm_menge := v_artikel_kd.lte_menge / (v_artikel_kd.lte_lhm_pro_lage + v_artikel_kd.lte_lhm_lagen);
      end if;
    end if;
    if v_artikel_kd.lhm_name is NULL
    or nvl(v_artikel_kd.lhm_menge, 0) = 0
    then
      if  nvl(v_artikel.lhm_menge, 0) = 0
      and nvl(v_artikel.lte_lhm_menge, 0) > 0
      then
        v_artikel.lhm_menge := v_artikel.lte_menge / v_artikel.lte_lhm_menge;
      end if;
      if  nvl(v_artikel.lhm_menge, 0) = 0
      and nvl(v_artikel.lte_lhm_pro_lage, 0) > 0
      and nvl(v_artikel.lte_lhm_lagen, 0) > 0
      then
        v_artikel.lhm_menge := v_artikel.lte_menge / (v_artikel.lte_lhm_pro_lage + v_artikel.lte_lhm_lagen);
      end if;
    end if;

    -- Initialisierung der Cursorergebnisse
    v_artikel_arb_plan     := NULL;
    v_artikel_grp_arb_plan := NULL;

    -- Lesen Arbeitsplan für den Artikel
    OPEN c_artikel_arb_plan;
    FETCH c_artikel_arb_plan
      into v_artikel_arb_plan;
    v_found := c_artikel_arb_plan%FOUND;
    CLOSE c_artikel_arb_plan;
    v_arb_plan_id := v_artikel_arb_plan.arb_plan_id;
    -- Kein Arbeitsplan für den Artikel gefunden, dann über die Artikelgruppe suchen
    if not v_found then
      OPEN c_artikel_grp_arb_plan;
      FETCH c_artikel_grp_arb_plan
        into v_artikel_grp_arb_plan;
      v_found := c_artikel_grp_arb_plan%FOUND;
      CLOSE c_artikel_grp_arb_plan;
      v_arb_plan_id := v_artikel_grp_arb_plan.arb_plan_id;
    end if;

    -- Kein Arbeitsplan für den Artikel oder Gruppe gefunden, dann Fehler
    if not v_found then
      raise_isi_error(20,
                      lc.ec_p1(lc.O_TP1_ARTIKEL_ARB_PLAN_FEHLT,
                               v_artikel.artikel));
    end if;

    -- Mit dem CURSOR c_bde_fa_plan werden die Daten so zusammengestellt, dass die max.
    -- Auspraegung der Kombinationen aus 'V'errichetn und 'MA'terialanforderung entsteht.
    -- Der Letzte Satz, der in der Stückliste den gleichen Arbeitsgang beschreibt, wird zur
    -- Erzeugung des 'V'erichten Satz benutzt. Hierfür wird der aktuelle Satz immer in die
    -- Recordstruktur v_bde_fa_plan_crt kopiert, die dann für die Erzeugung genutzt wird.
    OPEN c_bde_fa_plan;
    FETCH c_bde_fa_plan
      into v_bde_fa_plan;
    -- Wenn hier nichts gefunden wurde, dann Fehler
    if c_bde_fa_plan%NOTFOUND then
      CLOSE c_bde_fa_plan;
      raise_isi_error(20,
                      lc.ec_p1(lc.O_TP1_ARB_PLAN_POS_FEHLT,
                               v_artikel.artikel));
    end if;

    -- Initialisierung der STL-Ref Tabelle
    v_fa_ag      := 0;
    v_stl_tab_ix := 0;
    v_stl_tab    := v_stl_tab_empty;

    -- Ab jetzt alle Eintraege der c_bde_fa_plan abarbeiten
    LOOP
      exit when c_bde_fa_plan%NOTFOUND;

      case -- BasisMenge für Arbeitsgang
        when v_bde_fa_plan_crt.ag_plan_menge_faktor_op = 'MUL' then
          v_ag_menge := in_menge * v_bde_fa_plan_crt.ag_plan_menge_faktor;
        when v_bde_fa_plan_crt.ag_plan_menge_faktor_op = 'DIV' then
          v_ag_menge := in_menge / v_bde_fa_plan_crt.ag_plan_menge_faktor;
        when v_bde_fa_plan_crt.ag_plan_menge_faktor_op = 'ABS' then
          v_ag_menge := v_bde_fa_plan_crt.ag_plan_menge_faktor;
        else
          v_ag_menge := 0;
      end case;
      case -- BasisMenge für Arbeitsgang
        when v_bde_fa_plan.ag_plan_menge_faktor_op = 'MUL' then
          v_menge := in_menge * v_bde_fa_plan.ag_plan_menge_faktor;
        when v_bde_fa_plan.ag_plan_menge_faktor_op = 'DIV' then
          v_menge := in_menge / v_bde_fa_plan.ag_plan_menge_faktor;
        when v_bde_fa_plan.ag_plan_menge_faktor_op = 'ABS' then
          v_menge := v_bde_fa_plan.ag_plan_menge_faktor;
        else
          v_menge := 0;
      end case;

      -- Der der neue Eintrag ist für einen neuen 'V'errichten Eintrag,
      -- dann den letzten schreiben
      if v_bde_fa_plan_crt.arb_plan_pos_id != v_bde_fa_plan.arb_plan_pos_id then
        v_fa_ag := v_fa_ag + v_ag_schrittweite;

        v_mit_quitt_gruppe := v_mit_quitt_gruppe or
                              (v_bde_fa_plan_crt.quitt_gruppe_ag is not NULL);

        create_bde_fa_auftrag_DB31 (v_bde_fa_plan_crt.satzartz,
                                    -- in_ag_satzart      in bde_fa_auftrag.satzart%type,
                                    0, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                                    in_artikel_id, -- in_artikel_id      in isi_artikel.artikel_id%type,
                                    v_artikel.zeichnung, --  in_zeichnung       in isi_artikel.zeichnung%type,
                                    v_artikel.zeichnung_index,
                                    -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                                    in_charge_bez, -- in_charge_bez      in lvs_charge.charge_bez%type,
                                    in_login_id, -- in_login_id        in isi_user.login_id%type,
                                    v_menge, -- in_menge           in lvs_lam.menge%type,
                                    in_kunden_nr, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                                    v_artikel_kd.kd_art_nr,
                                    -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                                    in_kenz_lhm_druck, -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                                    nvl(v_artikel_kd.lte_name, v_artikel.lte_name),
                                    -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                                    nvl(v_artikel_kd.lte_menge,
                                        v_artikel.lte_menge),
                                    -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                                    in_anz_lte, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                                    nvl(v_artikel_kd.lhm_name, v_artikel.lhm_name),
                                    -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                                    nvl(v_artikel_kd.lhm_menge,
                                        v_artikel.lhm_menge),
                                    -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                                    in_anz_lhm, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                                    in_bestnr_kd, -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                                    in_abnr, -- in_abnr            in bde_fa_auftrag.abnr%type,
                                    in_out_leitzahl, -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                                    v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                                    v_artikel.abfuell_abschalt_grob,
                                    -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                    v_artikel.abfuell_abschalt_mittel,
                                    -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                    v_artikel.abfuell_abschalt_fein,
                                    -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                    v_artikel.abfuell_toleranz_plus,
                                    -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                    v_artikel.abfuell_toleranz_minus,
                                    -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                    v_artikel.abfuell_soll,
                                    v_bde_fa_plan_crt, -- in_bde_fa_plan     in t_bde_fa_plan)
                                    in_seq_nr,
                                    in_lead_leitzahl,
                                    in_primaer_leitzahl,
                                    NULL,   -- in_dispo_charge_rein       in varchar2,
                                    NULL    -- in_hersteller_liste        in pps_simple_fa.hersteller_kuerzel_liste%type
                                    );

        v_stl_tab_i := 0;
        -- Alle Referenzen in der v_stl_tab, die noch keine FA haben, müssen auf den letzen
        -- AG verweisen (Beim schreiben der Stückliste noch nicht bekannt)
        LOOP
          -- Leitzahl und Arbeitsgang eintragen (BDE_FA_AUFTRAG_STL Tabelle wird am ende geschrieben)
          v_stl_tab_i := v_stl_tab_i + 1;
          EXIT WHEN v_stl_tab_i > v_stl_tab_ix;
          if v_stl_tab(v_stl_tab_i).leitzahl is NULL then
            v_stl_tab(v_stl_tab_i).leitzahl := in_out_leitzahl;
            v_stl_tab(v_stl_tab_i).fa_ag := v_fa_ag;
            v_bde_fa_plan_crt.ag_upos := v_bde_fa_plan_crt.ag_upos;
          end if;
        end LOOP;
      end if;

      v_bde_fa_plan_crt := v_bde_fa_plan;
      if v_bde_fa_plan.stueckliste_id is not NULL then
        -- Suchen, ob diese STL-Referenz auch eine 'MA'terialanforderung ist
        v_stueckliste_pos_id := NULL;
        OPEN c_stl_pos_fuer_ma_in_ag;
        FETCH c_stl_pos_fuer_ma_in_ag
          into v_stueckliste_pos_id;
        CLOSE c_stl_pos_fuer_ma_in_ag;
        -- Diese STL-Referenz ist auch eine 'MA'terialanforderung (Kleinser AG für die Ref)
        if v_bde_fa_plan.stueckliste_pos_id = v_stueckliste_pos_id then
          if v_bde_fa_plan.prod_menge_ix = 1 then
            v_fa_ag := v_fa_ag + v_ag_schrittweite;
            create_bde_fa_auftrag_DB31 ('MA', -- in_ag_satzart      in bde_fa_auftrag.satzart%type,
                                        0, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                                        in_artikel_id, -- in_artikel_id      in isi_artikel.artikel_id%type,
                                        v_artikel.zeichnung, --  in_zeichnung       in isi_artikel.zeichnung%type,
                                        v_artikel.zeichnung_index,
                                        -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                                        in_charge_bez, -- in_charge_bez      in lvs_charge.charge_bez%type,
                                        in_login_id, -- in_login_id        in isi_user.login_id%type,
                                        v_menge, -- in_menge           in lvs_lam.menge%type,
                                        in_kunden_nr, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                                        v_artikel_kd.kd_art_nr,
                                        -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                                        in_kenz_lhm_druck, -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                                        nvl(v_artikel_kd.lte_name,
                                            v_artikel.lte_name),
                                        -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                                        nvl(v_artikel_kd.lte_menge,
                                            v_artikel.lte_menge),
                                        -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                                        in_anz_lte, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                                        nvl(v_artikel_kd.lhm_name,
                                            v_artikel.lhm_name),
                                        -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                                        nvl(v_artikel_kd.lhm_menge,
                                            v_artikel.lhm_menge),
                                        -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                                        in_anz_lhm, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                                        in_bestnr_kd, -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                                        in_abnr, -- in_abnr            in bde_fa_auftrag.abnr%type,
                                        in_out_leitzahl, -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                                        v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                                        v_artikel.abfuell_abschalt_grob,
                                        -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                        v_artikel.abfuell_abschalt_mittel,
                                        -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                        v_artikel.abfuell_abschalt_fein,
                                        -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                        v_artikel.abfuell_toleranz_plus,
                                        -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                        v_artikel.abfuell_toleranz_minus,
                                        -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                        v_artikel.abfuell_soll,
                                        -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                                        v_bde_fa_plan, -- in_bde_fa_plan     in t_bde_fa_plan)
                                        in_seq_nr,
                                        in_lead_leitzahl,
                                        in_primaer_leitzahl,
                                        in_dispo_charge_rein,   -- in_dispo_charge_rein       in varchar2,
                                        in_hersteller_liste);  -- in_hersteller_liste        in pps_simple_fa.hersteller_kuerzel_liste%type
          end if;
          v_fa_ag_stl := v_fa_ag;
        else

          v_stl_tab_i := 0;
          LOOP
            v_stl_tab_i := v_stl_tab_i + 1;
            EXIT WHEN v_stl_tab_i > v_stl_tab_ix or v_stl_tab(v_stl_tab_i).stueckliste_pos_id = v_bde_fa_plan.stueckliste_pos_id;
          end LOOP;
          if v_stl_tab(v_stl_tab_i)
           .stueckliste_pos_id = v_bde_fa_plan.stueckliste_pos_id then
            v_fa_ag_stl := v_stl_tab(v_stl_tab_i).ma_fa_ag;
          else
            v_fa_ag_stl := NULL;
          end if;
        end if;

        -- Naechsten Eintrag in der STL-Ref Tabelle
        v_stl_tab_ix := v_stl_tab_ix + 1;
        v_stl_tab(v_stl_tab_ix).sid := v_bde_fa_plan.sid;
        v_stl_tab(v_stl_tab_ix).firma_nr := v_bde_fa_plan.firma_nr;
        v_stl_tab(v_stl_tab_ix).ma_fa_ag := v_fa_ag_stl;
        v_stl_tab(v_stl_tab_ix).ma_fa_upos := v_bde_fa_plan.ag_upos;
        v_stl_tab(v_stl_tab_ix).stueckliste_pos_id := v_bde_fa_plan.stueckliste_pos_id;
        v_stl_tab(v_stl_tab_ix).stueckliste_pos_nr := v_bde_fa_plan.stueckliste_pos_nr;
        v_stl_tab(v_stl_tab_ix).prod_reihenfolge := v_bde_fa_plan.prod_reihenfolge;
        v_stl_tab(v_stl_tab_ix).prod_menge_p_einheit := v_bde_fa_plan.prod_menge_p_einheit;
        v_stl_tab(v_stl_tab_ix).prod_menge_p_einheit_op := v_bde_fa_plan.prod_menge_p_einheit_op;
        v_stl_tab(v_stl_tab_ix).prod_menge_ix := v_bde_fa_plan.prod_menge_ix;

      end if;
      FETCH c_bde_fa_plan
        into v_bde_fa_plan;
    end LOOP;
    CLOSE c_bde_fa_plan;

    -- Nach der Abarbeitung der Tabelle muessen noch die Relation AG - STL erstellt werden
    -- und der Letzte 'V'errichtensatz ist noch nicht geschrieben
    v_fa_ag     := v_fa_ag + v_ag_schrittweite;
    v_stl_tab_i := 0;
    LOOP
      -- Relation AG - STL werden erstellt
      v_stl_tab_i := v_stl_tab_i + 1;
      EXIT WHEN v_stl_tab_i > v_stl_tab_ix;
      if v_stl_tab(v_stl_tab_i).leitzahl is NULL -- Letzen AG noch nachtragen
       then
        v_stl_tab(v_stl_tab_i).leitzahl := in_out_leitzahl;
        v_stl_tab(v_stl_tab_i).fa_ag := v_fa_ag;
        v_bde_fa_plan_crt.ag_upos := v_bde_fa_plan_crt.ag_upos;
      end if;
      INSERT into bde_fa_auftrag_stl
      values
        (v_stl_tab                (v_stl_tab_i).sid,
         v_stl_tab                (v_stl_tab_i).firma_nr,
         NULL, -- FA_AG_STL_ID
         v_stl_tab                (v_stl_tab_i).leitzahl,
         v_stl_tab                (v_stl_tab_i).fa_ag,
         v_bde_fa_plan_crt.ag_upos,
         v_stl_tab                (v_stl_tab_i).ma_fa_ag,
         v_stl_tab                (v_stl_tab_i).ma_fa_upos,
         v_stl_tab                (v_stl_tab_i).stueckliste_pos_id,
         v_stl_tab                (v_stl_tab_i).stueckliste_pos_nr,
         v_stl_tab                (v_stl_tab_i).prod_reihenfolge,
         v_stl_tab                (v_stl_tab_i).prod_menge_p_einheit,
         v_stl_tab                (v_stl_tab_i).prod_menge_p_einheit_op,
         v_stl_tab                (v_stl_tab_i).prod_menge_ix,
         NULL);
    end LOOP;
    -- Loeschen der Ref-Tabelle
    v_stl_tab_ix := 0;
    v_stl_tab    := v_stl_tab_empty;

    -- Der Letzte 'V'errichtensatz wird geschrieben

    v_mit_quitt_gruppe := v_mit_quitt_gruppe or
                          (v_bde_fa_plan_crt.quitt_gruppe_ag is not NULL);

    create_bde_fa_auftrag_DB31 (v_bde_fa_plan_crt.satzartz,
                                -- in_ag_satzart      in bde_fa_auftrag.satzart%type,
                                1, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                                in_artikel_id, -- in_artikel_id      in isi_artikel.artikel_id%type,
                                v_artikel.zeichnung, --  in_zeichnung       in isi_artikel.zeichnung%type,
                                v_artikel.zeichnung_index,
                                -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                                in_charge_bez, -- in_charge_bez      in lvs_charge.charge_bez%type,
                                in_login_id, -- in_login_id        in isi_user.login_id%type,
                                v_menge, -- in_menge           in lvs_lam.menge%type,
                                in_kunden_nr, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                                v_artikel_kd.kd_art_nr,
                                -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                                in_kenz_lhm_druck, -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                                nvl(v_artikel_kd.lte_name, v_artikel.lte_name),
                                -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                                nvl(v_artikel_kd.lte_menge, v_artikel.lte_menge),
                                -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                                in_anz_lte, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                                nvl(v_artikel_kd.lhm_name, v_artikel.lhm_name),
                                -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                                nvl(v_artikel_kd.lhm_menge, v_artikel.lhm_menge),
                                -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                                in_anz_lhm, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                                in_bestnr_kd, -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                                in_abnr, -- in_abnr            in bde_fa_auftrag.abnr%type,
                                in_out_leitzahl, -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                                v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                                v_artikel.abfuell_abschalt_grob,
                                -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                v_artikel.abfuell_abschalt_mittel,
                                -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                v_artikel.abfuell_abschalt_fein,
                                -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                v_artikel.abfuell_toleranz_plus,
                                -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                v_artikel.abfuell_toleranz_minus,
                                -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                v_artikel.abfuell_soll,
                                -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                                v_bde_fa_plan_crt, -- in_bde_fa_plan     in t_bde_fa_plan)
                                in_seq_nr,
                                in_lead_leitzahl,
                                in_primaer_leitzahl,
                                NULL,   -- in_dispo_charge_rein       in varchar2,
                                NULL    -- in_hersteller_liste        in pps_simple_fa.hersteller_kuerzel_liste%type
                                );

    -- Dann am Ende den Kopfsatz schreiben
    insert into bde_fa_kopf
    values
      (in_sid, -- SID                     VARCHAR2(2) not null,
       in_firma_nr, -- FIRMA_NR                NUMBER(2) not null,  PLAN_AUF_AG_ID   NUMBER not null,
       in_out_leitzahl, -- PLAN_AUF_ID      NUMBER not null,
       in_out_leitzahl, -- PLAN_AUF_ID_EXT   NUMBER,
       in_artikel_id, -- ARTIKEL_ID        INTEGER not null,
       v_artikel.zeichnung, -- ZEICHNUNG         VARCHAR2(255),
       v_artikel.zeichnung_index, -- ZEICHNUNG_INDEX   VARCHAR2(10),
       in_menge, -- MENGE             INTEGER not null,
       'N', -- STATUS            VARCHAR2(10) default 'N' not null,
       sysdate, -- ERZ_DATUM         DATE not null,
       in_login_id, -- ERZ_LOGIN_ID      NUMBER,
       NULL, -- AEND_DATUM        DATE,
       NULL, -- AEND_LOGIN_ID     NUMBER,
       'ISI', -- ERZEUGER          VARCHAR2(10) default 'ISI' not null,
       v_bde_fa_plan.prod_params, -- PROD_PARAMS       VARCHAR2(4000),
       in_kunden_nr, -- KUNDEN_NR         VARCHAR2(20),
       v_artikel_kd.kd_art_nr, -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
       in_bestnr_kd, -- KD_BEST_NR        VARCHAR2(30),
       NULL, -- KD_BEST_POS       VARCHAR2(5),
       NULL, -- KD_BEST_TEXT1     VARCHAR2(255),
       NULL, -- KD_BEST_TEXT2     VARCHAR2(255),
       NULL, -- KD_BEST_TEXT3     VARCHAR2(255),
       NULL, -- TERMIN_ENDE       DATE,
       NULL, -- TERMIN_SOLL_START DATE,
       v_arb_plan_id, -- ARB_PLAN_ID       NUMBER,
       NULL, -- UNIQUE_HASH       VARCHAR2(200)
       v_bde_fa_plan.arb_soll_betriebsart, -- SOLL_BETRIEBSART  VARCHAR2(10)
       in_serie_id, -- SERIE_ID          NUMBER,
       in_serie_auto_inc, -- SERIE_AUTO_INC    VARCHAR2(1) default 'F',
       in_fa_gruppe, -- FA_GRUPPE         NUMBER
       in_lam_sel1, -- in_lam_sel1         in lvs_lam.LAM_SEL1%type,
       in_lam_sel2, -- in lvs_lam.LAM_SEL2%type,
       in_lam_sel3, -- in lvs_lam.LAM_SEL3%type,
       in_lam_sel4, -- in lvs_lam.LAM_SEL4%type,
       in_lam_sel5, -- in lvs_lam.LAM_SEL5%type,
       in_lam_sel6, -- in lvs_lam.LAM_SEL6%type,
       in_lam_sel7, -- in lvs_lam.LAM_SEL7%type,
       in_lam_sel8, -- in lvs_lam.LAM_SEL8%type,
       in_lam_sel9, -- in lvs_lam.LAM_SEL9%type,
       in_lam_sel10, -- in lvs_lam.LAM_SEL10%type,
       in_lohn_arbeit, -- in bde_fa_auftrag.lohn_arbeit%type,
       in_adress_id); -- in bde_fa_auftrag.adress_id%type,
    update bde_fa_auftrag t
       set t.lohn_arbeit = in_lohn_arbeit, t.adress_id = in_adress_id
     where t.leitzahl = in_out_leitzahl;

    if v_mit_quitt_gruppe then
      OPEN c_bde_fa_quitt_grp;
      LOOP
        FETCH c_bde_fa_quitt_grp
          into v_fa_ag_quitt_gruppe, v_quitt_gruppe;
        EXIT when c_bde_fa_quitt_grp%NOTFOUND;
        update bde_fa_auftrag t
           set t.quitt_gruppe_ag = v_fa_ag_quitt_gruppe
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.leitzahl = in_out_leitzahl
           and t.quitt_gruppe_ag = v_quitt_gruppe;
      end LOOP;
      CLOSE c_bde_fa_quitt_grp;
    end if;
    -- Einbau der Tabelle wenn eine FA erstellt wurde
    insert into bde_fa_auftrag_rel
      select *
        from bde_v_gen_bde_fa_auftrag_rel t
       where t.leitzahl = in_out_leitzahl;

    if isi_allg.c_get_firma_cfg_param (in_sid,
                                       in_firma_nr,
                                       'BDE_DISPO',           -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                       NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                       'BDE_DISPO_KOMPLETT',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                       'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                       'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                       c.R_C_FALSE,           -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                       'STRING') = c.R_C_TRUE -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    then
      create_bde_fa_dispo(in_sid, -- in isi_sid.sid%type,
                          in_firma_nr, -- in isi_firma.firma_nr%type,
                          in_dispo_charge_rein, -- in varchar2,
                          in_hersteller_liste, -- in pps_simple_fa.hersteller_kuerzel_liste%type,
                          in_out_leitzahl, -- in bde_fa_auftrag.leitzahl%type,
                          NULL, -- in bde_fa_auftrag.fa_ag%type,
                          NULL, -- in bde_fa_auftrag.fa_upos%type,
                          c.C_TRUE, -- Mengen muessen komplett vorhanden sein
                          in_login_id, -- in isi_user.login_id%type);
                          c.C_FALSE); -- In_ice
    end if;

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then
      -- Update 2011 show Exception Source Line
      v_err_text := v_err_text || CHR(13) || CHR(10) ||
                    DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text || CHR(13) || CHR(10) ||
                      DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%' then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) ||
                        DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  ---------------------------------------------------------------------------------------
  -- procedure create_bde_fa_auftrag
  -- Erzeugt eine Eintrag in der BDE_FA_AUFTRAG
  ---------------------------------------------------------------------------------------
  procedure create_bde_fa_auftrag(in_ag_satzart              in bde_fa_auftrag.satzart%type,
                                   in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                   in_artikel_id              in isi_artikel.artikel_id%type,
                                   in_zeichnung               in isi_artikel.zeichnung%type,
                                   in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                   in_charge_bez              in lvs_charge.charge_bez%type,
                                   in_login_id                in isi_user.login_id%type,
                                   in_menge                   in lvs_lam.menge%type,
                                   in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                   in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                   in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                   in_lte_name                in bde_fa_auftrag.lte_name%type,
                                   in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                   in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                   in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                   in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                   in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                   in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                   in_abnr                    in bde_fa_auftrag.abnr%type,
                                   in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                   in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                   in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                   in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                   in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                   in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                   in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                   in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                   in_bde_fa_plan             in t_bde_fa_plan) is
  begin
    create_bde_fa_auftrag_DB31(in_ag_satzart,              -- in bde_fa_auftrag.satzart%type,
                               in_kenz_letzter,            -- in bde_fa_auftrag.kenz_letzt_ag%type,
                               in_artikel_id,              -- in isi_artikel.artikel_id%type,
                               in_zeichnung,               -- in isi_artikel.zeichnung%type,
                               in_zeichnung_index,         -- in isi_artikel.zeichnung_index%type,
                               in_charge_bez,              -- in lvs_charge.charge_bez%type,
                               in_login_id,                -- in isi_user.login_id%type,
                               in_menge,                   -- in lvs_lam.menge%type,
                               in_kunden_nr,               -- in bde_fa_auftrag.kunden_nr%type,
                               in_kd_art_nr,               -- in bde_fa_auftrag.kd_art_nr%type,
                               in_kenz_lhm_druck,          -- in bde_fa_auftrag.kenz_lhm_druck%type,
                               in_lte_name,                -- in bde_fa_auftrag.lte_name%type,
                               in_lte_menge,               -- in bde_fa_auftrag.lte_menge%type,
                               in_anz_lte,                 -- in bde_fa_auftrag.lte_anz%type,
                               in_lhm_name,                -- in bde_fa_auftrag.lhm_name%type,
                               in_lhm_menge,               -- in bde_fa_auftrag.lhm_menge%type,
                               in_anz_lhm,                 -- in bde_fa_auftrag.lhm_anz%type,
                               in_bestnr_kd,               -- in bde_fa_auftrag.best_nr_kunde%type,
                               in_abnr,                    -- in bde_fa_auftrag.abnr%type,
                               in_out_leitzahl,            -- in out bde_fa_auftrag.leitzahl%type,
                               in_fa_ag,                   -- in bde_fa_auftrag.fa_ag%type,
                               in_abfuell_grob,            -- in bde_fa_auftrag.abfuell_abschalt_grob%type,
                               in_abfuell_mittel,          -- in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                               in_abfuell_fein,            -- in bde_fa_auftrag.abfuell_abschalt_fein%type,
                               in_abfuell_tolleranz_plus,  -- in bde_fa_auftrag.abfuell_toleranz_plus%type,
                               in_abfuell_tolleranz_minus, -- in bde_fa_auftrag.abfuell_toleranz_minus%type,
                               in_abfuell_soll,            -- in bde_fa_auftrag.abfuell_soll%type,
                               in_bde_fa_plan,             -- in t_bde_fa_plan,
                               NULL,                       --  in_seq_nr                  in bde_fa_auftrag.seq_nr,
                               NULL,                       --  in_lead_leitzahl           in bde_fa_auftrag.lead_leitzahl
                               NULL,                       --  in_primaer_leitzahl        in bde_fa_auftrag.primaer_leitzahl%type
                               NULL,                       --  in_dispo_charge_rein       in varchar2,
                               NULL                        --  in_hersteller_liste        in pps_simple_fa.hersteller_kuerzel_liste%type
                               );

  end;

  procedure create_bde_fa_auftrag_DB31(in_ag_satzart              in bde_fa_auftrag.satzart%type,
                                       in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                       in_artikel_id              in isi_artikel.artikel_id%type,
                                       in_zeichnung               in isi_artikel.zeichnung%type,
                                       in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                       in_charge_bez              in lvs_charge.charge_bez%type,
                                       in_login_id                in isi_user.login_id%type,
                                       in_menge                   in lvs_lam.menge%type,
                                       in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                       in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                       in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                       in_lte_name                in bde_fa_auftrag.lte_name%type,
                                       in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                       in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                       in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                       in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                       in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                       in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                       in_abnr                    in bde_fa_auftrag.abnr%type,
                                       in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                       in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                       in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                       in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                       in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                       in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                       in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                       in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                       in_bde_fa_plan             in t_bde_fa_plan,
                                       in_seq_nr                  in bde_fa_auftrag.seq_nr%type,
                                       in_lead_leitzahl           in bde_fa_auftrag.lead_leitzahl%type,
                                       in_primaer_leitzahl        in bde_fa_auftrag.primaer_leitzahl%type,
                                       in_dispo_charge_rein       in varchar2,
                                       in_hersteller_liste        in pps_simple_fa.hersteller_kuerzel_liste%type
                                       ) is

    v_found                boolean;
    v_charge_id            lvs_charge.charge_id%type;
    v_ag_menge             bde_fa_auftrag.ag_ist_mg%type;
    v_ag_prod_params       bde_fa_auftrag.prod_params%type;
    v_artikel              isi_artikel%rowtype;
    v_artikel_kunde        isi_artikel_kunde%rowtype;
    v_artikel_gruppe       isi_artikel_gruppe%rowtype;
    v_artikel_ctrl         isi_artikel_ctrl%rowtype;
    v_pps_arb_plan_ag_fhm  pps_arb_plan_ag_fhm%rowtype;
    v_lhm_menge            bde_fa_auftrag.lhm_menge%type; -- LHM_MENGE               NUMBER,
    v_lte_menge            bde_fa_auftrag.lte_menge%type; -- LTE_MENGE               NUMBER,
    v_hersteller           isi_artikel_hersteller%rowtype;
    v_bde_hersteller_liste pps_simple_fa.hersteller_kuerzel_liste%type;


    CURSOR c_pps_fhms is
      select pps_fhm.*
        from pps_arb_plan_ag_fhm pps_fhm,
             isi_resource r,
             isi_resource rmpg
       where pps_fhm.sid = in_bde_fa_plan.sid
         and pps_fhm.firma_nr = in_bde_fa_plan.firma_nr
         and pps_fhm.arb_plan_id = in_bde_fa_plan.arb_plan_id
         and pps_fhm.arb_plan_pos_id = in_bde_fa_plan.arb_plan_pos_id
         and pps_fhm.ag_alternative = in_bde_fa_plan.ag_alternative
         and r.res_id = in_bde_fa_plan.res_id
         and rmpg.res_id(+) = r.gruppe
         and rmpg.typ = 'MPG'
         and (pps_fhm.fhm_grp = r.res_name || '-' || in_bde_fa_plan.arb_plan_pos_id
           or pps_fhm.fhm_grp = rmpg.res_name || '-' || in_bde_fa_plan.arb_plan_pos_id);
     
    CURSOR c_get_hersteller_liste is
      select x.*
        from isi_artikel_hersteller x
       where (x.herstellerkuerzel = in_hersteller_liste or
              x.herstellerkuerzel || ';' = in_hersteller_liste)
         and x.artikel_id = in_bde_fa_plan.artikel_id;
  begin
    -- Pruefen, ob der MAV-Wert ereicht ist, wenn ja dann Fehler
    if in_fa_ag >= v_ag_max then
      raise_isi_error(10,
                      lc.ec_p2(lc.O_TP2_BDE_FA_AG_ZU_GROSS,
                               in_out_leitzahl,
                               in_fa_ag));
    end if;

    -- Keine Leitzahl uebergeben, dann aus SEQ holen
    if in_out_leitzahl is NULL then
      select SEQ_BDE_FA_AUFTRAG_LEITZAHL.nextval
        into in_out_leitzahl
        from dual;
    end if;

    v_ag_prod_params := in_bde_fa_plan.prod_params;
    if in_ag_satzart = 'MA' then
      v_charge_id := get_charge_id(in_bde_fa_plan.sid,
                                   in_bde_fa_plan.firma_nr,
                                   NULL,
                                   in_out_leitzahl || '/' || in_fa_ag,
                                   in_artikel_id);
      -- Materialanforderung immer nur auf dem ersten Eintrag mit der kompletten Menge
      if in_bde_fa_plan.prod_menge_ix > 1 then
        return;
      end if;
      v_ag_prod_params := in_bde_fa_plan.stk_prod_params;
    end if;

    -- Bei den Verrichtensaetzen Charge bilden
    if in_ag_satzart != 'MA' then
      if in_kenz_letzter = 1 then
        v_charge_id := get_charge_id(in_bde_fa_plan.sid,
                                     in_bde_fa_plan.firma_nr,
                                     NULL,
                                     nvl(in_charge_bez,
                                         in_out_leitzahl || '/' || in_fa_ag),
                                     in_artikel_id);
      else
        v_charge_id := get_charge_id(in_bde_fa_plan.sid,
                                     in_bde_fa_plan.firma_nr,
                                     NULL,
                                     in_out_leitzahl || '/' || in_fa_ag,
                                     in_artikel_id);
      end if;
      OPEN c_pps_fhms;
      LOOP
        FETCH c_pps_fhms into v_pps_arb_plan_ag_fhm;
        EXIT when c_pps_fhms%NOTFOUND;
        insert into bde_fa_auftrag_fhm
        values
          (in_bde_fa_plan.sid, -- SID                     VARCHAR2(2) not null,
           in_bde_fa_plan.firma_nr, -- FIRMA_NR                NUMBER(2) not null,
           in_abnr, -- ABNR                    VARCHAR2(20),
           in_out_leitzahl, -- LEITZAHL                NUMBER not null,
           in_fa_ag, -- FA_AG                   NUMBER not null,
           in_bde_fa_plan.ag_upos, -- FA_UPOS                 NUMBER not null,
           v_pps_arb_plan_ag_fhm.fhm,
           v_pps_arb_plan_ag_fhm.fhm_grp,
           v_pps_arb_plan_ag_fhm.anz_benoetigt);
      end LOOP;
      CLOSE c_pps_fhms;
    end if;

    -- Bei MA die Mengen er;mitteln
    if in_ag_satzart = 'MA' then
      -- Hotfix CMe 20210806 Hersteller darf nur dann hinterlegt werden, 
      -- wenn in der Artikel Hersteller Liste ein Hersteller hinterlegt
      open c_get_hersteller_liste;
      fetch c_get_hersteller_liste into v_hersteller;
      v_found := c_get_hersteller_liste%found;
      close c_get_hersteller_liste;
      
      if v_found
      then
        v_bde_hersteller_liste := in_hersteller_liste;
      else
        v_bde_hersteller_liste := null;
      end if;
      -- Hotfix CMe 20210806 Ende
      case
        when in_bde_fa_plan.stk_plan_menge_p_einheit_op = 'MUL' then
          v_ag_menge := in_menge * in_bde_fa_plan.stk_plan_menge_p_einheit;
        when in_bde_fa_plan.stk_plan_menge_p_einheit_op = 'DIV' then
          v_ag_menge := in_menge / in_bde_fa_plan.stk_plan_menge_p_einheit;
        when in_bde_fa_plan.stk_plan_menge_p_einheit_op = 'ABS' then
          v_ag_menge := in_bde_fa_plan.stk_plan_menge_p_einheit;
        else
          v_ag_menge := 0;
      end case;

      if isi_p_base.get_isi_artikel(in_bde_fa_plan.sid,
                                    in_artikel_id,
                                    v_artikel) then
        if not isi_p_base.get_isi_artikel_kd(in_bde_fa_plan.sid,
                                             in_artikel_id,
                                             in_kunden_nr,
                                             v_artikel_kunde) then
          v_artikel_kunde := NULL;
        end if;
        if isi_p_base.get_artikel_gruppe(in_bde_fa_plan.sid,
                                         v_artikel.art_gruppe_id,
                                         v_artikel_gruppe) then
          if v_artikel_gruppe.art_params_cfg is not null then
            if isi_p_base.get_artikel_ctrl(in_bde_fa_plan.sid,
                                           in_artikel_id,
                                           in_zeichnung,
                                           in_zeichnung_index,
                                           in_out_leitzahl,
                                           in_fa_ag,
                                           v_artikel_ctrl) then
              if isi_utils.is_param_list_comlete(v_artikel_ctrl.prod_params,
                                                 v_artikel_gruppe.art_params_cfg,
                                                 c.c_true) = c.c_false then
                raise_isi_error(30,
                                lc.ec_p3(lc.O_TP3_ART_PROD_PARAM_NIO,
                                         in_out_leitzahl,
                                         in_fa_ag,
                                         v_artikel.artikel));
              end if;
            else
              raise_isi_error(30,
                              lc.ec_p3(lc.O_TP3_ART_PROD_PARAM_NIO,
                                       in_out_leitzahl,
                                       in_fa_ag,
                                       v_artikel.artikel));
            end if;

            v_ag_prod_params := v_ag_prod_params || ';' ||
                                v_artikel_ctrl.prod_params;
          end if;

          if v_artikel_gruppe.prod_params is not null then
            v_ag_prod_params := v_ag_prod_params || ';' ||
                                v_artikel_gruppe.prod_params;
          end if;
        end if;
      end if;
    else
      v_found    := isi_p_base.get_isi_artikel(in_bde_fa_plan.sid,
                                               in_artikel_id,
                                               v_artikel);
      v_ag_menge := in_menge;
    end if;

    -- Mengen immer auf Ganze aufrunden
    v_ag_menge := round(v_ag_menge + 0.499999999999999999999999, 0); -- Immer ganze Einheit aufgerundet

    v_lhm_menge := in_lhm_menge;    -- LHM_MENGE               NUMBER,
    if nvl(v_lhm_menge, 0) = 0
    and in_anz_lhm > 0
    then
      v_lhm_menge := round(v_ag_menge / in_anz_lhm);
    end if;
    v_lte_menge := in_lte_menge;    -- LTE_MENGE               NUMBER,
    if nvl(v_lte_menge, 0) = 0
    and in_anz_lte > 0
    then
      v_lte_menge := round(v_ag_menge / in_anz_lte);
    end if;

    -- BDE-Eintrag schreiben
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
    insert into bde_fa_auftrag t
    values
      (in_bde_fa_plan.sid, -- SID                     VARCHAR2(2) not null,
       in_bde_fa_plan.firma_nr, -- FIRMA_NR                NUMBER(2) not null,
       in_abnr, -- ABNR                    VARCHAR2(20),
       in_out_leitzahl, -- LEITZAHL                NUMBER not null,
       in_fa_ag, -- FA_AG                   NUMBER not null,
       in_bde_fa_plan.ag_upos, -- FA_UPOS                 NUMBER not null,
       in_ag_satzart, -- SATZART                 VARCHAR2(2),
       in_bde_fa_plan.res_id, -- RES_ID                  NUMBER,
       0, -- ANZ_RES                 NUMBER,
       in_artikel_id, -- AB_ARTIKEL_ID           NUMBER,
       in_menge, -- AB_SOLL_MG              NUMBER,
       0, -- AB_IST_MG               NUMBER,
       in_bde_fa_plan.arb_plan_text1, -- AB_TEXT1                VARCHAR2(255),
       in_bde_fa_plan.arb_plan_text2, -- AB_TEXT2                VARCHAR2(255),
       in_bde_fa_plan.arb_plan_text3, -- AB_TEXT3                VARCHAR2(255),
       NULL, -- AB_ENDE_STATUS          VARCHAR2(3),
       v_ag_menge, -- AG_SOLL_MG              NUMBER,
       0, -- AG_IST_MG               NUMBER,
       0, -- AG_IST_MG_B             NUMBER,
       0, -- AG_IST_MG_SCHROTT       NUMBER,
       0, -- AG_IST_MG_RUESTEN       NUMBER,
       decode(in_ag_satzart, 'MA', 0, in_bde_fa_plan.soll_zeit_ruest),
       -- RUEST_ZEIT_GEPL         NUMBER,
       0, -- RUEST_ZEIT_IST          NUMBER,
       decode(in_ag_satzart,
              'MA',
              0,
              v_ag_menge * in_bde_fa_plan.soll_zeit_p_einh),
       -- PROD_ZEIT_GEPL          NUMBER,
       0, -- PROD_ZEIT_IST           NUMBER,
       decode(in_ag_satzart,
              'MA',
              0,
              v_ag_menge * in_bde_fa_plan.soll_zeit_p_einh *
              in_bde_fa_plan.soll_zeit_stoer_p_std / 60),
       -- STOER_ZEIT_GEPL         NUMBER,
       0, -- STOER_ZEIT_IST          NUMBER,
       decode(in_ag_satzart, 'MA', 0, in_bde_fa_plan.soll_zeit_p_einh),
       -- ZEIT_EINHEIT            NUMBER,
       in_bde_fa_plan.termin_start_gepl, -- TERMIN_START_GEPL       DATE,
       in_bde_fa_plan.termin_ende_gepl, -- TERMIN_ENDE_GEPL        DATE,
       NULL, -- TERMIN_START_IST        DATE,
       NULL, -- TERMIN_ENDE_IST         DATE,
       'N', -- FREIG_STATUS            VARCHAR2(3),
       NULL, -- FREIG_WER               NUMBER,
       NULL, -- FREIG_WANN              DATE,
       NULL, -- STATUS_RES_ID           NUMBER,
       NULL, -- STATUS_ID               NUMBER,
       NULL, -- STATUS_BEGIN            DATE,
       in_kunden_nr, -- KUNDEN_NR               NUMBER,
       decode(in_ag_satzart, 'MA', in_bde_fa_plan.artikel_id, in_artikel_id), -- AG_ARTIKEL_ID           NUMBER,
       in_kd_art_nr, -- KD_ART_NR               VARCHAR2(30),
       in_bde_fa_plan.ag_name1, -- AG_BEZ1                 VARCHAR2(255),
       in_bde_fa_plan.ag_name2, -- AG_BEZ2                 VARCHAR2(255),
       in_bde_fa_plan.ag_text1, -- AG_TEXT1                VARCHAR2(255),
       in_bde_fa_plan.ag_text2, -- AG_TEXT2                VARCHAR2(255),
       in_bde_fa_plan.ag_text3, -- AG_TEXT3                VARCHAR2(255),
       in_zeichnung, -- ZEICHNUNG               VARCHAR2(255),
       NULL, -- SCHROTT_PROZ            NUMBER,
       NULL, -- NUTZEN                  NUMBER,
       NULL, -- GEWICHT                 NUMBER,
       NULL, -- SCHORTT                 NUMBER,
       NULL, -- VERBRAUCH               NUMBER,
       NULL, -- EINSATZ                 NUMBER,
       NULL, -- MAX_TAKT_AUSF_ZEIT      NUMBER,
       NULL, -- MIN_TAKT_ZEIT           NUMBER,
       NULL, -- MAX_TAKT_ZEIT           NUMBER,
       NULL, -- STATUS_FREIGABE         NUMBER,
       NULL, -- AG_ID                   VARCHAR2(20),
       v_charge_id, -- CHARGE_ID               NUMBER,
       in_kenz_letzter, -- KENZ_LETZT_AG           NUMBER(1),
       in_zeichnung_index, -- ZEICHNUNG_INDEX         VARCHAR2(10),
       in_lhm_name, -- LHM_NAME                VARCHAR2(10),
       v_lhm_menge, -- LHM_MENGE               NUMBER,
       in_lte_name, -- LTE_NAME                VARCHAR2(10),
       v_lte_menge, -- LTE_MENGE               NUMBER,
       in_bestnr_kd, -- BEST_NR_KUNDE           VARCHAR2(30),
       in_kenz_lhm_druck, -- KENZ_LHM_DRUCK          VARCHAR2(1),
       0, -- MDE_IST_MG              NUMBER,
       0, -- MDE_IST_MG_B            NUMBER,
       0, -- MDE_IST_MG_SCHROTT      NUMBER,
       0, -- MDE_IST_MG_RUESTEN      NUMBER,
       0, -- MDE_MICRO_STOP          NUMBER,
       0, -- MDE_IST_MG_T            NUMBER,
       0, -- MDE_IST_MG_B_T          NUMBER,
       0, -- MDE_IST_MG_SCHROTT_T    NUMBER,
       0, -- MDE_IST_MG_RUESTEN_T    NUMBER,
       0, -- MDE_MICRO_STOP_T        NUMBER,
       v_artikel.lte_lhm_lagen, -- LTE_LHM_LAGEN           NUMBER(2),
       v_artikel.lte_lhm_pro_lage, -- LTE_LHM_PRO_LAGE        NUMBER(2),
       in_anz_lte, -- LTE_ANZ                 NUMBER,
       0, -- LTE_ANZ_IST             NUMBER,
       in_anz_lhm, -- LHM_ANZ                 NUMBER,
       0, -- LHM_ANZ_IST             NUMBER,
       in_abfuell_grob, -- ABFUELL_ABSCHALT_GROB   NUMBER,
       in_abfuell_mittel, -- ABFUELL_ABSCHALT_MITTEL NUMBER,
       in_abfuell_fein, -- ABFUELL_ABSCHALT_FEIN   NUMBER,
       in_abfuell_tolleranz_plus, -- ABFUELL_TOLERANZ_PLUS   NUMBER,
       in_abfuell_tolleranz_minus, -- ABFUELL_TOLERANZ_MINUS  NUMBER,
       NULL, -- ABFUELL_SILO            VARCHAR2(30),
       in_abfuell_soll, -- ABFUELL_SOLL            NUMBER,
       v_ag_prod_params, -- PROD_PARAMS             VARCHAR2(4000),
       in_bde_fa_plan.nio_res_id, -- nio_res_id              number
       in_bde_fa_plan.quitt_gruppe_ag, -- QUITT_GRUPPE_AG         NUMBER
       in_bde_fa_plan.stk_plan_menge_p_einheit, --
       in_bde_fa_plan.stk_plan_menge_p_einheit_op,
       NULL, -- Keine Lieferadresse
       NULL, -- AG_LOS_MG               NUMBER,
       0, -- RCV_AG_IST_MG           NUMBER,
       0, -- RCV_AG_IST_MG_B         NUMBER,
       0, -- RCV_AG_IST_MG_SCHROTT   NUMBER,
       0, -- RCV_AG_IST_MG_RUESTEN   NUMBER,
       0, -- RCV_RUEST_ZEIT_IST      NUMBER,
       0, -- RCV_PROD_ZEIT_IST       NUMBER
       0, -- RCV_STOER_ZEIT_IST      NUMBER,
       0, -- AG_LOS_IST_MG           NUMBER
       nvl(v_artikel_kunde.packschema_kopf_id, v_artikel.packschema_kopf_id), -- Packschema
       v_artikel.art_laenge, -- AG_ART_LAENGE  N  NUMBER  Y      Länge
       v_artikel.art_breite, -- AG_ART_BREITE  N  NUMBER  Y      Breite
       v_artikel.art_dicke, -- AG_ART_DICKE  N  NUMBER  Y      Dicke
       v_artikel.art_durch, -- AG_ART_DURCH  N  NUMBER  Y      Durchmesser
       null, -- KUNDEN_AB  N  VARCHAR2(20)  Y      AB Nummer des Kundenauftrags
       null, -- KUNDEN_AB_POS  N  VARCHAR2(20)  Y      AB Positionsnummer des Kundenauftrags
       null, -- KUNDEN_AB_UPOS  N  VARCHAR2(20)  Y      AB Unterposition des Kundenauftrags
       null, -- TERM_WUNSCH  N  DATE  Y      Wunschtermin in dd.mm.yyyy hh24:mi:ss
       null, -- TERM_BEST  N  DATE  Y      Bestätigter Termin in dd.mm.yyyy hh24:mi:ss
       0, -- TRANSP_ZEIT  N  NUMBER  Y      Transportzeit für die Lieferung zum Kunden in STD
       null, -- ANZ_ROHSTOFFE  N  NUMBER  Y      Anzahl der benötigten Drähte
       null, -- AUSGEF_ENDE  N  VARCHAR2(1)  Y      AUSGEFÜHRTES ENDE
       'T', -- AG_PROD_FREI  N  VARCHAR2(1)  Y      T = Freigegeben für Produktion, F = Nur für Planung
       0, -- AG_UEBERLAPPEN  N  NUMBER(12,3)  Y      Anzahl die fertig sein müssen, um den  nächsten AG zu beginnen nächsten AG zu beginnen"""""
       NULL, -- AG_OPT_GRP  N  VARCHAR2(50)  Y      Rüstgruppe zur optimierung im APS
       NULL, -- PRIORITAET
       NULL, -- Vorgangsqualifikation
       NULL, -- anz_mitarbeiter
       'F', -- LUECKENFUELLER
       in_bde_fa_plan.termin_start_gepl, -- TERMIN_START_FRUEH
       NULL, -- START_BATCH_BY_ORDER_START
       NULL, -- EXT_Arbeitsanweisung
       NULL, -- JOB_SEQUENZ  N  NUMBER  Y      Job Sequenz als Abarbeitungsreihenfolge für selektierte Splitts
       NULL, -- Kunden_AB_Text
       0,    -- RUEST_ZEIT_ERF  N  NUMBER  Y      Erfasste Rüstzeit in Minuten
       0,    -- PROD_ZEIT_ERF  N  NUMBER  Y      Erfasste netto Produktionszeit in Minuten
       0,    -- STOER_ZEIT_ERF  N  NUMBER  Y      Erfasste  Ausfallzeiten in Minuten
       NULL, -- TERMIN_START_ERF  N  DATE  Y      Erfasster Produktionsstart
       NULL, -- TERMIN_ENDE_ERF  N  DATE  Y      Erfasstes Produktionsende
       NULL, -- KATEGORIE  N  VARCHAR2(20)  Y      Kategorie z.B. SAMPLE, Nachschreiber, ...
       NULL, -- auf_id
       'F', -- MA_RESERVIERT  N  VARCHAR2(1)  Y      Ist der Rohstoff (Materialanforderung) Reserviert T=Ist Reserviert, F=Ist nicht reserviert
       0, -- MA_RES_MENGE  N  NUMBER  Y      Welche Menge  Rohstoff (Materialanforderung) ist Reserviert
       case when in_ag_satzart = 'MA'
             and in_dispo_charge_rein = 'T'
            then 0
            else NULL
       end, -- MA_RES_CHARGE_ID  N  NUMBER  Y      Wenn ID gefüllt, dann muss Chargenrein der Rohstoff verwendet werden
       v_bde_hersteller_liste, -- MA_HERSTELLER_KUERZEL_LISTE  N  VARCHAR2(100)  Y      Wenn Herstelle-Rein, dann ist hier der Hersteller als Liste hinterlegt Wert mit ;
       0, -- MA_RES_MENGE_KOMM  N  NUMBER  Y      Welche Menge  Rohstoff wurde berreitgestellt / Kommissioniert
       NULL, -- ADRESS_ID  N NUMBER  Y     Verlängerte Werkbank, Eigetümer der Rohstoffe und Fertigware
       'F', -- in_lohn_arbeit,            -- in bde_fa_auftrag.lohn_arbeit%type,
       sysdate, -- CREATED_DATE  N DATE  Y sysdate   creation date+time of this dataset
       in_login_id, -- CREATED_LOGIN_ID  N NUMBER  Y -1    login id of the user creating this dataset
       NULL, -- LAST_CHANGE_DATE  N DATE  Y     change date+time of this dataset
       NULL,  -- LAST_CHANGE_LOGIN_ID  N NUMBER  Y     login id of the user changing this dataset
       0,     -- RCV_RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
       0,     -- RCV_PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
       in_seq_nr,                 -- bde_fa_auftrag.seq_nr%type,
       in_lead_leitzahl,          -- bde_fa_auftrag.lead_leitzahl%type
       in_primaer_leitzahl,        -- bde_fa_auftrag.primaer_leitzahl%type
                                   -- AG 20200519 - Erweiterung Standard um eine ummer der Pruefung im BDE_FA_AUFTRAG und ín der LAM
       NULL,                       -- NR_PRUEFUNG N varchar2(20)  Bei der Erstellung des FAs noch nicht vorhanden
                                          -- Nummer der Prüfung (Nicht der Stammsate der die Prüfung beschreibt)
       NULL,                       -- FREMD_ZEICHNUNG N VARCHAR2(30)  Y     N   Externe Zeichnung
       NULL                       -- ZEICHNUNGNAME N VARCHAR2(255) Y     N   Zeichnungsname (*.TIF)
       );

  end;

  ---------------------------------------------------------------------------------------
  -- procedure c_create_bde_fa_auftrag_a_pps
  -- Erzeugt aus PPS-Daten --> BDE-Daten
  -- Erzeugt Eintraege in der BDE_FA_AUFTRAG auf der Grundlage der PPS_PLAN_AUFTRAG Daten.
  -- Mit dem CURSOR c_bde_fa_plan werden die Daten so zusammengestellt, dass die max.
  -- Auspraegung der Kombinationen aus 'V'errichetn und 'MA'terialanforderung entsteht.
  -- Der Letzte Satz, der in der Stückliste den gleichen Arbeitsgang beschreibt, wird zur
  -- Erzeugung des 'V'erichten Satz benutzt. Hierfür wird der aktuelle Satz immer in die
  -- Recordstruktur v_bde_fa_plan_crt kopiert, die dann für die Erzeugung genutzt wird.
  --
  -- ACHTUNG: Wenn eine in_plan_auf_id übergeben wird, dann wird dieser Auftrag in der
  --          BDE_FA_AUFTRAG Tabelle gelöscht und neu angelegt
  ---------------------------------------------------------------------------------------
  /* -------------------------------------------------------------------------------
  procedure c_create_bde_fa_auftrag_a_pps
  Erzeugt aus PPS-Daten --> BDE-Daten
  -------------------------------------------------------------------------------*/
  procedure c_create_bde_fa_auf_a_pla_disp(in_sid               in isi_sid.sid%type,
                                           in_firma_nr          in isi_firma.firma_nr%type,
                                           in_artikel_id        in isi_artikel.artikel_id%type,
                                           in_charge_bez        in lvs_charge.charge_bez%type,
                                           in_res_id            in isi_resource.res_id%type,
                                           in_login_id          in isi_user.login_id%type,
                                           in_menge             in lvs_lam.menge%type,
                                           in_ab_text1          in bde_fa_auftrag.ab_text1%type,
                                           in_ab_text2          in bde_fa_auftrag.ab_text2%type,
                                           in_ab_text3          in bde_fa_auftrag.ab_text3%type,
                                           in_soll_betriebsart  in bde_fa_kopf.soll_betriebsart%type,
                                           in_kunden_nr         in bde_fa_auftrag.kunden_nr%type,
                                           in_kd_art_nr         in bde_fa_auftrag.kd_art_nr%type,
                                           in_ag_name1          in bde_fa_auftrag.ag_bez1%type,
                                           in_ag_name2          in bde_fa_auftrag.ag_bez2%type,
                                           in_ag_text1          in bde_fa_auftrag.ag_text1%type,
                                           in_ag_text2          in bde_fa_auftrag.ag_text2%type,
                                           in_ag_text3          in bde_fa_auftrag.ag_text3%type,
                                           in_kenz_lhm_druck    in bde_fa_auftrag.kenz_lhm_druck%type,
                                           in_anz_lte           in bde_fa_auftrag.lte_anz%type,
                                           in_anz_lhm           in bde_fa_auftrag.lhm_anz%type,
                                           in_bestnr_kd         in bde_fa_auftrag.best_nr_kunde%type,
                                           in_abnr              in bde_fa_auftrag.abnr%type,
                                           in_serie_id          in bde_fa_kopf.serie_id%type,
                                           in_serie_auto_inc    in bde_fa_kopf.serie_auto_inc%type,
                                           in_fa_gruppe         in bde_fa_kopf.fa_gruppe%type,
                                           in_dispo_charge_rein in varchar2, -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                           in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type) is
  begin
    create_bde_fa_auf_a_plan_dispo(in_sid, -- in isi_sid.sid%type,
                                   in_firma_nr, -- in isi_firma.firma_nr%type,
                                   in_artikel_id, -- in isi_artikel.artikel_id%type,
                                   in_charge_bez, -- in lvs_charge.charge_bez%type,
                                   in_res_id, -- in isi_resource.res_id%type,
                                   in_login_id, -- in isi_user.login_id%type,
                                   in_menge, -- in lvs_lam.menge%type,
                                   in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                                   in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                                   in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                                   in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                                   in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                                   in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                                   in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                                   in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                                   in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                                   in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                                   in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                                   in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                                   in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                                   in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                                   in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                                   in_abnr, -- in bde_fa_auftrag.abnr%type,
                                   in_serie_id, -- in bde_fa_kopf.serie_id%type,
                                   in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                                   in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                                   in_dispo_charge_rein, -- in varchar2,      -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                   in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type)

    commit;
  end;

  procedure c_create_bde_fa_auftrag_a_pps(in_sid         in isi_sid.sid%type,
                                          in_firma_nr    in isi_firma.firma_nr%type,
                                          in_plan_auf_id in pps_plan_auftrag.plan_auf_id%type,
                                          in_login_id    in isi_user.login_id%type) is

    v_found boolean;

    v_bde_fa_plan         t_bde_fa_plan;
    v_bde_fa_plan_crt     t_bde_fa_plan;
    v_pps_plan_auftrag    pps_plan_auftrag%rowtype;
    v_pps_plan_auftrag_ag pps_plan_auftrag_ag%rowtype;

    v_artikel    isi_artikel%rowtype;
    v_artikel_kd isi_artikel_kunde%rowtype;

    v_ag_schrittweite number;
    v_fa_ag           number;

    v_fa_ag_stl number;

    v_lte_anz     number;
    v_lhm_anz     number;
    v_anz_bde_beg number;

    v_pps_plan_auftrag_stl pps_plan_auftrag_stl%rowtype;

    v_mit_quitt_gruppe   boolean;
    v_quitt_gruppe       bde_fa_auftrag.quitt_gruppe_ag%type;
    v_fa_ag_quitt_gruppe bde_fa_auftrag.fa_ag%type;

    CURSOR c_bde_fa_quitt_grp is
      select max(t.fa_ag), t.quitt_gruppe_ag
        from bde_fa_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.leitzahl = in_plan_auf_id
         and t.quitt_gruppe_ag is not NULL
       group by t.quitt_gruppe_ag
       order by t.quitt_gruppe_ag desc;

    CURSOR c_artikel is
      select *
        from isi_artikel t
       where t.sid = in_sid
         and t.artikel_id = v_pps_plan_auftrag.artikel_id;

    CURSOR c_artikel_kd is
      select *
        from isi_artikel_kunde t
       where t.sid = in_sid
         and t.artikel_id = v_pps_plan_auftrag.artikel_id
         and t.kunden_nr = v_pps_plan_auftrag.kunden_nr
         and t.kd_art_nr = nvl(v_pps_plan_auftrag.kd_art_nr, t.kd_art_nr);

    CURSOR c_pps_plan_auftrag is
      select *
        from pps_plan_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.plan_auf_id = in_plan_auf_id;

    CURSOR c_pps_plan_auftrag_ag is
      select *
        from pps_plan_auftrag_ag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.plan_auf_id = v_bde_fa_plan_crt.arb_plan_id
         and t.plan_auf_ag_id = v_bde_fa_plan_crt.arb_plan_pos_id;

    CURSOR c_bde_fa_plan is
      select p.sid,
             p.firma_nr,
             p.plan_auf_id,
             ap.arb_plan_name,
             ap.text1,
             ap.text2,
             ap.text3,
             ap.soll_betriebsart,
             p.fa_gruppe,
             pag.plan_auf_ag_id,
             pag.pos_nr,
             pag.ag_upos,
             pag.satzart,
             pag.ag_name1,
             pag.ag_name2,
             pag.ag_text1,
             pag.ag_text2,
             pag.ag_text3,
             pag.soll_menge,
             'ABS',
             pag.res_id,
             pag.nio_res_id,
             pag.prod_params,
             pag.quitt_gruppe_ag,
             pag.soll_zeit_ruest,
             pag.soll_zeit_p_einh,
             pag.soll_zeit_stoer,
             nvl(pag.termin_start_gepl, p.termin_soll_start),
             nvl(pag.termin_ende_gepl, p.termin_ende),
             pags.prod_reihenfolge,
             pags.prod_menge_p_einheit,
             pags.prod_menge_p_einheit_op,
             pags.prod_menge_ix,
             s.plan_auf_id,
             pag.ag_name1,
             pag.ag_text1,
             pag.ag_text2,
             pag.ag_text3,
             s.plan_auf_stl_id,
             s.pos_nr,
             s.artikel_id,
             s.zeichnung,
             s.zeichnung_index,
             s.prod_params,
             s.menge,
             'ABS',
             pag.vorgangsqualifikation,
             NULL
        from pps_plan_auftrag        p,
             pps_plan_auftrag_ag     pag,
             pps_plan_auftrag_ag_stl pags,
             pps_plan_auftrag_stl    s,
             pps_arb_plan            ap
       where p.sid = in_sid
         and p.firma_nr = in_firma_nr
         and p.plan_auf_id = in_plan_auf_id
         and p.sid = ap.sid(+)
         and p.firma_nr = ap.firma_nr(+)
         and p.arb_plan_id = ap.arb_plan_id(+)
         and p.sid = pag.sid
         and p.firma_nr = pag.firma_nr
         and p.plan_auf_id = pag.plan_auf_id
         and pag.sid = pags.sid(+)
         and pag.firma_nr = pags.firma_nr(+)
         and pag.plan_auf_ag_id = pags.plan_auf_ag_id(+)
         and pags.sid = s.sid(+)
         and pags.firma_nr = s.firma_nr(+)
         and pags.plan_auf_stl_id = s.plan_auf_stl_id(+)
       order by pag.plan_auf_id,
                pag.vorgang,
                pag.pos_nr,
                pag.ag_upos,
                pags.prod_reihenfolge,
                s.plan_auf_stl_id,
                pags.prod_menge_ix;

    CURSOR c_stl_pos_fuer_ma_in_ag is
      select t2.*
        from pps_plan_auftrag_ag_stl t, pps_plan_auftrag_stl t2
       where v_bde_fa_plan.sid = t.sid
         and v_bde_fa_plan.firma_nr = t.firma_nr
         and v_bde_fa_plan.arb_plan_pos_id = t.plan_auf_ag_id
         and v_bde_fa_plan.stueckliste_pos_id = t.plan_auf_stl_id
         and t2.sid = t.sid
         and t2.firma_nr = t.firma_nr
         and t2.plan_auf_stl_id = t.plan_auf_stl_id
         and t.plan_auf_ag_id not in
             (select t.plan_auf_ag_id
                from pps_plan_auftrag_ag_stl t3
               where t.sid = t3.sid
                 and t.firma_nr = t3.firma_nr
                 and t.plan_auf_ag_id > t3.plan_auf_ag_id
                 and t.plan_auf_stl_id = t3.plan_auf_stl_id);

    CURSOR c_bde_begonnen is
      select count(t.freig_status)
        from bde_fa_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.leitzahl = in_plan_auf_id
         and t.freig_status != 'N';

  begin
    v_mit_quitt_gruppe := False;
    -- Lesen der Schrrittweite der Arbeitsgaenge
    v_ag_schrittweite := isi_allg.c_get_firma_cfg_param(in_sid,
                                                        in_firma_nr,
                                                        'BDE_FA', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                        NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                        'BDE_FA_AG_SCHRITTWEITE', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                        'BDE', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                                        '10', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'INTEGER'); -- in_default_param_typ

    -- Lesen des Maxwert der Arbeitsgaenge
    v_ag_max := isi_allg.c_get_firma_cfg_param(in_sid,
                                               in_firma_nr,
                                               'BDE_FA', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                               NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                               'BDE_FA_AG_MAX', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'BDE', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                               '1000', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'INTEGER'); -- in_default_param_typ

    -- Alte Variante
    -- Pruefen ob der Auftrag breits begonnen ist
    /*OPEN c_bde_begonnen;
    FETCH c_bde_begonnen
      into v_anz_bde_beg;
    CLOSE c_bde_begonnen;

    if v_anz_bde_beg > 0 then
      raise_isi_error(5,
                      lc.ec_p2(lc.O_TP2_ARB_PPS_AG_BDE_BEG,
                               in_plan_auf_id,
                               v_anz_bde_beg));
    end if;*/
    if not check_bde_fa_for_delete(in_sid, in_firma_nr, in_plan_auf_id, v_anz_bde_beg) then
      raise_isi_error(5,
                      lc.ec_p2(lc.O_TP2_ARB_PPS_AG_BDE_BEG,
                               in_plan_auf_id,
                               v_anz_bde_beg));
    end if;
    -- Loeschen derBDE-Daten fuer diesen FA_Auftrag
    delete bde_fa_kopf t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.fa_nr = in_plan_auf_id;
    -- Einbau der Tabelle wenn eine FA erstellt wurde
    delete bde_fa_auftrag_rel t
     where t.leitzahl = in_plan_auf_id;

    OPEN c_pps_plan_auftrag;
    FETCH c_pps_plan_auftrag
      into v_pps_plan_auftrag;
    v_found := c_pps_plan_auftrag%FOUND;
    CLOSE c_pps_plan_auftrag;

    if not v_found then
      raise_isi_error(10,
                      lc.ec_p1(lc.O_TP1_ARB_PPS_AUF_FEHLT, in_plan_auf_id));
    end if;

    update pps_plan_auftrag t
       set t.status = 'UBDE'
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.plan_auf_id = in_plan_auf_id;

    -- Lesen der Artikeldaten
    OPEN c_artikel;
    FETCH c_artikel
      into v_artikel;
    v_found := c_artikel%found;
    CLOSE c_artikel;

    if not v_found then
      raise_isi_error(20,
                      lc.ec_p1(lc.O_TP1_ARTIKEL_ID_FEHLT,
                               v_pps_plan_auftrag.artikel_id));
    end if;

    v_artikel_kd := NULL;
    OPEN c_artikel_kd;
    FETCH c_artikel_kd
      into v_artikel_kd;
    CLOSE c_artikel_kd;

    -- Erst mal den Kopfsatz schreiben
    insert into bde_fa_kopf
    values
      (in_sid, -- SID                     VARCHAR2(2) not null,
       in_firma_nr, -- FIRMA_NR                NUMBER(2) not null,  PLAN_AUF_AG_ID   NUMBER not null,
       v_pps_plan_auftrag.plan_auf_id, -- PLAN_AUF_ID      NUMBER not null,
       v_pps_plan_auftrag.plan_auf_id_ext, -- PLAN_AUF_ID_EXT   NUMBER,
       v_pps_plan_auftrag.artikel_id, -- ARTIKEL_ID        INTEGER not null,
       v_pps_plan_auftrag.zeichnung, -- ZEICHNUNG         VARCHAR2(255),
       v_pps_plan_auftrag.zeichnung_index, -- ZEICHNUNG_INDEX   VARCHAR2(10),
       v_pps_plan_auftrag.menge, -- MENGE             INTEGER not null,
       'N', -- STATUS            VARCHAR2(10) default 'N' not null,
       sysdate, -- ERZ_DATUM         DATE not null,
       in_login_id, -- ERZ_LOGIN_ID      NUMBER,
       NULL, -- AEND_DATUM        DATE,
       NULL, -- AEND_LOGIN_ID     NUMBER,
       nvl(v_pps_plan_auftrag.erzeuger, 'ISI'), -- ERZEUGER          VARCHAR2(10) default 'ISI' not null,
       v_pps_plan_auftrag.prod_params, -- PROD_PARAMS       VARCHAR2(4000),
       v_pps_plan_auftrag.kunden_nr, -- KUNDEN_NR         VARCHAR2(20),
       v_pps_plan_auftrag.kd_art_nr, -- KD_ART_NR         VARCHAR2(30),
       v_pps_plan_auftrag.kd_best_nr, -- KD_BEST_NR        VARCHAR2(30),
       v_pps_plan_auftrag.kd_best_pos, -- KD_BEST_POS       VARCHAR2(5),
       v_pps_plan_auftrag.kd_best_text1, -- KD_BEST_TEXT1     VARCHAR2(255),
       v_pps_plan_auftrag.kd_best_text2, -- KD_BEST_TEXT2     VARCHAR2(255),
       v_pps_plan_auftrag.kd_best_text3, -- KD_BEST_TEXT3     VARCHAR2(255),
       v_pps_plan_auftrag.termin_ende, -- TERMIN_ENDE       DATE,
       v_pps_plan_auftrag.termin_soll_start, -- TERMIN_SOLL_START DATE,
       v_pps_plan_auftrag.arb_plan_id, -- ARB_PLAN_ID       NUMBER,
       v_pps_plan_auftrag.unique_hash, -- UNIQUE_HASH       VARCHAR2(200)
       v_pps_plan_auftrag.soll_betriebsart, -- SOLL_BETRIEBSART  VARCHAR2(10)
       v_pps_plan_auftrag.serie_id, -- SERIE_ID          NUMBER,
       v_pps_plan_auftrag.serie_auto_inc, -- SERIE_AUTO_INC    VARCHAR2(1) default 'F'
       v_pps_plan_auftrag.fa_gruppe, -- FA_GRUPPE         NUMBER
       NULL, -- in_lam_sel1,      in_lam_sel1         in lvs_lam.LAM_SEL1%type,
       NULL, -- in_lam_sel2,      in lvs_lam.LAM_SEL2%type,
       NULL, -- in_lam_sel3,      in lvs_lam.LAM_SEL3%type,
       NULL, -- in_lam_sel4,      in lvs_lam.LAM_SEL4%type,
       NULL, -- in_lam_sel5,      in lvs_lam.LAM_SEL5%type,
       NULL, -- in_lam_sel6,      in lvs_lam.LAM_SEL6%type,
       NULL, -- in_lam_sel7,      in lvs_lam.LAM_SEL7%type,
       NULL, -- in_lam_sel8,      in lvs_lam.LAM_SEL8%type,
       NULL, -- in_lam_sel9,      in lvs_lam.LAM_SEL9%type,
       NULL, -- in_lam_sel10);    in lvs_lam.LAM_SEL10%type,
       'F', -- Lohn-Arbeit
       NULL); -- Adress_ID

    -- Initialisierung der STL-Ref Tabelle
    v_fa_ag      := 0;
    v_stl_tab_ix := 0;
    v_stl_tab    := v_stl_tab_empty;

    -- Mit dem CURSOR c_bde_fa_plan werden die Daten so zusammengestellt, dass die max.
    -- Auspraegung der Kombinationen aus 'V'errichetn und 'MA'terialanforderung entsteht.
    -- Der Letzte Satz, der in der Stückliste den gleichen Arbeitsgang beschreibt, wird zur
    -- Erzeugung des 'V'erichten Satz benutzt. Hierfür wird der aktuelle Satz immer in die
    -- Recordstruktur v_bde_fa_plan_crt kopiert, die dann für die Erzeugung genutzt wird.
    OPEN c_bde_fa_plan;
    FETCH c_bde_fa_plan
      into v_bde_fa_plan;
    v_found := c_bde_fa_plan%FOUND;
    if not v_found then
      CLOSE c_bde_fa_plan;
      raise_isi_error(30,
                      lc.ec_p1(lc.O_TP1_ARB_PPS_AG_FEHLT, in_plan_auf_id));
    end if;

    -- Ab jetzt alle Eintraege der c_bde_fa_plan abarbeiten
    LOOP
      EXIT when c_bde_fa_plan%notfound;

      -- Der der neue Eintrag ist für einen neuen 'V'errichten Eintrag,
      -- dann den letzten schreiben
      if v_bde_fa_plan_crt.arb_plan_pos_id != v_bde_fa_plan.arb_plan_pos_id then
        v_fa_ag := v_fa_ag + v_ag_schrittweite;

        OPEN c_pps_plan_auftrag_ag;
        FETCH c_pps_plan_auftrag_ag
          into v_pps_plan_auftrag_ag;
        CLOSE c_pps_plan_auftrag_ag;

        -- Übertragen der Artikeldaten für LTE-Name etc. aus Artikel oder KD-Artikel
        if v_artikel_kd.lte_name is not NULL then
          if nvl(v_artikel_kd.lte_menge, 0) = 0 then
            v_lte_anz := 1;
          else
            v_lte_anz := round(v_pps_plan_auftrag.menge /
                               v_artikel_kd.lte_menge,
                               0);
          end if;
        else
          if nvl(v_artikel.lte_menge, 0) = 0 then
            v_lte_anz := 1;
          else
            v_lte_anz := round(v_pps_plan_auftrag.menge /
                               v_artikel.lte_menge,
                               0);
          end if;
        end if;
        -- Übertragen der Artikeldaten für LHM-Name etc. aus Artikel oder KD-Artikel
        if v_artikel_kd.lhm_name is not NULL then
          if nvl(v_artikel_kd.lhm_menge, 0) = 0 then
            v_lhm_anz := 1;
          else
            v_lhm_anz := round(v_pps_plan_auftrag.menge /
                               v_artikel_kd.lhm_menge,
                               0);
          end if;
        else
          if nvl(v_artikel.lhm_menge, 0) = 0 then
            v_lhm_anz := 1;
          else
            v_lhm_anz := round(v_pps_plan_auftrag.menge /
                               v_artikel.lhm_menge,
                               0);
          end if;
        end if;

        v_mit_quitt_gruppe := v_mit_quitt_gruppe or
                              (v_bde_fa_plan_crt.quitt_gruppe_ag is not NULL);

        create_bde_fa_auftrag(v_bde_fa_plan_crt.satzartz,
                              -- in_ag_satzart      in bde_fa_auftrag.satzart%type,
                              0, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                              v_pps_plan_auftrag.artikel_id,
                              -- in_artikel_id      in isi_artikel.artikel_id%type,
                              v_pps_plan_auftrag.zeichnung,
                              --  in_zeichnung       in isi_artikel.zeichnung%type,
                              v_pps_plan_auftrag.zeichnung_index,
                              -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                              to_char(v_pps_plan_auftrag_ag.plan_auf_id) || '/' ||
                              to_char(v_fa_ag),
                              -- in_charge_bez      in lvs_charge.charge_bez%type,
                              null, -- in_login_id        in isi_user.login_id%type,
                              v_pps_plan_auftrag.menge,
                              -- in_menge           in lvs_lam.menge%type,
                              v_pps_plan_auftrag.kunden_nr,
                              -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                              v_pps_plan_auftrag.kd_art_nr,
                              -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                              'F', -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                              nvl(v_artikel_kd.lte_name, v_artikel.lte_name),
                              -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                              v_artikel.lte_menge, -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                              v_lte_anz, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                              v_artikel.lhm_name, -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                              v_artikel.lhm_menge, -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                              v_lhm_anz, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                              v_pps_plan_auftrag.kd_best_nr,
                              -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                              v_pps_plan_auftrag.plan_auf_id_ext,
                              -- in_abnr            in bde_fa_auftrag.abnr%type,
                              v_pps_plan_auftrag.plan_auf_id,
                              -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                              v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                              v_artikel.abfuell_abschalt_grob,
                              -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                              v_artikel.abfuell_abschalt_mittel,
                              -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                              v_artikel.abfuell_abschalt_fein,
                              -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                              v_artikel.abfuell_toleranz_plus,
                              -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                              v_artikel.abfuell_toleranz_minus,
                              -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                              v_artikel.abfuell_soll,
                              -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                              v_bde_fa_plan_crt); -- in_bde_fa_plan     in t_bde_fa_plan)

        v_stl_tab_i := 0;
        -- Alle Referenzen in der v_stl_tab, die noch keine FA haben, müssen auf den letzen
        -- AG verweisen (Beim schreiben der Stückliste noch nicht bekannt)
        LOOP
          -- Leitzahl und Arbeitsgang eintragen (BDE_FA_AUFTRAG_STL Tabelle wird am ende geschrieben)
          v_stl_tab_i := v_stl_tab_i + 1;
          EXIT WHEN v_stl_tab_i > v_stl_tab_ix;
          if v_stl_tab(v_stl_tab_i).leitzahl is NULL then
            v_stl_tab(v_stl_tab_i).leitzahl := v_pps_plan_auftrag.plan_auf_id;
            v_stl_tab(v_stl_tab_i).fa_ag := v_fa_ag;
            v_bde_fa_plan_crt.ag_upos := v_bde_fa_plan_crt.ag_upos;
          end if;
        end LOOP;
      end if;

      v_bde_fa_plan_crt := v_bde_fa_plan;
      if v_bde_fa_plan.stueckliste_id is not NULL then
        -- Suchen, ob diese STL-Referenz auch eine 'MA'terialanforderung ist
        v_pps_plan_auftrag_stl.plan_auf_stl_id := NULL;
        OPEN c_stl_pos_fuer_ma_in_ag;
        FETCH c_stl_pos_fuer_ma_in_ag
          into v_pps_plan_auftrag_stl;
        CLOSE c_stl_pos_fuer_ma_in_ag;
        -- Diese STL-Referenz ist auch eine 'MA'terialanforderung (Kleinser AG für die Ref)
        if v_pps_plan_auftrag_stl.plan_auf_stl_id =
           v_bde_fa_plan.stueckliste_pos_id then
          if v_bde_fa_plan.prod_menge_ix = 1 then
            v_fa_ag := v_fa_ag + v_ag_schrittweite;
            create_bde_fa_auftrag('MA', -- in_ag_satzart      in bde_fa_auftrag.satzart%type,
                                  0, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                                  v_bde_fa_plan.artikel_id,
                                  -- in_artikel_id      in isi_artikel.artikel_id%type,
                                  v_bde_fa_plan.zeichnung,
                                  --  in_zeichnung       in isi_artikel.zeichnung%type,
                                  v_bde_fa_plan.zeichnung_index,
                                  -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                                  to_char(v_pps_plan_auftrag_ag.plan_auf_id) || '/' ||
                                  to_char(v_fa_ag),
                                  -- in_charge_bez      in lvs_charge.charge_bez%type,
                                  NULL, -- in_login_id        in isi_user.login_id%type,
                                  v_pps_plan_auftrag_stl.menge,
                                  -- in_menge           in lvs_lam.menge%type,
                                  NULL, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                                  NULL, -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                                  'F', -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                                  nvl(v_artikel_kd.lte_name,
                                      v_artikel.lte_name),
                                  -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                                  nvl(v_artikel_kd.lte_menge,
                                      v_artikel.lte_menge),
                                  -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                                  v_lte_anz, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                                  nvl(v_artikel.lhm_name,
                                      v_artikel_kd.lhm_name),
                                  -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                                  nvl(v_artikel.lhm_menge,
                                      v_artikel_kd.lhm_menge),
                                  -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                                  v_lhm_anz, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                                  v_pps_plan_auftrag.kd_best_nr,
                                  -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                                  v_pps_plan_auftrag.plan_auf_id_ext,
                                  -- in_abnr            in bde_fa_auftrag.abnr%type,
                                  v_pps_plan_auftrag.plan_auf_id,
                                  -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                                  v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                                  v_artikel.abfuell_abschalt_grob,
                                  -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                  v_artikel.abfuell_abschalt_mittel,
                                  -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                  v_artikel.abfuell_abschalt_fein,
                                  -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                  v_artikel.abfuell_toleranz_plus,
                                  -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                  v_artikel.abfuell_toleranz_minus,
                                  -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                  v_artikel.abfuell_soll,
                                  -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                                  v_bde_fa_plan); -- in_bde_fa_plan     in t_bde_fa_plan)
          end if;
          v_fa_ag_stl := v_fa_ag;
        else
          v_stl_tab_i := 0;
          LOOP
            v_stl_tab_i := v_stl_tab_i + 1;
            EXIT WHEN v_stl_tab_i > v_stl_tab_ix or v_stl_tab(v_stl_tab_i).stueckliste_pos_id = v_bde_fa_plan.stueckliste_pos_id;
          end LOOP;
          if v_stl_tab(v_stl_tab_i)
           .stueckliste_pos_id = v_bde_fa_plan.stueckliste_pos_id then
            v_fa_ag_stl := v_stl_tab(v_stl_tab_i).ma_fa_ag;
          else
            v_fa_ag_stl := NULL;
          end if;
        end if;

        -- Naechsten Eintrag in der STL-Ref Tabelle
        v_stl_tab_ix := v_stl_tab_ix + 1;
        v_stl_tab(v_stl_tab_ix).sid := v_bde_fa_plan.sid;
        v_stl_tab(v_stl_tab_ix).firma_nr := v_bde_fa_plan.firma_nr;
        v_stl_tab(v_stl_tab_ix).ma_fa_ag := v_fa_ag_stl;
        v_stl_tab(v_stl_tab_ix).ma_fa_upos := v_bde_fa_plan.ag_upos;
        v_stl_tab(v_stl_tab_ix).stueckliste_pos_id := v_bde_fa_plan.stueckliste_pos_id;
        v_stl_tab(v_stl_tab_ix).stueckliste_pos_nr := v_bde_fa_plan.stueckliste_pos_nr;
        v_stl_tab(v_stl_tab_ix).prod_reihenfolge := v_bde_fa_plan.prod_reihenfolge;
        v_stl_tab(v_stl_tab_ix).prod_menge_p_einheit := v_bde_fa_plan.prod_menge_p_einheit;
        v_stl_tab(v_stl_tab_ix).prod_menge_p_einheit_op := v_bde_fa_plan.prod_menge_p_einheit_op;
        v_stl_tab(v_stl_tab_ix).prod_menge_ix := v_bde_fa_plan.prod_menge_ix;
      end if;
      FETCH c_bde_fa_plan
        into v_bde_fa_plan;
    end LOOP;
    CLOSE c_bde_fa_plan;

    -- Nach der Abarbeitung der Tabelle muessen noch die Relation AG - STL erstellt werden
    -- und der Letzte 'V'errichtensatz ist noch nicht geschrieben
    v_fa_ag     := v_fa_ag + v_ag_schrittweite;
    v_stl_tab_i := 0;
    LOOP
      -- Relation AG - STL werden erstellt
      v_stl_tab_i := v_stl_tab_i + 1;
      EXIT WHEN v_stl_tab_i > v_stl_tab_ix;
      if v_stl_tab(v_stl_tab_i).leitzahl is NULL -- Letzen AG noch nachtragen
       then
        v_stl_tab(v_stl_tab_i).leitzahl := v_pps_plan_auftrag.plan_auf_id;
        v_stl_tab(v_stl_tab_i).fa_ag := v_fa_ag;
        v_bde_fa_plan_crt.ag_upos := v_bde_fa_plan_crt.ag_upos;
      end if;
      INSERT into bde_fa_auftrag_stl
      values
        (v_stl_tab                (v_stl_tab_i).sid,
         v_stl_tab                (v_stl_tab_i).firma_nr,
         NULL, -- FA_AG_STL_ID
         v_stl_tab                (v_stl_tab_i).leitzahl,
         v_stl_tab                (v_stl_tab_i).fa_ag,
         v_bde_fa_plan_crt.ag_upos,
         v_stl_tab                (v_stl_tab_i).ma_fa_ag,
         v_stl_tab                (v_stl_tab_i).ma_fa_upos,
         v_stl_tab                (v_stl_tab_i).stueckliste_pos_id,
         v_stl_tab                (v_stl_tab_i).stueckliste_pos_nr,
         v_stl_tab                (v_stl_tab_i).prod_reihenfolge,
         v_stl_tab                (v_stl_tab_i).prod_menge_p_einheit,
         v_stl_tab                (v_stl_tab_i).prod_menge_p_einheit_op,
         v_stl_tab                (v_stl_tab_i).prod_menge_ix,
         NULL);
    end LOOP;

    -- Loeschen der Ref-Tabelle
    v_stl_tab_ix := 0;
    v_stl_tab    := v_stl_tab_empty;

    -- Der Letzte 'V'errichtensatz wird geschrieben
    OPEN c_pps_plan_auftrag_ag;
    FETCH c_pps_plan_auftrag_ag
      into v_pps_plan_auftrag_ag;
    CLOSE c_pps_plan_auftrag_ag;

    v_mit_quitt_gruppe := v_mit_quitt_gruppe or
                          (v_bde_fa_plan_crt.quitt_gruppe_ag is not NULL);

    create_bde_fa_auftrag(v_bde_fa_plan_crt.satzartz,
                          -- in_ag_satzart      in bde_fa_auftrag.satzart%type,
                          1, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                          v_pps_plan_auftrag.artikel_id,
                          -- in_artikel_id      in isi_artikel.artikel_id%type,
                          v_pps_plan_auftrag.zeichnung,
                          --  in_zeichnung       in isi_artikel.zeichnung%type,
                          v_pps_plan_auftrag.zeichnung_index,
                          -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                          to_char(v_pps_plan_auftrag_ag.plan_auf_id) || '/' ||
                          to_char(v_fa_ag),
                          -- in_charge_bez      in lvs_charge.charge_bez%type,
                          null, -- in_login_id        in isi_user.login_id%type,
                          v_pps_plan_auftrag.menge,
                          -- in_menge           in lvs_lam.menge%type,
                          v_pps_plan_auftrag.kunden_nr,
                          -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                          v_pps_plan_auftrag.kd_art_nr,
                          -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                          'F', -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                          nvl(v_artikel_kd.lte_name, v_artikel.lte_name),
                          -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                          v_artikel.lte_menge, -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                          v_lte_anz, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                          v_artikel.lhm_name, -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                          v_artikel.lhm_menge, -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                          v_lhm_anz, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                          v_pps_plan_auftrag.kd_best_nr,
                          -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                          v_pps_plan_auftrag.plan_auf_id_ext,
                          -- in_abnr            in bde_fa_auftrag.abnr%type,
                          v_pps_plan_auftrag.plan_auf_id,
                          -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                          v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                          v_artikel.abfuell_abschalt_grob,
                          -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                          v_artikel.abfuell_abschalt_mittel,
                          -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                          v_artikel.abfuell_abschalt_fein,
                          -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                          v_artikel.abfuell_toleranz_plus,
                          -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                          v_artikel.abfuell_toleranz_minus,
                          -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                          v_artikel.abfuell_soll,
                          -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                          v_bde_fa_plan_crt); -- in_bde_fa_plan     in t_bde_fa_plan)

    if v_mit_quitt_gruppe then
      OPEN c_bde_fa_quitt_grp;
      LOOP
        FETCH c_bde_fa_quitt_grp
          into v_fa_ag_quitt_gruppe, v_quitt_gruppe;
        EXIT when c_bde_fa_quitt_grp%NOTFOUND;
        update bde_fa_auftrag t
           set t.quitt_gruppe_ag = v_fa_ag_quitt_gruppe
         where t.sid = in_sid
           and t.firma_nr = in_firma_nr
           and t.leitzahl = in_plan_auf_id
           and t.quitt_gruppe_ag = v_quitt_gruppe;
      end LOOP;
      CLOSE c_bde_fa_quitt_grp;
    end if;
    -- Einbau der Tabelle wenn eine FA erstellt wurde
    insert into bde_fa_auftrag_rel
      select *
        from bde_v_gen_bde_fa_auftrag_rel t
       where t.leitzahl = in_plan_auf_id;
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then
      -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text || CHR(13) || CHR(10) ||
                    DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        rollback;
        v_err_text := v_err_text || CHR(13) || CHR(10) ||
                      DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%' then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) ||
                        DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  ---------------------------------------------------------------------------------------
  -- procedure c_create_pps_auftrag_a_plan
  -- Erzeugt Eintraege in der PPS_PLAN_AUFTRAG auf der Grundlage der PPS_ARB_PLAN Daten.
  -- Mit dem CURSOR c_bde_fa_plan werden die Daten so zusammengestellt, dass die max.
  -- Auspraegung der Kombinationen aus 'V'errichetn und 'MA'terialanforderung entsteht.
  -- Der Letzte Satz, der in der Stückliste den gleichen Arbeitsgang beschreibt, wird zur
  -- Erzeugung des 'V'erichten Satz benutzt. Hierfür wird der aktuelle Satz immer in die
  -- Recordstruktur v_bde_fa_plan_crt kopiert, die dann für die Erzeugung genutzt wird.
  --
  -- ACHTUNG: Wenn eine Leitzahl übergeben wird, dann wird dieser Auftrag in der
  --          BDE_FA_AUFTRAG Tabelle gelöscht
  ---------------------------------------------------------------------------------------
  procedure c_create_pps_auftrag_a_plan(in_sid              in isi_sid.sid%type,
                                        in_firma_nr         in isi_firma.firma_nr%type,
                                        in_artikel_id       in isi_artikel.artikel_id%type,
                                        in_charge_bez       in lvs_charge.charge_bez%type,
                                        in_res_id           in isi_resource.res_id%type,
                                        in_login_id         in isi_user.login_id%type,
                                        in_menge            in lvs_lam.menge%type,
                                        in_ab_text1         in bde_fa_auftrag.ab_text1%type,
                                        in_ab_text2         in bde_fa_auftrag.ab_text2%type,
                                        in_ab_text3         in bde_fa_auftrag.ab_text3%type,
                                        in_soll_betriebsart in bde_fa_kopf.soll_betriebsart%type,
                                        in_kunden_nr        in bde_fa_auftrag.kunden_nr%type,
                                        in_kd_art_nr        in bde_fa_auftrag.kd_art_nr%type,
                                        in_ag_name1         in bde_fa_auftrag.ag_bez1%type,
                                        in_ag_name2         in bde_fa_auftrag.ag_bez2%type,
                                        in_ag_text1         in bde_fa_auftrag.ag_text1%type,
                                        in_ag_text2         in bde_fa_auftrag.ag_text2%type,
                                        in_ag_text3         in bde_fa_auftrag.ag_text3%type,
                                        in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck%type,
                                        in_anz_lte          in bde_fa_auftrag.lte_anz%type,
                                        in_anz_lhm          in bde_fa_auftrag.lhm_anz%type,
                                        in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde%type,
                                        in_abnr             in bde_fa_auftrag.abnr%type,
                                        in_serie_id         in bde_fa_kopf.serie_id%type,
                                        in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc%type,
                                        in_fa_gruppe        in bde_fa_kopf.fa_gruppe%type,
                                        in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type) is
  begin
    create_pps_auftrag_a_plan(in_sid, -- in isi_sid.sid%type,
                              in_firma_nr, -- in isi_firma.firma_nr%type,
                              in_artikel_id, -- in isi_artikel.artikel_id%type,
                              in_charge_bez, -- in lvs_charge.charge_bez%type,
                              in_res_id, -- in isi_resource.res_id%type,
                              in_login_id, -- in isi_user.login_id%type,
                              in_menge, -- in lvs_lam.menge%type,
                              in_ab_text1, -- in bde_fa_auftrag.ab_text1%type,
                              in_ab_text2, -- in bde_fa_auftrag.ab_text2%type,
                              in_ab_text3, -- in bde_fa_auftrag.ab_text3%type,
                              in_soll_betriebsart, -- in bde_fa_kopf.soll_betriebsart%type,
                              in_kunden_nr, -- in bde_fa_auftrag.kunden_nr%type,
                              in_kd_art_nr, -- in bde_fa_auftrag.kd_art_nr%type,
                              in_ag_name1, -- in bde_fa_auftrag.ag_bez1%type,
                              in_ag_name2, -- in bde_fa_auftrag.ag_bez2%type,
                              in_ag_text1, -- in bde_fa_auftrag.ag_text1%type,
                              in_ag_text2, -- in bde_fa_auftrag.ag_text2%type,
                              in_ag_text3, -- in bde_fa_auftrag.ag_text3%type,
                              in_kenz_lhm_druck, -- in bde_fa_auftrag.kenz_lhm_druck%type,
                              in_anz_lte, -- in bde_fa_auftrag.lte_anz%type,
                              in_anz_lhm, -- in bde_fa_auftrag.lhm_anz%type,
                              in_bestnr_kd, -- in bde_fa_auftrag.best_nr_kunde%type,
                              in_abnr, -- in bde_fa_auftrag.abnr%type,
                              in_serie_id, -- in bde_fa_kopf.serie_id%type,
                              in_serie_auto_inc, -- in bde_fa_kopf.serie_auto_inc%type,
                              in_fa_gruppe, -- in bde_fa_kopf.fa_gruppe%type,
                              in_out_leitzahl); -- in out bde_fa_auftrag.leitzahl%type);
    commit;
  end;

  procedure create_pps_auftrag_a_plan(in_sid              in isi_sid.sid%type,
                                      in_firma_nr         in isi_firma.firma_nr%type,
                                      in_artikel_id       in isi_artikel.artikel_id%type,
                                      in_charge_bez       in lvs_charge.charge_bez%type,
                                      in_res_id           in isi_resource.res_id%type,
                                      in_login_id         in isi_user.login_id%type,
                                      in_menge            in lvs_lam.menge%type,
                                      in_ab_text1         in bde_fa_auftrag.ab_text1%type,
                                      in_ab_text2         in bde_fa_auftrag.ab_text2%type,
                                      in_ab_text3         in bde_fa_auftrag.ab_text3%type,
                                      in_soll_betriebsart in bde_fa_kopf.soll_betriebsart%type,
                                      in_kunden_nr        in bde_fa_auftrag.kunden_nr%type,
                                      in_kd_art_nr        in bde_fa_auftrag.kd_art_nr%type,
                                      in_ag_name1         in bde_fa_auftrag.ag_bez1%type,
                                      in_ag_name2         in bde_fa_auftrag.ag_bez2%type,
                                      in_ag_text1         in bde_fa_auftrag.ag_text1%type,
                                      in_ag_text2         in bde_fa_auftrag.ag_text2%type,
                                      in_ag_text3         in bde_fa_auftrag.ag_text3%type,
                                      in_kenz_lhm_druck   in bde_fa_auftrag.kenz_lhm_druck%type,
                                      in_anz_lte          in bde_fa_auftrag.lte_anz%type,
                                      in_anz_lhm          in bde_fa_auftrag.lhm_anz%type,
                                      in_bestnr_kd        in bde_fa_auftrag.best_nr_kunde%type,
                                      in_abnr             in bde_fa_auftrag.abnr%type,
                                      in_serie_id         in bde_fa_kopf.serie_id%type,
                                      in_serie_auto_inc   in bde_fa_kopf.serie_auto_inc%type,
                                      in_fa_gruppe        in bde_fa_kopf.fa_gruppe%type,
                                      in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type) is

    v_found boolean;

    v_bde_fa_plan          t_bde_fa_plan;
    v_bde_fa_plan_crt      t_bde_fa_plan;
    v_artikel              isi_artikel%rowtype;
    v_artikel_kd           isi_artikel_kunde%rowtype;
    v_artikel_arb_plan     pps_artikel_arb_plan%rowtype;
    v_artikel_grp_arb_plan pps_artikel_grp_arb_plan%rowtype;

    v_arb_plan_id        pps_arb_plan.arb_plan_id%type;
    v_ag_schrittweite    number;
    v_fa_ag              number;
    v_menge              number;
    v_ag_menge           number;
    v_stueckliste_pos_id number;

    v_status_loeschbar isi_firma_cfg.parameter_wert%type;

    CURSOR c_artikel is
      select *
        from isi_artikel t
       where t.sid = in_sid
         and t.artikel_id = in_artikel_id;

    CURSOR c_artikel_kd is
      select *
        from isi_artikel_kunde t
       where t.sid = in_sid
         and t.artikel_id = in_artikel_id
         and t.kunden_nr = in_kunden_nr
         and t.kd_art_nr = nvl(in_kd_art_nr, t.kd_art_nr);

    CURSOR c_artikel_arb_plan is
      select *
        from pps_artikel_arb_plan t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.artikel_id = in_artikel_id;

    CURSOR c_artikel_grp_arb_plan is
      select *
        from pps_artikel_grp_arb_plan t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.art_gruppe_id = v_artikel.art_gruppe_id;

    CURSOR c_bde_fa_plan is
      select p.sid,
             p.firma_nr,
             p.arb_plan_id,
             p.arb_plan_name,
             nvl(in_ab_text1, p.text1),
             nvl(in_ab_text3, p.text2),
             nvl(in_ab_text2, p.text3),
             nvl(in_soll_betriebsart, p.soll_betriebsart),
             in_fa_gruppe,
             pag.arb_plan_pos_id,
             pag.pos_nr,
             pag.ag_upos,
             pag.satzart,
             nvl(in_ag_name1, pag.ag_name1),
             nvl(in_ag_name2, pag.ag_name2),
             nvl(in_ag_text1, pag.ag_text1),
             nvl(in_ag_text2, pag.ag_text2),
             nvl(in_ag_text3, pag.ag_text3),
             pag.plan_menge_faktor,
             pag.plan_menge_faktor_op,
             nvl(in_res_id, pag.res_id),
             pag.nio_res_id,
             nvl(pag.prod_params,
                 nvl(v_artikel_arb_plan.prod_params,
                     v_artikel_grp_arb_plan.prod_params)),
             pag.quitt_gruppe_ag,
             pag.soll_zeit_ruest,
             pag.soll_zeit_p_einh,
             pag.soll_zeit_stoer_p_std,
             NULL,
             NULL,
             pags.prod_reihenfolge,
             pags.prod_menge_p_einheit,
             pags.prod_menge_p_einheit_op,
             pags.prod_menge_ix,
             s.stueckliste_id,
             s.stueckliste_name,
             s.text1,
             s.text2,
             s.text3,
             sp.stueckliste_pos_id,
             sp.pos_nr,
             sp.artikel_id,
             sp.zeichnung,
             sp.zeichnung_index,
             sp.prod_params,
             sp.plan_menge_p_einheit,
             sp.plan_menge_p_einheit_op,
             pag.vorgangsqualifikation,
             NULL
        from pps_arb_plan        p,
             pps_arb_plan_ag     pag,
             pps_arb_plan_ag_stl pags,
             pps_stueckliste     s,
             pps_stueckliste_pos sp
       where p.arb_plan_id = v_arb_plan_id
         and p.sid = pag.sid
         and p.firma_nr = pag.firma_nr
         and p.arb_plan_id = pag.arb_plan_id
         and pag.sid = pags.sid(+)
         and pag.firma_nr = pags.firma_nr(+)
         and pag.arb_plan_pos_id = pags.arb_plan_pos_id(+)
         and pags.sid = sp.sid(+)
         and pags.firma_nr = sp.firma_nr(+)
         and pags.stueckliste_pos_id = sp.stueckliste_pos_id(+)
         and sp.sid = s.sid(+)
         and sp.firma_nr = s.firma_nr(+)
         and sp.stueckliste_id = s.stueckliste_id(+)
         and s.aktiv(+) = c.c_true
       order by pag.arb_plan_id,
                pag.vorgang,
                pag.pos_nr,
                pag.ag_upos,
                pags.prod_reihenfolge,
                s.stueckliste_id,
                pags.prod_menge_ix;

    CURSOR c_stl_pos_fuer_ma_in_ag is
      select t.stueckliste_pos_id
        from pps_arb_plan_ag_stl t, pps_arb_plan_ag t2
       where v_bde_fa_plan.sid = t2.sid
         and v_bde_fa_plan.firma_nr = t2.firma_nr
         and v_bde_fa_plan.arb_plan_id = t2.arb_plan_id
         and v_bde_fa_plan.arb_plan_pos_id = t.arb_plan_pos_id
         and v_bde_fa_plan.stueckliste_pos_id = t.stueckliste_pos_id
         and t2.sid = t.sid
         and t2.arb_plan_pos_id = t.arb_plan_pos_id
         and t.stueckliste_pos_id not in
             (select t3.stueckliste_pos_id
                from pps_arb_plan_ag_stl t3, pps_arb_plan_ag t4
               where t.sid = t4.sid
                 and t.firma_nr = t4.firma_nr
                 and t2.arb_plan_id = t4.arb_plan_id
                 and t.arb_plan_pos_id > t3.arb_plan_pos_id
                 and t2.sid = t.sid
                 and t3.arb_plan_pos_id = t4.arb_plan_pos_id);
    CURSOR c_auftrag_in_bde_begonnen is
      select t.status
        from pps_plan_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.plan_auf_id = in_out_leitzahl
         and v_status_loeschbar not like '%' || t.status || ';%';

    pragma autonomous_transaction;

  begin
    -- Lesen der Schrrittweite der Arbeitsgaenge
    v_ag_schrittweite := isi_allg.c_get_firma_cfg_param(in_sid,
                                                        in_firma_nr,
                                                        'BDE_FA', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                        NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                        'BDE_FA_AG_SCHRITTWEITE', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                        'BDE', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                        'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                                        '10', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                        'INTEGER'); -- in_default_param_typ

    -- Lesen des Maxwert der Arbeitsgaenge
    v_ag_max := isi_allg.c_get_firma_cfg_param(in_sid,
                                               in_firma_nr,
                                               'BDE_FA', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                               NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                               'BDE_FA_AG_MAX', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'BDE', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                               'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                               '1000', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                               'INTEGER'); -- in_default_param_typ

    v_status_loeschbar := isi_allg.c_get_firma_cfg_param(in_sid,
                                                         in_firma_nr,
                                                         'PPS_PLAN_AUFTRAG', -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                         NULL, -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                         'STATUS_LOESCHBAR', -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                         'PPS', -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                         'CFG', -- in_typ                   in isi_firma_cfg.typ%type,
                                                         'N;T;UBDE;', -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                         'STRING'); -- in_default_param_typ

    -- Prufen ob der Auftrag loeschbar ist
    OPEN c_auftrag_in_bde_begonnen;
    FETCH c_auftrag_in_bde_begonnen
      into v_status_loeschbar;
    v_found := c_auftrag_in_bde_begonnen%FOUND;
    CLOSE c_auftrag_in_bde_begonnen;

    if v_found then
      raise_isi_error(5,
                      lc.ec_p2(lc.O_TP2_ARB_PPS_AG_BDE_BEG,
                               in_out_leitzahl,
                               1));
    end if;

    -- Druch die Loeschung der Kopfsatz werden alle zugehoerigen Eintraege in den
    -- PPS-PLAN-Auftragstabellen geloescht
    delete pps_plan_auftrag t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.plan_auf_id = in_out_leitzahl;

    -- Lesen der Artikeldaten
    OPEN c_artikel;
    FETCH c_artikel
      into v_artikel;
    v_found := c_artikel%found;
    CLOSE c_artikel;

    if not v_found then
      raise_isi_error(10,
                      lc.ec_p1(lc.O_TP1_ARTIKEL_ID_FEHLT, in_artikel_id));
    end if;

    v_artikel_kd := NULL;
    OPEN c_artikel_kd;
    FETCH c_artikel_kd
      into v_artikel_kd;
    CLOSE c_artikel_kd;

    -- Initialisierung der Cursorergebnisse
    v_artikel_arb_plan     := NULL;
    v_artikel_grp_arb_plan := NULL;

    -- Lesen Arbeitsplan für den Artikel
    OPEN c_artikel_arb_plan;
    FETCH c_artikel_arb_plan
      into v_artikel_arb_plan;
    v_found := c_artikel_arb_plan%FOUND;
    CLOSE c_artikel_arb_plan;
    v_arb_plan_id := v_artikel_arb_plan.arb_plan_id;
    -- Kein Arbeitsplan für den Artikel gefunden, dann über die Artikelgruppe suchen
    if not v_found then
      OPEN c_artikel_grp_arb_plan;
      FETCH c_artikel_grp_arb_plan
        into v_artikel_grp_arb_plan;
      v_found := c_artikel_grp_arb_plan%FOUND;
      CLOSE c_artikel_grp_arb_plan;
      v_arb_plan_id := v_artikel_grp_arb_plan.arb_plan_id;
    end if;

    -- Kein Arbeitsplan für den Artikel oder Gruppe gefunden, dann Fehler
    if not v_found then
      raise_isi_error(20,
                      lc.ec_p1(lc.O_TP1_ARTIKEL_ARB_PLAN_FEHLT,
                               v_artikel.artikel));
    end if;

    -- Mit dem CURSOR c_bde_fa_plan werden die Daten so zusammengestellt, dass die max.
    -- Auspraegung der Kombinationen aus 'V'errichetn und 'MA'terialanforderung entsteht.
    -- Der Letzte Satz, der in der Stückliste den gleichen Arbeitsgang beschreibt, wird zur
    -- Erzeugung des 'V'erichten Satz benutzt. Hierfür wird der aktuelle Satz immer in die
    -- Recordstruktur v_bde_fa_plan_crt kopiert, die dann für die Erzeugung genutzt wird.
    OPEN c_bde_fa_plan;
    FETCH c_bde_fa_plan
      into v_bde_fa_plan;
    if c_bde_fa_plan%NOTFOUND
    -- Wenn hier nichts gefunden wurde, dann Fehler
     then
      CLOSE c_bde_fa_plan;
      raise_isi_error(20,
                      lc.ec_p1(lc.O_TP1_ARB_PLAN_POS_FEHLT,
                               v_artikel.artikel));
    end if;

    if in_out_leitzahl is NULL then
      select SEQ_BDE_FA_AUFTRAG_LEITZAHL.nextval
        into in_out_leitzahl
        from dual;
    end if;

    -- Erst mal den Kopfsatz schreiben
    insert into pps_plan_auftrag
    values
      (in_sid, -- SID                     VARCHAR2(2) not null,
       in_firma_nr, -- FIRMA_NR                NUMBER(2) not null,  PLAN_AUF_AG_ID   NUMBER not null,
       in_out_leitzahl, -- PLAN_AUF_ID      NUMBER not null,
       in_out_leitzahl, -- PLAN_AUF_ID_EXT   NUMBER,
       in_artikel_id, -- ARTIKEL_ID        INTEGER not null,
       v_artikel.zeichnung, -- ZEICHNUNG         VARCHAR2(255),
       v_artikel.zeichnung_index, -- ZEICHNUNG_INDEX   VARCHAR2(10),
       in_menge, -- MENGE             INTEGER not null,
       'N', -- STATUS            VARCHAR2(10) default 'N' not null,
       sysdate, -- ERZ_DATUM         DATE not null,
       in_login_id, -- ERZ_LOGIN_ID      NUMBER,
       NULL, -- AEND_DATUM        DATE,
       NULL, -- AEND_LOGIN_ID     NUMBER,
       'ISI', -- ERZEUGER          VARCHAR2(10) default 'ISI' not null,
       v_bde_fa_plan.prod_params, -- PROD_PARAMS       VARCHAR2(4000),
       in_kunden_nr, -- KUNDEN_NR         VARCHAR2(20),
       in_kd_art_nr, -- KD_ART_NR         VARCHAR2(30),
       in_bestnr_kd, -- KD_BEST_NR        VARCHAR2(30),
       NULL, -- KD_BEST_POS       VARCHAR2(5),
       NULL, -- KD_BEST_TEXT1     VARCHAR2(255),
       NULL, -- KD_BEST_TEXT2     VARCHAR2(255),
       NULL, -- KD_BEST_TEXT3     VARCHAR2(255),
       NULL, -- TERMIN_ENDE       DATE,
       NULL, -- TERMIN_SOLL_START DATE,
       v_arb_plan_id, -- ARB_PLAN_ID       NUMBER,
       NULL, -- UNIQUE_HASH       VARCHAR2(200)
       v_bde_fa_plan.arb_soll_betriebsart, -- SOLL_BETRIEBSART  VARCHAR2(10)
       in_serie_id, -- SERIE_ID          NUMBER,
       in_serie_auto_inc, -- SERIE_AUTO_INC    VARCHAR2(1) default 'F'
       in_fa_gruppe,      -- FA_GRUPPE         NUMBER
       sysdate,           -- Create Date
       '-1',              -- Create User ID
       null,              -- Change Date
       null               -- Change User ID
       );

    -- Initialisierung der STL-Ref Tabelle
    v_fa_ag          := 0;
    v_pps_stl_tab_ix := 0;
    v_pps_stl_tab    := v_pps_stl_tab_empty;

    -- Ab jetzt alle Eintraege der c_bde_fa_plan abarbeiten
    LOOP
      exit when c_bde_fa_plan%NOTFOUND;

      case -- BasisMenge für Arbeitsgang
        when v_bde_fa_plan_crt.ag_plan_menge_faktor_op = 'MUL' then
          v_ag_menge := in_menge * v_bde_fa_plan_crt.ag_plan_menge_faktor;
        when v_bde_fa_plan_crt.ag_plan_menge_faktor_op = 'DIV' then
          v_ag_menge := in_menge / v_bde_fa_plan_crt.ag_plan_menge_faktor;
        when v_bde_fa_plan_crt.ag_plan_menge_faktor_op = 'ABS' then
          v_ag_menge := v_bde_fa_plan_crt.ag_plan_menge_faktor;
        else
          v_ag_menge := 0;
      end case;
      case -- BasisMenge für Arbeitsgang
        when v_bde_fa_plan.ag_plan_menge_faktor_op = 'MUL' then
          v_menge := in_menge * v_bde_fa_plan.ag_plan_menge_faktor;
        when v_bde_fa_plan.ag_plan_menge_faktor_op = 'DIV' then
          v_menge := in_menge / v_bde_fa_plan.ag_plan_menge_faktor;
        when v_bde_fa_plan.ag_plan_menge_faktor_op = 'ABS' then
          v_menge := v_bde_fa_plan.ag_plan_menge_faktor;
        else
          v_menge := 0;
      end case;

      -- Der der neue Eintrag ist für einen neuen 'V'errichten Eintrag,
      -- dann den letzten schreiben
      if v_bde_fa_plan_crt.arb_plan_pos_id != v_bde_fa_plan.arb_plan_pos_id then
        v_fa_ag := v_fa_ag + v_ag_schrittweite;

        create_pps_auftrag_ag(0, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                              in_artikel_id, -- in_artikel_id      in isi_artikel.artikel_id%type,
                              v_artikel.zeichnung, --  in_zeichnung       in isi_artikel.zeichnung%type,
                              v_artikel.zeichnung_index,
                              -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                              in_charge_bez, -- in_charge_bez      in lvs_charge.charge_bez%type,
                              in_login_id, -- in_login_id        in isi_user.login_id%type,
                              v_menge, -- in_menge           in lvs_lam.menge%type,
                              in_kunden_nr, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                              in_kd_art_nr, -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                              in_kenz_lhm_druck, -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                              nvl(v_artikel.lte_name, v_artikel_kd.lte_name),
                              -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                              nvl(v_artikel.lte_menge,
                                  v_artikel_kd.lte_menge),
                              -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                              in_anz_lte, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                              nvl(v_artikel.lhm_name, v_artikel_kd.lhm_name),
                              -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                              nvl(v_artikel.lhm_menge,
                                  v_artikel_kd.lhm_menge),
                              -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                              in_anz_lhm, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                              in_bestnr_kd, -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                              in_abnr, -- in_abnr            in bde_fa_auftrag.abnr%type,
                              in_out_leitzahl, -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                              v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                              v_artikel.abfuell_abschalt_grob,
                              -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                              v_artikel.abfuell_abschalt_mittel,
                              -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                              v_artikel.abfuell_abschalt_fein,
                              -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                              v_artikel.abfuell_toleranz_plus,
                              -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                              v_artikel.abfuell_toleranz_minus,
                              -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                              v_artikel.abfuell_soll,
                              -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                              v_bde_fa_plan_crt); -- in_bde_fa_plan     in t_bde_fa_plan)

        v_pps_stl_tab_i := 0;
        -- Alle Referenzen in der v_stl_tab, die noch keine FA haben, müssen auf den letzen
        -- AG verweisen (Beim schreiben der Stückliste noch nicht bekannt)
        LOOP
          -- Leitzahl und Arbeitsgang eintragen (BDE_FA_AUFTRAG_STL Tabelle wird am ende geschrieben)
          v_pps_stl_tab_i := v_pps_stl_tab_i + 1;
          EXIT WHEN v_pps_stl_tab_i > v_pps_stl_tab_ix;
          if v_pps_stl_tab(v_pps_stl_tab_i).plan_auf_ag_id is NULL then
            v_pps_stl_tab(v_pps_stl_tab_i).plan_auf_ag_id := v_plan_auf_ag_id;
          end if;
        end LOOP;
      end if;

      v_bde_fa_plan_crt := v_bde_fa_plan;
      if v_bde_fa_plan.stueckliste_id is not NULL then
        -- Suchen, ob diese STL-Referenz auch eine 'MA'terialanforderung ist
        v_stueckliste_pos_id := NULL;
        OPEN c_stl_pos_fuer_ma_in_ag;
        FETCH c_stl_pos_fuer_ma_in_ag
          into v_stueckliste_pos_id;
        CLOSE c_stl_pos_fuer_ma_in_ag;
        -- Diese STL-Referenz ist auch eine 'MA'terialanforderung (Kleinser AG für die Ref)
        if v_bde_fa_plan.stueckliste_pos_id = v_stueckliste_pos_id then
          if v_bde_fa_plan.prod_menge_ix = 1 then
            v_fa_ag := v_fa_ag + v_ag_schrittweite;
            create_pps_auftrag_stl(0, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                                   in_artikel_id, -- in_artikel_id      in isi_artikel.artikel_id%type,
                                   v_artikel.zeichnung, --  in_zeichnung       in isi_artikel.zeichnung%type,
                                   v_artikel.zeichnung_index,
                                   -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                                   in_charge_bez, -- in_charge_bez      in lvs_charge.charge_bez%type,
                                   in_login_id, -- in_login_id        in isi_user.login_id%type,
                                   v_menge, -- in_menge           in lvs_lam.menge%type,
                                   in_kunden_nr, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                                   in_kd_art_nr, -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                                   in_kenz_lhm_druck, -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                                   nvl(v_artikel.lte_name,
                                       v_artikel_kd.lte_name),
                                   -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                                   nvl(v_artikel.lte_menge,
                                       v_artikel_kd.lte_menge),
                                   -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                                   in_anz_lte, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                                   nvl(v_artikel.lhm_name,
                                       v_artikel_kd.lhm_name),
                                   -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                                   nvl(v_artikel.lhm_menge,
                                       v_artikel_kd.lhm_menge),
                                   -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                                   in_anz_lhm, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                                   in_bestnr_kd, -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                                   in_abnr, -- in_abnr            in bde_fa_auftrag.abnr%type,
                                   in_out_leitzahl, -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                                   v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                                   v_artikel.abfuell_abschalt_grob,
                                   -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                   v_artikel.abfuell_abschalt_mittel,
                                   -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                   v_artikel.abfuell_abschalt_fein,
                                   -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                   v_artikel.abfuell_toleranz_plus,
                                   -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                   v_artikel.abfuell_toleranz_minus,
                                   -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                   v_artikel.abfuell_soll,
                                   -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                                   v_bde_fa_plan); -- in_bde_fa_plan     in t_bde_fa_plan)
          end if;
        end if;

        -- Naechsten Eintrag in der STL-Ref Tabelle
        v_pps_stl_tab_ix := v_pps_stl_tab_ix + 1;
        v_pps_stl_tab(v_pps_stl_tab_ix).sid := v_bde_fa_plan.sid;
        v_pps_stl_tab(v_pps_stl_tab_ix).firma_nr := v_bde_fa_plan.firma_nr;
        v_pps_stl_tab(v_pps_stl_tab_ix).plan_auf_stl_id := in_out_leitzahl *
                                                           v_ag_max +
                                                           v_bde_fa_plan.stueckliste_pos_id;
      end if;
      FETCH c_bde_fa_plan
        into v_bde_fa_plan;
    end LOOP;
    CLOSE c_bde_fa_plan;
    -- Nach der Abarbeitung der Tabelle muessen noch die Relation AG - STL erstellt werden
    -- und der Letzte 'V'errichtensatz ist noch nicht geschrieben
    v_fa_ag         := v_fa_ag + v_ag_schrittweite;
    v_pps_stl_tab_i := 0;
    LOOP
      -- Relation AG - STL werden erstellt
      v_pps_stl_tab_i := v_pps_stl_tab_i + 1;
      EXIT WHEN v_pps_stl_tab_i > v_pps_stl_tab_ix;
      if v_pps_stl_tab(v_pps_stl_tab_i).plan_auf_ag_id is NULL -- Letzen AG noch nachtragen
       then
        v_pps_stl_tab(v_pps_stl_tab_i).plan_auf_ag_id := v_plan_auf_ag_id;
      end if;
      INSERT into pps_plan_auftrag_ag_stl
      values
        (v_pps_stl_tab(v_pps_stl_tab_i).sid,
         v_pps_stl_tab(v_pps_stl_tab_i).firma_nr,
         v_pps_stl_tab(v_pps_stl_tab_i).plan_auf_ag_id,
         v_pps_stl_tab(v_pps_stl_tab_i).plan_auf_stl_id,
         v_pps_stl_tab(v_pps_stl_tab_i).prod_reihenfolge,
         v_pps_stl_tab(v_pps_stl_tab_i).prod_menge_p_einheit,
         v_pps_stl_tab(v_pps_stl_tab_i).prod_menge_p_einheit_op,
         v_pps_stl_tab(v_pps_stl_tab_i).prod_menge_ix,
         sysdate,           -- Create Date
         '-1',              -- Create User ID
         null,              -- Change Date
         null               -- Change User ID
         );
    end LOOP;
    -- Loeschen der Ref-Tabelle
    v_pps_stl_tab_ix := 0;
    v_pps_stl_tab    := v_pps_stl_tab_empty;
    -- Der Letzte 'V'errichtensatz wird geschrieben
    create_pps_auftrag_ag(1, -- in_kenz_letzter    in bde_fa_auftrag.kenz_letzt_ag%type,
                          in_artikel_id, -- in_artikel_id      in isi_artikel.artikel_id%type,
                          v_artikel.zeichnung, --  in_zeichnung       in isi_artikel.zeichnung%type,
                          v_artikel.zeichnung_index,
                          -- in_zeichnung_index in isi_artikel.zeichnung_index%type,
                          in_charge_bez, -- in_charge_bez      in lvs_charge.charge_bez%type,
                          in_login_id, -- in_login_id        in isi_user.login_id%type,
                          v_menge, -- in_menge           in lvs_lam.menge%type,
                          in_kunden_nr, -- in_kunden_nr       in bde_fa_auftrag.kunden_nr%type,
                          in_kd_art_nr, -- in_kd_art_nr       in bde_fa_auftrag.kd_art_nr%type,
                          in_kenz_lhm_druck, -- in_kenz_lhm_druck  in bde_fa_auftrag.kenz_lhm_druck%type,
                          nvl(v_artikel.lte_name, v_artikel_kd.lte_name),
                          -- in_lte_name        in bde_fa_auftrag.lte_name%type,
                          nvl(v_artikel.lte_menge, v_artikel_kd.lte_menge),
                          -- in_lte_menge       in bde_fa_auftrag.lte_menge%type,
                          in_anz_lte, -- in_anz_lte         in bde_fa_auftrag.lte_anz%type,
                          nvl(v_artikel.lhm_name, v_artikel_kd.lhm_name),
                          -- in_lhm_name        in bde_fa_auftrag.lhm_name%type,
                          nvl(v_artikel.lhm_menge, v_artikel_kd.lhm_menge),
                          -- in_lhm_menge       in bde_fa_auftrag.lhm_menge%type,
                          in_anz_lhm, -- in_anz_lhm         in bde_fa_auftrag.lhm_anz%type,
                          in_bestnr_kd, -- in_bestnr_kd       in bde_fa_auftrag.best_nr_kunde%type,
                          in_abnr, -- in_abnr            in bde_fa_auftrag.abnr%type,
                          in_out_leitzahl, -- in_out_leitzahl    in out bde_fa_auftrag.leitzahl%type,
                          v_fa_ag, -- in_fa_ag           in bde_fa_auftrag.fa_ag%type,
                          v_artikel.abfuell_abschalt_grob,
                          -- in_abfuell_grob    in bde_fa_auftrag.abfuell_abschalt_grob%type,
                          v_artikel.abfuell_abschalt_mittel,
                          -- in_abfuell_mittel  in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                          v_artikel.abfuell_abschalt_fein,
                          -- in_abfuell_fein    in bde_fa_auftrag.abfuell_abschalt_fein%type,
                          v_artikel.abfuell_toleranz_plus,
                          -- in_abfuell_tolleranz_plus in bde_fa_auftrag.abfuell_toleranz_plus%type,
                          v_artikel.abfuell_toleranz_minus,
                          -- in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                          v_artikel.abfuell_soll,
                          -- in_abfuell_soll    in bde_fa_auftrag.abfuell_soll%type,
                          v_bde_fa_plan_crt); -- in_bde_fa_plan     in t_bde_fa_plan)

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then
      -- Update 2011 show Exception Source Line
      v_err_text := v_err_text || CHR(13) || CHR(10) ||
                    DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if v_err_nr is not NULL then
        v_err_text := v_err_text || CHR(13) || CHR(10) ||
                      DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%' then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) ||
                        DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  ---------------------------------------------------------------------------------------
  -- procedure create_pps_auftrag_ag
  -- Erzeugt eine Eintrag in der PPS_PLAN_AUFTRAG_AG
  ---------------------------------------------------------------------------------------
  procedure create_pps_auftrag_ag(in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                  in_artikel_id              in isi_artikel.artikel_id%type,
                                  in_zeichnung               in isi_artikel.zeichnung%type,
                                  in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                  in_charge_bez              in lvs_charge.charge_bez%type,
                                  in_login_id                in isi_user.login_id%type,
                                  in_menge                   in lvs_lam.menge%type,
                                  in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                  in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                  in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                  in_lte_name                in bde_fa_auftrag.lte_name%type,
                                  in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                  in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                  in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                  in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                  in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                  in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                  in_abnr                    in bde_fa_auftrag.abnr%type,
                                  in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                  in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                  in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                  in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                  in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                  in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                  in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                  in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                  in_bde_fa_plan             in t_bde_fa_plan) is

  begin

    -- Pruefen, ob der MAV-Wert ereicht ist, wenn ja dann Fehler
    if in_fa_ag >= v_ag_max then
      raise_isi_error(10,
                      lc.ec_p2(lc.O_TP2_BDE_FA_AG_ZU_GROSS,
                               in_out_leitzahl,
                               in_fa_ag));
    end if;

    -- Keine Leitzahl uebergeben, dann aus SEQ holen
    if in_out_leitzahl is NULL then
      select SEQ_BDE_FA_AUFTRAG_LEITZAHL.nextval
        into in_out_leitzahl
        from dual;
    end if;
    select SEQ_PPS_PLAN_AUFTRAG_AG.nextval into v_plan_auf_ag_id from dual;

    -- PPS-Eintrag schreiben
    insert into pps_plan_auftrag_ag
    values
      (in_bde_fa_plan.sid, -- SID                     VARCHAR2(2) not null,
       in_bde_fa_plan.firma_nr, -- FIRMA_NR                NUMBER(2) not null,  PLAN_AUF_AG_ID   NUMBER not null,
       v_plan_auf_ag_id, -- PLAN_AUF_AG_ID   NUMBER not null,
       in_out_leitzahl, -- PLAN_AUF_ID      NUMBER not null,
       in_fa_ag, -- VORGANG          NUMBER not null,
       in_bde_fa_plan.pos_nr, -- POS_NR           NUMBER not null,
       in_bde_fa_plan.ag_upos, -- AG_UPOS          NUMBER default 1 not null,
       in_bde_fa_plan.ag_name1, -- AG_NAME1         VARCHAR2(255) not null,
       in_bde_fa_plan.ag_name2, -- AG_NAME2         VARCHAR2(255),
       in_bde_fa_plan.ag_text1, -- AG_TEXT1         VARCHAR2(255),
       in_bde_fa_plan.ag_text2, -- AG_TEXT2         VARCHAR2(255),
       in_bde_fa_plan.ag_text3, -- AG_TEXT3         VARCHAR2(255),
       in_bde_fa_plan.res_id, -- RES_ID           NUMBER,
       in_menge, -- SOLL_MENGE       NUMBER not null,
       in_bde_fa_plan.soll_zeit_ruest, -- SOLL_ZEIT_RUEST  NUMBER default 0 not null,
       in_menge * in_bde_fa_plan.soll_zeit_p_einh, -- SOLL_ZEIT_PROD   NUMBER default 0 not null,
       in_menge * in_bde_fa_plan.soll_zeit_p_einh *
       in_bde_fa_plan.soll_zeit_stoer_p_std / 60, -- SOLL_ZEIT_STOER  NUMBER default 0 not null,
       in_bde_fa_plan.soll_zeit_p_einh, -- SOLL_ZEIT_P_EINH NUMBER default 0 not null,
       in_bde_fa_plan.prod_params, -- PROD_PARAMS      VARCHAR2(4000),
       NULL, -- QUITT_GRUPPE_AG  NUMBER
       NULL, -- TERMIN_START_GEPL
       NULL, -- TERMIN_ENDE_GEPL
       in_bde_fa_plan.satzartz,
       in_bde_fa_plan.nio_res_id,
       in_bde_fa_plan.vorgangsqualifikation,
       sysdate,           -- Create Date
       '-1',              -- Create User ID
       null,              -- Change Date
       null               -- Change User ID
       );
  end;

  ---------------------------------------------------------------------------------------
  -- procedure create_pps_auftrag_stl
  -- Erzeugt eine Eintrag in der PPS_PLAN_AUFTRAG_STL
  ---------------------------------------------------------------------------------------
  procedure create_pps_auftrag_stl(in_kenz_letzter            in bde_fa_auftrag.kenz_letzt_ag%type,
                                   in_artikel_id              in isi_artikel.artikel_id%type,
                                   in_zeichnung               in isi_artikel.zeichnung%type,
                                   in_zeichnung_index         in isi_artikel.zeichnung_index%type,
                                   in_charge_bez              in lvs_charge.charge_bez%type,
                                   in_login_id                in isi_user.login_id%type,
                                   in_menge                   in lvs_lam.menge%type,
                                   in_kunden_nr               in bde_fa_auftrag.kunden_nr%type,
                                   in_kd_art_nr               in bde_fa_auftrag.kd_art_nr%type,
                                   in_kenz_lhm_druck          in bde_fa_auftrag.kenz_lhm_druck%type,
                                   in_lte_name                in bde_fa_auftrag.lte_name%type,
                                   in_lte_menge               in bde_fa_auftrag.lte_menge%type,
                                   in_anz_lte                 in bde_fa_auftrag.lte_anz%type,
                                   in_lhm_name                in bde_fa_auftrag.lhm_name%type,
                                   in_lhm_menge               in bde_fa_auftrag.lhm_menge%type,
                                   in_anz_lhm                 in bde_fa_auftrag.lhm_anz%type,
                                   in_bestnr_kd               in bde_fa_auftrag.best_nr_kunde%type,
                                   in_abnr                    in bde_fa_auftrag.abnr%type,
                                   in_out_leitzahl            in out bde_fa_auftrag.leitzahl%type,
                                   in_fa_ag                   in bde_fa_auftrag.fa_ag%type,
                                   in_abfuell_grob            in bde_fa_auftrag.abfuell_abschalt_grob%type,
                                   in_abfuell_mittel          in bde_fa_auftrag.abfuell_abschalt_mittel%type,
                                   in_abfuell_fein            in bde_fa_auftrag.abfuell_abschalt_fein%type,
                                   in_abfuell_tolleranz_plus  in bde_fa_auftrag.abfuell_toleranz_plus%type,
                                   in_abfuell_tolleranz_minus in bde_fa_auftrag.abfuell_toleranz_minus%type,
                                   in_abfuell_soll            in bde_fa_auftrag.abfuell_soll%type,
                                   in_bde_fa_plan             in t_bde_fa_plan) is

    v_ag_menge bde_fa_auftrag.ag_ist_mg%type;

  begin
    -- Pruefen, ob der MAV-Wert ereicht ist, wenn ja dann Fehler
    if in_fa_ag >= v_ag_max then
      raise_isi_error(10,
                      lc.ec_p2(lc.O_TP2_BDE_FA_AG_ZU_GROSS,
                               in_out_leitzahl,
                               in_fa_ag));
    end if;

    -- Keine Leitzahl uebergeben, dann aus SEQ holen
    if in_out_leitzahl is NULL then
      select SEQ_BDE_FA_AUFTRAG_LEITZAHL.nextval
        into in_out_leitzahl
        from dual;
    end if;

    -- Bei MA die Mengen ermitteln
    case
      when in_bde_fa_plan.stk_plan_menge_p_einheit_op = 'MUL' then
        v_ag_menge := in_menge * in_bde_fa_plan.stk_plan_menge_p_einheit;
      when in_bde_fa_plan.stk_plan_menge_p_einheit_op = 'DIV' then
        v_ag_menge := in_menge / in_bde_fa_plan.stk_plan_menge_p_einheit;
      when in_bde_fa_plan.stk_plan_menge_p_einheit_op = 'ABS' then
        v_ag_menge := in_bde_fa_plan.stk_plan_menge_p_einheit;
      else
        v_ag_menge := 0;
    end case;

    -- Mengen immer auf Ganze aufrunden
    v_ag_menge := round(v_ag_menge + 0.499999999999999999999999, 0); -- Immer ganze Einheit aufgerundet

    -- PPS-Eintrag schreiben
    insert into pps_plan_auftrag_stl
    values
      (in_bde_fa_plan.sid, -- SID                     VARCHAR2(2) not null,
       in_bde_fa_plan.firma_nr, -- FIRMA_NR                NUMBER(2) not null,
       in_out_leitzahl * v_ag_max + in_bde_fa_plan.stueckliste_pos_id, -- PLAN_AUF_STL_ID  NUMBER not null,
       in_out_leitzahl, -- PLAN_AUF_ID      NUMBER not null,
       in_bde_fa_plan.stueckliste_pos_id, -- POS_NR           NUMBER not null,
       in_bde_fa_plan.artikel_id, -- ARTIKEL_ID      NUMBER not null,
       in_bde_fa_plan.zeichnung, -- ZEICHNUNG       VARCHAR2(255),
       in_bde_fa_plan.zeichnung_index,                    -- ZEICHNUNG_INDEX VARCHAR2(10),
       v_ag_menge,                                        -- MENGE           NUMBER not null,
       NULL,                                              -- MENGE_EINHEIT   VARCHAR2(3),
       in_bde_fa_plan.stk_prod_params,                    -- PROD_PARAMS     VARCHAR2(4000)
       in_bde_fa_plan.stk_plan_menge_p_einheit,           -- PROD_MENGE_P_EINHEIT    NUMBER default 1 not null,
       in_bde_fa_plan.stk_plan_menge_p_einheit_op,        -- PROD_MENGE_P_EINHEIT_OP VARCHAR2(10) default 'MUL' not null
       sysdate,           -- Create Date
       '-1',              -- Create User ID
       null,              -- Change Date
       null               -- Change User ID
       );

  end;

  -- 2017.09.13 AG Erweiterung erweiterte Werkbank für KONSI-Bestände und KONSI Fertigware
  --            Eingebaut fuer projekt HAG (Nur Rohstoffe des Eigentümers verwenden)
  procedure create_bde_fa_dispo(in_sid               in isi_sid.sid%type,
                                in_firma_nr          in isi_firma.firma_nr%type,
                                in_dispo_charge_rein in varchar2,
                                in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                in_leitzahl          in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag             in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos           in bde_fa_auftrag.fa_upos%type,
                                in_komplett          in varchar2,
                                in_user_id           in isi_user.login_id%type,
                                in_ICE               in varchar2) is

  begin
    pps_p_bde_new.create_bde_fa_dispo_db31 (in_sid,
                                        in_firma_nr,
                                        in_dispo_charge_rein,
                                        in_hersteller_liste,
                                        in_leitzahl,
                                        in_fa_ag,
                                        in_fa_upos,
                                        in_komplett,
                                        in_user_id,
                                        in_ice,
                                        NULL);
  end;

  /*
  __________________________________________________
  Author    : HJG
  Created   : 24.06.2020
  __________________________________________________
  Description
  Die Prozedur reserviert für den übergebenen Fertigungsauftrag und Arbeitsgang
  das benötigte Material im Lager.
  __________________________________________________
  TODO
  none.
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  24.06.2020   DB31_1      (-HJG-)  Ableitung von create_bde_fa_dispo erstellt
                                    Erweiterung Reserviernung nicht Komplett nur bis in_min_res_menge
                                    Wenn in_es_menge erreicht, dann Reservierung stoppen
                                    Wenn Auftragsmenge Erreicht, dann auch Reservierung beenden
  29.07.2020   DB31_2      (-CMe-)  v_dispo ignorieren wenn in_min_res_menge not null und größer
                                    0 ist (P70397-849).
  14.08.2020   DB31_3      (-CMe-)  Hotfix fuer P70397-880. Material, dass in einen anderen Auftrag als
                                    Zwischenprodukt produziert wurde, kann aktuell nicht reserviert
                                    werden
  25.03.2021   DB31_4      (-CMe-)  Hotfix fuer E70397-596 (V_R_LTE_% Paletten dürfen nicht verwendet werden)
                                    Bei den V_R_LTE_% handelt es sich um Virtuelle Paletten die für die Produktion
                                    verwendet werden.
                                    Kennzeichen: CMe 20210325
  10.08.2021   DB31_5      (-CMe-)  Bugfix: Statement war falsch ausformuliert und ist korrigiert worden
                                    Vorher: Wenn In_Komplett False, dann muss die min Menge gesetzt sein (entspricht nicht dem wie laut Kommentar vorgesehen)
                                    Jetzt: Wenn die min. Menge gesetzt ist, muss in_komplett auf False stehen (entspricht dem wie laut kommentar vorgesehen)
                                    Kennzeichen: CMe 20210810
  21.02.2022   DB31_6      (-CMe-)  P71141-40 Rerservierungen auf bereits reeservierten PAletten die im Transport ist jetz möglich, inkl.
                                    Regelung  für Durchlauf Läger
                                    Kennteichen: CMe 20220221
  
  */

  procedure create_bde_fa_dispo_db31 (in_sid               in isi_sid.sid%type,
                                      in_firma_nr          in isi_firma.firma_nr%type,
                                      in_dispo_charge_rein in varchar2,
                                      in_hersteller_liste  in pps_simple_fa.hersteller_kuerzel_liste%type,
                                      in_leitzahl          in bde_fa_auftrag.leitzahl%type,
                                      in_fa_ag             in bde_fa_auftrag.fa_ag%type,
                                      in_fa_upos           in bde_fa_auftrag.fa_upos%type,
                                      in_komplett          in varchar2,
                                      in_user_id           in isi_user.login_id%type,
                                      in_ICE               in varchar2,
                                      in_min_res_menge     in lvs_lam.res_menge%type) is
                                      -- Wenn MIN-Menge gesetzt, dann muss Komplett Reserviern False sein
                                      -- Sonst wird Fehler gerissen

    v_result                  number;

    v_bde_fa                  bde_fa_auftrag%rowtype;
    v_bde_fak                 bde_fa_kopf%rowtype;
    v_bde_fa_res              bde_fa_auftrag%rowtype;
    v_found                   boolean;
    v_streng_fifo             varchar2(1);
    v_bde_push_q_chk          varchar2(1);
    -- 20180203 AG Erweiterung, LTE,s im BDE nur mit einem FA reservieren über pruefen reserviernung
    v_dispo_res_lte_chk       varchar2(1);
    v_bde_ausl_ltr_chk_transp varchar2(1);

    v_res                     isi_resource%rowtype;
    v_lam                     lvs_lam%rowtype; -- Lagerbestand
    v_lte                     lvs_lte%rowtype; -- LTE's
    v_art                     isi_artikel%rowtype; -- Artikeldaten
    v_lgr                     lvs_lgr%rowtype;
    v_lgr_grp                 lvs_lgr%rowtype;
    v_wa_type                 lvs_lgr.wa_typ%type;

    v_res_roh_platz           isi_resource.lager_roh%type;
    v_prod_params             isi_artikel_gruppe.prod_params%type;
    v_dispo                   boolean;
    v_fa_leit_res             bde_fa_auftrag.leitzahl%type; -- Letzter FA (Prüfen bei DURCHL-Lager Reihenfplge)
    v_fa_start_gepl           bde_fa_auftrag.termin_start_gepl%type; -- Letzter FA (Prüfen bei DURCHL-Lager Reihenfplge)
    v_check_seq_res           boolean; -- LTE auf Reservierung und Reihenfolge prüfen
    v_lte_res_ok              boolean; -- Darf in der aktuellen LTE reserviert werden
    v_hersteller_liste        pps_simple_fa.hersteller_kuerzel_liste%type;

    v_sort                    number;
    v_sort2                   number;
    v_lte_id                  lvs_lte.lte_id%type;
    v_lte_lgr_ort             lvs_lte.lgr_ort%type;
    v_lte_lgr_platz           lvs_lte.lgr_platz%type;

    v_menge                   number;
    v_menge_sum               number; -- Summe der gefundenen Ware in Mengeneinheit (LAM-Menge)
    v_delta_menge             number;
    v_bde_check_konsi         varchar2(1);
    v_lgr_gruppe_fa           lvs_lgr.lgr_platz_gruppe%type;
    v_lte_transport           isi_transport%rowtype;
    v_lte_dispo_ziele         lvs_lgr.lgr_platz_gruppe%type;

    CURSOR c_get_lgr_gruppe_fa is
      select lgr.lgr_platz_gruppe
        from bde_fa_auftrag fag
        join isi_resource res on res.res_id = fag.res_id
        join lvs_lgr lgr on lgr.lgr_platz = res.lager_roh
        where fag.leitzahl = v_bde_fa.leitzahl
          and fag.fa_ag = v_bde_fa.fa_ag
          and fag.fa_upos = v_bde_fa.fa_upos;
    
    CURSOR c_get_transport is
      select t.*
        from isi_transport t
       where t.lte_id = v_lte_id;
       
    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.sid = in_sid
         and lte.firma_nr = in_firma_nr
         and lte.lte_id = v_lte_id
       order by lte.lgr_platz desc;

    CURSOR c_art_grp is
      select ag.prod_params
        from isi_artikel a, isi_artikel_gruppe ag
       where a.artikel_id = v_bde_fa.ag_artikel_id
         and ag.art_gruppe_id = a.art_gruppe_id;

    CURSOR c_bde_fa is
      select *
        from bde_fa_auftrag fa
       where fa.sid = in_sid
         and fa.firma_nr = in_firma_nr
         and fa.leitzahl = in_leitzahl
         and fa.fa_ag = nvl(in_fa_ag, fa.fa_ag)
         and fa.fa_upos = nvl(in_fa_upos, fa.fa_upos)
         and fa.satzart = 'MA'
         and nvl(fa.ma_res_menge, 0) < fa.ag_soll_mg
       order by fa.termin_start_gepl,
                fa.abnr,
                fa.leitzahl,
                fa.fa_ag,
                fa.fa_upos;

    CURSOR c_bde_fak is
      select *
        from bde_fa_kopf fak
       where fak.sid = v_bde_fa.sid
         and fak.firma_nr = v_bde_fa.firma_nr
         and fak.fa_nr = v_bde_fa.leitzahl;

    CURSOR c_bde_fa_v is
      select r.lager_roh
        from bde_fa_auftrag fa, isi_resource r
       where fa.sid = in_sid
         and fa.firma_nr = in_firma_nr
         and fa.leitzahl = in_leitzahl
         and fa.satzart like 'V%'
         and fa.fa_ag > v_bde_fa.fa_ag
         and fa.fa_upos = v_bde_fa.fa_upos
         and r.res_id = fa.res_id
       order by fa.termin_start_gepl,
                fa.abnr,
                fa.leitzahl,
                fa.fa_ag,
                fa.fa_upos;

    CURSOR c_lams_c is
      select *
        from (select min(l.lam_mhd) lam_mhd,
                      l.charge_id,
                      sum(l.menge) g_menge
                 from lvs_lam     l,
                      lvs_lte     lte,
                      lvs_lgr     lgr,
                      isi_artikel a,
                      isi_firma   f,
                      lvs_lgr     zlgr
                where a.artikel_id = v_bde_fa.ag_artikel_id
                  and f.sid = v_bde_fa.sid
                  and f.firma_nr = v_bde_fa.firma_nr
                  and l.artikel_id = v_bde_fa.ag_artikel_id
                  and l.lgr_platz is not NULL
                  and l.lte_id = lte.lte_id
                  and nvl(l.order_pos_auf_id, v_bde_fa.auf_id) =
                      v_bde_fa.auf_id
                  and l.akt_inventur_id is NULL
                  and l.labor_status = c.LAB_STAT_F
                  and lvs_p_lgr_grp_fahrzeuge.chk_lgr_platz_zugriff_ok(lgr.lgr_platz) = c.c_true
                  and l.lam_mhd >= trunc(sysdate)
                     -- 2017.09.13 AG Jetzt auch verlängerte Werkbank und Verwendung von Kunden-KONSI-Beständen
                     --           Eingebaut für HAG und Verwendung von Rohstoffen, die genau einem Kunden oder Lieferadresse geoeren
                  and ((l.owner_address_id = nvl(v_bde_fa.adress_id, v_bde_fak.adress_id) and -- genau von diesem Kunden
                        v_bde_fa.lohn_arbeit = c.C_TRUE) or -- Und Konsi benutzen
                       l.owner_address_id is NULL or  -- oder kein Keine KONSI-Ware
                       v_bde_check_konsi = c.C_FALSE)
                  and l.lgr_platz = lgr.lgr_platz
                  and lgr.gesperrt = C.LGR_GESPERRT_F
                  and lgr.akt_inventur_id is null -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
                  and (lgr.wa_typ = 'BDEPUSH' or v_bde_push_q_chk = c.C_FALSE) -- BDE-Push eingestellt auf der Quelle oder ist nich Pflicht
                  and nvl(decode(v_bde_fa.ma_res_charge_id, -- ID 0 nicht moeglich - 0 Bedeutet Chargenrein
                                 0, NULL,
                                 v_bde_fa.ma_res_charge_id), nvl(l.charge_id, 0)) =
                                 nvl(l.charge_id, 0)
                  and l.order_pos_auf_id is NULL
                  --(-CMe-) Hotfix fuer P70397-880
                  --and nvl(l.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl -- Leitzahl beruecksichtigen
                  and (nvl(l.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl or l.fa_ag is null)
                  and l.fa_ag is NULL
                  and l.order_pos_auf_id is NULL
                  and (v_dispo_res_lte_chk = c.C_FALSE or
                       nvl(lte.order_vorgang_id, v_bde_fa.leitzahl) = v_bde_fa.leitzahl)
                  and lgr.lgr_typ != 'DURCHL1' -- Durchlauflager mit begrenzten Zugriff
                  and ((lte.lte_status like '%F') or
                       -- CMe 20220221 (P71141-40): Wenn in Transport Status ist die LTe zulässig, 
                       --                           solange v_bde_ausl_ltr_chk_transp 0 'T'
                       ((lte.lte_status like '%T' or 
                         lte.lte_status like '%D') and
                        v_bde_ausl_ltr_chk_transp = 'T') or
                       ((lte.lte_status like '%T' or 
                         lte.lte_status like '%D') and
                        (v_bde_fak.soll_betriebsart = 'JITSEQ' or
                         v_bde_fak.soll_betriebsart = 'EXPRESS') and
                        nvl(zlgr.lgr_typ, 'XX') != 'DURCHL1' and
                        nvl(zlgr.wa_typ, 'XX') in ('BDEPUSH', 'BDEICEPUSH')))
                  and (lgr.lgr_verwendung = C.R_Lgr_Typ_Lager or -- Lagertypen und Verwendungstypen erlaubt (Lager)
                       lgr.lgr_verwendung = C.R_Lgr_Typ_LagerP or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       lgr.lgr_verwendung = C.R_LGR_TYP_Puffer or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       (lgr.lgr_verwendung = C.R_LGR_TYP_WA and  -- Nur WA's wenn der WA_TYP BDEPUSH oder BDEICEPUSH
                        lgr.wa_typ in ('BDEPUSH', 'BDEICEPUSH')))
                 and lte.ziel_lgr_platz = zlgr.lgr_platz(+)
                 -- CMe 20210325 Hotfix fuer E70397-596 (V_R_LTE_% Paletten dürfen nicht verwendet werden)
                 and lte.lte_id not like 'V_R_LTE_%'
               group by l.charge_id) lam_s
       where lam_s.g_menge >= (v_bde_fa.ag_soll_mg - v_bde_fa.ma_res_menge)
          or nvl(v_bde_fa.ma_reserviert, c.C_FALSE) = c.C_TRUE
          or in_komplett = c.C_FALSE
       order by lam_s.lam_mhd;
    v_lams_c c_lams_c%rowtype;

    CURSOR c_lams_h is
      select *
        from (select min(l.lam_mhd) lam_mhd,
                      l.hersteller_kuerzel_liste,
                      sum(l.menge) g_menge
                 from lvs_lam     l,
                      lvs_lte     lte,
                      lvs_lgr     lgr,
                      isi_artikel a,
                      isi_firma   f,
                      lvs_lgr     zlgr
                where a.artikel_id = v_bde_fa.ag_artikel_id
                  and f.sid = v_bde_fa.sid
                  and f.firma_nr = v_bde_fa.firma_nr
                  and l.artikel_id = v_bde_fa.ag_artikel_id
                  and l.lgr_platz is not NULL
                  and l.lte_id = lte.lte_id
                  and nvl(l.order_pos_auf_id, v_bde_fa.auf_id) = v_bde_fa.auf_id
                  and l.akt_inventur_id is NULL
                  and (lgr.wa_typ = 'BDEPUSH' or v_bde_push_q_chk = c.C_FALSE) -- BDE-Push eingestellt auf der Quelle oder ist nich Pflicht
                  and l.labor_status = c.LAB_STAT_F
                  and lvs_p_lgr_grp_fahrzeuge.chk_lgr_platz_zugriff_ok(lgr.lgr_platz) = c.c_true
                  and l.lam_mhd > trunc(sysdate)
                     -- 2017.09.13 AG Jetzt auch verlängerte Werkbank und Verwendung von Kunden-KONSI-Beständen
                     --           Eingebaut für HAG und Verwendung von Rohstoffen, die genau einem Kunden oder Lieferadresse geoeren
                  and ((l.owner_address_id = nvl(v_bde_fa.adress_id, v_bde_fak.adress_id) and -- genau von diesem Kunden
                        v_bde_fa.lohn_arbeit = c.C_TRUE) or -- Und Konsi benutzen
                       l.owner_address_id is NULL or  -- oder kein Keine KONSI-Ware
                       v_bde_check_konsi = c.C_FALSE)
                  and l.lgr_platz = lgr.lgr_platz
                  and lgr.gesperrt = C.LGR_GESPERRT_F
                  and lgr.akt_inventur_id is null -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
                  and nvl(decode(v_bde_fa.ma_res_charge_id, -- ID 0 nicht moeglich - 0 Bedeutet Chargenrein
                                 0, NULL,
                                 v_bde_fa.ma_res_charge_id), nvl(l.charge_id, 0)) =
                                 nvl(l.charge_id, 0)
                  and l.order_pos_auf_id is NULL
                  --(-CMe-)  Hotfix fuer P70397-880
                  --and nvl(l.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl -- Leitzahl beruecksichtigen
                  and (nvl(l.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl or l.fa_ag is null)
                  and l.fa_ag is NULL
                  and l.order_pos_auf_id is NULL
                  and (v_dispo_res_lte_chk = c.C_FALSE or
                       nvl(lte.order_vorgang_id, v_bde_fa.leitzahl) = v_bde_fa.leitzahl)
                  and lgr.lgr_typ != 'DURCHL1' -- Durchlauflager mit begrenzten Zugriff
                  and (v_hersteller_liste like
                      ('%;' || l.hersteller_kuerzel_liste || '%') or
                      -- CMe Hotfix 20210806
                       v_hersteller_liste = ';' or
                       v_hersteller_liste is NULL or
                       l.hersteller_kuerzel_liste is NULL)
                  and ((lte.lte_status like '%F') or
                       -- CMe 20220221 (P71141-40): Wenn in Transport Status ist die LTe zulässig, 
                       --                           solange v_bde_ausl_ltr_chk_transp 0 'T'
                       ((lte.lte_status like '%T' or 
                         lte.lte_status like '%D') and
                        v_bde_ausl_ltr_chk_transp = 'T') or
                       ((lte.lte_status like '%T' or 
                         lte.lte_status like '%D') and
                        (v_bde_fak.soll_betriebsart = 'JITSEQ' or
                         v_bde_fak.soll_betriebsart = 'EXPRESS') and
                        nvl(zlgr.lgr_typ, 'XX') != 'DURCHL1' and
                        nvl(zlgr.wa_typ, 'XX') in ('BDEPUSH', 'BDEICEPUSH')))
                  and (lgr.lgr_verwendung = C.R_Lgr_Typ_Lager or -- Lagertypen und Verwendungstypen erlaubt (Lager)
                       lgr.lgr_verwendung = C.R_Lgr_Typ_LagerP or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       lgr.lgr_verwendung = C.R_LGR_TYP_Puffer or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       (lgr.lgr_verwendung = C.R_LGR_TYP_WA and -- Nur WA's wenn der WA_TYP BDEPUSH oder BDEICEPUSH
                        lgr.wa_typ in ('BDEPUSH', 'BDEICEPUSH')))
                  and lte.ziel_lgr_platz = zlgr.lgr_platz(+)
                 -- CMe 20210325 Hotfix fuer E70397-596 (V_R_LTE_% PAletten dürfen nicht verwendet werden)
                  and lte.lte_id not like 'V_R_LTE_%'
                group by l.hersteller_kuerzel_liste) lam_s
       where nvl(lam_s.hersteller_kuerzel_liste, ';') =
             nvl(nvl(v_bde_fa.ma_hersteller_kuerzel_liste,
                     lam_s.hersteller_kuerzel_liste),
                 ';')
         and (lam_s.g_menge >=
              (v_bde_fa.ag_soll_mg - v_bde_fa.ma_res_menge) or
              nvl(v_bde_fa.ma_reserviert, c.C_FALSE) = c.C_TRUE or
              in_komplett = c.C_FALSE)
       order by lam_s.lam_mhd;
    v_lams_h c_lams_h%rowtype;

    CURSOR c_lams_a is
      select *
        from (select min(l.lam_mhd) lam_mhd,
                      l.hersteller_kuerzel_liste,
                      sum(l.menge) g_menge
                 from lvs_lam     l,
                      lvs_lte     lte,
                      lvs_lgr     lgr,
                      isi_artikel a,
                      isi_firma   f,
                      lvs_lgr     zlgr
                where a.artikel_id = v_bde_fa.ag_artikel_id
                  and f.sid = v_bde_fa.sid
                  and f.firma_nr = v_bde_fa.firma_nr
                  and l.artikel_id = v_bde_fa.ag_artikel_id
                  and l.lgr_platz is not NULL
                  and l.lte_id = lte.lte_id
                  and nvl(l.order_pos_auf_id, v_bde_fa.auf_id) =
                      v_bde_fa.auf_id
                  and l.akt_inventur_id is NULL
                  and l.labor_status = c.LAB_STAT_F
                  and lvs_p_lgr_grp_fahrzeuge.chk_lgr_platz_zugriff_ok(lgr.lgr_platz) = c.c_true
                  and l.lam_mhd > trunc(sysdate)
                     -- 2017.09.13 AG Jetzt auch verlängerte Werkbank und Verwendung von Kunden-KONSI-Beständen
                     --           Eingebaut für HAG und Verwendung von Rohstoffen, die genau einem Kunden oder Lieferadresse geoeren
                  and ((l.owner_address_id = nvl(v_bde_fa.adress_id, v_bde_fak.adress_id) and -- genau von diesem Kunden
                        v_bde_fa.lohn_arbeit = c.C_TRUE) or -- Und Konsi benutzen
                       l.owner_address_id is NULL or  -- oder kein Keine KONSI-Ware
                       v_bde_check_konsi = c.C_FALSE)
                  and l.lgr_platz = lgr.lgr_platz
                  and lgr.gesperrt = C.LGR_GESPERRT_F
                  and lgr.akt_inventur_id is null -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
                  and (lgr.wa_typ = 'BDEPUSH' or v_bde_push_q_chk = c.C_FALSE) -- BDE-Push eingestellt auf der Quelle oder ist nich Pflicht
                   --(-CMe-)  Hotfix fuer P70397-880
                  --and nvl(l.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl -- Leitzahl beruecksichtigen
                  and (nvl(l.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl or l.fa_ag is null)
                  and l.fa_ag is NULL
                  and l.order_pos_auf_id is NULL
                  and (v_dispo_res_lte_chk = c.C_FALSE or
                       nvl(lte.order_vorgang_id, v_bde_fa.leitzahl) = v_bde_fa.leitzahl)
                  and lgr.lgr_typ != 'DURCHL1' -- Durchlauflager mit begrenzten Zugriff
                  and ((lte.lte_status like '%F') or
                       -- CMe 20220221 (P71141-40): Wenn in Transport Status ist die LTe zulässig, 
                       --                           solange v_bde_ausl_ltr_chk_transp 0 'T'
                       ((lte.lte_status like '%T' or 
                         lte.lte_status like '%D') and
                        v_bde_ausl_ltr_chk_transp = 'T') or
                       ((lte.lte_status like '%T' or 
                         lte.lte_status like '%D') and
                        (v_bde_fak.soll_betriebsart = 'JITSEQ' or
                         v_bde_fak.soll_betriebsart = 'EXPRESS') and
                        nvl(zlgr.lgr_typ, 'XX') != 'DURCHL1' and
                        nvl(zlgr.wa_typ, 'XX') in ('BDEPUSH', 'BDEICEPUSH')))
                  and (lgr.lgr_verwendung = C.R_Lgr_Typ_Lager or -- Lagertypen und Verwendungstypen erlaubt (Lager)
                       lgr.lgr_verwendung = C.R_Lgr_Typ_LagerP or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       lgr.lgr_verwendung = C.R_LGR_TYP_Puffer or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                       (lgr.lgr_verwendung = C.R_LGR_TYP_WA and -- Nur WA's wenn der WA_TYP BDEPUSH oder BDEICEPUSH
                        lgr.wa_typ in ('BDEPUSH', 'BDEICEPUSH')))
                  and lte.ziel_lgr_platz = zlgr.lgr_platz(+)
                  -- CMe 20210325 Hotfix fuer E70397-596 (V_R_LTE_% PAletten dürfen nicht verwendet werden)
                  and lte.lte_id not like 'V_R_LTE_%'
                group by l.hersteller_kuerzel_liste) lam_s
       where lam_s.g_menge >= (v_bde_fa.ag_soll_mg - v_bde_fa.ma_res_menge)
          or nvl(v_bde_fa.ma_reserviert, c.C_FALSE) = c.C_TRUE
          or in_komplett = c.C_FALSE
       order by lam_s.lam_mhd;
    v_lams_a c_lams_a%rowtype;

    CURSOR c_ltes is
    -- Achtung dieser SELECT muß in der Funktion lvs_lte_suche_buch_ausl und im Delphi (ISI-ORDER) als Vorschlag
    -- fuer Auslagerungen identisch gehalten werden
      select lte.lte_id,
             lte.lgr_ort,
             lte.lgr_platz,
             sum(lam.menge) menge,
             trunc(lvs_ausl.lvs_lte_platz_bewerten(in_sid,
                                                   in_firma_nr,
                                                   'FIFO',
                                                   'I',
                                                   lte.lte_voll,
                                                   nvl(min(lam.lam_mhd),
                                                       lte.res_mhd),
                                                   trunc(min(lam.prod_datum)),
                                                   lte.lte_id,
                                                   lte.lgr_platz,
                                                   lte.res_string,
                                                   lgr.lgr_platz_gruppe,
                                                   lgr.lgr_typ,
                                                   v_bde_fa.ag_artikel_id)) ausl_sort,
             lvs_ausl.lvs_lte_platz_bewerten(in_sid,
                                             in_firma_nr,
                                             'FIFO',
                                             'I',
                                             lte.lte_voll,
                                             nvl(min(lam.lam_mhd),
                                                 lte.res_mhd),
                                             trunc(min(lam.prod_datum)),
                                             lte.lte_id,
                                             lte.lgr_platz,
                                             lte.res_string,
                                             lgr.lgr_platz_gruppe,
                                             lgr.lgr_typ,
                                             v_bde_fa.ag_artikel_id) ausl_sort2
        from lvs_lte     lte,
             lvs_lam     lam,
             lvs_lgr     lgr,
             isi_artikel a,
             isi_firma   f,
             lvs_lgr     zlgr
       where a.artikel_id = v_bde_fa.ag_artikel_id
         and f.sid = in_sid
         and f.firma_nr = in_firma_nr
         and lte.sid = lam.sid
         and lte.lte_id = lam.lte_id
         and (v_dispo_res_lte_chk = c.C_FALSE or
             nvl(lte.order_vorgang_id, v_bde_fa.leitzahl) = v_bde_fa.leitzahl)
         and ((lte.lte_status like '%F') or
              -- CMe 20220221 (P71141-40): Wenn in Transport Status ist die LTe zulässig, 
              --                           solange v_bde_ausl_ltr_chk_transp 0 'T'
              ((lte.lte_status like '%T' or 
                lte.lte_status like '%D') and
               v_bde_ausl_ltr_chk_transp = 'T') or
              ((lte.lte_status like '%T' or 
                lte.lte_status like '%D') and
               (v_bde_fak.soll_betriebsart = 'JITSEQ' or
                v_bde_fak.soll_betriebsart = 'EXPRESS') and
               nvl(zlgr.lgr_typ, 'XX') != 'DURCHL1' and
               nvl(zlgr.wa_typ, 'XX') in ('BDEPUSH', 'BDEICEPUSH')))
         and lgr.sid = in_sid
         and lgr.lgr_platz = lte.lgr_platz
         and lgr.lgr_typ != 'DURCHL1' -- Durchlauflager mit begrenzten Zugriff
         and (lgr.lgr_verwendung = C.R_Lgr_Typ_Lager or -- Lagertypen und Verwendungstypen erlaubt (Lager)
              lgr.lgr_verwendung = C.R_Lgr_Typ_LagerP or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
              lgr.lgr_verwendung = C.R_LGR_TYP_Puffer or -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
              (lgr.lgr_verwendung = C.R_LGR_TYP_WA and -- Nur WA's wenn der WA_TYP BDEPUSH oder BDEICEPUSH
               lgr.wa_typ in ('BDEPUSH', 'BDEICEPUSH')))
         and lte.ziel_lgr_platz = zlgr.lgr_platz(+)
         and lam.sid = in_sid
         and lam.firma_nr = in_firma_nr
         and lam.artikel_id = v_bde_fa.ag_artikel_id -- Richtigen Artikel waehlen
         --(-CMe-)  Hotfix fuer P70397-880
         --and nvl(lam.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl -- Leitzahl beruecksichtigen
         and (nvl(lam.leitzahl, v_bde_fa.leitzahl) = v_bde_fa.leitzahl or lam.fa_ag is null) -- Leitzahl beruecksichtigen
         and lam.fa_ag is NULL
         and lam.menge > 0 -- Nur wenn Lagermengen vorhanden
         and lam.akt_inventur_id is null -- nur Ware reservieren die nicht in Inventur sind
         and (lgr.wa_typ = 'BDEPUSH' or v_bde_push_q_chk = c.C_FALSE) -- BDE-Push eingestellt auf der Quelle oder ist nich Pflicht
            -- -AG- 2015.05.12 Geaenderte selektirungsparameter Begin
         and lam.labor_status = c.LAB_STAT_F
            -- -AG- 2015.05.12 Neue selektirungsparameter End
         and nvl(lam.charge_id, -1) =
             nvl(v_lams_c.charge_id, nvl(lam.charge_id, -1)) -- Charge Passt?
         and nvl(lam.hersteller_kuerzel_liste, 'Keine') =
             nvl(v_lams_h.hersteller_kuerzel_liste,
                 nvl(lam.hersteller_kuerzel_liste, 'Keine')) -- Hersteller Passt?
         and lam.lam_mhd > trunc(sysdate)
         and lam.order_pos_auf_id is NULL
            --and nvl(lam.order_pos_auf_id, v_bde_fa.auf_id) = v_bde_fa.auf_id
            -- Jetzt noch Prüfen ob KONSI
            -- 2017.09.13 AG Jetzt auch verlängerte Werkbank und Verwendung von Kunden-KONSI-Beständen
            --           Eingebaut für HAG und Verwendung von Rohstoffen, die genau einem Kunden oder Lieferadresse geoeren
         and ((lam.owner_address_id = nvl(v_bde_fa.adress_id, v_bde_fak.adress_id) and -- genau von diesem Kunden
               v_bde_fa.lohn_arbeit = c.C_TRUE) or -- Und Konsi benutzen
              lam.owner_address_id is NULL or -- oder kein Keine KONSI-Ware
              v_bde_check_konsi = c.C_FALSE)
         and lgr.gesperrt = C.LGR_GESPERRT_F
         and lvs_p_lgr_grp_fahrzeuge.chk_lgr_platz_zugriff_ok(lgr.lgr_platz) = c.c_true
         and lgr.akt_inventur_id is null -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
         -- CMe 20210325 Hotfix fuer E70397-596 (V_R_LTE_% PAletten dürfen nicht verwendet werden)
         and lte.lte_id not like 'V_R_LTE_%'
       group by lte.lte_id,
                lte.lte_voll,
                lte.lte_letzte_buchung,
                lam.artikel_id,
                lte.lgr_ort,
                lte.lgr_platz,
                lte.res_string,
                lte.res_mhd,
                lte.order_vorgang_id,
                lgr.lgr_platz_gruppe,
                lgr.lgr_dim_p,
                lgr.lgr_typ,
                lgr.lgr_dim_platz,
                lam.owner_address_id
       order by decode(min(lam.order_pos_auf_id), v_bde_fa.auf_id, 0, 1),
                decode(v_bde_fa.lohn_arbeit,
                       c.C_TRUE,
                       decode(nvl(lam.owner_address_id, 0),
                              nvl(v_bde_fa.adress_id, 0),
                              0,
                              1),
                       0),
                decode(lgr.lgr_typ, c.R_DURCHL1, lgr.lgr_dim_platz, 0) desc,
                decode(lgr.lgr_typ,
                       c.R_DURCHL1,
                       to_number(lte.lte_letzte_buchung),
                       0),
                decode(v_streng_fifo, 'T', min(lam.prod_datum) - sysdate, 0),
                ausl_sort,
                ausl_sort2,
                decode(v_streng_fifo, 'T', min(lam.prod_datum) - sysdate, 0);
    v_lte_lams lvs_lam%rowtype;

    cursor c_lte_lams is
      select *
        from lvs_lam t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = v_lte_id
         and t.order_pos_auf_id = v_bde_fa.auf_id
       order by -- Hier wird sortiert, was bei der Auslagerung nicht berücksichtigt werden soll
                decode(v_streng_fifo,
                       'T',
                       t.prod_datum,
                       trunc(t.prod_datum)) desc,
                -- -AG- Besonderheit volle Beharlter beforzugt abarbeietn ->
                t.lam_id desc;

    CURSOR c_lgr_grp is
      select *
        from lvs_lgr t
       where t.sid = v_lgr.sid
         and t.firma_nr = v_lgr.firma_nr
         and t.lgr_verwendung = 'WA'
         and t.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
         and t.wa_typ = v_wa_type
         and t.lgr_typ = 'DURCHL1'
       order by t.lgr_platz;

    cursor c_lte_lam_res is
      select fa.leitzahl, fa.termin_start_gepl
        from bde_fa_auftrag fa, lvs_lam t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.lte_id = v_lte_id
         and t.order_pos_auf_id = fa.auf_id
       order by fa.termin_start_gepl desc, fa.abnr desc, fa.leitzahl desc;

   --CMe 20220221 (P71141-40): Bei einen Auftrag wo der Zielplatz vom Typ DURCHL1
   --                          muss das bereits reservierte entweder zum selben Auftrag
   --                          oder zum gleichen Batch gehören
    cursor c_fa_auf_res is
      select *
        from bde_fa_auftrag fa
       where (fa.termin_start_gepl >= v_fa_start_gepl or
             (fa.termin_start_gepl is NULL and v_fa_start_gepl is NULL and
             fa.leitzahl >= v_fa_leit_res))
         and fa.res_id = v_bde_fa.res_id
         and exists (select l.order_pos_auf_id
                       from lvs_lam l
                       join bde_fa_auftrag b on b.auf_id = l.order_pos_auf_id
                      where l.lte_id = v_lte_id
                        and (b.auf_id = fa.auf_id or
                             b.abnr = fa.abnr))
       order by fa.termin_start_gepl, fa.abnr, fa.leitzahl;
  begin
    
    -- CMe 20210810 Bugfix: Statement war falsch ausformuliert und ist korrigiert worden
    -- Vorher: Wenn In_Komplett False, dann muss die min Menge gesetzt sein (entspricht nicht dem wie laut Kommentar vorgesehen)
    -- Jetzt: Wenn die min. Menge gesetzt ist, muss in_komplett auf False stehen (entspricht dem wie laut kommentar vorgesehen)
    --if in_komplett != c.C_TRUE and
    --   in_min_res_menge is NULL   -- Fehlerhafter Aufruf der Funktion. Wenn MIN-Menge gesetzt, dann muss Komplett Reserviern False sein
    --then
    --  raise_isi_error(c.FMID_Param_fehlen,
    --                  lc.ec_p1(lc.O_TP1_RES_ERROR,
    --                           v_bde_fa.leitzahl));
    --end if;
   
   if in_min_res_menge is not NULL and
      in_komplett = c.C_TRUE -- Fehlerhafter Aufruf der Funktion. Wenn MIN-Menge gesetzt, dann muss Komplett Reserviern False sein
    then
      raise_isi_error(c.FMID_Param_fehlen,
                      lc.ec_p1(lc.O_TP1_RES_ERROR,
                               v_bde_fa.leitzahl));
    end if;

    -- - AG - 20211020 - Neuer Scahleter CHECK-KONSI - Default T = Pürfen
    v_bde_check_konsi := isi_allg.c_get_firma_cfg_param(in_sid,
                                                        in_firma_nr,
                                                        'BDE_CHECK',
                                                        'KONSI',
                                                        'BDE_CHECK_KONSI',
                                                        'BDE',
                                                        'CFG',
                                                        'T',
                                                        'BOOLEAN');

    -- CMe 20210810 Ende
    v_streng_fifo := isi_allg.get_firma_cfg_param(in_sid,
                                                  in_firma_nr,
                                                  'AUSL_STRAT',
                                                  null,
                                                  'STRENG_FIFO',
                                                  'LVS',
                                                  'CFG',
                                                  'F',
                                                  'BOOLEAN');

    v_bde_push_q_chk := isi_allg.get_firma_cfg_param(in_sid,
                                                     in_firma_nr,
                                                     'AUSL_BDE_PUSH',
                                                     'RES',
                                                     'BDE_AUSL_QPLATZ_PUSH_SET',
                                                     'BDE',
                                                     'CFG',
                                                     'F',
                                                     'BOOLEAN');

    -- 20180203 AG Erweiterung, LTE,s im BDE nur mit einem FA reservieren über pruefen reserviernung
    -- Soll geprüft werden, ob Reservierungen auf der LTE sind
    -- F = NICHT PRUEFEN - Es dürfen Reservierungen auf der LTE sein
    -- T = PRUEFEN - Es dürfen KEINE Reservierungen auf der LTE sein
    v_dispo_res_lte_chk := isi_allg.get_firma_cfg_param(in_sid,
                                                        in_firma_nr,
                                                        'AUSL_BDE_PUSH',
                                                        'RES',
                                                        'BDE_AUSL_LTE_CHK_DISPO',
                                                        'BDE',
                                                        'CFG',
                                                        'F',
                                                        'BOOLEAN');

    -- CMe 20220221 (P71141-40) Prüfen ob auf der LTE auch reserviert werden kann, wenn sie im Transport ist
    -- F = LTE darf nicht im Transport sein
    -- T = LTE darf im Transport sein
    v_bde_ausl_ltr_chk_transp := isi_allg.get_firma_cfg_param(in_sid,
                                                              in_firma_nr,
                                                              'AUSL_BDE_PUSH',
                                                              'RES',
                                                              'BDE_AUSL_LTE_CHK_TRANSP',
                                                              'BDE',
                                                              'CFG',
                                                              'F',
                                                              'BOOLEAN');
                                                              
    OPEN c_bde_fa;
    LOOP
      fetch c_bde_fa
        into v_bde_fa;
      exit when c_bde_fa%notfound;

      OPEN c_bde_fak;
      FETCH c_bde_fak
        into v_bde_fak;
      CLOSE c_bde_fak;

      v_prod_params := NULL;
      OPEN c_art_grp;
      FETCH c_art_grp
        into v_prod_params;
      CLOSE c_art_grp;
      v_dispo := v_prod_params like ('%ROH_DISPO=T;%');

      -- CMe 20200729: v_dispo ignorieren wenn in_min_res_menge not null und größer
      --               0 ist (P70397-849).
      if (nvl(v_bde_fa.ma_reserviert, c.C_FALSE) = c.C_FALSE or
         nvl(v_bde_fa.ma_res_menge, 0) < v_bde_fa.ag_soll_mg) and
         (v_dispo or (in_min_res_menge is not null and in_min_res_menge > 0)) then

        OPEN c_bde_fa_v;
        fetch c_bde_fa_v
          into v_res_roh_platz;
        CLOSE c_bde_fa_v;

        v_lams_a := NULL;
        v_lams_h := NULL;
        v_lams_c := NULL;
        if in_dispo_charge_rein = c.C_TRUE then
          OPEN c_lams_c;
          FETCH c_lams_c
            into v_lams_c;
          v_found := c_lams_c%FOUND;
          CLOSE c_lams_c;
        elsif in_dispo_charge_rein = 'H' or
              in_dispo_charge_rein = 'HERSTELLERVORGABE' then
          if in_hersteller_liste <> ';' then
            v_hersteller_liste := ';' || in_hersteller_liste;
          else
            v_hersteller_liste := NULL;
          end if;
          OPEN c_lams_h;
          FETCH c_lams_h
            into v_lams_h;
          v_found := c_lams_h%FOUND;
          CLOSE c_lams_h;
        else
          OPEN c_lams_a;
          FETCH c_lams_a
            into v_lams_a;
          v_found := c_lams_a%FOUND;
          CLOSE c_lams_a;
        end if;

        v_check_seq_res := False; -- Reihenfolgen und Reservierung aufgrund Ziel nicht pruefen

        if isi_p_base.get_resource(in_sid, v_bde_fa.res_id, v_res) then
          if lvs_p_base.get_lgr_platz(v_res.lager_roh, v_lgr) then
            if in_ICE = c.C_TRUE or v_bde_fak.soll_betriebsart = 'JITSEQ' then
              v_wa_type := 'BDEICEPUSH';
            else
              v_wa_type := 'BDEPUSH';
            end if;
            OPEN c_lgr_grp;
            fetch c_lgr_grp
              into v_lgr_grp;
            v_check_seq_res := c_lgr_grp%FOUND;
            CLOSE c_lgr_grp;

            -- Wenn der Ziellagertyp = DURCHL (Durchlagern mit reduzierten Zugriff)
            -- Dann muss die LTE auf Reservierungn gepueft werden.

          end if;
        end if;

        if not v_found then
          if v_bde_fa.ma_reserviert = c.C_TRUE then
            return;
          else
            raise_isi_error(c.FMID_Bestand_reicht_nicht,
                            lc.ec_p3(lc.O_TP3_BESTANDS_MG_FEHLT_BDE,
                                     v_bde_fa.leitzahl,
                                     v_bde_fa.fa_ag,
                                     v_bde_fa.fa_upos));
          end if;
        end if;

        v_menge_sum := 0;

        OPEN c_ltes;
        LOOP
          FETCH c_ltes
            into v_lte_id,
                 v_lte_lgr_ort,
                 v_lte_lgr_platz,
                 v_menge,
                 v_sort,
                 v_sort2;
          EXIT when c_ltes%NOTFOUND;
          v_lte_res_ok := true; -- Erst mal darf in der LTE reserviert werden
          
          open c_get_lgr_gruppe_fa;
          fetch c_get_lgr_gruppe_fa into v_lgr_gruppe_fa;
          close c_get_lgr_gruppe_fa;
          
          if v_check_seq_res -- Wir fahren zu einem Ziel, dass Durchlauf-Lager ist STRENG FIFO mit reduzierten Zugriff auf Ware
           then
            OPEN c_lte_lam_res;
            FETCH c_lte_lam_res
              into v_fa_leit_res, v_fa_start_gepl; -- Höchste Leitzahl oder Start geplant aus den Reservierungen der LTE
            v_found := c_lte_lam_res%FOUND;
            CLOSE c_lte_lam_res;

            if v_found -- LTE hat Reservierung
             then
              v_lte_res_ok := false; -- Erst mal darf in der LTE nicht reserviert werden

              OPEN c_fa_auf_res;
              FETCH c_fa_auf_res
                into v_bde_fa_res; -- Das ist der in der Reihenfolge letzte Auftrag aus der LTE-Reservierung
              if c_fa_auf_res%FOUND then
                LOOP
                --CMe 20220221 (P71141-40): Bei einen Auftrag wo der Zielplatz vom Typ DURCHL1
                --                          muss das bereits reservierte entweder zum sleben Auftrag
                --                          oder zum gleichen Batch gehören
                  FETCH c_fa_auf_res
                    into v_bde_fa_res; 
                  v_found := c_fa_auf_res%FOUND;
                  exit when not v_found or v_bde_fa_res.leitzahl != v_fa_leit_res;
                end loop;
                if (v_bde_fa_res.leitzahl = v_bde_fa.leitzahl) or
                   (v_bde_fa_res.abnr = v_bde_fa.abnr) or
                   (not v_found) then
                  -- CMe 20220221 (P71141-40) Auch hier die Transporte berücksichtigen
                  open c_get_transport;
                  fetch c_get_transport into v_lte_transport;
                  v_found := c_get_transport%found;
                  close c_get_transport;
                  
                  v_lte_dispo_ziele := get_lte_dipo_ziele(in_sid => v_bde_fa.sid,
                                                          in_firma_nr => v_bde_fa.firma_nr,
                                                          in_lte_id => v_lte_id);
                  
                  if (v_found) and
                     (v_bde_ausl_ltr_chk_transp = 'T') and
                     (v_lte_dispo_ziele = v_lgr_gruppe_fa) then
                     v_lte_res_ok := true; -- LTE reserviert werden
                  end if;
                end if;
              end if;
              CLOSE c_fa_auf_res;
            end if;
          -- CMe 20220221 (P71141-40) Bei Paletten die nicht in ein Durchlauflager gehen prüfen
          -- ob der FA die selbe Lagergruppe als ziel hat wie der anliegende Transport
          else
            open c_get_transport;
            fetch c_get_transport into v_lte_transport;
            v_found := c_get_transport%found;
            close c_get_transport;
            
            if (v_found) then
              v_lte_res_ok := false; -- Erst mal darf in der LTE nicht reserviert werden
              
              v_lte_dispo_ziele := get_lte_dipo_ziele(in_sid => v_bde_fa.sid,
                                                      in_firma_nr => v_bde_fa.firma_nr,
                                                      in_lte_id => v_lte_id);
              if (v_bde_ausl_ltr_chk_transp = 'T') and
                 (v_lte_dispo_ziele = v_lgr_gruppe_fa) then
                 v_lte_res_ok := true;
              end if;
            end if;
          end if;

          if v_lte_res_ok then

            v_menge_sum := v_menge_sum + nvl(v_menge, 0); -- Gefundene Menge addieren

            OPEN c_lte;
            FETCH c_lte
              into v_lte;
            v_found := c_lte%FOUND;
            CLOSE c_lte;
            if not v_found then
              v_err_nr   := 10;
              v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, v_lte_id);
              raise v_error;
            end if;

            v_result := lvs_ausl.lvs_lte_reserv_user_ziel(in_sid,
                                                          in_firma_nr,
                                                          v_bde_fa.leitzahl,
                                                          v_bde_fa.auf_id,
                                                          v_lte_id,
                                                          v_bde_fa.ag_artikel_id,
                                                          in_user_id,
                                                          v_res_roh_platz);

            -- Es soll nicht die ganze lte reserviert werden, also Teilreservierungen auf LHMs
            -- zuviel reservierte LAMs zurücksetzen
            v_delta_menge := v_menge_sum - (v_bde_fa.ag_soll_mg -
                             nvl(v_bde_fa.ma_res_menge, 0));
            if v_delta_menge > 0 then

              open c_lte_lams;
              loop
                fetch c_lte_lams
                  into v_lte_lams;
                exit when c_lte_lams%notfound;

                if v_lte_lams.order_pos_auf_id = v_bde_fa.auf_id then
                  if v_delta_menge > 0 then
                    if v_lte_lams.res_menge <= v_delta_menge then
                      -- ganze LAM aus der reservierung rausnehmen
                      update lvs_lam t
                         set t.order_pos_auf_id = null,
                             t.res_menge        = null,
                             t.res_ziel_lte_id  = null,
                             t.res_login_id     = NULL
                       where t.sid = v_lte_lams.sid
                         and t.firma_nr = v_lte_lams.firma_nr
                         and t.lam_id = v_lte_lams.lam_id;

                      v_menge     := v_menge - v_lte_lams.menge;
                      v_menge_sum := v_menge_sum - v_lte_lams.menge;
                    else
                      -- nur Teilmenge reserviert lassen (für spätere kommissionierung)
                      update lvs_lam t
                         set t.res_menge    = v_lte_lams.menge -
                                              v_delta_menge,
                             t.res_login_id = in_user_id
                       where t.sid = v_lte_lams.sid
                         and t.firma_nr = v_lte_lams.firma_nr
                         and t.lam_id = v_lte_lams.lam_id;
                      v_lte_lams.res_menge := v_lte_lams.menge -
                                              v_delta_menge;
                      v_menge              := v_menge - (v_lte_lams.menge -
                                              v_delta_menge);
                      v_menge_sum          := v_menge_sum - v_delta_menge;
                      create_new_lam_f_rest(in_sid, -- in isi_sid.sid%type,
                                            in_firma_nr, -- in isi_firma.firma_nr%type,
                                            v_lte_lams, -- in lvs_lam%rowtype,
                                            in_user_id); -- in isi_user.login_id%type)
                    end if;
                    if v_menge = 0 -- Von dieser Palette ist nichts mehr Reserviert
                     then
                      v_result := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                                             in_firma_nr,
                                                             v_bde_fa.leitzahl,
                                                             v_bde_fa.auf_id,
                                                             v_lte.lte_id,
                                                             v_bde_fa.leitzahl,
                                                             v_lte.lgr_platz,
                                                             c.c_true);
                    end if;
                  end if;
                end if;
                -- neu berechnen, was zuviel ist
                v_delta_menge := v_menge_sum -
                                 (v_bde_fa.ag_soll_mg -
                                 nvl(v_bde_fa.ma_res_menge, 0));
              end loop;
              close c_lte_lams;

            end if;
          end if;
          EXIT when v_menge_sum >=(v_bde_fa.ag_soll_mg -
                                   nvl(v_bde_fa.ma_res_menge, 0))
                 or v_menge_sum >= in_min_res_menge; -- Fertig wenn Menge erreicht
        end LOOP;
        CLOSE c_ltes;

        if in_komplett = c.C_TRUE and
           v_menge_sum <
           (v_bde_fa.ag_soll_mg - nvl(v_bde_fa.ma_res_menge, 0)) then
          raise_isi_error(c.FMID_Bestand_reicht_nicht,
                          lc.ec_p3(lc.O_TP3_BESTANDS_MG_FEHLT_BDE,
                                   v_bde_fa.leitzahl,
                                   v_bde_fa.fa_ag,
                                   v_bde_fa.fa_upos));
        end if;

        -- Hersteller oder Rohcharge im MA-Satz hinterlegen
        update bde_fa_auftrag fa
           set fa.ma_reserviert               = 'T',
               fa.ma_res_menge                = nvl(fa.ma_res_menge, 0) +
                                                v_menge_sum,
               fa.ma_res_charge_id            = v_lams_c.charge_id,
               fa.ma_hersteller_kuerzel_liste = v_lams_h.hersteller_kuerzel_liste
         where fa.sid = v_bde_fa.sid
           and fa.firma_nr = v_bde_fa.firma_nr
           and fa.leitzahl = v_bde_fa.leitzahl
           and fa.fa_ag = v_bde_fa.fa_ag
           and fa.fa_upos = v_bde_fa.fa_upos;

      end if;
    end LOOP;
    CLOSE c_bde_fa;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then
      -- Update 2011 show Exception Source Line
      if c_bde_fa%isopen then
        CLOSE c_bde_fa;
      end if;
      v_err_text := v_err_text || CHR(13) || CHR(10) ||
                    DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_bde_fa%isopen then
        CLOSE c_bde_fa;
      end if;
      if v_err_nr is not NULL then
        v_err_text := v_err_text || CHR(13) || CHR(10) ||
                      DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%' then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) ||
                        DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end;

  procedure create_new_lam_f_rest(in_sid      in isi_sid.sid%type,
                                  in_firma_nr in isi_firma.firma_nr%type,
                                  in_lam      in lvs_lam%rowtype,
                                  in_user_id  in isi_user.login_id%type) is

    v_art_ctrl   isi_artikel_ctrl%rowtype;
    v_typ        varchar2(10);
    v_hersteller isi_hersteller%rowtype; -- Daten aus isi-Hersteller
    v_h_tag      isi_hersteller.tag%type;
    v_lhm_id     lvs_lam.lhm_id%type; -- Neu LHM Karton ID
    v_charge     lvs_charge%rowtype;
    v_art        isi_artikel%rowtype;

    v_lam_id    lvs_lam.lam_id%type; -- Neu LAM_ID aus Sequenz
    v_lam_bh_id lvs_lam_bh.lam_bh_id%type; -- Neu LAM_BH_ID aus Sequenz
    v_vorg_id   lvs_lam_bh.vorg_id%type; -- Neu VORGang_ID aus Sequenz

    v_lam_bh_kg         lvs_lam_bh.lam_bh_id%type; -- Gewicht der Wahre
    v_lam_bh_kg_einheit lvs_lam_bh.lam_bh_kg_einheit%type; -- Gewicht der eine Wahre

    CURSOR c_charge is
      select t.* from lvs_charge t where t.charge_id = in_lam.charge_id;

  begin
    OPEN c_charge;
    FETCH c_charge
      into v_charge;
    CLOSE c_charge;

    if not isi_p_base.get_isi_artikel(in_sid, in_lam.artikel_id, v_art) then
      v_art.artikel_fuer_kunde_etikett := NULL;
    end if;

    if in_lam.hersteller_kuerzel_liste is not NULL and
       in_lam.hersteller_kuerzel_liste != ';' and
       isi_p_base.get_artikel_ctrl_typ(in_lam.sid,
                                       in_lam.artikel_id,
                                       substr(in_lam.hersteller_kuerzel_liste,
                                              1,
                                              length(in_lam.hersteller_kuerzel_liste) - 1),
                                       v_art_ctrl) then
      v_typ := v_art_ctrl.prod_params;
    else
      v_typ := '0000000000';
    end if;

    if in_lam.hersteller_kuerzel_liste is not NULL and
       in_lam.hersteller_kuerzel_liste != ';' and
       isi_p_base.get_hersteller(substr(in_lam.hersteller_kuerzel_liste,
                                        1,
                                        length(in_lam.hersteller_kuerzel_liste) - 1),
                                 v_hersteller) then
      v_h_tag := v_hersteller.tag;
    else
      v_h_tag := rpad('0', 20, '0');
    end if;

    v_lhm_id := lvs_p_lte.lvs_lte_lhm_next_id_v35(in_lam.sid,
                                                  in_lam.firma_nr,
                                                  c.BASIS_LHM,
                                                  v_charge.charge_bez,
                                                  in_lam.artikel_id,
                                                  v_art.artikel_fuer_kunde_etikett,
                                                  v_typ,
                                                  v_h_tag);

    insert into lvs_lhm
      select in_sid,
             in_firma_nr,
             v_lhm_id,
             in_lam.lte_id,
             l.lhm_name, -- man könnte auch in einen neuen LHM typ kommissionieren
             in_lam.lgr_platz,
             l.lhm_vol_hoehe,
             l.lhm_vol_breite,
             l.lhm_vol_tiefe,
             l.lhm_vol,
             0,
             l.lhm_letzte_buchung,
             l.lhm_eti_druck_status, -- ??? -WK- ist das richtig, einfach übernehmen? evtl. 'SD' weil ja ein neues LHM angelegt wird. Wo wird das Etikett gedruckt?
             NULL, -- abkommissioniert von LTE ID
             NULL, -- abkommissioniert am Lagerplatz
             null
        from lvs_lhm l
       where l.lhm_id = in_lam.lhm_id;

    v_err_nr   := 40;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam.nextval into v_lam_id from dual;
    -- Gewicht und Menge wird im Trigger LAM_BH gesetzt
    -- -AG- 06.09.2010 Erweiterung LFDN in der Charge
    insert into lvs_lam
    values
      (in_lam.sid, -- SID                 VARCHAR2(2) not null,
       in_lam.firma_nr, -- FIRMA_NR            NUMBER(2) not null,
       v_lam_id, -- LAM_ID              NUMBER not null,
       in_lam.artikel_id, -- ARTIKEL_ID          NUMBER,
       in_lam.lgr_platz, -- LGR_PLATZ           VARCHAR2(30),
       in_lam.lte_id, -- LTE_ID              VARCHAR2(19),
       v_lhm_id, -- LHM_ID              VARCHAR2(19),
       in_lam.charge_id, -- CHARGE_ID           NUMBER,
       in_lam.serie_id, -- SERIE_ID            NUMBER,
       in_lam.leitzahl, -- LEITZAHL            NUMBER,
       in_lam.fa_ag, -- FA_AG               NUMBER,
       in_lam.fa_upos, -- FA_UPOS             NUMBER,
       in_lam.abnr, -- ABNR                VARCHAR2(20),
       NULL, -- BEST_NR             VARCHAR2(20),
       NULL, -- BEST_POS            VARCHAR2(5),
       in_lam.res_id, -- RES_ID              NUMBER,
       in_lam.prod_datum, -- PROD_DATUM          DATE,
       in_lam.zug_datum, -- ZUG_DATUM           DATE,
       in_lam.ls_login_id, -- LS_LOGIN_ID         NUMBER,
       0, -- MENGE               NUMBER,
       0, -- LAM_KG              NUMBER,
       in_lam.lam_text, -- LAM_TEXT            VARCHAR2(20),
       in_lam.labor_status, -- LABOR_STATUS        CHAR(1),
       in_lam.labor_text, -- LABOR_TEXT          VARCHAR2(30),
       in_lam.lam_mhd, -- LAM_MHD             DATE,
       in_lam.kunden_nr, -- KUNDEN_NR           VARCHAR2(10),
       in_lam.kd_art_nr, -- KD_ART_NR           VARCHAR2(30),
       in_lam.lieferant_nr, -- LIEFERANT_NR        VARCHAR2(10),
       in_lam.lam_mhd_ausgabe, -- LAM_MHD_AUSGABE     DATE,
       in_lam.menge_basis, -- MENGE_BASIS         VARCHAR2(3) default 'LKE' not null,
       in_lam.mengeneinheit_basis, -- MENGENEINHEIT_BASIS VARCHAR2(10) default 'STK' not null,
       NULL, -- ORDER_POS_AUF_ID    NUMBER
       in_lam.zeichnung,
       in_lam.zeichnung_index,
       in_lam.li_nr_lief,
       in_lam.lte_id_lieferant,
       in_lam.sonst_id_lieferant,
       in_lam.akt_inventur_id,
       in_lam.letzte_inventur_id,
       in_lam.letzte_inventur_datum,
       in_lam.letzte_inventur_login_id,
       in_lam.lam_p1,
       in_lam.lam_p2,
       in_lam.lam_p3,
       in_lam.lam_p4,
       in_lam.lam_p5,
       in_lam.lam_p6,
       in_lam.lam_p7,
       in_lam.lam_p8,
       in_lam.lam_p9,
       in_lam.lam_p10,
       0,
       NULL,
       in_lam.res_login_id,
       in_lam.check_ware_transp_id,
       in_lam.fae_id,
       in_lam.fae_id_position,
       in_lam.qs_status,
       in_lam.waren_typ,
       in_lam.lhm_lfd_nr,
       lvs_komm.get_packschema_kopf_id(in_sid, in_firma_nr, in_lam.lte_id),
       lvs_komm.get_packschema_lfdn(in_sid, in_firma_nr, in_lam.lte_id),
       in_lam.lhm_c_lfd_nr,
       in_lam.owner_address_id, -- Besitzer wird aus der LAM übernommen
       in_lam.lam_sel1, -- LAM_SEL1  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel2, -- LAM_SEL2  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel3, -- LAM_SEL3  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel4, -- LAM_SEL4  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel5, -- LAM_SEL5  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel6, -- LAM_SEL6  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel7, -- LAM_SEL7  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel8, -- LAM_SEL8  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel9, -- LAM_SEL9  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.lam_sel10, -- LAM_SEL10  N  VARCHAR2(15)  Y      Parameter zusätzliche Selectionsparameter
       in_lam.hersteller_kuerzel_liste,
       in_lam.nr_pruefung);

    v_err_nr   := 50;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_vorg_id.nextval into v_vorg_id from dual;
    v_err_nr := NULL;

    begin
      if (nvl(in_lam.menge, 0) <> 0) then
        v_lam_bh_kg         := (nvl(in_lam.lam_kg, 0) *
                               nvl(in_lam.menge - in_lam.res_menge, 0)) /
                               nvl(in_lam.menge, 0);
        v_lam_bh_kg_einheit := nvl(in_lam.lam_kg, 0) / nvl(in_lam.menge, 0);
      else
        v_lam_bh_kg         := 0;
        v_lam_bh_kg_einheit := 0;
      end if;
    exception
      when others then
        v_lam_bh_kg         := 0;
        v_lam_bh_kg_einheit := 0;
    end;
    v_err_nr   := 60;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam_bh.nextval into v_lam_bh_id from dual;
    v_err_nr := NULL;
    -- Abgangsbuchungen
    insert into lvs_lam_bh
    values
      (in_sid, -- SID               VARCHAR2(2) not null,
       in_firma_nr, -- FIRMA_NR          NUMBER(2) not null,
       v_vorg_id, -- VORG_ID           NUMBER not null,
       c.LAM_BH_ABGAGNG, -- VORG_TYP          VARCHAR2(2) not null,
       v_lam_bh_id, -- LAM_BH_ID         NUMBER not null,
       in_lam.lam_id, -- LAM_ID            NUMBER not null,
       in_lam.artikel_id, -- ARTIKEL_ID        NUMBER,
       c.LAM_BH_BUS_ABG_KOMM, -- BUS               NUMBER,
       sysdate, -- BUCH_DATUM        DATE,
       in_user_id, -- LS_LOGIN_ID       NUMBER,
       in_lam.lgr_platz, -- LGR_PLATZ         VARCHAR2(30),
       in_lam.lte_id, -- LTE_ID            VARCHAR2(19),
       in_lam.lhm_id, -- LHM_ID            VARCHAR2(19),
       in_lam.charge_id, -- CHARGE_ID         NUMBER,
       in_lam.serie_id, -- SERIE_ID          NUMBER,
       NULL, -- ABNR              VARCHAR2(20),
       nvl(in_lam.menge - in_lam.res_menge, 0),
       -- MENGE             NUMBER,
       v_lam_bh_kg, -- LAM_BH_KG         NUMBER,
       v_lam_bh_kg_einheit, -- LAM_BH_KG_EINHEIT NUMBER,
       NULL, -- RES_ID            NUMBER
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       sysdate, -- CREATED_DATE          creation date+time of this dataset
       in_user_id, -- CREATED_LOGIN_ID      login id of the user creating this dataset
       sysdate, -- LAST_CHANGE_DATE      change date+time of this dataset
       in_user_id, -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
       null, -- CHANGE_MENGE          Menge die geändert wurde
       in_lam.owner_address_id, -- OWNER_ADDRESS_ID      Aktueller Eigentümer
       null); -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer
    -- Zugang in der gleichen Palette
    v_err_nr   := 60;
    v_err_text := LC.ec(LC.O_TXT_SEQ_ERR);
    select seq_lam_bh.nextval into v_lam_bh_id from dual;
    v_err_nr := NULL;
    insert into lvs_lam_bh
    values
      (in_sid, -- SID               VARCHAR2(2) not null,
       in_firma_nr, -- FIRMA_NR          NUMBER(2) not null,
       v_vorg_id, -- VORG_ID           NUMBER not null,
       c.LAM_BH_ZUGAGNG, -- VORG_TYP          VARCHAR2(2) not null,
       v_lam_bh_id, -- LAM_BH_ID         NUMBER not null,
       v_lam_id, -- LAM_ID            NUMBER not null,
       in_lam.artikel_id, -- ARTIKEL_ID        NUMBER,
       c.LAM_BH_BUS_ZUG_KOMM, -- BUS               NUMBER,
       sysdate, -- BUCH_DATUM        DATE,
       in_user_id, -- LS_LOGIN_ID       NUMBER,
       in_lam.lgr_platz, -- LGR_PLATZ         VARCHAR2(30),
       in_lam.lte_id, -- LTE_ID            VARCHAR2(19),
       v_lhm_id, -- LHM_ID            VARCHAR2(19),
       in_lam.charge_id, -- CHARGE_ID         NUMBER,
       in_lam.serie_id, -- SERIE_ID          NUMBER,
       null, -- ABNR              VARCHAR2(20),
       nvl(in_lam.menge - in_lam.res_menge, 0),
       -- MENGE             NUMBER,
       v_lam_bh_kg, -- LAM_BH_KG         NUMBER,
       v_lam_bh_kg_einheit, -- LAM_BH_KG_EINHEIT NUMBER,
       NULL, -- RES_ID            NUMBER
       null,
       null,
       null,
       null,
       null,
       null,
       null,
       sysdate, -- CREATED_DATE          creation date+time of this dataset
       in_user_id, -- CREATED_LOGIN_ID      login id of the user creating this dataset
       sysdate, -- LAST_CHANGE_DATE      change date+time of this dataset
       in_user_id, -- LAST_CHANGE_LOGIN_ID  login id of the user changing this dataset
       null, -- CHANGE_MENGE          Menge die geändert wurde
       in_lam.owner_address_id, -- OWNER_ADDRESS_ID      Aktueller Eigentümer
       null); -- OWNER_ADDRESS_ID_NEW  Neuer Eigentümer

  end;

  procedure storno_bde_fa_dispo(in_sid      in isi_sid.sid%type,
                                in_firma_nr in isi_firma.firma_nr%type,
                                in_leitzahl in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag    in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos  in bde_fa_auftrag.fa_upos%type,
                                in_user_id  in isi_user.login_id%type) is
    v_bde_fa bde_fa_auftrag%rowtype;
    v_found  boolean;
    v_result number;

    v_lte_id lvs_lte.lte_id%type;

    CURSOR c_lam_lte_id is
      select l.lte_id
        from lvs_lam l
       where l.order_pos_auf_id = v_bde_fa.auf_id
       group by l.lte_id;

    CURSOR c_bde_fa is
      select *
        from bde_fa_auftrag fa
       where fa.sid = in_sid
         and fa.firma_nr = in_firma_nr
         and fa.leitzahl = in_leitzahl
         and nvl(fa.fa_ag, in_fa_ag) = fa.fa_ag
         and nvl(fa.fa_upos, in_fa_upos) = fa.fa_upos
         and fa.satzart = 'MA'
       order by fa.leitzahl, fa.fa_ag, fa.fa_upos;
  begin

    OPEN c_bde_fa;
    LOOP
      fetch c_bde_fa
        into v_bde_fa;
      exit when c_bde_fa%notfound;

      OPEN c_lam_lte_id;
      LOOP
        FETCH c_lam_lte_id
          into v_lte_id;
        EXIT when c_lam_lte_id%notfound;
        v_result := lvs_ausl.lvs_lte_res_rueck(in_sid,
                                               in_firma_nr,
                                               v_bde_fa.leitzahl,
                                               v_bde_fa.auf_id,
                                               v_lte_id,
                                               v_bde_fa.leitzahl,
                                               v_bde_fa.auf_id,
                                               c.C_TRUE);
      end LOOP;
      CLOSE c_lam_lte_id;

      update bde_fa_auftrag fa
         set fa.ma_reserviert               = 'F',
             fa.ma_res_menge                = 0,
             fa.ma_res_charge_id            = case when fa.ma_res_charge_id is not NULL
                                                   then 0
                                                   else NULL
                                                   end,
             fa.ma_hersteller_kuerzel_liste = NULL
       where fa.sid = v_bde_fa.sid
         and fa.firma_nr = v_bde_fa.firma_nr
         and fa.leitzahl = v_bde_fa.leitzahl
         and fa.fa_ag = v_bde_fa.fa_ag
         and fa.fa_upos = v_bde_fa.fa_upos;
    end LOOP;
    CLOSE c_bde_fa;

  end;

  --------------------------------------------------------------------------------
  -- Funktion Gibt true zurück, wenn der eingegeben Fertigungsauftrag gelöscht
  -- werden darf
  --------------------------------------------------------------------------------

  function check_bde_fa_for_delete(in_sid          in pe_drucker_cfg.sid%type,
                                   in_firma_nr     in pe_drucker_cfg.firma_nr%type,
                                   in_leitzahl     in bde_fa_auftrag.leitzahl%type,
                                   out_anz_bde_beg out number)
                                   return boolean is
    v_result         boolean;
    v_anz_bde_beg    number;
    v_anz_transporte number;

    CURSOR c_bde_begonnen is
      select nvl(count(t.freig_status),0)
        from bde_fa_auftrag t
       where t.sid = in_sid
         and t.firma_nr = in_firma_nr
         and t.leitzahl = in_leitzahl
         and t.freig_status != 'N';
    CURSOR c_transporte is
      select nvl(count(trans.lte_id),0)
        from bde_fa_auftrag fa
        join isi_transport trans on trans.auf_id = fa.auf_id
       where fa.sid = in_sid
         and fa.firma_nr = in_firma_nr
         and fa.leitzahl = in_leitzahl;
  begin
    v_result := true;
    out_anz_bde_beg := 0;

    OPEN c_bde_begonnen;
    FETCH c_bde_begonnen into v_anz_bde_beg;
    CLOSE c_bde_begonnen;

    out_anz_bde_beg := v_anz_bde_beg;

    if v_anz_bde_beg > 0 then
      v_result := false;
    else
      OPEN c_transporte;
      FETCH c_transporte into v_anz_transporte;
      CLOSE c_transporte;

      out_anz_bde_beg := v_anz_transporte;

      if v_anz_transporte > 0 then
        v_result := false;
      end if;
    end if;
    return(v_result);
  end;
  
  --------------------------------------------------------------------------------
  -- Funktion Gibt die Ziele (Lagerplazgruppe) der anforderten Resource zurück
  --------------------------------------------------------------------------------

  function get_lte_dipo_ziele(in_sid          in lvs_lte.sid%type,
                              in_firma_nr     in lvs_lte.firma_nr%type,
                              in_lte_id       in lvs_lte.lte_id%type)
                              return varchar2 is
                              
    v_result         varchar2(4096);
    
    CURSOR c_get_lte_dispo_ziel is
      select stradd_distinct (lgr_platz_gruppe) from
      (
        select lgr.lgr_platz_gruppe
          from lvs_lte lte,
               lvs_lam lam,
               lvs_lgr lgr,
               isi_resource rg,
               bde_fa_auftrag fa
         where 1=1
           and lte.lte_id = in_lte_id
           and lam.lte_id = lte.lte_id
           and fa.auf_id = lam.order_pos_auf_id
           and fa.res_id = rg.res_id
           and rg.typ = 'MPG' -- Produktionsgruppe von Maschinen
           and not exists (select *
                             from isi_resource r,
                                  lvs_lgr ms_lgr
                            where r.gruppe = rg.gruppe
                              and r.typ = 'MS'
                              and ms_lgr.lgr_platz = r.lager_roh
                              and ms_lgr.lgr_platz_gruppe !=  lgr.lgr_platz_gruppe)
           and lgr.lgr_platz = rg.lager_roh
        UNION all
        select lgr.lgr_platz_gruppe
          from lvs_lte lte,
               lvs_lam lam,
               lvs_lgr lgr,
               isi_resource r,
               bde_fa_auftrag fa
         where 1=1
           and lte.lte_id = in_lte_id
           and lam.lte_id = lte.lte_id
           and fa.auf_id = lam.order_pos_auf_id
           and fa.res_id = r.res_id
           and r.typ = 'MS'
           and lgr.lgr_platz = r.lager_roh
    );
        
  begin
    OPEN c_get_lte_dispo_ziel;
    FETCH c_get_lte_dispo_ziel into v_result;
    CLOSE c_get_lte_dispo_ziel;
    return (v_result);
  end;
  
end pps_p_bde_new;
/



-- sqlcl_snapshot {"hash":"83528a4f8cedbff6ec6506fe13461782e9b7d79d","type":"PACKAGE_BODY","name":"PPS_P_BDE_NEW","schemaName":"DIRKSPZM32","sxml":""}