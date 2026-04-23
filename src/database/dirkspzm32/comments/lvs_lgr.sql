comment on table dirkspzm32.lvs_lgr is
    'Lagerplätze im ISIPlus LVS';

comment on column dirkspzm32.lvs_lgr.abc is
    'ABC Typ 1= A Schnelldreher 2=B Mitteldreher 3 = C Langsamdreher';

comment on column dirkspzm32.lvs_lgr.aktivierung_prio is
    'Prio für den Transport für diese Ziel. Wenn Die Prio im Transport hoeher ist, bleibt die höhere bestehen.';

comment on column dirkspzm32.lvs_lgr.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.lvs_lgr.anz_uml is
    'Max Anzahl an Umlagerungen ';

comment on column dirkspzm32.lvs_lgr.change_date is
    'Datum letzte Änderung';

comment on column dirkspzm32.lvs_lgr.change_login_id is
    'Login ID letzte Änderung (Wird z.Zt. nicht gefüllt)';

comment on column dirkspzm32.lvs_lgr.einl_ort_default_liste is
    'Liste der Einlagerorte, die als default auf diesem Platz genommen werden. Bsp.: 001;101;201; = In dieser Reihenfloge sollen die Platzsuche erfolgen. Also erst in 1 dann in 101 und dann in '
    ;

comment on column dirkspzm32.lvs_lgr.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lgr.flaechen_stellplatz is
    'Ist dieser Lagerplatz ein Flächenstellplatz (dann können hier auch Spezialpaletten abgestellt werden). Siehe LTE_CFG';

comment on column dirkspzm32.lvs_lgr.gefahren_klasse is
    'Klasse für Gefahrenkennzeichen, Gefahrenklasse des Artikel muss <= sein';

comment on column dirkspzm32.lvs_lgr.gesperrt is
    'F = Freigegeben, G = Gesperrt';

comment on column dirkspzm32.lvs_lgr.gesp_grund is
    'Grund für die Sperre';

comment on column dirkspzm32.lvs_lgr.gruppe is
    'Gruppierungskennzeichen Lagerplatz z.B. ein Kanal oder eine Gruppe von Plätzen die Strategisch zusammen geführt werden können [Satelitengasse im SAT_EPL oder dynamische Kanaltiefen])'
    ;

comment on column dirkspzm32.lvs_lgr.hrl_lag_max_pal_a is
    'Anzahl Euro Pal. je Kanal';

comment on column dirkspzm32.lvs_lgr.hrl_lag_max_pal_i is
    'Anzahl Indu Pal. je Kanal';

comment on column dirkspzm32.lvs_lgr.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_lgr.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_lgr.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';

comment on column dirkspzm32.lvs_lgr.lgr_akt_kg is
    'Aktuelles Gewicht der Waren auf diesem Lagerplatz in KG';

comment on column dirkspzm32.lvs_lgr.lgr_akt_te is
    'Anzahl der Transporteinheiten die aktuell auf diesem Lagerplatz stehen';

comment on column dirkspzm32.lvs_lgr.lgr_dat_erstellt is
    'Datum der Erstellung';

comment on column dirkspzm32.lvs_lgr.lgr_dat_erst_belegt is
    'Datum der ersten Belegung mit Ware';

comment on column dirkspzm32.lvs_lgr.lgr_dat_l_inventur is
    'Datum der letzten Inventur -- NICHT BENUTZT!! LÖSCHEN KLÄREN';

comment on column dirkspzm32.lvs_lgr.lgr_dim_e is
    'Logische Ebene im Regal oder Stapelhöhe bei Bodenlagerung';

comment on column dirkspzm32.lvs_lgr.lgr_dim_fifo_nr is
    'Identisch mit LGR_DIM_T oder LGR_DIM_E';

comment on column dirkspzm32.lvs_lgr.lgr_dim_g is
    'Logischer Lagergang';

comment on column dirkspzm32.lvs_lgr.lgr_dim_p is
    'Logischer Lagerplatz (Zwingend minimum im LGR_PLATZ)';

