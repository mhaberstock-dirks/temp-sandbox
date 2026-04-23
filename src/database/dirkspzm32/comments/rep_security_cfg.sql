comment on table dirkspzm32.rep_security_cfg is
    'this table is used to manage security for reports';

comment on column dirkspzm32.rep_security_cfg.can_delete_data is
    'T = this group can delete a record of the report data, F = delete not allowed';

comment on column dirkspzm32.rep_security_cfg.can_edit_data is
    'T = this group can edit the report data, F = edit not allowed';

comment on column dirkspzm32.rep_security_cfg.can_insert_data is
    'T = this group can insert a new record into the report data, F = insert not allowed';

comment on column dirkspzm32.rep_security_cfg.login_id is
    'the referencing user login id which is allowed to execute this report';

comment on column dirkspzm32.rep_security_cfg.rep_id is
    'the report id where this security schuld be applied';

comment on column dirkspzm32.rep_security_cfg.rep_security_cfg_id is
    'unique id of this security config';

comment on column dirkspzm32.rep_security_cfg.security_type is
    '''G'' = security by group, ''U'' = security by user';

comment on column dirkspzm32.rep_security_cfg.sec_group_id is
    'the referencing group id which is allowed to execute this report';


-- sqlcl_snapshot {"hash":"3d050f50dd4f21cb5abd4248d909435097eebd19","type":"COMMENT","name":"rep_security_cfg","schemaName":"dirkspzm32","sxml":""}