create or replace 
function DIRKSPZM32.GET_SUM_LOA_STD(p_pers_nr in number, p_datum in date, p_lohnart in varchar2) return number is
  Result number;
  CURSOR c_SumLOAStd IS
    SELECT zeaw_lz_loa_std
      FROM pzm_ze_loa_ausw
     WHERE zeaw_pers_nr = p_pers_nr AND
           zeaw_datum = TRUNC(p_datum) AND
           zeaw_lz_lohnart = p_lohnart;
begin
  OPEN c_SumLOAStd;

  FETCH c_SumLOAStd INTO Result;

  if c_SumLOAStd%NOTFOUND then
    Result := NULL;
  end if;

  CLOSE c_SumLOAStd;
  return(ROUND(Result, 2));
end GET_SUM_LOA_STD;
/



-- sqlcl_snapshot {"hash":"66bec0fc538e355c54d761e15b9f3da42ad5b691","type":"FUNCTION","name":"GET_SUM_LOA_STD","schemaName":"DIRKSPZM32","sxml":""}