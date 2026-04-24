comment on table dirkspzm32.mfr_viewports_cfg is
    'Contains camera position with name';

comment on column dirkspzm32.mfr_viewports_cfg.created_time is
    'Saves when the ViewPort was saved.';

comment on column dirkspzm32.mfr_viewports_cfg.creator_id is
    'Saves ReferenceID of the creator. This is saved in SCD folder and ISI_USER table';

comment on column dirkspzm32.mfr_viewports_cfg.creator_name is
    'Saves ReferenceID of the creator. This is saved in  ISI_USER table';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_comment is
    'Optional decription of the view port';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_id is
    'GUID of ViewPort.';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_name is
    'Given name of camera position.';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_scope is
    'This descripes the scope in what it will be used. "MFS" - MaterialFlowServer, "BDE" - Betreibsdatenerfassung, "LGR" - Lager ';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_x is
    'Camera position x coordinates as number (in c# as double).';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_y is
    'Camera position y coordinates as number (in c# as double).';

comment on column dirkspzm32.mfr_viewports_cfg.viewport_z is
    'Camera position z coordinates as number (in c# as double).';


-- sqlcl_snapshot {"hash":"7997d8ba7579c092ebf9a0a9016c60747bd515d5","type":"COMMENT","name":"mfr_viewports_cfg","schemaName":"dirkspzm32","sxml":""}