comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."ABT_ID" is 'NULL - Gilt für alle sonst Abteilungs-ID (Foreign-Key PZM_ABTEILUNGEN))';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."AKTIV" is 'Ist das Event aktiv (T = True, F = False)';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_DATUM" is 'Die Buchung soll genau zu diesem Zeitpunkt stattfinden (+ BUCH_EVENT_OFFSET_STD) oder wenn in den Wochentagen ein Wert gefüllt ist, dann zählt nur der Anteil der Uhrzeit.';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_EINHEIT" is 'Einheit der Buchung (HH24 = Stunden, DD= Tag)';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WERT" is 'Wert der Umbuchung von Konto nach Konto';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_DI_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_DO_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_FR_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_MI_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_MO_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_SA_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."BUCH_WOT_SO_WERT" is 'Buchungswert für diesen Wochentag';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."CREATED_DATE" is 'Datum Erstellt';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."CREATED_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag Erstellt';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."FIRMA_NR" is 'Firmennummer standortsbezogen z.B. Standort1 = 1, Standort2 = 2 (Primary-Key)';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."INFO" is 'Beschreibung - Information der Buchungen';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."LAST_CHANGE_DATE" is 'Datum der letzten Änderung';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."LAST_CHANGE_LOGIN_ID" is 'User-ID - Wer hat diesen Eintrag zuletzt geändert';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."LAST_EVENT_DATE" is 'Datum der letzten Ausführung';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."NACH_KONTO_NAME_KURZ" is 'auf dieses Konto (Konto-Kurz-Name)';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."NAME" is 'Name der automatischen Umbuchund ';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."PB_ID" is 'NULL - Gilt für alle sonst zugehöriger Mandant (PZM Produktionsbereich) zu der Kostenstelle';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."SID" is 'ID (Primary-Key)';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."TYP_STATUS" is 'N = Neu, F = Fertig, D=dauerbuchung für z.B. Wochentage';
comment on column DIRKSPZM32.PZM_KONTEN_UMBUCHEN."VON_KONTO_NAME_KURZ" is 'Von Konto (Konto-Kurz-Name) -- NULL kein Gegenkonto - Dann eine Gutschrift';



-- sqlcl_snapshot {"hash":"203db93adb57959209f40082599fb541755eab6f","type":"COMMENT","name":"pzm_konten_umbuchen","schemaName":"dirkspzm32","sxml":""}