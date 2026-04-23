create or replace editionable trigger dirkspzm32.db_lvs_lgr after
    insert or update or delete on dirkspzm32.lvs_lgr
    for each row
declare
  -- local variables here
    v_pk_values db_trace.act_pk_values%type;
    v_command   db_trace.act_command%type;
    v_info      db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
    if db_p_trace.get_trigger_aktiv('LVS_LGR') = 0 then
        return;
    end if;
    v_pk_values := null;
    if inserting then
        v_pk_values := :new.lgr_platz;
        v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
    elsif updating then
        v_pk_values := :new.lgr_platz;
        v_command := 'UPDATE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
    elsif deleting then
        v_pk_values := :old.lgr_platz;
        v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    end if;

  -- Autonome Transaktion
    db_p_trace.c_db_act_log('LVS_LGR', 'LGR_PLATZ', v_pk_values, v_command, v_info);
exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
        null;
end db_lvs_lgr;
/

alter trigger dirkspzm32.db_lvs_lgr enable;


-- sqlcl_snapshot {"hash":"6e54a13645a4a92471801646b3a504db67b6b734","type":"TRIGGER","name":"DB_LVS_LGR","schemaName":"DIRKSPZM32","sxml":""}