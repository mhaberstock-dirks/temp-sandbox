create or replace function dirkspzm32.get_pers_kst_id (
    in_pers_nr in pzm_personal.pers_nr%type
) return number is
    result number;
begin
    select
        nvl(
            nvl(p.pers_kst_id, a.abt_kst_id),
            pb.pb_kst_id
        )
    into result
    from
        pzm_personal            p,
        pzm_abteilungen         a,
        pzm_produktionsbereiche pb
    where
            p.pers_nr = in_pers_nr
        and p.pers_abt_id = a.abt_id (+)
        and pb.pb_id = nvl(p.pers_pb_id, a.abt_pb_id);

    return ( result );
exception
    when others then
        return ( null );
end get_pers_kst_id;
/


-- sqlcl_snapshot {"hash":"f10ce345ca6c5e9863c3fc3fb19625c10d18670e","type":"FUNCTION","name":"GET_PERS_KST_ID","schemaName":"DIRKSPZM32","sxml":""}