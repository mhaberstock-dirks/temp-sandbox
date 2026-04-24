comment on table dirkspzm32.bde_fa_auftrag_fhm is
    'Fertigungshilfsmittel-Liste für diesen AG im Planauftrag';

comment on column dirkspzm32.bde_fa_auftrag_fhm.abnr is
    'Eindeutige Nummer aus SEQ';

comment on column dirkspzm32.bde_fa_auftrag_fhm.anz_benoetigt is
    'wieviele FHMs belegt dieser Vorgang auf einem Fertigungshilfsmittel [Gantt rechnet hier in %] - Die tatsächliche Belegung wird auf ganze Zahlen abgerundet'
    ;

comment on column dirkspzm32.bde_fa_auftrag_fhm.fa_ag is
    'FA Arbeitsgang, für den dieses FHM benötigt wird';

comment on column dirkspzm32.bde_fa_auftrag_fhm.fa_upos is
    'FA Unterposition bzw Arbeitsgang';

comment on column dirkspzm32.bde_fa_auftrag_fhm.fhm_grp is
    'Gruppe (Ein FHM aus leitzahl/fa_ag/fa_upos muss auf der maschine verfügbar sein)';

comment on column dirkspzm32.bde_fa_auftrag_fhm.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.bde_fa_auftrag_fhm.leitzahl is
    'Auftragsnummer aus PPS_PLAN_AUFTRAG';

comment on column dirkspzm32.bde_fa_auftrag_fhm.prod_fhm is
    'Benötigtes FHM / Alternative im Arbeitsgang';

comment on column dirkspzm32.bde_fa_auftrag_fhm.sid is
    'SID';


-- sqlcl_snapshot {"hash":"70fad2fd0592cd57b2d5aa15d404eb1bca0ba028","type":"COMMENT","name":"bde_fa_auftrag_fhm","schemaName":"dirkspzm32","sxml":""}