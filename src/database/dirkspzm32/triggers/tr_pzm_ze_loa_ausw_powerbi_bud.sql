
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_AUSW_POWERBI_BUD" 
  before update or delete
  on DIRKSPZM32.pzm_ze_loa_ausw
  for each row
    
declare  
  v_is_reg        number;  
  
  CURSOR c_is_reg is
    select count(t.lnr)
      from z_pzm_pbi_delete t
     where t.tabelle = 'buchungsdaten'
       and t.lnr = 'LOA' || :old.zeaw_lz_lohnart || to_char(:old.zeaw_pers_nr) || to_char(:old.zeaw_datum, 'ddmmyyyy')
       and t.delete_date = sysdate;
  
begin
  OPEN c_is_reg;
  FETCH c_is_reg into v_is_reg;
  CLOSE c_is_reg;
  
  if v_is_reg = 0
  then
    begin
      -- auslastungsquote
      insert into z_pzm_pbi_delete
        (tabelle, lnr, delete_date, pers_nr)
      values
        ('buchungsdaten',
         'LOA' || :old.zeaw_lz_lohnart || to_char(:old.zeaw_pers_nr) || to_char(:old.zeaw_datum, 'ddmmyyyy'),
         sysdate,
         :old.zeaw_pers_nr);
    exception
      when others then NULL;
    end;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_AUSW_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"ba625e9cab43338002e7687ad2525f91df3831a5","type":"TRIGGER","name":"TR_PZM_ZE_LOA_AUSW_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}