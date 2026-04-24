create or replace function dirkspzm32.get_pers_pb_id (
    in_pers_nr in pzm_personal.pers_nr%type
) return number is
    result number;
begin
    select
        nvl(p.pers_pb_id, a.abt_pb_id)
    into result
    from
        pzm_personal    p,
        pzm_abteilungen a
    where
            p.pers_nr = in_pers_nr
        and p.pers_abt_id = a.abt_id (+);

    return ( result );
exception
    when others then
        return ( null );
end get_pers_pb_id;
/


-- sqlcl_snapshot {"hash":"5893e5931d1cf1c3d750cdf791241dd121ae234b","type":"FUNCTION","name":"GET_PERS_PB_ID","schemaName":"DIRKSPZM32","sxml":""}