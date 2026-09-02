comment on column REP_SQL_PARAMETER."DLG_CAPTION" is 'Anzeige Text im Parameingabedialog';
comment on column REP_SQL_PARAMETER."DLG_GRUPPE_NR" is 'Gruppe nummer für zusammengehörigen von bis Eingaben';
comment on column REP_SQL_PARAMETER."DLG_INPUT_CHECK" is '0 = Keine Eingabe notwendig, 1= mind. ein Parameter in Gruppe gesetzt  2=Zwangseingabe';
comment on column REP_SQL_PARAMETER."DLG_SPALTE_NR" is 'Anzeige Dialog in Spalte 1..max 3';
comment on column REP_SQL_PARAMETER."LOOKUP_REP_NAME" is 'Name der Nachschlage SQL für diesen Parameter';
comment on column REP_SQL_PARAMETER."ORDER_INDEX" is 'Für die Sortierung der Parameterreihenfolge';
comment on column REP_SQL_PARAMETER."PARAM_NAME" is 'Parametername der SQL';
comment on column REP_SQL_PARAMETER."PARAM_TYP" is '''S'' = String, ''AM''= AnzeigeMaske,  ''DM= DatenMaske , ''CB'' Comboauswahl, ''N'' = Number (Double), ''D'' = Date, ''DV'' =Datum von ''DB'', Datum Bis ''SD'', SDV, SDB, ''LU'' DB Lookup';
comment on column REP_SQL_PARAMETER."WERT_MASKE" is 'z.B. für Datumseingaben (Benutzung mit TMaskEdit)';



-- sqlcl_snapshot {"hash":"dfd085bedabb3f4eb58599d10af3395428bb7d30","type":"COMMENT","name":"rep_sql_parameter","schemaName":"dirkspzm32","sxml":""}