create or replace 
function DIRKSPZM32.FRACTION_OF_DAY(p_value in date) return number is
  Result number;
begin
  -- gibt nur den BRuchteil des Tages zurück
  -- die Differenz der gegebenen Zeit, und dem Mitternachtswert der gegeben Zeit
  Result := (p_value - TRUNC(p_value));
  return(Result);
end FRACTION_OF_DAY;
/



-- sqlcl_snapshot {"hash":"4c8b1de18b3e90c0e542b2e11d7f907a77d4963e","type":"FUNCTION","name":"FRACTION_OF_DAY","schemaName":"DIRKSPZM32","sxml":""}