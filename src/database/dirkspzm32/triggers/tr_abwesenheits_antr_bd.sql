
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ABWESENHEITS_ANTR_BD" 
  before delete on DIRKSPZM32."PZM_ABWESENHEITS_ANTR"
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

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);

begin
  v_start_date := :old.au_beginn;
  v_end_date := :old.au_ende;

  -- Anpassung HJg / MWe 20170210 Jira: P701074-1
  if :old.au_status != 0
  then
    v_err_nr := 10;
    v_err_text := 'Fehler: Nur neu angelegte Anträge dürfen gelöscht werden.';
    raise v_error;
  end if;

  v_current_date := v_start_date;
  while v_current_date <= v_end_date
  loop
    v_SAKurzname := null;
    v_schicht_vorh := get_schicht_daten(:old.au_pers_nr, v_current_date, v_current_date,
      v_SAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) = 1;

    delete pzm_abwes_plan t where t.pers_nr = :old.au_pers_nr and t.abwes_plan_tag = v_current_date;

    v_current_date := v_current_date + 1;
  end loop;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ABWESENHEITS_ANTR_BD" ENABLE;


-- sqlcl_snapshot {"hash":"0b61ebe438b7b0e23436df2ca6c77b0c1ae53f2d","type":"TRIGGER","name":"TR_ABWESENHEITS_ANTR_BD","schemaName":"DIRKSPZM32","sxml":""}