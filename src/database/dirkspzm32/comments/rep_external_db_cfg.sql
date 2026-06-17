comment on table DIRKSPZM32.REP_EXTERNAL_DB_CFG is 'global configuration of possible databases that ca be accesed by reports';
comment on column DIRKSPZM32.REP_EXTERNAL_DB_CFG."REP_EXT_DB_CAPTION" is 'a caption which will be visible in the report designer. if ''C_TXT_...'' is used, the system tries to load the caption from the lang file by this constant';
comment on column DIRKSPZM32.REP_EXTERNAL_DB_CFG."REP_EXT_DB_NAME" is 'a unique name for database connections';
comment on column DIRKSPZM32.REP_EXTERNAL_DB_CFG."REP_EXT_DB_PARAMS" is 'required params based on "rep_ext_db_type"';
comment on column DIRKSPZM32.REP_EXTERNAL_DB_CFG."REP_EXT_DB_TYPE" is '''DOA'' = direct oracle access, ''ADO'' = ActiveX Data Objects';



-- sqlcl_snapshot {"hash":"93e58d607c254e36bee66cf790c8cf1fd5a30dab","type":"COMMENT","name":"rep_external_db_cfg","schemaName":"dirkspzm32","sxml":""}