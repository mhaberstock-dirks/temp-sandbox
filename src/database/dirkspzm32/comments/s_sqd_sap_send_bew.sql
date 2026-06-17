comment on table DIRKSPZM32.S_SQD_SAP_SEND_BEW is 'Bewegungsdaten aus ISIPlus';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."AKTION" is '"AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen, L = Position im ISIPlus gelöscht LIF = Lieferschein fertig BEF = Bestellung Fertig F = Prod. Fertig TF = Prod. Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) UWAI = Abgang Intern (z.B. Maschine) Ungeplant
 WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."ARBEITSPLATZ_ID" is 'Arbeitsplatz der Versands bei Auslieferung';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."ARTIKEL" is 'Artikelnummer';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."AUF_ID" is 'eindeutige Sequenz-Nummer in Tabelle (S_EUS_SAP_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."BRUTTO_KG" is 'Brutto KG Gewicht für Rückmeldung im Lieferschein (LIF)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."B_DATUM" is 'Buchungszeitpunkt';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."CHARGE" is 'Charge des Materials';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."CYCLE" is 'Anzahl der Versuche der Übertragung  (Versuchszähler)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."EXT_BEST_NR" is '"Externe Bestellnummer bei Anlieferungen
"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."EXT_BEST_POS" is '"Externe Bestellposition bei Anlieferungen
"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."EXT_LIEF_NR" is 'Externe Lieferscheinnummer bei Anlieferungen';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."EXT_LIEF_POS" is 'Externe Lieferscheinposition bei Anlieferungen';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."FA_AG" is '"Vorgangsnummer in SAP
"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."FA_UPOS" is '"Unterposition für Gruppenarbeit
"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."FIRMA_NR" is 'Mandant z.B. 01';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."HERKUNFT" is '"ISI" immer konstant';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."IST_BESTAND" is 'IST_BESTAND für BAG oder INV';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."LAGERORT" is 'Lagerort im SAP';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."LEITZAHL" is '"Fertigungsauftrag in SAP
"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."LHM_NR" is 'Nummer des Lagerhilfsmittel (Barcode)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."LTE_NR" is 'Nummer der Transporteinheit (Barcode)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."MA_ID" is 'Maschinen ID aus SAP';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."MA_LAST_S_GRUND" is 'Letzter Status Grund (Vor diesen aktuelle Status)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."MA_STATUS" is 'Maschinenstatus P = Produktion U = Unterbrechung';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."MA_S_GRUND" is 'Störgrundnummer';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."ME" is '"Mengeneinheit aus isi-artikel
"';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."MENGE" is '1.Wahl Stück (LVS / BDE) oder Störgrund';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."MENGE_B" is 'B Qualität Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."PERS_NR" is 'Personalnummer';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."PRODZEIT_IST" is 'Produktionszeit in Minuten';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."RET_CODE" is 'Returncode aus Übertragung';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."RUESTZEIT_IST" is 'Rüstzeit in Minuten (Produktionsfertigmeldung)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."R_MENGE" is 'Menge Rüsten 1.Wahl Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."R_MENGE_B" is 'Menge Rüsten B Qualität Stück (Nicht für Euscher)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."R_SCHROTT" is 'Schrottmenge beim Rüsten in Stück';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."SAP_RESPONSEID" is 'SAP_ResponseID';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."SAP_RESPONSEMSG" is 'SAP_ResponseMsg';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."SAP_RESPONSENUMBER" is 'SAP_ResponseNumber';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."SAP_RESPONSETYPE" is 'SAP_ResponseType';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."SCHROTT" is 'Schrottmenge in Stück';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."SERIE" is 'Seriennummer des Materials';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."STATUS" is 'N = Neu, im SAP noch nicht Übernommen U = Ist in übertragung, UE = SAP hat den Satz übernommen, ERR = Fehler, D = Delete -> ISIPlus kann den Eintrag Löschen';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."STOERZEIT_IST" is 'Störzeit in Minuten (Produktionsfertigmeldung)';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."TABELLE" is 'NULL = Keine Referenz zu SAP Tabellen sonst Tabellenname';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."TS" is 'ID der Übertragung';
comment on column DIRKSPZM32.S_SQD_SAP_SEND_BEW."ZLAGERORT" is 'Ziellagerort im SAP';



-- sqlcl_snapshot {"hash":"fac82b0f151ce7c6dcac39472db5b167c8152bce","type":"COMMENT","name":"s_sqd_sap_send_bew","schemaName":"dirkspzm32","sxml":""}