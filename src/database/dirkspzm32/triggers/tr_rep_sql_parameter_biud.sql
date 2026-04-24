create or replace editionable trigger dirkspzm32.tr_rep_sql_parameter_biud before
    insert or update or delete on dirkspzm32.rep_sql_parameter
    for each row
declare
  -- local variables here
    v_dummy rep_sql_parameter.param_id%type;
begin
    if inserting then
        select
            nvl(
                max(param_id),
                0
            ) + 1
        into :new.param_id
        from
            rep_sql_parameter
        where
            rep_id = :new.rep_id;

        if :new.order_index is null
           or :new.order_index = 0 then
            :new.order_index := :new.param_id;
        end if;

        v_dummy := :new.rep_id;
        v_dummy := :new.param_id;
    end if;
end tr_rep_sql_parameter_biud;
/

alter trigger dirkspzm32.tr_rep_sql_parameter_biud enable;


-- sqlcl_snapshot {"hash":"d9c1b8500106d15c19f76c1f38cd870051f9f8b7","type":"TRIGGER","name":"TR_REP_SQL_PARAMETER_BIUD","schemaName":"DIRKSPZM32","sxml":""}