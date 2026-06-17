
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_ADR_BIU" 
  before insert or update or delete on DIRKSPZM32.S_ERP_RCV_ADR
  for each row
declare
  v_found             boolean;
  v_adr               isi_adressen%rowtype;
  v_adr_nr            isi_adressen.adr_nr%type;
  v_adr_lief          isi_adressen.adr_liefer%type;
  v_ende_pos          number;

  cursor c_s_adr is
    select t.adr_nr
      from s_rcv_adr t
     where t.adr_nr = :new.ADR_NR
       and t.adr_art = :new.adr_art
       and t.adr_liefer = nvl(:new.adr_liefer, 0);

  cursor c_adr is
    select t.*
      from isi_adressen t
     where t.firma_nr = :new.firma_nr
       and t.adr_art = 'W'                       -- Warenempfänger
       and t.adr_nr = nvl(:new.ADR_LIEFER, 0)
       and t.adr_liefer = nvl(:new.ADR_LIEFER, 0);

  cursor c_adr_d is
    select t.*
      from isi_adressen t
     where t.firma_nr = :new.firma_nr
       and t.adr_art = 'K'                       -- Warenempfänger
       and t.adr_nr = nvl(:new.ADR_LIEFER, 0)
       and t.adr_liefer = '0';
begin
  if updating or inserting
    then
        if inserting
        then
          if :new.created_date is NULL
          then
            :new.created_date := sysdate;
          end if;
          if :new.created_login_id is NULL
          then
            :new.created_login_id := -1;
          end if;
        end if;
        if updating
        then
          if :new.last_change_date = :old.last_change_date
          or :new.last_change_date is NULL
          then
            :new.last_change_date := sysdate;
          end if;
        end if;
    -- :new.firma_nr := 1;

    -- Im SAP kommen 'K'unden, 'L'ieferanten und 'W'arenempfaenger
    -- Die Lieferadressen kommen ohne Daten -> Referenzlesen in den Adressen Satzart 'W'arenempfaenger
    v_adr_lief := :new.ADR_LIEFER;
    /*
    if :new.ADR_ART = 'K'
    then
      :new.ADR_LIEFER := 0;
    end if;
    */

    if :new.ADR_ART = 'K'
    and nvl(:new.ADR_LIEFER, 0) != '0'                  -- Lieferadresse dann Warenempfaenger lesen
    then
      open c_adr;
      fetch c_adr into v_adr;
      v_found := c_adr%FOUND;
      close c_adr;
      -- Adressenangaben fehler
      if v_found
      then
        :new.NAME_1 := v_adr.name_1;
        :new.NAME_2 := v_adr.name_2;
        :new.NAME_3 := v_adr.name_3;
        :new.STRASSE := v_adr.strasse;
        :new.PLZ := v_adr.plz;
        :new.ORT := v_adr.ort;
        :new.AKTIV := v_adr.aktiv;
        :new.ANSPR := v_adr.anspr;
        :new.EMAIL := v_adr.email;
        :new.TEL := v_adr.tel;
        :new.FAX := v_adr.fax;
        :new.land_kurz := v_adr.land_kurz;
      end if;
    end if;

    OPEN c_s_adr;
    fetch c_s_adr into v_adr.adr_nr;
    v_found := c_s_adr%found;
    close c_s_adr;

    if not v_found
    then

      if :new.ADR_NR != nvl(:new.ADR_LIEFER, 0)
      or :new.ADR_ART = 'W'                      -- Warenempfänger
      then
        insert into s_rcv_adr
             values (
                    :new.FIRMA_NR,
                    :new.ADR_ART,
                    :new.ADR_NR,
                    nvl(:new.ADR_LIEFER, 0),
                    :new.NAME_1,
                    :new.NAME_2,
                    :new.NAME_3,
                    :new.STRASSE,
                    :new.PLZ,
                    :new.ORT,
                    decode(:new.AKTIV,
                           'Y', 'T',
                           'N', 'F',
                           nvl(:new.AKTIV, 'T')),
                    :new.ANSPR,
                    :new.EMAIL,
                    :new.TEL,
                    :new.FAX,
                    :new.land,
                    :new.land_kurz,
                    :new.lhm_etiketten_layout,
                    :new.lte_etiketten_layout,
                    :new.edi_enabled,
                    :new.edi_gln,
                    :new.edi_gln_b,
                    :new.adress_id_h,
                    :new.edi_gln_r,
                    :new.avis,
                    :new.lte_etiketten_name,
                    :new.lhm_etiketten_name,
                    :new.lte_etiketten_typ,
                    :new.lhm_etiketten_typ,
                    :new.info_1,
                    :new.waehrung,
                    :new.kundennrlief,
                    :new.lief_eink_rabatt_faktor,
                    :new.eink_preis_berechnen,
                    :new.lieferbedingungen,
                    :new.zahlungsbedingungen,
                    :new.ust_id_nummer,
                    :new.rg_mwst_text);
      end if;
    end if;

    OPEN c_s_adr;
    fetch c_s_adr into v_adr.adr_nr;
    v_found := c_s_adr%found;
    close c_s_adr;

    update s_rcv_adr a
       set a.name_1 = :new.NAME_1,
           a.name_2 = :new.NAME_2,
           a.name_3 = :new.NAME_3,
           a.strasse = :new.STRASSE,
           a.plz = :new.PLZ,
           a.ort = :new.ORT,
           a.aktiv =  decode(:new.AKTIV,
                             'Y', 'T',
                             'N', 'F',
                             nvl(:new.AKTIV, 'T')),
           a.anspr = :new.ANSPR,
           a.email = :new.EMAIL,
           a.tel = :new.TEL,
           a.fax = :new.FAX,
           a.land_kurz = :new.land_kurz
     where a.firma_nr = :new.FIRMA_NR
       and a.adr_art = :new.ADR_ART
       and a.adr_nr = :new.ADR_NR
       and a.adr_liefer = nvl(:new.ADR_LIEFER, 0);

    if :new.ADR_ART = 'W'                      -- Warenempfänger
    then
      :new.ADR_ART := 'K';
      v_adr_nr := :new.adr_nr;

      v_ende_pos := INSTR(:new.adr_nr, '-', 1, 1) - 1;
      if v_ende_pos > 0
      then
        :new.adr_nr := substr(:new.adr_nr, 1, v_ende_pos);
      end if;

      OPEN c_s_adr;
      fetch c_s_adr into v_adr.adr_nr;
      v_found := c_s_adr%found;
      close c_s_adr;

      if not v_found
      then

        insert into s_rcv_adr
             values (
                    :new.FIRMA_NR,
                    :new.ADR_ART,
                    :new.ADR_NR,
                    nvl(:new.ADR_LIEFER, 0),
                    :new.NAME_1,
                    :new.NAME_2,
                    :new.NAME_3,
                    :new.STRASSE,
                    :new.PLZ,
                    :new.ORT,
                    decode(:new.AKTIV,
                           'Y', 'T',
                           'N', 'F',
                           nvl(:new.AKTIV, 'T')),
                    :new.ANSPR,
                    :new.EMAIL,
                    :new.TEL,
                    :new.FAX,
                    :new.land,
                    :new.land_kurz,
                    :new.lhm_etiketten_layout,
                    :new.lte_etiketten_layout,
                    :new.edi_enabled,
                    :new.edi_gln,
                    :new.edi_gln_b,
                    :new.adress_id_h,
                    :new.edi_gln_r,
                    :new.avis,
                    :new.lte_etiketten_name,
                    :new.lhm_etiketten_name,
                    :new.lte_etiketten_typ,
                    :new.lhm_etiketten_typ,
                    :new.info_1,
                    :new.waehrung,
                    :new.kundennrlief,
                    :new.lief_eink_rabatt_faktor,
                    :new.eink_preis_berechnen,
                    :new.lieferbedingungen,
                    :new.zahlungsbedingungen,
                    :new.ust_id_nummer,
                    :new.rg_mwst_text);
      end if;

      OPEN c_s_adr;
      fetch c_s_adr into v_adr.adr_nr;
      v_found := c_s_adr%found;
      close c_s_adr;

      update s_rcv_adr adr
         set                                -- SID                VARCHAR2(2) not null,
                                            -- ADRESS_ID          NUMBER not null,
                                            -- FIRMA_NR           NUMBER(2) not null,
                                            -- ADR_ART            VARCHAR2(1) not null,
                                            -- ADR_NR             VARCHAR2(20) not null,
                                            -- ADR_LIEFER         VARCHAR2(20) not null,
             adr.name_1    = :new.name_1,   -- NAME_1             VARCHAR2(40),
             adr.name_2    = :new.name_2,   -- NAME_2             VARCHAR2(40),
             adr.name_3    = :new.name_3,   -- NAME_3             VARCHAR2(40),
             adr.strasse   = :new.strasse,  -- STRASSE            VARCHAR2(40),
             adr.plz       = :new.plz,      -- PLZ                VARCHAR2(10),
             adr.ort       = :new.ort,      -- ORT                VARCHAR2(40),
             adr.aktiv     = :new.aktiv,    -- AKTIV              VARCHAR2(1),
             adr.anspr     = :new.anspr,    -- ANSPR              VARCHAR2(40),
             adr.email     = :new.email,    -- EMAIL              VARCHAR2(40),
             adr.tel       = :new.tel,      -- TEL                VARCHAR2(40),
             adr.fax       = :new.fax,      -- FAX                VARCHAR2(40),
             adr.lte_etiketten_name
                           = :new.lte_etiketten_name,
                                            -- LTE_ETIKETTEN_NAME VARCHAR2(50),
             adr.lhm_etiketten_name
                           = :new.lhm_etiketten_name,
                                            -- LHM_ETIKETTEN_NAME VARCHAR2(50),
                                            -- EXT_ETIKETTEN_DRUCK        VARCHAR2(1) default 'F' not null,
                                            -- CHARGE_LTE_ID_LIEF_TAUSCH  VARCHAR2(1) default 'F' not null,
                                            -- ISIPLUS_MODULE             VARCHAR2(255),
             adr.lte_etiketten_typ
                           = :new.lte_etiketten_typ,
                                            -- LTE_ETIKETTEN_TYP          VARCHAR2(50),
                                            -- LTE_ETIKETTEN_SPEZ_BARCODE VARCHAR2(50),
             adr.lhm_etiketten_typ
                           = :new.lhm_etiketten_typ,
                                            -- LHM_ETIKETTEN_TYP          VARCHAR2(50),
                                            -- LHM_ETIKETTEN_SPEZ_BARCODE VARCHAR2(50),
             adr.land      = :new.land,     -- LAND               VARCHAR2(40),
             adr.land_kurz = :new.land_kurz, -- LAND_KURZ                  VARCHAR2(10)
             adr.info_1    = :new.info_1,    -- INFO_1                     VARCHAR2(100)
             adr.lhm_etiketten_layout
                           = :new.lhm_etiketten_layout,
             adr.lte_etiketten_layout
                           = :new.lte_etiketten_layout,
  --           adr.ecc_hersteller_id =
  --                           :new.ecc_hersteller_id, -- ECC_HERSTELLER_ID          VARCHAR2(10),
             adr.edi_gln   = :new.edi_gln,           -- EDI_GLN                    VARCHAR2(20),
             adr.edi_gln_b = :new.edi_gln_b,         -- EDI_GLN_B                  VARCHAR2(20),
             adr.adress_id_h
                           = :new.adress_id_h,       -- ADRESS_ID_H                NUMBER,
             adr.edi_gln_r = :new.edi_gln_r,         -- EDI_GLN_R                  VARCHAR2(20),
             adr.edi_enabled
                           = nvl(:new.edi_enabled, 'F'), -- EDI_ENABLED                VARCHAR2(1) default 'F' not null,
             adr.avis      = nvl(:new.avis, adr.avis),   -- AVIS                       VARCHAR2(10)
             adr.waehrung  = nvl(:new.waehrung, adr.waehrung), -- WAEHRUNG  N VARCHAR2(5) Y     Währung EUR, USD, ...
             adr.kundennrlief = nvl(:new.kundennrlief, adr.kundennrlief), -- KUNDENNRLIEF N VARCHAR2(20)  Y     Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden
             adr.lief_eink_rabatt_faktor = nvl(:new.lief_eink_rabatt_faktor, adr.lief_eink_rabatt_faktor), -- LIEF_EINK_RABATT_FAKTOR N NUMBER  Y     Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis
             adr.eink_preis_berechnen = nvl(:new.eink_preis_berechnen, adr.eink_preis_berechnen), -- EINK_PREIS_BERECHNEN N VARCHAR2(1) Y 'F'   Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!
             adr.lieferbedingungen = nvl(:new.lieferbedingungen, adr.lieferbedingungen), -- LIEFERBEDINGUNGEN N VARCHAR2(500) Y     Lieferbedingungen
             adr.zahlungsbedingungen = nvl(:new.zahlungsbedingungen, adr.zahlungsbedingungen),  -- ZAHLUNGSBEDINGUNGEN  N VARCHAR2(500) Y     Zahlungsbedingungen
             adr.ust_id_nummer = nvl(:new.ust_id_nummer, adr.ust_id_nummer), -- UST_ID_NUMMER N VARCHAR2(20)  Y     Umsatzsteuer ID Nummer
             adr.rg_mwst_text = nvl(:new.rg_mwst_text, adr.rg_mwst_text) -- RG_MWST_TEXT  N VARCHAR2(500) Y     Text für Erklärung der MWST Ausland / Inlanf und Europa
         where adr.firma_nr = :new.FIRMA_NR
           and adr.adr_art = :new.ADR_ART
           and adr.adr_nr = :new.ADR_NR
           and adr.adr_liefer = nvl(:new.ADR_LIEFER, 0);
      :new.ADR_ART := 'W';
      :new.adr_nr := v_adr_nr;
    end if;
    :new.ADR_LIEFER := v_adr_lief;

  elsif deleting then
    ---  :old.firma_nr := 1;  ----- Achtung
    delete s_rcv_adr a
     where a.firma_nr = :old.FIRMA_NR
       and a.adr_art = :old.ADR_ART
       and a.adr_nr = :old.ADR_NR
       and a.adr_liefer = nvl(:old.ADR_LIEFER, 0);
  end if;
end TR_S_ERP_RCV_ADR;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_ADR_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"01dd3abd8cb5092b7592015c4568e5af5bc03ee5","type":"TRIGGER","name":"TR_S_ERP_RCV_ADR_BIU","schemaName":"DIRKSPZM32","sxml":""}