create or replace 
package DIRKSPZM32.bde_p_pps is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-HJG-)  07.04.2005
  __________________________________________________
  Description
  PPS Funktionen für die Erzeugung von BDE Daten
             und PPS Daten aus Plandaten
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  *            3.4.4.1     (-HJG-)  Package erstellt
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

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
                                           in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type);

   procedure c_create_bde_fa_auftrag_a_pps (in_sid            in isi_sid.sid%type,
                                           in_firma_nr       in isi_firma.firma_nr%type,
                                           in_plan_auf_id    in pps_plan_auftrag.plan_auf_id%type,
                                           in_login_id       in isi_user.login_id%type);

   procedure create_bde_fa_auf_a_plan_dispo (in_sid               in isi_sid.sid%type,
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
                                             in_dispo_charge_rein in varchar2,      -- T = Chargenrein, H = Herstellerrein, F oder NULL Nur nach FIFO
                                             in_out_leitzahl      in out bde_fa_auftrag.leitzahl%type);

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
                                           in_out_leitzahl     in out bde_fa_auftrag.leitzahl%type);

  function get_pps_ruestmatrix_opt_grp(in_sid              in isi_sid.sid%type,
                                       in_firma_nr         in isi_firma.firma_nr%type,
                                       in_opt_grp          in pps_ruestmatrix_opt_grp.opt_grp%type,
                                       out_opt_grp        out pps_ruestmatrix_opt_grp%rowtype) return boolean;


end bde_p_pps;
/



-- sqlcl_snapshot {"hash":"875c4c442f13eed60291df49a612092af399e3de","type":"PACKAGE_SPEC","name":"BDE_P_PPS","schemaName":"DIRKSPZM32","sxml":""}