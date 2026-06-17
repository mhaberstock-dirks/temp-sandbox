create or replace 
procedure DIRKSPZM32.isi_enable is

  v_table_name     varchar2(255);
  v_constrane_name varchar2(255);
  v_my_sql         varchar2(255);

  v_job_nr         number;

CURSOR c_tables is
  select t.table_name
    from user_tables t;

CURSOR c_cons is
  select t.constraint_name
    from user_constraints t
   where t.table_name = v_table_name
     and t.constraint_type = 'R';

CURSOR c_jobs is
  select t.job
    from user_jobs t
   where t.BROKEN = 'Y';

begin
  OPEN c_tables;
  FETCH c_tables into v_table_name;
  LOOP
    EXIT when c_tables%NOTFOUND;
    v_my_sql := 'alter table ' || v_table_name  || ' enable all triggers';
    execute immediate v_my_sql;

    OPEN c_cons;
    FETCH c_cons into v_constrane_name;
    LOOP
      EXIT when c_cons%NOTFOUND;
      v_my_sql := 'alter table ' || v_table_name  || ' enable constraint ' || v_constrane_name;
      execute immediate v_my_sql;
      FETCH c_cons into v_constrane_name;
    end LOOP;
    CLOSE c_cons;
    FETCH c_tables into v_table_name;
  end LOOP;
  CLOSE c_tables;

  OPEN c_jobs;
  LOOP
    FETCH c_jobs into v_job_nr;
    EXIT WHEN c_jobs%NOTFOUND;
    dbms_job.broken(v_job_nr, FALSE);
  END LOOP;
  CLOSE c_jobs;

end isi_enable;
/



-- sqlcl_snapshot {"hash":"63972f93a63f0e415481a3b5dabe440eacd7d77a","type":"PROCEDURE","name":"ISI_ENABLE","schemaName":"DIRKSPZM32","sxml":""}