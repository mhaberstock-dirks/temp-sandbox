create or replace force editionable view dirkspzm32.isi_tables_and_columns (
    modul,
    table_name,
    table_comments,
    column_name,
    nullable,
    data_type,
    data_length,
    column_comments
) as
    select
        substr(ut.table_name,
               1,
               instr(ut.table_name, '_') - 1) as modul,
        ut.table_name,
        utco.comments                         table_comments,
        utf.column_name,
        utf.nullable,
        utf.data_type,
        utf.data_length,
        substr(ucc.comments, 1, 500)          column_comments
    from
        user_tables       ut,
        user_tab_comments utco,
        user_tab_cols     utf,
        user_col_comments ucc
    where
            ut.table_name = utco.table_name
        and ut.table_name = utf.table_name
        and utf.table_name = ucc.table_name
        and utf.column_name = ucc.column_name
    order by
        ut.table_name,
        utf.column_id;


-- sqlcl_snapshot {"hash":"bf39fe9ac6dab59c27fc5dc0a97fa395c334be85","type":"VIEW","name":"ISI_TABLES_AND_COLUMNS","schemaName":"DIRKSPZM32","sxml":""}