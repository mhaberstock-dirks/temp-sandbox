comment on table PPS_PRIORITAETSKURVE is 'Verspäätungskostensätze';
comment on column PPS_PRIORITAETSKURVE."BEZEICHNUNG" is 'Bezeichnung der Prioritätskurve';
comment on column PPS_PRIORITAETSKURVE."CREATED_DATE" is 'creation date+time of this dataset';
comment on column PPS_PRIORITAETSKURVE."CREATED_LOGIN_ID" is 'login id of the user creating this dataset';
comment on column PPS_PRIORITAETSKURVE."FIRMA_NR" is 'Mandanten-Nr. des Unternehmens';
comment on column PPS_PRIORITAETSKURVE."INTERVALL_KOSTEN_ABSOLUT" is '[Min] Gibt die Zeitspanne für dei Berechnung der absoluten Verspätungskosten an (Wenn erreicht werden die absoluten Kosten aufgeschlagen). Def=1Tag=1440';
comment on column PPS_PRIORITAETSKURVE."INTERVALL_KOSTEN_BEGIN" is '[Min] Gibt die Zeitspanne an, ab wann die Verspätungskosten berechnet werden Def 0=Sofot';
comment on column PPS_PRIORITAETSKURVE."KOSTEN_ABSOLIT" is 'Gibt den Betrag an, der zus. zu den relativen Kosten dazugerechnet wird';
comment on column PPS_PRIORITAETSKURVE."KOSTEN_RELATIV" is 'Gibt einen Prozentsatz zur Errechnung der relativen Kosten, die bei einer Verspätung anfallen, an';
comment on column PPS_PRIORITAETSKURVE."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column PPS_PRIORITAETSKURVE."LAST_CHANGE_LOGIN_ID" is 'login id of the user changing this dataset';
comment on column PPS_PRIORITAETSKURVE."PRIO_ID" is 'Nummer der nutzerdefinierten Priorität. Einer Priorität sind ein oder mehrere Verspätungskostensätze zugeordnet';



-- sqlcl_snapshot {"hash":"5de7a8a8bb6fc82b142f8e6afcda7e0c595b81ad","type":"COMMENT","name":"pps_prioritaetskurve","schemaName":"dirkspzm32","sxml":""}