comment on table dirkspzm32.s_pzm_pers is
    'Personlastamm';

comment on column dirkspzm32.s_pzm_pers.anrede is
    'Herr Frau … (PI muss den Schlüssel wandeln)
';

comment on column dirkspzm32.s_pzm_pers.azubi is
    'Pflege im ISIPlus';

comment on column dirkspzm32.s_pzm_pers.befristet_bis is
    'Null muss übernommen werden
';

comment on column dirkspzm32.s_pzm_pers.behind_status is
    'Behindertenstatus (Default 0) unter 50 % --> 0 Ab 50 % --> 1
';

comment on column dirkspzm32.s_pzm_pers.eintrittsdatum is
    'Bei Übergabe NULL darf der Wert in ISI nicht gelöscht werden (SAP E1P0041-DAT01)';

comment on column dirkspzm32.s_pzm_pers.fam_stand is
    'Familienstand 0 = Ledig, 1 = Verheiratet, 2 = Geschieden (Prüfen ob benötigt)
';

comment on column dirkspzm32.s_pzm_pers.firma_nr is
    'Mandant z.B. 01
';

comment on column dirkspzm32.s_pzm_pers.geb_datum is
    'Geburtsdatum
';

comment on column dirkspzm32.s_pzm_pers.geschlecht is
    'Geschlecht (Prüfen ob benötigt)
';

comment on column dirkspzm32.s_pzm_pers.kennz_zeiterf is
    '1 = Stempeln / 0 = Nicht Stempeln (Steuert zukünftig die Fehlzeiterfassung)
';

comment on column dirkspzm32.s_pzm_pers.kst is
    '(Achtung im SAP kann die Kostenstelle CHAR(10) sein, sind aber nur 6 stellig Numerisch)
';

comment on column dirkspzm32.s_pzm_pers.kuerzel is
    'Namenskürzel (z.B. Initialien)';

comment on column dirkspzm32.s_pzm_pers.lohngruppe is
    'Entfällt (Wird dann überall auf NULL gesetzt)
';

comment on column dirkspzm32.s_pzm_pers.passwort is
    'Password
';

comment on column dirkspzm32.s_pzm_pers.personalteilber is
    'Personnalteilbereich (Werk etc.)
';

comment on column dirkspzm32.s_pzm_pers.pers_nr is
    'Personalnummer des Benutzers (Bei integriertem PZM wir die Personalnumme und die Kontaktdaten von PZM übersteuert (Trigger im PZM)'
    ;

comment on column dirkspzm32.s_pzm_pers.schnittstelle is
    '1 = Die Daten müssen in die Schnittstelle / 0 = Nicht übertragen
';

comment on column dirkspzm32.s_pzm_pers.sm_name is
    'Schicht
';

comment on column dirkspzm32.s_pzm_pers.staatsangeh is
    'Staatsangehörigkeit
';

comment on column dirkspzm32.s_pzm_pers.username is
    'Benutzername der bei der Anmeldung im ISIPlus-System verwendet wird';

comment on column dirkspzm32.s_pzm_pers.ustd_freistd is
    'KF = KONTO_FREIZEIT, AZ = Auszahlung der Überstunden
';

comment on column dirkspzm32.s_pzm_pers.vertragsart is
    'Steuert die Erzeugung der Einträge, ob ein MA fehlt. (1 und 2)
 Zukünftig in --> Gewerblich (Mitarbeiterkreis + Mitarbeitergruppe)
';

comment on column dirkspzm32.s_pzm_pers.vertragsart_tx is
    'Texte für Mitarbeiterkreis Text Vertragsart --> für Referenztabelle PZM_VERTRAGSARTEN
';

comment on column dirkspzm32.s_pzm_pers.zk_von1_freistd is
    'Steuerung der Konten (Auszahlung)
';


-- sqlcl_snapshot {"hash":"64764ff5c6db51ee766e7b3586b468f10defc88d","type":"COMMENT","name":"s_pzm_pers","schemaName":"dirkspzm32","sxml":""}