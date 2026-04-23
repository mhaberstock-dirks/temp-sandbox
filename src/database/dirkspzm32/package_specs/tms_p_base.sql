create or replace package dirkspzm32.tms_p_base is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  27.02.2009 12:59:28
  __________________________________________________
  Description
  TMS TransportManagementSystem Basisfunktionen
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */


  /* -WK-: zum Test, ob wir evtl getrennte Versionskonstanten pflegen sollten */
    v_release_major constant number := 3;
    v_release_minor constant number := 5;
    v_revision constant number := 0;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '27.11.2009';
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
   *  27.02.2009 | 3.4.10     | (-WK-) package created
   */

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/
    function get_loading_point (
        in_lgr_platz         in tms_loading_points.lgr_platz%type,
        in_firma_nr          in tms_loading_points.firma_nr%type,
        in_sid               in tms_loading_points.sid%type,
        io_tms_loading_point in out tms_loading_points%rowtype
    ) return boolean;

    function get_kunden_auftr_pos (
        in_kunden_auftr_pos_id in tms_kunden_auftr_pos.kunden_auftr_pos_id%type,
        in_firma_nr            in tms_kunden_auftr_pos.firma_nr%type,
        in_sid                 in tms_kunden_auftr_pos.sid%type,
        io_kunden_auftr_pos    in out tms_kunden_auftr_pos%rowtype
    ) return boolean;

    function get_kunden_auftr_pos_by_uix (
        in_auftrag_nr       in tms_kunden_auftr_pos.auftrag_nr%type,
        in_pos_nr           in tms_kunden_auftr_pos.pos_nr%type,
        in_upos_nr          in tms_kunden_auftr_pos.upos_nr%type,
        in_firma_nr         in tms_kunden_auftr_pos.firma_nr%type,
        in_sid              in tms_kunden_auftr_pos.sid%type,
        io_kunden_auftr_pos in out tms_kunden_auftr_pos%rowtype
    ) return boolean;

end tms_p_base;
/


-- sqlcl_snapshot {"hash":"e8735bc648cfba455dfce96b414c0ce3c1b14d43","type":"PACKAGE_SPEC","name":"TMS_P_BASE","schemaName":"DIRKSPZM32","sxml":""}