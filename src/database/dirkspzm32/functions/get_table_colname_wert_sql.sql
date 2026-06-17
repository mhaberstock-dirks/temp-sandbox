create or replace 
function DIRKSPZM32.Get_table_Colname_wert_sql(in_tabelle in varchar2) return varchar2 is

v_sql       varchar2(10000);
v_col_name  varchar2(100);
v_komma     varchar2(2);
i           integer;

CURSOR c_col_name is
  select t.column_name from user_tab_cols t
  where t.table_name = in_tabelle;

begin
  v_komma := NULL;
  v_sql := 'select ';
  dbms_output.put_line(v_sql);
  i := 0;
  OPEN c_col_name;
  FETCH c_col_name into v_col_name;
  LOOP
    exit when c_col_name%NOTFOUND;
    v_sql := v_sql || v_komma || '''' || v_col_name || ''' as UEB_' || to_char(i) || ', ' || v_col_name;
    dbms_output.put_line(v_komma || '''' || v_col_name || ''' as U_' || to_char(i) || ', ' || v_col_name);
    i := i + 1;
    v_komma := ', ';
    FETCH c_col_name into v_col_name;
  end loop;
  CLOSE c_col_name;
  v_sql := v_sql || ' from ' || in_tabelle;
  dbms_output.put_line(' from ' || in_tabelle);
  --execute immediate v_sql;

  return(v_sql);
end Get_table_Colname_wert_sql;
/



-- sqlcl_snapshot {"hash":"a75b2f20f1400aea1de593cbb275ebb065343c61","type":"FUNCTION","name":"GET_TABLE_COLNAME_WERT_SQL","schemaName":"DIRKSPZM32","sxml":""}