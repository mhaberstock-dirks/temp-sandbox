create or replace package dirkspzm32.print_engine is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  08.04.2004 12:33:31
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

    jdt_sql constant pe_jobs.job_daten_typ%type := 'SQL';
    jdt_pv_liste constant pe_jobs.job_daten_typ%type := 'PV-LIST';
    jdt_rep constant pe_jobs.job_daten_typ%type := 'REP';
    jdt_direkt constant pe_jobs.job_daten_typ%type := 'DIREKT';
    job_status_neu constant pe_jobs.status%type := 'N';
    job_status_drucken constant pe_jobs.status%type := 'D';
    job_status_fertig constant pe_jobs.status%type := 'OK';
    job_status_fehler constant pe_jobs.status%type := 'ERR';
    procedure c_insert_new_job (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_rave_datei       in pe_jobs.rave_datei%type,
        in_rave_report_name in pe_jobs.rave_report_name%type,
        in_job_daten_typ    in pe_jobs.job_daten_typ%type,
        in_job_daten        in pe_jobs.job_daten%type,
        in_drucker_name     in pe_jobs.drucker_name%type,
        in_anzahl           in pe_jobs.anzahl%type,
        out_job_nr          out pe_jobs.job_nr%type
    );

    procedure insert_new_job (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_rave_datei       in pe_jobs.rave_datei%type,
        in_rave_report_name in pe_jobs.rave_report_name%type,
        in_job_daten_typ    in pe_jobs.job_daten_typ%type,
        in_job_daten        in pe_jobs.job_daten%type,
        in_drucker_name     in pe_jobs.drucker_name%type,
        in_anzahl           in pe_jobs.anzahl%type,
        out_job_nr          out pe_jobs.job_nr%type
    );

    function get_job_status (
        in_sid              in varchar2,
        in_firma_nr         in number,
        in_job_nr           in pe_jobs.job_nr%type,
        out_job_status      out pe_jobs.status%type,
        out_job_status_text out pe_jobs.status_text%type
    ) return boolean;

    function get_job_daten (
        in_sid          in varchar2,
        in_firma_nr     in number,
        in_job_nr       in pe_jobs.job_nr%type,
        out_job_data    out pe_jobs%rowtype,
        out_drucker_typ out pe_drucker_cfg.drucker_typ%type
    ) return boolean;

    function get_next_job (
        in_sid          in varchar2,
        in_firma_nr     in number,
        out_job_data    out pe_jobs%rowtype,
        out_drucker_typ out pe_drucker_cfg.drucker_typ%type
    ) return boolean;

    procedure c_set_job_status (
        in_sid             in varchar2,
        in_firma_nr        in number,
        in_job_nr          in pe_jobs.job_nr%type,
        in_job_status      in varchar2,
        in_job_status_text in varchar2
    );

    procedure c_reset_jobs (
        in_sid      in varchar2,
        in_firma_nr in number
    );

    procedure c_reprint_last_job (
        in_sid          in varchar2,
        in_firma_nr     in number,
        in_printer_name in pe_jobs.drucker_name%type
    );

end print_engine;
/


-- sqlcl_snapshot {"hash":"6189a22e54ea34a6d6a3596ba8e7a6734427fed6","type":"PACKAGE_SPEC","name":"PRINT_ENGINE","schemaName":"DIRKSPZM32","sxml":""}