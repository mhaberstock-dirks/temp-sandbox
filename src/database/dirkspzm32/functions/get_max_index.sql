create or replace 
function get_max_index (in_Table_Name in user_tables.TABLE_NAME%type,
                                          in_Field_Name in varchar2)
                                          return number is

v_max_idx number;
v_select varchar2(255);
v_table_name varchar2(255);
v_field_name varchar2(255);

Begin
  v_table_name := in_Table_Name;
  v_field_name := in_Field_Name;
  v_max_idx := 0;
  -- prüfen ob die angegebene Tabelle und feld existieren
  v_table_name := check_table_name(in_Table_Name);
  if instr(v_table_name, 'FALSCH') = 0
    then
      v_field_name := check_field_name(in_Table_Name,in_Field_Name);
      if instr(v_field_name, 'FALSCH') = 0
        then
           v_select := 'select max(' || v_Field_Name || ')'||
               ' from '|| v_Table_Name;
    execute immediate v_select into v_max_idx;
        end if;
  end if;


return v_max_idx;

end get_max_index;
/



-- sqlcl_snapshot {"hash":"aab827ac0d189a9c77b11fca26a779ae76152e24","type":"FUNCTION","name":"GET_MAX_INDEX","schemaName":"DIRKSPZM32","sxml":""}