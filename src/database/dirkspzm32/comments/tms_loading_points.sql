comment on table DIRKSPZM32.TMS_LOADING_POINTS is 'configuration and status table for all available loading points';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."ADDRESS_ID_CARRIER" is 'address id of the carrier';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."ARBEITSPLATZ_ID" is 'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."ARRIVAL_TIME" is 'arrival time of the vehicle';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."DEPARTURE_TIME" is 'departure time of the vehicle';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."DRIVER_NAME" is 'free field to enter the name of the vehicle driver';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."INFO" is 'information text (displayed on the terminal)';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."LAST_CHANGE_DATE" is 'date of last modification';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."LAST_CHANGE_LOGIN_ID" is 'login_id of the user who made the last modification';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."LGR_PLATZ" is 'loading point name';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."LOADING_START_TIME" is 'time when the loading of the vehicle has been started';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."LOADING_TEMP_CENT" is 'loading temperature in centigrade';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."ORDER_VORGANG_ID" is 'planned delivery id';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."STATUS" is 'FR = free, OCC = occupied, RES = reserved, CL = closed,  RDY = ready, RDYH = ready and transmitted to host-system';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."VEHICLE_NUMBER_PLATE" is 'number plate of the docking/docked vehicle';
comment on column DIRKSPZM32.TMS_LOADING_POINTS."VEHICLE_TEMP_CENT" is 'vehicle temperature in centigrade';



-- sqlcl_snapshot {"hash":"ebc0fa90376221be9454e1f4b47cd64339fa278e","type":"COMMENT","name":"tms_loading_points","schemaName":"dirkspzm32","sxml":""}