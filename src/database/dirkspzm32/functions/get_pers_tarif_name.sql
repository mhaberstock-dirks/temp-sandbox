create or replace function dirkspzm32.get_pers_tarif_name (
    in_pers_nr in pzm_personal.pers_nr%type
) return varchar2 is
    result varchar2(100);
begin
    select
        nvl(p.tarif_name, a.tarif_name)
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
end get_pers_tarif_name;
/


-- sqlcl_snapshot {"hash":"b1aece96cc1a2493bc544988512cb1c1496153c5","type":"FUNCTION","name":"GET_PERS_TARIF_NAME","schemaName":"DIRKSPZM32","sxml":""}