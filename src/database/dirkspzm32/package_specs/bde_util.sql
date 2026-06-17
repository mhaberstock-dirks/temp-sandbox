create or replace 
PACKAGE DIRKSPZM32.bde_util IS


  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  03.02.2006 15:08:06
  __________________________________________________
  Description
  Allgemeine Funktionen wie isi_utils nur für BDE
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  06.01.2009   3.4.10      (-BW-)   Zentrale FORMAT_XX
  */


    PROCEDURE convert_human_to_steuerzeichen (
      in_str  IN  VARCHAR2,
      out_str OUT VARCHAR2);

    FUNCTION human_to_steuerzeichen (
      in_str IN VARCHAR2) RETURN VARCHAR2;

    FUNCTION Format_EAN (
      in_str IN VARCHAR2) RETURN VARCHAR2;

    FUNCTION Format_NVE (
      in_str IN VARCHAR2) RETURN VARCHAR2;

    procedure c_bde_linie_fertig  (in_sid         in isi_sid.sid%type,
                                   in_res_id      in isi_resource.res_id%type);

    procedure c_wr_bde_pd_prozess_data (in_sid         in isi_sid.sid%type,
                                        in_firma_nr    in isi_firma.firma_nr%type,
                                        in_name        in isi_resource.res_name%type,
                                        in_login_id    in isi_user.login_id%type,
                                        in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                        in_id          in lvs_lte.lte_id%type,
                                        in_IO          in bde_pd_prozess_data.io%type,
                                        in_qd_data     in varchar2);

    procedure bde_wr_pd_prozess_data (in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_name        in isi_resource.res_name%type,
                                      in_login_id    in isi_user.login_id%type,
                                      in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                      in_id          in lvs_lte.lte_id%type,
                                      in_IO          in bde_pd_prozess_data.io%type,
                                      in_qd_data     in varchar2);

    procedure c_wr_bde_pd_prozess_d_o_fa (in_sid         in isi_sid.sid%type,
                                          in_firma_nr    in isi_firma.firma_nr%type,
                                          in_name        in isi_resource.res_name%type,
                                          in_login_id    in isi_user.login_id%type,
                                          in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                          in_id          in lvs_lte.lte_id%type,
                                          in_IO          in bde_pd_prozess_data.io%type,
                                          in_qd_data     in varchar2);

    procedure bde_wr_pd_prozess_d_o_fa (in_sid         in isi_sid.sid%type,
                                        in_firma_nr    in isi_firma.firma_nr%type,
                                        in_name        in isi_resource.res_name%type,
                                        in_login_id    in isi_user.login_id%type,
                                        in_b_datum     in bde_pd_prozess_data.res_prozess_data_date%type,
                                        in_id          in lvs_lte.lte_id%type,
                                        in_IO          in bde_pd_prozess_data.io%type,
                                        in_qd_data     in varchar2);

    function bde_check_pd_prozess_data (in_sid         in isi_sid.sid%type,
                                        in_firma_nr    in isi_firma.firma_nr%type,
                                        in_id          in lvs_lte.lte_id%type)
                                        return varchar2;

    procedure c_bde_pd_restart_on_res (in_sid         in isi_sid.sid%type,
                                       in_firma_nr    in isi_firma.firma_nr%type,
                                       in_lte_id      in lvs_lte.lte_id%type,
                                       in_rdk_id      in lvs_lte.lte_id%type,
                                       in_res_id      in isi_resource.res_id%type);

    procedure c_bde_pd_2nd_live (in_sid         in isi_sid.sid%type,
                                 in_firma_nr    in isi_firma.firma_nr%type,
                                 in_lte_id      in lvs_lte.lte_id%type,
                                 in_login_id    in isi_user.login_id%type,
                                 in_lgr_platz   in lvs_lgr.lgr_platz%type,
                                 in_drucker     in pe_drucker_cfg.drucker_name%type);

    procedure c_bde_pd_2nd_live_3511(in_sid          in isi_sid.sid%type,
                                     in_firma_nr     in isi_firma.firma_nr%type,
                                     in_lte_id       in lvs_lte.lte_id%type,
                                     in_login_id     in isi_user.login_id%type,
                                     in_lgr_platz    in lvs_lgr.lgr_platz%type,
                                     in_drucker      in pe_drucker_cfg.drucker_name%type,
                                     in_labor_status in lvs_lam.labor_status%type);

                                     
END bde_util;
/



-- sqlcl_snapshot {"hash":"5cb685c74a935cbacd7d0519ab0f4a2b0c0cfe88","type":"PACKAGE_SPEC","name":"BDE_UTIL","schemaName":"DIRKSPZM32","sxml":""}