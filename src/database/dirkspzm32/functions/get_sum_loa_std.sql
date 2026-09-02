create or replace 
function GET_SUM_LOA_STD(p_pers_nr in number, p_datum in date, p_lohnart in varchar2) return number is
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



-- sqlcl_snapshot {"hash":"8ecce917e22e6206be2568343dcb2cb80b15281f","type":"FUNCTION","name":"GET_SUM_LOA_STD","schemaName":"DIRKSPZM32","sxml":""}