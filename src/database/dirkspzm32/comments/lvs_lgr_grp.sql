comment on table dirkspzm32.lvs_lgr_grp is
    'Lagerplatz Gruppe für dir Zuordnung von Fahrzeugen auf einen Teil eiens Lagerorts';

comment on column dirkspzm32.lvs_lgr_grp.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lgr_grp.lgr_gruppe_haupt_grp is
    'Um Lagergrupen zusammen zu fassen Bsp 3 Lagergruppen und zwei Fahrzeuge die auf eine Schiene fahren';

comment on column dirkspzm32.lvs_lgr_grp.lgr_gruppe_id is
    'ID Der Gruppe (Gruppe für die Zuordnung von Fahrzeugen)';

comment on column dirkspzm32.lvs_lgr_grp.lgr_gruppe_max_lte is
    'Anzahl Max LTE die in dieser Gruppe eingelagert werden können';

comment on column dirkspzm32.lvs_lgr_grp.lgr_gruppe_name is
    'Text Bezeichnung der Gruppe';

comment on column dirkspzm32.lvs_lgr_grp.lgr_ort is
    'Referenz zum Lagerort';

comment on column dirkspzm32.lvs_lgr_grp.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"7338ae87179c6916f6d823db2a63dc75b5c7eb91","type":"COMMENT","name":"lvs_lgr_grp","schemaName":"dirkspzm32","sxml":""}