comment on table DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU is 'Packschema Beschreibung Palettenaufbau ';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."ARTIKEL_ID" is 'Artikel_Id  -> Tabelle ISI_ARTIKE ';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."PACKSCHEMA_KOPF_ID" is 'ID / Name des Packschemas';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."PACKSCHEMA_LAGE" is 'Lage bzw. Position im Aufbau 1 ist unten 1+x ist oben';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."PACKSCHEMA_LAGE_HOEHE" is '[mm] Wenn PACKSCHEMA_LAGE_TYP = Artikel -> Höhe 0 (Hähe kommt dann aus dem Auftrag';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."PACKSCHEMA_LAGE_TYP" is 'TP = TraegerPalette, SM = SekundaerMaterial, ART = Artikel (1 bis n Lagen definiert im KOM Auftrag)';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."PROZESS_PARAM" is 'Prozessvariable für Fertigungsprozess z.B. SAP Fertig Meldungs Position.';
comment on column DIRKSPZM32.LVS_PACKSCHEMA_AUFBAU."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"19011276e0cd528a73e1410cf9d100514f620f3e","type":"COMMENT","name":"lvs_packschema_aufbau","schemaName":"dirkspzm32","sxml":""}