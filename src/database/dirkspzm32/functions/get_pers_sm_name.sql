create or replace function dirkspzm32.get_pers_sm_name (
    in_pers_nr in pzm_personal.pers_nr%type
) return varchar2 is
    result pzm_schicht_modelle.sm_name%type;
begin
    if not pzm_utils.get_schicht_modell_name(in_pers_nr, result) then
        result := null;
    end if;

    return result;
exception
    when others then
        return ( null );
end get_pers_sm_name;
/


-- sqlcl_snapshot {"hash":"128eaacf8c11f63119c6054f3b1d234c6af63133","type":"FUNCTION","name":"GET_PERS_SM_NAME","schemaName":"DIRKSPZM32","sxml":""}