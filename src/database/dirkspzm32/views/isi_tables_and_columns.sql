
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ISI_TABLES_AND_COLUMNS" ("MODUL", "TABLE_NAME", "TABLE_COMMENTS", "COLUMN_NAME", "NULLABLE", "DATA_TYPE", "DATA_LENGTH", "COLUMN_COMMENTS") AS 
  select
  substr(ut.table_name, 1, instr(ut.TABLE_NAME, '_')- 1) as Modul,
  ut.TABLE_NAME,
  utco.COMMENTS Table_Comments,
  utf.COLUMN_NAME,
  utf.NULLABLE,
  utf.DATA_TYPE,
  utf.DATA_LENGTH,
  substr(ucc.COMMENTS, 1, 500) Column_Comments
from
  user_tables ut,
  user_tab_comments utco,
  user_tab_cols utf,
  user_col_comments ucc
where
  ut.TABLE_NAME = utco.table_name
  and ut.TABLE_NAME = utf.TABLE_NAME
  and utf.TABLE_NAME = ucc.TABLE_NAME
  and utf.COLUMN_NAME = ucc.COLUMN_NAME
order
  by ut.TABLE_NAME, utf.COLUMN_ID
;


-- sqlcl_snapshot {"hash":"af43d741c859a5fb495839c2ceee0b6ab4d2c4cd","type":"VIEW","name":"ISI_TABLES_AND_COLUMNS","schemaName":"DIRKSPZM32","sxml":""}