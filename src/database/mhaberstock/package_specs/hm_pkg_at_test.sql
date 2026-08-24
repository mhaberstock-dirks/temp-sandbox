create or replace 
PACKAGE MHABERSTOCK.hm_pkg_at_test AS
    PROCEDURE log_event(
        p_caller_level  IN VARCHAR2,
        p_event_text    IN VARCHAR2,
        p_is_autonomous IN VARCHAR2 DEFAULT 'N'
    );

    PROCEDURE log_event_autonomous(
        p_caller_level  IN VARCHAR2,
        p_event_text    IN VARCHAR2
    );

    PROCEDURE nested_autonomous_level1;
    PROCEDURE nested_autonomous_level2;
END hm_pkg_at_test;
/



-- sqlcl_snapshot {"hash":"46c18ea5f900526a1e47f12482cdfd8bca35d5c2","type":"PACKAGE_SPEC","name":"HM_PKG_AT_TEST","schemaName":"MHABERSTOCK","sxml":""}