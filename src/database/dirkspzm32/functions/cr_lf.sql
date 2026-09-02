create or replace 
function cr_lf
  return varchar2 is --# Concatenated CR (0x0D) LF (0x0A) characters
------------------------------------------------------------------------------------------------
--# Helper function to retrieve concatenated carriage return and line feed characters
--# ---- HISTORY ---
--# 2013-09-12: (wkroeker) function created
------------------------------------------------------------------------------------------------
begin
  return(chr(13) || chr(10));
end cr_lf;
/



-- sqlcl_snapshot {"hash":"e07da1106468a1da725ae269d6ac9d59cddc3fba","type":"FUNCTION","name":"CR_LF","schemaName":"DIRKSPZM32","sxml":""}