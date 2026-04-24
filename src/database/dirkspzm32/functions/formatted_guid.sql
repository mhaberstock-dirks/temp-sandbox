create or replace function dirkspzm32.formatted_guid (
    in_guid_value          in raw,                            --# Original (raw) guid value (can be table value or result of sys_guid())
    in_enclose_with_braces in varchar2 default 'F'   --# (optional) Indicate whether to enclose the result with curly braces or not.
) return varchar2 is                             --# Return: converted/formated guid value as varchar2
------------------------------------------------------------------------------------------------
--# Helper function to be used in SQL queries to get a formatted string representation
--# of a raw GUID
------------------------------------------------------------------------------------------------

    v_result varchar2(38);
begin
    v_result := substr(in_guid_value, 1, 8)
                || '-'
                || substr(in_guid_value, 9, 4)
                || '-'
                || substr(in_guid_value, 13, 4)
                || '-'
                || substr(in_guid_value, 17, 4)
                || '-'
                || substr(in_guid_value, 21);

    if ( in_enclose_with_braces = 'T' ) then
        v_result := '{'
                    || v_result
                    || '}';
    end if;

    return ( v_result );
end;
/


-- sqlcl_snapshot {"hash":"d27a1a0d20c907549050b87979358e13d59432e1","type":"FUNCTION","name":"FORMATTED_GUID","schemaName":"DIRKSPZM32","sxml":""}