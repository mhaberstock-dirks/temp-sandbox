create or replace function dirkspzm32.check_field_name (
    in_table_name in user_tables.table_name%type,
    in_field_name in varchar2
) return varchar2 is

    v_select     varchar2(255);
    v_table_name varchar2(255);
    v_field_name varchar2(255) := null;
    v_found      number;
begin
    v_field_name := in_field_name;
    v_found := 0;
  -- prüfen ob die angegebene Tabelle und feld existieren
    v_table_name := check_table_name(in_table_name);
    if instr(v_table_name, 'FALSCH') = 0 then
       --prüfen ob das Feld existiert
        v_select := 'select count(*)
                    from USER_TAB_COLS
                   where table_name ='
                    || ''''
                    || in_table_name
                    || ''''
                    || ' and column_name ='
                    || ''''
                    || in_field_name
                    || '''';

        execute immediate v_select
        into v_found;
        if v_found = 0 then
            v_field_name := in_field_name || ' -FALSCH- ';
        end if;
    end if;

    return v_field_name;
end check_field_name;
/


-- sqlcl_snapshot {"hash":"7b071ef420bc15e9f57a780a757ad32f81978946","type":"FUNCTION","name":"CHECK_FIELD_NAME","schemaName":"DIRKSPZM32","sxml":""}