
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."MHK_VWTABLECOLUMNS" ("TABLE_NAME", "COLUMN_NAME", "ORDINAL_POSITION", "COLUMN_DEFAULT", "IS_NULLABLE", "DATA_TYPE", "IS_ROWGUID", "IS_IDENTITY") AS 
  select sao.object_name as TABLE_NAME, sac.COLUMN_NAME, sac.COLUMN_ID as ORDINAL_POSITION,
--clh.tableType, clh.tableName, clh.columnName, clh.displayText,
sac.DATA_DEFAULT as column_default,
case sac.nullable
  when 'Y' then 'YES'
  when 'N' then 'NO'
end as is_nullable,
sac.DATA_TYPE,
case
  when trim(upper(mhk_data_default(table_name, column_name))) = 'SYS_GUID()' then 1
  else 0
end as is_rowguid,
case
  when sac.IDENTITY_COLUMN = 'YES' then 1
  else 0
end as is_identity
from all_objects sao
left join all_tab_cols sac on sao.OBJECT_NAME = sac.TABLE_NAME
--left join CNF_columnHeaders AS clh ON clh.tableName = sao.name AND sac.name = clh.columnName
where sao.OBJECT_TYPE='TABLE' and sao.OWNER in ('DIREM01') and sac.owner in ('DIREM01')
order by sao.object_name, sac.COLUMN_ID
;


-- sqlcl_snapshot {"hash":"b8491c9ba87578ae7b0aa3f9a78fc8952b459e8e","type":"VIEW","name":"MHK_VWTABLECOLUMNS","schemaName":"DIRKSPZM32","sxml":""}