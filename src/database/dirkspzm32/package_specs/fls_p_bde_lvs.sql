create or replace 
package DIRKSPZM32.fls_p_bde_lvs is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  17.12.2007 13:14:07
  __________________________________________________
  Description
  FLS Funktioen für Buchungen im BDE -> LVS
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  17.12.2007   3.4.4.1     (-WK-)   Package erstellt
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;
    procedure c_bde_prod_lte_o_platz (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_lte_barcode in lvs_lte.lte_id%type,
                                      in_lhm_barcode in lvs_lhm.lhm_id%type,
                                      in_res_id      in isi_resource.res_id%type,
                                      in_login_id    in isi_user.login_id%type,
                                      in_menge_a     in lvs_lam.menge%type,
                                      in_menge_b     in lvs_lam.menge%type,
                                      in_schrott     in lvs_lam.menge%type,
                                      in_abfuell_ist in bde_pd_prod.abfuell_ist%type,
                                      in_abfuell_tara in bde_pd_prod.abfuell_tara%type,
                                      out_leitzahl   out bde_fa_auftrag.leitzahl%type,
                                      out_fa_ag      out bde_fa_auftrag.fa_ag%type,
                                      out_fa_upos    out bde_fa_auftrag.fa_upos%type);

    procedure c_bde_prod_lhm_o_platz (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_lte_barcode in lvs_lte.lte_id%type,
                                      in_lhm_barcode in lvs_lhm.lhm_id%type,
                                      in_res_id      in isi_resource.res_id%type,
                                      in_login_id    in isi_user.login_id%type,
                                      in_menge_a     in lvs_lam.menge%type,
                                      in_menge_b     in lvs_lam.menge%type,
                                      in_schrott     in lvs_lam.menge%type,
                                      in_abfuell_ist in bde_pd_prod.abfuell_ist%type,
                                      in_abfuell_tara in bde_pd_prod.abfuell_tara%type,
                                      out_leitzahl   out bde_fa_auftrag.leitzahl%type,
                                      out_fa_ag      out bde_fa_auftrag.fa_ag%type,
                                      out_fa_upos    out bde_fa_auftrag.fa_upos%type);

    procedure c_bde_res_print_lte (in_sid         in isi_sid.sid%type,
                                   in_res_id      in isi_resource.res_id%type);


    procedure c_bde_linie_fertig  (in_sid         in isi_sid.sid%type,
                                   in_res_id      in isi_resource.res_id%type);

  procedure c_bde_res_print_str (in_sid         in isi_sid.sid%type,
                                 in_firma_nr    in isi_firma.firma_nr%type,
                                 in_res_id      in isi_resource.res_id%type,
                                 in_prn_str     in varchar2);
end fls_p_bde_lvs;
/



-- sqlcl_snapshot {"hash":"84d593f203939d4b5cfee518079c60bb607564b7","type":"PACKAGE_SPEC","name":"FLS_P_BDE_LVS","schemaName":"DIRKSPZM32","sxml":""}