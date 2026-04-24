comment on table dirkspzm32.isi_komm_order is
    'Kommisionieraufträge';

comment on column dirkspzm32.isi_komm_order.anz_lte is
    'Die Anzahl der LTE''s, die z.B. umetikettiert oder Umpalettiert werden sollen';

comment on column dirkspzm32.isi_komm_order.artikel_id is
    'Artikel, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.auf_id is
    'Verknüpfung zur Order-Pos-Tabelle, falls dies z.B. eine vorbereitende Kommissionierung für eine konkrete Order-Position ist';

comment on column dirkspzm32.isi_komm_order.bearb_arbeitsplatz_id is
    'Arbeitsplatz, an dem dieser Auftrag bearbeitet wird';

comment on column dirkspzm32.isi_komm_order.bearb_login_id is
    'Benutzer, der diesen Auftrag bearbeitet (hat)';

comment on column dirkspzm32.isi_komm_order.bearb_res_id is
    'Resource, die diesen Auftrag bearbeitet (Stapler, Roboter, Maschine, Wickler, etc.)';

comment on column dirkspzm32.isi_komm_order.bearb_start_datum is
    'Zeitpunkt, an dem die Bearbeitung begonnen wurde';

comment on column dirkspzm32.isi_komm_order.charge_id is
    'Falls relevant, Charge des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.fa_ag is
    'Falls relevant, Fertigungs AG des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.fa_upos is
    'Falls relevant, FE_UPOS des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.fertig_datum is
    'wann wurde die Kommissionierung abegeschlossen';

comment on column dirkspzm32.isi_komm_order.fertig_login_id is
    'Benutzer, der die Kommissionierung durchgeführt und abgeschlossen hat';

comment on column dirkspzm32.isi_komm_order.freigabe is
    'M=manuelle Freigabe; A=automatisch freigegeben zum Freigabedatum';

comment on column dirkspzm32.isi_komm_order.freigabe_datum is
    'freigabe=A --> automatisch Freigeben am';

comment on column dirkspzm32.isi_komm_order.freigegeben_datum is
    'bei manueller Freigabe: Datum, an dem die Freigabe genehmigt wurde';

comment on column dirkspzm32.isi_komm_order.freigegeben_login_id is
    'bei manueller Freigabe: Benutzer, der die Freigabe genehmigt hat';

comment on column dirkspzm32.isi_komm_order.info_text is
    'Freier Text an den Kommissionierer';

comment on column dirkspzm32.isi_komm_order.komm_id is
    'Laufende Nummer';

comment on column dirkspzm32.isi_komm_order.komm_ist_menge is
    'Menge des Artikels, der kommissioniert/abgepackt worden ist';

comment on column dirkspzm32.isi_komm_order.komm_lgr_platz is
    'Auf welchem platz wird kommissioniert bzw. soll kommissioniert werden. Neue Leer-LTE wird auf diesem Platz angelegt';

comment on column dirkspzm32.isi_komm_order.komm_neu_artikel is
    'Bei komm_typ=LC, neue Artikelnummer, nach der Umetikettierung';

comment on column dirkspzm32.isi_komm_order.komm_neu_charge is
    'Bei komm_typ=LC, neue Charge (evtl. des neuen Artikels), nach der Umetikettierung';

comment on column dirkspzm32.isi_komm_order.komm_neu_fa_ag is
    'Bei komm_typ=LC, neuer FA_AG (evtl. des neuen Artikels), nach der Umetikettierung';

comment on column dirkspzm32.isi_komm_order.komm_neu_fa_upos is
    'Bei komm_typ=LC, neue FA_UPOS (evtl. des neuen Artikels), nach der Umetikettierung';

comment on column dirkspzm32.isi_komm_order.komm_neu_leitzahl is
    'Bei komm_typ=LC, neue Leitzahl (evtl. des neuen Artikels), nach der Umetikettierung';

