comment on table dirkspzm32.isi_res_personal_bedarf is
    'Stores the current configuration for resource pan data';

comment on column dirkspzm32.isi_res_personal_bedarf.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.isi_res_personal_bedarf.created_login_id is
    'login id of the user creating this dataset';

comment on column dirkspzm32.isi_res_personal_bedarf.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.isi_res_personal_bedarf.last_change_login_id is
    'login id of the user changing this dataset';

comment on column dirkspzm32.isi_res_personal_bedarf.res_id is
    'resource id of the magazine';

comment on column dirkspzm32.isi_res_personal_bedarf.res_personal_bedarf_anz is
    'Anzahl der Personen, die an diesem Arbeitsplatz für die jeweilige Vorgangsposition benötigt werden';

comment on column dirkspzm32.isi_res_personal_bedarf.res_personal_bedarf_anz_max is
    'Hinweis: Eigenschaft wird noch nicht ausgewertet
maximale Anzahl gleichzeitiger Bediener
0 = inaktiv
-1 = unbegrenzt';

comment on column dirkspzm32.isi_res_personal_bedarf.res_personal_bedarf_grp is
    'eindeutige, frei wählbare ID des benötigten Personalbedarfs (Personalbedarfsgruppe), z.B. ''1'', ''Packer'' oder ''Schweißer''. Die Gruppennummer darf
nicht leer sein!
Diese wird benötigt, um unterschiedlichen Personalbedarf unterscheiden zu können (nicht mit ID der Personalgruppe verwechseln!)';

comment on column dirkspzm32.isi_res_personal_bedarf.res_personal_proz_ausl is
    'prozentuale Auslastung der Bediener';

comment on column dirkspzm32.isi_res_personal_bedarf.res_personal_wechsel is
    'Einstellungen zum Personalwechsel
Personalwechseltyp
Wert Bezeichnung Beschreibung
0 ständiger Wechsel
erlaubt
Mehrschichtbearbeitung ist zugelassen, d.h. dass ein Mitarbeiter aus z.B. einer anderen Schicht die
angemeldete Tätigkeit auf diesem Arbeitsplatz weiterbearbeiten darf
1 kein Wechsel in
Vorgangsposition
erlaubt
Personalwechsel innerhalb von Vorgangspositionen ist nicht erlaubt (keine Mehrschichtbearbeitung), d.h.
der/die gleicheMitarbeiter bearbeiten komplett eine Vorgangsposition
2 kein Wechsel in
Vorgang erlaubt
Personalwechsel innerhalb eines kompletten Vorgangs ist nicht erlaubt, d.h. exakt der/die gleicheMitarbeiter
werden für den kompletten Vorgang verwendet (entspricht Bedienzwang)
Achtung: Wird dieser Typ gewählt, dann muss activity_type = 0 (alle) sein';

comment on column dirkspzm32.isi_res_personal_bedarf.vorgangsqualifikation is
    'Vorgangsqualifikation, die das Personal benötigt, um die jeweilige Vorgangsposition bearbeiten zu können';

comment on column dirkspzm32.isi_res_personal_bedarf.vorgangstyp is
    'Für welchen Vorgangspositionstyp gilt der angegeben Personalbedarf
0 = alle (Personalbedarf gilt automatisch für alle Positionen eines Vorgangs)
1 = fertigen
2 = rüsten';


-- sqlcl_snapshot {"hash":"321299ec500c60fa9663227556671c49781302f9","type":"COMMENT","name":"isi_res_personal_bedarf","schemaName":"dirkspzm32","sxml":""}