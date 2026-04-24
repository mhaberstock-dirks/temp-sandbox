create or replace function dirkspzm32.mhk_data_default (
    p_table_name  varchar2,
    p_column_name varchar2
) return varchar2 as

    l_query     varchar2(1000) := 'select data_default from user_tab_cols where table_name = :tn and column_name = :cn';
    l_from_byte number := 0;
    l_for_bytes number := 1000;
    l_cursor    integer default dbms_sql.open_cursor;
    l_long_val  long;
    l_buflen    integer;
    l_ignore    number;
begin
    dbms_sql.parse(l_cursor, l_query, dbms_sql.native);
    dbms_sql.bind_variable(l_cursor, ':tn', p_table_name);
    dbms_sql.bind_variable(l_cursor, ':cn', p_column_name);
    dbms_sql.define_column_long(l_cursor, 1);
    l_ignore := dbms_sql.execute(l_cursor);
    if ( dbms_sql.fetch_rows(l_cursor) > 0 ) then
        dbms_sql.column_value_long(
            c            => l_cursor,
            position     => 1,
            length       => l_for_bytes,
            offset       => l_from_byte,
            value        => l_long_val,
            value_length => l_buflen
        );
    end if;

    dbms_sql.close_cursor(l_cursor);
    return l_long_val;
exception
    when others then
        if dbms_sql.is_open(l_cursor) then
            dbms_sql.close_cursor(l_cursor);
        end if;
        raise;
end mhk_data_default;
/


-- sqlcl_snapshot {"hash":"e6879cc2d9e16e1b20eae2846803412dfc8d080e","type":"FUNCTION","name":"MHK_DATA_DEFAULT","schemaName":"DIRKSPZM32","sxml":""}