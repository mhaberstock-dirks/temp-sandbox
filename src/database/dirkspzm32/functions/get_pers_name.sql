create or replace 
function DIRKSPZM32.GET_PERS_NAME(p_pers_nr in number) return varchar2 is
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



-- sqlcl_snapshot {"hash":"3ca956f3e532354229a741ba9ef3d3fe52d6cf75","type":"FUNCTION","name":"GET_PERS_NAME","schemaName":"DIRKSPZM32","sxml":""}