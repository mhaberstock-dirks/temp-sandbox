comment on table DIRKSPZM32.BDE_PD_PROD is 'Referenzen Produktion und Rohware als Vorgänge';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_ABSCHALT_FEIN" is 'Absch. Fein';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_ABSCHALT_GROB" is 'Absch. Grob';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_ABSCHALT_MITTEL" is 'Absch. Mittel';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_BRUTTO" is 'Istmenge für der Abfüllung Brutto';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_IST" is 'Istmenge für der Abfüllung';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_SILO" is 'Silo für Abfüllung';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_SOLL" is 'Sollmenge für die Abfüllung';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_TARA" is 'Istmenge für der Abfüllung TARA';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_TOLERANZ_MINUS" is 'Toleranz Minus';
comment on column DIRKSPZM32.BDE_PD_PROD."ABFUELL_TOLERANZ_PLUS" is 'Toleranz Plus';
comment on column DIRKSPZM32.BDE_PD_PROD."ABNR" is 'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';
comment on column DIRKSPZM32.BDE_PD_PROD."ARTIKEL_ID" is 'Artikel ID in ISI_ARTIKEL';
comment on column DIRKSPZM32.BDE_PD_PROD."FAE_ID" is 'Fertigungs Einheit ID (Fertigungs Einheit ID (Entspricht z.B. der LTE_ID, kann aber auch eine Transpoder-ID je Teil sein)';
comment on column DIRKSPZM32.BDE_PD_PROD."FAE_ID_POSITION" is 'R = Rechts, L = Links, V = Vorne, H = Hinten, O = Oben, U = Unten';
comment on column DIRKSPZM32.BDE_PD_PROD."FA_AG" is 'Aktueller Arbeitsgang der Leitzahl';
comment on column DIRKSPZM32.BDE_PD_PROD."FA_UPOS" is 'Unterposition der Arbeitsgangs';
comment on column DIRKSPZM32.BDE_PD_PROD."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.BDE_PD_PROD."LAM_ID" is 'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';
comment on column DIRKSPZM32.BDE_PD_PROD."LEITZAHL" is 'Fertigungsauftrag Nr. (Leitzahl)';
comment on column DIRKSPZM32.BDE_PD_PROD."LS_LOGIN_ID" is 'Login ID des Erfassers';
comment on column DIRKSPZM32.BDE_PD_PROD."MENGE_A" is 'Gutmenger 1. Wahl';
comment on column DIRKSPZM32.BDE_PD_PROD."MENGE_B" is '2. Wahl Menge';
comment on column DIRKSPZM32.BDE_PD_PROD."PD_NETTO_ZEIT" is 'Netto Produktionszeit';
comment on column DIRKSPZM32.BDE_PD_PROD."PERS_NR" is 'Personalnummer des Maschinenführeres';
comment on column DIRKSPZM32.BDE_PD_PROD."PROD_BEGINN" is 'Zeitpunkt des Produktionsbeginn';
comment on column DIRKSPZM32.BDE_PD_PROD."PROD_ENDE" is 'Zeitpunkt des Produktionsende';
comment on column DIRKSPZM32.BDE_PD_PROD."PROD_PARAMS" is 'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';
comment on column DIRKSPZM32.BDE_PD_PROD."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column DIRKSPZM32.BDE_PD_PROD."SCHROTT" is 'Schrottmenge';
comment on column DIRKSPZM32.BDE_PD_PROD."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.BDE_PD_PROD."VORG_ID" is 'Vorgangsnummer (Eindeutig für jede Fertigmeldung oder Rohwarenzug. auf der Maschine)';
comment on column DIRKSPZM32.BDE_PD_PROD."VORG_TYP" is '"PP" Produktion, "PB" Bezug auf Rohware, "PM" Material, "PR" Wie "PP" jedoch Anfahren n. Rüsten "PA" und "PR" = Auftragsanmeldung Produktion und Rüsten "QF"=Qualitätsfreigabe "KM" = Kortrektur PA-Satz durch Mitarbeiter';



-- sqlcl_snapshot {"hash":"9ce1ae2e046783d0b0fffe6234060732270fec50","type":"COMMENT","name":"bde_pd_prod","schemaName":"dirkspzm32","sxml":""}