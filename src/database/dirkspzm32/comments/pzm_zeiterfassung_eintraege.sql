comment on table dirkspzm32.pzm_zeiterfassung_eintraege is
    'Tabelle für die Einträge (Einzel-Stemplungen)';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.korr_ze_aktion is
    'Ablage des original Wertes aus dem Terminal. Nutzbar bei manueller Korrektur.';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.pers_nr is
    'Ermittelte Pers-Nr. zu der gebuchten RFID, wenn verfuegbar.';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.quelle is
    'Quelle der Buchung (z.B. ''LIVE'', ''APP'', ''TERMINAL'', ''MANUELL'', ''SYSTEM'')';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_aktion is
    'Aktion K=Kommen, G=gehen, D=Dienstgang, P=Pause, BDE=BDE (Bookingtype)';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_datum is
    'Datum des Eintrags';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_fa_ag is
    'Arbeitsgang (Operation)';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_fa_auftrag is
    'Fertigungsauftrag erste Scannung (ProdOrder)';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_geraet is
    'Geräte oder Arbeitsplatz-ID (Seriennummer des Terminals)';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_geraet_info is
    'Name, optionale Pos. Info des Terminals, wenn verfuegbar';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_id is
    'Zugeordnete ID aus PZM_ZEITERFASSUNG, wenn die Verbuchung erfolgreich war. Fuer historische Nachverfolgbarkeit';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_ret_code is
    '0 = OK, sonst Fehlercode';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_ret_msg is
    'Status/Fehlertext der Übertragung';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_rfid is
    'RF-ID-Chip (Transponder)';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_timezone_name is
    'IANA based timezone name';

comment on column dirkspzm32.pzm_zeiterfassung_eintraege.ze_transfer_status is
    'Transfer-Status N=Neu, U=In Übetragung, UE=Übetragen(Fertig), ERR=Fehler';


-- sqlcl_snapshot {"hash":"58b1cfdea7e397adc9583f515a7a44520a79ee77","type":"COMMENT","name":"pzm_zeiterfassung_eintraege","schemaName":"dirkspzm32","sxml":""}