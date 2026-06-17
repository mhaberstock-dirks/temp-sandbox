comment on table DIRKSPZM32.ISI_LIEFS is 'Daten für Lieferschein';
comment on column DIRKSPZM32.ISI_LIEFS."ADRESS_ID" is 'ID aus Adressen Tabelle (ISI_ORDER)';
comment on column DIRKSPZM32.ISI_LIEFS."ADRESS_NR" is 'Kunden oder Lieferanten Nr.';
comment on column DIRKSPZM32.ISI_LIEFS."ARTIKEL_ID" is 'Artikel ID aus ISI_ORDER --> ISI_ARTIKEL';
comment on column DIRKSPZM32.ISI_LIEFS."AUFTRAG" is 'Auftragsnummer / Bestellung im DIAF';
comment on column DIRKSPZM32.ISI_LIEFS."AVIS_STATUS" is 'Status: N=Neu, F = Freigegeben, U=Übertragung läuft, UE= Übertragen';
comment on column DIRKSPZM32.ISI_LIEFS."BE_NR" is 'Bestellnummer';
comment on column DIRKSPZM32.ISI_LIEFS."FAHRZEUG_ABFAHRT" is 'Abfarhrt, kann beim Ausdruck eingegeben werden';
comment on column DIRKSPZM32.ISI_LIEFS."FAHRZEUG_ANKUNFT" is 'Ankunft, kann beim Ausdruck eingegeben werden';
comment on column DIRKSPZM32.ISI_LIEFS."FAHRZEUG_KENNZ" is 'Fahrzeugkennzeichen, kann beim Ausdruck eingegeben werden';
comment on column DIRKSPZM32.ISI_LIEFS."FIRMA_NR" is 'Firmennummer in der Datenbank';
comment on column DIRKSPZM32.ISI_LIEFS."INAKTIV_GRUND" is 'Grund der Deaktivierung';
comment on column DIRKSPZM32.ISI_LIEFS."INFO_TEXT" is 'Infotext';
comment on column DIRKSPZM32.ISI_LIEFS."LAM_BH_ID" is 'ID der LAM-Buchung in der LAM_BH oder History';
comment on column DIRKSPZM32.ISI_LIEFS."LAM_ID" is 'ID der LAM in der LAM oder History';
comment on column DIRKSPZM32.ISI_LIEFS."LAM_MHD" is 'Min. Haldbar bis (Datum) (Aus LVS_LAM)';
comment on column DIRKSPZM32.ISI_LIEFS."LHM_ID" is 'ID der LHM in der LHM oder History';
comment on column DIRKSPZM32.ISI_LIEFS."LIEFS_DATUM" is 'Datum des ersten Ausdrucks';
comment on column DIRKSPZM32.ISI_LIEFS."LI_NR" is 'Lieferschein Nummer aus Externem System, sonst einen Lieferschein in eigener Tabelle anlegen (ISI_ORDER)';
comment on column DIRKSPZM32.ISI_LIEFS."LI_POS_NR" is 'Lieferscheinposition -Nummer (ISI_ORDER)';
comment on column DIRKSPZM32.ISI_LIEFS."LOGIN_ID" is 'LOGIN ID des Erzeugers der ISI-Order Bzw. Erzeugers der LS-Daten für kommissionierte Ware';
comment on column DIRKSPZM32.ISI_LIEFS."LOGIN_ID_VERANTWORTUNG" is 'LOGIN ID des Erzeugers des Lieferscheins (Druck des Lieferscheinpapiers)';
comment on column DIRKSPZM32.ISI_LIEFS."LTE_ID" is 'ID der LTE in der LTE oder History';
comment on column DIRKSPZM32.ISI_LIEFS."LTE_NAME" is 'Art, Name der Transporteinheit';
comment on column DIRKSPZM32.ISI_LIEFS."MENGE" is 'Menge in der Verladung';
comment on column DIRKSPZM32.ISI_LIEFS."MENGENEINHEIT_BASIS" is 'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';
comment on column DIRKSPZM32.ISI_LIEFS."MENGE_BASIS" is 'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';
comment on column DIRKSPZM32.ISI_LIEFS."ORDER_ADRESS_ID" is 'ID, wer hat diese Bestellung erstellt (Rechnungsadresse) (ISI_ORDER)';
comment on column DIRKSPZM32.ISI_LIEFS."POS_NR" is 'Positionsnummer';
comment on column DIRKSPZM32.ISI_LIEFS."RES_ID" is 'RES_ID mit welcher Resource wurde transportiert';
comment on column DIRKSPZM32.ISI_LIEFS."SID" is 'Datenbank für Konsolidierung';
comment on column DIRKSPZM32.ISI_LIEFS."TEMPERATUR_GELESEN" is 'Temperatur aus Script (Gelesen aus Anlage)';
comment on column DIRKSPZM32.ISI_LIEFS."TRANSPORTEUR" is 'Name der Spedition ....';
comment on column DIRKSPZM32.ISI_LIEFS."UEBERGABE_TEMP" is 'Uebergabe-Temp, kann beim Ausdruck eingegeben werden';
comment on column DIRKSPZM32.ISI_LIEFS."UPOS_NR" is 'Unterposition Bsp.: Eine Position mit n Chargen etc.';
comment on column DIRKSPZM32.ISI_LIEFS."VORGANG_ID" is 'Tourennummer aus isi_order';
comment on column DIRKSPZM32.ISI_LIEFS."VORGANG_POS" is 'Position im Vorgang aus isi_order';
comment on column DIRKSPZM32.ISI_LIEFS."VORGANG_TYP" is 'WEI/WAI = Zugang/Abgang Intern (z.B. Produktion), WEE/WAE = Zugang/Abgang Extern (Anlieferung, Versand) WUI/WUE = Umlagerung Intern/Extern';
comment on column DIRKSPZM32.ISI_LIEFS."V_LHM_ID" is 'Vorgaenger LHM_ID';
comment on column DIRKSPZM32.ISI_LIEFS."ZOLLPLOMBE_ID" is 'ID der Zollplombe (Normalerweise 8 Stellen)';



-- sqlcl_snapshot {"hash":"39ac6afa6a2d228bd5b59f442668d05a539488ba","type":"COMMENT","name":"isi_liefs","schemaName":"dirkspzm32","sxml":""}