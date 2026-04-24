comment on table dirkspzm32.pzm_allg_parameter is
    'Algemeine Parameter PZM - Generische (globale) Konfigurationen zur Steuerung der Zeiterfassung';

comment on column dirkspzm32.pzm_allg_parameter.ap_info is
    'Beschreibung des Allgemeinen Parameters';

comment on column dirkspzm32.pzm_allg_parameter.ap_name is
    'Name des Allgemeinen Parameters (Primary-Key)';

comment on column dirkspzm32.pzm_allg_parameter.ap_pb_id is
    'Produktionsbereich (Foreign-Key PZM_PRODUKTIONSBEREICHE)';

comment on column dirkspzm32.pzm_allg_parameter.ap_type is
    'Typ des Allgemeinen Parameters (Ganze Zahl = Integer, etc...)';

comment on column dirkspzm32.pzm_allg_parameter.ap_value is
    'Wert des Allgemeinen Parameters';

comment on column dirkspzm32.pzm_allg_parameter.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_allg_parameter.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_allg_parameter.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_allg_parameter.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';


-- sqlcl_snapshot {"hash":"1e97a959fae6b7635c2ae6ef645a10c4029e7c97","type":"COMMENT","name":"pzm_allg_parameter","schemaName":"dirkspzm32","sxml":""}