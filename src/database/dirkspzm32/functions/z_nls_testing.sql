create or replace 
function Z_NLS_TESTING return varchar2 is
  FunctionResult varchar2(255 char);
begin
  FunctionResult := 'Hällööö Wörld';
  return(FunctionResult);
end Z_NLS_TESTING;
/



-- sqlcl_snapshot {"hash":"28224a734f0b92f61bcff6349f8dd6cbc21a9bea","type":"FUNCTION","name":"Z_NLS_TESTING","schemaName":"DIRKSPZM32","sxml":""}