comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."AEND_DATUM" is 'Letztes Änderungsdatum des Datensatzes';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."AEND_LOGIN_ID" is 'LoginId der Users, der die letzte Änderung gespeichert hat';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."FA_AG" is 'AG zu dem die Informationen und der Status gespeichert werden';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."FA_AG_STL_ID" is 'Stücklistenposition zu der die Fertigungsdetails, -daten gespeichert werden (nicht NIO-Daten!)';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."FA_NR" is 'eindeutige Nummer, Fertigungsauftrags-Nr. (LEITZAHL in AG) ISIPlus PPS';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."FA_UPOS" is 'AG-UPos zu dem die Informationen und der Status gespeichert werden';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."FERT_LAM_ID" is 'LAM_ID des Fertigproduktes (Fertigungseinheit)';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."PD_LAM_STL_DATEN_ID" is 'Eindeutige Nummer aus Sequence';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."RESULT_PARAMS" is 'Container für Fertigungsparameter / -daten die von Ressourcen automatisiert eingetragen werden können';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."RES_ID" is 'RES_ID (falls bekannt) der Ressource auf der diese LAM in diesem Schritt gefertigt werden soll / wurde';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."RES_STATUS_ID" is 'Ressourcenstatus, der Ressource wenn der Status sich auf eine AG_STL_ID bezieht';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."STATUS" is 'aktueller Status des LAM + AG + Upos (+ AG_STL)';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."STL_LAM_AB_MENGE" is 'Menge Lagerabgang für die LAM';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."STL_LAM_ID" is 'ggf. konkrete LAM_ID der Stücklistenposition';
comment on column DIRKSPZM32.BDE_PD_LAM_STL_DATEN."STL_LAM_IST_MENGE" is 'Menge, die durch den normalen Verbrauch der Fertigungseinheit verbraucht (Verarbeitet) wurde';



-- sqlcl_snapshot {"hash":"4eb8844d3f9fc5282abfa9568c7eee631f08b74b","type":"COMMENT","name":"bde_pd_lam_stl_daten","schemaName":"dirkspzm32","sxml":""}