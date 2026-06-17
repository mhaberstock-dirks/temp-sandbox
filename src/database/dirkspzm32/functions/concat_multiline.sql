create or replace 
function DIRKSPZM32.concat_multiline(
  in_line1 in varchar2,              --# 
  in_line2 in varchar2,              --# 
  in_line3 in varchar2 default null, --# 
  in_line4 in varchar2 default null, --# 
  in_line5 in varchar2 default null, --# 
  in_line6 in varchar2 default null, --# 
  in_line7 in varchar2 default null, --# 
  in_line8 in varchar2 default null, --# 
  in_line9 in varchar2 default null, --# 
  in_line10 in varchar2 default null --# 
  ) return varchar2 is               --# 
------------------------------------------------------------------------------------------------
--# 
--# ---- HISTORY ---
--# 2013-10-01: (wkroeker) function created
------------------------------------------------------------------------------------------------

  v_result varchar2(4000);
begin
  v_result := in_line1;
  if in_line2 is not null
  then
    v_result := v_result || CR_LF() || in_line2;
  end if;
  if in_line3 is not null
  then
    v_result := v_result || CR_LF() || in_line3;
  end if;
  if in_line4 is not null
  then
    v_result := v_result || CR_LF() || in_line4;
  end if;
  if in_line5 is not null
  then
    v_result := v_result || CR_LF() || in_line5;
  end if;
  if in_line6 is not null
  then
    v_result := v_result || CR_LF() || in_line6;
  end if;
  if in_line7 is not null
  then
    v_result := v_result || CR_LF() || in_line7;
  end if;
  if in_line8 is not null
  then
    v_result := v_result || CR_LF() || in_line8;
  end if;
  if in_line9 is not null
  then
    v_result := v_result || CR_LF() || in_line9;
  end if;
  if in_line10 is not null
  then
    v_result := v_result || CR_LF() || in_line10;
  end if;
  
  return(v_result);
end;
/



-- sqlcl_snapshot {"hash":"06401c7d824fef3910e938e526803126de9c85f1","type":"FUNCTION","name":"CONCAT_MULTILINE","schemaName":"DIRKSPZM32","sxml":""}