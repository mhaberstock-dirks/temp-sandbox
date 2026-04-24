comment on table dirkspzm32.s_rcv_fa_auf_fhm is
    'Vorgang-Maschinen';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.anz_benoetigt is
    'wieviele FHMs belegt dieser Vorgang auf einem Fertigungshilfsmittel [Gantt rechnet hier in %] - Die tatsächliche Belegung wird auf ganze Zahlen abgerundet'
    ;

comment on column dirkspzm32.s_rcv_fa_auf_fhm.auftrag is
    'Aufragsnummer (PLEIT)';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.auf_id is
    'eindeutige Sequenz-Nummer';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.fa_ag is
    'Arbeitsgang / Vorgang zur Leitzahl';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.fa_upos is
    'Unterposition für Gruppenarbeit Split';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.fhm_grp is
    'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.firma_nr is
    'Mandant z.B. 01';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.leitzahl is
    'Leitzahl aus DIAF (KLEIT)';

comment on column dirkspzm32.s_rcv_fa_auf_fhm.prod_fhm is
    'Benötigtes FHM';


-- sqlcl_snapshot {"hash":"c7d77853ebb6c82300dcd156f7ad7bf502bc1d37","type":"COMMENT","name":"s_rcv_fa_auf_fhm","schemaName":"dirkspzm32","sxml":""}