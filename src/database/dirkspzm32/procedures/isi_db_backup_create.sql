create or replace procedure dirkspzm32.isi_db_backup_create is

    v_pk          varchar2(251);
    v_table       varchar2(251);
    v_column_name varchar2(251);
    v_l_table     varchar2(251);
    v_l_pk        varchar2(251);
    v_pk_colums   varchar2(1024);
    v_akt_table   varchar2(251);
    cursor c_pk is
    select
        ut.table_name,
        uc.index_name,
        ic.column_name
    from
        user_tables      ut,
        user_constraints uc,
        user_ind_columns ic
    where
        ut.table_name not in ( 'ISI_DB_AKTIVITAET', 'ISI_DB_MA_SLA', 'DIS_CFG', 'ISI_SYSTEM_INFO', 'PE_JOBS',
                               'DB_TRACE', 'DB_TRACE_CFG', 'ISI_SCAN_LOG', 'ISI_DB_ACT_LOG', 'ISI_DB_BACKUP',
                               'ISI_LOG' )
        and ut.table_name not like 'GP%'
        and ut.table_name = uc.table_name (+)
        and uc.constraint_type = 'P'
        and uc.index_name = ic.index_name
    order by
        ut.table_name,
        uc.index_name,
        ic.column_position;

    cursor c_db_backup is
    select
        t.tab_name
    from
        isi_db_backup t
    where
        t.tab_name = v_l_table;

begin
    open c_pk;
    fetch c_pk into
        v_table,
        v_pk,
        v_column_name;
    v_l_table := v_table;
  --v_l_pk := v_pk;
    v_pk_colums := null;
    loop
        exit when c_pk%notfound;
        if v_l_table != v_table then
            open c_db_backup;
            fetch c_db_backup into v_akt_table;
            if c_db_backup%found then
                update isi_db_backup t
                set
                    t.tab_pk_keys = v_pk_colums
                where
                    t.tab_name = v_l_table;

            else
                dbms_output.put_line('Neue tabelle: ' || v_l_table);
                insert into isi_db_backup db_b (
                    db_b.tab_name,
                    db_b.tab_pk_keys
                ) values ( v_l_table,
                           v_pk_colums );

            end if;

            close c_db_backup;
            v_l_table := v_table;
            v_l_pk := v_pk;
            v_pk_colums := v_column_name;
        else
            if v_pk_colums is null then
                v_pk_colums := v_column_name;
            else
                v_pk_colums := v_pk_colums
                               || '@@'
                               || v_column_name;
            end if;
        end if;

        fetch c_pk into
            v_table,
            v_pk,
            v_column_name;
    end loop;

    close c_pk;
    delete isi_db_backup t
    where
        t.tab_name not in (
            select
                ut.table_name
            from
                user_tables ut
            where
                    ut.table_name != 'ISI_DB_AKTIVITAET'
                and ut.table_name != 'ISI_DB_MA_SLA'
        );

    commit;
end isi_db_backup_create;
/


-- sqlcl_snapshot {"hash":"3f6e660418bf484aaf188527df375804f67d2270","type":"PROCEDURE","name":"ISI_DB_BACKUP_CREATE","schemaName":"DIRKSPZM32","sxml":""}