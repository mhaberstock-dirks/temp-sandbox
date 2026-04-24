comment on table dirkspzm32.lvs_lgr_ort is
    'Beschreibung der Lagerorte';

comment on column dirkspzm32.lvs_lgr_ort.adress_id is
    'Adressen ID zur Bestimmung wo sich der Lagerort befindet (Standort)';

comment on column dirkspzm32.lvs_lgr_ort.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.lvs_lgr_ort.default_abc is
    'ABC Typ 1= A Schnelldreher 2=B Mitteldreher 3 = C Langsamdreher';

comment on column dirkspzm32.lvs_lgr_ort.default_breite is
    'Vorgabebreite neuer Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.default_flaechen_stellplatz is
    'Ist dieser Lagerplatz ein Flächenstellplatz (dann können hier auch Spezialpaletten abgestellt werden). Siehe LTE_CFG';

comment on column dirkspzm32.lvs_lgr_ort.default_gefahren_klasse is
    'Klasse für Gefahrenkennzeichen, Gefahrenklasse des Artikel muss <= sein';

comment on column dirkspzm32.lvs_lgr_ort.default_hoehe is
    'Vorgabehoehe neuer Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.default_lgr_temp is
    'Temperatur des Lagers';

comment on column dirkspzm32.lvs_lgr_ort.default_lte_namen_cfg is
    'Vorgabe der TE die generell z.B. wenn Leer eingelagert werden dürfen';

comment on column dirkspzm32.lvs_lgr_ort.default_max_lte is
    'Vorgabe Max TE je Lagerplatz';

comment on column dirkspzm32.lvs_lgr_ort.default_tiefe is
    'Vorgabetiefe neuer Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.default_waren_typen_cfg is
    'welche warentypen ''FW'',HW'',''RW'' darf hier hinein!';

comment on column dirkspzm32.lvs_lgr_ort.default_wert_klasse is
    'Klasse für Warenwert, Wertklasse des Artikels muss <= diesem sein';

comment on column dirkspzm32.lvs_lgr_ort.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lgr_ort.host_lgr_ort is
    'Lagerort im Frempsystem (HOST)';

comment on column dirkspzm32.lvs_lgr_ort.komm_ausweich_lgr_platz is
    'Kommissionierlagerplatz, wenn keine Kommissionierung an diesem lgr_ort möglich ist';

comment on column dirkspzm32.lvs_lgr_ort.komm_direkt_moegl is
    'Ist an diesem Lagerort eine Kommissionierung möglich (T = möglich, F = nicht möglich)';

comment on column dirkspzm32.lvs_lgr_ort.komm_neu_lte_lgr_platz is
    'Standardlagerplatz für neue LTEs bei Kommissionierung';

comment on column dirkspzm32.lvs_lgr_ort.komm_picken_moegl is
    'Ist an diesem Lagerort das Picken von LHMs möglich (T = möglich, F = nicht möglich)';

comment on column dirkspzm32.lvs_lgr_ort.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_lgr_ort.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_lgr_ort.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt/beaufsichtigt';

comment on column dirkspzm32.lvs_lgr_ort.lgr_dim_e_text is
    'Bezeichnung für den Log. Bezeichner Ebene';

comment on column dirkspzm32.lvs_lgr_ort.lgr_dim_g_text is
    'Bezeichnung für den Log. Bezeichner Gang';

comment on column dirkspzm32.lvs_lgr_ort.lgr_dim_p_text is
    'Bezeichnung für den Log. Bezeichner Platz';

comment on column dirkspzm32.lvs_lgr_ort.lgr_dim_r_g_u_gegenueber is
    'Liegt in diesem Lagerort Grade und Ungrade regalnimmern gegebüber';

comment on column dirkspzm32.lvs_lgr_ort.lgr_dim_r_text is
    'Bezeichnung für den Log. Bezeichner Regal';

comment on column dirkspzm32.lvs_lgr_ort.lgr_dim_t_text is
    'Bezeichnung für den Log. Bezeichner Tiefe';

comment on column dirkspzm32.lvs_lgr_ort.lgr_einl_opti is
    'Soll an diesem Lagerort nach der WE-Scannung und Findung eiens Platz nochmal nach einem besseren gesucht werden';

comment on column dirkspzm32.lvs_lgr_ort.lgr_lte_namen is
    'alle LTE_NAMEN, Die in diesen Lagerort gelagert werden dürfen z.B. ''EURO'';''INDU'';''CHEP'' ;...';

