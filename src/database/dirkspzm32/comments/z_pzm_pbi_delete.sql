comment on table Z_PZM_PBI_DELETE is 'Zu löschende Daten im PowerBi';
comment on column Z_PZM_PBI_DELETE."DELETE_DATE" is 'Datum der Löschung';
comment on column Z_PZM_PBI_DELETE."ERR_TEXT" is 'Fehlertext';
comment on column Z_PZM_PBI_DELETE."LNR" is 'Eindeutiger Key in PowerBi';
comment on column Z_PZM_PBI_DELETE."PERS_NR" is 'Personalnummer zur prüfung';
comment on column Z_PZM_PBI_DELETE."STATUS" is 'Status der Übertragung
''N'' Neu - Datensatz löschen
''D'' Deleted - Datensatz ist im DW geloescht und kann auch in dieser tabelle gelöschte werden
''I'' Ignor - Der Datensatz ist beim Löschen zu ignorieren
''V'' Verarbeitung - Datensatz ist aktuell in der Verarbeitung (Soll im DW gelöscht werden)
''E'' Error - Datensatz kann nicht gelöscht werden (Ist nicht vorhanden)
''F'' Fehler - Datensatz ist vorhanden konnte aber nicht gelöscht werden';
comment on column Z_PZM_PBI_DELETE."TABELLE" is 'Tabelle';



-- sqlcl_snapshot {"hash":"76cd4933874aee68fe2bd48fbef2d32a9a3af80b","type":"COMMENT","name":"z_pzm_pbi_delete","schemaName":"dirkspzm32","sxml":""}