comment on table ISI_SID is 'Datenbanken (System ID Referenz)';
comment on column ISI_SID."SID" is 'Datenbank ID für Konsolidierung';
comment on column ISI_SID."SID_AKT_HOST_BETRIEBSART" is '0=ISI 1=Host';
comment on column ISI_SID."SID_EXT_ETIKETTEN_DRUCK" is 'Ist die Funktion für externen Etikettendruck für dieses System freigeschaltet (''F'' -> NICHT freigeschaltet; ''T'' -> freigeschaltet)';
comment on column ISI_SID."SID_HOST_BETRIEBSART_WAEHLEN" is 'Kann ISI Plus zwischen Host und ISI Betrieb Wählen 0= Nein 1..n Hostprogrammnummer';
comment on column ISI_SID."SID_MY_SID" is 'Ist diese System ID von dieser Datenbank';
comment on column ISI_SID."SID_NAME" is 'Kompletter Name';
comment on column ISI_SID."SID_SCHNITTSTELLE" is 'Name der Schnittstelle zum HOST';
comment on column ISI_SID."SID_STATUS" is 'T = Test, P = Produktiv, D = Develop';



-- sqlcl_snapshot {"hash":"fa082194f985c561f23bece5e9c147a4d8d12ed7","type":"COMMENT","name":"isi_sid","schemaName":"dirkspzm32","sxml":""}