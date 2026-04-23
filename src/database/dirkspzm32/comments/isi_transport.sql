comment on table dirkspzm32.isi_transport is
    'Alle aktiven Transporte';

comment on column dirkspzm32.isi_transport.auf_id is
    'Auftrags ID der ISI_Order';

comment on column dirkspzm32.isi_transport.auf_id_extern is
    'host auftragsnr bei externer Beauftragung';

comment on column dirkspzm32.isi_transport.check_platz_q_login_id is
    'Wurde eine Prüfung für den Quell-Platz für diesem Transport durchgeführt? NULL = Nein, Login ID = Ja';

comment on column dirkspzm32.isi_transport.check_platz_z_login_id is
    'Wurde eine Prüfung für den Ziel-Platz für diesem Transport durchgeführt? NULL = Nein, Login ID = Ja';

comment on column dirkspzm32.isi_transport.check_ware_login_id is
    'Wurde eine Warenprüfung für diesem Transport durchgeführt? NULL = Nein, Login ID = Ja';

comment on column dirkspzm32.isi_transport.firma_nr is
    'Firmennummer id der Datenbank';

comment on column dirkspzm32.isi_transport.freifahrauftrag is
    'T= Freifahren , F=Normaler Auftrag';

comment on column dirkspzm32.isi_transport.info_text is
    'Infotext für den Transport';

comment on column dirkspzm32.isi_transport.kunden_nr is
    'Referenz auf adress_id in isi_adressen';

comment on column dirkspzm32.isi_transport.lam_bh_vorgang_id is
    'Vorgangs_ID für die Zusammenfassung von LAM-Buchungen';

comment on column dirkspzm32.isi_transport.leitzahl is
    'Produktionsnummer wenn Eindeutig auf der ges. Palette';

comment on column dirkspzm32.isi_transport.lgr_ort_quelle is
    'Lagerort der quelle';

comment on column dirkspzm32.isi_transport.lgr_ort_ziel is
    'Lagerort des Ziels';

comment on column dirkspzm32.isi_transport.lgr_platz_quelle is
    'Quelle des Auftrags';

comment on column dirkspzm32.isi_transport.lgr_platz_ziel is
    'Ziel des Auftrags';

comment on column dirkspzm32.isi_transport.lgr_platz_ziel_check_new is
    'Ziel des Auftrags / Zugeordnet durch lvs_check_transport_ziel';

comment on column dirkspzm32.isi_transport.lgr_verwendung_quelle is
    'Quelle  ist  WE WA Lager, Puffer ....';

comment on column dirkspzm32.isi_transport.lgr_verwendung_ziel is
    'Ziel ist WE WA Lager Puffer ...';

comment on column dirkspzm32.isi_transport.lieferschein is
    'Lieferscheindaten erzeugen ''T'' = Ja, erzeugen, ''F'' = Nein, wird nicht erzeut';

comment on column dirkspzm32.isi_transport.li_nr is
    'Lieferschein Nummer';

comment on column dirkspzm32.isi_transport.li_pos_nr is
    'Lieferscheinposition -Nummer';

comment on column dirkspzm32.isi_transport.lkw_nr is
    'Gruppiert meherer Touren (Vorgänge)';

comment on column dirkspzm32.isi_transport.lte_id is
    'Transport ID LTE';

comment on column dirkspzm32.isi_transport.lte_letzte_buchung is
    'Letzte Buchung vor diesem Transport';

comment on column dirkspzm32.isi_transport.modul_bearbeiter is
    'MFR, SLS, PAP papier a la huf aus lvs_lgr_ort isi_modul SHT Shutle';

comment on column dirkspzm32.isi_transport.modul_erzeuger is
    'ISI, MFR, HST, SLS, LVS, ORD';

comment on column dirkspzm32.isi_transport.parent_transp_id is
    'Vorgelagerter Transport';

comment on column dirkspzm32.isi_transport.prio is
    'Priorät des Aufrags 1=klein 9=Hoch';

