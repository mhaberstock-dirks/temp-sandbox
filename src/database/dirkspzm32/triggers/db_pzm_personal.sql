create or replace editionable trigger dirkspzm32.db_pzm_personal after
    insert or update or delete on dirkspzm32.pzm_personal
    for each row
declare
  -- local variables here
    v_pk_values db_trace.act_pk_values%type;
    v_command   db_trace.act_command%type;
    v_info      db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
    if db_p_trace.get_trigger_aktiv('pzm_personal') = 0 then
        return;
    end if;
    v_pk_values := null;
    if inserting then
        v_pk_values := :new.pers_nr;
        v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
    elsif updating then
        v_pk_values := :new.pers_nr;
        v_command := 'UPDATE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
    elsif deleting then
        v_pk_values := :old.pers_nr;
        v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    end if;

  -- Autonome Transaktion
    db_p_trace.c_db_act_log('pzm_personal', 'PERS_NR', v_pk_values, v_command, v_info);
exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
        null;
end db_pzm_personal;
/

alter trigger dirkspzm32.db_pzm_personal enable;


-- sqlcl_snapshot {"hash":"30e6b404d85ec800adcc4e66a66dc15d8c44541c","type":"TRIGGER","name":"DB_PZM_PERSONAL","schemaName":"DIRKSPZM32","sxml":""}