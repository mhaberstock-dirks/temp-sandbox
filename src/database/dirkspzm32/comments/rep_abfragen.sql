comment on table dirkspzm32.rep_abfragen is
    'Alle Reports im ISIPlus';

comment on column dirkspzm32.rep_abfragen.base_rep_name is
    'Auf welchem ursprünglichen Report basiert dieser?';

comment on column dirkspzm32.rep_abfragen.custom_code is
    'Kurzbezeichnung des Kunden für den dieser Report erstellt/angepasst wurde';

comment on column dirkspzm32.rep_abfragen.default_anzeige is
    '''T'' = Tabellenansicht; ''D'' = Druckansicht; ''C'' = Chartansicht, ''E'' = Extension';

comment on column dirkspzm32.rep_abfragen.detail_rep_name is
    'Reportname des Detail-Reports, bei einer Master-Detailbeziehung';

comment on column dirkspzm32.rep_abfragen.dlg_category is
    '0=dcActivity, 1=dcAdmin, 2=dcConfig, 3=dcCustom, 4=dcMasterData, 5=dcNone (analog zu ISIFrame)';

comment on column dirkspzm32.rep_abfragen.dlg_short_name is
    'DlgKuerzel für die automatische Integration im ISIPlus Menü (wie DDL)';

comment on column dirkspzm32.rep_abfragen.embed_in_menu is
    'Einbindung in das Hauptmenü T=Ja, F=Nein';

comment on column dirkspzm32.rep_abfragen.enabled_extensions_csv is
    'CSV (";" separated) list of enabled info system extensions for this report';

comment on column dirkspzm32.rep_abfragen.extensions_params_csv is
    'Her können Report-Extensions eigene Parameter unterbringen';

comment on column dirkspzm32.rep_abfragen.icon16_ix is
    'Icon Index aus der Haupt-ImageList';

comment on column dirkspzm32.rep_abfragen.master_category is
    '0=mcExtras, 1=mcFile, 2=mcHelp, 3=mcInfo, 4=mcNone (analog zu ISIFrame)';

comment on column dirkspzm32.rep_abfragen.query_type is
    '''select'' = normale SQL, ''command'' = SQL mit stored procedure, insert, update etc.';

comment on column dirkspzm32.rep_abfragen.rep_caption is
    'a caption for the profile which the end user can see. if ''C_TXT_...'' is used, the system tries to load the caption from the lang file by this constant'
    ;

comment on column dirkspzm32.rep_abfragen.rep_ext_db_name is
    'Name einer externen Datenbank-Konfiguration wenn erforderlich für den aktuellen Report';

comment on column dirkspzm32.rep_abfragen.rep_intern is
    '''T''  = Interner Report   ''L''= Lookup Report  ''F'' = Öffentlich';

comment on column dirkspzm32.rep_abfragen.show_detail_data is
    '''T'' = if a detail report is defined, it will be executed and shown, ''F'' = do not display any detail report';

comment on column dirkspzm32.rep_abfragen.show_in_toolbar is
    'Button in der Toolbar erzeugen T=Ja, F=Nein';

comment on column dirkspzm32.rep_abfragen.show_type is
    '0=stShowDlgNormal, 1=stShowDlgStayOnTop, 2=stShowModal, 3=stShowNormal (analog zu ISIFrame)';

comment on column dirkspzm32.rep_abfragen.sorting_mode is
    '''SQL'' = substition inside of a query, ''CONTROL'' = a client control (table) for in memory sorting';

comment on column dirkspzm32.rep_abfragen.sort_field_param_name is
    'Wird nicht in der Parameterliste gepflegt und ist ein Substitutions-Parameter (d.h. wird im SQL Text ersetzt)';


-- sqlcl_snapshot {"hash":"de7dbcae0905b87b16bd5fbc935c34c2ef44f540","type":"COMMENT","name":"rep_abfragen","schemaName":"dirkspzm32","sxml":""}