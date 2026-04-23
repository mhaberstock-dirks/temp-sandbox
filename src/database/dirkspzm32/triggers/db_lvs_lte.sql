create or replace editionable trigger dirkspzm32.db_lvs_lte after
    insert or update or delete on dirkspzm32.lvs_lte
    for each row
declare
  -- local variables here
    v_pk_values db_trace.act_pk_values%type;
    v_command   db_trace.act_command%type;
    v_info      db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
    if db_p_trace.get_trigger_aktiv('LVS_LTE') = 0 then
        return;
    end if;
    v_pk_values := null;
    if inserting then
        v_pk_values := :new.lte_id;
        v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
    elsif updating then
        v_pk_values := :new.lte_id;
        v_command := 'UPDATE';
        v_info := 'lte_id='
                  || :new.lte_id
                  || 'lgr_platz='
                  || :new.lgr_platz
                  || 'lte_status='
                  || :new.lte_status;
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
    elsif deleting then
        v_pk_values := :old.lte_id;
        v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    end if;

  -- Autonome Transaktion
    db_p_trace.c_db_act_log('LVS_LTE', 'LTE_ID', v_pk_values, v_command, v_info);
exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
        null;
end db_lvs_lte;
/

alter trigger dirkspzm32.db_lvs_lte enable;


-- sqlcl_snapshot {"hash":"a1c78fccde3c0a99346cfefe461df601562e0a28","type":"TRIGGER","name":"DB_LVS_LTE","schemaName":"DIRKSPZM32","sxml":""}