comment on column dirkspzm32.isi_komm_order.komm_neu_lhm_name is
    'LHM-Typ des neuen LHM in den hineinkommissioniert wird (falls automatisch bei Kommissionierung angelegt)';

comment on column dirkspzm32.isi_komm_order.komm_neu_lte_hoehe is
    'voraussichtl. Höhe der neuen LTE, auf die draufkommissioniert wird (falls automatisch bei Kommissionierung angelegt)';

comment on column dirkspzm32.isi_komm_order.komm_neu_lte_name is
    'LTE-Typ der neuen LTE auf die draufkommissioniert wird (falls automatisch bei Kommissionierung angelegt)';

comment on column dirkspzm32.isi_komm_order.komm_neu_seriennr is
    'Bei komm_typ=LC, neue Seriennummer (evtl. des neuen Artikels), nach der Umetikettierung';

comment on column dirkspzm32.isi_komm_order.komm_scan_daten_q is
    'Speichern des gescannten Barcodes von der Kommissionierquelle';

comment on column dirkspzm32.isi_komm_order.komm_scan_daten_z is
    'Speichern des gescannten Barcodes von dem Kommissionierziel';

comment on column dirkspzm32.isi_komm_order.komm_soll_menge is
    'Menge des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.komm_typ is
    'Kommissioniertyp:
KE=Kommissionierung-Entnahme;
KRE=Kommissionierung Rest-Entnahme;
KP=Kommissionierung-Picken;
LC=Label-exChange;
UP=Umpacken;
UPA=Artikelreines Umpacken;
W=Palettenwechsler;
D=reines doppeln;
ZE=Zusatzetikett (z.B. Routinglabel);
MV=Mengen-Validierung;';

comment on column dirkspzm32.isi_komm_order.komm_ziel_lgr_platz is
    'Ziel-Lagerplatz für den Transport nach der Kommissionierung';

comment on column dirkspzm32.isi_komm_order.komm_ziel_lte_id is
    'Falls bekannt, Ziel-LTE auf die Zusammenkommissioniert wird (Mischpalette erstellen)';

comment on column dirkspzm32.isi_komm_order.lam_id is
    'Falls relevant, welche konkrete LAM soll abkommissioniert/abgepackt werden';

comment on column dirkspzm32.isi_komm_order.leitzahl is
    'Falls relevant, Leitzahl des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.lgr_ort_quelle is
    'Falls relevant, aus welchem Lagerort sollen LTE''s für die Kommissionierung reserviert werden.';

comment on column dirkspzm32.isi_komm_order.lhm_hoehe_lage is
    'Höhe einer Lage (LHM''s)';

comment on column dirkspzm32.isi_komm_order.lhm_menge is
    'Menge im Ziel (LHM) für das Zielgebinde';

comment on column dirkspzm32.isi_komm_order.lieferschein_nr is
    'LieferscheinNr';

comment on column dirkspzm32.isi_komm_order.login_id is
    'Benutzer, der den Datensatz angelegt hat';

comment on column dirkspzm32.isi_komm_order.lte_id is
    'Falls relevant, von welcher konkreten LTE soll Ware abkommissioniert/abgepackt werden';

comment on column dirkspzm32.isi_komm_order.lte_lhm_lagen is
    'Anzahl Lagen (LHM''s) je LTE ->  Anzahl der Lagen auf der Zielpalette für Packschema_aufbau Typ Artikel (ART)';

comment on column dirkspzm32.isi_komm_order.lte_lhm_lagen_quelle is
    'Anzahl Lagen (LHM''s) je LTE ->  Anzahl der Lagen der vollen Quellpalette';

comment on column dirkspzm32.isi_komm_order.lte_lhm_pro_lage is
    'Anzahl LHM je Lage';

comment on column dirkspzm32.isi_komm_order.menge is
    'Falls relevant, Menge des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.menge_basis is
    'LKE=kleinste Einheit; LHM=ganzer LHM; LTE=ganze LTE';

