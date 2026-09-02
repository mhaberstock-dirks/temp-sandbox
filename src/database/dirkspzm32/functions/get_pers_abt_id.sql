create or replace 
function GET_PERS_ABT_ID(in_pers_nr in pzm_personal.pers_nr%type
                                        ) return number is

  Result number;
begin
  select p.pers_abt_id into Result from pzm_personal p
   where p.pers_nr = in_pers_nr;
  return(Result);
exception
  when others then
    return(NULL);
end GET_PERS_ABT_ID;
/



-- sqlcl_snapshot {"hash":"6931cdf1b3e9d8594f01035f7f6e56ae398ed94c","type":"FUNCTION","name":"GET_PERS_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}