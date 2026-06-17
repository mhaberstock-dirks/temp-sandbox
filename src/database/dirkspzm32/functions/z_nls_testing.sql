create or replace 
function DIRKSPZM32.Z_NLS_TESTING return varchar2 is
  FunctionResult varchar2(255 char);
begin
  FunctionResult := 'Hällööö Wörld';
  return(FunctionResult);
end Z_NLS_TESTING;
/



-- sqlcl_snapshot {"hash":"56d85c3bce2ff0c02aed3f062809d1c8170fbc37","type":"FUNCTION","name":"Z_NLS_TESTING","schemaName":"DIRKSPZM32","sxml":""}