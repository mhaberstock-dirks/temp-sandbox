comment on table dirkspzm32.s_erp_rcv_fa_auf_res is
    'Vorgang-Maschinen Liste der möglichen maschinen mit Zeitbedarf';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.auftrag is
    'Aufragsnummer (PLEIT)';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.fa_ag is
    'Arbeitsgang / Vorgang zur Leitzahl';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.fa_upos is
    'Unterposition für Gruppenarbeit (Split)';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.leitzahl is
    'Leitzahl aus DIAF (KLEIT)';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.maschine is
    'Eindeutiger Maschinen ID Z.B. M36';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.minuten is
    'Zeitbedarf für Auftrag auf dieser Maschine in Minuten';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.minuten_ruesten is
    'Zeitbedarf für Rüsten auf dieser Maschine in Minuten';

comment on column dirkspzm32.s_erp_rcv_fa_auf_res.satzart is
    '"V" Verrichten, "MA" = Materialanforderung, "VA" = Verrichten Auswäts, "VR" = Verrichten Rüsten';


-- sqlcl_snapshot {"hash":"216acc9919af2e5324f8801a8b67f12db36a2438","type":"COMMENT","name":"s_erp_rcv_fa_auf_res","schemaName":"dirkspzm32","sxml":""}