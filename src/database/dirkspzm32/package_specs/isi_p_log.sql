create or replace package dirkspzm32.isi_p_log is

  /*
  __________________________________________________
  Author
  A.Goedeke (-AG-)  06.07.2006 15:31:34
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  05.04.2008   3.4.4.2     (-WK-)   Erweiterung: db_act_log
	07.07.2006   3.3.4.1     (-AG-)   Erweiterung Funktion mit und ohne COMMIT
	00.00.2006   3.3.4.0     (-AG-)   Erstellung des Package
    */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

    procedure c_isi_system_meldung (
        in_sid               in isi_sid.sid%type,
        in_firma             in isi_firma.firma_nr%type,
        in_programm          in isi_log.log_programm%type,
        in_modul             in isi_log.log_modul%type,
        in_category          in isi_log.log_category%type,
        in_computer          in isi_arbeitsplatz.ip_adresse%type,
        in_arbeitsplatz_id   in isi_arbeitsplatz.arbeitsplatz_id%type,
        in_user_login_id     in isi_user.login_id%type,
        in_meldung_engine_id in meldung_cfg.engine_id%type,
        in_meldung_nr        in meldung_texte.mt_fehlernr%type,
        in_details           in isi_log.log_details%type,
        in_log_type          in isi_log.log_typ%type,
        in_log_level         in isi_log.log_level%type default 4
    );

    procedure isi_system_meldung (
        in_sid               in isi_sid.sid%type,
        in_firma             in isi_firma.firma_nr%type,
        in_programm          in isi_log.log_programm%type,
        in_modul             in isi_log.log_modul%type,
        in_category          in isi_log.log_category%type,
        in_computer          in isi_arbeitsplatz.ip_adresse%type,
        in_arbeitsplatz_id   in isi_arbeitsplatz.arbeitsplatz_id%type,
        in_user_login_id     in isi_user.login_id%type,
        in_meldung_engine_id in meldung_cfg.engine_id%type,
        in_meldung_nr        in meldung_texte.mt_fehlernr%type,
        in_details           in isi_log.log_details%type,
        in_log_type          in isi_log.log_typ%type,
        in_log_level         in isi_log.log_level%type default 4
    );

  --------------------------------------------------------------------------------
  -- 05.04.2008 (-WK-)
  -- procedure loggt Aktivitäten in Tabellen und speichert die Umgebungsinformationen
  --
  --------------------------------------------------------------------------------
    procedure db_act_log (
        in_act_table     in isi_db_act_log.act_table%type,
        in_act_pk_cols   in isi_db_act_log.act_pk_cols%type,
        in_act_pk_values in isi_db_act_log.act_pk_values%type,
        in_act_command   in isi_db_act_log.act_command%type,
        in_act_info      in isi_db_act_log.act_info%type
    );

end isi_p_log;
/


-- sqlcl_snapshot {"hash":"26b1d6a9272f22d6e47fdb217c2337c19399115a","type":"PACKAGE_SPEC","name":"ISI_P_LOG","schemaName":"DIRKSPZM32","sxml":""}