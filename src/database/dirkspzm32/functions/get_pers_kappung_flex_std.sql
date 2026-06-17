create or replace 
function DIRKSPZM32.GET_PERS_KAPPUNG_FLEX_STD(in_pers_nr in pzm_personal.pers_nr%type
                                                    ) return number is

  Result number;
begin
  select nvl(p.pers_kappung_me_ab_flx_std, sm.kappung_me_ab_flx_std) into Result 
    from pzm_personal p,
         pzm_schicht_modelle sm
   where p.pers_nr = in_pers_nr
     and sm.sm_name(+) = p.pers_sm_name;
  return(Result);
exception
  when others then
    return(NULL);
end;
/



-- sqlcl_snapshot {"hash":"d5a751ea547c7c33238fed85fcd7b9969943a118","type":"FUNCTION","name":"GET_PERS_KAPPUNG_FLEX_STD","schemaName":"DIRKSPZM32","sxml":""}