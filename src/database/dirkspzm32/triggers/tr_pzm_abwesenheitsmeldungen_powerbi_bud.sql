
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD" 
  before update or delete
  on pzm_abwesenheitsmeldungen
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
ALTER TRIGGER "TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"dd2c531290d1e13ad08df9d25d99b9f632e4eb49","type":"TRIGGER","name":"TR_PZM_ABWESENHEITSMELDUNGEN_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}