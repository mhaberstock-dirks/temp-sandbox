create or replace 
function GET_PERS_SCHICHT_D_STD(in_pers_nr in pzm_personal.pers_nr%type
                                        ) return number is

  v_sm_name                      pzm_schicht_modelle.sm_name%type;
  
  Result number;
begin
  result := NULL;
  if pzm_utils.get_schicht_modell_name(in_pers_nr, v_sm_name)
  then
    Result := pzm_utils.pzm_get_sm_durch_std_tag(v_sm_name);
  end if;
  return nvl(Result, 8);
exception
  when others then
    return(NULL);
end GET_PERS_SCHICHT_D_STD;
/



-- sqlcl_snapshot {"hash":"e979a4ea2285718a444611624862a2c9846296d3","type":"FUNCTION","name":"GET_PERS_SCHICHT_D_STD","schemaName":"DIRKSPZM32","sxml":""}