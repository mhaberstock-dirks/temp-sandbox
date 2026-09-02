create or replace 
function GET_PERS_SM_NAME(in_pers_nr in pzm_personal.pers_nr%type
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



-- sqlcl_snapshot {"hash":"7effd676e6e29e83947a2c1834aa562508020dc1","type":"FUNCTION","name":"GET_PERS_SM_NAME","schemaName":"DIRKSPZM32","sxml":""}