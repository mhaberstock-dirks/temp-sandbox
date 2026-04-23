create or replace procedure dirkspzm32.isi_enable is

    v_table_name     varchar2(255);
    v_constrane_name varchar2(255);
    v_my_sql         varchar2(255);
    v_job_nr         number;
    cursor c_tables is
    select
        t.table_name
    from
        user_tables t;

    cursor c_cons is
    select
        t.constraint_name
    from
        user_constraints t
    where
            t.table_name = v_table_name
        and t.constraint_type = 'R';

    cursor c_jobs is
    select
        t.job
    from
        user_jobs t
    where
        t.broken = 'Y';

begin
    open c_tables;
    fetch c_tables into v_table_name;
    loop
        exit when c_tables%notfound;
        v_my_sql := 'alter table '
                    || v_table_name
                    || ' enable all triggers';
        execute immediate v_my_sql;
        open c_cons;
        fetch c_cons into v_constrane_name;
        loop
            exit when c_cons%notfound;
            v_my_sql := 'alter table '
                        || v_table_name
                        || ' enable constraint '
                        || v_constrane_name;
            execute immediate v_my_sql;
            fetch c_cons into v_constrane_name;
        end loop;

        close c_cons;
        fetch c_tables into v_table_name;
    end loop;

    close c_tables;
    open c_jobs;
    loop
        fetch c_jobs into v_job_nr;
        exit when c_jobs%notfound;
        dbms_job.broken(v_job_nr, false);
    end loop;

    close c_jobs;
end isi_enable;
/


-- sqlcl_snapshot {"hash":"69bea35dbf46758fabc54ea5f1cd12fd30814bdb","type":"PROCEDURE","name":"ISI_ENABLE","schemaName":"DIRKSPZM32","sxml":""}