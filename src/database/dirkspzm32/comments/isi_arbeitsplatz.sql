comment on table DIRKSPZM32.ISI_ARBEITSPLATZ is 'Beschreibung der Terminals mit Name Ortsbeschreibung etc.';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."ADRESS_ID" is 'Adresse ';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."ANWENDUNG" is 'Nur R3: Anwendung auf dem Terminal';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."ARBEITSPLATZ_ID" is 'Eindeutige Arbeitsplatz ID (ggf. aus Sequence)';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."BESCHREIBUNG" is 'Beschreibung des Arbeitsplatzes';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."IP_ADRESSE" is 'IP des Arbeitsplatzes, NULL = DHCP (Nur von R3 tatsächlich verwendet)';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."IP_NAME" is 'Hostname des Arbeitsplatzes';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."ISI_LOG_POPUP" is 'Nur R3: T = Jedes LOG bringt das Logfenster';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."LAGERORT" is 'Nur R3: Lagerort des Terminals';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."ORD_VERLADUNG" is 'Nur R3: T = An diesem Arbeitsplatz werden Verladungen abgewickelt (ISI_ORDER)';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."ORTS_KZ" is 'Ortskennzeichen';
comment on column DIRKSPZM32.ISI_ARBEITSPLATZ."RES_ID" is 'Zugeordnete Ressource falls relevant';



-- sqlcl_snapshot {"hash":"cde2f83ced850dc286583a8c1c69700ea9e38498","type":"COMMENT","name":"isi_arbeitsplatz","schemaName":"dirkspzm32","sxml":""}