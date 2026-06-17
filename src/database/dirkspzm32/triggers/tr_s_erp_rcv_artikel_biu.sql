
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_ARTIKEL_BIU" 
  before insert or update on DIRKSPZM32.S_ERP_RCV_ARTIKEL
  for each row
declare
  -- local variables here

  v_art                   isi_artikel.artikel%type;
  v_pack_schema           s_ERP_rcv_pack_vorschr.pack_schema%type;

  CURSOR c_artikel is
    select a.artikel
      from s_rcv_artikel a
     where a.artikel = :new.artikel;

  CURSOR c_pack_vorschr is
    select p.pack_schema
      from s_ERP_rcv_pack_vorschr p
     where p.artikel = :new.artikel;

begin
  -- Spez. Default für Euscher
  if :new.MHD_TAGE = 1
  or :new.MHD_TAGE is NULL
  then
    :new.MHD_TAGE := 360;
  end if;
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

    v_art := NULL;
    OPEN c_artikel;
    FETCH c_artikel into v_art;
    CLOSE c_artikel;

    if v_art is NULL -- Noch nicht da
    then
      insert into s_rcv_artikel
           values (
                    :new.FIRMA_NR,
                    :new.ARTIKEL,
                    :new.BEZEICHNUNG1,
                    :new.BEZEICHNUNG2,
                    :new.BEZEICHNUNG3,
                    :new.MATERIALART,
                    :new.LHM_NAME,
                    :new.LHM_MENGE,
                    :new.LHM_GEWICHT_KG,
                    :new.LHM_EAN,
                    :new.LTE_NAME,
                    :new.LTE_LHM_MENGE * :new.LHM_MENGE, --:new.LTE_MENGE,
                    :new.LTE_GEWICHT_KG,
                    :new.LTE_BREITE_MAX,
                    :new.LTE_TIEFE_MAX,
                    :new.LTE_HOEHE_MAX,
                    :new.LTE_LHM_MENGE,
                    :new.LTE_LHM_PRO_LAGE,
                    :new.LTE_LHM_LAGEN,
                    :new.LTE_HOEHE_LAGE,
                    :new.LTE_EAN,
                    :new.WERT_KLASSE,
                    :new.GEFAHREN_KLASSE,
                    :new.MENGENEINHEIT,
                    :new.WAREN_GRUPPE,
                    :new.WAREN_TYP,
                    nvl(:new.ABC, 'A'),
                    :new.MHD_TAGE,
                    :new.LABOR_VORG_STATUS,
                    :new.REIFE_ZEIT_TAGE,
                    :new.EAN,
                    :new.LAENGE,
                    :new.BREITE,
                    :new.HOEHE,
                    NULL,              --:new.VOLUMEN,
                    :new.GEWICHT,
                    decode(:new.AKTIV, 'Y', 'T', 'T', 'T', 'N'),
                    :new.MIN_LAGER_TEMP,
                    :new.MAX_LAGER_TEMP,
                    :new.min_mhd_tage_ausl, -- art.min_mhd_tage_ausl
                    :new.min_mhd_tage_ms,   -- art.min_mhd_tage_ms
                    NULL,
                    NULL,
                    NULL,                        -- ANZ_ETIKETT_JE_LTE      NUMBER
                    :new.ZEICHNUNG,              -- ZEICHNUNG               VARCHAR2(255),
                    :new.ZEICHNUNG_INDEX,        -- ZEICHNUNG_INDEX         VARCHAR2(10),
                    'AR',  -- EINLAGERUNG             VARCHAR2(2),
                    NULL,  -- MHD_FESTES_DATUM        DATE,
                    NULL,  -- ARTIKEL_KURZ            VARCHAR2(20),
                    'TA',  -- MHD_BERECKNUNG          VARCHAR2(2)
                    NULL,  -- RES_ARTIKEL             CHAR(1),
                    NULL,  -- RES_CHARGE              CHAR(1),
                    NULL,  -- RES_SERIE               CHAR(1),
                    NULL,  -- RES_FA_AUFTRAG          CHAR(1),
                    NULL,  -- RES_KUNDE               CHAR(1),
                    NULL,  -- RES_MHD                 CHAR(1),
                    NULL,  -- RES_MHD_TAGE            NUMBER
                    NULL,  -- Absch. Grob
                    NULL,  -- Absch. Mittel
                    NULL,  -- Absch. Fein
                    NULL,  -- Toleranz Plus
                    NULL,  -- Toleranz Minus
                    NULL,  -- SollGewicht Abfüllung
                    NULL,                       -- Parameter P1
                    NULL,                       -- Parameter P2
                    NULL,                       -- Parameter P3
                    NULL,                       -- Parameter P4
                    NULL,                       -- Parameter P5
                    NULL,                       -- Parameter P6
                    NULL,                       -- Parameter P7
                    NULL,                       -- Parameter P8
                    NULL,                       -- Parameter P9
                    NULL,                       -- Parameter P10
                    NULL,                       -- art_gruppe_id
                   :new.preis_standard,         -- PREIS_STANDARD    NUMBER,
                   :new.preis_gleitend,         -- PREIS_GLEITEND    NUMBER
                    null,                       -- res_string
                    null,                       -- Packschema_Kopf_id
                    :new.durch,                 -- DURCH
                    :new.pack_vorschr,          -- PACK_VORSCHR N VARCHAR2(15)  Y     Verpackungsvorschrift
                    :new.wieder_besch,          -- WIEDER_BESCH N NUMBER(10)  Y     Wiederbeschaffungszeit in Tagen
                    :new.herstell_kosten,        -- HERSTELL_KOSTEN N NUMBER(11,5)  Y     Herstell
                    :new.beschaffungs_kosten,
                    1,
                    NULL,
                    :new.lhm_tara,
                    :new.min_mhd_tage_ausl, -- art.min_mhd_tage_ausl
                    :new.min_mhd_tage_ms,   -- art.min_mhd_tage_ms
                    :new.artikel_fuer_kunde,
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
                    :new.artikel_fuer_kunde_etikett,
                    :new.volumen_cm3,          -- VOLUMEN_CM3 N NUMBER(11,2)  Y     N   Volumen in CM3
                    :new.created_date,         -- CREATED_DATE  N DATE  N sysdate   N   Erstelldatum und Zeitstempel wann der Datensatz kreiert wurde
                    :new.created_login_id,     -- CREATED_LOGIN_ID  N NUMBER  N -1    N   Id des Benutzers der diesen Datensatz erstellt hat
                    :new.last_change_date,     -- LAST_CHANGE_DATE  N DATE  Y     N   Änderungsdatum und Zeitstempel wann der Datensatz zuletzt geändert wurde
                    :new.last_change_login_id  -- LAST_CHANGE_LOGIN_ID  N NUMBER  Y     N   Id des Benutzers der diesen Datensatz zuletzt geändert hat
                    );

    end if;
    if :new.MENGENEINHEIT = 'KG'
    then
      if nvl(:new.LHM_MENGE, 0) = 0
      then
        :new.LHM_MENGE := 1;
      end if;
      :new.LHM_GEWICHT_KG := :new.LHM_MENGE;
      :new.GEWICHT := 1000;
    end if;

    v_pack_schema := NULL;
    OPEN c_pack_vorschr;
    FETCH c_pack_vorschr into v_pack_schema;
    CLOSE c_pack_vorschr;

    update s_rcv_artikel a
         set
                  a.bezeichnung1 = :new.BEZEICHNUNG1,
                  a.bezeichnung2 = :new.BEZEICHNUNG2,
                  a.bezeichnung3 = :new.BEZEICHNUNG3,
                  a.materialart = nvl(:new.MATERIALART, a.materialart),
                  a.lhm_name = :new.LHM_NAME,
                  a.lhm_menge = :new.LHM_MENGE,
                  a.lhm_gewicht_kg = :new.LHM_GEWICHT_KG,
                  a.lhm_ean = :new.LHM_EAN,
                  a.lte_name = :new.LTE_NAME,
                  a.lte_menge = :new.LTE_LHM_MENGE * :new.LHM_MENGE, --:new.LTE_MENGE,
                  a.lte_gewicht_kg = :new.LTE_GEWICHT_KG,
                  a.lte_breite_max = :new.LTE_BREITE_MAX,
                  a.lte_tiefe_max = :new.LTE_TIEFE_MAX,
                  a.lte_hoehe_max = :new.LTE_HOEHE_MAX,
                  a.lte_lhm_menge = :new.LTE_LHM_MENGE,
                  a.lte_lhm_pro_lage = :new.LTE_LHM_PRO_LAGE,
                  a.lte_lhm_lagen = :new.LTE_LHM_LAGEN,
                  a.lte_hoehe_lage = :new.LTE_HOEHE_LAGE,
                  a.lte_ean = :new.LTE_EAN,
                  a.wert_klasse = :new.WERT_KLASSE,
                  a.gefahren_klasse = :new.GEFAHREN_KLASSE,
                  a.mengeneinheit = :new.MENGENEINHEIT,
                  a.waren_gruppe = :new.WAREN_GRUPPE,
                  a.waren_typ = :new.WAREN_TYP,
                  a.abc = nvl(:new.ABC, a.abc),
                  a.mhd_tage = :new.MHD_TAGE,
                  a.labor_vorg_status = :new.LABOR_VORG_STATUS,
                  a.reife_zeit_tage = :new.REIFE_ZEIT_TAGE,
                  a.ean = :new.EAN,
                  a.laenge = :new.LAENGE,
                  a.breite = :new.BREITE,
                  a.hoehe = :new.HOEHE,
                  a.gewicht = :new.GEWICHT,
                  a.aktiv = decode(:new.AKTIV, 'Y', 'T', 'T', 'T', 'N'),
                  a.zeichnung =  :new.ZEICHNUNG,              -- ZEICHNUNG               VARCHAR2(255),
                  a.zeichnung_index = :new.ZEICHNUNG_INDEX,   -- ZEICHNUNG_INDEX         VARCHAR2(10),
                  a.min_lager_temp = :new.MIN_LAGER_TEMP,
                  a.max_lager_temp = :new.MAX_LAGER_TEMP,
                  a.preis_standard = :new.preis_standard,
                  a.preis_gleitend = :new.preis_gleitend,
                  a.packschema_kopf_id = v_pack_schema,
                  a.durch = :new.durch,                    -- DURCH
                  a.pack_vorschr = :new.pack_vorschr,      -- PACK_VORSCHR  N VARCHAR2(15)  Y     Verpackungsvorschrift
                  a.wieder_besch = :new.wieder_besch,      -- WIEDER_BESCH  N NUMBER(10)  Y     Wiederbeschaffungszeit in Tagen
                  a.herstell_kosten = :new.herstell_kosten,-- HERSTELL_KOSTEN N NUMBER(11,5)  Y     Herstell
                  a.beschaffungs_kosten = :new.beschaffungs_kosten,
                  a.lhm_tara = :new.lhm_tara,
                  a.artikel_p1 = :new.artikel_p1,
                  a.artikel_p2 = :new.artikel_p2,
                  a.artikel_p3 = :new.artikel_p3,
                  a.artikel_p4 = :new.artikel_p4,
                  a.artikel_p5 = :new.artikel_p5,
                  a.artikel_p6 = :new.artikel_p6,
                  a.artikel_p7 = :new.artikel_p7,
                  a.artikel_p8 = :new.artikel_p8,
                  a.artikel_p9 = :new.artikel_p9,
                  a.artikel_p10 = :new.artikel_p10,
                  a.min_mhd_tage_ausl = :new.min_mhd_tage_ausl,
                  a.min_mhd_tage_ms = :new.min_mhd_tage_ms,
                  a.artikel_fuer_kunde = :new.artikel_fuer_kunde,
                  a.volumen_cm3 = :new.volumen_cm3,
                  a.created_date = :new.created_date,
                  a.created_login_id = :new.created_login_id,
                  a.last_change_date = :new.last_change_date,
                  a.last_change_login_id = :new.last_change_login_id
     where a.firma_nr = :new.FIRMA_NR
       and a.artikel= :new.ARTIKEL;
  elsif deleting then
    update s_rcv_artikel a
         set      a.aktiv = 'F'
      ---- Achtung Firma
     where a.firma_nr = :old.FIRMA_NR
       and a.artikel= :old.ARTIKEL;
  end if;

end TR_S_ERP_RCV_ARTIKEL;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_RCV_ARTIKEL_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"a5f6a07127b8c4b748a21cd306b2e395b46ca0af","type":"TRIGGER","name":"TR_S_ERP_RCV_ARTIKEL_BIU","schemaName":"DIRKSPZM32","sxml":""}