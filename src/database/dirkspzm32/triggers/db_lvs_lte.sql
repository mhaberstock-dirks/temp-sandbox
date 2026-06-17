
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."DB_LVS_LTE" 
  after insert or update or delete on DIRKSPZM32.LVS_LTE
  for each row
declare
  -- local variables here
  v_pk_values  db_trace.act_pk_values%type;
  v_command    db_trace.act_command%type;
  v_info       db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
  if db_p_trace.get_trigger_aktiv('LVS_LTE') = 0
  then
    return;
  end if;

  v_pk_values := null;
  if inserting
  then
    v_pk_values := :new.lte_id;
    v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
  elsif updating
  then
    v_pk_values := :new.lte_id;
    v_command := 'UPDATE';
    v_info := 'lte_id=' || :new.lte_id || 'lgr_platz=' || :new.lgr_platz || 'lte_status=' || :new.lte_status;
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
  elsif deleting
  then
    v_pk_values := :old.lte_id;
    v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
  end if;

  -- Autonome Transaktion
  db_p_trace.c_db_act_log('LVS_LTE',
                        'LTE_ID',
                        v_pk_values,
                        v_command,
                        v_info);

  exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
      null;

end db_lvs_lte;

/
ALTER TRIGGER "DIRKSPZM32"."DB_LVS_LTE" ENABLE;


-- sqlcl_snapshot {"hash":"23d538d60e019a226accef391b99cb75c0a0a216","type":"TRIGGER","name":"DB_LVS_LTE","schemaName":"DIRKSPZM32","sxml":""}