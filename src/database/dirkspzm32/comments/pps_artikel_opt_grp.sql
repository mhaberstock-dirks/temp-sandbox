comment on table dirkspzm32.pps_artikel_opt_grp is
    'Material Optimierungsgruppen';

comment on column dirkspzm32.pps_artikel_opt_grp.artikel_id is
    'Fertig-Produkt ArtikelID aus der Tabelle isi_artikel / Arbeitsgänge aus Arbeitsplänen, welche dieses Material herstellen, können die Optimierungsgruppen des Materials übernehmen.'
    ;

comment on column dirkspzm32.pps_artikel_opt_grp.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_artikel_opt_grp.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_artikel_opt_grp.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_artikel_opt_grp.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_artikel_opt_grp.optimierungsgruppen_id is
    '"ID der Optimierungsgruppe
Wenn ID leer ist, dann gilt keine Optimierungsgruppe (auch nicht die aus dem Materialstamm)"';

comment on column dirkspzm32.pps_artikel_opt_grp.optimierungsgruppen_typ is
    '"gibt an, welche Optimierungen von dieser Gruppe abhängen
Optimierungsgruppentyp
Wert Bezeichnung Beschreibung
1 statisch rüsten Statische Rüstpositionen werden bei gleicher Optimierungsgruppe reduziert.
2 dynamisch rüsten Dynamische Rüstpositionen werden entsprechend der Umrüstmatrix reduziert.
4 parallele Belegung Aufträge werden parallel auf eine Ressource geplant.
jeder Typ darf nur einmal pro Vorgang verwendet werden"';

comment on column dirkspzm32.pps_artikel_opt_grp.optimierungsgruppen_value is
    '"wertmäßige Ausprägung der Optimierungsgruppe
Das Merkmal darf nur entsprechend der Angabe in der Optimierungsgruppe maximal abweichen (Toleranz), damit gleiche Optimierungsgruppen zueinander
als kompatibel gelten. (Bei Kompatibilität würde z.B. die eingestellte Dauer aus der Diagonalen der Rüstmatrix nicht verwendet werden)"'
    ;


-- sqlcl_snapshot {"hash":"8c49bd36df20fac98b9b65604ba3907ef3c7cfc6","type":"COMMENT","name":"pps_artikel_opt_grp","schemaName":"dirkspzm32","sxml":""}