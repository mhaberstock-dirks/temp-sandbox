comment on table ISI_KOMM_ZEIT is 'Zeit für das Umpacken eine LAM auf eine KOM-Platz';
comment on column ISI_KOMM_ZEIT."BEARB_RES_ID" is 'Resource, die diesen Auftrag bearbeitet (Stapler, Roboter, Maschine, Wickler, etc.)';
comment on column ISI_KOMM_ZEIT."KOMM_ZEIT_SEC" is 'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ';
comment on column ISI_KOMM_ZEIT."QUELL_TRANSPORT_EINHEIT" is '"Transportierte Ware
 ''LTE'' = Alle LTE_CFG,
 ''LHM'' = Alle LHM_CFG,
 ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE
 ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM
"';
comment on column ISI_KOMM_ZEIT."ZIEL_TRANSPORT_EINHEIT" is '"Transportierte Ware
 ''LTE'' = Alle LTE_CFG,
 ''LHM'' = Alle LHM_CFG,
 ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE
 ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM
"';



-- sqlcl_snapshot {"hash":"6b04430529b48d173c71ae0eadf9f78a79c2fc26","type":"COMMENT","name":"isi_komm_zeit","schemaName":"dirkspzm32","sxml":""}