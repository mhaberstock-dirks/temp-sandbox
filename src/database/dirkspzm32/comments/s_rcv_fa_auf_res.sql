comment on table dirkspzm32.s_rcv_fa_auf_res is
    'Vorgang-Maschinen';

comment on column dirkspzm32.s_rcv_fa_auf_res.auftrag is
    'Aufragsnummer (PLEIT)';

comment on column dirkspzm32.s_rcv_fa_auf_res.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_rcv_fa_auf_res.fa_ag is
    'Arbeitsgang / Vorgang zur Leitzahl';

comment on column dirkspzm32.s_rcv_fa_auf_res.fa_upos is
    'Unterposition für Gruppenarbeit (Split)';

comment on column dirkspzm32.s_rcv_fa_auf_res.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_rcv_fa_auf_res.leitzahl is
    'Leitzahl aus DIAF (KLEIT)';

comment on column dirkspzm32.s_rcv_fa_auf_res.minuten is
    'Zeitbedarf für Auftrag auf dieser Maschine in Minuten';

comment on column dirkspzm32.s_rcv_fa_auf_res.minuten_ruesten is
    'Zeitbedarf für Rüsten auf dieser Maschine in Minuten';

comment on column dirkspzm32.s_rcv_fa_auf_res.res_id is
    'Maschinen ID aus der Resourcentabelle';

comment on column dirkspzm32.s_rcv_fa_auf_res.satzart is
    '"V" Verrichten, "MA" = Materialanforderung, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten
';


-- sqlcl_snapshot {"hash":"a12b3daa5ec793f038b1f2fb48d72b1315d2abba","type":"COMMENT","name":"s_rcv_fa_auf_res","schemaName":"dirkspzm32","sxml":""}