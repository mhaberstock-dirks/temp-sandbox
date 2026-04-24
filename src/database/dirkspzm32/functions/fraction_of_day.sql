create or replace function dirkspzm32.fraction_of_day (
    p_value in date
) return number is
    result number;
begin
  -- gibt nur den BRuchteil des Tages zurück
  -- die Differenz der gegebenen Zeit, und dem Mitternachtswert der gegeben Zeit
    result := ( p_value - trunc(p_value) );
    return ( result );
end fraction_of_day;
/


-- sqlcl_snapshot {"hash":"18a59881d674dfb9aa332d1bac4b4731b82af448","type":"FUNCTION","name":"FRACTION_OF_DAY","schemaName":"DIRKSPZM32","sxml":""}