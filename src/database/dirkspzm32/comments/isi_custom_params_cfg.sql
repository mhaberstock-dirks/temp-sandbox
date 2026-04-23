comment on table dirkspzm32.isi_custom_params_cfg is
    'verwendete Parameter ';

comment on column dirkspzm32.isi_custom_params_cfg.beschreibung is
    'Beschreibung des Parameters';

comment on column dirkspzm32.isi_custom_params_cfg.bezugspunkt is
    'ABSOLUT, Mittellinie , Achsmitte , Aussenkante ';

comment on column dirkspzm32.isi_custom_params_cfg.editor is
    'MaskEdit, SpinEdit, ComboBox,CheckBox,CheckComboBox, LookupComboBox';

comment on column dirkspzm32.isi_custom_params_cfg.einheit is
    '''mm'',''Grad'',...';

comment on column dirkspzm32.isi_custom_params_cfg.firma_nr is
    'Firma_Nr';

comment on column dirkspzm32.isi_custom_params_cfg.format is
    'Maskierung ';

comment on column dirkspzm32.isi_custom_params_cfg.gruppe is
    'Gruppe des Parameters';

comment on column dirkspzm32.isi_custom_params_cfg.ist_variable is
    'T= dieser PArameter ist variabel, F = Dieser Parameter ist konstant';

comment on column dirkspzm32.isi_custom_params_cfg.lookuplist is
    'Liste der Nachschlageparameter mit CR/LF getrennt';

comment on column dirkspzm32.isi_custom_params_cfg.lookupreport is
    'LookupReport ';

comment on column dirkspzm32.isi_custom_params_cfg.maxvalue is
    'grösster Wert';

comment on column dirkspzm32.isi_custom_params_cfg.minvalue is
    'kleinster Wert';

comment on column dirkspzm32.isi_custom_params_cfg.param_id is
    'Unique ID';

comment on column dirkspzm32.isi_custom_params_cfg.param_name is
    'Kurzname wird in Prod_Params eingetragen';

comment on column dirkspzm32.isi_custom_params_cfg.quelle is
    'HOST = aus Schnittstelle zum Host, DLG = manuelle Dialogeingabe, SCRIPT = Script holt und setzt Daten';

comment on column dirkspzm32.isi_custom_params_cfg.sid is
    'sid';

comment on column dirkspzm32.isi_custom_params_cfg.wert_typ is
    '1=ganze Zahl, 2=realzahl, 3=Datum + Uhrzeit, 4=string  ';

comment on column dirkspzm32.isi_custom_params_cfg.ziel is
    'Zielschnittstelle, an die der Parameter gesendet werden soll (insbesondere für Customizing geeignet)';


-- sqlcl_snapshot {"hash":"4d1a43fa8c7f03e9c4a7cb5314307f699478978c","type":"COMMENT","name":"isi_custom_params_cfg","schemaName":"dirkspzm32","sxml":""}