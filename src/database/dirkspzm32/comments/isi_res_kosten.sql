comment on table ISI_RES_KOSTEN is 'Stores the current configuration for resource pan data';
comment on column ISI_RES_KOSTEN."CREATED_DATE" is 'creation date+time of this dataset';
comment on column ISI_RES_KOSTEN."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column ISI_RES_KOSTEN."FERTIGEN" is '[€/h] -> Kosten für die Bearbeitung auf der Maschine';
comment on column ISI_RES_KOSTEN."GILT_AB" is 'Datum, ab wann dieses Material mit dem Arbeitsplan hergestellt werden kann';
comment on column ISI_RES_KOSTEN."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column ISI_RES_KOSTEN."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column ISI_RES_KOSTEN."RES_ID" is 'resource id of the magazine';
comment on column ISI_RES_KOSTEN."RUESTEN" is '[€/h] -> Kosten für die Rüstung der Maschine';
comment on column ISI_RES_KOSTEN."STILLSTAND" is '[€/h] -> Stillstandskosten des Arbeitsplatzes';



-- sqlcl_snapshot {"hash":"083ffd9afde73e5dcffa9e24c0cce0c5d29e86e1","type":"COMMENT","name":"isi_res_kosten","schemaName":"dirkspzm32","sxml":""}