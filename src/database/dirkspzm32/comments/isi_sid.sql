comment on table DIRKSPZM32.ISI_SID is 'Datenbanken (System ID Referenz)';
comment on column DIRKSPZM32.ISI_SID."SID" is 'Datenbank ID für Konsolidierung';
comment on column DIRKSPZM32.ISI_SID."SID_AKT_HOST_BETRIEBSART" is '0=ISI 1=Host';
comment on column DIRKSPZM32.ISI_SID."SID_EXT_ETIKETTEN_DRUCK" is 'Ist die Funktion für externen Etikettendruck für dieses System freigeschaltet (''F'' -> NICHT freigeschaltet; ''T'' -> freigeschaltet)';
comment on column DIRKSPZM32.ISI_SID."SID_HOST_BETRIEBSART_WAEHLEN" is 'Kann ISI Plus zwischen Host und ISI Betrieb Wählen 0= Nein 1..n Hostprogrammnummer';
comment on column DIRKSPZM32.ISI_SID."SID_MY_SID" is 'Ist diese System ID von dieser Datenbank';
comment on column DIRKSPZM32.ISI_SID."SID_NAME" is 'Kompletter Name';
comment on column DIRKSPZM32.ISI_SID."SID_SCHNITTSTELLE" is 'Name der Schnittstelle zum HOST';
comment on column DIRKSPZM32.ISI_SID."SID_STATUS" is 'T = Test, P = Produktiv, D = Develop';



-- sqlcl_snapshot {"hash":"82c2dfdf0ada295f3e3b4b6ca63a0288377a74ca","type":"COMMENT","name":"isi_sid","schemaName":"dirkspzm32","sxml":""}