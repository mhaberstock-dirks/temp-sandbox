comment on table ISI_CUSTOM_PARAMS_CFG is 'verwendete Parameter ';
comment on column ISI_CUSTOM_PARAMS_CFG."BESCHREIBUNG" is 'Beschreibung des Parameters';
comment on column ISI_CUSTOM_PARAMS_CFG."BEZUGSPUNKT" is 'ABSOLUT, Mittellinie , Achsmitte , Aussenkante ';
comment on column ISI_CUSTOM_PARAMS_CFG."EDITOR" is 'MaskEdit, SpinEdit, ComboBox,CheckBox,CheckComboBox, LookupComboBox';
comment on column ISI_CUSTOM_PARAMS_CFG."EINHEIT" is '''mm'',''Grad'',...';
comment on column ISI_CUSTOM_PARAMS_CFG."FIRMA_NR" is 'Firma_Nr';
comment on column ISI_CUSTOM_PARAMS_CFG."FORMAT" is 'Maskierung ';
comment on column ISI_CUSTOM_PARAMS_CFG."GRUPPE" is 'Gruppe des Parameters';
comment on column ISI_CUSTOM_PARAMS_CFG."IST_VARIABLE" is 'T= dieser PArameter ist variabel, F = Dieser Parameter ist konstant';
comment on column ISI_CUSTOM_PARAMS_CFG."LOOKUPLIST" is 'Liste der Nachschlageparameter mit CR/LF getrennt';
comment on column ISI_CUSTOM_PARAMS_CFG."LOOKUPREPORT" is 'LookupReport ';
comment on column ISI_CUSTOM_PARAMS_CFG."MAXVALUE" is 'grösster Wert';
comment on column ISI_CUSTOM_PARAMS_CFG."MINVALUE" is 'kleinster Wert';
comment on column ISI_CUSTOM_PARAMS_CFG."PARAM_ID" is 'Unique ID';
comment on column ISI_CUSTOM_PARAMS_CFG."PARAM_NAME" is 'Kurzname wird in Prod_Params eingetragen';
comment on column ISI_CUSTOM_PARAMS_CFG."QUELLE" is 'HOST = aus Schnittstelle zum Host, DLG = manuelle Dialogeingabe, SCRIPT = Script holt und setzt Daten';
comment on column ISI_CUSTOM_PARAMS_CFG."SID" is 'sid';
comment on column ISI_CUSTOM_PARAMS_CFG."WERT_TYP" is '1=ganze Zahl, 2=realzahl, 3=Datum + Uhrzeit, 4=string  ';
comment on column ISI_CUSTOM_PARAMS_CFG."ZIEL" is 'Zielschnittstelle, an die der Parameter gesendet werden soll (insbesondere für Customizing geeignet)';



-- sqlcl_snapshot {"hash":"80e57ad6d86802e4c54c5e144f2db4da97c53b2b","type":"COMMENT","name":"isi_custom_params_cfg","schemaName":"dirkspzm32","sxml":""}