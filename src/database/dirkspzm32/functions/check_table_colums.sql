create or replace 
function DIRKSPZM32.CHECK_TABLE_COLUMS (in_source_schema in varchar2,
                                               in_destination_schema in varchar2,
                                               in_table_name in varchar2)
                                          return varchar2 is

  TYPE t_col_name IS TABLE OF ALL_TAB_COLS.column_name%TYPE;
  v_col_array t_col_name;
  v_col_array_dest t_col_name;
  v_column_name varchar2(200);
  v_col_sql_source varchar2(1000);
  v_col_sql_dest varchar2(1000);
  v_result varchar2(2);

begin
  v_result := 'T';
  v_col_sql_source := 'select COLUMN_NAME FROM sys.dba_tab_columns where owner = ''' || in_source_schema ||'''' ||
                      ' and table_name = ''' || in_table_name ||'''' ||
                      ' order by COLUMN_ID ';


  --DBMS_OUTPUT.PUT_LINE('col sql: ' || v_col_sql);

  execute immediate v_col_sql_Source
  BULK COLLECT INTO v_col_array;

  FOR i IN 1..v_col_array.count
  LOOP
    v_column_name := v_col_array(i);
    v_col_sql_dest  := 'select COLUMN_NAME FROM sys.dba_tab_columns where owner = ''' || in_destination_schema ||'''' ||
                      ' and table_name = ''' || in_table_name ||'''' ||
                      ' and column_name = ''' || v_column_name ||'''' ||
                      ' order by COLUMN_ID ';

    execute immediate v_col_sql_dest
    BULK COLLECT INTO v_col_array_dest;
    -- Check if Column is in Destination
    IF v_col_array_dest.count  = 0 THEN
      v_result := 'F';

    END IF;
  END LOOP;

  return (v_result);
  
end CHECK_TABLE_COLUMS;
/



-- sqlcl_snapshot {"hash":"54c677012bc0e1d3b40f45f85af65016c80aba02","type":"FUNCTION","name":"CHECK_TABLE_COLUMS","schemaName":"DIRKSPZM32","sxml":""}