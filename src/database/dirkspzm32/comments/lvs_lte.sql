comment on table dirkspzm32.lvs_lte is
    'Transporteinheiten';

comment on column dirkspzm32.lvs_lte.abc is
    'A = Schnell B = Mittel C = Langsam';

comment on column dirkspzm32.lvs_lte.akt_inventur_id is
    'NULL = keine Inventur, ansonsten Inventur aktiv. ID aus LVS_INVENTUR';

comment on column dirkspzm32.lvs_lte.anz_uml is
    'Anzahl der Umlagerungen ';

comment on column dirkspzm32.lvs_lte.auto_depal is
    'Automatisches depaletieren möglich?
 T = True, F = False und NULL Unbekannt ob möglich oder nicht';

comment on column dirkspzm32.lvs_lte.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lte.gefahren_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.lvs_lte.komm_menge_kontrolle is
    'TK = Die Menge muss auf einem Komm-Platz kontrolliert werden, N oder TD LTE kann dierekt zum Ziel, wenn diese komplett benötigt wird'
    ;

comment on column dirkspzm32.lvs_lte.letzte_inventur_datum is
    'NULL = noch keine Inventur erfolgt, ansonsten: Datum der letzten Inventur';

comment on column dirkspzm32.lvs_lte.letzte_inventur_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Inventur anhand ID durchgeführt';

comment on column dirkspzm32.lvs_lte.letzte_inventur_login_id is
    'NULL = noch keine Inventur erfolgt, ansonsten: Wer hat die Inventur hier durchgeführt';

comment on column dirkspzm32.lvs_lte.lgr_platz is
    'Lagerplatz auf dem die TE steht';

comment on column dirkspzm32.lvs_lte.lkw_nr is
    'Gruppiert mehrere Touren (Vorgänge)';

comment on column dirkspzm32.lvs_lte.ls_login_id is
    'Login ID des Erfassers';

comment on column dirkspzm32.lvs_lte.lte_akt_kg is
    'Aktuelles Gewicht der Waren auf dieser Transporteinheit in KG';

comment on column dirkspzm32.lvs_lte.lte_akt_lhm is
    'Anzahl der LHM''s auf diesem LTE';

comment on column dirkspzm32.lvs_lte.lte_eti_druck_status is
    'NULL = Kein Etikett gedruckt, SD= Soll Drucken (etikett muss noch gedruckt werden), D=Etikett gedruckt und vorhanden';

comment on column dirkspzm32.lvs_lte.lte_id is
    'Transporteinheit ID (PID Paletten ID)';

comment on column dirkspzm32.lvs_lte.lte_inv_status is
    'Inventurstatus';

comment on column dirkspzm32.lvs_lte.lte_letzte_buchung is
    'Datum und Zeit der letzten Buchung';

comment on column dirkspzm32.lvs_lte.lte_name is
    'Art, Name der Transporteinheit';

comment on column dirkspzm32.lvs_lte.lte_offset_x is
    'X-Position Y-Position Offset zum Mittelpunkt des Lagerplatz in mm (Lagerplatzmittelpunkt)';

comment on column dirkspzm32.lvs_lte.lte_offset_y is
    'Y-Position Offset zum Mittelpunkt des Lagerplatz in mm (Lagerplatzmittelpunkt)';

comment on column dirkspzm32.lvs_lte.lte_offset_z is
    'Z Position der LTE (Absolut)';

comment on column dirkspzm32.lvs_lte.lte_status is
    'Z,B. ''BS'' = Wird befüllt, ''BF'' Befüller fertig, kann transportiert werden .... Siehe C.LTE_xx_STAT';

comment on column dirkspzm32.lvs_lte.lte_vol is
    'Volumen in m3';

comment on column dirkspzm32.lvs_lte.lte_voll is
    'A = Anbruch, V = Voll (Std-Menge, oder Angelieferte Menge bei Rohware)';

comment on column dirkspzm32.lvs_lte.lte_vol_breite is
    'Gesamtbreite der Transporteinheit in mm';

comment on column dirkspzm32.lvs_lte.lte_vol_hoehe is
    'Gesamthoehe der Transporteinheit in mm';

comment on column dirkspzm32.lvs_lte.lte_vol_tiefe is
    'Gesamttiefe der Transporteinheit in mm';

comment on column dirkspzm32.lvs_lte.max_temp is
    'maximale temperatur der ware';

comment on column dirkspzm32.lvs_lte.min_temp is
    'Minimale temperatur der Ware';

comment on column dirkspzm32.lvs_lte.nve_nr is
    'Eindeutigen Nummer aus Vergabe';

comment on column dirkspzm32.lvs_lte.order_auf_id is
    'Auf_ID aus der ISI-Order';

comment on column dirkspzm32.lvs_lte.order_vorgang_id is
    'Kopf der ISI-Order, wenn Ware auf  dieser LTE  für diese Order reserviert ist sont  null';

comment on column dirkspzm32.lvs_lte.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_lte.res_artikel_id is
    'Artikel_ID als String, kann auch ''MP'' für Mischpaltette sein';

comment on column dirkspzm32.lvs_lte.res_login_id is
    'User, für den diese LTE reserviert ist. Nicht zwingend für Lieferschein/Verladung-Order';

comment on column dirkspzm32.lvs_lte.res_mhd is
    'Gleich, solange gleiche Tage im Firmenstamm';

comment on column dirkspzm32.lvs_lte.res_string is
    'Lagerplatzreservierung für Bsp. Artikel, Charge oder FA + FA_AG + Charge etc.';

comment on column dirkspzm32.lvs_lte.res_string_statisch is
    'Reservierungsstring für LTE wenn null autmatische Berechnung nutzen  sonst diese';

comment on column dirkspzm32.lvs_lte.res_ziel_lgr_platz is
    'Reservierte Ware soll zum Ziel-Lagerplatz';

comment on column dirkspzm32.lvs_lte.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_lte.transport_gruppe is
    'Beladereihenfolge für einen LKW Tournummer im MFR';

comment on column dirkspzm32.lvs_lte.waren_typ is
    'RW = Rohware, HW = Teilfertig/Halbfertigware (Zwischenprodukt), FW Fertigware, MP mischpalette LP leerpalette';

comment on column dirkspzm32.lvs_lte.wert_klasse is
    '0 = Klein, 99 = Hoch';

comment on column dirkspzm32.lvs_lte.wickelprogramm is
    'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';

comment on column dirkspzm32.lvs_lte.wickelprogramm_einl is
    'Wickel Programm Nr. wie die LTE eingelagert werden soll';

comment on column dirkspzm32.lvs_lte.ziel_lgr_ort is
    'Ziel Lagerort';

comment on column dirkspzm32.lvs_lte.ziel_lgr_ort_n_freif is
    'Ziel Lagerort der nach dem Freifahern wieder gesetzt werde soll';

comment on column dirkspzm32.lvs_lte.ziel_lgr_platz is
    'Ziel Lagerplatz';

comment on column dirkspzm32.lvs_lte.ziel_lgr_platz_n_freif is
    'Ziel Lagerplatz der nach dem Freifahern wieder gesetzt werde soll';


-- sqlcl_snapshot {"hash":"90a6fa3a11cc7925d830f9fc204e1a897bc41987","type":"COMMENT","name":"lvs_lte","schemaName":"dirkspzm32","sxml":""}