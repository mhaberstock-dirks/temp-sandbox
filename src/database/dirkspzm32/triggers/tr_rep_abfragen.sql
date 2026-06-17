
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_REP_ABFRAGEN" 
  before delete on DIRKSPZM32.rep_abfragen
  for each row
declare
  -- local variables here
begin
  DELETE FROM rep_sql_parameter WHERE rep_id = :old.rep_id;
  DELETE FROM rep_grid_columns_cfg WHERE rep_id = :old.rep_id;
  DELETE FROM rep_user_top_abfragen WHERE rep_id = :old.rep_id;
end tr_rep_abfragen;

/
ALTER TRIGGER "DIRKSPZM32"."TR_REP_ABFRAGEN" ENABLE;


-- sqlcl_snapshot {"hash":"12cded3290567d304a54ab287622c4da038b29cc","type":"TRIGGER","name":"TR_REP_ABFRAGEN","schemaName":"DIRKSPZM32","sxml":""}