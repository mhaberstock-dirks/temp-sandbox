create or replace function dirkspzm32.get_pers_abt_id (
    in_pers_nr in pzm_personal.pers_nr%type
) return number is
    result number;
begin
    select
        p.pers_abt_id
    into result
    from
        pzm_personal p
    where
        p.pers_nr = in_pers_nr;

    return ( result );
exception
    when others then
        return ( null );
end get_pers_abt_id;
/


-- sqlcl_snapshot {"hash":"52e99cc505d03502b95983bdaaba781699ec2116","type":"FUNCTION","name":"GET_PERS_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}