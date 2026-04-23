create or replace function dirkspzm32.get_pers_austritt (
    p_pers_nr in number
) return date is
    result date;
    cursor c_personal is
    select
        pers_austrittdatum
    from
        pzm_personal
    where
        pers_nr = p_pers_nr;

begin
    result := null;
    open c_personal;
    fetch c_personal into result;
  -- Wenn FETCH nicht gefunden hat, bleibt Result automatisch auf dem initialisierten Wert

    close c_personal;
    return ( result );
end get_pers_austritt;
/


-- sqlcl_snapshot {"hash":"af3ee3dc6657105df4f53bdd119d4cb3e7ccd835","type":"FUNCTION","name":"GET_PERS_AUSTRITT","schemaName":"DIRKSPZM32","sxml":""}