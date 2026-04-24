comment on table dirkspzm32.isi_sid is
    'Datenbanken (System ID Referenz)';

comment on column dirkspzm32.isi_sid.sid is
    'Datenbank ID für Konsolidierung';

comment on column dirkspzm32.isi_sid.sid_akt_host_betriebsart is
    '0=ISI 1=Host';

comment on column dirkspzm32.isi_sid.sid_ext_etiketten_druck is
    'Ist die Funktion für externen Etikettendruck für dieses System freigeschaltet (''F'' -> NICHT freigeschaltet; ''T'' -> freigeschaltet)'
    ;

comment on column dirkspzm32.isi_sid.sid_host_betriebsart_waehlen is
    'Kann ISI Plus zwischen Host und ISI Betrieb Wählen 0= Nein 1..n Hostprogrammnummer';

comment on column dirkspzm32.isi_sid.sid_my_sid is
    'Ist diese System ID von dieser Datenbank';

comment on column dirkspzm32.isi_sid.sid_name is
    'Kompletter Name';

comment on column dirkspzm32.isi_sid.sid_schnittstelle is
    'Name der Schnittstelle zum HOST';

comment on column dirkspzm32.isi_sid.sid_status is
    'T = Test, P = Produktiv, D = Develop';


-- sqlcl_snapshot {"hash":"e185bbc260ca3eee9dad3679f084f3dd6d644428","type":"COMMENT","name":"isi_sid","schemaName":"dirkspzm32","sxml":""}