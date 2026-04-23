comment on table dirkspzm32.isi_artikel_ctrl is
    'Steuerinformationen für Artikel im ISIPlus';

comment on column dirkspzm32.isi_artikel_ctrl.artikel_id is
    'Artikel ID aus ISI_Artikel';

comment on column dirkspzm32.isi_artikel_ctrl.ep is
    'Entscheidungspunkt z.B. Maschine, Pos. auf der Fördertechnik, etc';

comment on column dirkspzm32.isi_artikel_ctrl.fa_ag is
    'Arbeitsgang (Fertigungsstufe)';

comment on column dirkspzm32.isi_artikel_ctrl.firma_nr is
    'Firma Nummer';

comment on column dirkspzm32.isi_artikel_ctrl.funktion is
    'z.B. LGR_FAEHIG oder AUSSCHL';

comment on column dirkspzm32.isi_artikel_ctrl.isi_artikel_ctrl_id is
    'PK ';

comment on column dirkspzm32.isi_artikel_ctrl.leitzahl is
    'FA-Auftragsnummer aus BDE_FA_AUFTRAG -> LAM und LAM_BH ';

comment on column dirkspzm32.isi_artikel_ctrl.param_wert is
    'T = True, F = False oder Auschleusziel etc';

comment on column dirkspzm32.isi_artikel_ctrl.prod_params is
    'Produktionsparameter; T = True, F = False oder Auschleusziel etc';

comment on column dirkspzm32.isi_artikel_ctrl.sid is
    'ISI_SID ';

comment on column dirkspzm32.isi_artikel_ctrl.zeichnung is
    'Zeichnungsnummer';

comment on column dirkspzm32.isi_artikel_ctrl.zeichnung_index is
    'Zeichnungsindex';


-- sqlcl_snapshot {"hash":"dbc03ee793c18fc4e226b337205fe1d8d422387e","type":"COMMENT","name":"isi_artikel_ctrl","schemaName":"dirkspzm32","sxml":""}