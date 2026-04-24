comment on table dirkspzm32.pzm_produktionsbereiche is
    'Produktionsbereich / Werk bzw. PZM-Mandant. Hier ist der Vertragspartner der Arbeitnehmers der den Lohn bezahlt (Intern oder PZ-Dienstleister)'
    ;

comment on column dirkspzm32.pzm_produktionsbereiche.created_date is
    'Datum Erstellt';

comment on column dirkspzm32.pzm_produktionsbereiche.created_login_id is
    'User-ID - Wer hat diesen Eintrag Erstellt';

comment on column dirkspzm32.pzm_produktionsbereiche.last_change_date is
    'Datum der letzten Änderung';

comment on column dirkspzm32.pzm_produktionsbereiche.last_change_login_id is
    'User-ID - Wer hat diesen Eintrag zuletzt geändert';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_adress_id is
    'Adress-ID des Produktionsbereichs/Mandanten (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_bemerkungen is
    'Freies Textfeld für Infos/Bemerkungen';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_extern is
    '''T'' = Externer Dienstleister F=Interner Mandant - Extern oder Dienstleister für Personalbereitstellung';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_id is
    'Eindeutige ID des Produktionsbereiches (Primary-Key)';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_kst_id is
    'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_name is
    'Name des Produktionsbereiches';

comment on column dirkspzm32.pzm_produktionsbereiche.pb_personal_abt_id is
    'Zugehörige Personalabteilung. Diese gilt für alle Abteilungen in diesem Produktionsbereich die keine eingene Personalabteilung eingetragen haben'
    ;

comment on column dirkspzm32.pzm_produktionsbereiche.pb_schnittstelle is
    'Schnittstelle für die Übertragung der LOAS (Wenn PB_EXTERN = ''T'', dann wenn leer Standardschnittstelle z.B. DATEV)';


-- sqlcl_snapshot {"hash":"e00f5cca20200bef51fe45442ed2ff9563323c28","type":"COMMENT","name":"pzm_produktionsbereiche","schemaName":"dirkspzm32","sxml":""}