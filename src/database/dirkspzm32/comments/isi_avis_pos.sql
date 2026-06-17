comment on table DIRKSPZM32.ISI_AVIS_POS is 'VDA4913, Wareneingangsdaten / Lieferschein AVIS (Wareneingangsankündigung), LFT an Daimler AG (POS)';
comment on column DIRKSPZM32.ISI_AVIS_POS."ABRUF_SCHLUESSEL" is 'Abruf-Schlüssel';
comment on column DIRKSPZM32.ISI_AVIS_POS."BEARBEITUNGS_STATUS" is '''N'' = Neu, ''U'' = Übernommen im Wareneingang, ''E'' = Erledigt';
comment on column DIRKSPZM32.ISI_AVIS_POS."CHARGEN_NR" is 'Chargen-Nummer, z.B. CH12345678';
comment on column DIRKSPZM32.ISI_AVIS_POS."GEAENDERT_SCHLUESSEL" is 'Geänderte-Ausführung-Schlüssel, blank';
comment on column DIRKSPZM32.ISI_AVIS_POS."GEFAHR_STOFF_SCHLUESSEL" is 'Gefährliche-Stoffe-Schlüssel';
comment on column DIRKSPZM32.ISI_AVIS_POS."LIEFERANTEN_NR" is 'Lieferanten-Nummer, z,B, 12345678';
comment on column DIRKSPZM32.ISI_AVIS_POS."LIEFERMENGE_KUNDE" is 'N13(10,3), Liefermenge-Kunde, z.B. 0000010000000';
comment on column DIRKSPZM32.ISI_AVIS_POS."LIEFERMENGE_LIEFERANT" is 'N13(10,3), Liefermenge-Lieferant, z.B. 0000010000000';
comment on column DIRKSPZM32.ISI_AVIS_POS."LIEFERSCHEIN_NR" is 'N8, Lieferschein-Nummer';
comment on column DIRKSPZM32.ISI_AVIS_POS."LIEFERSCHEIN_POS" is 'N3, Lieferschein-Position';
comment on column DIRKSPZM32.ISI_AVIS_POS."ME_KUNDE" is 'Mengeneinheit-Kunde, z.B. ST; KG = Kilogramm, L = Liter, M = Meter, M2 = Quadratmeter, M3 = Kubikmeter, SA = Satz, ST = Stück, T = Tonne, 16 = Blatt, 17 = Packungen, 18 = Pack, 19 = Rollen, 21 = Spulen, 23 = Karton, 26 = Dosen, 32 = Verpackungseinheit, 36 = Kanister, 37 = Gebinde';
comment on column DIRKSPZM32.ISI_AVIS_POS."ME_LIEFERANT" is 'Mengeneinheit-Lieferant, z.B. ST; KG = Kilogramm, L = Liter, M = Meter, M2 = Quadratmeter, M3 = Kubikmeter, SA = Satz, ST = Stück, T = Tonne, 16 = Blatt, 17 = Packungen, 18 = Pack, 19 = Rollen, 21 = Spulen, 23 = Karton, 26 = Dosen, 32 = Verpackungseinheit, 36 = Kanister, 37 = Gebinde';
comment on column DIRKSPZM32.ISI_AVIS_POS."PRAEFERENZ_STATUS" is 'Präferenzstatus, z.B. G';
comment on column DIRKSPZM32.ISI_AVIS_POS."SACH_NR_KUNDE" is 'Sachnummer-Kunde, z,B, A2206601234';
comment on column DIRKSPZM32.ISI_AVIS_POS."SACH_NR_LIEFERANT" is 'Sachnummer-Lieferant';
comment on column DIRKSPZM32.ISI_AVIS_POS."SLB_NR" is 'N8, Sendungs-Ladungs-Bezugsnummer, z.B. 12345678';
comment on column DIRKSPZM32.ISI_AVIS_POS."STORNO_GRUND" is 'Grund wenn STORNO';
comment on column DIRKSPZM32.ISI_AVIS_POS."TEXT_1" is 'Text 1, hier Zeichnungsgeometriestand und Konstruktionseinsatzmeldung eintragen: Z001E12345   B1205     KEM123054';
comment on column DIRKSPZM32.ISI_AVIS_POS."TEXT_2" is 'Text 2';
comment on column DIRKSPZM32.ISI_AVIS_POS."TEXT_3" is 'Text 3, hier 13stellig Gewichtschlüssel eintragen: GEW0012310000 (10stellig, davon 4 Nachkommastellen)';
comment on column DIRKSPZM32.ISI_AVIS_POS."UMSATZSTEUERSATZ" is 'N3(2,1), Umsatzsteuersatz, z.B. 190';
comment on column DIRKSPZM32.ISI_AVIS_POS."URSPRUNGSLAND" is 'N3, Ursprungsland, z.B. 004';
comment on column DIRKSPZM32.ISI_AVIS_POS."URSPRUNG_LIEFERSCHEIN_NR" is 'Ursprung-Lieferschein-Nummer';
comment on column DIRKSPZM32.ISI_AVIS_POS."VERWENDUNG_SCHLUESSEL" is 'Verwendungs-Schlüssel, z.B. S; E = Ersatz allgemein, M = Erstmuster, S = Serie allgemein, U = Serie und Ersatz';
comment on column DIRKSPZM32.ISI_AVIS_POS."ZOLLGUT" is 'Zollgut, blank';



-- sqlcl_snapshot {"hash":"59248f634ea00993f64e1910a574a1f98c82366e","type":"COMMENT","name":"isi_avis_pos","schemaName":"dirkspzm32","sxml":""}