create or replace package dirkspzm32.lvs_uml is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  09.09.2006 13:45:05
  __________________________________________________
  Description
  Lagerverwaltung Funktionen die zum Umlagern benötigt werden
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	             3.3.4.0              Erstellt
  */

  -- Public type declarations
    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

  -- Public function and procedure declarations

    procedure c_res_lte_erz_transp_gesp (
        in_sid            in lvs_lte.sid%type,
        in_firma_nr       in lvs_lte.firma_nr%type,
        in_lte_id         in lvs_lte.lte_id%type,
        in_ziel_lgr_platz in lvs_lte.lgr_platz%type,
        in_login_id       in lvs_lte.res_login_id%type,
        in_modul_erzeuger in isi_transport.modul_erzeuger%type,
        in_prio           in isi_transport.prio%type
    );

    procedure c_res_lhm_erz_transp_gesp (
        in_sid            in lvs_lhm.sid%type,
        in_firma_nr       in lvs_lhm.firma_nr%type,
        in_lhm_id         in lvs_lhm.lhm_id%type,
        in_neu_lhm_name   in lvs_lhm.lhm_name%type,
        in_ziel_lgr_platz in lvs_lhm.lgr_platz%type,
        in_login_id       in lvs_lte.res_login_id%type,
        in_modul_erzeuger in isi_transport.modul_erzeuger%type,
        in_prio           in isi_transport.prio%type
    );

    procedure c_uml_gesp_transp_delete (
        in_sid       in isi_transport.sid%type,
        in_firma_nr  in isi_transport.firma_nr%type,
        in_login_id  in isi_transport.user_id%type,
        in_transp_id in isi_transport.transp_id%type
    );

    procedure c_uml_gesp_transp_freigeben (
        in_sid              in isi_transport.sid%type,
        in_firma_nr         in isi_transport.firma_nr%type,
        in_login_id         in isi_transport.user_id%type,
        in_transp_id        in isi_transport.transp_id%type,
        in_eti_druck_status in lvs_lte.lte_eti_druck_status%type
    );

end lvs_uml;
/


-- sqlcl_snapshot {"hash":"65b44e563b0524a618db5720e5d3bb6f0d1c3a00","type":"PACKAGE_SPEC","name":"LVS_UML","schemaName":"DIRKSPZM32","sxml":""}