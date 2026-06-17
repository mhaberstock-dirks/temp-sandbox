
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD" 
  before update or delete
  on DIRKSPZM32.pzm_abwesenheitsmeldungen
  for each row
begin
  begin
    -- auslastungsquote
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('buchungsdaten', 
       'ABW' || :old.aa_id || to_char(:old.pers_nr) || to_char(:old.beginn, 'ddmmyyyy') || :old.aa_id,
       sysdate,
       :old.pers_nr);
  exception
    when others then NULL;
  end;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"2e4b8748e6d818baa43b208a9ee37ec1f5096cb6","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}