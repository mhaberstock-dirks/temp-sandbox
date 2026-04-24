comment on table dirkspzm32.isi_res_prod_takt is
    'TaktType einer Prod Schicht siehe ISI_RES_SCHICHT_MODELL, ISI_RES_SCHICHT ';

comment on column dirkspzm32.isi_res_prod_takt.name is
    '[UK] Name des ProduktionsTaks';

comment on column dirkspzm32.isi_res_prod_takt.prod_takt_id is
    '[PK]';

comment on column dirkspzm32.isi_res_prod_takt.stk_pro_takt is
    'Stueckzahl Fertig Pro Takt';

comment on column dirkspzm32.isi_res_prod_takt.takt_zeit_gui is
    '''S'' = Sekundengenau  ,   ''M'' = Minutengenau R4 Kann Das nicht also nur ''S'' erlau8bt BWe';

comment on column dirkspzm32.isi_res_prod_takt.takt_zeit_sek is
    'Zeit für einen Takt in Sekunden';


-- sqlcl_snapshot {"hash":"6fda06889f91717f84c075b1a66a985bfc6b8874","type":"COMMENT","name":"isi_res_prod_takt","schemaName":"dirkspzm32","sxml":""}