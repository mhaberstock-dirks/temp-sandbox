create or replace 
function DIRKSPZM32.to_guid_string(in_raw_guid raw) return varchar2 is
  v_result_text varchar2(36);
begin
  v_result_text := regexp_replace(rawtohex(in_raw_guid), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5');
  return(lower(v_result_text));
end;
/



-- sqlcl_snapshot {"hash":"021365390c7ed5753300f55d4939885a23b105ea","type":"FUNCTION","name":"TO_GUID_STRING","schemaName":"DIRKSPZM32","sxml":""}