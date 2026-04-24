create or replace editionable trigger dirkspzm32.db_lvs_lam after
    insert or update or delete on dirkspzm32.lvs_lam
    for each row
declare
  -- local variables here
    v_pk_values db_trace.act_pk_values%type;
    v_command   db_trace.act_command%type;
    v_info      db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
    if db_p_trace.get_trigger_aktiv('lvs_lam') = 0 then
        return;
    end if;
    v_pk_values := null;
    if inserting then
        v_pk_values := :new.firma_nr
                       || ';'
                       || :new.lam_id
                       || ';'
                       || :new.sid;

        v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
    elsif updating then
        v_pk_values := :new.firma_nr
                       || ';'
                       || :new.lam_id
                       || ';'
                       || :new.sid;

        v_command := 'UPDATE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
    elsif deleting then
        v_pk_values := :old.firma_nr
                       || ';'
                       || :old.lam_id
                       || ';'
                       || :old.sid;

        v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    end if;

  -- Autonome Transaktion
    db_p_trace.c_db_act_log('lvs_lam', 'FIRMA_NR;LAM_ID;SID', v_pk_values, v_command, v_info);
exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
        null;
end db_lvs_lam;
/

alter trigger dirkspzm32.db_lvs_lam enable;


-- sqlcl_snapshot {"hash":"820ef78a624debca42ded39448f948df5d57c980","type":"TRIGGER","name":"DB_LVS_LAM","schemaName":"DIRKSPZM32","sxml":""}