comment on column dirkspzm32.lvs_lgr.lgr_dim_platz is
    'Logische Platz Beschreibung aus GGGG+RRRR+PPPP+EEEE+TTTT';

comment on column dirkspzm32.lvs_lgr.lgr_dim_r is
    'Logisches Regal';

comment on column dirkspzm32.lvs_lgr.lgr_dim_t is
    'Logische Tiefe im Regal oder Position der Palette vom Platzende';

comment on column dirkspzm32.lvs_lgr.lgr_dispo_einl_frei_hoehe is
    'Höhen die für Einlagerung aktuell für diesen Lagerplatz disponiert sind';

comment on column dirkspzm32.lvs_lgr.lgr_dispo_einl_kg is
    'Geplanter Zugang in KG für diesen Lagerplatz';

comment on column dirkspzm32.lvs_lgr.lgr_dispo_einl_te is
    'Anzahl der Transporteinheiten aktuell für diesen Lagerplatz disponiert';

comment on column dirkspzm32.lvs_lgr.lgr_einl_te_verfueg is
    'LGR_max_TE-LGR_AKT_TE-LGR_DISPO_EINL_TE';

comment on column dirkspzm32.lvs_lgr.lgr_einl_te_verfueg_gruppe is
    'LGR_max_TE-LGR_AKT_TE-LGR_DISPO_EINL_TE der ges. LGR_PLATZ_GRUPPE';

comment on column dirkspzm32.lvs_lgr.lgr_frei_breite is
    'Freie Breite des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_frei_hoehe is
    'Freie Hoehe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_frei_tiefe is
    'Freie Tiefe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_gruppe_id is
    'ID Der Gruppe (Gruppe für die Zuordnung von Fahrzeugen)';

comment on column dirkspzm32.lvs_lgr.lgr_kg_gruppe is
    'Gruppe für Prozentsatz in KG die eingelagert werden dürfen (Wird beim Anlegen mit DIM_GANG, Regal und Platz gefüllt)';

comment on column dirkspzm32.lvs_lgr.lgr_max_kg is
    'Maximale Tragfähigkeit des Lagerplatzes in KG';

comment on column dirkspzm32.lvs_lgr.lgr_max_te is
    'Anzahl der Transporteinheiten Maximal';

comment on column dirkspzm32.lvs_lgr.lgr_min_lte_breite is
    'Minimale Breite der LTE in diesem Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_min_lte_hoehe is
    'Minimale Hoehe der LTE in diesem Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_min_lte_tiefe is
    'Minimale Tiefe der LTE in diesem Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_order_res_te is
    'Anzahl der LTE''s die für eine Order Reserviert sind';

comment on column dirkspzm32.lvs_lgr.lgr_ort is
    'Referenz zum Lagerort';

comment on column dirkspzm32.lvs_lgr.lgr_platz is
    'Lagerplatz ID gebildet aus Vorgabe im Lagerort';

comment on column dirkspzm32.lvs_lgr.lgr_platz_eti_pfeil_richt is
    'Pfeilrichtung auf dem Lagerplatzetikett (o/u/r/l zeigt nach oben, unten, rechts oder linkks)';

comment on column dirkspzm32.lvs_lgr.lgr_platz_gruppe is
    'Gruppe des Platzes (Fifo struktur)';

comment on column dirkspzm32.lvs_lgr.lgr_platz_gruppe_gegenueber is
    'gegenüberliegender Lagerplatzgruppe bei Gängen mit zwei seiten';

comment on column dirkspzm32.lvs_lgr.lgr_pos_x is
    'X-Position der Lagerplatz in mm (Lagerplatzmittelpunkt)';

comment on column dirkspzm32.lvs_lgr.lgr_pos_y is
    'X-Position der Lagerplatz in mm (Lagerplatzmittelpunkt)';

comment on column dirkspzm32.lvs_lgr.lgr_res_strat is
    'Reservierung über (A)= Anzahl TE Artikel / Reservirungsstring (O) = Oder / Auftragsbezogen RES_String = Ordernummer im Lager';

