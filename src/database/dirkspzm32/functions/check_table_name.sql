create or replace 
function DIRKSPZM32.CHECK_TABLE_NAME (in_Table_Name in user_tables.TABLE_NAME%type)
                                          return varchar2 is

  v_select varchar2(255);
  v_table_name varchar2(255) := null;
  v_obj_TABLE varchar2(255) := 'TABLE';
  v_found number;

  begin
  v_table_name := in_Table_Name;
  v_found := 0;
  -- prüfen ob die angegebene Tabelle existiert
  v_select := 'SELECT count(*)
                FROM USER_OBJECTS
               WHERE OBJECT_TYPE = ' || '''' || v_obj_TABLE || '''' ||   --'''TABLE'''
               ' and OBJECT_NAME =' || '''' || in_Table_Name || '''';
  execute immediate v_select into v_found;

  if v_found = 0
    then
      v_table_name := in_Table_Name || ' -ist FALSCH- ';
  end if;

  return v_table_name;

  end check_table_name;
/



-- sqlcl_snapshot {"hash":"a17bf1fbfbd0643ede4d47bb9aecb0e889f70b3b","type":"FUNCTION","name":"CHECK_TABLE_NAME","schemaName":"DIRKSPZM32","sxml":""}