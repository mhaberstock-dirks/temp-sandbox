create or replace 
package DIRKSPZM32.pps_p_utils is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  17.12.2007 13:14:07
  __________________________________________________
  Description
  PPS Funktionen fï¿½r die Erzeugung von BDE Daten
  und PPS Daten aus Plandaten
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  19.11.2019   DB31       (-AG-)   Package erstellt
  */

  v_version_str constant varchar2(20) := 'DB31 / 19.11.2019';
  function get_version return varchar2;

  -- Author  : HJGOEDEKE
  -- Created : 19.11.2019 12:22:47
  -- Purpose :

  -- Public type declarations

  -- Public constant declarations

  -- Public variable declarations

  -- Public function and procedure declarations
  procedure c_gen_arbeitsplan(in_artikel_id        in isi_artikel.artikel_id%type);

  procedure c_gen_arbeitsplan_res_list(in_artikel_id        in isi_artikel.artikel_id%type);

  --procedure c_gen_fhm_pers_grp_vqual;

  function  check_stueckliste (in_artikel_id        in isi_artikel.artikel_id%type,  -- Zu pruefender Artikle fï¿½r neue Stï¿½klistenposition
                               in_artikel_id_sl     in isi_artikel.artikel_id%type)  -- Stuecklistenartikel aus Stï¿½klistenposition)
                             return boolean;

  procedure c_gen_fhm_art_ltes (in_sid               in isi_sid.sid%type,
                                in_firma_nr          in isi_firma.firma_nr%type,
                                in_fhm_grp           in isi_res_fhm_grp.fhm_grp%type);  -- FHM fuer den der Artikel und die LTEs generiert werden soll

  -- Prï¿½fen, ob fï¿½r eine Resource der Auftragsvorrat ausreichend ist
  function check_res_fa_vorrat (in_sid         in isi_sid.sid%type,
                                in_firma_nr    in isi_firma.firma_nr%type,
                                in_res_id      in isi_resource.res_id%type)
                                return number;

  procedure c_gen_fas_all_ms (in_sid         in isi_sid.sid%type,
                              in_firma_nr    in isi_firma.firma_nr%type);

  -- Setzen des aktuellen Datums im Ganttplan Interface Status beim Laden des Modells bzw. beim verlassen vom Ganttplan
  procedure c_set_gp_int_status_oninit;

  procedure c_set_gp_int_status_onexit;
end pps_p_utils;
/



-- sqlcl_snapshot {"hash":"1faba1fdd3686f41074c0f15ba88f3b330d6c05a","type":"PACKAGE_SPEC","name":"PPS_P_UTILS","schemaName":"DIRKSPZM32","sxml":""}