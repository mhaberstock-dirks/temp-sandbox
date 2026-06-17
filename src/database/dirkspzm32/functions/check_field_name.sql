create or replace 
function DIRKSPZM32.CHECK_FIELD_NAME (in_Table_Name in user_tables.TABLE_NAME%type,
                                             in_Field_Name in varchar2)
                                          return varchar2 is

  v_select varchar2(255);
  v_table_name varchar2(255);
  v_field_name varchar2(255) := null;
  v_found number;

  begin
  v_field_name := in_Field_Name;
  v_found := 0;
  -- prüfen ob die angegebene Tabelle und feld existieren
  v_table_name := check_table_name(in_Table_Name);
  if instr(v_table_name, 'FALSCH') = 0
    then
       --prüfen ob das Feld existiert
      v_select := 'select count(*)
                    from USER_TAB_COLS
                   where table_name =' || '''' || in_Table_Name || '''' ||
                   ' and column_name =' || '''' || in_Field_Name || '''';
      execute immediate v_select into v_found;
      if v_found = 0
        then
          v_field_name := in_Field_Name || ' -FALSCH- ';
      end if;
   end if;

  return v_field_name;

  end check_field_name;
/



-- sqlcl_snapshot {"hash":"d8b101df3005bd4a596123c789eb99617de93794","type":"FUNCTION","name":"CHECK_FIELD_NAME","schemaName":"DIRKSPZM32","sxml":""}