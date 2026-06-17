create or replace 
function DIRKSPZM32.isi_adresse_insert(in_sid in isi_sid.sid%type,
                                              in_firma_nr    in isi_firma.firma_nr%type,
                                              in_adresse_typ in isi_adressen.adr_art%type,
                                              in_adresse_nr  in isi_adressen.adr_nr%type,
                                              in_liefer_adr  in isi_adressen.adr_liefer%type
                                             ) return integer is
  Result integer;
begin
  insert into isi_adressen
  values (in_sid,
          0,            -- Adress_ID kommt aus trigger
          in_firma_nr,
          in_adresse_typ,
          in_adresse_nr,-- Adress Nr ist hier Firma
          in_liefer_adr,-- Keine Liefer Adressse
          NULL,         -- Name 1
          NULL,         -- Name 2
          NULL,         -- Name 3
          NULL,         -- Strasse
          NULL,         -- PLZ
          NULL,         -- Ort
          'T',          -- Aktive
          NULL,         -- Anspr. Patner
          NULL,         -- EMAIL
          NULL,         -- Telefon
          NULL,         -- FAX
          NULL,         -- LTE Etikett
          NULL,         -- LHM Etikett
          'F',          -- externer Etikettendruck freigeschaltet (default-Wert wird benutzt)
          'F',          -- 'T' => Bei der Etikettierung mit Scanner muss die LTE_ID und Charge getauscht werden.
          null,         -- ISIPlus Module, die an dieser Adresse installiert sind
          null,         -- LTE_Etiketten Typ
          null,         -- LTE_Etiketten Spez_barcodce_Aufbau
          null,         -- LHM_Etiketten Typ
          null,         -- LTE_Etiketten Spez_barcodce_Aufbau
          null,         -- Land
          null,         -- Land Kurz
          NULL,         -- info_1
          NULL,         -- lhm_etiketten_layout
          NULL,         -- lte_etiketten_layout
          NULL,         -- ecc_hersteller_id
          NULL,         -- edi_gln
          NULL,         -- k_adress_id_b
          NULL,         -- k_adress_id_h
          NULL,         -- k_adress_id_r
          'F',          -- edi_enabled
          NULL,         -- ls_versand   Avis??
          NULL,         -- WAEHRUNG
          NULL,         -- KUNDENNRLIEF
          NULL,         -- LIEF_EINK_RABATT_FAKTOR
          NULL,         -- EINK_PREIS_BERECHNEN
          NULL,         -- LIEFERBEDINGUNGEN
          NULL,         -- ZAHLUNGSBEDINGUNGEN
          NULL,         -- UST_ID_NUMMER
          NULL,         -- RG_MWST_TEXT
          NULL,         -- LTE_LHM_NUMMERNKREIS_VON N NUMBER  Y     Beginn des Nummernkreises
          NULL,         -- LTE_LHM_NUMMERNKREIS_BIS N NUMBER  Y     Ende des Nummernkreises
          NULL,         -- LTE_LHM_NUMMERNKREIS_AKTUELL N NUMBER  Y     Aktuelle Nummer innerhalb des Nummernkreises
          NULL,         -- LTE_BARCODE_TYPE N VARCHAR2(10)  Y     Typ des Barcodes (CCG, VDA, NVE...)
          NULL,         -- LTE_EIGENER_NR_KREIS N VARCHAR2(1) Y     'T' => bedeutet Kunde hat eigenen Nummernkreis, sonst 'F'
          NULL,         -- LTE_BARCODE_KOPF N VARCHAR2(20)  Y     Basisnummer bei Cerealia 34027453 oder SID
          NULL,         -- LTE_BARCODE_LAENGE N NUMBER(2) Y     Länge des Barcodes inkl. Kopf (Basisnummer, SID etc.)
          NULL,         -- LHM_BARCODE_TYPE N VARCHAR2(10)  Y     Typ des Barcodes für den Karton (CCG, VDA, NVE...)
          NULL,         -- LHM_EIGENER_NR_KREIS N VARCHAR2(1) Y     'T' => bedeutet Kunde hat eigenen Nummernkreis, sonst 'F'
          NULL,         -- LHM_BARCODE_KOPF N VARCHAR2(20)  Y     Basisnummer für den Karton
          NULL,         -- LHM_BARCODE_LAENGE N NUMBER(2) Y     Länge des Barcodes für den Karton inkl. Kopf  (Basisnummer , SID, etc.)
          'F',          -- ZOLLPFLICHT  N VARCHAR2(1) Y 'F'   N   Ist der Kunde oder Lieferant Zollpflichtig (z.B. muss eine Zollplbe oder Zollpapiere ausgestellt werden)
          NULL);        -- REGION_CODE	N	VARCHAR2(40)	Y			N	N		"Bundesland / Region - Zur Feiertagsfindung z.B.: 

  select seq_adressen_id.currval into Result from dual;

  return(Result);
end isi_adresse_insert;
/



-- sqlcl_snapshot {"hash":"10df06cd9eda595507a2b95f286d80f1a37e3e8a","type":"FUNCTION","name":"ISI_ADRESSE_INSERT","schemaName":"DIRKSPZM32","sxml":""}