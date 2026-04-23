comment on table dirkspzm32.isi_currency is
    'Währungen';

comment on column dirkspzm32.isi_currency.base_currency is
    'Basis Waehrung EUR, USD, ... Wenn diese NULL ist, dann ist die Heimatwährung die Basis';

comment on column dirkspzm32.isi_currency.bezeichnung1 is
    'Bezeichnung 1';

comment on column dirkspzm32.isi_currency.currency is
    'Waehrung EUR, USD, ...';

comment on column dirkspzm32.isi_currency.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_currency.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_currency.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.isi_currency.valide_date is
    'Gültig ab';

comment on column dirkspzm32.isi_currency.wechselkurs is
    'Wechselkurs';


-- sqlcl_snapshot {"hash":"945676137dcc92ea9a4704d105928881778f6fc8","type":"COMMENT","name":"isi_currency","schemaName":"dirkspzm32","sxml":""}