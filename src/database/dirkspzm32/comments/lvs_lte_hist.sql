comment on table dirkspzm32.lvs_lte_hist is
    'Transporteinheiten';

comment on column dirkspzm32.lvs_lte_hist.abc is
    'A = Schnell B = Mittel C = Langsam';

comment on column dirkspzm32.lvs_lte_hist.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.lvs_lte_hist.anz_uml is
    'Anzahl der Umlagerungen ';

comment on column dirkspzm32.lvs_lte_hist.auto_depal is
    'Automatisches depaletieren möglich? FALSE: nicht möglich, LAGE: Nur Lagenweise depaletieren möglich, LHM: LHM weise depaletierbar, NULL: Status ist unbekannt'
    ;

comment on column dirkspzm32.lvs_lte_hist.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lte_hist.gefahren_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.lvs_lte_hist.komm_menge_kontrolle is
    'TK = Die Menge muss auf einem Komm-Platz kontrolliert werden, N oder TD LTE kann dierekt zum Ziel, wenn diese komplett benötigt wird'
    ;

comment on column dirkspzm32.lvs_lte_hist.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_lte_hist.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_lte_hist.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';

comment on column dirkspzm32.lvs_lte_hist.lgr_platz is
    'Lagerplatz auf dem die TE steht';

comment on column dirkspzm32.lvs_lte_hist.lkw_nr is
    'Gruppiert meherer Touren (Vorgänge)';

comment on column dirkspzm32.lvs_lte_hist.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.lvs_lte_hist.lte_akt_kg is
    'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';

comment on column dirkspzm32.lvs_lte_hist.lte_akt_lhm is
    'Anzahl der LHM''s auf diesem LTE';

comment on column dirkspzm32.lvs_lte_hist.lte_eti_druck_status is
    'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';

comment on column dirkspzm32.lvs_lte_hist.lte_id is
    'Transporteinheit ID (PID Paletten ID)';

comment on column dirkspzm32.lvs_lte_hist.lte_inv_status is
    'Inventurstatus';

comment on column dirkspzm32.lvs_lte_hist.lte_letzte_buchung is
    'Datum und Zeit der letzten Buchung';

comment on column dirkspzm32.lvs_lte_hist.lte_name is
    'Art, Name der Transporteinheit';

comment on column dirkspzm32.lvs_lte_hist.lte_offset_x is
    'X-Position Y-Position Offset zum Mittelpunkt des Lagerplatz in mm (Lagerplatzmittelpunkt)';

comment on column dirkspzm32.lvs_lte_hist.lte_offset_y is
    'Y-Position Offset zum Mittelpunkt des Lagerplatz in mm (Lagerplatzmittelpunkt)';

comment on column dirkspzm32.lvs_lte_hist.lte_offset_z is
    'Z Position der LTE (Absolut)';

comment on column dirkspzm32.lvs_lte_hist.lte_status is
    'Z,B. ''BS'' = Wird befüllt, ''BF'' Befüller fertig, kann transportiert werden ....';

comment on column dirkspzm32.lvs_lte_hist.lte_vol is
    'Volumen in m3';

comment on column dirkspzm32.lvs_lte_hist.lte_voll is
    'A = Anbruch, V = Voll (Std-Menge, oder Angelieferte Menge bei Rohware)';

comment on column dirkspzm32.lvs_lte_hist.lte_vol_breite is
    'Gesamtbreite der Transporteinheit in mm';

comment on column dirkspzm32.lvs_lte_hist.lte_vol_hoehe is
    'Gesamthoehe der Transporteinheit in mm';

comment on column dirkspzm32.lvs_lte_hist.lte_vol_tiefe is
    'Gesamttiefe der Transporteinheit in mm';

comment on column dirkspzm32.lvs_lte_hist.max_temp is
    'maximale temperatur der ware';

comment on column dirkspzm32.lvs_lte_hist.min_temp is
    'Minimale temperatur der Ware';

comment on column dirkspzm32.lvs_lte_hist.nve_nr is
    'Eindeutigen Nummer aus Vergabe';

comment on column dirkspzm32.lvs_lte_hist.order_auf_id is
    'Auf_ID aus der ISI-Order';

comment on column dirkspzm32.lvs_lte_hist.order_vorgang_id is
    'Kopf der ISI-Order, wenn Ware auf  dieser LTE  für diese Order reserviert ist sont  null';

comment on column dirkspzm32.lvs_lte_hist.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_lte_hist.res_artikel_id is
    'Artikel_ID als String, kann auch ''MP'' für Mischpaltette sein';

comment on column dirkspzm32.lvs_lte_hist.res_login_id is
    'User, für den diese LTE reserviert ist. Nicht zwingend für Lieferschein/Verladung-Order';

comment on column dirkspzm32.lvs_lte_hist.res_mhd is
    'Gleich, solange gleiche Tage im Firmenstamm';

comment on column dirkspzm32.lvs_lte_hist.res_string is
    'Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';

comment on column dirkspzm32.lvs_lte_hist.res_string_statisch is
    'Reservierungsstring für LTE wenn null autmatische Berechnung nutzen  sonst diese';

comment on column dirkspzm32.lvs_lte_hist.res_ziel_lgr_platz is
    'Reservierte Ware soll zum Ziel-Lagerplatz';

comment on column dirkspzm32.lvs_lte_hist.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lte_hist.transport_gruppe is
    'Beladereihenfolge für einen LKW Tournummer im MFR';

comment on column dirkspzm32.lvs_lte_hist.waren_typ is
    'RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW Fertigware, MP mischpalette lp leerpalette';

comment on column dirkspzm32.lvs_lte_hist.wert_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.lvs_lte_hist.wickelprogramm is
    'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';

comment on column dirkspzm32.lvs_lte_hist.wickelprogramm_einl is
    'Wickel Programm Nr. wie die LTE eingelagert werden soll';

comment on column dirkspzm32.lvs_lte_hist.ziel_lgr_ort is
    'Ziel Lagerort';

comment on column dirkspzm32.lvs_lte_hist.ziel_lgr_ort_n_freif is
    'Ziel Lagerort der nach dem Freifahern wieder gesetzt werde soll';

comment on column dirkspzm32.lvs_lte_hist.ziel_lgr_platz is
    'Ziel Lagerplatz';

comment on column dirkspzm32.lvs_lte_hist.ziel_lgr_platz_n_freif is
    'Ziel Lagerplatz der nach dem Freifahern wieder gesetzt werde soll';


-- sqlcl_snapshot {"hash":"e26b2170b78d56a46d0ac6f2f3a3a082b24bcdbf","type":"COMMENT","name":"lvs_lte_hist","schemaName":"dirkspzm32","sxml":""}