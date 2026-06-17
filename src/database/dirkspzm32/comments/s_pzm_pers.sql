comment on table DIRKSPZM32.S_PZM_PERS is 'Personlastamm';
comment on column DIRKSPZM32.S_PZM_PERS."ANREDE" is 'Herr Frau … (PI muss den Schlüssel wandeln)
';
comment on column DIRKSPZM32.S_PZM_PERS."AZUBI" is 'Pflege im ISIPlus';
comment on column DIRKSPZM32.S_PZM_PERS."BEFRISTET_BIS" is 'Null muss übernommen werden
';
comment on column DIRKSPZM32.S_PZM_PERS."BEHIND_STATUS" is 'Behindertenstatus (Default 0) unter 50 % --> 0 Ab 50 % --> 1
';
comment on column DIRKSPZM32.S_PZM_PERS."EINTRITTSDATUM" is 'Bei Übergabe NULL darf der Wert in ISI nicht gelöscht werden (SAP E1P0041-DAT01)';
comment on column DIRKSPZM32.S_PZM_PERS."FAM_STAND" is 'Familienstand 0 = Ledig, 1 = Verheiratet, 2 = Geschieden (Prüfen ob benötigt)
';
comment on column DIRKSPZM32.S_PZM_PERS."FIRMA_NR" is 'Mandant z.B. 01
';
comment on column DIRKSPZM32.S_PZM_PERS."GEB_DATUM" is 'Geburtsdatum
';
comment on column DIRKSPZM32.S_PZM_PERS."GESCHLECHT" is 'Geschlecht (Prüfen ob benötigt)
';
comment on column DIRKSPZM32.S_PZM_PERS."KENNZ_ZEITERF" is '1 = Stempeln / 0 = Nicht Stempeln (Steuert zukünftig die Fehlzeiterfassung)
';
comment on column DIRKSPZM32.S_PZM_PERS."KST" is '(Achtung im SAP kann die Kostenstelle CHAR(10) sein, sind aber nur 6 stellig Numerisch)
';
comment on column DIRKSPZM32.S_PZM_PERS."KUERZEL" is 'Namenskürzel (z.B. Initialien)';
comment on column DIRKSPZM32.S_PZM_PERS."LOHNGRUPPE" is 'Entfällt (Wird dann überall auf NULL gesetzt)
';
comment on column DIRKSPZM32.S_PZM_PERS."PASSWORT" is 'Password
';
comment on column DIRKSPZM32.S_PZM_PERS."PERSONALTEILBER" is 'Personnalteilbereich (Werk etc.)
';
comment on column DIRKSPZM32.S_PZM_PERS."PERS_NR" is 'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)';
comment on column DIRKSPZM32.S_PZM_PERS."SCHNITTSTELLE" is '1 = Die Daten müssen in die Schnittstelle / 0 = Nicht übertragen
';
comment on column DIRKSPZM32.S_PZM_PERS."SM_NAME" is 'Schicht
';
comment on column DIRKSPZM32.S_PZM_PERS."STAATSANGEH" is 'Staatsangehörigkeit
';
comment on column DIRKSPZM32.S_PZM_PERS."USERNAME" is 'Benutzername der bei der Anmeldung im ISIPlus-System verwendet wird';
comment on column DIRKSPZM32.S_PZM_PERS."USTD_FREISTD" is 'KF = KONTO_FREIZEIT, AZ = Auszahlung der Überstunden
';
comment on column DIRKSPZM32.S_PZM_PERS."VERTRAGSART" is 'Steuert die Erzeugung der Einträge, ob ein MA fehlt. (1 und 2)
 Zukünftig in --> Gewerblich (Mitarbeiterkreis + Mitarbeitergruppe)
';
comment on column DIRKSPZM32.S_PZM_PERS."VERTRAGSART_TX" is 'Texte für Mitarbeiterkreis Text Vertragsart --> für Referenztabelle PZM_VERTRAGSARTEN
';
comment on column DIRKSPZM32.S_PZM_PERS."ZK_VON1_FREISTD" is 'Steuerung der Konten (Auszahlung)
';



-- sqlcl_snapshot {"hash":"f6fa8c08d2beee9c46379507a3666730c232392a","type":"COMMENT","name":"s_pzm_pers","schemaName":"dirkspzm32","sxml":""}