comment on table DIRKSPZM32.BDE_PD_PROZESS_DATA is ' Erzeugte Prozessdaten aus der Produktion';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."FAE_ID" is 'Fertigungs Einheit ID (Entspricht z.B. der LTE_ID, kann aber auch eine Transpoder-ID je Teil sein übernehmen aus BDE_PD_PROD)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."FAE_ID_POSITION" is 'R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten (übernehmen aus BDE_PD_PROD)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."FA_AG" is 'Aktueller Arbeitsgang der Leitzahl (auf der Maschine übernehmen aus BDE_PD_PROD)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."FA_UPOS" is 'Unterposition der Arbeitsgangs (auf der Maschine übernehmen aus BDE_PD_PROD)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."ID" is 'Unique Identifier';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."IO" is 'Sind die Ergebnisse dieser Prozessdaten IO oder NIO T = IO, F = NIO, N=NIO Nachgearbeitet, U=Ungeprüft';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."LEITZAHL" is 'Fertigungsauftrag Nr. (Leitzahlauf der Maschine übernehmen aus BDE_PD_PROD)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk (Typ MS = Maschine zu diesem Arbeitsgang auf der Maschine übernehmen aus BDE_PD_PROD)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."RES_PROZESS_DATA_DATE" is 'Zeitpunkt der Produktion / Prozessdaten';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."RES_PROZESS_DATA_NR" is 'Index. Dieser entspricht der Position im Telegramm';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."RES_PROZESS_DATA_RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk (Meldepunkt der Prozessdaten)';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."RES_PROZESS_DATA_VALUE" is 'Wert der Prozessdaten';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.BDE_PD_PROZESS_DATA."VORG_ID" is 'Vorgangsnummer (Eindeutig für jede Fertigmeldung auf der Maschine übernehmen aus BDE_PD_PROD)';



-- sqlcl_snapshot {"hash":"3f8afc54aa4f3232f9ceb3f65df35a81051bf53e","type":"COMMENT","name":"bde_pd_prozess_data","schemaName":"dirkspzm32","sxml":""}