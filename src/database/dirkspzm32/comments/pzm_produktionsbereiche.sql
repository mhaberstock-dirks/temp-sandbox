comment on table DIRKSPZM32.PZM_PRODUKTIONSBEREICHE is 'Produktionsbereich / Werk bzw. PZM-Mandant. Hier ist der Vertragspartner der Arbeitnehmers der den Lohn bezahlt (Intern oder PZ-Dienstleister)';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_ADRESS_ID" is 'Adress-ID des Produktionsbereichs/Mandanten (Zur Findung Bundesland, Land etc. z.B. für die Zuordnung der korrekten Feiertage)';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_BEMERKUNGEN" is 'Freies Textfeld für Infos/Bemerkungen';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_EXTERN" is '''T'' = Externer Dienstleister F=Interner Mandant - Extern oder Dienstleister für Personalbereitstellung';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_ID" is 'Eindeutige ID des Produktionsbereiches (Primary-Key)';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_KST_ID" is 'Kostenstelle-ID (Foreign-Key PZM_KOSTENSTELLEN)';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_NAME" is 'Name des Produktionsbereiches';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_PERSONAL_ABT_ID" is 'Zugehörige Personalabteilung. Diese gilt für alle Abteilungen in diesem Produktionsbereich die keine eingene Personalabteilung eingetragen haben';
comment on column DIRKSPZM32.PZM_PRODUKTIONSBEREICHE."PB_SCHNITTSTELLE" is 'Schnittstelle für die Übertragung der LOAS (Wenn PB_EXTERN = ''T'', dann wenn leer Standardschnittstelle z.B. DATEV)';



-- sqlcl_snapshot {"hash":"2474c9197e98e09fb6f70dfe8d9b3869d15fe6b1","type":"COMMENT","name":"pzm_produktionsbereiche","schemaName":"dirkspzm32","sxml":""}