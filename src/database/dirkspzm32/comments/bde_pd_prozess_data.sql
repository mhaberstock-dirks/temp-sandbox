comment on table dirkspzm32.bde_pd_prozess_data is
    ' Erzeugte Prozessdaten aus der Produktion';

comment on column dirkspzm32.bde_pd_prozess_data.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.bde_pd_prozess_data.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.bde_pd_prozess_data.fae_id is
    'Fertigungs Einheit ID (Entspricht z.B. der LTE_ID, kann aber auch eine Transpoder-ID je Teil sein übernehmen aus BDE_PD_PROD)';

comment on column dirkspzm32.bde_pd_prozess_data.fae_id_position is
    'R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten (übernehmen aus BDE_PD_PROD)';

comment on column dirkspzm32.bde_pd_prozess_data.fa_ag is
    'Aktueller Arbeitsgang der Leitzahl (auf der Maschine übernehmen aus BDE_PD_PROD)';

comment on column dirkspzm32.bde_pd_prozess_data.fa_upos is
    'Unterposition der Arbeitsgangs (auf der Maschine übernehmen aus BDE_PD_PROD)';

comment on column dirkspzm32.bde_pd_prozess_data.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_pd_prozess_data.id is
    'Unique Identifier';

comment on column dirkspzm32.bde_pd_prozess_data.io is
    'Sind die Ergebnisse dieser Prozessdaten IO oder NIO T = IO, F = NIO, N=NIO Nachgearbeitet, U=Ungeprüft';

comment on column dirkspzm32.bde_pd_prozess_data.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.bde_pd_prozess_data.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.bde_pd_prozess_data.leitzahl is
    'Fertigungsauftrag Nr. (Leitzahlauf der Maschine übernehmen aus BDE_PD_PROD)';

comment on column dirkspzm32.bde_pd_prozess_data.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk (Typ MS = Maschine zu diesem Arbeitsgang auf der Maschine übernehmen aus BDE_PD_PROD)'
    ;

comment on column dirkspzm32.bde_pd_prozess_data.res_prozess_data_date is
    'Zeitpunkt der Produktion / Prozessdaten';

comment on column dirkspzm32.bde_pd_prozess_data.res_prozess_data_nr is
    'Index. Dieser entspricht der Position im Telegramm';

comment on column dirkspzm32.bde_pd_prozess_data.res_prozess_data_res_id is
    'Eindeutige Nummer der Resource in der Datenbamk (Meldepunkt der Prozessdaten)';

comment on column dirkspzm32.bde_pd_prozess_data.res_prozess_data_value is
    'Wert der Prozessdaten';

comment on column dirkspzm32.bde_pd_prozess_data.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_pd_prozess_data.vorg_id is
    'Vorgangsnummer (Eindeutig für jede Fertigmeldung auf der Maschine übernehmen aus BDE_PD_PROD)';


-- sqlcl_snapshot {"hash":"9720285b380e29c0e40dfc0fb6cd51552c5e195f","type":"COMMENT","name":"bde_pd_prozess_data","schemaName":"dirkspzm32","sxml":""}