comment on column dirkspzm32.isi_komm_order.mhd is
    'Falls relevant, min. MHD des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.modul_bearbeiter is
    'SLS, LVS, KOMM';

comment on column dirkspzm32.isi_komm_order.modul_erzeuger is
    'ISI, HST, LVS, ORD';

comment on column dirkspzm32.isi_komm_order.packschema_kopf_id is
    'Zeiger auf LVS_PACKSCHEMA_KOPF';

comment on column dirkspzm32.isi_komm_order.packschema_traeger_id is
    'Zeiger auf LVS_PACKSCHEMA_KOPF, in dem nur der Trägeraufbau beschrieben ist';

comment on column dirkspzm32.isi_komm_order.prio is
    'Prio für die Bearbeitung';

comment on column dirkspzm32.isi_komm_order.p_komm_id is
    'Link auf übergeordneten Kommissionierauftrag';

comment on column dirkspzm32.isi_komm_order.seriennr_id is
    'Falls relevant, Seriennummer des Artikels, der kommissioniert/abgepackt werden soll';

comment on column dirkspzm32.isi_komm_order.soll_datum is
    'bis spätestens wann soll die Kommissionierung erledigt sein';

comment on column dirkspzm32.isi_komm_order.status is
    'N=Neu;
FB=zur Bearb. Freigeg.;
B=Bearb. beg. (Ware res.);
TVK=Transp. vor Komm.;
TNK=Transp. Nach Komm.;
TVKE;
TNKE;
KA=Komm. aktiv;
KE=Komm. beEndet;
KEH=an Host übertr.;
Z=Zurückgewiesen;';

comment on column dirkspzm32.isi_komm_order.status_info_text is
    'Kann von Prozessen oder Personen, die den aktuellen Status ändern, verwendet werden um zusätzliche Informationen abzulegen';

comment on column dirkspzm32.isi_komm_order.s_ext_rcv_info_text is
    'Feld für Informationen aus dem externen System';

comment on column dirkspzm32.isi_komm_order.s_ext_rcv_komm_id is
    'Externe Nummer (z.B. Lieferscheinnummer vom Host) für den Kommissionierauftrag';

comment on column dirkspzm32.isi_komm_order.s_send_ref_id is
    'Referenz ID aus der Sende-Schnittstelle, nachdem die Daten in die Schnittstelle eingetragen sind';

comment on column dirkspzm32.isi_komm_order.s_send_tab_name is
    'Name der Sende-Schnittstellentabelle';

comment on column dirkspzm32.isi_komm_order.transport_nach_komm is
    'T=nach der Kommissionierung ist ein Transport zu einem z.B. WA erforderlich';

comment on column dirkspzm32.isi_komm_order.transport_vor_komm is
    'T=es ist ein Transport zum Kommissionierplatz vor der Kommissionierung erfordelich; F=Kommissionierung wird direkt am Quell-Lagerplatz durchgeführt'
    ;

comment on column dirkspzm32.isi_komm_order.transp_id_nach_komm is
    'Transport ID des Transportauftrags nach der Kommissionierung';

comment on column dirkspzm32.isi_komm_order.transp_id_vor_komm is
    'Transport ID des Transportauftrags vor der Kommissionierung';

comment on column dirkspzm32.isi_komm_order.ts is
    'Zeitstempel des Datensatzes';

comment on column dirkspzm32.isi_komm_order.vorgang_id is
    'Verknüpfung zur Order-Kopf-Tabelle, falls dies z.B. eine vorbereitende Kommissionierung für eine Order ist';

comment on column dirkspzm32.isi_komm_order.zusatz_etiketten_name is
    'Name des Zusatzetiketts für die Kommissionierung';


-- sqlcl_snapshot {"hash":"5fdf7dc2864b3570df99c402daab0b92306f7cc4","type":"COMMENT","name":"isi_komm_order","schemaName":"dirkspzm32","sxml":""}