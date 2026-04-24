comment on table dirkspzm32.lvs_prod_linie is
    'Liniendaten für die Etikettenerzeugung';

comment on column dirkspzm32.lvs_prod_linie.adress_id is
    'Werkszugehörigkeit der Linie (kann ein eigenes weiteres Werk sein kann aber auch ein Lieferant sein)';

comment on column dirkspzm32.lvs_prod_linie.auto_depal is
    'Automatisches depaletieren möglich? FALSE: nicht möglich, LAGE: Nur Lagenweise depaletieren möglich, LHM: LHM weise depaletierbar, NULL: Status ist unbekannt'
    ;

comment on column dirkspzm32.lvs_prod_linie.erstellen_mit_transport is
    'Transporteinheit, welche aus der Produktionslinie erstellt wird, wird automatisch eingelagert. Das heißt, es erfolgt nach der Erstellung eine Lagerplatzsuche und der dazugehörige Transport wird generiert.'
    ;

comment on column dirkspzm32.lvs_prod_linie.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_prod_linie.linie_aktiv is
    'Aktive 1 = Ja, 0 = Nein';

comment on column dirkspzm32.lvs_prod_linie.linie_lagerort is
    'Ziellagerort';

comment on column dirkspzm32.lvs_prod_linie.linie_name is
    'Linien Name';

comment on column dirkspzm32.lvs_prod_linie.linie_nr is
    'Linie für Ware';

comment on column dirkspzm32.lvs_prod_linie.linie_produktionsdatum is
    'Produktionsdatum der hier zu Produzierenden Ware';

comment on column dirkspzm32.lvs_prod_linie.lte_eti_druck_status is
    'NULL = Kein Etikett drucken, SD= Soll Drucken (etikett muss noch gedruckt werden)';

comment on column dirkspzm32.lvs_prod_linie.lte_name is
    'Art, Name des LTE''s Bsp.: EURO als Europalette';

comment on column dirkspzm32.lvs_prod_linie.lte_vol_breite is
    'Breite des LTE';

comment on column dirkspzm32.lvs_prod_linie.lte_vol_hoehe is
    'Höhe des LTE';

comment on column dirkspzm32.lvs_prod_linie.lte_vol_tiefe is
    'Länge des LTE';

comment on column dirkspzm32.lvs_prod_linie.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_prod_linie.res_id is
    'Res_id aus ISI_RESOURCE';

comment on column dirkspzm32.lvs_prod_linie.res_string is
    'Reservierungsstring für LTE wenn null autmatische Berechnung nutzen  sonst diese';

comment on column dirkspzm32.lvs_prod_linie.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_prod_linie.wickelprogramm is
    'Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll';

comment on column dirkspzm32.lvs_prod_linie.wickelprogramm_einl is
    'Wickel Programm Nr. wie die LTE eingelagert werden soll';


-- sqlcl_snapshot {"hash":"c1feb49a55c2ea0eaf11e94f096840330154b057","type":"COMMENT","name":"lvs_prod_linie","schemaName":"dirkspzm32","sxml":""}