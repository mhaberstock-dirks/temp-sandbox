create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_artikel_biu before
    insert or update on dirkspzm32.s_erp_rcv_artikel
    for each row
declare
  -- local variables here

    v_art         isi_artikel.artikel%type;
    v_pack_schema s_erp_rcv_pack_vorschr.pack_schema%type;
    cursor c_artikel is
    select
        a.artikel
    from
        s_rcv_artikel a
    where
        a.artikel = :new.artikel;

    cursor c_pack_vorschr is
    select
        p.pack_schema
    from
        s_erp_rcv_pack_vorschr p
    where
        p.artikel = :new.artikel;

begin
  -- Spez. Default für Euscher
    if :new.mhd_tage = 1
    or :new.mhd_tage is null then
        :new.mhd_tage := 360;
    end if;

    if updating
    or inserting then
        if inserting then
            if :new.created_date is null then
                :new.created_date := sysdate;
            end if;

            if :new.created_login_id is null then
                :new.created_login_id := -1;
            end if;

        end if;

        if updating then
            if :new.last_change_date = :old.last_change_date
            or :new.last_change_date is null then
                :new.last_change_date := sysdate;
            end if;

        end if;

        v_art := null;
        open c_artikel;
        fetch c_artikel into v_art;
        close c_artikel;
        if v_art is null -- Noch nicht da
         then
            insert into s_rcv_artikel values ( :new.firma_nr,
                                               :new.artikel,
                                               :new.bezeichnung1,
                                               :new.bezeichnung2,
                                               :new.bezeichnung3,
                                               :new.materialart,
                                               :new.lhm_name,
                                               :new.lhm_menge,
                                               :new.lhm_gewicht_kg,
                                               :new.lhm_ean,
                                               :new.lte_name,
                                               :new.lte_lhm_menge * :new.lhm_menge, --:new.LTE_MENGE,
                                               :new.lte_gewicht_kg,
                                               :new.lte_breite_max,
                                               :new.lte_tiefe_max,
                                               :new.lte_hoehe_max,
                                               :new.lte_lhm_menge,
                                               :new.lte_lhm_pro_lage,
                                               :new.lte_lhm_lagen,
                                               :new.lte_hoehe_lage,
                                               :new.lte_ean,
                                               :new.wert_klasse,
                                               :new.gefahren_klasse,
                                               :new.mengeneinheit,
                                               :new.waren_gruppe,
                                               :new.waren_typ,
                                               nvl(:new.abc,
                                                   'A'),
                                               :new.mhd_tage,
                                               :new.labor_vorg_status,
                                               :new.reife_zeit_tage,
                                               :new.ean,
                                               :new.laenge,
                                               :new.breite,
                                               :new.hoehe,
                                               null,              --:new.VOLUMEN,
                                               :new.gewicht,
                                               decode(:new.aktiv,
                                                      'Y',
                                                      'T',
                                                      'T',
                                                      'T',
                                                      'N'),
                                               :new.min_lager_temp,
                                               :new.max_lager_temp,
                                               :new.min_mhd_tage_ausl, -- art.min_mhd_tage_ausl
                                               :new.min_mhd_tage_ms,   -- art.min_mhd_tage_ms
                                               null,
                                               null,
                                               null,                        -- ANZ_ETIKETT_JE_LTE      NUMBER
                                               :new.zeichnung,              -- ZEICHNUNG               VARCHAR2(255),
                                               :new.zeichnung_index,        -- ZEICHNUNG_INDEX         VARCHAR2(10),
                                               'AR',  -- EINLAGERUNG             VARCHAR2(2),
                                               null,  -- MHD_FESTES_DATUM        DATE,
                                               null,  -- ARTIKEL_KURZ            VARCHAR2(20),
                                               'TA',  -- MHD_BERECKNUNG          VARCHAR2(2)
                                               null,  -- RES_ARTIKEL             CHAR(1),
                                               null,  -- RES_CHARGE              CHAR(1),
                                               null,  -- RES_SERIE               CHAR(1),
                                               null,  -- RES_FA_AUFTRAG          CHAR(1),
                                               null,  -- RES_KUNDE               CHAR(1),
                                               null,  -- RES_MHD                 CHAR(1),
                                               null,  -- RES_MHD_TAGE            NUMBER
                                               null,  -- Absch. Grob
                                               null,  -- Absch. Mittel
                                               null,  -- Absch. Fein
                                               null,  -- Toleranz Plus
                                               null,  -- Toleranz Minus
                                               null,  -- SollGewicht Abfüllung
                                               null,                       -- Parameter P1
                                               null,                       -- Parameter P2
                                               null,                       -- Parameter P3
                                               null,                       -- Parameter P4
                                               null,                       -- Parameter P5
                                               null,                       -- Parameter P6
                                               null,                       -- Parameter P7
                                               null,                       -- Parameter P8
                                               null,                       -- Parameter P9
                                               null,                       -- Parameter P10
                                               null,                       -- art_gruppe_id
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
                                               null,
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

        if :new.mengeneinheit = 'KG' then
            if nvl(:new.lhm_menge,
                   0) = 0 then
                :new.lhm_menge := 1;
            end if;

            :new.lhm_gewicht_kg := :new.lhm_menge;
            :new.gewicht := 1000;
        end if;

        v_pack_schema := null;
        open c_pack_vorschr;
        fetch c_pack_vorschr into v_pack_schema;
        close c_pack_vorschr;
        update s_rcv_artikel a
        set
            a.bezeichnung1 = :new.bezeichnung1,
            a.bezeichnung2 = :new.bezeichnung2,
            a.bezeichnung3 = :new.bezeichnung3,
            a.materialart = nvl(:new.materialart,
                                a.materialart),
            a.lhm_name = :new.lhm_name,
            a.lhm_menge = :new.lhm_menge,
            a.lhm_gewicht_kg = :new.lhm_gewicht_kg,
            a.lhm_ean = :new.lhm_ean,
            a.lte_name = :new.lte_name,
            a.lte_menge = :new.lte_lhm_menge * :new.lhm_menge, --:new.LTE_MENGE,
            a.lte_gewicht_kg = :new.lte_gewicht_kg,
            a.lte_breite_max = :new.lte_breite_max,
            a.lte_tiefe_max = :new.lte_tiefe_max,
            a.lte_hoehe_max = :new.lte_hoehe_max,
            a.lte_lhm_menge = :new.lte_lhm_menge,
            a.lte_lhm_pro_lage = :new.lte_lhm_pro_lage,
            a.lte_lhm_lagen = :new.lte_lhm_lagen,
            a.lte_hoehe_lage = :new.lte_hoehe_lage,
            a.lte_ean = :new.lte_ean,
            a.wert_klasse = :new.wert_klasse,
            a.gefahren_klasse = :new.gefahren_klasse,
            a.mengeneinheit = :new.mengeneinheit,
            a.waren_gruppe = :new.waren_gruppe,
            a.waren_typ = :new.waren_typ,
            a.abc = nvl(:new.abc,
                        a.abc),
            a.mhd_tage = :new.mhd_tage,
            a.labor_vorg_status = :new.labor_vorg_status,
            a.reife_zeit_tage = :new.reife_zeit_tage,
            a.ean = :new.ean,
            a.laenge = :new.laenge,
            a.breite = :new.breite,
            a.hoehe = :new.hoehe,
            a.gewicht = :new.gewicht,
            a.aktiv = decode(:new.aktiv,
                             'Y',
                             'T',
                             'T',
                             'T',
                             'N'),
            a.zeichnung = :new.zeichnung,              -- ZEICHNUNG               VARCHAR2(255),
            a.zeichnung_index = :new.zeichnung_index,   -- ZEICHNUNG_INDEX         VARCHAR2(10),
            a.min_lager_temp = :new.min_lager_temp,
            a.max_lager_temp = :new.max_lager_temp,
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
        where
                a.firma_nr = :new.firma_nr
            and a.artikel = :new.artikel;

    elsif deleting then
        update s_rcv_artikel a
        set
            a.aktiv = 'F'
      ---- Achtung Firma
        where
                a.firma_nr = :old.firma_nr
            and a.artikel = :old.artikel;

    end if;

end tr_s_erp_rcv_artikel;
/

alter trigger dirkspzm32.tr_s_erp_rcv_artikel_biu enable;


-- sqlcl_snapshot {"hash":"d91399391ebaa66b7c43f1e27b0cc74cbafd09b5","type":"TRIGGER","name":"TR_S_ERP_RCV_ARTIKEL_BIU","schemaName":"DIRKSPZM32","sxml":""}