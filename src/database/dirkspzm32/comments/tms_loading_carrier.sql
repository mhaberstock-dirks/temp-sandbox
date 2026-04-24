comment on table dirkspzm32.tms_loading_carrier is
    'configuration and status table for all available loading carrier (Container)';

comment on column dirkspzm32.tms_loading_carrier.address_id_carrier is
    'address id of the carrier';

comment on column dirkspzm32.tms_loading_carrier.adress_id is
    'ID aus Adressen Tabelle (ISI_ORDER.ADRESS_ID)';

comment on column dirkspzm32.tms_loading_carrier.arrival_time is
    'arrival time of the vehicle';

comment on column dirkspzm32.tms_loading_carrier.departure_time is
    'departure time of the vehicle';

comment on column dirkspzm32.tms_loading_carrier.driver_name is
    'free field to enter the name of the vehicle driver';

comment on column dirkspzm32.tms_loading_carrier.info is
    'information text (displayed on the terminal)';

comment on column dirkspzm32.tms_loading_carrier.lgr_platz is
    'Lagerplatz, auf dem der Carrier steht';

comment on column dirkspzm32.tms_loading_carrier.loading_carrier_id is
    'z.B. Containernummer bei Containern';

comment on column dirkspzm32.tms_loading_carrier.loading_carrier_typ is
    'Typ z.b. ''CONTAINER'', ''LKW'', ...';

comment on column dirkspzm32.tms_loading_carrier.loading_start_time is
    'time when the loading of the vehicle has been started';

comment on column dirkspzm32.tms_loading_carrier.loading_temp_cent is
    'loading temperature in centigrade';

comment on column dirkspzm32.tms_loading_carrier.order_adress_id is
    'ID, wer hat diese Bestellung erstellt (Rechnungsadresse) (ISI_ORDER.ORDER_ADRESS_ID)';

comment on column dirkspzm32.tms_loading_carrier.order_li_nr is
    'Lieferscheinnummer ';

comment on column dirkspzm32.tms_loading_carrier.order_vorgang_id is
    'Vorgang_ID = Tournummer ';

comment on column dirkspzm32.tms_loading_carrier.status is
    'FR = free,
OCC = occupied Belegt bzw besetzt,
RES = reserved,
CL = closed,
RDY = ready,
RDYH = ready and transmitted to host-system';

comment on column dirkspzm32.tms_loading_carrier.tara is
    'Tara-Gewicht des Carrier';

comment on column dirkspzm32.tms_loading_carrier.vehicle_temp_cent is
    'vehicle temperature in centigrade';

comment on column dirkspzm32.tms_loading_carrier.zollplombe_id is
    'ID der Zollplombe (Normalerweise 8 Stellen)';


-- sqlcl_snapshot {"hash":"e88ec1be82fc252feffd7b606084c5ec55d765bd","type":"COMMENT","name":"tms_loading_carrier","schemaName":"dirkspzm32","sxml":""}