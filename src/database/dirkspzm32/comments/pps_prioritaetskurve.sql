comment on table dirkspzm32.pps_prioritaetskurve is
    'Verspäätungskostensätze';

comment on column dirkspzm32.pps_prioritaetskurve.bezeichnung is
    'Bezeichnung der Prioritätskurve';

comment on column dirkspzm32.pps_prioritaetskurve.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_prioritaetskurve.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.pps_prioritaetskurve.firma_nr is
    'Mandanten-Nr. des Unternehmens';

comment on column dirkspzm32.pps_prioritaetskurve.intervall_kosten_absolut is
    '[Min] Gibt die Zeitspanne für dei Berechnung der absoluten Verspätungskosten an (Wenn erreicht werden die absoluten Kosten aufgeschlagen). Def=1Tag=1440'
    ;

comment on column dirkspzm32.pps_prioritaetskurve.intervall_kosten_begin is
    '[Min] Gibt die Zeitspanne an, ab wann die Verspätungskosten berechnet werden Def 0=Sofot';

comment on column dirkspzm32.pps_prioritaetskurve.kosten_absolit is
    'Gibt den Betrag an, der zus. zu den relativen Kosten dazugerechnet wird';

comment on column dirkspzm32.pps_prioritaetskurve.kosten_relativ is
    'Gibt einen Prozentsatz zur Errechnung der relativen Kosten, die bei einer Verspätung anfallen, an';

comment on column dirkspzm32.pps_prioritaetskurve.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_prioritaetskurve.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.pps_prioritaetskurve.prio_id is
    'Nummer der nutzerdefinierten Priorität. Einer Priorität sind ein oder mehrere Verspätungskostensätze zugeordnet';


-- sqlcl_snapshot {"hash":"28610fa80703d9e1cdd418dd6847505c7c441a2a","type":"COMMENT","name":"pps_prioritaetskurve","schemaName":"dirkspzm32","sxml":""}