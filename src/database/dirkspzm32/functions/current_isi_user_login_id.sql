create or replace 
function DIRKSPZM32.current_isi_user_login_id return number is
  v_client_ident varchar2(255);
  v_isiusr varchar2(255);
  v_result number;
  cursor c_isi_user is
    select u.login_id
      from isi_user u
     where u.username = v_isiusr;
begin
  -- CLIENT_IDENTIFIER: Returns an identifier that is set by the application through the DBMS_SESSION.SET_IDENTIFIER
  -- procedure, the OCI attribute OCI_ATTR_CLIENT_IDENTIFIER, or the Java class
  -- Oracle.jdbc.OracleConnection.setClientIdentifier. This attribute is used by various database
  -- components to identify lightweight application users who authenticate as the same database user.
  v_client_ident := sys_context('USERENV', 'CLIENT_IDENTIFIER');
  v_isiusr := isi_utils.get_csv_value(v_client_ident, 'isiusr');

  open c_isi_user;
  fetch c_isi_user into v_result;
  if c_isi_user%notfound
  then
    v_result := -1; -- unknown / unidentified user
  end if;
  close c_isi_user;

  return(v_result);
end;
/



-- sqlcl_snapshot {"hash":"5fdbac7d8fb0fe6b894b7d041ee19c9963076b4b","type":"FUNCTION","name":"CURRENT_ISI_USER_LOGIN_ID","schemaName":"DIRKSPZM32","sxml":""}