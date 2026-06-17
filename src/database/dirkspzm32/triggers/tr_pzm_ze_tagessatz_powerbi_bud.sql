
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_TAGESSATZ_POWERBI_BUD" 
  before update or delete
  on DIRKSPZM32.PZM_ZE_TAGESSATZ
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_TAGESSATZ_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"1ce0435f8f0a3bfc534a08472b63c6aca31d5599","type":"TRIGGER","name":"TR_PZM_ZE_TAGESSATZ_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}