comment on column dirkspzm32.isi_transport.progr_nr is
    'Programm nummer für die Bearbeitung  von Sonderaufträgen';

comment on column dirkspzm32.isi_transport.p_komm_id is
    'Kommissionierauftrag -> PAZ Erweiterung imm Transport - Link auf übergeordneten Kommissionierauftrag (Umpackauftrag)';

comment on column dirkspzm32.isi_transport.p_komm_lhm_hoehe_lage is
    'Kommissionierauftrag -> Höhe einer Lage (LHM''s)';

comment on column dirkspzm32.isi_transport.p_komm_lte_lhm_lagen is
    'Kommissionierauftrag -> Anzahl Lagen (LHM''s) je LTE ->  Anzahl der Lagen auf der Zielpalette für Packschema_aufbau Typ Artikel (ART)'
    ;

comment on column dirkspzm32.isi_transport.p_komm_lte_lhm_pro_lage is
    'Kommissionierauftrag -> Anzahl LHM je Lage';

comment on column dirkspzm32.isi_transport.p_komm_packschema_kopf_id is
    'Kommissionierauftrag -> Zeiger auf LVS_PACKSCHEMA_KOPF';

comment on column dirkspzm32.isi_transport.quelle_leer_progr_nr is
    '1=Auftrag löschen';

comment on column dirkspzm32.isi_transport.res_id is
    'Resource aus isi_resource die mit dem Transport beauftragt wird';

comment on column dirkspzm32.isi_transport.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_transport.soll_fertig_bis is
    'Dieser Transport muss fertig sein (BIS). Un diese Uhrzeit';

comment on column dirkspzm32.isi_transport.status is
    'F=Frei,
G=Gesperrt,
Z=Zugewiesen,
B=Begonnen (Resource bewegt sich zur LTE),
T=LTE wird transportiert
S=Transportreihenfolge bearbeiten
E=Fertig Ende - Aus Transport Fertig vor dem Löschen';

comment on column dirkspzm32.isi_transport.transportmittel_gruppe is
    'Gesetzt von MFR ,SLS gruppierung erst mal noch frei';

comment on column dirkspzm32.isi_transport.transportmittel_id is
    'Gesetzt von MFR,SLS RFZ_1=1  oder bei Stapler aus Resource';

comment on column dirkspzm32.isi_transport.transportmittel_typ is
    'gesetzt von MFR,SLS  R=RBG  S=Stapler H=Hubwagen B=Bediener';

comment on column dirkspzm32.isi_transport.transport_gruppe is
    'Z.B. Beladereihenfolge für einen LKW Tournummer Oetker';

comment on column dirkspzm32.isi_transport.transport_reihenfolge is
    'Feste Transportreihenfolge (Setzt die PRIO-Steuerung ausser Kraft)';

comment on column dirkspzm32.isi_transport.transp_id is
    'Transport ID (Sequenz)';

comment on column dirkspzm32.isi_transport.transp_id_source is
    'Quell Auftrag z.B. für Automatisches Freifahren';

comment on column dirkspzm32.isi_transport.transp_typ is
    '''E'' Einlagern, ''A'' Auslagern, ''U'' Umlagern';

comment on column dirkspzm32.isi_transport.ts is
    'Timestamp Autragserzeugung';

comment on column dirkspzm32.isi_transport.uml_ziel_res_id is
    'RES_ID für das Ziel ';

comment on column dirkspzm32.isi_transport.user_id is
    'Erzeuger des Auftrags';

comment on column dirkspzm32.isi_transport.vorgang_id is
    'Nummer um die Positionen zu Klammern Z.B. Tourennummer';

comment on column dirkspzm32.isi_transport.ziel_voll_progr_nr is
    '1=Pause';


-- sqlcl_snapshot {"hash":"e35d8fb8d8b5b35cbc7cd77875b4bc6cd0b32651","type":"COMMENT","name":"isi_transport","schemaName":"dirkspzm32","sxml":""}