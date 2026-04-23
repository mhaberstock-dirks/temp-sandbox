comment on table dirkspzm32.rep_external_db_cfg is
    'global configuration of possible databases that ca be accesed by reports';

comment on column dirkspzm32.rep_external_db_cfg.rep_ext_db_caption is
    'a caption which will be visible in the report designer. if ''C_TXT_...'' is used, the system tries to load the caption from the lang file by this constant'
    ;

comment on column dirkspzm32.rep_external_db_cfg.rep_ext_db_name is
    'a unique name for database connections';

comment on column dirkspzm32.rep_external_db_cfg.rep_ext_db_params is
    'required params based on "rep_ext_db_type"';

comment on column dirkspzm32.rep_external_db_cfg.rep_ext_db_type is
    '''DOA'' = direct oracle access, ''ADO'' = ActiveX Data Objects';


-- sqlcl_snapshot {"hash":"5c77960d708e66509dbbbffa47e4de4c554f29dc","type":"COMMENT","name":"rep_external_db_cfg","schemaName":"dirkspzm32","sxml":""}