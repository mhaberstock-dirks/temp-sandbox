create or replace editionable trigger dirkspzm32.db_bde_fa_auftrag after
    insert or update or delete on dirkspzm32.bde_fa_auftrag
    for each row
declare
  -- local variables here
    v_pk_values db_trace.act_pk_values%type;
    v_command   db_trace.act_command%type;
    v_info      db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
    if db_p_trace.get_trigger_aktiv('BDE_FA_AUFTRAG') = 0 then
        return;
    end if;
    v_pk_values := null;
    if inserting then
        v_pk_values := :new.fa_ag
                       || ';'
                       || :new.fa_upos
                       || ';'
                       || :new.leitzahl;

        v_command := 'INSERT';
        v_info := 'freig_status= '
                  || :new.freig_status
                  || '; '
                  || 'res_id= '
                  || :new.res_id
                  || '; '
                  || 'ag_ist_mg= '
                  || :new.ag_ist_mg
                  || '; '
                  || 'anz_res= '
                  || :new.anz_res
                  || '; '
                  || 'ag_soll_mg= '
                  || :new.ag_soll_mg
                  || '; '
                  || 'ab_soll_mg= '
                  || :new.ab_soll_mg
                  || ';'
                  || 'created_date= '
                  || :new.created_date
                  || '; '
                  || 'last_changed= '
                  || :new.last_change_date;
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
    elsif updating then
        v_pk_values := :new.fa_ag
                       || ';'
                       || :new.fa_upos
                       || ';'
                       || :new.leitzahl;

        v_command := 'UPDATE';
        v_info := 'new_freig_status= '
                  || :new.freig_status
                  || '; '
                  || 'old_freig_status= '
                  || :old.freig_status
                  || '; '
                  || 'new_ag_ist_mg= '
                  || :new.ag_ist_mg
                  || '; '
                  || 'old_ag_ist_mg= '
                  || :old.ag_ist_mg
                  || '; '
                  || 'new_ag_soll_mg= '
                  || :new.ag_soll_mg
                  || '; '
                  || 'old_ag_soll_mg= '
                  || :old.ag_soll_mg
                  || '; '
                  || 'new_ab_soll_mg= '
                  || :new.ab_soll_mg
                  || '; '
                  || 'old_ab_soll_mg= '
                  || :old.ab_soll_mg
                  || '; '
                  || 'last_changed= '
                  || :new.last_change_date
                  || '; '
                  || 'last_change_id= '
                  || :new.last_change_login_id;

    elsif deleting then
        v_pk_values := :old.fa_ag
                       || ';'
                       || :old.fa_upos
                       || ';'
                       || :old.leitzahl;

        v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    end if;

  -- Autonome Transaktion
    db_p_trace.c_db_act_log('BDE_FA_AUFTRAG', 'FA_AG;FA_UPOS;LEITZAHL', v_pk_values, v_command, v_info);
exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
        null;
end db_bde_fa_auftrag;
/

alter trigger dirkspzm32.db_bde_fa_auftrag enable;


-- sqlcl_snapshot {"hash":"ec47c677d1168343e8514d23179d2609f375ec65","type":"TRIGGER","name":"DB_BDE_FA_AUFTRAG","schemaName":"DIRKSPZM32","sxml":""}