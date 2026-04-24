create or replace package dirkspzm32.sqlcl_lb_capture authid current_user is
    function sxmltoddl11 (
        sxml  in clob,
        otype in varchar2
    ) return clob;

    function get_deps (
        oname in varchar2,
        otype in varchar2
    ) return varchar2;

    function getsequence return number;

    function capture_object_type (
        p_rank                 in number,
        p_otype                varchar2,
        p_body                 varchar2 default 'on',
        p_constraints          varchar2 default 'on',
        p_constraints_as_alter varchar2 default 'on',
        p_force                varchar2 default 'on',
        p_inherit              varchar2 default 'on',
        p_inserts              varchar2 default 'on',
        p_partitioning         varchar2 default 'on',
        p_pretty               varchar2 default 'on',
        p_ref_constraints      varchar2 default 'on',
        p_segments             varchar2 default 'on',
        p_size_byte_keyword    varchar2 default 'on',
        p_specification        varchar2 default 'on',
        p_sqlterminator        varchar2 default 'on',
        p_storage              varchar2 default 'on',
        p_tablespace           varchar2 default 'on',
        p_lb_table_name        varchar2 default 'DATABASECHANGELOG',
        p_filter               varchar2 default null
    ) return varchar2;

    procedure sortcapturedobjects;

end;
/


-- sqlcl_snapshot {"hash":"10bf1d871b438f70436af5f7eacac28399472e22","type":"PACKAGE_SPEC","name":"SQLCL_LB_CAPTURE","schemaName":"DIRKSPZM32","sxml":""}