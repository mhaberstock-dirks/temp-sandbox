create or replace package dirkspzm32.tms_p_utils is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  27.02.2009 12:59:28
  __________________________________________________
  Description
  TMS TransportManagementSystem Utils Funktionen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  27.02.2009   3.4.10      (-WK-)   package created
  */

  /* -WK-: zum Test, ob wir evtl getrennte Versionskonstanten pflegen sollten */
    v_release_major constant number := 3;
    v_release_minor constant number := 4;
    v_revision constant number := 10;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '27.02.2009';
    v_release_str constant varchar2(20) := to_char(v_release_major)
                                           || '.'
                                           || to_char(v_release_minor)
                                           || '.'
                                           || to_char(v_revision)
                                           || ' / '
                                           || v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.4.10.1 / 27.02.2009';
    function get_release return varchar2;

    function get_version return varchar2;

    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    );

end tms_p_utils;
/


-- sqlcl_snapshot {"hash":"14e055e20235a7636ac83ab77ce1bea8b465bf4f","type":"PACKAGE_SPEC","name":"TMS_P_UTILS","schemaName":"DIRKSPZM32","sxml":""}