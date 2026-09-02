create or replace 
function get_anz_arbeitstage(p_pers_nr in integer,
                                               p_start_datum    in date,
                                               p_ende_datum     in date,
                                               p_einflussfaktor in integer)
  return number is
  Result number(15, 1);

begin
  result := get_anz_arbeitstage_R32(p_pers_nr => p_pers_nr,
                                    p_start_datum => p_start_datum,
                                    p_ende_datum => p_ende_datum);
  return(Result);
end;
/



-- sqlcl_snapshot {"hash":"d1a559366651d36a2e45bc2878a8743274b90ec2","type":"FUNCTION","name":"GET_ANZ_ARBEITSTAGE","schemaName":"DIRKSPZM32","sxml":""}