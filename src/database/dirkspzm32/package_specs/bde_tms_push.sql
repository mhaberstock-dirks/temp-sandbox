create or replace 
package DIRKSPZM32.bde_tms_push is

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


  v_version_str    constant  varchar2(20) := '3.5.10 / 04.10.2016';
  function get_version return varchar2;

  procedure c_create_tms_push_transport(in_sid               in isi_sid.sid%type,
                                        in_firma_nr          in isi_firma.firma_nr%type,
                                        in_ICE               in varchar2);

  function c_tms_push_inventur (in_sid               in isi_sid.sid%type,
                                in_firma_nr          in isi_firma.firma_nr%type,
                                in_leitzahl          in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag             in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos           in bde_fa_auftrag.fa_upos%type,
                                in_res_id            in isi_resource.res_id%type,
                                in_login_id          in isi_user.login_id%type,
                                in_lte_id            in lvs_lte.lte_id%type,
                                in_menge             in lvs_lam_bh.menge%type)
                                return varchar2;

  procedure c_tms_push_res_red (in_sid               in isi_sid.sid%type,
                                in_firma_nr          in isi_firma.firma_nr%type,
                                in_leitzahl          in bde_fa_auftrag.leitzahl%type,
                                in_fa_ag             in bde_fa_auftrag.fa_ag%type,
                                in_fa_upos           in bde_fa_auftrag.fa_upos%type,
                                in_res_id            in isi_resource.res_id%type,
                                in_login_id          in isi_user.login_id%type,
                                in_lte_id            in lvs_lte.lte_id%type,
                                in_menge             in lvs_lam_bh.menge%type);
 
  procedure c_crt_tms_push_transport_db31(in_sid               in isi_sid.sid%type,
                                          in_firma_nr          in isi_firma.firma_nr%type,
                                          in_ICE               in varchar2,
                                          in_leitzahl          in bde_fa_auftrag.leitzahl%type);
  
  procedure crt_tms_push_transport_db31(in_sid               in isi_sid.sid%type,
                                          in_firma_nr        in isi_firma.firma_nr%type,
                                          in_ICE             in varchar2,
                                          in_leitzahl        in bde_fa_auftrag.leitzahl%type);

end bde_tms_push;
/



-- sqlcl_snapshot {"hash":"112bc7b48826834bae99ddfab852b7467a9bfc3d","type":"PACKAGE_SPEC","name":"BDE_TMS_PUSH","schemaName":"DIRKSPZM32","sxml":""}