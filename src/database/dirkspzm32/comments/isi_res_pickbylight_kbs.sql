comment on table dirkspzm32.isi_res_pickbylight_kbs is
    'Status und Bearbeitungstabelle aus den Geräten bzw. der Applikation';

comment on column dirkspzm32.isi_res_pickbylight_kbs.controller_id is
    '"PickTerm Flexible Geräte-Id, z.B.
8zQY"';

comment on column dirkspzm32.isi_res_pickbylight_kbs.controller_ip is
    'TCP/IP Adresse des Controllers';

comment on column dirkspzm32.isi_res_pickbylight_kbs.controller_port is
    'PORT des Controllers';

comment on column dirkspzm32.isi_res_pickbylight_kbs.device_driver is
    'PickTerm Flexible Geräte-Treiber, SUB2, PT-3, 3N-4';

comment on column dirkspzm32.isi_res_pickbylight_kbs.device_id is
    'PickTerm Flexible Geräte-Id, z.B.
8zQY';

comment on column dirkspzm32.isi_res_pickbylight_kbs.enabled is
    'Aktiv T/F True/False';

comment on column dirkspzm32.isi_res_pickbylight_kbs.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_res_pickbylight_kbs.in_changed is
    'Zeitstempel der Pick2Light Service Logic, wann Input Daten empfangen wurden, von PickTermFlexible ? ISIPlus';

comment on column dirkspzm32.isi_res_pickbylight_kbs.in_data_long is
    'Input Daten, die im Kontext der Pick2Light Service Logic gesetzt werden: Zähler = Zähler - 2';

comment on column dirkspzm32.isi_res_pickbylight_kbs.in_key1 is
    '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';

comment on column dirkspzm32.isi_res_pickbylight_kbs.in_key2 is
    '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';

comment on column dirkspzm32.isi_res_pickbylight_kbs.in_key3 is
    '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';

comment on column dirkspzm32.isi_res_pickbylight_kbs.in_key4 is
    '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_changed is
    'Zeitstempel von der PL oder DB Logik, die Output daten senden möchte,  von ISIPlus ? PickTermFlexible';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_display is
    'Data to be displayed, all ASCII Characters if they can be shown on the 7-Segment';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_display_mode is
    'Mode of each digit.
‘0’: The digit is switched off.
‘1’: The digit is switched on.
‘2’: The digit is blinking.
‘3’: The digit is blinking with the opposite phase as a digit in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_dp1 is
    'Mode of the decimal point 1.
‘0’: The dot is switched off.
‘1’: The dot is switched on.
‘2’: The dot is blinking.
‘3’: The dot is blinking with the opposite phase as a dot in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_dp2 is
    'Mode of the decimal point 2.
‘0’: The dot is switched off.
‘1’: The dot is switched on.
‘2’: The dot is blinking.
‘3’: The dot is blinking with the opposite phase as a dot in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_led1_blue is
    'Mode of Upper LED blue.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_led1_green is
    'Mode of Upper LED green.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_led1_red is
    'Mode of Upper LED red.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_led2_blue is
    'Mode of Lower LED blue.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_led2_green is
    'Mode of Lower LED green.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.out_led2_red is
    'Mode of Lower LED red.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';

comment on column dirkspzm32.isi_res_pickbylight_kbs.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"9ac2261fb0cbbb6a4afb4403e092e1131141af8b","type":"COMMENT","name":"isi_res_pickbylight_kbs","schemaName":"dirkspzm32","sxml":""}