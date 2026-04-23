create or replace package dirkspzm32.res_status is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  28.01.2005 09:55:53
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

	-- Public type declarations
	/* Status beginnen */
    procedure res_status_beg (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_ls_login_id   in isi_user.login_id%type,
        in_res_st_id     in isi_res_status_cfg.res_st_id%type,
        in_res_typ       in isi_res_status_cfg.res_typ%type,
        in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
        in_fehler_res_id in isi_res_status.fehler_res_id%type,
        in_sysdate       in date default null
    );

	/* aktuellen Status beenden */
    procedure res_status_end (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_res_id   in isi_resource.res_id%type,
        in_sysdate  in date default null
    );

	/* aktuellen Status unterbrechen */
    procedure res_status_unterb (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_ls_login_id in isi_user.login_id%type,
        in_sysdate     in date default null
    );

	/* aktuellen Status ändern */
    procedure res_status_grund (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_ls_login_id   in isi_user.login_id%type,
        in_res_st_id     in isi_res_status_cfg.res_st_id%type,
        in_res_typ       in isi_res_status_cfg.res_typ%type,
        in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
        in_fehler_res_id in isi_res_status.fehler_res_id%type
    );

	/* (commited) Status beginnen */
    procedure c_res_status_beg (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_ls_login_id   in isi_user.login_id%type,
        in_res_st_id     in isi_res_status_cfg.res_st_id%type,
        in_res_typ       in isi_res_status_cfg.res_typ%type,
        in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
        in_fehler_res_id in isi_res_status.fehler_res_id%type,
        in_sysdate       in date default null
    );

	/* (commited) aktuellen Status beenden */
    procedure c_res_status_end (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_res_id   in isi_resource.res_id%type,
        in_sysdate  in date default null
    );

	/* (commited) aktuellen Status unterbrechen */
    procedure c_res_status_unterb (
        in_sid         in isi_sid.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_res_id      in isi_resource.res_id%type,
        in_ls_login_id in isi_user.login_id%type,
        in_sysdate     in date default null
    );

	/* (commited) aktuellen Status ändern */
    procedure c_res_status_grund (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_ls_login_id   in isi_user.login_id%type,
        in_res_st_id     in isi_res_status_cfg.res_st_id%type,
        in_res_typ       in isi_res_status_cfg.res_typ%type,
        in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
        in_fehler_res_id in isi_res_status.fehler_res_id%type
    );

    procedure c_res_status_beg_stl_ref (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_res_id        in isi_resource.res_id%type,
        in_ls_login_id   in isi_user.login_id%type,
        in_res_st_id     in isi_res_status_cfg.res_st_id%type,
        in_res_typ       in isi_res_status_cfg.res_typ%type,
        in_res_st_ug_id  in isi_res_status_ug_cfg.res_st_ug_id%type,
        in_fehler_res_id in isi_res_status.fehler_res_id%type,
        in_stl_fa_ag     in bde_fa_auftrag_stl.ma_fa_ag%type,
        in_stl_fa_upos   in bde_fa_auftrag_stl.ma_fa_upos%type,
        in_stl_fa_mg_ix  in bde_fa_auftrag_stl.prod_menge_ix%type,
        in_sysdate       in date default null
    );

end res_status;
/


-- sqlcl_snapshot {"hash":"ce5b909257ba2fbfb30261f053f456a3e108513d","type":"PACKAGE_SPEC","name":"RES_STATUS","schemaName":"DIRKSPZM32","sxml":""}