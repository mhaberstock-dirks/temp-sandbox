comment on table BDE_FA_AUFTRAG_REL is 'Vorgänger Nachfolger Relation für diesen FA';
comment on column BDE_FA_AUFTRAG_REL."FA_AG" is 'ID des Vorgangs innerhalb des FA';
comment on column BDE_FA_AUFTRAG_REL."FA_UPOS" is 'Eindeutige ID des Autragvorgangssplits';
comment on column BDE_FA_AUFTRAG_REL."LEITZAHL" is 'Eindeutige ID des FA Kopf';
comment on column BDE_FA_AUFTRAG_REL."MAXPUFFER" is 'Maximaler Abstand zwichen den Vorgängen';
comment on column BDE_FA_AUFTRAG_REL."MAXPUFFERBEACHTEN" is 'aktiviert/deaktiviert maximalen Puffer 0=nein 1=ja';
comment on column BDE_FA_AUFTRAG_REL."MINPUFFER" is 'minimaler zeitlicher Abstand zum Nachfolger';
comment on column BDE_FA_AUFTRAG_REL."NFA_AG" is 'NachVorgangsID innerhalb des FA';
comment on column BDE_FA_AUFTRAG_REL."NFA_UPOS" is 'NachSplitID  des Ausgangsvorgangssplits';
comment on column BDE_FA_AUFTRAG_REL."SID" is 'SID';
comment on column BDE_FA_AUFTRAG_REL."UEBERLAPPUNGSTYP" is 'Überlappungstyp, falls Überlappungen zwischen Vorgängen geplant werden sollen 0=keine,  1=prozentual    2=Zeit in s    3=automatisch
';
comment on column BDE_FA_AUFTRAG_REL."WERT" is 'Überlappungswert entsprechend dem eingestellten 0berlappungstyp
';



-- sqlcl_snapshot {"hash":"59452346c74a2ffee7118adb8b39e20dcbe25c92","type":"COMMENT","name":"bde_fa_auftrag_rel","schemaName":"dirkspzm32","sxml":""}