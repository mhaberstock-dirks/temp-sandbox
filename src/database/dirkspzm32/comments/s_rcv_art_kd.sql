comment on column dirkspzm32.s_rcv_art_kd.aktiv is
    'Status Aktiv T = Artikelnummer ist gültig, F = Artikelnummer ist ungültig';

comment on column dirkspzm32.s_rcv_art_kd.artikel is
    'Artikelnummer aus Schnittstelle';

comment on column dirkspzm32.s_rcv_art_kd.ean is
    'EAN je kleinster Einheit (z.B. Je Becher, Päckchen, Stück etc.)';

comment on column dirkspzm32.s_rcv_art_kd.kd_art_nr is
    'Kundenartikelnummer';

comment on column dirkspzm32.s_rcv_art_kd.kd_art_text1 is
    'Bezeichnung 1';

comment on column dirkspzm32.s_rcv_art_kd.kd_art_text2 is
    'Bezeichnung 2';

comment on column dirkspzm32.s_rcv_art_kd.kunden_nr is
    'Kundennummer für Artikel (Kondition)';

comment on column dirkspzm32.s_rcv_art_kd.lhm_ean is
    'EAN für LHM';

comment on column dirkspzm32.s_rcv_art_kd.lhm_gewicht_kg is
    'LHM Gewicht incl. Verpackung';

comment on column dirkspzm32.s_rcv_art_kd.lhm_menge is
    'LHM = Kleinste Gebindemenge';

comment on column dirkspzm32.s_rcv_art_kd.lhm_name is
    'Name des LHM z.B. K600 = Karton 600 aus LVS_LHM_CFG';

comment on column dirkspzm32.s_rcv_art_kd.lte_breite_max is
    'Max Breite incl. Überstand';

comment on column dirkspzm32.s_rcv_art_kd.lte_ean is
    'EAN für eine Transporteinheit';

comment on column dirkspzm32.s_rcv_art_kd.lte_gewicht_kg is
    'Max Gewicht der Transporteinheit (Gilt nur für Artikelreine Ttransporteinheit)';

comment on column dirkspzm32.s_rcv_art_kd.lte_hoehe_lage is
    'Höhe einer Lage (LHM''s)';

comment on column dirkspzm32.s_rcv_art_kd.lte_hoehe_max is
    'Max Höhe incl. Transporteinheit';

comment on column dirkspzm32.s_rcv_art_kd.lte_lhm_lagen is
    'Anzahl Lagen (LHM''s) je LTE';

comment on column dirkspzm32.s_rcv_art_kd.lte_lhm_menge is
    'Anzahl LHM je Transporteinheit';

comment on column dirkspzm32.s_rcv_art_kd.lte_lhm_pro_lage is
    'Anzahl LHM je Lage';

comment on column dirkspzm32.s_rcv_art_kd.lte_menge is
    'Menge je Mengeneinheit pro. Transporteinheit';

comment on column dirkspzm32.s_rcv_art_kd.lte_name is
    'EURO = Europalette, INDU = INDU-Palette, CHEPEURO = Chep-Europalette ... aus LVS_LTE_CFG';

comment on column dirkspzm32.s_rcv_art_kd.lte_tiefe_max is
    'Max Tiefe incl. Überstand';

comment on column dirkspzm32.s_rcv_art_kd.pack_vorschr is
    'Verpackungsvorschrift';

comment on column dirkspzm32.s_rcv_art_kd.stk_liste_txt is
    'Texte für Stücklisten auf Etikett oder sonstige Texte';


-- sqlcl_snapshot {"hash":"8727a0e86ceee27f4dd6a6281b952dda8fc0bdaf","type":"COMMENT","name":"s_rcv_art_kd","schemaName":"dirkspzm32","sxml":""}