comment on table S_RCV_FA_AUF_REL is 'Vorgänger Nachfolger Relation für diesen FA';
comment on column S_RCV_FA_AUF_REL."FA_AG" is 'ID des Vorgangs innerhalb des FA';
comment on column S_RCV_FA_AUF_REL."FA_UPOS" is 'Eindeutige ID des Autragvorgangssplits';
comment on column S_RCV_FA_AUF_REL."LEITZAHL" is 'Eindeutige ID des FA Kopf';
comment on column S_RCV_FA_AUF_REL."MAXPUFFER" is 'Maximaler Abstand zwichen den Vorgängen';
comment on column S_RCV_FA_AUF_REL."MAXPUFFERBEACHTEN" is 'aktiviert/deaktiviert maximalen Puffer 0=nein 1=ja';
comment on column S_RCV_FA_AUF_REL."MINPUFFER" is 'minimaler zeitlicher Abstand zum Nachfolger';
comment on column S_RCV_FA_AUF_REL."NFA_AG" is 'NachVorgangsID innerhalb des FA';
comment on column S_RCV_FA_AUF_REL."NFA_UPOS" is 'NachSplitID  des Ausgangsvorgangssplits';
comment on column S_RCV_FA_AUF_REL."SID" is 'SID';
comment on column S_RCV_FA_AUF_REL."UEBERLAPPUNGSTYP" is 'Überlappungstyp, falls Überlappungen zwischen Vorgängen geplant werden sollen 0=keine,  1=prozentual    2=Zeit in s    3=automatisch
';
comment on column S_RCV_FA_AUF_REL."WERT" is 'Überlappungswert entsprechend dem eingestellten 0berlappungstyp
';



-- sqlcl_snapshot {"hash":"1f0207abb3585072e4a73038656b851a6f67c45b","type":"COMMENT","name":"s_rcv_fa_auf_rel","schemaName":"dirkspzm32","sxml":""}