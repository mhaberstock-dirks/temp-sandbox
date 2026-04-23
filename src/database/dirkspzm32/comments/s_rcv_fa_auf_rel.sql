comment on table dirkspzm32.s_rcv_fa_auf_rel is
    'Vorgänger Nachfolger Relation für diesen FA';

comment on column dirkspzm32.s_rcv_fa_auf_rel.fa_ag is
    'ID des Vorgangs innerhalb des FA';

comment on column dirkspzm32.s_rcv_fa_auf_rel.fa_upos is
    'Eindeutige ID des Autragvorgangssplits';

comment on column dirkspzm32.s_rcv_fa_auf_rel.leitzahl is
    'Eindeutige ID des FA Kopf';

comment on column dirkspzm32.s_rcv_fa_auf_rel.maxpuffer is
    'Maximaler Abstand zwichen den Vorgängen';

comment on column dirkspzm32.s_rcv_fa_auf_rel.maxpufferbeachten is
    'aktiviert/deaktiviert maximalen Puffer 0=nein 1=ja';

comment on column dirkspzm32.s_rcv_fa_auf_rel.minpuffer is
    'minimaler zeitlicher Abstand zum Nachfolger';

comment on column dirkspzm32.s_rcv_fa_auf_rel.nfa_ag is
    'NachVorgangsID innerhalb des FA';

comment on column dirkspzm32.s_rcv_fa_auf_rel.nfa_upos is
    'NachSplitID  des Ausgangsvorgangssplits';

comment on column dirkspzm32.s_rcv_fa_auf_rel.sid is
    'SID';

comment on column dirkspzm32.s_rcv_fa_auf_rel.ueberlappungstyp is
    'Überlappungstyp, falls Überlappungen zwischen Vorgängen geplant werden sollen 0=keine,  1=prozentual    2=Zeit in s    3=automatisch
';

comment on column dirkspzm32.s_rcv_fa_auf_rel.wert is
    'Überlappungswert entsprechend dem eingestellten 0berlappungstyp
';


-- sqlcl_snapshot {"hash":"c866b5bb60da5048a24b3fc05bd48f44fd1bcc33","type":"COMMENT","name":"s_rcv_fa_auf_rel","schemaName":"dirkspzm32","sxml":""}