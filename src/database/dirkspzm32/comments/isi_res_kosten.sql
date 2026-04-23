comment on table dirkspzm32.isi_res_kosten is
    'Stores the current configuration for resource pan data';

comment on column dirkspzm32.isi_res_kosten.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_kosten.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.isi_res_kosten.fertigen is
    '[€/h] -> Kosten für die Bearbeitung auf der Maschine';

comment on column dirkspzm32.isi_res_kosten.gilt_ab is
    'Datum, ab wann dieses Material mit dem Arbeitsplan hergestellt werden kann';

comment on column dirkspzm32.isi_res_kosten.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_kosten.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.isi_res_kosten.res_id is
    'resource id of the magazine';

comment on column dirkspzm32.isi_res_kosten.ruesten is
    '[€/h] -> Kosten für die Rüstung der Maschine';

comment on column dirkspzm32.isi_res_kosten.stillstand is
    '[€/h] -> Stillstandskosten des Arbeitsplatzes';


-- sqlcl_snapshot {"hash":"86d0a333833456317c99ded83287a4cec46e2759","type":"COMMENT","name":"isi_res_kosten","schemaName":"dirkspzm32","sxml":""}