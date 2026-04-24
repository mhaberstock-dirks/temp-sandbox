comment on table dirkspzm32.isi_liefs is
    'Daten für Lieferschein';

comment on column dirkspzm32.isi_liefs.adress_id is
    'ID aus Adressen Tabelle (ISI_ORDER)';

comment on column dirkspzm32.isi_liefs.adress_nr is
    'Kunden oder Lieferanten Nr.';

comment on column dirkspzm32.isi_liefs.artikel_id is
    'Artikel ID aus ISI_ORDER --> ISI_ARTIKEL';

comment on column dirkspzm32.isi_liefs.auftrag is
    'Auftragsnummer / Bestellung im DIAF';

comment on column dirkspzm32.isi_liefs.avis_status is
    'Status: N=Neu, F = Freigegeben, U=Übertragung läuft, UE= Übertragen';

comment on column dirkspzm32.isi_liefs.be_nr is
    'Bestellnummer';

comment on column dirkspzm32.isi_liefs.fahrzeug_abfahrt is
    'Abfarhrt, kann beim Ausdruck eingegeben werden';

comment on column dirkspzm32.isi_liefs.fahrzeug_ankunft is
    'Ankunft, kann beim Ausdruck eingegeben werden';

comment on column dirkspzm32.isi_liefs.fahrzeug_kennz is
    'Fahrzeugkennzeichen, kann beim Ausdruck eingegeben werden';

comment on column dirkspzm32.isi_liefs.firma_nr is
    'Firmennummer in der Datenbank';

comment on column dirkspzm32.isi_liefs.inaktiv_grund is
    'Grund der Deaktivierung';

comment on column dirkspzm32.isi_liefs.info_text is
    'Infotext';

comment on column dirkspzm32.isi_liefs.lam_bh_id is
    'ID der LAM-Buchung in der LAM_BH oder History';

comment on column dirkspzm32.isi_liefs.lam_id is
    'ID der LAM in der LAM oder History';

comment on column dirkspzm32.isi_liefs.lam_mhd is
    'Min. Haldbar bis (Datum) (Aus LVS_LAM)';

comment on column dirkspzm32.isi_liefs.lhm_id is
    'ID der LHM in der LHM oder History';

comment on column dirkspzm32.isi_liefs.liefs_datum is
    'Datum des ersten Ausdrucks';

comment on column dirkspzm32.isi_liefs.li_nr is
    'Lieferschein Nummer aus Externem System, sonst einen Lieferschein in eigener Tabelle anlegen (ISI_ORDER)';

comment on column dirkspzm32.isi_liefs.li_pos_nr is
    'Lieferscheinposition -Nummer (ISI_ORDER)';

comment on column dirkspzm32.isi_liefs.login_id is
    'LOGIN ID des Erzeugers der ISI-Order Bzw. Erzeugers der LS-Daten für kommissionierte Ware';

comment on column dirkspzm32.isi_liefs.login_id_verantwortung is
    'LOGIN ID des Erzeugers des Lieferscheins (Druck des Lieferscheinpapiers)';

comment on column dirkspzm32.isi_liefs.lte_id is
    'ID der LTE in der LTE oder History';

comment on column dirkspzm32.isi_liefs.lte_name is
    'Art, Name der Transporteinheit';

comment on column dirkspzm32.isi_liefs.menge is
    'Menge in der Verladung';

comment on column dirkspzm32.isi_liefs.mengeneinheit_basis is
    'Mengeneinheit aus Menge Basis z.B. MENGENEINHEIT oder Name der LHM oder LTE';

comment on column dirkspzm32.isi_liefs.menge_basis is
    'LKE = Kleinste Einheit, LHM = Name LHM, LTE = Name Transporteinheit';

comment on column dirkspzm32.isi_liefs.order_adress_id is
    'ID, wer hat diese Bestellung erstellt (Rechnungsadresse) (ISI_ORDER)';

comment on column dirkspzm32.isi_liefs.pos_nr is
    'Positionsnummer';

comment on column dirkspzm32.isi_liefs.res_id is
    'RES_ID mit welcher Resource wurde transportiert';

comment on column dirkspzm32.isi_liefs.sid is
    'Datenbank für Konsolidierung';

comment on column dirkspzm32.isi_liefs.temperatur_gelesen is
    'Temperatur aus Script (Gelesen aus Anlage)';

comment on column dirkspzm32.isi_liefs.transporteur is
    'Name der Spedition ....';

comment on column dirkspzm32.isi_liefs.uebergabe_temp is
    'Uebergabe-Temp, kann beim Ausdruck eingegeben werden';

comment on column dirkspzm32.isi_liefs.upos_nr is
    'Unterposition Bsp.: Eine Position mit n Chargen etc.';

comment on column dirkspzm32.isi_liefs.vorgang_id is
    'Tourennummer aus isi_order';

comment on column dirkspzm32.isi_liefs.vorgang_pos is
    'Position im Vorgang aus isi_order';

comment on column dirkspzm32.isi_liefs.vorgang_typ is
    'WEI/WAI = Zugang/Abgang Intern (z.B. Produktion), WEE/WAE = Zugang/Abgang Extern (Anlieferung, Versand) WUI/WUE = Umlagerung Intern/Extern'
    ;

comment on column dirkspzm32.isi_liefs.v_lhm_id is
    'Vorgaenger LHM_ID';

comment on column dirkspzm32.isi_liefs.zollplombe_id is
    'ID der Zollplombe (Normalerweise 8 Stellen)';


-- sqlcl_snapshot {"hash":"7c5aae48a212ce9853e37b579f1afdc29ad1175c","type":"COMMENT","name":"isi_liefs","schemaName":"dirkspzm32","sxml":""}