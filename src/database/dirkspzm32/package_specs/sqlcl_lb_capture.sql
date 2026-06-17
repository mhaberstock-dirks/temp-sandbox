create or replace 
PACKAGE DIRKSPZM32.sqlcl_lb_capture
AUTHID CURRENT_USER IS
    FUNCTION sxmltoddl11 (
        sxml  IN CLOB,
        otype IN VARCHAR2
    ) RETURN CLOB;
 FUNCTION get_deps (
        oname IN VARCHAR2,
        otype IN VARCHAR2
    ) RETURN VARCHAR2;
    FUNCTION getsequence RETURN NUMBER;
   FUNCTION capture_object_type (
         p_rank                 IN NUMBER,
         p_otype                VARCHAR2,
         p_body                 VARCHAR2 DEFAULT 'on',
         p_constraints          VARCHAR2 DEFAULT 'on',
        p_constraints_as_alter VARCHAR2 DEFAULT 'on',
         p_force                VARCHAR2 DEFAULT 'on',
         p_inherit              VARCHAR2 DEFAULT 'on',
         p_inserts              VARCHAR2 DEFAULT 'on',
        p_partitioning         VARCHAR2 DEFAULT 'on',
        p_pretty               VARCHAR2 DEFAULT 'on',
        p_ref_constraints      VARCHAR2 DEFAULT 'on',
        p_segments             VARCHAR2 DEFAULT 'on',
        p_size_byte_keyword    VARCHAR2 DEFAULT 'on',
        p_specification        VARCHAR2 DEFAULT 'on',
        p_sqlterminator        VARCHAR2 DEFAULT 'on',
        p_storage              VARCHAR2 DEFAULT 'on',
        p_tablespace           VARCHAR2 DEFAULT 'on',
        p_lb_table_name        VARCHAR2 DEFAULT 'DATABASECHANGELOG',
        p_filter               VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;
    PROCEDURE SORTCAPTUREDOBJECTS;
end;                
/



-- sqlcl_snapshot {"hash":"f5bdd927350797b683eaa5072c3f285e3cf04f96","type":"PACKAGE_SPEC","name":"SQLCL_LB_CAPTURE","schemaName":"DIRKSPZM32","sxml":""}