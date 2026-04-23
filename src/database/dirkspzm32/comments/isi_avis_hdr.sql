comment on table dirkspzm32.isi_avis_hdr is
    'VDA4913, Wareneingangsdaten / Lieferschein AVIS (Wareneingangsankündigung), LFT an Daimler AG';

comment on column dirkspzm32.isi_avis_hdr.abladestelle is
    'Abladestelle, Entladeort der bei der Bestellung angegeben wird';

comment on column dirkspzm32.isi_avis_hdr.abruf_nr is
    'N4, Abruf-Nummer, z.B. 1234';

comment on column dirkspzm32.isi_avis_hdr.abschluss_bestell_nr is
    'N12, Abschluss-Bestell-Nr. wie in der Bestellung angegeben. Sollte keine Angabe vorhanden sein, wird hier 9 eingetragen.';

comment on column dirkspzm32.isi_avis_hdr.anz_packstuecke is
    'N4, Anzahl Packstücke';

comment on column dirkspzm32.isi_avis_hdr.bearbeitungs_status is
    '''N'' = Neu, ''U'' = Übernommen im Wareneingang, ''E'' = Erledigt';

comment on column dirkspzm32.isi_avis_hdr.bearb_datum is
    'Bearbeitungsdatum und -uhrzeit, zuletzt bearbeitet am';

comment on column dirkspzm32.isi_avis_hdr.besteller is
    'Besteller, Zeichen des Kunden';

comment on column dirkspzm32.isi_avis_hdr.brutto_gewicht is
    'N7, Brutto-Gewicht ohne Dezimalstelle, Ware einschl. Verpackung und LHM';

comment on column dirkspzm32.isi_avis_hdr.daten_empf_werk is
    'Datenempfangswerk, z.B. 10005007 für Sindelfingen';

comment on column dirkspzm32.isi_avis_hdr.daten_sender_nr is
    'Datensendernummer, z.B. 12345678A';

comment on column dirkspzm32.isi_avis_hdr.dok_nr_kunde is
    'Dokument-Nr. Kunde';

comment on column dirkspzm32.isi_avis_hdr.eintreff_datum_soll is
    'Datum und Uhrzeit, an dem die Ware bei Daimler AG angeliefert werden soll';

comment on column dirkspzm32.isi_avis_hdr.erstell_datum is
    'Erstellungsdatum und -uhrzeit, erstellt am';

comment on column dirkspzm32.isi_avis_hdr.export_datum is
    'Datum und Uhrzeit des Exports durch Service Logic';

comment on column dirkspzm32.isi_avis_hdr.fehler_code is
    'Host-Übertragung Fehlernummer';

comment on column dirkspzm32.isi_avis_hdr.fehler_text is
    'Host-Übertragung Fehlertext';

comment on column dirkspzm32.isi_avis_hdr.ff_uebergabe_datum is
    'Frachtführer-Übergabe-Datum und Uhrzeit';

comment on column dirkspzm32.isi_avis_hdr.frachtfuehrer is
    'Frachtführer, z.B. Müller';

comment on column dirkspzm32.isi_avis_hdr.frankatur_schluessel is
    'N2, Frankatur-Schlüssel, z.B. 01';

comment on column dirkspzm32.isi_avis_hdr.import_datum is
    'Datum und Uhrzeit des Imports durch Service Logic';

comment on column dirkspzm32.isi_avis_hdr.konsignation is
    'N8, Konsignation, ref auf ISI_Adressen ADR_ID';

comment on column dirkspzm32.isi_avis_hdr.lademeter is
    'N3, Angabe der belegten Meter der Ladefläche (eine Dezimalstelle), z.B. 093';

comment on column dirkspzm32.isi_avis_hdr.lagerhalter_id is
    'Lagerhalter-Schlüssel, [blank]';

comment on column dirkspzm32.isi_avis_hdr.lagerort_kunde is
    'Lagerort Kunde, entspricht der Anlieferstelle im Belieferungsprozess,';

comment on column dirkspzm32.isi_avis_hdr.lieferanten_nr is
    'Lieferanten-Nummer, z,B, 12345678';

comment on column dirkspzm32.isi_avis_hdr.lieferschein_datum is
    'Versanddatum, Datum und Uhrzeit des Lieferscheins ';

comment on column dirkspzm32.isi_avis_hdr.lieferschein_nr is
    'N8, Lieferschein-Nummer';

comment on column dirkspzm32.isi_avis_hdr.liefer_kennung is
    'Lieferungs-Kennung, [blank]';

comment on column dirkspzm32.isi_avis_hdr.lkw_art_schluessel is
    'N1, LKW-Art Schlüssel, z.B. 1';

comment on column dirkspzm32.isi_avis_hdr.nachricht_datum is
    'Datum und Uhrzeit der Nachricht';

comment on column dirkspzm32.isi_avis_hdr.nachricht_nr is
    'N5, Datenersteller vergibt NACHRICHT_NR. Datenersteller wiederholt Nummer des vorausgegangenen DFÜ-Laufs als NACHRICHT_NR_A';

comment on column dirkspzm32.isi_avis_hdr.nachricht_nr_a is
    'N5, Beschreibung siehe NACHRICHT_NR. Bei der ersten Übertragung ist NACHRICHT_NR_A = 00000';

comment on column dirkspzm32.isi_avis_hdr.nachricht_typ is
    'Nachrichten Typ: Lieferschein, ...';

comment on column dirkspzm32.isi_avis_hdr.nachricht_ursprg is
    'Ursprungsdatei, z.B. M100_r0011239.d01.txt';

comment on column dirkspzm32.isi_avis_hdr.nachricht_ziel is
    'Zieldatei, MB<3stelligWerk><3stelligWEZielsystem>; z.B. MB050WES';

comment on column dirkspzm32.isi_avis_hdr.netto_gewicht is
    'N7, Netto-Gewicht ohne Dezimalstelle, Ware einschl. Verpackung aber ohne LHM';

comment on column dirkspzm32.isi_avis_hdr.slb_nr is
    'N8, Sendungs-Ladungs-Bezugsnummer, z.B. 12345678';

comment on column dirkspzm32.isi_avis_hdr.spediteur_dfu_schluessel is
    'Spediteur DFÜ-Schlüssel';

comment on column dirkspzm32.isi_avis_hdr.sped_daten_empf is
    'Speditionsdaten-Empfänger, z.B. 12345678';

comment on column dirkspzm32.isi_avis_hdr.storno_grund is
    'Grund wenn STORNO';

comment on column dirkspzm32.isi_avis_hdr.transfer_status is
    'Host-Übertragung Status; N=Neu, U=In Übertragung, UE=erfolgreich übertragen, F=Fehler, L=zum Löschen markiert';

comment on column dirkspzm32.isi_avis_hdr.transportmittel_info is
    'Transportmittel-Information, z.B. HH-DD 123';

comment on column dirkspzm32.isi_avis_hdr.transportmittel_info_id is
    'Transportmittel-Info-Schlüssel, z.B. 2';

comment on column dirkspzm32.isi_avis_hdr.transportmittel_nr is
    'Transportmittel-Nr., z.B. 471112345';

comment on column dirkspzm32.isi_avis_hdr.transportmittel_schluessel is
    'N2, Transportmittel-Schlüssel, 01 = KFZ-Kennzwichen, 02 = Bordero-Nummer, 07 = Expressgut-Nummer, 08 = Waggon-Nummer, 09 = Postpaket-Nummer, 19 = Flugnummer / Luftfrachtbrief-Nr., 11 = Schiffsname'
    ;

comment on column dirkspzm32.isi_avis_hdr.transport_partner_nr is
    'Transportpartner-Nummer, z.B. 12345678';

comment on column dirkspzm32.isi_avis_hdr.verbrauchsstelle is
    'Verbrauchsstelle, wie im Abruf falls vorhanden';

comment on column dirkspzm32.isi_avis_hdr.versandart is
    'N2, Versandart: 01 = LKW (Unterlieferant), 02 = LKW Kunde, 03 = LKW Spedition, 04 = LKW Bahn, 05 = LKW eigen (Lieferant), 08 = Bahn Waggon, 09 = Postsendung, 10 = Luftfracht, 11 = Seefracht, 20 = Privater Paketdienst'
    ;

comment on column dirkspzm32.isi_avis_hdr.vorgang_schluessel is
    'N2, Vorgangs-Schlüssel, z.B. 40';

comment on column dirkspzm32.isi_avis_hdr.waren_empfaenger_nr is
    'Waren-Empfänger-Nummer, z.B. 12345678';

comment on column dirkspzm32.isi_avis_hdr.werk_kunde is
    'N3, Werk Kunde, z.B. 050';

comment on column dirkspzm32.isi_avis_hdr.werk_lieferant is
    'Werk Lieferant, z.B. AAA';


-- sqlcl_snapshot {"hash":"087452ff8a04ea48f2ecc3996b6846867c5124cb","type":"COMMENT","name":"isi_avis_hdr","schemaName":"dirkspzm32","sxml":""}