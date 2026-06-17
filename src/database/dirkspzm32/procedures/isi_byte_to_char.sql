create or replace 
procedure DIRKSPZM32.isi_byte_to_char is

  v_table_name     varchar2(255);
  v_column_name    varchar2(255);
  v_data_length    number;
  v_my_sql         varchar2(255);

  v_job_nr         number;

CURSOR c_tables is
  select t.table_name, t.column_name, t.data_length
    from all_tab_columns t
   where t.owner = (SELECT USER FROM DUAL)
     and ( (t.char_used = 'B' and t.data_type = 'VARCHAR2')
         or t.data_type in ('VARCHAR', 'CHAR'));

begin
  OPEN c_tables;
  FETCH c_tables into v_table_name, v_column_name, v_data_length;
  LOOP
    EXIT when c_tables%NOTFOUND;
    
    
    v_my_sql := 'alter table ' || v_table_name  || ' MODIFY (' ||  v_column_name || ' VARCHAR2(' || to_char(v_data_length) || ' CHAR))';
    begin
      execute immediate v_my_sql;
    exception
      when others then 
        dbms_output.put_line(v_my_sql);
    end;

  FETCH c_tables into v_table_name, v_column_name, v_data_length;
  end LOOP;
  CLOSE c_tables;

end;
/



-- sqlcl_snapshot {"hash":"da0b12d601fee34f9adae8d6c62b2fe74acf2c4a","type":"PROCEDURE","name":"ISI_BYTE_TO_CHAR","schemaName":"DIRKSPZM32","sxml":""}