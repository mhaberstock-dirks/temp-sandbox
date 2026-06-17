
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_REP_SQL_PARAMETER_BIUD" 
  before insert or update or delete on DIRKSPZM32.rep_sql_parameter
  for each row
declare
  -- local variables here
  v_dummy rep_sql_parameter.param_id%type;
begin
  if INSERTING then
    select nvl(max(param_id), 0) + 1
      into :new.param_id
      from rep_sql_parameter
     where rep_id = :new.rep_id;

    if :new.order_index is null or :new.order_index = 0
    then
      :new.order_index := :new.param_id;
    end if;

    v_dummy := :new.rep_id;
    v_dummy := :new.param_id;
  end if;
end TR_REP_SQL_PARAMETER_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_REP_SQL_PARAMETER_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"4eaf4bb105127ab412584b3bc7c4bef981acf635","type":"TRIGGER","name":"TR_REP_SQL_PARAMETER_BIUD","schemaName":"DIRKSPZM32","sxml":""}