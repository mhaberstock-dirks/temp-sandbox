comment on table LVS_LGR_GRP is 'Lagerplatz Gruppe für dir Zuordnung von Fahrzeugen auf einen Teil eiens Lagerorts';
comment on column LVS_LGR_GRP."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column LVS_LGR_GRP."LGR_GRUPPE_HAUPT_GRP" is 'Um Lagergrupen zusammen zu fassen Bsp 3 Lagergruppen und zwei Fahrzeuge die auf eine Schiene fahren';
comment on column LVS_LGR_GRP."LGR_GRUPPE_ID" is 'ID Der Gruppe (Gruppe für die Zuordnung von Fahrzeugen)';
comment on column LVS_LGR_GRP."LGR_GRUPPE_MAX_LTE" is 'Anzahl Max LTE die in dieser Gruppe eingelagert werden können';
comment on column LVS_LGR_GRP."LGR_GRUPPE_NAME" is 'Text Bezeichnung der Gruppe';
comment on column LVS_LGR_GRP."LGR_ORT" is 'Referenz zum Lagerort';
comment on column LVS_LGR_GRP."SID" is 'Datenbank für Konsolidierung';



-- sqlcl_snapshot {"hash":"1613cecbb8b57b259cfada98345562f656e0b69b","type":"COMMENT","name":"lvs_lgr_grp","schemaName":"dirkspzm32","sxml":""}