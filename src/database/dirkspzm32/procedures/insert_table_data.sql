create or replace 
procedure DIRKSPZM32.INSERT_TABLE_DATA(in_source_schema in varchar2,
                                              in_source_table_name in varchar2,
                                              in_destination_table_name varchar2,
                                              in_create_table boolean) is
--https://asktom.oracle.com/ords/asktom.search?tag=create-insert-statements-dynamically
  TYPE t_col_name IS TABLE OF ALL_TAB_COLS.column_name%TYPE;
  v_col_array t_col_name;
  v_col_sql varchar2(1000);
  v_owner_name varchar2(200);
  v_source_table_cols varchar2(3000);
  v_source_table_name varchar2(200);
  v_destination_table_name varchar2(200);
  v_insert_sql varchar2(3000);
  i integer;
begin
  v_source_table_cols := '';
  v_owner_name := in_source_schema;
  v_source_table_name := in_source_table_name;
  v_destination_table_name := in_source_table_name;
  IF (in_destination_table_name is not null) THEN
    v_destination_table_name := in_destination_table_name;
  END IF;
  -- Get source Colums of the Table
  v_col_sql := 'select COLUMN_NAME FROM sys.dba_tab_columns where owner = ''' || v_owner_name ||'''' ||
               ' and table_name = ''' || v_source_table_name ||'''' ||
               ' order by COLUMN_ID ';

  --DBMS_OUTPUT.PUT_LINE('col sql: ' || v_col_sql);

  execute immediate v_col_sql
  BULK COLLECT INTO v_col_array;

  FOR i IN 1..v_col_array.count
  LOOP
    v_source_table_cols := v_source_table_cols || v_col_array(i);
    if (i < v_col_array.count) then
      v_source_table_cols := v_source_table_cols || ',';
    end if;
  END LOOP;
  dbms_output.put_line('B colums: ' || v_source_table_cols);
  IF v_source_table_cols is Null THEN
      RAISE_APPLICATION_ERROR(-20001, 'No Columns found Check Owner, TableName and then the access rights for sys.dba_tab_columns ');
  END IF;
  -- Insert Statement
  IF in_create_table THEN
   BEGIN
     -- DROP Table if Exist
     EXECUTE IMMEDIATE 'DROP TABLE ' || v_destination_table_name;
     EXCEPTION
       WHEN OTHERS THEN
       IF SQLCODE != -942 THEN
         RAISE;
       END IF;
    END;
    v_insert_sql :=  'CREATE TABLE ' ||v_destination_table_name || ' AS
      SELECT *
      FROM ' || v_owner_name ||'.'||v_source_table_name;
  ELSE
    EXECUTE IMMEDIATE 'truncate Table  ' || v_destination_table_name;
    v_insert_sql :=  'insert into '|| v_destination_table_name ||
                     ' (' ||  v_source_table_cols  || ' ) select  * from ' || v_owner_name ||'.'||v_source_table_name;
  END IF;

  DBMS_OUTPUT.PUT_LINE('insert sql: ' || v_insert_sql);

  execute immediate
   v_insert_sql;
  commit;
end INSERT_TABLE_DATA;
/



-- sqlcl_snapshot {"hash":"30b2703e883ec0d9cb70d278759ca28e0b5de4e7","type":"PROCEDURE","name":"INSERT_TABLE_DATA","schemaName":"DIRKSPZM32","sxml":""}