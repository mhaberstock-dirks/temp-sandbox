create or replace 
function DIRKSPZM32.get_anz_arbeitstage(p_pers_nr in integer,
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



-- sqlcl_snapshot {"hash":"9cf900a1a4f07f58d1ccd4f27461d4bb52172458","type":"FUNCTION","name":"GET_ANZ_ARBEITSTAGE","schemaName":"DIRKSPZM32","sxml":""}