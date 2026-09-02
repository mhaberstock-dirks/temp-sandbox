comment on table ISI_RES_PROD_TAKT is 'TaktType einer Prod Schicht siehe ISI_RES_SCHICHT_MODELL, ISI_RES_SCHICHT ';
comment on column ISI_RES_PROD_TAKT."NAME" is '[UK] Name des ProduktionsTaks';
comment on column ISI_RES_PROD_TAKT."PROD_TAKT_ID" is '[PK]';
comment on column ISI_RES_PROD_TAKT."STK_PRO_TAKT" is 'Stueckzahl Fertig Pro Takt';
comment on column ISI_RES_PROD_TAKT."TAKT_ZEIT_GUI" is '''S'' = Sekundengenau  ,   ''M'' = Minutengenau R4 Kann Das nicht also nur ''S'' erlau8bt BWe';
comment on column ISI_RES_PROD_TAKT."TAKT_ZEIT_SEK" is 'Zeit für einen Takt in Sekunden';



-- sqlcl_snapshot {"hash":"cfdb364f654a3410f8c9dfcad19320530f91c447","type":"COMMENT","name":"isi_res_prod_takt","schemaName":"dirkspzm32","sxml":""}