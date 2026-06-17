create or replace 
package DIRKSPZM32.lvs_p_lte_lhm is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  24.05.2004 09:24:58
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  14.07.2008   3.4.4.1A    (-BW-)   MHD_BERECHNUNG BEI 'ME' mit Uhrzeit
	##.##.####   3.3.4.1              BugFix beim Aufpacken Zeil LTE-Hoehe war NULL
	##.##.####   3.3.4.0              Versionierung Erstellt
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  function lvs_lte_lhm_pruefcheck_mod10(in_barcode in varchar2)
    return boolean;

  function lvs_lte_lhm_pruefziffer_mod10(in_barcode in varchar2)
    return varchar2;

  function lvs_lte_lhm_ref(in_sid      in isi_sid.sid%type,
                           in_firma_nr in isi_firma.firma_nr%type,
                           in_barcode  in lvs_lte.lte_id%type)
    return varchar2;

  function lvs_lte_lhm_best(in_sid         in isi_sid.sid%type,
                            in_firma_nr    in isi_firma.firma_nr%type,
                            in_barcode     in lvs_lte.lte_id%type,
                            in_barcode_ref in varchar2) return number;

  function lvs_lte_lhm_best_R30(in_sid              in isi_sid.sid%type,
                                in_firma_nr         in isi_firma.firma_nr%type,
                                in_barcode          in lvs_lte.lte_id%type,
                                in_barcode_ref      in varchar2,
                                in_ignor_lte_status in varchar2) return number;

  function lvs_lam_name_get(in_artikel_id in number,
                            in_kunden_nr  in bde_fa_auftrag.kunden_nr%type)
    return varchar2;

  procedure lvs_c_lam_sper_neue_lte_mg(in_lte_id       in lvs_lhm.Lte_Id%TYPE,
                                       in_lhm_id       in lvs_lhm.Lhm_Id%TYPE,
                                       in_lam_id       in lvs_lam.Lam_Id%TYPE,
                                       in_lam_bh_id    in lvs_lam_bh.lam_bh_id%TYPE,
                                       in_user_ID      in isi_user.login_id%TYPE,
                                       in_lgr_ort      in lvs_lgr_ort.lgr_ort%type,
                                       in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                       in_menge        in number,
                                       in_drucker_name in varchar2);

  procedure lvs_c_lam_sperren_neue_lte(in_lte_id       in lvs_lhm.Lte_Id%TYPE,
                                       in_lhm_id       in lvs_lhm.Lhm_Id%TYPE,
                                       in_lam_id       in lvs_lam.Lam_Id%TYPE,
                                       in_lam_bh_id    in lvs_lam_bh.lam_bh_id%TYPE,
                                       in_user_ID      in isi_user.login_id%TYPE,
                                       in_lgr_ort      in lvs_lgr_ort.lgr_ort%type,
                                       in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                       in_drucker_name in varchar2);

  procedure lvs_c_lam_status(in_lam_id       in lvs_lhm.Lte_Id%TYPE,
                             in_user_ID      in isi_user.login_id%TYPE,
                             in_out_vorg_id  in out lvs_lam_bh.vorg_id%TYPE,
                             in_labor_status in lvs_lam.labor_status%type,
                             in_labor_text   in lvs_lam.labor_text%type);

  procedure lvs_c_lhm_sperre_abpack(in_sid          in isi_sid.sid%type,
                                    in_firma_nr     in isi_firma.firma_nr%type,
                                    in_lhm_id       in lvs_lhm.Lte_Id%TYPE,
                                    in_scanner_name in isi_scanner_cfg.scanner_name%TYPE,
                                    in_out_vorg_id  in out lvs_lam_bh.vorg_id%TYPE,
                                    in_labor_status in lvs_lam.labor_status%type,
                                    in_labor_text   in lvs_lam.labor_text%type);

  procedure lvs_c_lhm_umpacken(in_sid      in isi_sid.sid%type,
                               in_firma_nr in isi_firma.firma_nr%type,
                               in_user_id  in isi_user.login_id%type,
                               in_res_id   in isi_resource.res_id%type,
                               in_lhm_id   in lvs_lhm.Lhm_Id%TYPE,
                               in_lte_id   in lvs_lte.lte_id%type);

  procedure lvs_lhm_umpacken(in_sid      in isi_sid.sid%type,
                             in_firma_nr in isi_firma.firma_nr%type,
                             in_user_id  in isi_user.login_id%type,
                             in_res_id   in isi_resource.res_id%type,
                             in_lhm_id   in lvs_lhm.Lhm_Id%TYPE,
                             in_lte_id   in lvs_lte.lte_id%type);

  function LVS_C_LHM_DRUCKEN_BDE (in_lhm_id       in lvs_lam.lhm_id%type,
                                  in_drucker_name in pe_drucker_cfg.drucker_name%type)
                                  return integer;

  procedure lvs_c_lte_wieder_einl(in_lte_id     in lvs_lte.lte_id%type,
                                in_lgr_ort    in lvs_lgr_ort.lgr_ort%type,
                                in_user_ID    in isi_user.login_id%TYPE);

  procedure lvs_c_lte_set_artikel(in_sid        in isi_sid.sid%type,
                                  in_firma_nr   in isi_firma.firma_nr%type,
                                  in_lhm_id     in lvs_lhm.lhm_id%type,
                                  in_lte_id     in lvs_lte.lte_id%type,
                                  in_artikel    in isi_artikel.artikel%type,
                                  in_artikel_id in isi_artikel.artikel_id%type,
                                  in_charge     in lvs_charge.charge_bez%type,
                                  in_Menge      in lvs_lam.menge%type,
                                  in_Kundennr   in lvs_lam.kunden_nr%type,
                                  in_user_ID    in isi_user.login_id%TYPE);

  procedure lvs_lte_set_artikel(in_sid        in isi_sid.sid%type,
                                in_firma_nr   in isi_firma.firma_nr%type,
                                in_lhm_id     in lvs_lhm.lhm_id%type,
                                in_lte_id     in lvs_lte.lte_id%type,
                                in_artikel    in isi_artikel.artikel%type,
                                in_artikel_id in isi_artikel.artikel_id%type,
                                in_charge     in lvs_charge.charge_bez%type,
                                in_Menge      in lvs_lam.menge%type,
                                in_Kundennr   in lvs_lam.kunden_nr%type,
                                in_user_ID    in isi_user.login_id%TYPE);

  procedure lvs_c_lam_schrott(in_lte_id       in lvs_lhm.Lte_Id%TYPE,
                              in_lhm_id       in lvs_lhm.Lhm_Id%TYPE,
                              in_lam_id       in lvs_lam.Lam_Id%TYPE,
                              in_user_ID      in isi_user.login_id%TYPE
                             );

  function lvs_mhd_berechne(in_start_date in date,
                            in_mhd_tage   in isi_artikel.mhd_tage%type,
                            in_berechnung in isi_artikel.mhd_berechnung%type)
    return date;

  function format_ean(in_str in varchar2) return varchar2;

  function format_nve(in_str in varchar2) return varchar2;

  procedure LVS_C_SEP_LAM (in_sid                 in isi_sid.sid%type,
                           in_firma_nr            in isi_firma.firma_nr%type,
                           in_res_id              in isi_resource.res_id%type,
                           in_user_id             in isi_user.login_id%type,
                           in_lte_id              in lvs_lte.lte_id%type,
                           in_lam_id              in lvs_lam.lam_id%type,
                           in_lam_bh_id           in lvs_lam_bh.lam_bh_id%type,
                           in_sonst_id_lieferant  in lvs_lam.sonst_id_lieferant%type,
                           in_menge               in lvs_lam.menge%type);

  procedure lvs_c_teile_lhm_auf_lte (in_lte_id           in lvs_lte.lte_id%type,
                                     in_lhm_menge        in lvs_lam.menge%type,
                                     in_lhm_name         in lvs_lhm_cfg.lhm_name%type,
                                     in_login_id         in isi_user.login_id%type,
                                     in_eti_druck_status in lvs_lhm.lhm_eti_druck_status%type
                                     );

  procedure split_spez_barcode(in_barcode              in  lvs_lam.lhm_id%type,
                               in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                               out_artikel             out varchar2,
                               out_charge              out varchar2,
                               out_prod_datum_str      out varchar2,
                               out_prod_datum_struktur out varchar2,
                               out_menge_str           out varchar2,
                               out_ean                 out varchar2,
                               out_lfd_nr_str          out varchar2,
                               out_linie_str           out varchar2);

  procedure spez_barcode_result(in_sid      in isi_sid.sid%type,
                                in_firma_nr in isi_firma.firma_nr%type,
                                in_barcode              in  lvs_lam.lhm_id%type,
                                in_parameter_wert       in  isi_firma_cfg.parameter_wert%type,
                                out_artikel             out isi_artikel%rowtype,
                                out_charge              out varchar2,
                                out_prod_datum          out date,
                                out_menge               out number,
                                out_ean                 out varchar2,
                                out_lfd_nr_str          out varchar2,
                                out_linie_str           out varchar2);

  function insert_lhm_aus_barcode(in_sid             in isi_sid.sid%type,
                                  in_firma_nr        in isi_firma.firma_nr%type,
                                  in_barcode         in lvs_lam.lhm_id%type,
                                  in_parameter_wert  in isi_firma_cfg.parameter_wert%type,
                                  in_login_id        in isi_user.login_id%type,
                                  in_out_menge       in out number,
                                  in_lte_barcode     in lvs_lam.lte_id%type)
                                  return varchar2;
  
  procedure unite_lams_without_reservation (in_sid          in lvs_lam_bh.sid%type,
                                            in_firma_nr     in lvs_lam_bh.firma_nr%type,
                                            in_lte_id       in lvs_lte.lte_id%type,
                                            in_user_id      in isi_user.login_id%type,
                                            in_consider_mhd in varchar2,
                                            in_min_mhd      in date);
  
  procedure add_amount_to_reservation (in_sid          in lvs_lam_bh.sid%type,
                                       in_firma_nr     in lvs_lam_bh.firma_nr%type,
                                       in_lte_id       in lvs_lte.lte_id%type,
                                       in_auf_id       in lvs_lam.order_pos_auf_id%type,
                                       in_user_id      in isi_user.login_id%type,
                                       in_consider_mhd in varchar2,
                                       in_min_mhd      in date);
end lvs_p_lte_lhm;
/



-- sqlcl_snapshot {"hash":"5af177416e02f75f27de6ce88db007a7bac86914","type":"PACKAGE_SPEC","name":"LVS_P_LTE_LHM","schemaName":"DIRKSPZM32","sxml":""}