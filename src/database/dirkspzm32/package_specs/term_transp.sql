create or replace package dirkspzm32.term_transp is

  -- Author  : wkroeker
  -- Created : 12.02.2009 11:27:22
  -- Purpose :

  /* -WK-: zum Test, ob wir evtl getrennte Versionskonstanten pflegen sollten */
    v_release_major constant number := 3;
    v_release_minor constant number := 4;
    v_revision constant number := 10;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '12.02.2009';
    v_release_str constant varchar2(20) := to_char(v_release_major)
                                           || '.'
                                           || to_char(v_release_minor)
                                           || '.'
                                           || to_char(v_revision)
                                           || ' / '
                                           || v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.4.10.1 / 12.02.2009';
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
  *  12.02.2009 | 3.4.10     | (-WK-) package created
  */

    function get_next_transp_list_csv (
        in_sid                 in isi_transport.sid%type,
        in_firma_nr            in isi_transport.firma_nr%type,
        in_login_id            in isi_user.login_id%type,
        in_res_id              in isi_transport.res_id%type,
        in_max_count           in number,
        out_transp_id_list_csv out varchar2
    ) return varchar2;

    procedure c_assign_transp_to_resource (
        in_sid       in isi_transport.sid%type,
        in_firma_nr  in isi_transport.firma_nr%type,
        in_transp_id in isi_transport.transp_id%type,
        in_res_id    in isi_transport.res_id%type,
        in_login_id  in isi_user.login_id%type
    );

    procedure c_release_assigned_transp (
        in_sid       in isi_transport.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        in_res_id    in isi_transport.res_id%type
    );

    procedure c_handle_storage_cell_empty (
        in_sid       in isi_transport.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        in_login_id  in isi_user.login_id%type
    );

    procedure c_handle_storage_lte_alter (
        in_sid       in isi_transport.sid%type,
        in_transp_id in isi_transport.transp_id%type,
        in_login_id  in isi_user.login_id%type,
        in_lte_id    lvs_lte.lte_id%type
    );

    procedure c_handle_storage_cell_occupied (
        in_sid               in isi_transport.sid%type,
        in_transp_id         in isi_transport.transp_id%type,
        in_login_id          in isi_user.login_id%type,
        out_new_storage_cell out isi_transport.lgr_platz_ziel%type
    );

    procedure c_handle_storage_cell_alter (
        in_sid               in isi_transport.sid%type,
        in_transp_id         in isi_transport.transp_id%type,
        in_login_id          in isi_user.login_id%type,
        out_new_storage_cell out isi_transport.lgr_platz_ziel%type
    );

    procedure c_change_transp_diff_tu (
        in_sid                 in isi_transport.sid%type,
        in_transp_id           in isi_transport.transp_id%type,
        in_diff_transp_unit_id in isi_transport.lte_id%type,
        in_login_id            in isi_user.login_id%type,
        in_res_id              in isi_transport.res_id%type
    );

    function get_loading_transp_list_csv (
        in_sid                 in tms_loading_points.sid%type,
        in_firma_nr            in tms_loading_points.firma_nr%type,
        in_loading_point       in tms_loading_points.lgr_platz%type,
        out_transp_id_list_csv out varchar2
    ) return varchar2;

end term_transp;
/


-- sqlcl_snapshot {"hash":"a5fb9741b94653f8945fa8b0ac36146a3910f037","type":"PACKAGE_SPEC","name":"TERM_TRANSP","schemaName":"DIRKSPZM32","sxml":""}