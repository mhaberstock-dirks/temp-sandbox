comment on table dirkspzm32.z_pzm_pbi_delete is
    'Zu löschende Daten im PowerBi';

comment on column dirkspzm32.z_pzm_pbi_delete.delete_date is
    'Datum der Löschung';

comment on column dirkspzm32.z_pzm_pbi_delete.err_text is
    'Fehlertext';

comment on column dirkspzm32.z_pzm_pbi_delete.lnr is
    'Eindeutiger Key in PowerBi';

comment on column dirkspzm32.z_pzm_pbi_delete.pers_nr is
    'Personalnummer zur prüfung';

comment on column dirkspzm32.z_pzm_pbi_delete.status is
    'Status der Übertragung
''N'' Neu - Datensatz löschen
''D'' Deleted - Datensatz ist im DW geloescht und kann auch in dieser tabelle gelöschte werden
''I'' Ignor - Der Datensatz ist beim Löschen zu ignorieren
''V'' Verarbeitung - Datensatz ist aktuell in der Verarbeitung (Soll im DW gelöscht werden)
''E'' Error - Datensatz kann nicht gelöscht werden (Ist nicht vorhanden)
''F'' Fehler - Datensatz ist vorhanden konnte aber nicht gelöscht werden';

comment on column dirkspzm32.z_pzm_pbi_delete.tabelle is
    'Tabelle';


-- sqlcl_snapshot {"hash":"e4758ff2a72efa0320702a2213e662bbb7255250","type":"COMMENT","name":"z_pzm_pbi_delete","schemaName":"dirkspzm32","sxml":""}