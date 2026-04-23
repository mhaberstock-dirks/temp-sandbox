comment on table dirkspzm32.s_erp_rcv_fa_auf_fhm is
    'Vorgang-Maschinen Liste der möglichen maschinen mit Zeitbedarf';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.auftrag is
    'Aufragsnummer (PLEIT)';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.fa_ag is
    'Arbeitsgang / Vorgang zur Leitzahl';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.fa_upos is
    'Unterposition für Gruppenarbeit';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.fhm_grp is
    'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.leitzahl is
    'Leitzahl aus DIAF (KLEIT)';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.prod_fhm is
    'Benötigtes FHM';

comment on column dirkspzm32.s_erp_rcv_fa_auf_fhm.ruest_zeit is
    'Rüstzeit für den Einbau und Ausbau';


-- sqlcl_snapshot {"hash":"4c275b33fa8ccaf0f20ebd39d354364b18616430","type":"COMMENT","name":"s_erp_rcv_fa_auf_fhm","schemaName":"dirkspzm32","sxml":""}