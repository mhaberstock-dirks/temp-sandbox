comment on table DIRKSPZM32.S_SEAQUIST_SEND_BEW is 'Bewegungsdaten aus ISIPlus';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."AKTION" is 'AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen L = Position im ISIPlus gelöscht LIF = Lieferschein fertig BEF = Bestellung Fertig F = Prod. Fertig TF = Prod. Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."ARB_PL_ID" is 'Arbeitsplatz der Versands bei Auslieferung';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."AUF_ID" is 'eindeutige Sequenz-Nummer in Tabelle (S_SeaQuist_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."BEW_ID" is 'Eindeutig ID';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."BRUTTO_KG" is 'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."B_DATUM" is 'Buchungszeitpunkt';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."CHARGE" is 'Charge des Materials';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."EXT_LIE_NR" is 'Externe Lieferscheinnummer bei Anlieferungen';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."EXT_LIE_PO" is 'Externe Lieferscheinposition bei Anlieferungen';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."HERKUNFT" is '"ISI" immer konstant';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."IST_BEST" is 'IST_BESTAND für BAG oder INV';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."LAGERORT" is 'Lagerort im SeaQuist';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."LHM_NR" is 'Nummer des Lagerhilfsmittel (Barcode)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."LTE_NR" is 'Nummer der Transporteinheit (Barcode)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."MA_ID" is 'Maschinen ID aus SeaQuist';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."MA_STATUS" is 'Maschinenstatus P = Produktion U = Unterbrechung';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."MA_S_GRUND" is 'Störgrundnummer';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."MENGE" is '1.Wahl Stück (LVS / BDE) oder Störgrund';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."MENGE_B" is 'B Qualität Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."PRODZ_IST" is 'Produktionszeit in Minuten';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."RUESTZ_IST" is 'Rüstzeit in Minuten (Produktionsfertigmeldung)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."R_MENGE" is 'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."R_MENGE_B" is 'Menge Rüsten B Qualität Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."R_SCHROTT" is 'Schrottmenge beim Rüsten in Stück';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."SCHROTT" is 'Schrottmenge in Stück';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."SERIE" is 'Seriennummer des Materials';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."STATUS" is 'NULL = Im SeaQuist noch nicht Übernommen UE = SeaQuist hat den Satz übernommen A = SeaQuist hat Angefangen F = SeaQuist ist Fertig L = ISIPlus kann den Eintrag Löschen';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."STOERZ_IST" is 'Störzeit in Minuten (Produktionsfertigmeldung)';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."TABELLE" is 'NULL = Keine Referenz zu SeaQuist Tabellen sonst Tabellenname';
comment on column DIRKSPZM32.S_SEAQUIST_SEND_BEW."ZLAGERORT" is 'Ziellagerort im SeaQuist';



-- sqlcl_snapshot {"hash":"9f585a93522764969f9a746266758b7cb66fdff1","type":"COMMENT","name":"s_seaquist_send_bew","schemaName":"dirkspzm32","sxml":""}