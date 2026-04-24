comment on table dirkspzm32.isi_avis_pos is
    'VDA4913, Wareneingangsdaten / Lieferschein AVIS (Wareneingangsankündigung), LFT an Daimler AG (POS)';

comment on column dirkspzm32.isi_avis_pos.abruf_schluessel is
    'Abruf-Schlüssel';

comment on column dirkspzm32.isi_avis_pos.bearbeitungs_status is
    '''N'' = Neu, ''U'' = Übernommen im Wareneingang, ''E'' = Erledigt';

comment on column dirkspzm32.isi_avis_pos.chargen_nr is
    'Chargen-Nummer, z.B. CH12345678';

comment on column dirkspzm32.isi_avis_pos.geaendert_schluessel is
    'Geänderte-Ausführung-Schlüssel, blank';

comment on column dirkspzm32.isi_avis_pos.gefahr_stoff_schluessel is
    'Gefährliche-Stoffe-Schlüssel';

comment on column dirkspzm32.isi_avis_pos.lieferanten_nr is
    'Lieferanten-Nummer, z,B, 12345678';

comment on column dirkspzm32.isi_avis_pos.liefermenge_kunde is
    'N13(10,3), Liefermenge-Kunde, z.B. 0000010000000';

comment on column dirkspzm32.isi_avis_pos.liefermenge_lieferant is
    'N13(10,3), Liefermenge-Lieferant, z.B. 0000010000000';

comment on column dirkspzm32.isi_avis_pos.lieferschein_nr is
    'N8, Lieferschein-Nummer';

comment on column dirkspzm32.isi_avis_pos.lieferschein_pos is
    'N3, Lieferschein-Position';

comment on column dirkspzm32.isi_avis_pos.me_kunde is
    'Mengeneinheit-Kunde, z.B. ST; KG = Kilogramm, L = Liter, M = Meter, M2 = Quadratmeter, M3 = Kubikmeter, SA = Satz, ST = Stück, T = Tonne, 16 = Blatt, 17 = Packungen, 18 = Pack, 19 = Rollen, 21 = Spulen, 23 = Karton, 26 = Dosen, 32 = Verpackungseinheit, 36 = Kanister, 37 = Gebinde'
    ;

comment on column dirkspzm32.isi_avis_pos.me_lieferant is
    'Mengeneinheit-Lieferant, z.B. ST; KG = Kilogramm, L = Liter, M = Meter, M2 = Quadratmeter, M3 = Kubikmeter, SA = Satz, ST = Stück, T = Tonne, 16 = Blatt, 17 = Packungen, 18 = Pack, 19 = Rollen, 21 = Spulen, 23 = Karton, 26 = Dosen, 32 = Verpackungseinheit, 36 = Kanister, 37 = Gebinde'
    ;

comment on column dirkspzm32.isi_avis_pos.praeferenz_status is
    'Präferenzstatus, z.B. G';

comment on column dirkspzm32.isi_avis_pos.sach_nr_kunde is
    'Sachnummer-Kunde, z,B, A2206601234';

comment on column dirkspzm32.isi_avis_pos.sach_nr_lieferant is
    'Sachnummer-Lieferant';

comment on column dirkspzm32.isi_avis_pos.slb_nr is
    'N8, Sendungs-Ladungs-Bezugsnummer, z.B. 12345678';

comment on column dirkspzm32.isi_avis_pos.storno_grund is
    'Grund wenn STORNO';

comment on column dirkspzm32.isi_avis_pos.text_1 is
    'Text 1, hier Zeichnungsgeometriestand und Konstruktionseinsatzmeldung eintragen: Z001E12345   B1205     KEM123054';

comment on column dirkspzm32.isi_avis_pos.text_2 is
    'Text 2';

comment on column dirkspzm32.isi_avis_pos.text_3 is
    'Text 3, hier 13stellig Gewichtschlüssel eintragen: GEW0012310000 (10stellig, davon 4 Nachkommastellen)';

comment on column dirkspzm32.isi_avis_pos.umsatzsteuersatz is
    'N3(2,1), Umsatzsteuersatz, z.B. 190';

comment on column dirkspzm32.isi_avis_pos.ursprungsland is
    'N3, Ursprungsland, z.B. 004';

comment on column dirkspzm32.isi_avis_pos.ursprung_lieferschein_nr is
    'Ursprung-Lieferschein-Nummer';

comment on column dirkspzm32.isi_avis_pos.verwendung_schluessel is
    'Verwendungs-Schlüssel, z.B. S; E = Ersatz allgemein, M = Erstmuster, S = Serie allgemein, U = Serie und Ersatz';

comment on column dirkspzm32.isi_avis_pos.zollgut is
    'Zollgut, blank';


-- sqlcl_snapshot {"hash":"dcc13d5a78fc2f4838850ea7522d5b356fe3154f","type":"COMMENT","name":"isi_avis_pos","schemaName":"dirkspzm32","sxml":""}