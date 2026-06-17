comment on table DIRKSPZM32.LVS_LAM_BH is 'Lager Artikel Menge Buchungs Historie';
comment on column DIRKSPZM32.LVS_LAM_BH."ABNR" is 'Auftragsbestätigungsnummer des Kundenauftragsbestätigung';
comment on column DIRKSPZM32.LVS_LAM_BH."ABNR_EXTERN" is 'Auftrag Bestätigungsnummer (PLEIT)';
comment on column DIRKSPZM32.LVS_LAM_BH."ARTIKEL_ID" is 'Artikel ID in ISI_ARTIKEL';
comment on column DIRKSPZM32.LVS_LAM_BH."BUCH_DATUM" is 'Buchungsdatum';
comment on column DIRKSPZM32.LVS_LAM_BH."BUS" is 'Buchungsschlüssel (Zugang, Abgang, Inventur etc.)';
comment on column DIRKSPZM32.LVS_LAM_BH."CHANGE_MENGE" is 'Menge die geändert wurde';
comment on column DIRKSPZM32.LVS_LAM_BH."CHARGE_ID" is 'ID der Charge';
comment on column DIRKSPZM32.LVS_LAM_BH."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.LVS_LAM_BH."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column DIRKSPZM32.LVS_LAM_BH."FA_AG" is 'Arbeitsgang des Auftrags';
comment on column DIRKSPZM32.LVS_LAM_BH."FA_UPOS" is 'Unterposition des Arbeitsgangs';
comment on column DIRKSPZM32.LVS_LAM_BH."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_LAM_BH."LAM_BH_ID" is 'Buchungsnummer ID';
comment on column DIRKSPZM32.LVS_LAM_BH."LAM_BH_KG" is 'Aktuelles Gewicht der Waren in KG';
comment on column DIRKSPZM32.LVS_LAM_BH."LAM_BH_KG_EINHEIT" is 'Gewicht der Ware je Einheit';
comment on column DIRKSPZM32.LVS_LAM_BH."LAM_ID" is 'Lager Artikel Mengen ID auf die gebucht wurde (Bestands Key)';
comment on column DIRKSPZM32.LVS_LAM_BH."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.LVS_LAM_BH."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column DIRKSPZM32.LVS_LAM_BH."LEITZAHL" is 'Leitzahl des Fertigungsauftrags (KLEIT)';
comment on column DIRKSPZM32.LVS_LAM_BH."LGR_PLATZ" is 'Bebuchter Lagerplatz';
comment on column DIRKSPZM32.LVS_LAM_BH."LHM_ID" is 'ID des Lagerhilfsmittel für diese Buchung';
comment on column DIRKSPZM32.LVS_LAM_BH."LI_NR" is 'Lieferscheinnummer der Auslieferung';
comment on column DIRKSPZM32.LVS_LAM_BH."LI_POS_NR" is 'Lieferscheinpositionsnummer der Auslieferung';
comment on column DIRKSPZM32.LVS_LAM_BH."LS_LOGIN_ID" is 'Login ID des Erfassers';
comment on column DIRKSPZM32.LVS_LAM_BH."LTE_ID" is 'ID der Transporteinheit für diese Buchung';
comment on column DIRKSPZM32.LVS_LAM_BH."MENGE" is 'Aktuelle gebuchte Menge im Lager';
comment on column DIRKSPZM32.LVS_LAM_BH."OWNER_ADDRESS_ID" is 'Aktueller Eigentümer bei Ausführung der Buchung (gilt auch für normale Bewegungen im Lager) für Auswertungen';
comment on column DIRKSPZM32.LVS_LAM_BH."OWNER_ADDRESS_ID_NEW" is 'Neuer Eigentümer bei Umbuchung von Konsignationsware für Auswertungen';
comment on column DIRKSPZM32.LVS_LAM_BH."RES_ID" is 'Mit welcher Resource wurde diese Buchung (TRANSPORT) durchgeführt';
comment on column DIRKSPZM32.LVS_LAM_BH."SERIE_ID" is 'ID Der Serie';
comment on column DIRKSPZM32.LVS_LAM_BH."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.LVS_LAM_BH."VORGANG_ID" is 'Tour der Auslieferung';
comment on column DIRKSPZM32.LVS_LAM_BH."VORG_ID" is 'Vorgangs ID Bsp.: Eine Umlagerung sind zei Buchungen aber ein Vorgang';
comment on column DIRKSPZM32.LVS_LAM_BH."VORG_TYP" is 'Art der Vorgangs (LZ, LA, INventur, DIspo etc)';



-- sqlcl_snapshot {"hash":"8442a84547fa1397d78b939bb556d619a3e3b093","type":"COMMENT","name":"lvs_lam_bh","schemaName":"dirkspzm32","sxml":""}