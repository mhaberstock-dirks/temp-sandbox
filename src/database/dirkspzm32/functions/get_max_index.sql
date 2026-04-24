create or replace function dirkspzm32.get_max_index (
    in_table_name in user_tables.table_name%type,
    in_field_name in varchar2
) return number is

    v_max_idx    number;
    v_select     varchar2(255);
    v_table_name varchar2(255);
    v_field_name varchar2(255);
begin
    v_table_name := in_table_name;
    v_field_name := in_field_name;
    v_max_idx := 0;
  -- prüfen ob die angegebene Tabelle und feld existieren
    v_table_name := check_table_name(in_table_name);
    if instr(v_table_name, 'FALSCH') = 0 then
        v_field_name := check_field_name(in_table_name, in_field_name);
        if instr(v_field_name, 'FALSCH') = 0 then
            v_select := 'select max('
                        || v_field_name
                        || ')'
                        || ' from '
                        || v_table_name;
            execute immediate v_select
            into v_max_idx;
        end if;

    end if;

    return v_max_idx;
end get_max_index;
/


-- sqlcl_snapshot {"hash":"cf30227742abb7f8261cbc60eed4fa894c7072ec","type":"FUNCTION","name":"GET_MAX_INDEX","schemaName":"DIRKSPZM32","sxml":""}