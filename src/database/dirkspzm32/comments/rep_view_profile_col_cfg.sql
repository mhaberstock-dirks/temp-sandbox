comment on table dirkspzm32.rep_view_profile_col_cfg is
    'column based data of a reports view profile';

comment on column dirkspzm32.rep_view_profile_col_cfg.column_position is
    'NULL = as base configuration, the column position within the grid for individual column order';

comment on column dirkspzm32.rep_view_profile_col_cfg.column_visible is
    'NULL = as base configuration, ''T'' = true, ''F'' = false (used in master detail reports)';

comment on column dirkspzm32.rep_view_profile_col_cfg.column_width is
    'NULL = as base configuration, individual width of a column for this profile';

comment on column dirkspzm32.rep_view_profile_col_cfg.field_name is
    'the filed name to be configured in this profile';

comment on column dirkspzm32.rep_view_profile_col_cfg.grouping_level is
    'NULL = as base configuration, level for grouping if grouping is wanted';

comment on column dirkspzm32.rep_view_profile_col_cfg.rep_id is
    'the report id where this profile belongs to';

comment on column dirkspzm32.rep_view_profile_col_cfg.rep_view_profile_name is
    'a unique name of a profile within the rep_id';


-- sqlcl_snapshot {"hash":"ff2a5b5386c249e10e812cb96f5b7acff0414c3d","type":"COMMENT","name":"rep_view_profile_col_cfg","schemaName":"dirkspzm32","sxml":""}