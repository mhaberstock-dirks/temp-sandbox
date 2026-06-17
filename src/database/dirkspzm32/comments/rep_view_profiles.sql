comment on table DIRKSPZM32.REP_VIEW_PROFILES is 'stored individual view profiles per report';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."CHART_SETTING" is 'NULL = no chart defined to show, ELSE various chart types';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."CREATED_BY" is 'username who has created this record';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."CREATED_DATE" is 'creation date of this record';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."LAST_CHANGE_BY" is 'username who has made last change on this record';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."LAST_CHANGE_DATE" is 'last change date of this record';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."PRINT_LAYOUT_FILE" is 'NULL = as base configuration, filename for layout file';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."PRINT_LAYOUT_NAME" is 'NULL = as base configuration, layoutname within the layout file';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."PROFILE_CAPTION" is 'a caption for the profile which the end user can see. if ''C_TXT_...'' is used, the system tries to load the caption from the lang file by this constant';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."REP_ID" is 'the report id where this profile belongs to';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."REP_VIEW_PROFILE_NAME" is 'a unique name of a profile within the rep_id';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."SHOW_DETAIL_DATA" is 'NULL = as base configuration, ''T'' = true, ''F'' = false (used in master detail reports)';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."SHOW_TYPE" is '0=stShowDlgNormal, 1=stShowDlgStayOnTop, 2=stShowModal, 3=stShowNormal (analog zu ISIFrame)';
comment on column DIRKSPZM32.REP_VIEW_PROFILES."STARTUP_VIEW" is 'NULL = as base configuration, ''T'' = Table, ''P'' = print layout, ''C'' = chart, ''E'' = extension';



-- sqlcl_snapshot {"hash":"9af48629e6594b4a007c2bf6fa87fbf649cc3807","type":"COMMENT","name":"rep_view_profiles","schemaName":"dirkspzm32","sxml":""}