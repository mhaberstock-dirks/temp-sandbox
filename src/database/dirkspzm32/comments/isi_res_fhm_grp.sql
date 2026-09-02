comment on table ISI_RES_FHM_GRP is 'Stammdatem Fertigungshilfsmittel Gruppen';
comment on column ISI_RES_FHM_GRP."CREATED_DATE" is 'creation date+time of this dataset';
comment on column ISI_RES_FHM_GRP."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column ISI_RES_FHM_GRP."FHM_GRP" is 'Name der FHM-Gruppe (z.B. Formteilfamilie)';
comment on column ISI_RES_FHM_GRP."FHM_TYP" is 'Typ des FHM';
comment on column ISI_RES_FHM_GRP."FIRMA_NR" is 'Mandant / Firma';
comment on column ISI_RES_FHM_GRP."INFO1" is 'Infofeld ';
comment on column ISI_RES_FHM_GRP."INFO2" is 'Infofeld ';
comment on column ISI_RES_FHM_GRP."INFO3" is 'Infofeld ';
comment on column ISI_RES_FHM_GRP."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column ISI_RES_FHM_GRP."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column ISI_RES_FHM_GRP."PLN_MIT_GRP" is 'FHH Gruppe als Planungsgruppe
0 = Gruppe ist nur eine organisatorische Gruppe.
1 = Gruppe sammelt alle FHM der Gruppe, summiert die Kapa und übergibt dies dem APS als FHM
    Dann dürfen in der Planung nur die Gruppen verwendet werden, auch in den Arbeitsplänen';
comment on column ISI_RES_FHM_GRP."SID" is 'SID';



-- sqlcl_snapshot {"hash":"08af54b2c25426c67c90240add67fd469e85a260","type":"COMMENT","name":"isi_res_fhm_grp","schemaName":"dirkspzm32","sxml":""}