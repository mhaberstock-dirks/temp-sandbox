create or replace function dirkspzm32.get_pers_kappung_flex_std (
    in_pers_nr in pzm_personal.pers_nr%type
) return number is
    result number;
begin
    select
        nvl(p.pers_kappung_me_ab_flx_std, sm.kappung_me_ab_flx_std)
    into result
    from
        pzm_personal        p,
        pzm_schicht_modelle sm
    where
            p.pers_nr = in_pers_nr
        and sm.sm_name (+) = p.pers_sm_name;

    return ( result );
exception
    when others then
        return ( null );
end;
/


-- sqlcl_snapshot {"hash":"9fc55fb49f93bdc470aba2c0dbb6d8ff133b745c","type":"FUNCTION","name":"GET_PERS_KAPPUNG_FLEX_STD","schemaName":"DIRKSPZM32","sxml":""}