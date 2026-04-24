comment on table dirkspzm32.bde_fa_auftrag_lte_pool is
    'Reservierte LTE_NR für diesen Auftag - Losgoesse 1 LTE';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.leitzahl is
    'Leitzahl Fertigungsauftragsnummer ';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.lte_id is
    'LTE Nummer';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.lte_lfdn is
    'Laufende Nummer im Auftag -- Ggf. für Pärchenbildung';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.lte_verwendet is
    'Wird die Nummer Verwendet ''F''rei, ''R''eserviert , ''V''erbraucht als echtes LTE gebucht, ''A'' = abgeschlossen';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_fa_auftrag_lte_pool.status is
    'N = Neu, D = Gedruckt, UE = Übertragen an z.B. QS System';


-- sqlcl_snapshot {"hash":"51eea18438a997ff25ee1d30eb3c3147aa3be818","type":"COMMENT","name":"bde_fa_auftrag_lte_pool","schemaName":"dirkspzm32","sxml":""}