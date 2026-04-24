create or replace package dirkspzm32.isi_p_license is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  27.06.2006 17:35:26
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

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

  -- Public Funktions und Prozedur-Deklaration
    procedure get_app_license_ticket (
        in_sid                in isi_sid.sid%type,
        in_firma_nr           in isi_firma.firma_nr%type,
        in_license_type       in varchar2,
        in_app_exe_filename   in varchar2,
        in_hostname           in varchar2,
        in_os_username        in varchar2,
        out_license_ts        out date,
        out_license_valid_sek out number,
        out_license_ticket_id out number
    );

end isi_p_license;
/


-- sqlcl_snapshot {"hash":"34008cb5c660cf52a1975af679b0db58d8b9110e","type":"PACKAGE_SPEC","name":"ISI_P_LICENSE","schemaName":"DIRKSPZM32","sxml":""}