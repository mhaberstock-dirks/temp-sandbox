comment on table dirkspzm32.isi_komm_zeit is
    'Zeit für das Umpacken eine LAM auf eine KOM-Platz';

comment on column dirkspzm32.isi_komm_zeit.bearb_res_id is
    'Resource, die diesen Auftrag bearbeitet (Stapler, Roboter, Maschine, Wickler, etc.)';

comment on column dirkspzm32.isi_komm_zeit.komm_zeit_sec is
    'Bearbeitungszeit in Sekunden für das Umpacken vom Quell-Typ zum Ziel-Typ';

comment on column dirkspzm32.isi_komm_zeit.quell_transport_einheit is
    '"Transportierte Ware
 ''LTE'' = Alle LTE_CFG,
 ''LHM'' = Alle LHM_CFG,
 ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE
 ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM
"';

comment on column dirkspzm32.isi_komm_zeit.ziel_transport_einheit is
    '"Transportierte Ware
 ''LTE'' = Alle LTE_CFG,
 ''LHM'' = Alle LHM_CFG,
 ''LTE_LTE'' = LTE_CFG vom Transporttyp LTE
 ''LTE_LHM'' = LTE_CFG vom Transporttyp LHM
"';


-- sqlcl_snapshot {"hash":"7da19231003cfc8d3cd380dd478fc7905e836805","type":"COMMENT","name":"isi_komm_zeit","schemaName":"dirkspzm32","sxml":""}