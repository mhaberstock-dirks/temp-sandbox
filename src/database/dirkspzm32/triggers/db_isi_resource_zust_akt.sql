
  CREATE OR REPLACE EDITIONABLE TRIGGER "DB_ISI_RESOURCE_ZUST_AKT" 
  after insert or update or delete on ISI_RESOURCE_ZUST_AKT
  for each row
declare
  -- local variables here
  v_pk_values  db_trace.act_pk_values%type;
  v_command    db_trace.act_command%type;
  v_info       db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
  if db_p_trace.get_trigger_aktiv('ISI_RESOURCE_ZUST_AKT') = 0
  then
    return;
  end if;

  v_pk_values := null;
  if inserting
  then
    v_pk_values := :new.firma_nr|| ';' || :new.res_id|| ';' || :new.sid;
    v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
  elsif updating
  then
    v_pk_values := :new.firma_nr|| ';' || :new.res_id|| ';' || :new.sid;
    v_command := 'UPDATE';
    v_info := 'res_id=' ||:new.res_id || ';' || 'leitzahl=' || :new.leitzahl || '.' || :new.Fa_Ag || :new.fa_upos ||';' ||'lte_id=' || :new.lte_id || ';';

    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
  elsif deleting
  then
    v_pk_values := :old.firma_nr|| ';' || :old.res_id|| ';' || :old.sid;
    v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
  end if;

  -- Autonome Transaktion
  db_p_trace.c_db_act_log('ISI_RESOURCE_ZUST_AKT',
                        'FIRMA_NR;RES_ID;SID',
                        v_pk_values,
                        v_command,
                        v_info);

  exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
      null;

end db_isi_resource_zust_akt;


/
ALTER TRIGGER "DB_ISI_RESOURCE_ZUST_AKT" ENABLE;


-- sqlcl_snapshot {"hash":"ca310246ffc1406a3ffd30f8c1623e0a3f39e5e7","type":"TRIGGER","name":"DB_ISI_RESOURCE_ZUST_AKT","schemaName":"DIRKSPZM32","sxml":""}