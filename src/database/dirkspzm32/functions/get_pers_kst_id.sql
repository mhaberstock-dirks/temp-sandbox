create or replace 
function DIRKSPZM32.GET_PERS_KST_ID(in_pers_nr in pzm_personal.pers_nr%type
                                        ) return number is
  Result number;
begin
  select nvl(nvl(p.pers_kst_id, a.abt_kst_id), pb.pb_kst_id) into Result
    from pzm_personal p,
         pzm_abteilungen a,
         pzm_produktionsbereiche pb
   where p.pers_nr = in_pers_nr
     and p.pers_abt_id = a.abt_id(+)
     and pb.pb_id = nvl(p.pers_pb_id, a.abt_pb_id);
  return(Result);
exception
  when others then
    return(NULL);
end GET_PERS_KST_ID;
/



-- sqlcl_snapshot {"hash":"89e141f4d9c2c48fa43cf4a9f462ba7b2966067f","type":"FUNCTION","name":"GET_PERS_KST_ID","schemaName":"DIRKSPZM32","sxml":""}