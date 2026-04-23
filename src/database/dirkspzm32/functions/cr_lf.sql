create or replace function dirkspzm32.cr_lf return varchar2 is --# Concatenated CR (0x0D) LF (0x0A) characters
------------------------------------------------------------------------------------------------
--# Helper function to retrieve concatenated carriage return and line feed characters
--# ---- HISTORY ---
--# 2013-09-12: (wkroeker) function created
------------------------------------------------------------------------------------------------
begin
    return ( chr(13) || chr(10) );
end cr_lf;
/


-- sqlcl_snapshot {"hash":"76af8c951f6f5b183aaccabb03d6ec6bb95166d4","type":"FUNCTION","name":"CR_LF","schemaName":"DIRKSPZM32","sxml":""}