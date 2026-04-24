create or replace procedure dirkspzm32.isi_byte_to_char is

    v_table_name  varchar2(255);
    v_column_name varchar2(255);
    v_data_length number;
    v_my_sql      varchar2(255);
    v_job_nr      number;
    cursor c_tables is
    select
        t.table_name,
        t.column_name,
        t.data_length
    from
        all_tab_columns t
    where
            t.owner = (
                select
                    user
                from
                    dual
            )
        and ( ( t.char_used = 'B'
                and t.data_type = 'VARCHAR2' )
              or t.data_type in ( 'VARCHAR', 'CHAR' ) );

begin
    open c_tables;
    fetch c_tables into
        v_table_name,
        v_column_name,
        v_data_length;
    loop
        exit when c_tables%notfound;
        v_my_sql := 'alter table '
                    || v_table_name
                    || ' MODIFY ('
                    || v_column_name
                    || ' VARCHAR2('
                    || to_char(v_data_length)
                    || ' CHAR))';

        begin
            execute immediate v_my_sql;
        exception
            when others then
                dbms_output.put_line(v_my_sql);
        end;
        fetch c_tables into
            v_table_name,
            v_column_name,
            v_data_length;
    end loop;

    close c_tables;
end;
/


-- sqlcl_snapshot {"hash":"104ba667c553701e06d963392961c29f2a85f029","type":"PROCEDURE","name":"ISI_BYTE_TO_CHAR","schemaName":"DIRKSPZM32","sxml":""}