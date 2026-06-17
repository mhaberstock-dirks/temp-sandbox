
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZEITERFASSUNG_POWERBI_BUD" 
  before update or delete
  on DIRKSPZM32.pzm_zeiterfassung
  for each row
begin
  begin
  -- auslastungsquote
    if updating and :new.last_change_date < sysdate
    then
      return;
    end if;
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('buchungsdaten',
       'ZE' || to_char(:old.ze_pers_nr) || to_char(:old.ze_calc_ist_start, 'ddmmyyyyhh24mi'),
       sysdate,
       :old.ze_pers_nr);
  exception
    when others then NULL;
  end;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZEITERFASSUNG_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"166c5efb3be5f2c75002c6c63eb58b0b447339be","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}