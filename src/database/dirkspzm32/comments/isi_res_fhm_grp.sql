comment on table dirkspzm32.isi_res_fhm_grp is
    'Stammdatem Fertigungshilfsmittel Gruppen';

comment on column dirkspzm32.isi_res_fhm_grp.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_fhm_grp.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.isi_res_fhm_grp.fhm_grp is
    'Name der FHM-Gruppe (z.B. Formteilfamilie)';

comment on column dirkspzm32.isi_res_fhm_grp.fhm_typ is
    'Typ des FHM';

comment on column dirkspzm32.isi_res_fhm_grp.firma_nr is
    'Mandant / Firma';

comment on column dirkspzm32.isi_res_fhm_grp.info1 is
    'Infofeld ';

comment on column dirkspzm32.isi_res_fhm_grp.info2 is
    'Infofeld ';

comment on column dirkspzm32.isi_res_fhm_grp.info3 is
    'Infofeld ';

comment on column dirkspzm32.isi_res_fhm_grp.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_fhm_grp.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.isi_res_fhm_grp.pln_mit_grp is
    'FHH Gruppe als Planungsgruppe
0 = Gruppe ist nur eine organisatorische Gruppe.
1 = Gruppe sammelt alle FHM der Gruppe, summiert die Kapa und übergibt dies dem APS als FHM
    Dann dürfen in der Planung nur die Gruppen verwendet werden, auch in den Arbeitsplänen';

comment on column dirkspzm32.isi_res_fhm_grp.sid is
    'SID';


-- sqlcl_snapshot {"hash":"a5a92dd77bae2a2097a93e5b54e17c865a383b3a","type":"COMMENT","name":"isi_res_fhm_grp","schemaName":"dirkspzm32","sxml":""}