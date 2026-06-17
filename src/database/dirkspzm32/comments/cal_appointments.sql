comment on table DIRKSPZM32.CAL_APPOINTMENTS is 'Appointment entries related to a calendar that can be displayed in a scheduler or used by sub systems';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."ALL_DAY" is 'T = true, is all day appointment, F = false';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."APPOINTMENT_ID" is 'Unique id of the appointment';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."APPOINTMENT_TYPE_ID" is 'DevExpress specific: the type of the appointment is specified by its role (normal, recurring, changed from recurring series, etc.). Date is based on DevExpress.XtraScheduler.AppointmentType enumeration';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."CALENDAR_ID" is 'Associated calendar for usage of multiple calendars';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."DESCRIPTION" is 'Appointment description';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."END_TIME" is 'End date and time of the appointment';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."LOCATION" is 'Associated location of the appointment';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."RECURRENCE_INFO_XML" is 'DevExpress specific: recurrence info stored as XML data';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."SHARED_RESOURCES_INFO_XML" is 'DevExpress specific: shared resource association as XML data';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."START_TIME" is 'Start date and time of the appointment';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."STATUS_ID" is 'Index id of the static specified statuses within the calendar context';
comment on column DIRKSPZM32.CAL_APPOINTMENTS."SUBJECT" is 'Appointment subject / title';



-- sqlcl_snapshot {"hash":"98b62bf5880bd73b54ab7620e9d309c7dc6e8732","type":"COMMENT","name":"cal_appointments","schemaName":"dirkspzm32","sxml":""}