create or replace function dirkspzm32.to_guid_string (
    in_raw_guid raw
) return varchar2 is
    v_result_text varchar2(36);
begin
    v_result_text := regexp_replace(
        rawtohex(in_raw_guid),
        '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})',
        '\1-\2-\3-\4-\5'
    );
    return ( lower(v_result_text) );
end;
/


-- sqlcl_snapshot {"hash":"e6c86cca17e3a6e21da209f595ed7503ed38dc88","type":"FUNCTION","name":"TO_GUID_STRING","schemaName":"DIRKSPZM32","sxml":""}