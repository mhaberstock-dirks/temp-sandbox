
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_REP_ABFRAGEN" 
  before delete on rep_abfragen
  for each row
declare
  -- local variables here
begin
  DELETE FROM rep_sql_parameter WHERE rep_id = :old.rep_id;
  DELETE FROM rep_grid_columns_cfg WHERE rep_id = :old.rep_id;
  DELETE FROM rep_user_top_abfragen WHERE rep_id = :old.rep_id;
end tr_rep_abfragen;


/
ALTER TRIGGER "TR_REP_ABFRAGEN" ENABLE;


-- sqlcl_snapshot {"hash":"36a99ad14b4a7062138936b19cc7c5dedb680ffc","type":"TRIGGER","name":"TR_REP_ABFRAGEN","schemaName":"DIRKSPZM32","sxml":""}