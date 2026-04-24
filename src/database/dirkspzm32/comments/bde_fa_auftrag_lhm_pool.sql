comment on table dirkspzm32.bde_fa_auftrag_lhm_pool is
    'Reservierte LHM_NR für diesen Auftag';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.fa_ag is
    'Arbeitsgang des Auftrags';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.fa_upos is
    'Unterposition des Arbeitsgangs';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.leitzahl is
    'Leitzahl Fertigungsauftragsnummer ';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.lhm_id is
    'LHM Nummer';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.lhm_verwendet is
    'Wird die Nummer Verwendet ''F''rei, ''R''eserviert , ''V''erbraucht als echtes LHM gebucht';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.bde_fa_auftrag_lhm_pool.status is
    'N = Neu, D = Gedruckt, UE = Übertragen an z.B. CAQ System';


-- sqlcl_snapshot {"hash":"2339d8c78a9505a1febe0dd0f52982e37f653af0","type":"COMMENT","name":"bde_fa_auftrag_lhm_pool","schemaName":"dirkspzm32","sxml":""}