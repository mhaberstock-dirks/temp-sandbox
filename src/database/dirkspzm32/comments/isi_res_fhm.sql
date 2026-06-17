comment on table DIRKSPZM32.ISI_RES_FHM is 'Stammdatem Fertigungshilfsmittel';
comment on column DIRKSPZM32.ISI_RES_FHM."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.ISI_RES_FHM."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.ISI_RES_FHM."DYN_GEN" is 'Dynamisch generiert T ja oder F Nein D beim nächsten Prüfen löschen';
comment on column DIRKSPZM32.ISI_RES_FHM."FHM" is 'Fertigungshilsmittel';
comment on column DIRKSPZM32.ISI_RES_FHM."FHM_GRP" is 'Name der FHM-Gruppe (z.B. Formteilfamilie)';
comment on column DIRKSPZM32.ISI_RES_FHM."FIRMA_NR" is 'Mandant / Firma';
comment on column DIRKSPZM32.ISI_RES_FHM."GESCHW_FAKTOR_FERT" is 'Geschwindigkeitsfaktor des Werkzeugs; Wirkt sich bei Verwendung des Werkzeugs auf die Dauer der Vorgangsposition aus';
comment on column DIRKSPZM32.ISI_RES_FHM."INFO1" is 'Infofeld ';
comment on column DIRKSPZM32.ISI_RES_FHM."INFO2" is 'Infofeld ';
comment on column DIRKSPZM32.ISI_RES_FHM."INFO3" is 'Infofeld ';
comment on column DIRKSPZM32.ISI_RES_FHM."KAPAZITAETSPRUEFUNG" is 'Typ der Kapazitätsprüfung der Ressource 1=keine
2=Belegung+Zeit
5=gesperrt
6=Zeit
';
comment on column DIRKSPZM32.ISI_RES_FHM."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.ISI_RES_FHM."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.ISI_RES_FHM."MASCHINENWECHSEL" is 'Definiert, ob das Werkzeug, während der Blockiertzeit einens Maschinenvorgangs auf anderen Maschinen verplant werden darf um danach für den selben Vorgang weiterverwendet zu werden 0=nein
1=ja
';
comment on column DIRKSPZM32.ISI_RES_FHM."MAX_BELEGUNG" is 'Angabe, zu wie viel Prozent der Pool verfügbar ist (300% entspricht 3 Fertigungshilfsmitteln)';
comment on column DIRKSPZM32.ISI_RES_FHM."MAX_NUTZUNG_ANZAHL" is 'Maximale Anzahl produzierbarer Einheiten bis zur nächsten Wartung';
comment on column DIRKSPZM32.ISI_RES_FHM."MAX_NUTZUNG_ANZAHL_EINHEIT" is 'Einheit auf die sich MaxNutzungAnzahl bezieht';
comment on column DIRKSPZM32.ISI_RES_FHM."MAX_NUTZUNG_DAUER" is 'Maximal Einsatzdauer des Werkzeugs bis zur nächsten Wartung in Minuten';
comment on column DIRKSPZM32.ISI_RES_FHM."NAME" is 'Bezeichnung des Fertigungshilfsmittels';
comment on column DIRKSPZM32.ISI_RES_FHM."RUEST_ZEIT" is 'Zusätzliche Rüstzeit, die bei Verwendung diese Werkzeugs anfällt, sofern umgerüstet werden muss in Minuten';
comment on column DIRKSPZM32.ISI_RES_FHM."SID" is 'SID';



-- sqlcl_snapshot {"hash":"e64db274fe05edf4bcccdfa88025d11c06a8680c","type":"COMMENT","name":"isi_res_fhm","schemaName":"dirkspzm32","sxml":""}