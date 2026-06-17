create or replace 
function DIRKSPZM32.get_login_id_by_username(in_sid in isi_user.sid%type,
                                                    in_firma_nr in isi_user.firma_nr%type,
                                                    in_username in isi_user.username%type)
  return number is
  v_result number;

  cursor c_user is
    select t.login_id
      from isi_user t
     where t.sid = in_sid
       and t.firma_nr = in_firma_nr
       and t.username = in_username;
begin
  open c_user;
  fetch c_user into v_result;
  close c_user;

  return(v_result);
end get_login_id_by_username;
/



-- sqlcl_snapshot {"hash":"9a826151f64c2d5aafce53ee6e19e7e95528c376","type":"FUNCTION","name":"GET_LOGIN_ID_BY_USERNAME","schemaName":"DIRKSPZM32","sxml":""}