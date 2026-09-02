comment on table S_OET_SEND_BEW is 'Bewegungsdaten aus ISIPlus';
comment on column S_OET_SEND_BEW."AKTION" is 'AV = Status in Vorbereitung AA = Status Angefangen AR = Status Rüsten  AP = Status Produktion UE = Im ISIPlus übernommen L = Position im ISIPlus gelöscht LIF = Lieferschein fertig BEF = Bestellung Fertig F = Prod. Fertig TF = Prod. Teilfertig STB = Störung Beginn STG = Störung begründen STE = Störung Ende WEI = Zugang Intern (z.B. Produktion) WAI = Abgang Intern (z.B. Maschine) WEE = Zugang Extern (Warenanlieferung) WAE = Abgang Extern (Versand von Ware) WUI = Umlagerung Intern WUE = Umlagerung Extern BAG = Bestandsabgleich INV = Inventur FRE = Freigeben SPR = Sperren';
comment on column S_OET_SEND_BEW."ARTIKEL" is 'Artikelnummer';
comment on column S_OET_SEND_BEW."AUF_ID" is 'eindeutige Sequenz-Nummer in Tabelle (S_ACH_RES...) oder Sequenz-Nummer aus ISIPlus wenn TABELLE = NULL';
comment on column S_OET_SEND_BEW."B_DATUM" is 'Buchungszeitpunkt';
comment on column S_OET_SEND_BEW."BEW_ID" is 'Eindeutige Nummer der Bewegung';
comment on column S_OET_SEND_BEW."ERR_NR" is 'Fehlernummer z.B. 1 = LTE nicht vorhanden2 = LTE schon disponiert3 = Artikelnr fehlt';
comment on column S_OET_SEND_BEW."EXT_LIEF_NR" is 'Externe Lieferscheinnummer bei Anlieferungen';
comment on column S_OET_SEND_BEW."EXT_LIEF_POS" is 'Externe Lieferscheinposition bei Anlieferungen';
comment on column S_OET_SEND_BEW."FIRMA_NR" is 'Mandant z.B. 01';
comment on column S_OET_SEND_BEW."HERKUNFT" is '"ISI" immer konstant';
comment on column S_OET_SEND_BEW."IST_BESTAND" is 'IST_BESTAND für BAG oder INV';
comment on column S_OET_SEND_BEW."LAGERORT" is 'Lagerort im ACH';
comment on column S_OET_SEND_BEW."LHM_ID" is 'Nummer des Lagerhilfsmittel (Barcode)';
comment on column S_OET_SEND_BEW."LTE_ID" is 'Nummer der Transporteinheit (Barcode)';
comment on column S_OET_SEND_BEW."MENGE" is '1.Wahl Stück (LVS / BDE) oder Störgrund';
comment on column S_OET_SEND_BEW."STATUS" is 'NULL = Im ACH noch nicht Übernommen UE = ACH hat den Satz übernommen A = ACH hat Angefangen F = ACH ist Fertig L = ISIPlus kann den Eintrag Löschen';
comment on column S_OET_SEND_BEW."TABELLE" is 'NULL = Keine Referenz zu ACH Tabellen sonst Tabellenname';
comment on column S_OET_SEND_BEW."TEXT" is 'Rückgabetext';



-- sqlcl_snapshot {"hash":"41a9c5b3666282d6d18fa6c7950ad57fff211c36","type":"COMMENT","name":"s_oet_send_bew","schemaName":"dirkspzm32","sxml":""}