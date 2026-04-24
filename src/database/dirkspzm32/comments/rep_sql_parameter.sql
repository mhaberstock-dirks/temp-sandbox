comment on column dirkspzm32.rep_sql_parameter.dlg_caption is
    'Anzeige Text im Parameingabedialog';

comment on column dirkspzm32.rep_sql_parameter.dlg_gruppe_nr is
    'Gruppe nummer für zusammengehörigen von bis Eingaben';

comment on column dirkspzm32.rep_sql_parameter.dlg_input_check is
    '0 = Keine Eingabe notwendig, 1= mind. ein Parameter in Gruppe gesetzt  2=Zwangseingabe';

comment on column dirkspzm32.rep_sql_parameter.dlg_spalte_nr is
    'Anzeige Dialog in Spalte 1..max 3';

comment on column dirkspzm32.rep_sql_parameter.lookup_rep_name is
    'Name der Nachschlage SQL für diesen Parameter';

comment on column dirkspzm32.rep_sql_parameter.order_index is
    'Für die Sortierung der Parameterreihenfolge';

comment on column dirkspzm32.rep_sql_parameter.param_name is
    'Parametername der SQL';

comment on column dirkspzm32.rep_sql_parameter.param_typ is
    '''S'' = String, ''AM''= AnzeigeMaske,  ''DM= DatenMaske , ''CB'' Comboauswahl, ''N'' = Number (Double), ''D'' = Date, ''DV'' =Datum von ''DB'', Datum Bis ''SD'', SDV, SDB, ''LU'' DB Lookup'
    ;

comment on column dirkspzm32.rep_sql_parameter.wert_maske is
    'z.B. für Datumseingaben (Benutzung mit TMaskEdit)';


-- sqlcl_snapshot {"hash":"10814cc35b4a19f807530c83ba4eaa710d278b83","type":"COMMENT","name":"rep_sql_parameter","schemaName":"dirkspzm32","sxml":""}