create or replace editionable trigger dirkspzm32.tr_rep_abfragen before
    delete on dirkspzm32.rep_abfragen
    for each row
declare
  -- local variables here
 begin
    delete from rep_sql_parameter
    where
        rep_id = :old.rep_id;

    delete from rep_grid_columns_cfg
    where
        rep_id = :old.rep_id;

    delete from rep_user_top_abfragen
    where
        rep_id = :old.rep_id;

end tr_rep_abfragen;
/

alter trigger dirkspzm32.tr_rep_abfragen enable;


-- sqlcl_snapshot {"hash":"5f5e4876016dc2a37648f42d946f8ff862525b91","type":"TRIGGER","name":"TR_REP_ABFRAGEN","schemaName":"DIRKSPZM32","sxml":""}