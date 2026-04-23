create or replace function dirkspzm32.get_login_id_by_username (
    in_sid      in isi_user.sid%type,
    in_firma_nr in isi_user.firma_nr%type,
    in_username in isi_user.username%type
) return number is

    v_result number;
    cursor c_user is
    select
        t.login_id
    from
        isi_user t
    where
            t.sid = in_sid
        and t.firma_nr = in_firma_nr
        and t.username = in_username;

begin
    open c_user;
    fetch c_user into v_result;
    close c_user;
    return ( v_result );
end get_login_id_by_username;
/


-- sqlcl_snapshot {"hash":"7cb2282da418a398bc3185fb8a6589e6f671d6c5","type":"FUNCTION","name":"GET_LOGIN_ID_BY_USERNAME","schemaName":"DIRKSPZM32","sxml":""}