create or replace editionable trigger dirkspzm32.trg_db_ddl_log
    after ddl on schema declare
        l_sql ora_name_list_t;
        l_id  number(10, 0);
    begin
        if ora_dict_obj_name not like 'DB_DDL_LOG%' then  -- diese lässt sich nicht ändern wenn hier geloggt wird
            select
                db_ddl_log_id.nextval
            into l_id
            from
                dual;

            insert into db_ddl_log (
                event_id,
                event_date,
                user_id,
                object_name,
                owner,
                object_type,
                system_event,
                machine,
                program
            )
                (
                    select
                        l_id,
                        sysdate,
                        ora_login_user,
                        ora_dict_obj_name,
                        ora_dict_obj_owner,
                        ora_dict_obj_type,
                        ora_sysevent,
                        upper(sys_context('USERENV', 'TERMINAL')),
                        sys_context('USERENV', 'MODULE')
                    from
                        dual
                );

        end if;
--FOR l IN 1 .. ora_sql_txt (l_sql)
--  LOOP
--    INSERT INTO DB_ddl_log_sql (event_id, sqlline, sqltext)
--      VALUES (l_id, l, l_sql (l));
--  END LOOP;
    end;
/

alter trigger dirkspzm32.trg_db_ddl_log enable;


-- sqlcl_snapshot {"hash":"198316f6026ff717aaf6983e4dd7e9804ddc3558","type":"TRIGGER","name":"TRG_DB_DDL_LOG","schemaName":"DIRKSPZM32","sxml":""}