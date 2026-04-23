comment on table dirkspzm32.lvs_lgr_ort_ue_platz is
    'Übergabeplatze von nach Lagerort';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.lgr_ort_quelle is
    'Lagerort der quelle';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.lgr_ort_ziel is
    'Lagerort des Ziels';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.lgr_platz is
    'Übergabeplatz (NULL = Keine Mögilchkeit / Keine Weg)';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.lte_name is
    'LTE-Nmae eingetragen, dann genau für diese LTE-Namen, Wenn NULL, dann für alle LTE-Typen';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.lte_name_ziel is
    'Wenn die LTE in dieses Ziel soll, dann ist dieser LTE-Typ zu verwenden. Fall dieser NULL, dann bleibt der LTE-Name unverändert';

comment on column dirkspzm32.lvs_lgr_ort_ue_platz.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"730394a52b07250a518371a54b809aac0be84f4c","type":"COMMENT","name":"lvs_lgr_ort_ue_platz","schemaName":"dirkspzm32","sxml":""}