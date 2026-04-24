create or replace editionable trigger dirkspzm32.tr_abwesenheits_antr_bd before
    delete on dirkspzm32.pzm_abwesenheits_antr
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

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr       number;
    v_err_text     varchar2(255);
begin
    v_start_date := :old.au_beginn;
    v_end_date := :old.au_ende;

  -- Anpassung HJg / MWe 20170210 Jira: P701074-1
    if :old.au_status != 0 then
        v_err_nr := 10;
        v_err_text := 'Fehler: Nur neu angelegte Anträge dürfen gelöscht werden.';
        raise v_error;
    end if;

    v_current_date := v_start_date;
    while v_current_date <= v_end_date loop
        v_sakurzname := null;
        v_schicht_vorh := get_schicht_daten(:old.au_pers_nr,
                                            v_current_date,
                                            v_current_date,
                                            v_sakurzname,
                                            v_sabeginn,
                                            v_saende,
                                            v_sastdprotag) = 1;

        delete pzm_abwes_plan t
        where
                t.pers_nr = :old.au_pers_nr
            and t.abwes_plan_tag = v_current_date;

        v_current_date := v_current_date + 1;
    end loop;

end;
/

alter trigger dirkspzm32.tr_abwesenheits_antr_bd enable;


-- sqlcl_snapshot {"hash":"907e79c9ee5d05dd7adbf4aebfbbfde61c4a7f87","type":"TRIGGER","name":"TR_ABWESENHEITS_ANTR_BD","schemaName":"DIRKSPZM32","sxml":""}