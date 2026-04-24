comment on table dirkspzm32.bde_fa_auftrag_rel is
    'Vorgänger Nachfolger Relation für diesen FA';

comment on column dirkspzm32.bde_fa_auftrag_rel.fa_ag is
    'ID des Vorgangs innerhalb des FA';

comment on column dirkspzm32.bde_fa_auftrag_rel.fa_upos is
    'Eindeutige ID des Autragvorgangssplits';

comment on column dirkspzm32.bde_fa_auftrag_rel.leitzahl is
    'Eindeutige ID des FA Kopf';

comment on column dirkspzm32.bde_fa_auftrag_rel.maxpuffer is
    'Maximaler Abstand zwichen den Vorgängen';

comment on column dirkspzm32.bde_fa_auftrag_rel.maxpufferbeachten is
    'aktiviert/deaktiviert maximalen Puffer 0=nein 1=ja';

comment on column dirkspzm32.bde_fa_auftrag_rel.minpuffer is
    'minimaler zeitlicher Abstand zum Nachfolger';

comment on column dirkspzm32.bde_fa_auftrag_rel.nfa_ag is
    'NachVorgangsID innerhalb des FA';

comment on column dirkspzm32.bde_fa_auftrag_rel.nfa_upos is
    'NachSplitID  des Ausgangsvorgangssplits';

comment on column dirkspzm32.bde_fa_auftrag_rel.sid is
    'SID';

comment on column dirkspzm32.bde_fa_auftrag_rel.ueberlappungstyp is
    'Überlappungstyp, falls Überlappungen zwischen Vorgängen geplant werden sollen 0=keine,  1=prozentual    2=Zeit in s    3=automatisch
';

comment on column dirkspzm32.bde_fa_auftrag_rel.wert is
    'Überlappungswert entsprechend dem eingestellten 0berlappungstyp
';


-- sqlcl_snapshot {"hash":"06d94581d93fe3f0ecae28c9415319c9634a0fc6","type":"COMMENT","name":"bde_fa_auftrag_rel","schemaName":"dirkspzm32","sxml":""}