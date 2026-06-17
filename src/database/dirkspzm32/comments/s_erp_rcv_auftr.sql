comment on table DIRKSPZM32.S_ERP_RCV_AUFTR is 'Bestellungen und Ladelisten die zur Verladung anstehen';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."ADR_ART" is 'K = Kunde L = Lieferant';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."ADR_LIEFER" is 'Lieferadresse bei Kunden aus ADR';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."ADR_NR" is 'Kunden oder Lieferanten-Nummer aus ADR';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."ARBEITSPLATZ_ID" is 'ID des Arbeitsplatz der die Lagerbewegung auslösen soll';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."AUFTRAG" is 'Auftragsnummer / Bestellung im SAP';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."AUF_ID" is 'eindeutige Sequenz-Nummer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."BEST_NR_KUNDE" is 'Bestellnummer des Kunden';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."BEST_TERM" is 'Bestätigter Liefertermin';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."CHARGE" is 'Charge';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."CREATED_DATE" is 'Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."CREATED_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz erstellt hat';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."IST_MENGE" is 'Ist Menge';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."KOM_INFO" is 'zus. Info für Kommissionierer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."KOM_LGR_ORTE" is 'Lagerorte aus aus denen für die Kommissionierung ware entnommen werden darf';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL1" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL10" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL2" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL3" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL4" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL5" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL6" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL7" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL8" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAM_SEL9" is 'Parameter zusätzliche Selectionsparameter';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAST_CHANGE_DATE" is 'Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LAST_CHANGE_LOGIN_ID" is 'Id des Benutzers der diesen Datensatz zuletzt geändert hat';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LEITZAHL" is 'Leitzahl Fertigungsauftrag';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LI_NR" is 'Lieferschein Nummer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LI_POS_NR" is 'Lieferscheinposition -Nummer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."LVS_INFO" is 'für Informationen vom LVS';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."MHD" is 'MHD';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."PRIORITAET" is 'Priorität (0..9), 9: hohe Priorität';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."PROD_PARAMS" is 'Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."SATZART" is 'BE = Bestellung (Achtung M1.1 bis M1.3)
LI = Anstehende Lieferung Lieferschein
BL = Beistelllieferung zur Bestellung
';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."SERIENNR" is 'Serien-Nummer';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."SOLL_MG" is 'Soll-Menge';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."STATUS" is 'N = Noch nicht angefangen V = In Vorbereitung F = Fertig A = AngefangenL = Löschen';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."STRATEGIE" is 'FIFO, LIFO';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."TOUR" is 'Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."VORGANG" is 'Nummer um die Positionen zu Klammern';
comment on column DIRKSPZM32.S_ERP_RCV_AUFTR."WA_ZIEL" is 'SPED = Spedition SELB = Selbstabholer UPS = UPS DPAD = Paketversand';



-- sqlcl_snapshot {"hash":"75e7501bf7814b037f0bf979a8d26323c6cc7d81","type":"COMMENT","name":"s_erp_rcv_auftr","schemaName":"dirkspzm32","sxml":""}