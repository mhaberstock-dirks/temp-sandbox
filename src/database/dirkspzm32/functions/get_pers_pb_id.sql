create or replace 
function DIRKSPZM32.GET_PERS_PB_ID(in_pers_nr in pzm_personal.pers_nr%type
                                        ) return number is

  Result number;
begin
  select nvl(p.pers_pb_id, a.abt_pb_id) into Result 
    from pzm_personal p,
         pzm_abteilungen a
   where p.pers_nr = in_pers_nr
     and p.pers_abt_id = a.abt_id(+);
  return(Result);
exception
  when others then
    return(NULL);
end GET_PERS_PB_ID;
/



-- sqlcl_snapshot {"hash":"917532aca4600ac7bf53bc80a5ffe30aceaf336d","type":"FUNCTION","name":"GET_PERS_PB_ID","schemaName":"DIRKSPZM32","sxml":""}