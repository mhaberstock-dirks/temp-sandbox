create or replace function dirkspzm32.current_isi_user return varchar2 is

    v_client_ident varchar2(255);
    v_isiusr       varchar2(255);
    v_result       number;
    cursor c_isi_user is
    select
        u.login_id
    from
        isi_user u
    where
        u.username = v_isiusr;

begin
  -- CLIENT_IDENTIFIER: Returns an identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER
  -- procedure, the OCI attribute OCI_ATTR_CLIENT_IDENTIFIER, or the Java class
  -- Oracle.jdbc.OracleConnection.setClientIdentifier. This attribute is used by various database
  -- components to identify lightweight application users who authenticate as the same database user.
    v_client_ident := sys_context('USERENV', 'CLIENT_IDENTIFIER');
    v_isiusr := isi_utils.get_csv_value(v_client_ident, 'isiusr');
    return ( v_isiusr );
end;
/


-- sqlcl_snapshot {"hash":"537cea1b0408b7ff2282ff0efbf63f04532cef15","type":"FUNCTION","name":"CURRENT_ISI_USER","schemaName":"DIRKSPZM32","sxml":""}