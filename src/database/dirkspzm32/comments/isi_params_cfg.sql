comment on table DIRKSPZM32.ISI_PARAMS_CFG is 'verwendete Parameter ';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."BESCHREIBUNG" is 'Beschreibung des Parameters';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."BEZUGSPUNKT" is 'ABSOLUT, Mittellinie , Achsmitte , Aussenkante ';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."EDITOR" is 'MaskEdit, SpinEdit, ComboBox,CheckBox,CheckComboBox, LookupComboBox';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."EINHEIT" is '''mm'',''Grad'',...';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."FIRMA_NR" is 'Firma_Nr';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."FORMAT" is 'Maskierung ';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."GRUPPE" is 'Gruppe des Parameters';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."IST_VARIABLE" is 'T= dieser PArameter ist variabel, F = Dieser Parameter ist konstant';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."LOOKUPLIST" is 'Liste der Nachschlageparameter mit CR/LF getrennt';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."LOOKUPREPORT" is 'LookupReport ';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."MAXVALUE" is 'grösster Wert';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."MINVALUE" is 'kleinster Wert';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."PARAM_ID" is 'Unique ID';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."PARAM_NAME" is 'Kurzname wird in Prod_Params eingetragen';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."PARAM_TABLE" is 'PROZ Params aus Tabelle ';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."PFLICHTEINGABE" is '''T'' Prüfung im Dialog Null verboten,  ''F'' Keine Prüfung';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."QUELLE" is 'HOST = aus Schnittstelle zum Host, DLG = manuelle Dialogeingabe, SCRIPT = Script holt und setzt Daten';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."SID" is 'sid';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."WERT_TYP" is '1=ganze Zahl, 2=realzahl, 3=Datum + Uhrzeit, 4=string  ';
comment on column DIRKSPZM32.ISI_PARAMS_CFG."ZIEL" is 'Zielschnittstelle, an die der Parameter gesendet werden soll (insbesondere für Customizing geeignet)';



-- sqlcl_snapshot {"hash":"bda8ad85d8aaeb681eb23616e6369dd07581c42a","type":"COMMENT","name":"isi_params_cfg","schemaName":"dirkspzm32","sxml":""}