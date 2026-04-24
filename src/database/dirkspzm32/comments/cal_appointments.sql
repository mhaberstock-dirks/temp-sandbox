comment on table dirkspzm32.cal_appointments is
    'Appointment entries related to a calendar that can be displayed in a scheduler or used by sub systems';

comment on column dirkspzm32.cal_appointments.all_day is
    'T = true, is all day appointment, F = false';

comment on column dirkspzm32.cal_appointments.appointment_id is
    'Unique id of the appointment';

comment on column dirkspzm32.cal_appointments.appointment_type_id is
    'DevExpress specific: the type of the appointment is specified by its role (normal, recurring, changed from recurring series, etc.). Date is based on DevExpress.XtraScheduler.AppointmentType enumeration'
    ;

comment on column dirkspzm32.cal_appointments.calendar_id is
    'Associated calendar for usage of multiple calendars';

comment on column dirkspzm32.cal_appointments.description is
    'Appointment description';

comment on column dirkspzm32.cal_appointments.end_time is
    'End date and time of the appointment';

comment on column dirkspzm32.cal_appointments.location is
    'Associated location of the appointment';

comment on column dirkspzm32.cal_appointments.recurrence_info_xml is
    'DevExpress specific: recurrence info stored as XML data';

comment on column dirkspzm32.cal_appointments.shared_resources_info_xml is
    'DevExpress specific: shared resource association as XML data';

comment on column dirkspzm32.cal_appointments.start_time is
    'Start date and time of the appointment';

comment on column dirkspzm32.cal_appointments.status_id is
    'Index id of the static specified statuses within the calendar context';

comment on column dirkspzm32.cal_appointments.subject is
    'Appointment subject / title';


-- sqlcl_snapshot {"hash":"8ef582ce0858398a6df20efd7c5d188282227600","type":"COMMENT","name":"cal_appointments","schemaName":"dirkspzm32","sxml":""}