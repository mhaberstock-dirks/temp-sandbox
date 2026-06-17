comment on table DIRKSPZM32.MFR_VIEWPORTS_CFG is 'Contains camera position with name';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."CREATED_TIME" is 'Saves when the ViewPort was saved.';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."CREATOR_ID" is 'Saves ReferenceID of the creator. This is saved in SCD folder and ISI_USER table';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."CREATOR_NAME" is 'Saves ReferenceID of the creator. This is saved in  ISI_USER table';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_COMMENT" is 'Optional decription of the view port';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_ID" is 'GUID of ViewPort.';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_NAME" is 'Given name of camera position.';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_SCOPE" is 'This descripes the scope in what it will be used. "MFS" - MaterialFlowServer, "BDE" - Betreibsdatenerfassung, "LGR" - Lager ';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_X" is 'Camera position x coordinates as number (in c# as double).';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_Y" is 'Camera position y coordinates as number (in c# as double).';
comment on column DIRKSPZM32.MFR_VIEWPORTS_CFG."VIEWPORT_Z" is 'Camera position z coordinates as number (in c# as double).';



-- sqlcl_snapshot {"hash":"d4875dda3ccd5d8b1dcb057d59075f892c832e3f","type":"COMMENT","name":"mfr_viewports_cfg","schemaName":"dirkspzm32","sxml":""}