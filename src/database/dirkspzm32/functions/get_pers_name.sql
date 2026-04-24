create or replace function dirkspzm32.get_pers_name (
    p_pers_nr in number
) return varchar2 is

    result varchar2(255);
    cursor c_persname is
    select
        pers_nname
        || ', '
        || pers_vname
    from
        pzm_personal
    where
        pers_nr = p_pers_nr;

begin
    result := '';
    open c_persname;
    fetch c_persname into result;
    if c_persname%notfound then
        result := '';
    end if;
    close c_persname;
    return ( result );
end get_pers_name;
/


-- sqlcl_snapshot {"hash":"d68f81e6e99208d0bf39e9df97ed30be38a5ea1d","type":"FUNCTION","name":"GET_PERS_NAME","schemaName":"DIRKSPZM32","sxml":""}