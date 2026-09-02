
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_POWERBI_BUD" 
  before update or delete
  on pzm_ze_loa_exp_ext_gutsch
  for each row
begin
  begin  
  -- auslastungsquote
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('buchungsdaten', 
       'PDL' || :old.pers_nr || :old.lohnart || to_char(:old.datum, 'ddmmyyyy'),
       sysdate,
       :old.pers_nr);
    insert into z_pzm_pbi_delete
      (tabelle, lnr, delete_date, pers_nr)
    values
      ('pdler', 
       'PDL' || to_char(:old.pers_nr) || to_char(:old.datum, 'ddmmyyyy') || :old.lohnart,
       sysdate,
       :old.pers_nr);
  exception
    when others then NULL;
  end;
end;


/
ALTER TRIGGER "TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_POWERBI_BUD" ENABLE;


-- sqlcl_snapshot {"hash":"12f746845995a6a49a6e79af0949886cdc690125","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_EXT_GUTSCH_POWERBI_BUD","schemaName":"DIRKSPZM32","sxml":""}