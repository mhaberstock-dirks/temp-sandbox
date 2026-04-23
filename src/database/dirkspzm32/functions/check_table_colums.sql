create or replace function dirkspzm32.check_table_colums (
    in_source_schema      in varchar2,
    in_destination_schema in varchar2,
    in_table_name         in varchar2
) return varchar2 is

    type t_col_name is
        table of all_tab_cols.column_name%type;
    v_col_array      t_col_name;
    v_col_array_dest t_col_name;
    v_column_name    varchar2(200);
    v_col_sql_source varchar2(1000);
    v_col_sql_dest   varchar2(1000);
    v_result         varchar2(2);
begin
    v_result := 'T';
    v_col_sql_source := 'select COLUMN_NAME FROM sys.dba_tab_columns where owner = '''
                        || in_source_schema
                        || ''''
                        || ' and table_name = '''
                        || in_table_name
                        || ''''
                        || ' order by COLUMN_ID ';

  --DBMS_OUTPUT.PUT_LINE('col sql: ' || v_col_sql);
    execute immediate v_col_sql_source
    bulk collect
    into v_col_array;
    for i in 1..v_col_array.count loop
        v_column_name := v_col_array(i);
        v_col_sql_dest := 'select COLUMN_NAME FROM sys.dba_tab_columns where owner = '''
                          || in_destination_schema
                          || ''''
                          || ' and table_name = '''
                          || in_table_name
                          || ''''
                          || ' and column_name = '''
                          || v_column_name
                          || ''''
                          || ' order by COLUMN_ID ';

        execute immediate v_col_sql_dest
        bulk collect
        into v_col_array_dest;
    -- Check if Column is in Destination
        if v_col_array_dest.count = 0 then
            v_result := 'F';
        end if;
    end loop;

    return ( v_result );
end check_table_colums;
/


-- sqlcl_snapshot {"hash":"d15ca2088647f3e54d4d14cb7034a0fc1def8993","type":"FUNCTION","name":"CHECK_TABLE_COLUMS","schemaName":"DIRKSPZM32","sxml":""}