comment on table dirkspzm32.lvs_packschema_aufbau is
    'Packschema Beschreibung Palettenaufbau ';

comment on column dirkspzm32.lvs_packschema_aufbau.artikel_id is
    'Artikel_Id  -> Tabelle ISI_ARTIKE ';

comment on column dirkspzm32.lvs_packschema_aufbau.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.lvs_packschema_aufbau.packschema_kopf_id is
    'ID / Name des Packschemas';

comment on column dirkspzm32.lvs_packschema_aufbau.packschema_lage is
    'Lage bzw. Position im Aufbau 1 ist unten 1+x ist oben';

comment on column dirkspzm32.lvs_packschema_aufbau.packschema_lage_hoehe is
    '[mm] Wenn PACKSCHEMA_LAGE_TYP = Artikel -> Höhe 0 (Hähe kommt dann aus dem Auftrag';

comment on column dirkspzm32.lvs_packschema_aufbau.packschema_lage_typ is
    'TP = TraegerPalette, SM = SekundaerMaterial, ART = Artikel (1 bis n Lagen definiert im KOM Auftrag)';

comment on column dirkspzm32.lvs_packschema_aufbau.prozess_param is
    'Prozessvariable für Fertigungsprozess z.B. SAP Fertig Meldungs Position.';

comment on column dirkspzm32.lvs_packschema_aufbau.sid is
    'Datenbank für Konsolidierung';


-- sqlcl_snapshot {"hash":"370c4a9769594c26d88e175dab0db8aec6b19b7f","type":"COMMENT","name":"lvs_packschema_aufbau","schemaName":"dirkspzm32","sxml":""}