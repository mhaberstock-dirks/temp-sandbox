
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ABWESENHEITSMELD_BD" 
  before delete on DIRKSPZM32."PZM_ABWESENHEITSMELDUNGEN"
  for each row
declare
  -- local variables here
  v_start_date date;
  v_end_date date;
  v_current_date date;

  v_SAKurzname     pzm_schichtarten.sa_kurzname%type;
  v_SABeginn       pzm_schichtarten.sa_beginn%type;
  v_SAEnde         pzm_schichtarten.sa_ende%type;
  v_SAStdProTag    number;
  v_schicht_vorh   boolean;
begin
  v_start_date := :old.beginn;
  v_end_date := :old.ende;

  v_current_date := v_start_date;
  while v_current_date <= v_end_date
  loop
    v_SAKurzname := null;
    v_schicht_vorh := get_schicht_daten(:old.pers_nr, v_current_date, v_current_date,
      v_SAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) = 1;

    delete pzm_abwes_plan t where t.pers_nr = :old.pers_nr and t.abwes_plan_tag = v_current_date;

    v_current_date := v_current_date + 1;
  end loop;
end;


/
ALTER TRIGGER "DIRKSPZM32"."TR_ABWESENHEITSMELD_BD" ENABLE;


-- sqlcl_snapshot {"hash":"4c40978ea01846cfa9851d41153505afde6e051b","type":"TRIGGER","name":"TR_ABWESENHEITSMELD_BD","schemaName":"DIRKSPZM32","sxml":""}