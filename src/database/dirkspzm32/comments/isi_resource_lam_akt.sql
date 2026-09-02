comment on table ISI_RESOURCE_LAM_AKT is 'In dieser Tabelle sind alle Artikel dim LAM_ID die auf diese Maschine gebucht sind';
comment on column ISI_RESOURCE_LAM_AKT."ARTIKEL_ID" is 'Artikel ID des Artikels, der auf diese Maschine gebucht wurde (Rohstoff)';
comment on column ISI_RESOURCE_LAM_AKT."B_DATUM" is 'Buchungszeitpunkt';
comment on column ISI_RESOURCE_LAM_AKT."LAM_ID" is 'Lager Artikel Material ID, Eindeutige ID des Materials im Lager';
comment on column ISI_RESOURCE_LAM_AKT."LTE_ID" is 'Paletten LTE ID diesen Bestands';
comment on column ISI_RESOURCE_LAM_AKT."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column ISI_RESOURCE_LAM_AKT."RES_LAM_PARAMS" is 'Konfigurierbare Paramter für diese Resource mit Bezug auf die aktuelle LAM';
comment on column ISI_RESOURCE_LAM_AKT."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"60a6b1d6ed2a2d0889e4ab3261398f7f907224d2","type":"COMMENT","name":"isi_resource_lam_akt","schemaName":"dirkspzm32","sxml":""}