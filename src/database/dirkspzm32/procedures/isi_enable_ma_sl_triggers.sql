create or replace 
procedure DIRKSPZM32.isi_enable_MA_SL_triggers (in_owner in varchar2) is
/*
DTs, 12.03.2021
Die Prozedur aktiviert alle Trigger die in der Tabelle: ISI_DB_AKTIVITAET schreiben.
Diese Prozedur soll bzw. muss ausgeführt werden
bei Systemen wo ein Master-Slave aufgesetzt ist.

!!! VORSICHT !!!
Diese Trigger dürfen nicht aktiviert werden bei Systemen die kein
Master-Slave System haben.
Sonst, durch das ständige Schreiben in der Tabelle ISI_DB_AKTIVITAET,
wird die DB voll laufen.
*/

/*
in_owner := definiert den user bzw. das zugehörige Schema
*/

v_trigger_name  varchar2(255);
v_owner         varchar2(255);
v_my_sql        varchar2(255);

CURSOR c_triggers is
  Select t.trigger_name
    from all_triggers t
   where t.owner=v_owner
     and t.trigger_name not like 'TR_%'
     and t.trigger_name not like 'R4_TR_%'
     and t.trigger_name not like 'DB_%'     --Triger die nur alle Aktionen in eine Logtabelle schreiben
     /*
     and t.TRIGGER_NAME not in('db_lvs_lam',
                                'db_isi_resource_zust_akt',
                                'db_bde_fa_auftrag_lte_pool',
                                'db_bde_fa_auftrag')
     */
order by t.TRIGGER_NAME asc;

begin

  v_owner:= in_owner;

  OPEN c_triggers;
  FETCH c_triggers into v_trigger_name;
  LOOP
    EXIT when c_triggers%NOTFOUND;
    v_my_sql := 'alter trigger ' || v_trigger_name  || ' enable';
    execute immediate v_my_sql;
    FETCH c_triggers into v_trigger_name;
  end LOOP;
  CLOSE c_triggers;


end isi_enable_MA_SL_triggers;
/



-- sqlcl_snapshot {"hash":"06f6f9759618ee4b456f8b6b441782cfe281ce03","type":"PROCEDURE","name":"ISI_ENABLE_MA_SL_TRIGGERS","schemaName":"DIRKSPZM32","sxml":""}