comment on table DIRKSPZM32.CAL_CFG is 'Calendar configurations to support multiple calendar schedules';
comment on column DIRKSPZM32.CAL_CFG."APPOINTMENT_EDIT_LOGIC" is 'Name of the logic that can edit the appointment details (including usage system specific data)';
comment on column DIRKSPZM32.CAL_CFG."CALENDAR_ID" is 'Unique identifier of a calendar';
comment on column DIRKSPZM32.CAL_CFG."CAL_COLOR" is 'ARGB value, Optional individual color for the calendar';
comment on column DIRKSPZM32.CAL_CFG."CAL_TITLE_NLS_KEY" is 'Display title of the calendar';
comment on column DIRKSPZM32.CAL_CFG."CMD_INFO_ADD_APPOINTMENT" is 'Parameter name/value list with context menu command informations to add an appointment';
comment on column DIRKSPZM32.CAL_CFG."CMD_INFO_DELETE_APPOINTMENT" is 'Parameter name/value list with context menu command informations to delete an appointment';
comment on column DIRKSPZM32.CAL_CFG."CMD_INFO_EDIT_APPOINTMENT" is 'Parameter name/value list with context menu command informations to edit an appointment';
comment on column DIRKSPZM32.CAL_CFG."EDIT_LOGIC_EXT_PARAM_NAME" is 'Name of the external param within the appointment editing logic to receive appointment context data';
comment on column DIRKSPZM32.CAL_CFG."SCHEDULER_LOGIC" is 'Scheduler logic that is responsible to display more specific details related to the usage system';
comment on column DIRKSPZM32.CAL_CFG."USAGE_SYSTEM_ID" is 'System identifier / logic etc. that is responsible to use appointments of this calendar';



-- sqlcl_snapshot {"hash":"a5d080d2f31fb2263fc8f34aec59512c4b652602","type":"COMMENT","name":"cal_cfg","schemaName":"dirkspzm32","sxml":""}