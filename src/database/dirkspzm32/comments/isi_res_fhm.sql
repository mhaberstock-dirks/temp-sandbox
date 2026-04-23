comment on table dirkspzm32.isi_res_fhm is
    'Stammdatem Fertigungshilfsmittel';

comment on column dirkspzm32.isi_res_fhm.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_fhm.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.isi_res_fhm.dyn_gen is
    'Dynamisch generiert T ja oder F Nein D beim nächsten Prüfen löschen';

comment on column dirkspzm32.isi_res_fhm.fhm is
    'Fertigungshilsmittel';

comment on column dirkspzm32.isi_res_fhm.fhm_grp is
    'Name der FHM-Gruppe (z.B. Formteilfamilie)';

comment on column dirkspzm32.isi_res_fhm.firma_nr is
    'Mandant / Firma';

comment on column dirkspzm32.isi_res_fhm.geschw_faktor_fert is
    'Geschwindigkeitsfaktor des Werkzeugs; Wirkt sich bei Verwendung des Werkzeugs auf die Dauer der Vorgangsposition aus';

comment on column dirkspzm32.isi_res_fhm.info1 is
    'Infofeld ';

comment on column dirkspzm32.isi_res_fhm.info2 is
    'Infofeld ';

comment on column dirkspzm32.isi_res_fhm.info3 is
    'Infofeld ';

comment on column dirkspzm32.isi_res_fhm.kapazitaetspruefung is
    'Typ der Kapazitätsprüfung der Ressource 1=keine
2=Belegung+Zeit
5=gesperrt
6=Zeit
';

comment on column dirkspzm32.isi_res_fhm.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_fhm.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.isi_res_fhm.maschinenwechsel is
    'Definiert, ob das Werkzeug, während der Blockiertzeit einens Maschinenvorgangs auf anderen Maschinen verplant werden darf um danach für den selben Vorgang weiterverwendet zu werden 0=nein
1=ja
';

comment on column dirkspzm32.isi_res_fhm.max_belegung is
    'Angabe, zu wie viel Prozent der Pool verfügbar ist (300% entspricht 3 Fertigungshilfsmitteln)';

comment on column dirkspzm32.isi_res_fhm.max_nutzung_anzahl is
    'Maximale Anzahl produzierbarer Einheiten bis zur nächsten Wartung';

comment on column dirkspzm32.isi_res_fhm.max_nutzung_anzahl_einheit is
    'Einheit auf die sich MaxNutzungAnzahl bezieht';

comment on column dirkspzm32.isi_res_fhm.max_nutzung_dauer is
    'Maximal Einsatzdauer des Werkzeugs bis zur nächsten Wartung in Minuten';

comment on column dirkspzm32.isi_res_fhm.name is
    'Bezeichnung des Fertigungshilfsmittels';

comment on column dirkspzm32.isi_res_fhm.ruest_zeit is
    'Zusätzliche Rüstzeit, die bei Verwendung diese Werkzeugs anfällt, sofern umgerüstet werden muss in Minuten';

comment on column dirkspzm32.isi_res_fhm.sid is
    'SID';


-- sqlcl_snapshot {"hash":"4c76ed4be8da7d78810095052c5ba1604bde5fb6","type":"COMMENT","name":"isi_res_fhm","schemaName":"dirkspzm32","sxml":""}