comment on column dirkspzm32.lvs_lgr.lgr_temp is
    'Temperatur des Lagers';

comment on column dirkspzm32.lvs_lgr.lgr_typ is
    'BLK1, SAT1, KANAL1, KANAL_BLOCK1, REG_FACH1 .....';

comment on column dirkspzm32.lvs_lgr.lgr_usr_id_erstellt is
    'LS_LOGIN_ID des Erstellers';

comment on column dirkspzm32.lvs_lgr.lgr_verwendung is
    'WE, WA, Lager, Puffer etc., WEP Wareneingang für Palletierer, LagerP = Paletierplatz';

comment on column dirkspzm32.lvs_lgr.lgr_verwendung_proj is
    'Für Projekte individuell verwendbar (Keine Std. Logik verwendet dieses Feld)';

comment on column dirkspzm32.lvs_lgr.lgr_vol_breite is
    'Gesamtbreite des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_vol_hoehe is
    'Gesamthoehe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lgr_vol_tiefe is
    'Gesamttiefe des Lagerplatz in mm';

comment on column dirkspzm32.lvs_lgr.lte_namen is
    'Aktuell erlaubte TEs die eingelagert werden dürfen   ''Keine''  = Lagerplatz nicht verwendbar;  Null = Alle LteNamen';

comment on column dirkspzm32.lvs_lgr.lte_namen_cfg is
    'Vorgabe der TE die generell z.B. wenn Leer eingelagert werden dürfen';

comment on column dirkspzm32.lvs_lgr.owner_address_id is
    'ID in der ISI_ADRESSEN für KONSI. Ist der Wert != NULL dann ist die Adresse dieser ID Eigentümer der Ware';

comment on column dirkspzm32.lvs_lgr.res_artikel_id is
    'Lagerplatz ist für diese Artikel_ID Statisch reserviert';

comment on column dirkspzm32.lvs_lgr.res_art_statisch is
    'Reservierung Statisch = Dauerhaft =''T'' sonst ''F'' ';

comment on column dirkspzm32.lvs_lgr.res_ls_login_name is
    'Lagerplatz ist Reserviert für User';

comment on column dirkspzm32.lvs_lgr.res_res_string_statisch is
    'Reservierung von Res_String Statisch (Bediener) =''T'' sonst ''F''';

comment on column dirkspzm32.lvs_lgr.res_string is
    'Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';

comment on column dirkspzm32.lvs_lgr.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lgr.transport_einheit is
    'Transportierte Ware
 ''LTE'' = Alle LTE_CFG,
 ''LHM'' = Alle LHM_CFG,
 ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE
 ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM
';

comment on column dirkspzm32.lvs_lgr.uml_erlaubt is
    'T = Erlaubt R = Umlagern nur im gleichen Regal F = Gasseninternse Umlagern nicht erlaubt';

comment on column dirkspzm32.lvs_lgr.waren_typen_cfg is
    'welche warentypen ''FW'',HW'',''RW'' darf hier hinein!';

comment on column dirkspzm32.lvs_lgr.wa_menge_ueberlief is
    'Bei Lieferbestellungen an diesen WA darf bei T auch zu viel geliefert werden,
wenn dadurch auf eine Kommissionierung verzichtet werden kann.';

comment on column dirkspzm32.lvs_lgr.wa_typ is
    'NULL = Funktion wie bisher, LDPR = Bereitstellung, LDPO = Verladepunkt LTE wird sofort ausgelagert BDEPUSH=BDE-PUSCH Normal kann auch im Typ Lager eingetragen werden (Dann Quelle für BDE-Resevierung und in ISI-Firma eingeschaltet), BDEICEPUSH = BDE-Pusch Express'
    ;

comment on column dirkspzm32.lvs_lgr.wert_klasse is
    'Klasse für Warenwert, Wertklasse des Artikels muss <= diesem sein';


-- sqlcl_snapshot {"hash":"dd85d22a97fda72bd48b8add06ae53c4599d9bce","type":"COMMENT","name":"lvs_lgr","schemaName":"dirkspzm32","sxml":""}