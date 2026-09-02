
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_DB_DDL_LOG" 
 AFTER DDL
 ON SCHEMA
DECLARE
  l_sql ora_name_list_t;
  l_id NUMBER (10, 0);
BEGIN
  if ora_dict_obj_name not like 'DB_DDL_LOG%' then  -- diese lässt sich nicht ändern wenn hier geloggt wird
    SELECT db_ddl_log_id.NEXTVAL INTO l_id FROM DUAL;

    INSERT INTO db_ddl_log (event_id,
      event_date,
      user_id,
      object_name,
      owner,
      object_type,
      system_event,
      machine,
      program)
     (SELECT l_id,
          SYSDATE,
          ora_login_user,
          ora_dict_obj_name,
          ora_dict_obj_owner,
          ora_dict_obj_type,
          ora_sysevent,
          UPPER (SYS_CONTEXT ('USERENV', 'TERMINAL')),
          SYS_CONTEXT ('USERENV', 'MODULE')
       FROM DUAL);
  end if;
--FOR l IN 1 .. ora_sql_txt (l_sql)
--  LOOP
--    INSERT INTO DB_ddl_log_sql (event_id, sqlline, sqltext)
--      VALUES (l_id, l, l_sql (l));
--  END LOOP;
END;


/
ALTER TRIGGER "TRG_DB_DDL_LOG" ENABLE;


-- sqlcl_snapshot {"hash":"ad3b1e8d43a4011a4fb990c6cf3515624162d682","type":"TRIGGER","name":"TRG_DB_DDL_LOG","schemaName":"DIRKSPZM32","sxml":""}