comment on table S_RCV_UML_AUFTRAG is 'Umlageraufträge aus dem SAP (Lagerort -> Lagerort)';
comment on column S_RCV_UML_AUFTRAG."ARTIKEL" is 'Artikelnummer ISI_ARTIKEL.ARTIKEL';
comment on column S_RCV_UML_AUFTRAG."AUFTRNR" is 'Auftragsnummer';
comment on column S_RCV_UML_AUFTRAG."CHARGE" is 'Geforderte Charge';
comment on column S_RCV_UML_AUFTRAG."ERSTELLT_DATUM" is 'Erzeugungsdatum';
comment on column S_RCV_UML_AUFTRAG."FIRMA_NR" is 'Firmanummer (Mandant)';
comment on column S_RCV_UML_AUFTRAG."LTE_ID" is 'Genau diese LTE ist zu transportieren';
comment on column S_RCV_UML_AUFTRAG."QIUELL_LGR_PLATZ" is 'Quellenlagerplatz (In ISI-Plus)';
comment on column S_RCV_UML_AUFTRAG."QUELL_LGR_ORT" is 'Quellenlagerort Lagerort im ISIPlus ==> LVS_LGR_ORT.LGR_ORT';
comment on column S_RCV_UML_AUFTRAG."SID" is 'SID ';
comment on column S_RCV_UML_AUFTRAG."UMLDAT" is 'Umlagerdatum';
comment on column S_RCV_UML_AUFTRAG."ZIEL_LGR_ORT" is 'Ziellagerort Lagerort im ISIPlus ==> LVS_LGR_ORT.LGR_ORT';
comment on column S_RCV_UML_AUFTRAG."ZIEL_LGR_PLATZ" is 'Ziellagerplatz (In ISI-Plus)';
comment on column S_RCV_UML_AUFTRAG."ZIEL_ORT_BEZ" is 'Ziel Halle';



-- sqlcl_snapshot {"hash":"821085e6019e2bdc7e8be02023a4a7aaed89ea65","type":"COMMENT","name":"s_rcv_uml_auftrag","schemaName":"dirkspzm32","sxml":""}