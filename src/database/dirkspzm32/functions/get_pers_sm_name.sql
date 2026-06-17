create or replace 
function DIRKSPZM32.GET_PERS_SM_NAME(in_pers_nr in pzm_personal.pers_nr%type
                                        ) return varchar2 is

  Result pzm_schicht_modelle.sm_name%type;
begin
  if not pzm_utils.get_schicht_modell_name(in_pers_nr, Result)
  then
    Result := NULL;
  end if;
  return Result;
exception
  when others then
    return(NULL);
end GET_PERS_SM_NAME;
/



-- sqlcl_snapshot {"hash":"1b29f0b561d818340add956205206b1b5e99eb02","type":"FUNCTION","name":"GET_PERS_SM_NAME","schemaName":"DIRKSPZM32","sxml":""}