create or replace 
FUNCTION DIRKSPZM32.mhk_data_default
(
  p_table_name  VARCHAR2
 ,p_column_name VARCHAR2
) RETURN VARCHAR2 AS
  l_query     VARCHAR2(1000) := 'select data_default from user_tab_cols where table_name = :tn and column_name = :cn';
  l_from_byte NUMBER := 0;
  l_for_bytes NUMBER := 1000;
  l_cursor    INTEGER DEFAULT dbms_sql.open_cursor;
  l_long_val  LONG;
  l_buflen    INTEGER;
  l_ignore    NUMBER;
BEGIN
  dbms_sql.parse(l_cursor, l_query, dbms_sql.native);

  dbms_sql.bind_variable(l_cursor, ':tn', p_table_name);
  dbms_sql.bind_variable(l_cursor, ':cn', p_column_name);

  dbms_sql.define_column_long(l_cursor, 1);
  l_ignore := dbms_sql.execute(l_cursor);

  IF (dbms_sql.fetch_rows(l_cursor) > 0) THEN
    dbms_sql.column_value_long(c            => l_cursor
                              ,position     => 1
                              ,length       => l_for_bytes
                              ,offset       => l_from_byte
                              ,VALUE        => l_long_val
                              ,value_length => l_buflen);
  END IF;

  dbms_sql.close_cursor(l_cursor);

  RETURN l_long_val;
EXCEPTION
  WHEN OTHERS THEN
    IF dbms_sql.is_open(l_cursor) THEN
      dbms_sql.close_cursor(l_cursor);
    END IF;
    RAISE;
END mhk_data_default;
/



-- sqlcl_snapshot {"hash":"2762ab361070be170c1f3c3f5de3cb8ad42294aa","type":"FUNCTION","name":"MHK_DATA_DEFAULT","schemaName":"DIRKSPZM32","sxml":""}