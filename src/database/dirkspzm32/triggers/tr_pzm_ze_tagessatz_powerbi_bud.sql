
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZE_TAGESSATZ_POWERBI_BUD" 
  before update or delete
  on PZM_ZE_TAGESSATZ
  for each row
begin
  -- auslastungsquote
  begin
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('auslastungsquote', 
       to_char(:old.ts_pers_nr * 1000000000) + to_number(to_char(:old.ts_datum, 'yyyymmdd')) * 10 + 0,
       sysdate,
       :old.ts_pers_nr);
  exception
    when others then NULL;
  end;
  begin
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('auslastungsquote', 
       to_char(:old.ts_pers_nr * 1000000000) + to_number(to_char(:old.ts_datum, 'yyyymmdd')) * 10 + 1,
       sysdate,
       :old.ts_pers_nr);
  exception
    when others then NULL;
  end;
  begin
    -- kostenstellensplit
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('kostenstellensplit', 
       substr(:old.ts_pers_nr || :old.ts_day_kst_id || to_char(:old.ts_datum, 'ddmmyyyy') || 'Anwesende_Zeit', 1, 150),
       sysdate,
       :old.ts_pers_nr);
  exception
    when others then NULL;
  end;
  begin
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('kostenstellensplit',
       substr(:old.ts_pers_nr || :old.ts_day_kst_id || to_char(:old.ts_datum, 'ddmmyyyy') || :old.ts_aa_id, 1, 150),
       sysdate,
       :old.ts_pers_nr);
  exception
    when others then NULL;
  end;
end;


/
ALTER TRIGGER "TR_PZM_ZE_TAGESSATZ_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"50b2b57681cdd19df6e2ec94e3e67f38b376774a","type":"TRIGGER","name":"TR_PZM_ZE_TAGESSATZ_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}