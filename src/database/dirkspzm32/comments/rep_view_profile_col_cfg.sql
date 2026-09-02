comment on table REP_VIEW_PROFILE_COL_CFG is 'column based data of a reports view profile';
comment on column REP_VIEW_PROFILE_COL_CFG."COLUMN_POSITION" is 'NULL = as base configuration, the column position within the grid for individual column order';
comment on column REP_VIEW_PROFILE_COL_CFG."COLUMN_VISIBLE" is 'NULL = as base configuration, ''T'' = true, ''F'' = false (used in master detail reports)';
comment on column REP_VIEW_PROFILE_COL_CFG."COLUMN_WIDTH" is 'NULL = as base configuration, individual width of a column for this profile';
comment on column REP_VIEW_PROFILE_COL_CFG."FIELD_NAME" is 'the filed name to be configured in this profile';
comment on column REP_VIEW_PROFILE_COL_CFG."GROUPING_LEVEL" is 'NULL = as base configuration, level for grouping if grouping is wanted';
comment on column REP_VIEW_PROFILE_COL_CFG."REP_ID" is 'the report id where this profile belongs to';
comment on column REP_VIEW_PROFILE_COL_CFG."REP_VIEW_PROFILE_NAME" is 'a unique name of a profile within the rep_id';



-- sqlcl_snapshot {"hash":"9e815544534e98a0a5723d29ef8e9015a5749ae2","type":"COMMENT","name":"rep_view_profile_col_cfg","schemaName":"dirkspzm32","sxml":""}