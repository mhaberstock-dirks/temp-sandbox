create or replace editionable trigger dirkspzm32.db_bde_fa_auftrag_lte_pool after
    insert or update or delete on dirkspzm32.bde_fa_auftrag_lte_pool
    for each row
declare
  -- local variables here
    v_pk_values db_trace.act_pk_values%type;
    v_command   db_trace.act_command%type;
    v_info      db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
    if db_p_trace.get_trigger_aktiv('bde_fa_auftrag_lte_pool') = 0 then
        return;
    end if;
    v_pk_values := null;
    if inserting then
        v_pk_values := :new.firma_nr
                       || ';'
                       || :new.lte_id
                       || ';'
                       || :new.sid;

        v_command := 'INSERT';
        v_info := 'leitzahl='
                  || :new.leitzahl
                  || ';'
                  || 'lte_id= '
                  || :new.lte_id
                  || ';'
                  || 'lte_verwendet='
                  || :new.lte_verwendet
                  || ';'
                  || 'status='
                  || :new.status
                  || ';'
                  || 'lfdn='
                  || :new.lte_lfdn;
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
    elsif updating then
        v_pk_values := :new.firma_nr
                       || ';'
                       || :new.lte_id
                       || ';'
                       || :new.sid;

        v_command := 'UPDATE';
        v_info := 'leitzahl='
                  || :new.leitzahl
                  || ';'
                  || 'lte_id= '
                  || :new.lte_id
                  || ';'
                  || 'lte_verwendet='
                  || :new.lte_verwendet
                  || ';'
                  || 'status='
                  || :new.status
                  || ';'
                  || 'lfdn='
                  || :new.lte_lfdn;
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
    elsif deleting then
        v_pk_values := :old.firma_nr
                       || ';'
                       || :old.lte_id
                       || ';'
                       || :old.sid;

        v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    end if;

  -- Autonome Transaktion
    db_p_trace.c_db_act_log('bde_fa_auftrag_lte_pool', 'FIRMA_NR;LTE_ID;SID', v_pk_values, v_command, v_info);
exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
        null;
end db_bde_fa_auftrag_lte_pool;
/

alter trigger dirkspzm32.db_bde_fa_auftrag_lte_pool enable;


-- sqlcl_snapshot {"hash":"a829dad048c970c20a2570ec036732aa34c99fd3","type":"TRIGGER","name":"DB_BDE_FA_AUFTRAG_LTE_POOL","schemaName":"DIRKSPZM32","sxml":""}