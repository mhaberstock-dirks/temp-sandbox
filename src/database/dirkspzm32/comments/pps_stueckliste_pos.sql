comment on table dirkspzm32.pps_stueckliste_pos is
    'PPS Stückliste Positionen';

comment on column dirkspzm32.pps_stueckliste_pos.artikel_id is
    'Artikel ID aus ISI-Artikel';

comment on column dirkspzm32.pps_stueckliste_pos.created_date is
    'creation date+time of this dataset';

comment on column dirkspzm32.pps_stueckliste_pos.created_login_id is
    'login ID of the user creating this dataset';

comment on column dirkspzm32.pps_stueckliste_pos.firma_nr is
    'Firma';

comment on column dirkspzm32.pps_stueckliste_pos.last_change_date is
    'change date+time of this dataset';

comment on column dirkspzm32.pps_stueckliste_pos.last_change_login_id is
    'login ID of the user changing this dataset';

comment on column dirkspzm32.pps_stueckliste_pos.plan_menge_p_einheit is
    'Faktor Bedarfsmenge zur AG Planmenge';

comment on column dirkspzm32.pps_stueckliste_pos.plan_menge_p_einheit_op is
    '''ABS'' = Absolute -> Immer genau diese Menge ''MUL'' = Multiplizieren, ''DIV'' = Dividieren';

comment on column dirkspzm32.pps_stueckliste_pos.pos_nr is
    'Stücklistenposition für Reihenfolge ';

comment on column dirkspzm32.pps_stueckliste_pos.prod_params is
    'Produktionsparameter Statisch für Stücklisteneintrag';

comment on column dirkspzm32.pps_stueckliste_pos.sid is
    'SID';

comment on column dirkspzm32.pps_stueckliste_pos.sl_alternative is
    'Vorgang Alternative Leer = Standard';

comment on column dirkspzm32.pps_stueckliste_pos.stueckliste_id is
    'Stücklisten ID';

comment on column dirkspzm32.pps_stueckliste_pos.stueckliste_pos_id is
    'Eindeutige ID für genau diesen Eintrag';

comment on column dirkspzm32.pps_stueckliste_pos.zeichnung is
    'Zeichnung (Wenn genau diese verwendet werden soll) Wenn NULL dann aus Artikel';

comment on column dirkspzm32.pps_stueckliste_pos.zeichnung_index is
    'Zeichnungsindex (Wenn genau dieser verwendet werden soll) Wenn NULL dann aus Artikel';


-- sqlcl_snapshot {"hash":"fba6f1ebc5150333d8201f1e5bc34572a84a86ca","type":"COMMENT","name":"pps_stueckliste_pos","schemaName":"dirkspzm32","sxml":""}