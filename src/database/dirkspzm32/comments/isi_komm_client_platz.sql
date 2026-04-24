comment on column dirkspzm32.isi_komm_client_platz.isi_komm_client_platz_name is
    'Name des Kommisionierarbeitsplatz';

comment on column dirkspzm32.isi_komm_client_platz.isi_komm_client_platz_typ is
    'Platz-Typ (Quelle, Ziel)';

comment on column dirkspzm32.isi_komm_client_platz.komm_client_name is
    'Name des Kommisionierarbeitsplatz';

comment on column dirkspzm32.isi_komm_client_platz.komm_id is
    'Laufende Nummer des aktuellen Auftrags aus der ISI_KOMM_ORDER';

comment on column dirkspzm32.isi_komm_client_platz.lte_id is
    'LTE_ID der Paltte oder Behälter auf dem Platz';

comment on column dirkspzm32.isi_komm_client_platz.status is
    'aktueller Status des Platzes, z.B. frei, belegt, gestört usw.';

comment on column dirkspzm32.isi_komm_client_platz.transport_einheit is
    'erlaubter LTE_Typ an diesem Platz (Behälter, Palette)';

comment on column dirkspzm32.isi_komm_client_platz.vorgang_id is
    'Verknüpfung zur Order-Kopf-Tabelle, falls dies z.B. eine vorbereitende Kommissionierung für eine Order ist';


-- sqlcl_snapshot {"hash":"3250d26b88f4a81bf7f8541918739d7919781e12","type":"COMMENT","name":"isi_komm_client_platz","schemaName":"dirkspzm32","sxml":""}