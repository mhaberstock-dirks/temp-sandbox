comment on table DIRKSPZM32.ISI_TRANSPORT is 'Alle aktiven Transporte';
comment on column DIRKSPZM32.ISI_TRANSPORT."AUF_ID" is 'Auftrags ID der ISI_Order';
comment on column DIRKSPZM32.ISI_TRANSPORT."AUF_ID_EXTERN" is 'host auftragsnr bei externer Beauftragung';
comment on column DIRKSPZM32.ISI_TRANSPORT."CHECK_PLATZ_Q_LOGIN_ID" is 'Wurde eine Prüfung für den Quell-Platz für diesem Transport durchgeführt? NULL = Nein, Login ID = Ja';
comment on column DIRKSPZM32.ISI_TRANSPORT."CHECK_PLATZ_Z_LOGIN_ID" is 'Wurde eine Prüfung für den Ziel-Platz für diesem Transport durchgeführt? NULL = Nein, Login ID = Ja';
comment on column DIRKSPZM32.ISI_TRANSPORT."CHECK_WARE_LOGIN_ID" is 'Wurde eine Warenprüfung für diesem Transport durchgeführt? NULL = Nein, Login ID = Ja';
comment on column DIRKSPZM32.ISI_TRANSPORT."FIRMA_NR" is 'Firmennummer id der Datenbank';
comment on column DIRKSPZM32.ISI_TRANSPORT."FREIFAHRAUFTRAG" is 'T= Freifahren , F=Normaler Auftrag';
comment on column DIRKSPZM32.ISI_TRANSPORT."INFO_TEXT" is 'Infotext für den Transport';
comment on column DIRKSPZM32.ISI_TRANSPORT."KUNDEN_NR" is 'Referenz auf adress_id in isi_adressen';
comment on column DIRKSPZM32.ISI_TRANSPORT."LAM_BH_VORGANG_ID" is 'Vorgangs_ID für die Zusammenfassung von LAM-Buchungen';
comment on column DIRKSPZM32.ISI_TRANSPORT."LEITZAHL" is 'Produktionsnummer wenn Eindeutig auf der ges. Palette';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_ORT_QUELLE" is 'Lagerort der quelle';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_ORT_ZIEL" is 'Lagerort des Ziels';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_PLATZ_QUELLE" is 'Quelle des Auftrags';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_PLATZ_ZIEL" is 'Ziel des Auftrags';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_PLATZ_ZIEL_CHECK_NEW" is 'Ziel des Auftrags / Zugeordnet durch lvs_check_transport_ziel';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_VERWENDUNG_QUELLE" is 'Quelle  ist  WE WA Lager, Puffer ....';
comment on column DIRKSPZM32.ISI_TRANSPORT."LGR_VERWENDUNG_ZIEL" is 'Ziel ist WE WA Lager Puffer ...';
comment on column DIRKSPZM32.ISI_TRANSPORT."LIEFERSCHEIN" is 'Lieferscheindaten erzeugen ''T'' = Ja, erzeugen, ''F'' = Nein, wird nicht erzeut';
comment on column DIRKSPZM32.ISI_TRANSPORT."LI_NR" is 'Lieferschein Nummer';
comment on column DIRKSPZM32.ISI_TRANSPORT."LI_POS_NR" is 'Lieferscheinposition -Nummer';
comment on column DIRKSPZM32.ISI_TRANSPORT."LKW_NR" is 'Gruppiert meherer Touren (Vorgänge)';
comment on column DIRKSPZM32.ISI_TRANSPORT."LTE_ID" is 'Transport ID LTE';
comment on column DIRKSPZM32.ISI_TRANSPORT."LTE_LETZTE_BUCHUNG" is 'Letzte Buchung vor diesem Transport';
comment on column DIRKSPZM32.ISI_TRANSPORT."MODUL_BEARBEITER" is 'MFR, SLS, PAP papier a la huf aus lvs_lgr_ort isi_modul SHT Shutle';
comment on column DIRKSPZM32.ISI_TRANSPORT."MODUL_ERZEUGER" is 'ISI, MFR, HST, SLS, LVS, ORD';
comment on column DIRKSPZM32.ISI_TRANSPORT."PARENT_TRANSP_ID" is 'Vorgelagerter Transport';
comment on column DIRKSPZM32.ISI_TRANSPORT."PRIO" is 'Priorät des Aufrags 1=klein 9=Hoch';
comment on column DIRKSPZM32.ISI_TRANSPORT."PROGR_NR" is 'Programm nummer für die Bearbeitung  von Sonderaufträgen';
comment on column DIRKSPZM32.ISI_TRANSPORT."P_KOMM_ID" is 'Kommissionierauftrag -> PAZ Erweiterung imm Transport - Link auf übergeordneten Kommissionierauftrag (Umpackauftrag)';
comment on column DIRKSPZM32.ISI_TRANSPORT."P_KOMM_LHM_HOEHE_LAGE" is 'Kommissionierauftrag -> Höhe einer Lage (LHM''s)';
comment on column DIRKSPZM32.ISI_TRANSPORT."P_KOMM_LTE_LHM_LAGEN" is 'Kommissionierauftrag -> Anzahl Lagen (LHM''s) je LTE ->  Anzahl der Lagen auf der Zielpalette für Packschema_aufbau Typ Artikel (ART)';
comment on column DIRKSPZM32.ISI_TRANSPORT."P_KOMM_LTE_LHM_PRO_LAGE" is 'Kommissionierauftrag -> Anzahl LHM je Lage';
comment on column DIRKSPZM32.ISI_TRANSPORT."P_KOMM_PACKSCHEMA_KOPF_ID" is 'Kommissionierauftrag -> Zeiger auf LVS_PACKSCHEMA_KOPF';
comment on column DIRKSPZM32.ISI_TRANSPORT."QUELLE_LEER_PROGR_NR" is '1=Auftrag löschen';
comment on column DIRKSPZM32.ISI_TRANSPORT."RES_ID" is 'Resource aus isi_resource die mit dem Transport beauftragt wird';
comment on column DIRKSPZM32.ISI_TRANSPORT."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_TRANSPORT."SOLL_FERTIG_BIS" is 'Dieser Transport muss fertig sein (BIS). Un diese Uhrzeit';
comment on column DIRKSPZM32.ISI_TRANSPORT."STATUS" is 'F=Frei,
G=Gesperrt,
Z=Zugewiesen,
B=Begonnen (Resource bewegt sich zur LTE),
T=LTE wird transportiert
S=Transportreihenfolge bearbeiten
E=Fertig Ende - Aus Transport Fertig vor dem Löschen';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSPORTMITTEL_GRUPPE" is 'Gesetzt von MFR ,SLS gruppierung erst mal noch frei';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSPORTMITTEL_ID" is 'Gesetzt von MFR,SLS RFZ_1=1  oder bei Stapler aus Resource';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSPORTMITTEL_TYP" is 'gesetzt von MFR,SLS  R=RBG  S=Stapler H=Hubwagen B=Bediener';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSPORT_GRUPPE" is 'Z.B. Beladereihenfolge für einen LKW Tournummer Oetker';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSPORT_REIHENFOLGE" is 'Feste Transportreihenfolge (Setzt die PRIO-Steuerung ausser Kraft)';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSP_ID" is 'Transport ID (Sequenz)';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSP_ID_SOURCE" is 'Quell Auftrag z.B. für Automatisches Freifahren';
comment on column DIRKSPZM32.ISI_TRANSPORT."TRANSP_TYP" is '''E'' Einlagern, ''A'' Auslagern, ''U'' Umlagern';
comment on column DIRKSPZM32.ISI_TRANSPORT."TS" is 'Timestamp Autragserzeugung';
comment on column DIRKSPZM32.ISI_TRANSPORT."UML_ZIEL_RES_ID" is 'RES_ID für das Ziel ';
comment on column DIRKSPZM32.ISI_TRANSPORT."USER_ID" is 'Erzeuger des Auftrags';
comment on column DIRKSPZM32.ISI_TRANSPORT."VORGANG_ID" is 'Nummer um die Positionen zu Klammern Z.B. Tourennummer';
comment on column DIRKSPZM32.ISI_TRANSPORT."ZIEL_VOLL_PROGR_NR" is '1=Pause';



-- sqlcl_snapshot {"hash":"4e88446efdc7651c820e2b363ae20fa93ae3ae4b","type":"COMMENT","name":"isi_transport","schemaName":"dirkspzm32","sxml":""}