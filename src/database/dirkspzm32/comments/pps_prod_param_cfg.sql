comment on table PPS_PROD_PARAM_CFG is 'verwendete Prod. Parameter ';
comment on column PPS_PROD_PARAM_CFG."BESCHREIBUNG" is 'Beschreibung des Parameters';
comment on column PPS_PROD_PARAM_CFG."BEZUGSPUNKT" is 'ABSOLUT, Mittellinie , Achsmitte , Aussenkante ';
comment on column PPS_PROD_PARAM_CFG."CREATED_DATE" is 'creation date+time of this dataset';
comment on column PPS_PROD_PARAM_CFG."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column PPS_PROD_PARAM_CFG."EDITOR" is 'MaskEdit, SpinEdit, ComboBox,CheckBox,CheckComboBox, LookupComboBox';
comment on column PPS_PROD_PARAM_CFG."EINHEIT" is '''mm'',''Grad'',...';
comment on column PPS_PROD_PARAM_CFG."FIRMA_NR" is 'Firma_Nr';
comment on column PPS_PROD_PARAM_CFG."FORMAT" is 'Maskierung ';
comment on column PPS_PROD_PARAM_CFG."GRUPPE" is 'Gruppe des Parameters';
comment on column PPS_PROD_PARAM_CFG."IST_VARIABLE" is 'T= dieser PArameter ist variabel, F = Dieser Parameter ist konstant';
comment on column PPS_PROD_PARAM_CFG."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column PPS_PROD_PARAM_CFG."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column PPS_PROD_PARAM_CFG."LOOKUPLIST" is 'Liste der Nachschlageparameter mit CR/LF getrennt';
comment on column PPS_PROD_PARAM_CFG."LOOKUPREPORT" is 'LookupReport ';
comment on column PPS_PROD_PARAM_CFG."MAXVALUE" is 'grösster Wert';
comment on column PPS_PROD_PARAM_CFG."MINVALUE" is 'kleinster Wert';
comment on column PPS_PROD_PARAM_CFG."PARAM_ID" is 'Unique ID';
comment on column PPS_PROD_PARAM_CFG."PARAM_NAME" is 'Kurzname wird in Prod_Params eingetragen';
comment on column PPS_PROD_PARAM_CFG."QUELLE" is 'HOST = aus Schnittstelle zum Host, DLG = manuelle Dialogeingabe, SCRIPT = Script holt und setzt Daten';
comment on column PPS_PROD_PARAM_CFG."SID" is 'sid';
comment on column PPS_PROD_PARAM_CFG."WERT_TYP" is '1=ganze Zahl, 2=realzahl, 3=Datum + Uhrzeit, 4=string  ';
comment on column PPS_PROD_PARAM_CFG."ZIEL" is 'Zielschnittstelle, an die der Parameter gesendet werden soll (insbesondere für Customizing geeignet)';



-- sqlcl_snapshot {"hash":"d395c2bef64286475b7091d8f829b3e41dda5fa4","type":"COMMENT","name":"pps_prod_param_cfg","schemaName":"dirkspzm32","sxml":""}