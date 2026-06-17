
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_RCV_ARTIKEL_BIU" 
  before insert or update on DIRKSPZM32.s_rcv_artikel
  for each row
declare
  -- local variables here
  v_found             boolean;
  v_sid               isi_sid.sid%type;
  v_artikel           isi_artikel%rowtype;
  v_lte_cfg           lvs_lte_cfg%rowtype;
  v_lhm_cfg           lvs_lhm_cfg%rowtype;

  CURSOR c_sid is
   select s.sid
     from isi_sid s
    where s.sid_my_sid = 1;

  CURSOR c_artikel is
   select *
     from isi_artikel art
    where art.artikel = :new.artikel
       or art.artikel_kurz = :new.artikel_kurz;

  CURSOR c_lte_cfg is
   select *
     from lvs_lte_cfg lte
    where lte.sid = v_sid
      and lte.firma_nr = :new.firma_nr
      and lte.lte_name = nvl(:new.lte_name, v_artikel.lte_name);

  CURSOR c_lhm_cfg is
   select *
     from lvs_lhm_cfg lhm
    where lhm.sid = v_sid
      and lhm.firma_nr = :new.firma_nr
      and lhm.lhm_name = nvl(:new.lhm_name, v_artikel.lhm_name);

begin
  -- sid
  OPEN c_sid;
  FETCH c_sid into v_sid;
  v_found := c_sid%FOUND;
  CLOSE c_sid;

  if not v_found then
    v_sid := '01';
  end if;

  -- c_artikel
  OPEN c_artikel;
  FETCH c_artikel into v_artikel;
  v_found := c_artikel%FOUND;
  CLOSE c_artikel;

  if :new.stueckzahl_pro_preis is NULL
  then
    :new.stueckzahl_pro_preis := 1;
  end if;

  if not v_found then
    insert into isi_artikel art
         values (
                v_sid,                -- SID              VARCHAR2(2) not null,
                NULL,
                :new.artikel,         -- ARTIKEL          VARCHAR2(20) not null,
                NULL,                 -- BEZEICHNUNG1         VARCHAR2(50),
                NULL,                 -- BEZEICHNUNG2         VARCHAR2(50),
                NULL,                 -- BEZEICHNUNG3         VARCHAR2(50),
                NULL,                 -- MATERIALART          VARCHAR2(20),
                :new.lhm_name,        -- LHM_NAME         VARCHAR2(10) not null,
                0,                    -- LHM_MENGE        NUMBER(10) not null,
                0,                    -- LHM_GEWICHT_KG   NUMBER not null,
                NULL,                 -- LHM_EAN              VARCHAR2(15),
                :new.lte_name,        -- LTE_NAME         VARCHAR2(10) not null,
                0,                    -- LTE_MENGE        NUMBER(10) not null,
                0,                    -- LTE_GEWICHT_KG   NUMBER not null,
                0,                    -- LTE_BREITE_MAX   NUMBER not null,
                0,                    -- LTE_TIEFE_MAX    NUMBER not null,
                0,                    -- LTE_HOEHE_MAX    NUMBER not null,
                0,                    -- LTE_LHM_MENGE    NUMBER(8) not null,
                0,                    -- LTE_LHM_PRO_LAGE NUMBER(2) not null,
                0,                    -- LTE_LHM_LAGEN    NUMBER(2) not null,
                NULL,                 -- LTE_EAN              VARCHAR2(15),
                1,                    -- WERT_KLASSE          NUMBER default 0 not null,
                1,                    -- GEFAHREN_KLASSE      NUMBER default 0 not null,
                'STK',                -- MENGENEINHEIT        VARCHAR2(3) default 'STK' not null,
                NULL,                 -- WAREN_GRUPPE         NUMBER,
                'FW',                 -- WAREN_TYP            VARCHAR2(3) default 'FW' not null,
                NULL,                 -- LGR_SUCH_GRP         NUMBER,
                NULL,                 -- LGR_LETZTER_PLATZ    VARCHAR2(30),
                1,                    -- ABC                  NUMBER default 1 not null,
                1,                    -- MHD_TAGE             NUMBER(10) default 1 not null,
                'F',                  -- LABOR_VORGABE_STATUS VARCHAR2(1) default 'F' not null,
                0,                    -- REIFE_ZEIT_TAGE      NUMBER default 0 not null,
                NULL,                 -- EAN                  VARCHAR2(15),
                -300,                 -- MIN_TEMP             NUMBER(5,1) default -300,
                300,                  -- MAX_TEMP             NUMBER(5,1) default 300,
                nvl(:new.einlagerung,
                               'AR'), -- EINLAGERUNG          VARCHAR2(2) default 'AR',
                0,                    -- MIN_BESTAND          NUMBER default 0 not null,
                0,                    -- MAX_BESTAND          NUMBER default 0 not null,
                0,                    -- EINLAGER_TAGE        NUMBER default 0,
                :new.artikel_kurz,    -- ARTIKEL_KURZ         VARCHAR2(15),
                nvl(:new.menge_basis, 'LKE'),
                                      -- MENGE_BASIS          VARCHAR2(3) default 'LKE' not null,
                nvl(:new.mengeneinheit_basis, 'STK'),
                                      -- MENGENEINHEIT_BASIS  VARCHAR2(10) default 'STK' not null,
                'ALLE;',              -- LAGERORTE            VARCHAR2(70) default 'ALLE;' not null,
                :new.MHD_BERECHNUNG,  -- MHD_BERECHNUNG       VARCHAR2(2) default 'TA',
                NULL,                 -- ARTIKEL_P1           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P2           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P3           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P4           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P5           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P6           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P7           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P8           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P9           VARCHAR2(15),
                NULL,                 -- ARTIKEL_P10          VARCHAR2(15)
                NULL,                 -- INVENTUR_DATUM       DATE,
                NULL,                 -- INVENTUR_USER_ID     NUMBER,
                NULL,                 -- MIN_MHD_TAGE_AUSL    NUMBER,
                NULL,                 -- MIN_MHD_TAGE_MS      NUMBER
                :new.aktiv,           -- aktiv                VARCHAR2(1)
                :new.zeichnung,       -- zeichnung            VARCHAR2(255)
                :new.zeichnung_index, -- zeichnung_index      VARCHAR2(10)
                :new.lte_hoehe_lage,  -- LHM_HOEHE_LAGE       NUMBER
                :new.anz_etikett_je_lte, -- ANZ_ETIKETT_JE_LTE      NUMBER
                null,                 -- akt_inventur_id
                null,                 -- letzte_inventur_id
                null,                 -- lte_namen
                null,                 -- lhm_namen
                :new.MHD_FESTES_DATUM,-- Dieser Artikel bekommt immer dieses Datum fest eingestellt als MHD
                :new.RES_ARTIKEL,     -- Reservierung der Lagerplätze über Artikel (Achtung, FW Artikel kann auch HW sein (Arbeitsgang) darum auch FA_AG mit abspeichern
                :new.RES_CHARGE,      -- Reservierung der Lagerplätze über Charge (Chargenrein)
                :new.RES_SERIE,       -- Reservierung der Lagerplätze über Seriennummer
                :new.RES_FA_AUFTRAG,  -- Reservierung der Lagerplätze über Auftragsnummer
                :new.RES_KUNDE,       -- Reservierung der Lagerplätze über Kunde
                :new.RES_MHD,         -- Reservierung der Lagerplätze über MHD
                :new.RES_MHD_TAGE,    -- Reservierung der Lagerplätze über MHD Wie lange werden MHD's als gleich betrachtet
                :new.ABFUELL_ABSCHALT_GROB,   --  Absch. Grob
                :new.ABFUELL_ABSCHALT_MITTEL,--  Absch. Mittel
                :new.ABFUELL_ABSCHALT_FEIN,  --  Absch. Fein
                :new.ABFUELL_TOLERANZ_PLUS,  --  Toleranz Plus
                :new.ABFUELL_TOLERANZ_MINUS, -- Toleranz Minus
                :new.ABFUELL_SOLL,           -- Abfüllgewicht soll
                :new.art_gruppe_id,          -- ART_GRUPPE_ID           NUMBER
                null,                 -- Einzelgewicht
                'U',                  -- Ersatzteil Kennzeichen (U = unbekannt/undefiniert) -WK- 20080910 für Huf benötigt
                :new.preis_standard,  -- PREIS_STANDARD    NUMBER,
                :new.preis_gleitend,  -- PREIS_GLEITEND    NUMBER
                :new.res_string,      -- RES_STRING  VARCHAR2(50)
                :new.created_date,    -- ERZ_DATUM
                -1,                   -- ERZ_LOGINID Def. Login_ID wenn Schnittstelle
                NULL,                 -- AEND_DATUM  Neu noch nicht geändert
                NULL,                 -- AEND_LOGINID Neu noch nicht geändert
                NULL,                 -- LGR_ORT_VORGABE
                NULL,                 -- VERK_PREIS
                NULL,                 -- VERK_RABATT_FAKTOR
                NULL,                 -- DEFAULT_LIEFERANT_ID
                :new.packschema_kopf_id,
                :new.laenge,          -- ART_LAENGE  N  NUMBER  Y      Länge
                :new.breite,          -- ART_BREITE  N  NUMBER  Y      Breite
                :new.hoehe,           -- ART_DICKE  N  NUMBER  Y      Dicke
                :new.durch,           -- ART_DURCH  N  NUMBER  Y      Durchmesser
                :new.pack_vorschr,    -- PACK_VORSCHR  N  VARCHAR2(15)  Y      Verpackungsvorschrift
                :new.herstell_kosten,
                :new.beschaffungs_kosten,
                :new.wieder_besch,
                nvl(:new.stueckzahl_pro_preis, 1), -- STUECKZAHL_PRO_PREIS
                :new.opt_grp,                      -- Optimierungsgruppe
                :new.lhm_tara,                      -- Tara für Verwiegung
                null,                 -- einsatzgewicht_kg
                null,                 -- leg_zuschlag_p_1000kg
                null,                 -- leg_zuschlag_artikel_id
                :new.artikel_fuer_kunde, -- artikel_fuer_kunde
                :new.laufrichtung,
                :new.lam_sel1,
                :new.lam_sel2,
                :new.lam_sel3,
                :new.lam_sel4,
                :new.lam_sel5,
                :new.lam_sel6,
                :new.lam_sel7,
                :new.lam_sel8,
                :new.lam_sel9,
                :new.lam_sel10,
                :new.artikel_fuer_kunde_etikett
                )

                returning art.artikel_id
           into v_artikel.artikel_id;
    OPEN c_artikel;
    FETCH c_artikel into v_artikel;
    --v_found := c_artikel%FOUND;
    CLOSE c_artikel;
  end if;

  OPEN c_lte_cfg;
  FETCH c_lte_cfg into v_lte_cfg;
  CLOSE c_lte_cfg;

  OPEN c_lhm_cfg;
  FETCH c_lhm_cfg into v_lhm_cfg;
  CLOSE c_lhm_cfg;

  if  nvl(:new.lte_lhm_menge, 0) = 0
  and :new.lte_menge > 0
  and :new.lhm_menge > 0 then
    :new.lte_lhm_menge := :new.lte_menge / :new.lhm_menge;
  end if;

  begin
    if  nvl(:new.lte_lhm_pro_lage, 0) = 0
    and :new.lte_lhm_menge > 0
    and :new.lte_lhm_lagen > 0 then
      :new.lte_lhm_pro_lage := :new.lte_lhm_menge / :new.lte_lhm_lagen;
    end if;
  exception
    when others then
      :new.lte_lhm_pro_lage := 0;
  end;

  v_artikel.lhm_gewicht_kg := nvl(:new.lhm_gewicht_kg, nvl(v_artikel.lhm_gewicht_kg, 0))
                              + nvl(v_lhm_cfg.lhm_gew_kg, 0);

  if nvl(:new.lte_gewicht_kg, 0 ) = 0
  then
    v_artikel.lte_gewicht_kg      := v_artikel.lhm_gewicht_kg * nvl(:new.lte_lhm_menge, nvl(v_artikel.lte_lhm_menge, 0))
                                                              + nvl(v_lte_cfg.lte_gew_kg, 0);
  else
    v_artikel.lte_gewicht_kg      := :new.lte_gewicht_kg;
  end if;


  v_artikel.lte_breite_max       := nvl(:new.lte_breite_max, nvl(v_artikel.lte_breite_max, v_lte_cfg.lte_vol_breite));
  if nvl(v_artikel.lte_breite_max, 0) < v_lte_cfg.lte_vol_breite
  then
    v_artikel.lte_breite_max := v_lte_cfg.lte_vol_breite;
  end if;
  v_artikel.lte_tiefe_max        := nvl(:new.lte_tiefe_max, nvl(v_artikel.lte_tiefe_max, v_lte_cfg.lte_vol_tiefe));
  if nvl(v_artikel.lte_tiefe_max, 0) < v_lte_cfg.lte_vol_tiefe
  then
    v_artikel.lte_tiefe_max := v_lte_cfg.lte_vol_tiefe;
  end if;
  if nvl(:new.lte_hoehe_max, 0) = 0
  then
    v_artikel.lte_hoehe_max        := nvl(v_lte_cfg.lte_vol_hoehe, 0) + nvl(:new.lte_lhm_lagen, 1)
                                                                      * nvl(:new.lte_hoehe_lage, 0);
  else
    v_artikel.lte_hoehe_max := :new.lte_hoehe_max;
  end if;
  v_artikel.lhm_hoehe_lage       := nvl(:new.lte_hoehe_lage, v_artikel.lhm_hoehe_lage);

  if isi_allg.c_get_firma_cfg_param (v_sid,
                                     :new.firma_nr,
                                     'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                     NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                     'S_HOST_ART_PX_NULL',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                     'HOST_DB',             -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                     'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                     'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                     'BOOLEAN') = c.C_FALSE -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
  then
    v_artikel.artikel_p1 := nvl(v_artikel.artikel_p1, :new.artikel_p1);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p2 := nvl(v_artikel.artikel_p2, :new.artikel_p2);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p3 := nvl(v_artikel.artikel_p3, :new.artikel_p3);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p4 := nvl(v_artikel.artikel_p4, :new.artikel_p4);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p5 := nvl(v_artikel.artikel_p5, :new.artikel_p5);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p6 := nvl(v_artikel.artikel_p6, :new.artikel_p6);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p7 := nvl(v_artikel.artikel_p7, :new.artikel_p7);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p8 := nvl(v_artikel.artikel_p8, :new.artikel_p8);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p9 := nvl(v_artikel.artikel_p9, :new.artikel_p9);                      -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p10 := nvl(v_artikel.artikel_p10, :new.artikel_p10);                   -- ARTIKEL_P1           VARCHAR2(15),

  else
    v_artikel.artikel_p1 := :new.artikel_p1;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p2 := :new.artikel_p2;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p3 := :new.artikel_p3;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p4 := :new.artikel_p4;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p5 := :new.artikel_p5;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p6 := :new.artikel_p6;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p7 := :new.artikel_p7;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p8 := :new.artikel_p8;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p9 := :new.artikel_p9;                                                 -- ARTIKEL_P1           VARCHAR2(15),
    v_artikel.artikel_p10 := :new.artikel_p10;                                               -- ARTIKEL_P1           VARCHAR2(15),

  end if;

  update isi_artikel art
     set                                                                                   -- SID                  VARCHAR2(2) not null,
         art.artikel              = nvl(:new.artikel, art.artikel),                        -- ARTIKEL              VARCHAR2(20) not null,
         art.bezeichnung1         = :new.bezeichnung1,                                     -- BEZEICHNUNG1         VARCHAR2(50),
         art.bezeichnung2         = :new.bezeichnung2,                                     -- BEZEICHNUNG2         VARCHAR2(50),
         art.bezeichnung3         = :new.bezeichnung3,                                     -- BEZEICHNUNG3         VARCHAR2(50),
         art.materialart          = :new.materialart,                                      -- MATERIALART          VARCHAR2(20),
         art.lhm_name             = nvl(:new.lhm_name, art.lhm_name),                      -- LHM_NAME             VARCHAR2(10) not null,
         art.lhm_menge            = nvl(:new.lhm_menge, art.lhm_menge),                    -- LHM_MENGE            NUMBER(10) not null,
         art.lhm_gewicht_kg       = v_artikel.lhm_gewicht_kg,                              -- LHM_GEWICHT_KG       NUMBER not null,
         art.lhm_ean              = :new.lhm_ean,                                          -- LHM_EAN              VARCHAR2(15),
         art.lte_name             = nvl(:new.lte_name, art.lte_name),                      -- LTE_NAME             VARCHAR2(10) not null,
         art.lte_menge            = nvl(:new.lte_menge, art.lte_menge),                    -- LTE_MENGE            NUMBER(10) not null,
         art.lte_gewicht_kg       = v_artikel.lte_gewicht_kg,                              -- LTE_GEWICHT_KG       NUMBER not null,
         art.lte_breite_max       = v_artikel.lte_breite_max,                              -- LTE_BREITE_MAX       NUMBER not null,
         art.lte_tiefe_max        = v_artikel.lte_tiefe_max,                               -- LTE_TIEFE_MAX        NUMBER not null,
         art.lte_hoehe_max        = v_artikel.lte_hoehe_max,                               -- LTE_HOEHE_MAX        NUMBER not null,
         art.lte_lhm_menge        = nvl(:new.lte_lhm_menge, art.lte_lhm_menge),            -- LTE_LHM_MENGE        NUMBER(8) not null,
         art.lte_lhm_pro_lage     = nvl(:new.lte_lhm_pro_lage, art.lte_lhm_pro_lage),      -- LTE_LHM_PRO_LAGE     NUMBER(2) not null,
         art.lte_lhm_lagen        = nvl(:new.lte_lhm_lagen, art.lte_lhm_lagen),            -- LTE_LHM_LAGEN        NUMBER(2) not null,
         art.lte_ean              = :new.lte_ean,                                          -- LTE_EAN              VARCHAR2(15),
         art.wert_klasse          = nvl(:new.wert_klasse, art.wert_klasse),                -- WERT_KLASSE          NUMBER default 0 not null,
         art.gefahren_klasse      = nvl(:new.gefahren_klasse, art.gefahren_klasse),        -- GEFAHREN_KLASSE      NUMBER default 0 not null,
         art.mengeneinheit        = nvl(:new.mengeneinheit, art.mengeneinheit),            -- MENGENEINHEIT        VARCHAR2(3) default 'STK' not null,
         art.waren_gruppe         = :new.waren_gruppe,                                     -- WAREN_GRUPPE         NUMBER,
         art.waren_typ            = nvl(:new.waren_typ, art.waren_typ),                    -- WAREN_TYP            VARCHAR2(3) default 'FW' not null,
                                                                                           -- LGR_SUCH_GRP         NUMBER,
                                                                                           -- LGR_LETZTER_PLATZ    VARCHAR2(30),
         art.abc                  = decode(:new.abc,'C', 3,
                                                    'c', 3,
                                                    'B', 2,
                                                    'b', 2,
                                                    'A', 1,
                                                    'a', 1,
                                                    art.abc),                              -- ABC                  NUMBER default 1 not null,
         art.mhd_tage             = nvl(:new.mhd_tage, nvl(art.mhd_tage, 1)),              -- MHD_TAGE             NUMBER(10) default 1 not null,
         art.labor_vorgabe_status = nvl(:new.labor_vorg_status,
                                        nvl(art.labor_vorgabe_status, 'F')),               -- LABOR_VORGABE_STATUS VARCHAR2(1) default 'F' not null,
         art.reife_zeit_tage      = nvl(:new.reife_zeit_tage, nvl(art.reife_zeit_tage, 0)),-- REIFE_ZEIT_TAGE      NUMBER default 0 not null,
         -- -AG- 21.08.2009 Ref ist immer der Host. Löschumg muss möglich sein, um diesen EAN einer anderen Artikelnummer zuweisen zu können
         art.ean                  = :new.ean,                                              -- EAN                  VARCHAR2(15),
         art.min_temp             = nvl(:new.min_lager_temp, art.min_temp),                -- MIN_TEMP             NUMBER(5,1) default -300,
         art.max_temp             = nvl(:new.max_lager_temp, art.max_temp),                -- MAX_TEMP             NUMBER(5,1) default 300,
         art.einlagerung          = nvl(:new.einlagerung, 'AR'),                           -- EINLAGERUNG          VARCHAR2(2) default 'AR',
                                                                                           -- MIN_BESTAND          NUMBER default 0 not null,
                                                                                           -- MAX_BESTAND          NUMBER default 0 not null,
                                                                                           -- EINLAGER_TAGE        NUMBER default 0,
                                                                                           -- ARTIKEL_KURZ         VARCHAR2(15),
         art.menge_basis          = nvl(:new.menge_basis, v_artikel.menge_basis),          -- MENGE_BASIS          VARCHAR2(3) default 'LKE' not null,
         art.mengeneinheit_basis  = nvl(:new.mengeneinheit_basis,
                                          decode(nvl(:new.menge_basis, v_artikel.menge_basis), 'LKE',
                                           nvl(art.mengeneinheit, v_artikel.mengeneinheit),
                                           nvl(art.mengeneinheit_basis, v_artikel.mengeneinheit_basis))),
                                                                                           -- MENGENEINHEIT_BASIS  VARCHAR2(10) default 'STK' not null,
                                                                                           -- LAGERORTE            VARCHAR2(70) default 'ALLE;' not null,
                                                                                           -- MHD_BERECHNUNG       VARCHAR2(2) default 'TA',
         art.artikel_p1 = v_artikel.artikel_p1,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p2 = v_artikel.artikel_p2,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p3 = v_artikel.artikel_p3,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p4 = v_artikel.artikel_p4,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p5 = v_artikel.artikel_p5,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p6 = v_artikel.artikel_p6,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p7 = v_artikel.artikel_p7,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p8 = v_artikel.artikel_p8,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p9 = v_artikel.artikel_p9,                                            -- ARTIKEL_P1           VARCHAR2(15),
         art.artikel_p10 = v_artikel.artikel_p10,                                          -- ARTIKEL_P1           VARCHAR2(15),
                                                                                           -- NULL,                 -- INVENTUR_DATUM       DATE,
                                                                                           -- NULL,                 -- INVENTUR_USER_ID     NUMBER,
                                                                                           -- NULL,                 -- MIN_MHD_TAGE_AUSL    NUMBER,
                                                                                           -- NULL,                 -- MIN_MHD_TAGE_MS      NUMBER
         art.lhm_hoehe_lage = nvl(:new.lte_hoehe_lage, v_artikel.lhm_hoehe_lage),          -- lhm_hoehe_lage
         art.aktiv = :new.aktiv,                                                           -- :new.aktiv,           -- aktiv                VARCHAR2(1)
         art.zeichnung = :new.zeichnung,                                                   -- NULL,                 -- zeichnung            VARCHAR2(255)
         art.zeichnung_index = :new.zeichnung_index,                                       -- NULL,                 -- zeichnung_index      VARCHAR2(10)
         art.anz_etikett_je_lte = :new.anz_etikett_je_lte,                                 -- ANZ_ETIKETT_JE_LTE      NUMBER,
                                                                                           -- AKT_INVENTUR_ID         NUMBER,
                                                                                           -- LETZTE_INVENTUR_ID      NUMBER,
         art.mhd_festes_datum = :new.MHD_FESTES_DATUM,                                     -- MHD_FESTES_DATUM        DATE,
         art.res_artikel = :new.RES_ARTIKEL,                                               -- RES_ARTIKEL             CHAR(1),
         art.res_charge = :new.RES_CHARGE,                                                 -- RES_CHARGE              CHAR(1),
         art.res_serie = :new.RES_SERIE,                                                   -- RES_SERIE               CHAR(1),
         art.res_fa_auftrag = :new.RES_FA_AUFTRAG,                                         -- RES_FA_AUFTRAG          CHAR(1),
         art.res_kunde = :new.RES_KUNDE,                                                   -- RES_KUNDE               CHAR(1),
         art.res_mhd = :new.RES_MHD,                                                       -- RES_MHD                 CHAR(1),
         art.res_mhd_tage = :new.RES_MHD_TAGE,                                             -- RES_MHD_TAGE            NUMBER,
         art.abfuell_abschalt_grob = nvl(:new.ABFUELL_ABSCHALT_GROB,
                                         art.abfuell_abschalt_grob),                       -- ABFUELL_ABSCHALT_GROB   NUMBER,
         art.abfuell_abschalt_mittel = nvl(:new.ABFUELL_ABSCHALT_MITTEL,
                                           art.abfuell_abschalt_mittel),                   -- ABFUELL_ABSCHALT_MITTEL NUMBER,
         art.abfuell_abschalt_fein = nvl(:new.ABFUELL_ABSCHALT_FEIN,
                                         art.abfuell_abschalt_fein),                           -- ABFUELL_ABSCHALT_FEIN   NUMBER,
         art.abfuell_toleranz_plus = nvl(:new.ABFUELL_TOLERANZ_PLUS,
                                         art.abfuell_toleranz_plus),                           -- ABFUELL_TOLERANZ_PLUS   NUMBER,
         art.abfuell_toleranz_minus = nvl(:new.ABFUELL_TOLERANZ_MINUS,
                                          art.abfuell_toleranz_minus),                         -- ABFUELL_TOLERANZ_MINUS  NUMBER
         art.abfuell_soll = nvl(:new.ABFUELL_SOLL,
                                art.abfuell_soll),                                             -- ABFUELL_SOLL            NUMBER
         art.art_gruppe_id = nvl(:new.art_gruppe_id,
                                 art.art_gruppe_id),                                       -- ART_GRUPPE_ID           NUMBER
         art.preis_standard = :new.preis_standard,
         art.preis_gleitend = :new.preis_gleitend,
         art.res_string     = nvl(:new.res_string,
                                  art.res_string),
         art.erz_datum      = :new.created_date,
         art.aend_datum     = :new.last_change_date,
         art.aend_login_id  = :new.last_change_login_id,
         art.herstell_kosten = nvl(:new.herstell_kosten, art.herstell_kosten),
         art.beschaffungs_kosten = nvl(:new.beschaffungs_kosten, art.beschaffungs_kosten),
         art.wieder_besch = nvl(:new.wieder_besch, art.wieder_besch),
         art.stueckzahl_pro_preis = nvl(:new.stueckzahl_pro_preis, art.stueckzahl_pro_preis),
         art.packschema_kopf_id = nvl(:new.packschema_kopf_id, art.packschema_kopf_id),
         art.pack_vorschr = nvl(:new.pack_vorschr, art.pack_vorschr),
         art.lhm_tara = nvl(:new.lhm_tara, art.lhm_tara),
         art.min_mhd_tage_ausl = nvl(:new.min_mhd_tage_ausl, art.min_mhd_tage_ausl),
         art.min_mhd_tage_ms = nvl(:new.min_mhd_tage_ms, art.min_mhd_tage_ms),
         art.artikel_fuer_kunde = :new.artikel_fuer_kunde,
         art.artikel_fuer_kunde_etikett = :new.artikel_fuer_kunde_etikett
   where art.sid        = v_sid
     and art.artikel_id = v_artikel.artikel_id;
end TR_S_RCV_ARTIKEL_BIU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_RCV_ARTIKEL_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"7c8ece36b714a0be5d980eb7aaa1a24be5424a62","type":"TRIGGER","name":"TR_S_RCV_ARTIKEL_BIU","schemaName":"DIRKSPZM32","sxml":""}