comment on table DIRKSPZM32.TMS_LOADING_CARRIER is 'configuration and status table for all available loading carrier (Container)';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ADDRESS_ID_CARRIER" is 'address id of the carrier';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ADRESS_ID" is 'ID aus Adressen Tabelle (ISI_ORDER.ADRESS_ID)';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ARRIVAL_TIME" is 'arrival time of the vehicle';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."DEPARTURE_TIME" is 'departure time of the vehicle';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."DRIVER_NAME" is 'free field to enter the name of the vehicle driver';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."INFO" is 'information text (displayed on the terminal)';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."LGR_PLATZ" is 'Lagerplatz, auf dem der Carrier steht';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."LOADING_CARRIER_ID" is 'z.B. Containernummer bei Containern';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."LOADING_CARRIER_TYP" is 'Typ z.b. ''CONTAINER'', ''LKW'', ...';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."LOADING_START_TIME" is 'time when the loading of the vehicle has been started';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."LOADING_TEMP_CENT" is 'loading temperature in centigrade';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ORDER_ADRESS_ID" is 'ID, wer hat diese Bestellung erstellt (Rechnungsadresse) (ISI_ORDER.ORDER_ADRESS_ID)';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ORDER_LI_NR" is 'Lieferscheinnummer ';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ORDER_VORGANG_ID" is 'Vorgang_ID = Tournummer ';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."STATUS" is 'FR = free,
OCC = occupied Belegt bzw besetzt,
RES = reserved,
CL = closed,
RDY = ready,
RDYH = ready and transmitted to host-system';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."TARA" is 'Tara-Gewicht des Carrier';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."VEHICLE_TEMP_CENT" is 'vehicle temperature in centigrade';
comment on column DIRKSPZM32.TMS_LOADING_CARRIER."ZOLLPLOMBE_ID" is 'ID der Zollplombe (Normalerweise 8 Stellen)';



-- sqlcl_snapshot {"hash":"6f152643f3c7a6c114a290084275b2da51837cd9","type":"COMMENT","name":"tms_loading_carrier","schemaName":"dirkspzm32","sxml":""}