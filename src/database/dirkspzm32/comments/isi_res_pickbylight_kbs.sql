comment on table DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS is 'Status und Bearbeitungstabelle aus den Geräten bzw. der Applikation';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."CONTROLLER_ID" is '"PickTerm Flexible Geräte-Id, z.B.
8zQY"';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."CONTROLLER_IP" is 'TCP/IP Adresse des Controllers';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."CONTROLLER_PORT" is 'PORT des Controllers';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."DEVICE_DRIVER" is 'PickTerm Flexible Geräte-Treiber, SUB2, PT-3, 3N-4';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."DEVICE_ID" is 'PickTerm Flexible Geräte-Id, z.B.
8zQY';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."ENABLED" is 'Aktiv T/F True/False';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."IN_CHANGED" is 'Zeitstempel der Pick2Light Service Logic, wann Input Daten empfangen wurden, von PickTermFlexible ? ISIPlus';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."IN_DATA_LONG" is 'Input Daten, die im Kontext der Pick2Light Service Logic gesetzt werden: Zähler = Zähler - 2';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."IN_KEY1" is '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."IN_KEY2" is '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."IN_KEY3" is '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."IN_KEY4" is '0 = Taste wurde nicht gedrückt, 1 = Taste wurde gedrückt';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_CHANGED" is 'Zeitstempel von der PL oder DB Logik, die Output daten senden möchte,  von ISIPlus ? PickTermFlexible';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_DISPLAY" is 'Data to be displayed, all ASCII Characters if they can be shown on the 7-Segment';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_DISPLAY_MODE" is 'Mode of each digit.
‘0’: The digit is switched off.
‘1’: The digit is switched on.
‘2’: The digit is blinking.
‘3’: The digit is blinking with the opposite phase as a digit in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_DP1" is 'Mode of the decimal point 1.
‘0’: The dot is switched off.
‘1’: The dot is switched on.
‘2’: The dot is blinking.
‘3’: The dot is blinking with the opposite phase as a dot in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_DP2" is 'Mode of the decimal point 2.
‘0’: The dot is switched off.
‘1’: The dot is switched on.
‘2’: The dot is blinking.
‘3’: The dot is blinking with the opposite phase as a dot in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_LED1_BLUE" is 'Mode of Upper LED blue.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_LED1_GREEN" is 'Mode of Upper LED green.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_LED1_RED" is 'Mode of Upper LED red.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_LED2_BLUE" is 'Mode of Lower LED blue.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_LED2_GREEN" is 'Mode of Lower LED green.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."OUT_LED2_RED" is 'Mode of Lower LED red.
‘0’: The LED is switched off.
‘1’: The LED is switched on.
‘2’: The LED is blinking.
‘3’: The LED is blinking with the opposite phase as a LED in mode ‘2’.';
comment on column DIRKSPZM32.ISI_RES_PICKBYLIGHT_KBS."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"caf0b188c56619dc1a41af946fc02c5794bc5e21","type":"COMMENT","name":"isi_res_pickbylight_kbs","schemaName":"dirkspzm32","sxml":""}