
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ABWESENHEITS_ANTR_POWERBI_BUD" 
  before update or delete
  on DIRKSPZM32.pzm_abwesenheits_antr
  for each row
begin
  begin
  -- auslastungsquote
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('buchungsdaten', 
       'ABW-ANT' || :old.au_abwes_art || to_char(:old.au_pers_nr) || to_char(:old.au_beginn, 'ddmmyyyy') || :old.au_status,
       sysdate,
       :old.au_pers_nr);
  exception
    when others then NULL;
  end;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ABWESENHEITS_ANTR_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"e4882adebee23e5dd88068fcd5bbf795323ff7fc","type":"TRIGGER","name":"TR_PZM_ABWESENHEITS_ANTR_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}