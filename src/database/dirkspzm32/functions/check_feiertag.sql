create or replace 
function DIRKSPZM32.CHECK_FEIERTAG(in_pb_id in pzm_produktionsbereiche.pb_id%type,
                                          in_abt_id           in pzm_abteilungen.abt_id%type,
                                          in_pers_nr          in pzm_personal.pers_nr%type,
                                          in_kst_id           in pzm_personal.pers_kst_id%type,
                                          in_datum in date) return varchar2 is
  Result varchar2(10);
  v_SonderFeiertag varchar2(5);
begin
  Result := '';
  if IST_FEIERTAG(in_pers_nr,
                  in_pb_id,
                  in_abt_id,
                  in_kst_id,
                  in_datum, 
                  v_SonderFeiertag) = 1 then
    Result := 'F';
    if (v_SonderFeiertag is not NULL) AND (v_SonderFeiertag <> '') then
      Result := 'SF';
    end if;
  end if;
  return(Result);
end CHECK_FEIERTAG;
/



-- sqlcl_snapshot {"hash":"69f65d5a30f992bf5640cbe68efb937538bb1991","type":"FUNCTION","name":"CHECK_FEIERTAG","schemaName":"DIRKSPZM32","sxml":""}