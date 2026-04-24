create or replace function dirkspzm32.get_pers_schicht_d_std (
    in_pers_nr in pzm_personal.pers_nr%type
) return number is
    v_sm_name pzm_schicht_modelle.sm_name%type;
    result    number;
begin
    result := null;
    if pzm_utils.get_schicht_modell_name(in_pers_nr, v_sm_name) then
        result := pzm_utils.pzm_get_sm_durch_std_tag(v_sm_name);
    end if;

    return nvl(result, 8);
exception
    when others then
        return ( null );
end get_pers_schicht_d_std;
/


-- sqlcl_snapshot {"hash":"c19b792d692b64e4c2d8bef5690ca3751e8f59b4","type":"FUNCTION","name":"GET_PERS_SCHICHT_D_STD","schemaName":"DIRKSPZM32","sxml":""}