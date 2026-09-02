
  CREATE OR REPLACE EDITIONABLE TRIGGER "DB_BDE_FA_AUFTRAG_LTE_POOL" 
  after insert or update or delete on bde_fa_auftrag_lte_pool
  for each row
declare
  -- local variables here
  v_pk_values  db_trace.act_pk_values%type;
  v_command    db_trace.act_command%type;
  v_info       db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
  if db_p_trace.get_trigger_aktiv('bde_fa_auftrag_lte_pool') = 0
  then
    return;
  end if;

  v_pk_values := null;
  if inserting
  then
    v_pk_values := :new.firma_nr|| ';' || :new.lte_id|| ';' || :new.sid;
    v_command := 'INSERT';
    v_info := 'leitzahl=' || :new.leitzahl || ';' || 'lte_id= ' || :new.Lte_id ||';'|| 'lte_verwendet=' ||:new.lte_verwendet || ';' || 'status=' ||:new.status || ';' || 'lfdn='|| :new.lte_lfdn;
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
  elsif updating
  then
    v_pk_values := :new.firma_nr|| ';' || :new.lte_id|| ';' || :new.sid;
    v_command := 'UPDATE';
    v_info := 'leitzahl=' || :new.leitzahl || ';' || 'lte_id= ' || :new.Lte_id ||';'|| 'lte_verwendet=' ||:new.lte_verwendet || ';' || 'status=' ||:new.status || ';' || 'lfdn='|| :new.lte_lfdn;
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
  elsif deleting
  then
    v_pk_values := :old.firma_nr|| ';' || :old.lte_id|| ';' || :old.sid;
    v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
  end if;

  -- Autonome Transaktion
  db_p_trace.c_db_act_log('bde_fa_auftrag_lte_pool',
                        'FIRMA_NR;LTE_ID;SID',
                        v_pk_values,
                        v_command,
                        v_info);

  exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
      null;

end db_bde_fa_auftrag_lte_pool;


/
ALTER TRIGGER "DB_BDE_FA_AUFTRAG_LTE_POOL" ENABLE;


-- sqlcl_snapshot {"hash":"afd15c43b896572e0ae035721fa7260911e00cb7","type":"TRIGGER","name":"DB_BDE_FA_AUFTRAG_LTE_POOL","schemaName":"DIRKSPZM32","sxml":""}