
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZEITERFASSUNG_POWERBI_BUD" 
  before update or delete
  on pzm_zeiterfassung
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
ALTER TRIGGER "TR_PZM_ZEITERFASSUNG_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"aa86287031dd651e0a9d0ea155967f0808891381","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}