create or replace package dirkspzm32.db_p_trace is

  -- Author  : DTSEKAS
  -- Created : 29.01.2019 10:53:57
  -- Purpose : Monitoring von Werten in Tabellen
  -- Jira: https://portal.isi-automation.com:8444/browse/P70540-126
  -- Confluence Link: https://portal.isi-automation.com:8443/display/ORACLEDEV/Oracle+Daten+Monitoring

  -- Public function and procedure declarations
    function get_trigger_aktiv (
        in_tabellenname in varchar2
    ) return integer;

    function get_spalten_namen (
        in_sid          in isi_firma.sid%type,
        in_firma_nr     in isi_firma.firma_nr%type,
        in_login_id     in isi_user.login_id%type,
        in_tabellenname in varchar2
    ) return varchar2;

    procedure c_tabelle_db_trace_verkleinern (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        in_ab_tage  in integer,
        out_meldung out varchar2
    );

    procedure c_tabelle_db_trace_verklein_in (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        in_ab_tage  in integer
    );

    procedure c_trigger_deaktivieren (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        out_meldung    out varchar2
    );

    procedure c_trigger_aktivieren (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        in_wert        in integer,
        out_meldung    out varchar2
    );

    procedure c_trigger_loeschen_alle (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    );

    procedure c_trigger_loeschen (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        out_meldung    out varchar2
    );

    procedure c_trigger_von_tmpl_erstellen (
        in_sid         in isi_firma.sid%type,
        in_firma_nr    in isi_firma.firma_nr%type,
        in_login_id    in isi_user.login_id%type,
        in_tabellename in varchar2,
        out_meldung    out varchar2
    );

    procedure c_trigger_von_tmpl_alle_tbl (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    );

    procedure db_act_log (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type
    );

    procedure db_act_log_out_meld (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type,
        out_meldung      out varchar2
    );

    procedure c_db_act_log_out_meld (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type,
        out_meldung      out varchar2
    );

    procedure c_db_act_log (
        in_act_table     in db_trace.act_table%type,
        in_act_pk_cols   in db_trace.act_pk_cols%type,
        in_act_pk_values in db_trace.act_pk_values%type,
        in_act_command   in db_trace.act_command%type,
        in_act_info      in db_trace.act_info%type
    );

    procedure c_job_erstellen (
        in_sid       in isi_firma.sid%type,
        in_firma_nr  in isi_firma.firma_nr%type,
        in_login_id  in isi_user.login_id%type,
        in_startzeit in varchar2,
        out_meldung  out varchar2
    );

    procedure c_job_loeschen (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    );

    procedure c_db_trace_deaktivieren (
        in_sid      in isi_firma.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_login_id in isi_user.login_id%type,
        out_meldung out varchar2
    );

end db_p_trace;
/


-- sqlcl_snapshot {"hash":"477391e3279d0917f7cf13e435deeea38d689663","type":"PACKAGE_SPEC","name":"DB_P_TRACE","schemaName":"DIRKSPZM32","sxml":""}