comment on column dirkspzm32.lvs_lgr_ort.lgr_max_breite is
    'MAX-Breite des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_max_hoehe is
    'MAX-Hoehe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_max_tiefe is
    'MAX-Tiefe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_min_breite is
    'MIN-Breite des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_min_hoehe is
    'MIN-Hoehe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_min_tiefe is
    'MIN-Tiefe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort is
    'Kurzname oder Nummer des Lagerorts';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_block_trans_erlaubt is
    'Darf eine Palette ausgelagert werden, wenn sie von einer anderen blockiert wird.';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_fuehrend_system is
    'Für diesen Lagerort ist ISI das führende System oder das hier bezeichnete';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_max_kg_proz is
    'Maximal darf dieser Prozentsatz in KG in Plätze der LVS_LGR.LGR_KG_GRUPPE eingelagert werden';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_modul is
    '''MFR'',SLS'',....wer transportiert die Ware dieses Lagerorts Für ISI_TRANSPORT';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_raster_x is
    'Raster im mm für X-Richtung (Breite)';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_raster_y is
    'Raster im mm für Y-Richtung (Tiefe)';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_text is
    'Bezeichnung der Lagerorts';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_vol_breite is
    'Gesamtbreite des Lagerort in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_vol_hoehe is
    'Gesamthoehe des Lagerort in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_ort_vol_tiefe is
    'Gesamttiefe des Lagerort in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_platz_cfg is
    'Config String für die Lagerplatz Bsp.: GG.RR.PPP.EE.TT Gang Regal Platz Ebene Tiefe';

comment on column dirkspzm32.lvs_lgr_ort.lgr_platz_eti_pfeil_richt is
    'Pfeilrichtung auf dem Lagerplatzetikett (o/u/r/l zeigt nach oben, unten, rechts oder linkks)';

comment on column dirkspzm32.lvs_lgr_ort.lgr_platz_rand_abstand_x is
    'Abstand zum nächsten Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_platz_rand_abstand_y is
    'Abstand zum nächsten Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr_ort.lgr_typ is
    'BLK1, SAT1, KANAL1, KANAL_BLOCK1, REG_FACH1 .....';

comment on column dirkspzm32.lvs_lgr_ort.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lgr_ort.stapler_ls_id is
    'ID der Staplerleitsystems';

comment on column dirkspzm32.lvs_lgr_ort.strat_abc is
    'Faktor besser, schlechter für ABC-Abgleich';

comment on column dirkspzm32.lvs_lgr_ort.strat_abstand_faktor is
    '0 = Abstand Egal 1 = Grosser Abstand Gut -1 kleiner Abstand gut Zusammenstellen';

comment on column dirkspzm32.lvs_lgr_ort.strat_art_res is
    'Faktor besser, schlechter wenn für einen Kanal eine Artikelreservierung vorgenommen wurde';

comment on column dirkspzm32.lvs_lgr_ort.strat_breite_relevanz is
    'Faktor mit dem die freihe Breite multpliziert wird um der Lagerplatz zu bewerten
';

comment on column dirkspzm32.lvs_lgr_ort.strat_fuellgrad_relevanz is
    'Achtung: Funktioniert nur, wenn der Abstans-faktor >0 ist. Faktor mit dem der Füllgrad in Prozent multipliziert wird, wenn im Lager gleichverteilung gewünscht ist'
    ;

comment on column dirkspzm32.lvs_lgr_ort.strat_gewicht_relevanz is
    'Faktor mit dem das Differenzgewicht multpliziert wird um der Lagerplatz zu bewerten';

comment on column dirkspzm32.lvs_lgr_ort.strat_hoehe_relevanz is
    'Faktor mit dem die freihe Hoehe multpliziert wird um den Lagerplatz zu bewerten';

comment on column dirkspzm32.lvs_lgr_ort.strat_lgr_platz_akt_lte is
    'Um wieviel besser wird der PLatz bei je power(LTE, 2)';

comment on column dirkspzm32.lvs_lgr_ort.strat_lgr_platz_verfueg is
    'Um wieviel besser wird der PLatz bei je Verfügbaren Platz';

comment on column dirkspzm32.lvs_lgr_ort.strat_order_reservierung is
    'Um wieviel schlechter wird der PLatz bei je Order Reservierung';

comment on column dirkspzm32.lvs_lgr_ort.strat_ort_abstand_faktor is
    'Abstand der Lagerplätze nach LGR_ORT ';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_ausl_dispo is
    'Um wieviel schlechter wird der PLatz bei je Auslagerung';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_factor_max is
    'Schlechter darf der Platz in der Bewertung nicht sein (Nur Belegung';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_falsch is
    '!!! TEXT !!!!! -- Multiplikator für Kanäle die mit anderen Artikeln gefüllt sind';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_leer is
    'Multiplikator für leeren Platz';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_misch_kanal is
    'Multiplikator für Mischkanäle';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_misch_pal is
    'Multiplikator für Kanäle mit Mischpaletten';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_res_string is
    'Multiplikator für gleichen Reservierungsstring';

comment on column dirkspzm32.lvs_lgr_ort.strat_platz_r_faktor is
    'Platz (X-Achse) 0 = Egal  (1) Kleine Gut (-1)Grosse Gut ';

comment on column dirkspzm32.lvs_lgr_ort.strat_regal_hoehe_fw is
    'Reservierung (FW) Fertigware (+1) =  von Unten nach Oben,  (-1)  Von Oben nach Unten Hohe Gut (0) Egal (Alt. C.LGR_HOEHE_FW_WERT)'
    ;

comment on column dirkspzm32.lvs_lgr_ort.strat_regal_hoehe_hw is
    'Reservierung (HW) Fertigware (+1) =  von Unten nach Oben,  (-1)  Von Oben nach Unten Hohe Gut (0) Egal
';

comment on column dirkspzm32.lvs_lgr_ort.strat_regal_hoehe_mp is
    'Reservierung (MP) Fertigware (+1) =  von Unten nach Oben,  (-1)  Von Oben nach Unten Hohe Gut (0) Egal
';

comment on column dirkspzm32.lvs_lgr_ort.strat_regal_hoehe_rw is
    'Reservierung (RW) Fertigware (+1) =  von Unten nach Oben,  (-1)  Von Oben nach Unten Hohe Gut (0) Egal';

comment on column dirkspzm32.lvs_lgr_ort.strat_tiefe_relevanz is
    'Faktor mit dem die freihe Tiefe multpliziert wird um der Lagerplatz zu bewerten';

comment on column dirkspzm32.lvs_lgr_ort.verl_vorb_lgr_orte is
    'Lagerorte in die Verladungen aus diesem Lagerort vorbereitet werden können.';


-- sqlcl_snapshot {"hash":"0999e34e0fbc30fe2db71e84f629f6e1ff428521","type":"COMMENT","name":"lvs_lgr_ort","schemaName":"dirkspzm32","sxml":""}