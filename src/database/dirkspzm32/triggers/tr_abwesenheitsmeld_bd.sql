create or replace editionable trigger dirkspzm32.tr_abwesenheitsmeld_bd before
    delete on dirkspzm32.pzm_abwesenheitsmeldungen
    for each row
declare
  -- local variables here
    v_start_date   date;
    v_end_date     date;
    v_current_date date;
    v_sakurzname   pzm_schichtarten.sa_kurzname%type;
    v_sabeginn     pzm_schichtarten.sa_beginn%type;
    v_saende       pzm_schichtarten.sa_ende%type;
    v_sastdprotag  number;
    v_schicht_vorh boolean;
begin
    v_start_date := :old.beginn;
    v_end_date := :old.ende;
    v_current_date := v_start_date;
    while v_current_date <= v_end_date loop
        v_sakurzname := null;
        v_schicht_vorh := get_schicht_daten(:old.pers_nr,
                                            v_current_date,
                                            v_current_date,
                                            v_sakurzname,
                                            v_sabeginn,
                                            v_saende,
                                            v_sastdprotag) = 1;

        delete pzm_abwes_plan t
        where
                t.pers_nr = :old.pers_nr
            and t.abwes_plan_tag = v_current_date;

        v_current_date := v_current_date + 1;
    end loop;

end;
/

alter trigger dirkspzm32.tr_abwesenheitsmeld_bd enable;


-- sqlcl_snapshot {"hash":"e73b4f2504e4a144b864e99afad7d518239c5e74","type":"TRIGGER","name":"TR_ABWESENHEITSMELD_BD","schemaName":"DIRKSPZM32","sxml":""}