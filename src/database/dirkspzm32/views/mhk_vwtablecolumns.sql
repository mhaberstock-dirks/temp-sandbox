create or replace force editionable view dirkspzm32.mhk_vwtablecolumns (
    table_name,
    column_name,
    ordinal_position,
    column_default,
    is_nullable,
    data_type,
    is_rowguid,
    is_identity
) as
    select
        sao.object_name  as table_name,
        sac.column_name,
        sac.column_id    as ordinal_position,
--clh.tableType, clh.tableName, clh.columnName, clh.displayText,
        sac.data_default as column_default,
        case sac.nullable
            when 'Y' then
                'YES'
            when 'N' then
                'NO'
        end              as is_nullable,
        sac.data_type,
        case
            when trim(upper(mhk_data_default(table_name, column_name))) = 'SYS_GUID()' then
                1
            else
                0
        end              as is_rowguid,
        case
            when sac.identity_column = 'YES' then
                1
            else
                0
        end              as is_identity
    from
        all_objects  sao
        left join all_tab_cols sac on sao.object_name = sac.table_name
--left join CNF_columnHeaders AS clh ON clh.tableName = sao.name AND sac.name = clh.columnName
    where
            sao.object_type = 'TABLE'
        and sao.owner in ( 'DIREM01' )
        and sac.owner in ( 'DIREM01' )
    order by
        sao.object_name,
        sac.column_id;


-- sqlcl_snapshot {"hash":"9e591c6f6b138baf03b3cf18d6a952ca86c62bb9","type":"VIEW","name":"MHK_VWTABLECOLUMNS","schemaName":"DIRKSPZM32","sxml":""}