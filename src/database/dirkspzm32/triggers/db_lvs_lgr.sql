
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."DB_LVS_LGR" 
  after insert or update or delete on DIRKSPZM32.LVS_LGR
  for each row
declare
  -- local variables here
  v_pk_values  db_trace.act_pk_values%type;
  v_command    db_trace.act_command%type;
  v_info       db_trace.act_info%type;
begin
  -- Dieser Trigger verändert keine Daten. Hier werden nur alle Aktionen in eine Logtabelle geschrieben
  if db_p_trace.get_trigger_aktiv('LVS_LGR') = 0
  then
    return;
  end if;

  v_pk_values := null;
  if inserting
  then
    v_pk_values := :new.lgr_platz;
    v_command := 'INSERT';
    -- v_info := 'vorgang_id=' || :new.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :new.pos_nr || ';';
  elsif updating
  then
    v_pk_values := :new.lgr_platz;
    v_command := 'UPDATE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
    -- v_info := v_info || 'pos_nr=' || :old.pos_nr || ';';
  elsif deleting
  then
    v_pk_values := :old.lgr_platz;
    v_command := 'DELETE';
    -- v_info := 'vorgang_id=' || :old.vorgang_id || ';';
  end if;

  -- Autonome Transaktion
  db_p_trace.c_db_act_log('LVS_LGR',
                        'LGR_PLATZ',
                        v_pk_values,
                        v_command,
                        v_info);

  exception
    -- Wenn Fehler keine Exception (Rekursive Aufrufe vermeiden)
    when others then
      null;

end db_lvs_lgr;

/
ALTER TRIGGER "DIRKSPZM32"."DB_LVS_LGR" ENABLE;


-- sqlcl_snapshot {"hash":"37db71303f1dc7c18cc66a62a9d7b53a42a1744a","type":"TRIGGER","name":"DB_LVS_LGR","schemaName":"DIRKSPZM32","sxml":""}