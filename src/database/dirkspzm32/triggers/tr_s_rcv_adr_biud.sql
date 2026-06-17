
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_ADR_BIUD" 
  before insert or update or delete on DIRKSPZM32.s_rcv_adr
  for each row
declare
  -- local variables here
  v_found     boolean;
  v_sid       isi_sid.sid%type;
  v_adress_id isi_adressen.adress_id%type;

  CURSOR c_sid is
   select s.sid
     from isi_sid s
    where s.sid_my_sid = 1;

  CURSOR c_adressen is
   select adr.adress_id
     from isi_adressen adr
    where adr.sid        = v_sid
      and adr.firma_nr   = :new.firma_nr
      and adr.adr_art    = :new.adr_art
      and adr.adr_nr     = :new.adr_nr
      and adr.adr_liefer = :new.adr_liefer;
begin
  -- sid
  OPEN c_sid;
  FETCH c_sid into v_sid;
  v_found := c_sid%FOUND;
  CLOSE c_sid;

  if not v_found then
    v_sid := '01';
  end if;

  if inserting or updating then
    -- c_adressen
    OPEN c_adressen;
    FETCH c_adressen into v_adress_id;
    v_found := c_adressen%FOUND;
    CLOSE c_adressen;

    if not v_found then
      insert into isi_adressen (
                  sid,                          -- SID        VARCHAR2(2) not null,
                  firma_nr,                     -- FIRMA_NR   NUMBER(2) not null,
                  adr_art,                      -- ADR_ART    VARCHAR2(1) not null,
                  adr_nr,                       -- ADR_NR     VARCHAR2(20) not null,
                  adr_liefer)                   -- ADR_LIEFER VARCHAR2(20) not null,
           values (
                  v_sid,                        -- SID        VARCHAR2(2) not null,
                  nvl(:new.firma_nr, 0),        -- FIRMA_NR   NUMBER(2) not null,
                  nvl(:new.adr_art, c.LEER),    -- ADR_ART    VARCHAR2(1) not null,
                  nvl(:new.adr_nr, c.LEER),     -- ADR_NR     VARCHAR2(20) not null,
                  nvl(:new.adr_liefer, c.LEER)) -- ADR_LIEFER VARCHAR2(20) not null,
        returning adress_id
             into v_adress_id;
    end if;

    update isi_adressen adr
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
           adr.waehrung  = nvl(:new.waehrung, adr.waehrung), -- WAEHRUNG	N	VARCHAR2(5)	Y			Währung EUR, USD, ...
           adr.kundennrlief = nvl(:new.kundennrlief, adr.kundennrlief), -- KUNDENNRLIEF	N	VARCHAR2(20)	Y			Meine Kundennummer bei Lieferant / meine Lieferantennummer beim Kunden
           adr.lief_eink_rabatt_faktor = nvl(:new.lief_eink_rabatt_faktor, adr.lief_eink_rabatt_faktor), -- LIEF_EINK_RABATT_FAKTOR	N	NUMBER	Y			Vorgabe Eink_Rabatt_Faktor für Berechnung Eink_Preis
           adr.eink_preis_berechnen = nvl(:new.eink_preis_berechnen, adr.eink_preis_berechnen), -- EINK_PREIS_BERECHNEN	N	VARCHAR2(1)	Y	'F'		Vorgabe Artikel_Lieferant.EINK_PREIS Berechnen oder Eingeben.!
           adr.lieferbedingungen = nvl(:new.lieferbedingungen, adr.lieferbedingungen), -- LIEFERBEDINGUNGEN	N	VARCHAR2(500)	Y			Lieferbedingungen
           adr.zahlungsbedingungen = nvl(:new.zahlungsbedingungen, adr.zahlungsbedingungen),  -- ZAHLUNGSBEDINGUNGEN	N	VARCHAR2(500)	Y			Zahlungsbedingungen
           adr.ust_id_nummer = nvl(:new.ust_id_nummer, adr.ust_id_nummer), -- UST_ID_NUMMER	N	VARCHAR2(20)	Y			Umsatzsteuer ID Nummer
           adr.rg_mwst_text = nvl(:new.rg_mwst_text, adr.rg_mwst_text) -- RG_MWST_TEXT	N	VARCHAR2(500)	Y			Text für Erklärung der MWST Ausland / Inlanf und Europa
     where adr.sid       = v_sid
       and adr.adress_id = v_adress_id;
  end if;

  -- If we delete our record or have update in primary key,
  -- we need to set our old record to unactive state.
  if deleting
  or :old.firma_nr   <> :new.firma_nr
  or :old.adr_art    <> :new.adr_art
  or :old.adr_nr     <> :new.adr_nr
  or :old.adr_liefer <> :new.adr_liefer then
    update isi_adressen adr
       set adr.aktiv = c.C_FALSE -- AKTIV VARCHAR2(1),
     where adr.sid        = v_sid
       and adr.firma_nr   = :old.firma_nr
       and adr.adr_art    = :old.adr_art
       and adr.adr_nr     = :old.adr_nr
       and adr.adr_liefer = :old.adr_liefer;
  end if;
end TR_S_RCV_ADR_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_ADR_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"6dfd0dcbeca709a1388c97627411e5b163023c9d","type":"TRIGGER","name":"TR_S_RCV_ADR_BIUD","schemaName":"DIRKSPZM32","sxml":""}