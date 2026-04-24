comment on table dirkspzm32.cal_cfg is
    'Calendar configurations to support multiple calendar schedules';

comment on column dirkspzm32.cal_cfg.appointment_edit_logic is
    'Name of the logic that can edit the appointment details (including usage system specific data)';

comment on column dirkspzm32.cal_cfg.calendar_id is
    'Unique identifier of a calendar';

comment on column dirkspzm32.cal_cfg.cal_color is
    'ARGB value, Optional individual color for the calendar';

comment on column dirkspzm32.cal_cfg.cal_title_nls_key is
    'Display title of the calendar';

comment on column dirkspzm32.cal_cfg.cmd_info_add_appointment is
    'Parameter name/value list with context menu command informations to add an appointment';

comment on column dirkspzm32.cal_cfg.cmd_info_delete_appointment is
    'Parameter name/value list with context menu command informations to delete an appointment';

comment on column dirkspzm32.cal_cfg.cmd_info_edit_appointment is
    'Parameter name/value list with context menu command informations to edit an appointment';

comment on column dirkspzm32.cal_cfg.edit_logic_ext_param_name is
    'Name of the external param within the appointment editing logic to receive appointment context data';

comment on column dirkspzm32.cal_cfg.scheduler_logic is
    'Scheduler logic that is responsible to display more specific details related to the usage system';

comment on column dirkspzm32.cal_cfg.usage_system_id is
    'System identifier / logic etc. that is responsible to use appointments of this calendar';


-- sqlcl_snapshot {"hash":"23c7d6fe99487f90d3b4229d12de0192bf2a2ed6","type":"COMMENT","name":"cal_cfg","schemaName":"dirkspzm32","sxml":""}