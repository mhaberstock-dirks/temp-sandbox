comment on table DIRKSPZM32.PPS_ARTIKEL_OPT_GRP is 'Material Optimierungsgruppen';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."ARTIKEL_ID" is 'Fertig-Produkt ArtikelID aus der Tabelle isi_artikel / Arbeitsgänge aus Arbeitsplänen, welche dieses Material herstellen, können die Optimierungsgruppen des Materials übernehmen.';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."CREATED_DATE" is 'creation date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."CREATED_LOGIN_ID" is 'login ID of the user creating this dataset';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."LAST_CHANGE_DATE" is 'change date+time of this dataset';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."LAST_CHANGE_LOGIN_ID" is 'login ID of the user changing this dataset';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."OPTIMIERUNGSGRUPPEN_ID" is '"ID der Optimierungsgruppe
Wenn ID leer ist, dann gilt keine Optimierungsgruppe (auch nicht die aus dem Materialstamm)"';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."OPTIMIERUNGSGRUPPEN_TYP" is '"gibt an, welche Optimierungen von dieser Gruppe abhängen
Optimierungsgruppentyp
Wert Bezeichnung Beschreibung
1 statisch rüsten Statische Rüstpositionen werden bei gleicher Optimierungsgruppe reduziert.
2 dynamisch rüsten Dynamische Rüstpositionen werden entsprechend der Umrüstmatrix reduziert.
4 parallele Belegung Aufträge werden parallel auf eine Ressource geplant.
jeder Typ darf nur einmal pro Vorgang verwendet werden"';
comment on column DIRKSPZM32.PPS_ARTIKEL_OPT_GRP."OPTIMIERUNGSGRUPPEN_VALUE" is '"wertmäßige Ausprägung der Optimierungsgruppe
Das Merkmal darf nur entsprechend der Angabe in der Optimierungsgruppe maximal abweichen (Toleranz), damit gleiche Optimierungsgruppen zueinander
als kompatibel gelten. (Bei Kompatibilität würde z.B. die eingestellte Dauer aus der Diagonalen der Rüstmatrix nicht verwendet werden)"';



-- sqlcl_snapshot {"hash":"3ae434ecebef947c1c2c9449b04e55b09d76ff92","type":"COMMENT","name":"pps_artikel_opt_grp","schemaName":"dirkspzm32","sxml":""}