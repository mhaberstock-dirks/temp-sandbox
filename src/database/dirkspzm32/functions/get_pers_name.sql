create or replace 
function GET_PERS_NAME(p_pers_nr in number) return varchar2 is
  Result varchar2(255);

  CURSOR c_PersName IS
     SELECT pers_nname||', '||pers_vname from pzm_personal WHERE pers_nr = p_pers_nr;
begin
  Result := '';

  OPEN c_PersName;

  FETCH c_PersName INTO Result;

  if c_PersName%NOTFOUND then
     Result := '';
  end if;

  CLOSE c_PersName;

  return(Result);
end GET_PERS_NAME;
/



-- sqlcl_snapshot {"hash":"60b9361bd5a51b1c58ed7b540ac3b7b978beb2ff","type":"FUNCTION","name":"GET_PERS_NAME","schemaName":"DIRKSPZM32","sxml":""}