create or replace function dirkspzm32.isi_adresse_insert (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in isi_firma.firma_nr%type,
    in_adresse_typ in isi_adressen.adr_art%type,
    in_adresse_nr  in isi_adressen.adr_nr%type,
    in_liefer_adr  in isi_adressen.adr_liefer%type
) return integer is
    result integer;
begin
    insert into isi_adressen values ( in_sid,
                                      0,            -- Adress_ID kommt aus trigger
                                      in_firma_nr,
                                      in_adresse_typ,
                                      in_adresse_nr,-- Adress Nr ist hier Firma
                                      in_liefer_adr,-- Keine Liefer Adressse
                                      null,         -- Name 1
                                      null,         -- Name 2
                                      null,         -- Name 3
                                      null,         -- Strasse
                                      null,         -- PLZ
                                      null,         -- Ort
                                      'T',          -- Aktive
                                      null,         -- Anspr. Patner
                                      null,         -- EMAIL
                                      null,         -- Telefon
                                      null,         -- FAX
                                      null,         -- LTE Etikett
                                      null,         -- LHM Etikett
                                      'F',          -- externer Etikettendruck freigeschaltet (default-Wert wird benutzt)
                                      'F',          -- 'T' => Bei der Etikettierung mit Scanner muss die LTE_ID und Charge getauscht werden.
                                      null,         -- ISIPlus Module, die an dieser Adresse installiert sind
                                      null,         -- LTE_Etiketten Typ
                                      null,         -- LTE_Etiketten Spez_barcodce_Aufbau
                                      null,         -- LHM_Etiketten Typ
                                      null,         -- LTE_Etiketten Spez_barcodce_Aufbau
                                      null,         -- Land
                                      null,         -- Land Kurz
                                      null,         -- info_1
                                      null,         -- lhm_etiketten_layout
                                      null,         -- lte_etiketten_layout
                                      null,         -- ecc_hersteller_id
                                      null,         -- edi_gln
                                      null,         -- k_adress_id_b
                                      null,         -- k_adress_id_h
                                      null,         -- k_adress_id_r
                                      'F',          -- edi_enabled
                                      null,         -- ls_versand   Avis??
                                      null,         -- WAEHRUNG
                                      null,         -- KUNDENNRLIEF
                                      null,         -- LIEF_EINK_RABATT_FAKTOR
                                      null,         -- EINK_PREIS_BERECHNEN
                                      null,         -- LIEFERBEDINGUNGEN
                                      null,         -- ZAHLUNGSBEDINGUNGEN
                                      null,         -- UST_ID_NUMMER
                                      null,         -- RG_MWST_TEXT
                                      null,         -- LTE_LHM_NUMMERNKREIS_VON N NUMBER  Y     Beginn des Nummernkreises
                                      null,         -- LTE_LHM_NUMMERNKREIS_BIS N NUMBER  Y     Ende des Nummernkreises
                                      null,         -- LTE_LHM_NUMMERNKREIS_AKTUELL N NUMBER  Y     Aktuelle Nummer innerhalb des Nummernkreises
                                      null,         -- LTE_BARCODE_TYPE N VARCHAR2(10)  Y     Typ des Barcodes (CCG, VDA, NVE...)
                                      null,         -- LTE_EIGENER_NR_KREIS N VARCHAR2(1) Y     'T' => bedeutet Kunde hat eigenen Nummernkreis, sonst 'F'
                                      null,         -- LTE_BARCODE_KOPF N VARCHAR2(20)  Y     Basisnummer bei Cerealia 34027453 oder SID
                                      null,         -- LTE_BARCODE_LAENGE N NUMBER(2) Y     Länge des Barcodes inkl. Kopf (Basisnummer, SID etc.)
                                      null,         -- LHM_BARCODE_TYPE N VARCHAR2(10)  Y     Typ des Barcodes für den Karton (CCG, VDA, NVE...)
                                      null,         -- LHM_EIGENER_NR_KREIS N VARCHAR2(1) Y     'T' => bedeutet Kunde hat eigenen Nummernkreis, sonst 'F'
                                      null,         -- LHM_BARCODE_KOPF N VARCHAR2(20)  Y     Basisnummer für den Karton
                                      null,         -- LHM_BARCODE_LAENGE N NUMBER(2) Y     Länge des Barcodes für den Karton inkl. Kopf  (Basisnummer , SID, etc.)
                                      'F',          -- ZOLLPFLICHT  N VARCHAR2(1) Y 'F'   N   Ist der Kunde oder Lieferant Zollpflichtig (z.B. muss eine Zollplbe oder Zollpapiere ausgestellt werden)
                                      null );        -- REGION_CODE	N	VARCHAR2(40)	Y			N	N		"Bundesland / Region - Zur Feiertagsfindung z.B.: 
    select
        seq_adressen_id.currval
    into result
    from
        dual;

    return ( result );
end isi_adresse_insert;
/


-- sqlcl_snapshot {"hash":"deb0f17ec0d0a43664a365500c6bff2e6ac47121","type":"FUNCTION","name":"ISI_ADRESSE_INSERT","schemaName":"DIRKSPZM32","sxml":""}