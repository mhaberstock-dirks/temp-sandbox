comment on table dirkspzm32.lvs_fahrzeuge is
    'Alle Fahrzeuge die für die innerbetrieblichen Transporte zur Verfügung stehen';

comment on column dirkspzm32.lvs_fahrzeuge.akt_trans_lte is
    'Anzahl der aktuelle Transportierten LTE''s';

comment on column dirkspzm32.lvs_fahrzeuge.anz_test_lte is
    'Wenn ein Fahrzeug in der Testphase ist, soll dieses erst mal mit dieser Anzahl an LTE''s getestet werden';

comment on column dirkspzm32.lvs_fahrzeuge.fahrzeug_ausl_ok is
    '''T'' = Fahrzeug ist OK und kann benutzt werden, ''F'' = Fahrzeug ist nicht bereit, ''M'' = Fahrzeug ist manuell auf fehler gestellt ''?'' = Fahzeug in der Testphase und soll erst mal nur ANZ_TEST_LTE fahren'
    ;

comment on column dirkspzm32.lvs_fahrzeuge.fahrzeug_ok is
    '''T'' = Fahrzeug ist OK und kann benutzt werden, ''F'' = Fahrzeug ist nicht bereit, ''M'' = Fahrzeug ist manuell auf fehler gestellt ''?'' = Fahzeug in der Testphase und soll erst mal nur ANZ_TEST_LTE fahren'
    ;

comment on column dirkspzm32.lvs_fahrzeuge.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_fahrzeuge.max_hoehe is
    'Maximale Höhe die dieses Fahrzeug erreichen kann (Bsp. Stalper)';

comment on column dirkspzm32.lvs_fahrzeuge.max_kg is
    'Maximales Gewicht das dieses Fahrzeug transportieren kann';

comment on column dirkspzm32.lvs_fahrzeuge.max_lte is
    'Maximale Anzahl an LTE''s die das Fahrzeug transportieren kann';

comment on column dirkspzm32.lvs_fahrzeuge.max_trans_lte is
    '0 = ohne Beschränkung Max.Anz. LTE''s (mit Fahrzeugen gilt Wert immer, ohne nur wenn Fahrzeug_OK auf ''F''alse steht)';

comment on column dirkspzm32.lvs_fahrzeuge.res_id is
    'Eindeutige Nummer der Resource in der Datenbamk';

comment on column dirkspzm32.lvs_fahrzeuge.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.lvs_fahrzeuge.stapler_ls_id is
    'ID des Leitsystems';

comment on column dirkspzm32.lvs_fahrzeuge.transp_richtung is
    '''B'' = Beide Richtungen, ''A'' = Nur Auslagern ''E'' = Nur Einlagern';

comment on column dirkspzm32.lvs_fahrzeuge.typ is
    'ST = Stapler';


-- sqlcl_snapshot {"hash":"733759a51c90b414f1972b61a0f2bfe934e1439e","type":"COMMENT","name":"lvs_fahrzeuge","schemaName":"dirkspzm32","sxml":""}