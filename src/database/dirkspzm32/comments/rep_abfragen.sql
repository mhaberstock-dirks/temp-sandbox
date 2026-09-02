comment on table REP_ABFRAGEN is 'Alle Reports im ISIPlus';
comment on column REP_ABFRAGEN."BASE_REP_NAME" is 'Auf welchem ursprünglichen Report basiert dieser?';
comment on column REP_ABFRAGEN."CUSTOM_CODE" is 'Kurzbezeichnung des Kunden für den dieser Report erstellt/angepasst wurde';
comment on column REP_ABFRAGEN."DEFAULT_ANZEIGE" is '''T'' = Tabellenansicht; ''D'' = Druckansicht; ''C'' = Chartansicht, ''E'' = Extension';
comment on column REP_ABFRAGEN."DETAIL_REP_NAME" is 'Reportname des Detail-Reports, bei einer Master-Detailbeziehung';
comment on column REP_ABFRAGEN."DLG_CATEGORY" is '0=dcActivity, 1=dcAdmin, 2=dcConfig, 3=dcCustom, 4=dcMasterData, 5=dcNone (analog zu ISIFrame)';
comment on column REP_ABFRAGEN."DLG_SHORT_NAME" is 'DlgKuerzel für die automatische Integration im ISIPlus Menü (wie DDL)';
comment on column REP_ABFRAGEN."EMBED_IN_MENU" is 'Einbindung in das Hauptmenü T=Ja, F=Nein';
comment on column REP_ABFRAGEN."ENABLED_EXTENSIONS_CSV" is 'CSV (";" separated) list of enabled info system extensions for this report';
comment on column REP_ABFRAGEN."EXTENSIONS_PARAMS_CSV" is 'Her können Report-Extensions eigene Parameter unterbringen';
comment on column REP_ABFRAGEN."ICON16_IX" is 'Icon Index aus der Haupt-ImageList';
comment on column REP_ABFRAGEN."MASTER_CATEGORY" is '0=mcExtras, 1=mcFile, 2=mcHelp, 3=mcInfo, 4=mcNone (analog zu ISIFrame)';
comment on column REP_ABFRAGEN."QUERY_TYPE" is '''select'' = normale SQL, ''command'' = SQL mit stored procedure, insert, update etc.';
comment on column REP_ABFRAGEN."REP_CAPTION" is 'a caption for the profile which the end user can see. if ''C_TXT_...'' is used, the system tries to load the caption from the lang file by this constant';
comment on column REP_ABFRAGEN."REP_EXT_DB_NAME" is 'Name einer externen Datenbank-Konfiguration wenn erforderlich für den aktuellen Report';
comment on column REP_ABFRAGEN."REP_INTERN" is '''T''  = Interner Report   ''L''= Lookup Report  ''F'' = Öffentlich';
comment on column REP_ABFRAGEN."SHOW_DETAIL_DATA" is '''T'' = if a detail report is defined, it will be executed and shown, ''F'' = do not display any detail report';
comment on column REP_ABFRAGEN."SHOW_IN_TOOLBAR" is 'Button in der Toolbar erzeugen T=Ja, F=Nein';
comment on column REP_ABFRAGEN."SHOW_TYPE" is '0=stShowDlgNormal, 1=stShowDlgStayOnTop, 2=stShowModal, 3=stShowNormal (analog zu ISIFrame)';
comment on column REP_ABFRAGEN."SORT_FIELD_PARAM_NAME" is 'Wird nicht in der Parameterliste gepflegt und ist ein Substitutions-Parameter (d.h. wird im SQL Text ersetzt)';
comment on column REP_ABFRAGEN."SORTING_MODE" is '''SQL'' = substition inside of a query, ''CONTROL'' = a client control (table) for in memory sorting';



-- sqlcl_snapshot {"hash":"fffb78a3645db9553678bc3a1d5f7148d996cb8a","type":"COMMENT","name":"rep_abfragen","schemaName":"dirkspzm32","sxml":""}