create or replace function dirkspzm32.check_table_name (
    in_table_name in user_tables.table_name%type
) return varchar2 is

    v_select     varchar2(255);
    v_table_name varchar2(255) := null;
    v_obj_table  varchar2(255) := 'TABLE';
    v_found      number;
begin
    v_table_name := in_table_name;
    v_found := 0;
  -- prüfen ob die angegebene Tabelle existiert
    v_select := 'SELECT count(*)
                FROM USER_OBJECTS
               WHERE OBJECT_TYPE = '
                || ''''
                || v_obj_table
                || ''''
                ||   --'''TABLE'''
                 ' and OBJECT_NAME ='
                || ''''
                || in_table_name
                || '''';

    execute immediate v_select
    into v_found;
    if v_found = 0 then
        v_table_name := in_table_name || ' -ist FALSCH- ';
    end if;
    return v_table_name;
end check_table_name;
/


-- sqlcl_snapshot {"hash":"1587c17ab44b3f9da955865470c8dd009500ee34","type":"FUNCTION","name":"CHECK_TABLE_NAME","schemaName":"DIRKSPZM32","sxml":""}