create or replace 
function GET_PERS_TARIF_NAME(in_pers_nr in pzm_personal.pers_nr%type
                                        ) return varchar2 is
  Result varchar2(100);
begin
  select nvl(p.tarif_name, a.tarif_name) into Result
    from pzm_personal p,
         pzm_abteilungen a
   where p.pers_nr = in_pers_nr
     and p.pers_abt_id = a.abt_id(+);
  return(Result);
exception
  when others then
    return(NULL);
end GET_PERS_TARIF_NAME;
/



-- sqlcl_snapshot {"hash":"c5ffc8985c5a37bf371b20d38c37a7ff82cea51b","type":"FUNCTION","name":"GET_PERS_TARIF_NAME","schemaName":"DIRKSPZM32","sxml":""}