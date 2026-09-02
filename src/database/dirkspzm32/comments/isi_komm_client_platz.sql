comment on column ISI_KOMM_CLIENT_PLATZ."ISI_KOMM_CLIENT_PLATZ_NAME" is 'Name des Kommisionierarbeitsplatz';
comment on column ISI_KOMM_CLIENT_PLATZ."ISI_KOMM_CLIENT_PLATZ_TYP" is 'Platz-Typ (Quelle, Ziel)';
comment on column ISI_KOMM_CLIENT_PLATZ."KOMM_CLIENT_NAME" is 'Name des Kommisionierarbeitsplatz';
comment on column ISI_KOMM_CLIENT_PLATZ."KOMM_ID" is 'Laufende Nummer des aktuellen Auftrags aus der ISI_KOMM_ORDER';
comment on column ISI_KOMM_CLIENT_PLATZ."LTE_ID" is 'LTE_ID der Paltte oder Behälter auf dem Platz';
comment on column ISI_KOMM_CLIENT_PLATZ."STATUS" is 'aktueller Status des Platzes, z.B. frei, belegt, gestört usw.';
comment on column ISI_KOMM_CLIENT_PLATZ."TRANSPORT_EINHEIT" is 'erlaubter LTE_Typ an diesem Platz (Behälter, Palette)';
comment on column ISI_KOMM_CLIENT_PLATZ."VORGANG_ID" is 'Verknüpfung zur Order-Kopf-Tabelle, falls dies z.B. eine vorbereitende Kommissionierung für eine Order ist';



-- sqlcl_snapshot {"hash":"ecf49b5a71157eb7738cc6c3bfb1e80560173217","type":"COMMENT","name":"isi_komm_client_platz","schemaName":"dirkspzm32","sxml":""}