comment on table ISI_TOR_CFG is 'Beschreibung der Tore für den ISI Server';
comment on column ISI_TOR_CFG."COM_NAME" is 'Angeschlossen an ComServer für Antworten etc.';
comment on column ISI_TOR_CFG."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column ISI_TOR_CFG."SCHED_RES_ID" is 'Resourcen-ID für den Task-Scheduler';
comment on column ISI_TOR_CFG."SID" is 'Datenbank für Konsolidierung';
comment on column ISI_TOR_CFG."TOR_ABLAUF" is 'Welche Funktion handelt die Comunikation ab';
comment on column ISI_TOR_CFG."TOR_ALLE" is '''T'' Alle eingetragenen Transponder dürfen dieses Tor öffnen';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN" is 'Soll das Tor eine Daueroeffnung haben T = Ja F = Nein';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_BIS" is 'Uhrzeit ab wann ist das Tor daueroffen';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_DI" is 'Gillt fuer Dienstags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_DO" is 'Gillt fuer Donnerstags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_FEIERTAG" is 'Gillt Feiertags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_FR" is 'Gillt fuer Freitags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_MI" is 'Gillt fuer Mittwochs';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_MO" is 'Gillt fuer Montags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_SA" is 'Gillt fuer Samstags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_SO" is 'Gillt fuer Sonntags';
comment on column ISI_TOR_CFG."TOR_DAUER_OFFEN_VON" is 'Uhrzeit ab wann ist das Tor daueroffen';
comment on column ISI_TOR_CFG."TOR_ID_LESEGERAET" is 'Name vom Transponderleser für Tor';
comment on column ISI_TOR_CFG."TOR_ID_LESEGERAET_TYP" is 'Lesertyp vom Transponderleser';
comment on column ISI_TOR_CFG."TOR_NAME" is 'Name des TOR';
comment on column ISI_TOR_CFG."TOR_OFFEN_ZEIT" is 'Wie lange ist das Tor offen in Sekunden';
comment on column ISI_TOR_CFG."TOR_POST" is 'Postambel für TOR (Letzte Zeichen vor 0x0D) Bsp.: ]]';
comment on column ISI_TOR_CFG."TOR_PRAE" is 'Präambel im TOR ohne Name Bsp.: [[';
comment on column ISI_TOR_CFG."TOR_RS485_ADRESSE" is 'Adresse des Tors bei Protokoll RS485';
comment on column ISI_TOR_CFG."TOR_TYP" is 'TOR Typ, evtl später für besondere Abhandlung';
comment on column ISI_TOR_CFG."TOR_VISUNAME" is 'Name in der Visu';
comment on column ISI_TOR_CFG."TOR_WARTE_ANTWORT" is 'Zus. Wartezeit für Antwort, wenn Antwort noch nicht da';
comment on column ISI_TOR_CFG."TOR_WARTE_DATEN" is 'Wartezeit beim Lesen ob noch etwas kommt';
comment on column ISI_TOR_CFG."TOR_WARTE_EXECUTE" is 'Wartezeit im EXECUTE';
comment on column ISI_TOR_CFG."TOR_WARTE_N_SENDEN" is 'Wartezeit nach Senden zum ComServer';



-- sqlcl_snapshot {"hash":"56c87cce585b92aa6c42d81508abf0b7b1ffb741","type":"COMMENT","name":"isi_tor_cfg","schemaName":"dirkspzm32","sxml":""}