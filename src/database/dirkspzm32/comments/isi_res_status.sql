comment on table DIRKSPZM32.ISI_RES_STATUS is 'Resourcen-Status Tabelle';
comment on column DIRKSPZM32.ISI_RES_STATUS."FEHLER_RES_ID" is 'Konkrete eingebaute Resource an der ein Fehler aufgetreten ist';
comment on column DIRKSPZM32.ISI_RES_STATUS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_RES_STATUS."LS_LOGIN_ID" is 'Login ID des Erfassers';
comment on column DIRKSPZM32.ISI_RES_STATUS."RES_ID" is 'Eindeutige Nummer der Resource in der Datenbamk';
comment on column DIRKSPZM32.ISI_RES_STATUS."RES_ST_ID" is 'ID der Statusgrunds (0 = Produktion läuft; -1 = Status undefiniert)';
comment on column DIRKSPZM32.ISI_RES_STATUS."RES_ST_UG_ID" is 'ID der Untergruppe';
comment on column DIRKSPZM32.ISI_RES_STATUS."RES_TYP" is 'MG=MaschGruppe, MS=Maschine, WKZ=Werkzeug, ST = Stapler, LI = Linie';
comment on column DIRKSPZM32.ISI_RES_STATUS."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_RES_STATUS."ST_ENDE" is 'Status beendet am/um';
comment on column DIRKSPZM32.ISI_RES_STATUS."ST_START" is 'Status hat begonnen am/um';



-- sqlcl_snapshot {"hash":"0b2124920eed473992c3a187542158af59ab9d7b","type":"COMMENT","name":"isi_res_status","schemaName":"dirkspzm32","sxml":""}