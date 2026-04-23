comment on table dirkspzm32.tms_loading_points is
    'configuration and status table for all available loading points';

comment on column dirkspzm32.tms_loading_points.address_id_carrier is
    'address id of the carrier';

comment on column dirkspzm32.tms_loading_points.arbeitsplatz_id is
    'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';

comment on column dirkspzm32.tms_loading_points.arrival_time is
    'arrival time of the vehicle';

comment on column dirkspzm32.tms_loading_points.departure_time is
    'departure time of the vehicle';

comment on column dirkspzm32.tms_loading_points.driver_name is
    'free field to enter the name of the vehicle driver';

comment on column dirkspzm32.tms_loading_points.info is
    'information text (displayed on the terminal)';

comment on column dirkspzm32.tms_loading_points.last_change_date is
    'date of last modification';

comment on column dirkspzm32.tms_loading_points.last_change_login_id is
    'login_id of the user who made the last modification';

comment on column dirkspzm32.tms_loading_points.lgr_platz is
    'loading point name';

comment on column dirkspzm32.tms_loading_points.loading_start_time is
    'time when the loading of the vehicle has been started';

comment on column dirkspzm32.tms_loading_points.loading_temp_cent is
    'loading temperature in centigrade';

comment on column dirkspzm32.tms_loading_points.order_vorgang_id is
    'planned delivery id';

comment on column dirkspzm32.tms_loading_points.status is
    'FR = free, OCC = occupied, RES = reserved, CL = closed,  RDY = ready, RDYH = ready and transmitted to host-system';

comment on column dirkspzm32.tms_loading_points.vehicle_number_plate is
    'number plate of the docking/docked vehicle';

comment on column dirkspzm32.tms_loading_points.vehicle_temp_cent is
    'vehicle temperature in centigrade';


-- sqlcl_snapshot {"hash":"1d96ecdf87b5c7e2ad4b425515066b8fdfb6106a","type":"COMMENT","name":"tms_loading_points","schemaName":"dirkspzm32","sxml":""}