create or replace 
function DIRKSPZM32.GET_PERS_AUSTRITT(p_pers_nr in number) return date is
  Result date;
  CURSOR c_Personal IS
    SELECT pers_austrittdatum FROM pzm_personal WHERE pers_nr = p_pers_nr;
begin
  Result := NULL;

  OPEN c_Personal;

  FETCH c_Personal INTO Result;
  -- Wenn FETCH nicht gefunden hat, bleibt Result automatisch auf dem initialisierten Wert

  CLOSE c_Personal;

  return(Result);
end GET_PERS_AUSTRITT;
/



-- sqlcl_snapshot {"hash":"bfffa21e1cafcb0060f4c28e71a1fae10709cd01","type":"FUNCTION","name":"GET_PERS_AUSTRITT","schemaName":"DIRKSPZM32","sxml":""}