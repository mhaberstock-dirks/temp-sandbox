comment on table dirkspzm32.pps_prod_param_cfg is
    'verwendete Prod. Parameter ';

comment on column dirkspzm32.pps_prod_param_cfg.beschreibung is
    'Beschreibung des Parameters';

comment on column dirkspzm32.pps_prod_param_cfg.bezugspunkt is
    'ABSOLUT, Mittellinie , Achsmitte , Aussenkante ';

comment on column dirkspzm32.pps_prod_param_cfg.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_prod_param_cfg.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_prod_param_cfg.editor is
    'MaskEdit, SpinEdit, ComboBox,CheckBox,CheckComboBox, LookupComboBox';

comment on column dirkspzm32.pps_prod_param_cfg.einheit is
    '''mm'',''Grad'',...';

comment on column dirkspzm32.pps_prod_param_cfg.firma_nr is
    'Firma_Nr';

comment on column dirkspzm32.pps_prod_param_cfg.format is
    'Maskierung ';

comment on column dirkspzm32.pps_prod_param_cfg.gruppe is
    'Gruppe des Parameters';

comment on column dirkspzm32.pps_prod_param_cfg.ist_variable is
    'T= dieser PArameter ist variabel, F = Dieser Parameter ist konstant';

comment on column dirkspzm32.pps_prod_param_cfg.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_prod_param_cfg.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_prod_param_cfg.lookuplist is
    'Liste der Nachschlageparameter mit CR/LF getrennt';

comment on column dirkspzm32.pps_prod_param_cfg.lookupreport is
    'LookupReport ';

comment on column dirkspzm32.pps_prod_param_cfg.maxvalue is
    'grösster Wert';

comment on column dirkspzm32.pps_prod_param_cfg.minvalue is
    'kleinster Wert';

comment on column dirkspzm32.pps_prod_param_cfg.param_id is
    'Unique ID';

comment on column dirkspzm32.pps_prod_param_cfg.param_name is
    'Kurzname wird in Prod_Params eingetragen';

comment on column dirkspzm32.pps_prod_param_cfg.quelle is
    'HOST = aus Schnittstelle zum Host, DLG = manuelle Dialogeingabe, SCRIPT = Script holt und setzt Daten';

comment on column dirkspzm32.pps_prod_param_cfg.sid is
    'sid';

comment on column dirkspzm32.pps_prod_param_cfg.wert_typ is
    '1=ganze Zahl, 2=realzahl, 3=Datum + Uhrzeit, 4=string  ';

comment on column dirkspzm32.pps_prod_param_cfg.ziel is
    'Zielschnittstelle, an die der Parameter gesendet werden soll (insbesondere für Customizing geeignet)';


-- sqlcl_snapshot {"hash":"91f507a39f5c7fb9bd0187d205935d8969a2edd3","type":"COMMENT","name":"pps_prod_param_cfg","schemaName":"dirkspzm32","sxml":""}