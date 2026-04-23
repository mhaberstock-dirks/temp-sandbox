comment on table dirkspzm32.bde_fa_auftrag_res_liste is
    'Resourcenliste für diesen AG im Planauftrag';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.abnr is
    'Eindeutige Nummer';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.fa_ag is
    'Vorgangsnummer des Fertigungsauftrags (erstmal nur Plan in dieser Tabelle)';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.fa_upos is
    'Unterposition für den Arbeitsgang (für Parallelverarbeitung auf mehreren Resourcen)';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.firma_nr is
    'Firma Nr.';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.leitzahl is
    'Auftragsnummer aus PPS_PLAN_AUFTRAG';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.minuten is
    'Angabe,wie viele Minuten benötigt diese Alternativ-Ressource';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.minuten_ruesten is
    'Zeitbedarf für Rüsten auf dieser Maschine in Minuten';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.res_id is
    'Resource(ngruppe), die für die Produktion eingesetzt werden soll';

comment on column dirkspzm32.bde_fa_auftrag_res_liste.sid is
    'SID';


-- sqlcl_snapshot {"hash":"2bc6455dcd49cd663ec43eaa97382145ccf30143","type":"COMMENT","name":"bde_fa_auftrag_res_liste","schemaName":"dirkspzm32","sxml":""}