comment on table DIRKSPZM32.PPS_PRIORITAETSKURVE is 'Verspäätungskostensätze';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."BEZEICHNUNG" is 'Bezeichnung der Prioritätskurve';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."FIRMA_NR" is 'Mandanten-Nr. des Unternehmens';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."INTERVALL_KOSTEN_ABSOLUT" is '[Min] Gibt die Zeitspanne für dei Berechnung der absoluten Verspätungskosten an (Wenn erreicht werden die absoluten Kosten aufgeschlagen). Def=1Tag=1440';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."INTERVALL_KOSTEN_BEGIN" is '[Min] Gibt die Zeitspanne an, ab wann die Verspätungskosten berechnet werden Def 0=Sofot';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."KOSTEN_ABSOLIT" is 'Gibt den Betrag an, der zus. zu den relativen Kosten dazugerechnet wird';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."KOSTEN_RELATIV" is 'Gibt einen Prozentsatz zur Errechnung der relativen Kosten, die bei einer Verspätung anfallen, an';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column DIRKSPZM32.PPS_PRIORITAETSKURVE."PRIO_ID" is 'Nummer der nutzerdefinierten Priorität. Einer Priorität sind ein oder mehrere Verspätungskostensätze zugeordnet';



-- sqlcl_snapshot {"hash":"b6f3e883c68be83b3174e19883104a9f66f26de5","type":"COMMENT","name":"pps_prioritaetskurve","schemaName":"dirkspzm32","sxml":""}