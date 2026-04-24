create or replace procedure dirkspzm32.insert_table_data (
    in_source_schema          in varchar2,
    in_source_table_name      in varchar2,
    in_destination_table_name varchar2,
    in_create_table           boolean
) is
--https://asktom.oracle.com/ords/asktom.search?tag=create-insert-statements-dynamically
    type t_col_name is
        table of all_tab_cols.column_name%type;
    v_col_array              t_col_name;
    v_col_sql                varchar2(1000);
    v_owner_name             varchar2(200);
    v_source_table_cols      varchar2(3000);
    v_source_table_name      varchar2(200);
    v_destination_table_name varchar2(200);
    v_insert_sql             varchar2(3000);
    i                        integer;
begin
    v_source_table_cols := '';
    v_owner_name := in_source_schema;
    v_source_table_name := in_source_table_name;
    v_destination_table_name := in_source_table_name;
    if ( in_destination_table_name is not null ) then
        v_destination_table_name := in_destination_table_name;
    end if;
  -- Get source Colums of the Table
    v_col_sql := 'select COLUMN_NAME FROM sys.dba_tab_columns where owner = '''
                 || v_owner_name
                 || ''''
                 || ' and table_name = '''
                 || v_source_table_name
                 || ''''
                 || ' order by COLUMN_ID ';

  --DBMS_OUTPUT.PUT_LINE('col sql: ' || v_col_sql);
    execute immediate v_col_sql
    bulk collect
    into v_col_array;
    for i in 1..v_col_array.count loop
        v_source_table_cols := v_source_table_cols || v_col_array(i);
        if ( i < v_col_array.count ) then
            v_source_table_cols := v_source_table_cols || ',';
        end if;

    end loop;

    dbms_output.put_line('B colums: ' || v_source_table_cols);
    if v_source_table_cols is null then
        raise_application_error(-20001, 'No Columns found Check Owner, TableName and then the access rights for sys.dba_tab_columns '
        );
    end if;
  -- Insert Statement
    if in_create_table then
        begin
     -- DROP Table if Exist
            execute immediate 'DROP TABLE ' || v_destination_table_name;
        exception
            when others then
                if sqlcode != -942 then
                    raise;
                end if;
        end;

        v_insert_sql := 'CREATE TABLE '
                        || v_destination_table_name
                        || ' AS
      SELECT *
      FROM '
                        || v_owner_name
                        || '.'
                        || v_source_table_name;

    else
        execute immediate 'truncate Table  ' || v_destination_table_name;
        v_insert_sql := 'insert into '
                        || v_destination_table_name
                        || ' ('
                        || v_source_table_cols
                        || ' ) select  * from '
                        || v_owner_name
                        || '.'
                        || v_source_table_name;

    end if;

    dbms_output.put_line('insert sql: ' || v_insert_sql);
    execute immediate v_insert_sql;
    commit;
end insert_table_data;
/


-- sqlcl_snapshot {"hash":"0633377420c51c5772cbb2f88e4da6aeba701a09","type":"PROCEDURE","name":"INSERT_TABLE_DATA","schemaName":"DIRKSPZM32","sxml":""}