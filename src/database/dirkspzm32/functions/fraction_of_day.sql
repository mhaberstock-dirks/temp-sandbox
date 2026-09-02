create or replace 
function FRACTION_OF_DAY(p_value in date) return number is
  Result number;
begin
  -- gibt nur den BRuchteil des Tages zurück
  -- die Differenz der gegebenen Zeit, und dem Mitternachtswert der gegeben Zeit
  Result := (p_value - TRUNC(p_value));
  return(Result);
end FRACTION_OF_DAY;
/



-- sqlcl_snapshot {"hash":"ce6e2853d59695a9e4662744483019b4464289a2","type":"FUNCTION","name":"FRACTION_OF_DAY","schemaName":"DIRKSPZM32","sxml":""}