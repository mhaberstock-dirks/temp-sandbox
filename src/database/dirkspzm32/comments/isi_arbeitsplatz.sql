comment on table dirkspzm32.isi_arbeitsplatz is
    'Beschreibung der Terminals mit Name Ortsbeschreibung etc.';

comment on column dirkspzm32.isi_arbeitsplatz.adress_id is
    'Adresse ';

comment on column dirkspzm32.isi_arbeitsplatz.anwendung is
    'Nur R3: Anwendung auf dem Terminal';

comment on column dirkspzm32.isi_arbeitsplatz.arbeitsplatz_id is
    'Eindeutige Arbeitsplatz ID (ggf. aus Sequence)';

comment on column dirkspzm32.isi_arbeitsplatz.beschreibung is
    'Beschreibung des Arbeitsplatzes';

comment on column dirkspzm32.isi_arbeitsplatz.ip_adresse is
    'IP des Arbeitsplatzes, NULL = DHCP (Nur von R3 tatsächlich verwendet)';

comment on column dirkspzm32.isi_arbeitsplatz.ip_name is
    'Hostname des Arbeitsplatzes';

comment on column dirkspzm32.isi_arbeitsplatz.isi_log_popup is
    'Nur R3: T = Jedes LOG bringt das Logfenster';

comment on column dirkspzm32.isi_arbeitsplatz.lagerort is
    'Nur R3: Lagerort des Terminals';

comment on column dirkspzm32.isi_arbeitsplatz.ord_verladung is
    'Nur R3: T = An diesem Arbeitsplatz werden Verladungen abgewickelt (ISI_ORDER)';

comment on column dirkspzm32.isi_arbeitsplatz.orts_kz is
    'Ortskennzeichen';

comment on column dirkspzm32.isi_arbeitsplatz.res_id is
    'Zugeordnete Ressource falls relevant';


-- sqlcl_snapshot {"hash":"0f83adf12cc712f3e2242cd3e4eaf56c692af767","type":"COMMENT","name":"isi_arbeitsplatz","schemaName":"dirkspzm32","sxml":""}