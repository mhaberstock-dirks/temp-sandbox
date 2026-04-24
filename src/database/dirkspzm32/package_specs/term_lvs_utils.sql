create or replace package dirkspzm32.term_lvs_utils is

  -- Author  : WKROEKER
  -- Created : 07.03.2009 12:59:28
  -- Purpose :

  /* -WK-: zum Test, ob wir evtl getrennte Versionskonstanten pflegen sollten */
    v_release_major constant number := 3;
    v_release_minor constant number := 5;
    v_revision constant number := 0;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '07.03.2009';
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

  /*
  *  Revision history
  *  date       | revision   | Info
  *  ---------------------------------------------------------------------------------
  *  07.03.2009 | 3.4.10     | (-WK-) package created
  */

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
    function check_storage_cell_valid (
        in_scan_data             in varchar2,
        in_expected_storage_cell in lvs_lgr.lgr_platz%type,
        out_found_storage_cell   out lvs_lgr.lgr_platz%type
    ) return number;

end term_lvs_utils;
/


-- sqlcl_snapshot {"hash":"4c1ccfdcf78997674e9b1ee1d9d66d9b4f66e647","type":"PACKAGE_SPEC","name":"TERM_LVS_UTILS","schemaName":"DIRKSPZM32","sxml":""}