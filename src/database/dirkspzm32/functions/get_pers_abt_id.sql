create or replace 
function DIRKSPZM32.GET_PERS_ABT_ID(in_pers_nr in pzm_personal.pers_nr%type
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



-- sqlcl_snapshot {"hash":"3622c8220f99b109b2115932e4659da79a74d4ac","type":"FUNCTION","name":"GET_PERS_ABT_ID","schemaName":"DIRKSPZM32","sxml":""}