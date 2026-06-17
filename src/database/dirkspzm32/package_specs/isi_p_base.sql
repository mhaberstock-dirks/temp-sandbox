create or replace 
package DIRKSPZM32.isi_p_base is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  22.11.2006 08:37:22
  __________________________________________________
  Description
  Allgemeine Hilfsfunktionen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	*            3.4.4.1              Erweiterungen Sasol (Spez barcode und Claas FLS)
  *                                 Neue Funktion: get_res_zust_akt
	*            3.3.4.1              Änderung in den Parametern von LVS_LTE_PLATZ_BEWERTEN
	*            3.3.4.0              Versionierung Erstellt
  */


  v_version_str    constant  varchar2(20) := '3.5.0.1 / 27.11.2009';
  function get_version return varchar2;

  -- Public function and procedure declarations
  function get_isi_firma(in_sid                   in  isi_sid.sid%type,
                         in_firma_nr              in  isi_firma.firma_nr%type,
                         out_firma                out isi_firma%rowtype
                        ) return boolean;

  function get_isi_artikel_kd(in_sid        in  isi_sid.sid%type,
                              in_artikel_id in  isi_artikel_kunde.artikel_id%type,
                              in_kundennr   in  isi_artikel_kunde.kunden_nr%type,
                              out_artikel   out isi_artikel_kunde%rowtype
                              ) return boolean;

  function get_isi_artikel(in_sid        in  isi_sid.sid%type,
                           in_artikel_id in  isi_artikel.artikel_id%type,
                           out_artikel   out isi_artikel%rowtype
                          ) return boolean;

  function get_isi_artikel_Id_by_nr(in_sid        in  isi_sid.sid%type,
                           in_artikel in  isi_artikel.artikel%type,
                           out_artikel_id   out isi_artikel.artikel_id%type
                          ) return boolean;

  function get_isi_artikel_nr_by_id(in_sid        in  isi_sid.sid%type,
                           in_artikel_id  in  isi_artikel.artikel_id%type,
                           out_artikel_nr   out isi_artikel.artikel%type
                          ) return boolean;

  function get_isi_artikel_by_nr(in_artikel_nr in  isi_artikel.artikel%type,
                                 out_artikel   out isi_artikel%rowtype
                                ) return boolean;

  function get_res_zust_akt(in_sid           in  isi_sid.sid%type,
                            in_res_id        in  isi_resource.res_id%type,
                            out_res_zust_akt out isi_resource_zust_akt%rowtype
                           ) return boolean;

  function get_res_lam_akt(in_sid           in  isi_resource_lam_akt.sid%type,
                           in_res_id        in  isi_resource_lam_akt.res_id%type,
                           in_artikel_id    in  isi_resource_lam_akt.artikel_id%type,
                           out_res_lam_akt  out isi_resource_lam_akt%rowtype
                           ) return boolean;

  function get_resource(in_sid           in  isi_sid.sid%type,
                        in_res_id        in  isi_resource.res_id%type,
                        out_resource     out isi_resource%rowtype
                       ) return boolean;

  function get_resource_by_ext_name(in_res_ext_name  in  isi_resource.res_ext_name%type,
                                    out_resource     out isi_resource%rowtype
                                   ) return boolean;

  function get_resource_by_name(in_res_name      in  isi_resource.res_ext_name%type,
                                out_resource     out isi_resource%rowtype
                               ) return boolean;

  function get_scanner_by_res_id(in_sid           in  isi_sid.sid%type,
                                 in_res_id        in  isi_resource.res_id%type,
                                 out_scanner     out isi_scanner_cfg%rowtype
                                 ) return boolean;

  function get_resource_zust_akt(in_sid                    in  isi_sid.sid%type,
                                 in_res_id                 in  isi_resource.res_id%type,
                                 out_resource_zust_akt     out isi_resource_zust_akt%rowtype
                       ) return boolean;

  function get_scanner(in_sid           in  isi_sid.sid%type,
                       in_scaner_name   in  isi_scanner_cfg.scanner_name%type,
                       out_scanner     out isi_scanner_cfg%rowtype
                       ) return boolean;

  function get_artikel_gruppe(in_sid           in  isi_sid.sid%type,
                              in_art_gruppe_id in  isi_artikel_gruppe.art_gruppe_id%type,
                              out_art_gruppe   out isi_artikel_gruppe%rowtype
                             ) return boolean;

  function get_artikel_ctrl(in_sid           in  isi_sid.sid%type,
                            in_artikel_id    in  isi_artikel_ctrl.artikel_id%type,
                            in_zeichnung     in  isi_artikel_ctrl.zeichnung%type,
                            in_zindex        in  isi_artikel_ctrl.zeichnung_index%type,
                            in_leitzahl      in  isi_artikel_ctrl.leitzahl%type,
                            in_fa_ag         in  isi_artikel_ctrl.fa_ag%type,
                            out_art_ctrl     out isi_artikel_ctrl%rowtype
                           ) return boolean;

  function get_artikel_ctrl_typ(in_sid           in  isi_sid.sid%type,
                                in_artikel_id    in  isi_artikel_ctrl.artikel_id%type,
                                in_herstelle_k   in  isi_hersteller.kuerzel%type,
                                out_art_ctrl     out isi_artikel_ctrl%rowtype
                               ) return boolean;
  function get_hersteller(in_herstelle_k   in  isi_hersteller.kuerzel%type,
                          out_art_ctrl     out isi_hersteller%rowtype
                        ) return boolean;


  function get_adresse(in_sid           in  isi_sid.sid%type,
                       in_firma_nr      in  isi_adressen.firma_nr%type,
                       in_adr_art       in  isi_adressen.adr_art%type,
                       in_adr_nr        in  isi_adressen.adr_nr%type,
                       in_adr_lief      in  isi_adressen.adr_liefer%type,
                       out_adressen     out isi_adressen%rowtype
                       ) return boolean;

  function get_adress_nr_by_id(in_sid           in  isi_sid.sid%type,
                               in_adress_id     in  isi_adressen.adress_id%type,
                               out_adress_nr    out isi_adressen.adr_nr%type
                               ) return boolean;

  function get_adress_next_lfdn_id(in_sid                   in  isi_sid.sid%type,
                                   in_adress_id             in  isi_adressen.adress_id%type,
                                   out_nummernkreis_aktuell out isi_adressen.lte_lhm_nummernkreis_aktuell%type
                                   ) return boolean;

                              
end isi_p_base;
/



-- sqlcl_snapshot {"hash":"4865b506188df6c2275d6f9720829981c4168684","type":"PACKAGE_SPEC","name":"ISI_P_BASE","schemaName":"DIRKSPZM32","sxml":""}