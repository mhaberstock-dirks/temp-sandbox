create or replace 
package body DIRKSPZM32.S_SCHNITTSTELLE is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function trägt alle Daten in die BEW-Tabelle ein, Diese Tabelle ist für den
  -- Datentransfer von ISIPlus --> HOST
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure WRITE_HOST_BEW(in_order_pos   in isi_order_pos%rowtype,
                           in_lam         in lvs_lam%rowtype,
                           in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                           in_lam_bh_bus  in lvs_lam_bh.bus%type,
                           in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                           in_tabelle     in varchar2,
                           in_status      in s_send_bew.status%type,
                           in_quell_lgr   in lvs_lgr%rowtype,
                           in_ziel_lgr    in lvs_lgr%rowtype,
                           in_login_id    in isi_user.login_id%type,
                           in_menge       in number default NULL
                          ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_found     boolean;                                -- Daten Gefunfen?

    v_ort                lvs_lgr_ort.lgr_ort%type;  -- Für nachlesen des Lagerorts
    v_quelle_ort         lvs_lgr_ort%rowtype;       -- Lagerort Quelle
    v_ziel_ort           lvs_lgr_ort%rowtype;       -- Lagerort Ziel
    v_arbeitsplatz       isi_arbeitsplatz%rowtype;
    v_lte                lvs_lte%rowtype;

    v_charge             varchar2(255);
    v_art                isi_artikel%rowtype;       -- Artikel Daten
    v_vorgang_typ        s_send_bew.aktion%type;    -- WAE, WAI, WUI ... Warenabgang Extern, intern ...
    v_menge              number;
    v_brutto_kg          number;
    v_ist_bestand        number;
    v_ext_liefs_nr       s_send_bew.ext_lief_nr%type;

    v_user               isi_user%rowtype;
    v_sid                isi_sid%rowtype;
    v_res                isi_resource%rowtype;
    v_status             s_send_bew.status%type;

    CURSOR c_lam_sum is
      select nvl(sum(lam.menge), 0)
        from lvs_lam lam,
             lvs_lgr lgr,
             lvs_lgr_ort ort
       where lam.sid = v_sid.sid
         and lam.artikel_id = in_lam.artikel_id
         and lam.fa_ag is NULL
         and lam.lgr_platz is not NULL
         and lam.labor_status = 'F'
         and lam.lgr_platz = lgr.lgr_platz
         and lam.owner_address_id is NULL           -- Es darf nur Bestand gezählt werden, der nicht KONSI-Bestand ist
         and lgr.lgr_ort = ort.lgr_ort
         and ort.host_lgr_ort = v_quelle_ort.host_lgr_ort
       group by lam.artikel_id;

    CURSOR c_sid is
      select *
        from isi_sid s
        where s.sid_my_sid = 1;

    CURSOR c_lgr_ort is                             -- Lesen des Lagerplatz
      select *
        from lvs_lgr_ort ort
       where ort.lgr_ort = v_ort
         and ort.sid = in_lam.sid;

    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lte_id = in_lam.lte_id;

    CURSOR c_art is                        -- Lesen des Artikels
      select *
       from isi_artikel art
      where art.sid = nvl(in_lam.sid, in_order_pos.sid)
        and art.artikel_id = nvl(in_lam.artikel_id, in_order_pos.artikel_id);

    CURSOR c_charge is
      select chg.charge_bez
        from lvs_charge chg
       where chg.sid = in_lam.sid
         and chg.charge_id = in_lam.charge_id;

    CURSOR c_arbeitsplatz is
      select *
        from isi_arbeitsplatz ap
       where ap.arbeitsplatz_id = in_order_pos.arbeitsplatz_id;

    CURSOR c_resource is
      select *
        from isi_resource r
       where r.res_id = in_lam.res_id;
  begin
    v_user := NULL;
    v_res := NULL;

    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    v_status := in_status;
    if v_sid.sid_schnittstelle is NULL
    then
      if in_order_pos.vorgang_typ != 'LIF'
      or in_order_pos.besteller != 'WAWI'
      then
        return;
      end if;
    end if;
    if in_order_pos.vorgang_typ = 'LIF'
    and in_order_pos.besteller = 'WAWI'
    then
      v_status := 'N';
    end if;

    v_ist_bestand := NULL;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    if in_order_pos.besteller = 'HOST'
    or in_order_pos.besteller = 'WAWI'
    or in_order_pos.besteller is NULL
    then
      v_ort := in_quell_lgr.lgr_ort;
      v_quelle_ort := NULL;
      v_quelle_ort.host_lgr_ort := NULL;
      OPEN c_lgr_ort;
      FETCH c_lgr_ort into v_quelle_ort;
      v_found := c_lgr_ort%FOUND;
      CLOSE c_lgr_ort;
      if not v_found
      then

        v_ort := v_lte.lgr_ort;
        OPEN c_lgr_ort;
        FETCH c_lgr_ort into v_quelle_ort;
        CLOSE c_lgr_ort;

      end if;

      v_ort := in_ziel_lgr.lgr_ort;
      v_ziel_ort := NULL;
      v_ziel_ort.host_lgr_ort := NULL;
      OPEN c_lgr_ort;
      FETCH c_lgr_ort into v_ziel_ort;
      CLOSE c_lgr_ort;

      -- Bei Umlagerungen auf den gleichen Lagerort kann diese Buchrung Ignoriert werden
      if  (in_lam_bh_bus = c.lam_bh_bus_uml
      or   in_lam_bh_bus = c.LAM_BH_BUS_UP)
      and (v_quelle_ort.host_lgr_ort = v_ziel_ort.host_lgr_ort
         or v_quelle_ort.host_lgr_ort is null
         or v_ziel_ort.host_lgr_ort is null)
      then
        if  (in_lam_bh_bus != c.LAM_BH_BUS_UP          -- Prüfen, ob HOST die LTE_IDs verwaltet (benötigt)
          or in_lam.lte_id is NULL                      -- Dann auch bei gleichem Lagerort buchen
          or isi_allg.c_get_firma_cfg_param(in_lam.sid,
                                            in_lam.firma_nr,
                                            'CFG',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                            NULL,                   -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                            'HOST_HANDEL_LTE',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                            'HOST',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                            'CFG',                  -- in_typ                   in isi_firma_cfg.typ%type,
                                            'F',                    -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                            'BOOLEAN') = c.C_FALSE) -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
         and (in_lam_bh_bus = c.LAM_BH_BUS_UP          -- Prüfen, ob HOST die LTE_IDs verwaltet (benötigt)
          or in_lam.lte_id is NULL                      -- Dann auch bei gleichem Lagerort buchen
          or isi_allg.c_get_firma_cfg_param(in_lam.sid,
                                            in_lam.firma_nr,
                                            'CFG',                  -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                            NULL,                   -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                            'HOST_HANDEL_LTE_ALL_UML',      -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                            'HOST',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                            'CFG',                  -- in_typ                   in isi_firma_cfg.typ%type,
                                            'F',                    -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                            'BOOLEAN') = c.C_FALSE) -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
        then
          return;
        end if;
      end if;

      OPEN c_charge;                                   -- Lesen der charge
      FETCH c_charge into v_charge;
      CLOSE c_charge;

      OPEN c_art;
      FETCH c_art into v_art;
      CLOSE c_art;

      OPEN c_arbeitsplatz;
      FETCH c_arbeitsplatz into v_arbeitsplatz;
      CLOSE c_arbeitsplatz;

      v_menge := nvl(in_menge, in_lam.menge);
      v_ext_liefs_nr := in_order_pos.li_nr;

      if in_order_pos.vorgang_typ is NULL then
        if in_tabelle = 'S_FA'
        then
          OPEN c_resource;
          FETCH c_resource into v_res;
          CLOSE c_resource;
        end if;

        if (in_lam_bh_bus = c.lam_bh_bus_uml)
        then
          if in_tabelle is NULL then
            v_vorgang_typ := 'WUI';
          else
            v_vorgang_typ := 'WUE';
          end if;
        end if;

        if (in_lam_bh_bus = c.LAM_BH_BUS_UP)
        then
          v_vorgang_typ := 'KOM';
        end if;
        -- Hier jetzt KONSI Zugang
        if in_lam_bh_bus = c.LAM_BH_BUS_ZUG_KONSI
        then
          v_vorgang_typ := 'KWE';
          -- bei Konsi-Buchungen immer die Lieferscheinnr des Lieferanten verwenden
          v_ext_liefs_nr := in_lam.li_nr_lief;
        end if;
        if in_lam_bh_bus = c.lam_bh_bus_zug
        then
          if in_tabelle is NULL
          or in_tabelle = 'S_FA'
          then
            -- Im SAP kommt diese Buchung als Wareneingean Extern 'WEE'
            if v_sid.sid_schnittstelle = 'EUS_SAP'
            then
              v_vorgang_typ := 'WEE';
            elsif v_sid.sid_schnittstelle = 'ERP_STD' -- Standard-Schnittstelle
            then
              if nvl(in_tabelle, 'xx') != 'S_FA'      -- keine fertigung
              and v_sid.sid_name like 'direm%'        -- Bei Dirks dann Korekt eintragen als WEE
              then
                v_vorgang_typ := 'WEE';
              else
                v_vorgang_typ := 'WEI';
              end if;
            else
              v_vorgang_typ := 'WEI';
            end if;
          else
            v_vorgang_typ := 'WEE';
          end if;
        end if;
        -- Hier jetzt KONSI Abgang
        if in_lam_bh_bus = c.LAM_BH_BUS_ABG_KONSI
        then
          v_vorgang_typ := 'KWA';
        end if;
        -- Hier jetzt Entnahme KONSI
        if in_lam_bh_bus = c.LAM_BH_BUS_WKE_KONSI
        then
          v_vorgang_typ := 'WKE';
          -- bei Konsi-Buchungen immer die Lieferscheinnr des Lieferanten verwenden
          v_ext_liefs_nr := in_lam.li_nr_lief;
        end if;
        if in_lam_bh_bus = c.lam_bh_bus_abg then
          if in_tabelle is NULL
          or in_tabelle = 'S_FA' then
            v_vorgang_typ := 'WAI';
          else
            v_vorgang_typ := 'WAE';
          end if;
        end if;
        if in_lam_bh_bus = c.lam_bh_bus_q then
          v_vorgang_typ := 'WAS';
        end if;
        if in_lam_bh_bus = c.LAM_BH_BUS_SP then
          if v_menge < 0
          then
            v_menge := nvl(in_menge, in_lam.menge) * -1;
            v_vorgang_typ := 'FRE';
          else
            v_vorgang_typ := 'SPR';
          end if;
        end if;
        -- -AG- Komm darf bei Huf nicht gebucht werden
        if in_lam_bh_bus = c.lam_bh_bus_zug_komm then
          v_vorgang_typ := 'WEK';
        end if;
        if in_lam_bh_bus = c.lam_bh_bus_abg_komm then
          v_vorgang_typ := 'WAK';
        end if;
        if in_lam_bh_bus = c.LAM_BH_BUS_INV then
          v_vorgang_typ := 'INV';
          OPEN c_lam_sum;
          FETCH c_lam_sum into v_ist_bestand;
          CLOSE c_lam_sum;
          v_ist_bestand := nvl(v_ist_bestand, 0);
        end if;

        if in_lam_bh_bus = c.LAM_BH_BUS_IVZ then -- bei Huf erstmal ohne c.LAM_BH_BUS_IVZ then
          v_vorgang_typ := 'IVZ';
          OPEN c_lam_sum;
          FETCH c_lam_sum into v_ist_bestand;
          CLOSE c_lam_sum;
          v_ist_bestand := nvl(v_ist_bestand, 0);
        end if;
      else
        -- Hier jetzt Entnahme KONSI
        if in_lam_bh_bus = c.LAM_BH_BUS_WKE_KONSI
        then
          v_vorgang_typ := 'WKE';
          -- bei Konsi-Buchungen immer die Lieferscheinnr des Lieferanten verwenden
          v_ext_liefs_nr := in_lam.li_nr_lief;
        else
          v_vorgang_typ := in_order_pos.vorgang_typ;
          v_brutto_kg := in_order_pos.brutto_kg;
        end if;
      end if;

      -- AG 17.06.2015 Im Standard soll die Lieferscheinnummer des Lieferanten in der Schnittstelle eingeragen werden
      if in_lam_bh_bus = c.lam_bh_bus_zug
      and v_vorgang_typ = 'WEE'
      and v_sid.sid_schnittstelle = 'ERP_STD'
      then
        v_ext_liefs_nr := in_lam.li_nr_lief;
      end if;

      -- Lesen der User-Daten zum übermitteln der Personalnummer zu Hostsystemen
      if not isi_allg.get_user_by_login_id(v_sid.sid, in_login_id, v_user)
      then
        v_user.pers_nr := NULL;
        v_user.username := NULL;
      end if;

      insert into s_send_bew send
         values (
            NULL,                    -- BEW_ID          NUMBER,
            in_lam.firma_nr,            -- FIRMA_NR        NUMBER(3),
            'ISI',                      -- HERKUNFT        VARCHAR2(3),
            in_tabelle,                 -- TABELLE         VARCHAR2(5),
            in_order_pos.auf_id_extern, -- AUF_ID          NUMBER,
            v_status,                   -- STATUS          VARCHAR2(3),
            v_vorgang_typ,              -- AKTION          VARCHAR2(3),
            NULL,                       -- MA_STATUS       VARCHAR2(1),
            NULL,                       -- MA_S_GRUND      NUMBER(3),
            NULL,                       -- MA_ID           VARCHAR2(10),
            in_lam.lte_id,              -- LTE_NR          VARCHAR2(20),
            in_lam.lhm_id,              -- LHM_NR          VARCHAR2(20),
            v_quelle_ort.host_lgr_ort,  -- LAGERORT        VARCHAR2(10),
            v_ziel_ort.host_lgr_ort,    -- ZLAGERORT       VARCHAR2(10),
            v_menge,                    -- MENGE           NUMBER(12,3),
            NULL,                       -- MENGE_B         NUMBER(12,3),
            NULL,                       -- SCHROTT         NUMBER(12,3),
            NULL,                       -- R_MENGE         NUMBER(12,3),
            NULL,                       -- R_MENGE_B       NUMBER(12,3),
            NULL,                       -- R_SCHROTT       NUMBER(12,3),
            NULL,                       -- STOERZEIT_IST   NUMBER,
            NULL,                       -- RUESTZEIT_IST   NUMBER,
            NULL,                       -- PRODZEIT_IST    NUMBER,
            v_ext_liefs_nr,             -- EXT_LIEF_NR     VARCHAR2(15),
            in_order_pos.li_pos_nr,     -- EXT_LIEF_POS    VARCHAR2(5),
            v_charge,                   -- CHARGE          VARCHAR2(20),
            NULL,                       -- SERIE           VARCHAR2(20),
            v_arbeitsplatz.arbeitsplatz_id, -- ARBEITSPLATZ_ID VARCHAR2(20),
            V_ist_bestand,              -- IST_BESTAND     NUMBER,
            v_art.artikel,              -- ARTIKEL         VARCHAR2(20),
            sysdate,                    -- B_DATUM         DATE,
            in_lam.lam_id,              -- LAM_ID          NUMBER,
            in_lam_bh_id,               -- LAM_BH_ID       NUMBER,
            in_lam_bh_typ,              -- LAM_BH_TYP      VARCHAR2(2)
            NULL,                       -- LEITZAHL        NUMBER,
            NULL,                       -- FA_AG           NUMBER,
            NULL,                       -- FA_UPOS         NUMBER
            in_lam.fa_ag,               -- LAM_AG          NUMBER
            v_brutto_kg,                -- BRUTTO_KG
            NULL,                       -- TEXT            VARCHAR2(40),
            NULL,                       -- ERR_NR          NUMBER
            v_user.username,            -- USER_NAME       VARCHAR2(100)
            in_lam.res_id,              -- RES_ID          NUMBER
            NULL,                       -- SEND_ID         NUMBER
            NULL,                       -- MA_LAST_S_GRUND NUMBER
            v_user.pers_nr,             -- PERS_NR         NUMBER (Personalnummer der Buchung lesen
            in_lam.labor_text,          -- SPER_GRUND      VARCHAR2(30)
            in_quell_lgr.lgr_platz,     -- LAGERPLATZ N VARCHAR2(10)  Y     Lagerplatz im ISI
            in_ziel_lgr.lgr_platz,      -- ZLAGERPLATZ  N VARCHAR2(10)  Y     Ziellagerplatz im ISI
            in_lam.labor_status,        -- LABOR_STATUS N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
            in_lam.lam_sel1,            -- LAM_SEL1 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel2,            -- LAM_SEL2 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel3,            -- LAM_SEL3 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel4,            -- LAM_SEL4 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel5,            -- LAM_SEL5 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel6,            -- LAM_SEL6 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel7,            -- LAM_SEL7 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel8,            -- LAM_SEL8 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel9,            -- LAM_SEL9 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            in_lam.lam_sel10,           -- LAM_SEL10  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
            v_lte.lte_name,             -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
            in_order_pos.auf_id,        -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
            NULL,                       -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
            NULL);                      -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden


    end if;

  end write_host_bew;


  procedure WRITE_HOST_BEW_MENGE(in_order_pos   in isi_order_pos%rowtype,
                                 in_lam         in lvs_lam%rowtype,
                                 in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                 in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                 in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                 in_tabelle     in varchar2,
                                 in_status      in s_send_bew.status%type,
                                 in_quell_lgr   in lvs_lgr.lgr_platz%type,
                                 in_ziel_lgr    in lvs_lgr.lgr_platz%type,
                                 in_login_id    in isi_user.login_id%type,
                                 in_menge       in number
                               ) is


    v_lgr                lvs_lgr%rowtype;
    v_lte                lvs_lte%rowtype;

    v_lgr_platz          lvs_lgr.lgr_platz%type;

    v_quelle_ort         lvs_lgr_ort%rowtype;       -- Lagerort Quelle
    v_ziel_ort           lvs_lgr_ort%rowtype;       -- Lagerort Ziel

    v_vorgang_typ        s_send_bew.aktion%type;    -- WAE, WAI, WUI ... Warenabgang Extern, intern ...
    v_art                isi_artikel%rowtype;       -- Artikel Daten
    v_charge             varchar2(255);

    v_mg                 s_send_bew.menge%type;
    v_mg_b               s_send_bew.menge_b%type;
    v_schrott            s_send_bew.schrott%type;
    v_r_mg               s_send_bew.r_menge%type;
    v_r_mg_b             s_send_bew.r_menge_b%type;
    v_r_schrott          s_send_bew.r_schrott%type;
    v_prod_zeit          s_send_bew.prodzeit_ist%type;
    v_ruest_zeit         s_send_bew.ruestzeit_ist%type;
    v_stoer_zeit         s_send_bew.stoerzeit_ist%type;
    v_ruest_zeit_erf     s_send_bew.ruestzeit_ist%type;
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
    v_prod_zeit_erf      s_send_bew.stoerzeit_ist%type;
    v_ext_liefs_nr       s_send_bew.ext_lief_nr%type;

    v_user               isi_user%rowtype;

    v_sid               isi_sid%rowtype;
    v_brutto_kg          number;

    CURSOR c_sid is
      select *
        from isi_sid s
        where s.sid_my_sid = 1;

    CURSOR c_lgr is                             -- Lesen des Lagerpltz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lgr_platz
         and lgr.sid = in_lam.sid;

    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lte_id = in_lam.lte_id;

    CURSOR c_lgr_ort is                             -- Lesen des Lagerort
      select *
        from lvs_lgr_ort ort
       where ort.lgr_ort = v_lgr.lgr_ort
         and ort.sid = in_lam.sid;

    CURSOR c_art is                        -- Lesen des Artikels
      select *
       from isi_artikel art
      where art.sid = in_lam.sid
        and art.artikel_id = in_lam.artikel_id;

    CURSOR c_charge is
      select chg.charge_bez
        from lvs_charge chg
       where chg.sid = in_lam.sid
         and chg.charge_id = in_lam.charge_id;

  begin
    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    if v_sid.sid_schnittstelle is NULL then
      return;
    end if;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    OPEN c_art;
    FETCH c_art into v_art;
    CLOSE c_art;

    OPEN c_charge;                                   -- Lesen der charge
    FETCH c_charge into v_charge;
    CLOSE c_charge;

    v_lgr_platz := in_quell_lgr;
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    v_quelle_ort := NULL;
    v_quelle_ort.host_lgr_ort := NULL;
    OPEN c_lgr_ort;
    FETCH c_lgr_ort into v_quelle_ort;
    CLOSE c_lgr_ort;

    v_lgr_platz := in_ziel_lgr;
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    v_ziel_ort := NULL;
    v_ziel_ort.host_lgr_ort := NULL;
    OPEN c_lgr_ort;
    FETCH c_lgr_ort into v_ziel_ort;
    CLOSE c_lgr_ort;

    v_mg                 := NULL;
    v_mg_b               := NULL;
    v_schrott            := NULL;
    v_r_mg               := NULL;
    v_r_mg_b             := NULL;
    v_r_schrott          := NULL;
    v_prod_zeit          := NULL;
    v_ruest_zeit         := NULL;
    v_stoer_zeit         := NULL;
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
    v_ruest_zeit_erf     := NULL;
    v_prod_zeit_erf      := NULL;

    v_brutto_kg := in_order_pos.brutto_kg;

    if in_lam_bh_bus = c.lam_bh_bus_zug then
      v_mg                 := in_menge;
      -- Im SAP kommt diese Buchung als Wareneingean Extern 'WEE'
      if v_sid.sid_schnittstelle = 'EUS_SAP'
      then
        v_vorgang_typ := 'WEE';
      else
        v_vorgang_typ := 'WEI';
      end if;
      v_brutto_kg := in_lam.lam_kg;
    end if;
    if in_lam_bh_bus = c.lam_bh_bus_abg then
      v_mg                 := in_menge;
      v_vorgang_typ := 'WAI';
      v_brutto_kg := in_lam.lam_kg;
    end if;
    if in_lam_bh_bus = c.lam_bh_bus_q
    then
      v_mg                 := in_menge;
      v_vorgang_typ := 'WAS';
      v_brutto_kg := in_lam.lam_kg;
    end if;
    if in_lam_bh_bus = c.LAM_BH_BUS_UML
    then
      v_mg                 := in_menge;
      v_vorgang_typ := 'WUI';
      v_brutto_kg := in_lam.lam_kg;
    end if;
    -- -AG- Komm darf bei Huf nicht gebucht werden
    if in_lam_bh_bus = c.lam_bh_bus_zug_komm then
      v_mg                 := in_menge;
      v_vorgang_typ := 'WEK';
      v_brutto_kg := in_lam.lam_kg;
    end if;
    if in_lam_bh_bus = c.lam_bh_bus_abg_komm then
      v_mg                 := in_menge;
      v_vorgang_typ := 'WAK';
      v_brutto_kg := in_lam.lam_kg;
    end if;

    if in_lam_bh_bus = c.lam_bh_bus_zug_konsi then
      v_mg                 := in_menge;
      v_vorgang_typ := 'KWE';
      v_brutto_kg := in_lam.lam_kg;
    end if;
    if in_lam_bh_bus = c.lam_bh_bus_abg_komm then
      v_mg                 := in_menge;
      v_vorgang_typ := 'KWA';
      v_brutto_kg := in_lam.lam_kg;
    end if;

    -- Bei Umlagerungen auf den gleichen Lagerort kann diese Buchrung Ignoriert werden
    if  (in_lam_bh_bus = c.lam_bh_bus_uml
    or   in_lam_bh_bus = c.LAM_BH_BUS_UP)
    and (v_quelle_ort.host_lgr_ort = v_ziel_ort.host_lgr_ort
       or v_quelle_ort.host_lgr_ort is null
       or v_ziel_ort.host_lgr_ort is null)
    then
      return;
    end if;

    -- Lesen der User-Daten zum übermitteln der Personalnummer zu Hostsystemen
    if not isi_allg.get_user_by_login_id(v_sid.sid, in_login_id, v_user)
    then
      v_user.pers_nr := NULL;
      v_user.username := NULL;
    end if;

    -- AG 17.06.2015 Im Standard soll die Lieferscheinnummer des Lieferanten in der Schnittstelle eingeragen werden
    v_ext_liefs_nr := in_order_pos.li_nr;
    if in_lam_bh_bus = c.lam_bh_bus_zug
    and v_vorgang_typ = 'WEE'
    and v_sid.sid_schnittstelle = 'ERP_STD'
    then
      v_ext_liefs_nr := in_lam.li_nr_lief;
    end if;

    insert into s_send_bew send
       values (
          NULL,                       -- BEW_ID          NUMBER,
          in_lam.firma_nr,            -- FIRMA_NR        NUMBER(3),
          'ISI',                      -- HERKUNFT        VARCHAR2(3),
          in_tabelle,                 -- TABELLE         VARCHAR2(5),
          in_order_pos.auf_id_extern, -- AUF_ID          NUMBER,
          in_status,                  -- STATUS          VARCHAR2(3),
          v_vorgang_typ,              -- AKTION          VARCHAR2(3),
          NULL,                       -- MA_STATUS       VARCHAR2(1),
          NULL,                       -- MA_S_GRUND      NUMBER(3),
          NULL,                       -- MA_ID           VARCHAR2(10),
          in_lam.lte_id,              -- LTE_NR          VARCHAR2(20),
          in_lam.lhm_id,              -- LHM_NR          VARCHAR2(20),
          v_quelle_ort.host_lgr_ort,  -- LAGERORT        VARCHAR2(10),
          v_ziel_ort.host_lgr_ort,    -- ZLAGERORT       VARCHAR2(10),
          v_mg,                       -- MENGE           NUMBER(12,3),
          v_mg_b,                     -- MENGE_B         NUMBER(12,3),
          v_schrott,                  -- SCHROTT         NUMBER(12,3),
          v_r_mg,                     -- R_MENGE         NUMBER(12,3),
          v_r_mg_b,                   -- R_MENGE_B       NUMBER(12,3),
          v_r_schrott,                -- R_SCHROTT       NUMBER(12,3),
          v_stoer_zeit,               -- STOERZEIT_IST   NUMBER,
          v_ruest_zeit,               -- RUESTZEIT_IST   NUMBER,
          v_prod_zeit,                -- PRODZEIT_IST    NUMBER,
          v_ext_liefs_nr,             -- EXT_LIEF_NR     VARCHAR2(15),
          in_order_pos.li_pos_nr,     -- EXT_LIEF_POS    VARCHAR2(5),
          v_charge,                   -- CHARGE          VARCHAR2(20),
          NULL,                       -- SERIE           VARCHAR2(20),
          NULL,                       -- ARBEITSPLATZ_ID VARCHAR2(20),
          NULL,                       -- IST_BESTAND     NUMBER,
          v_art.artikel,              -- ARTIKEL         VARCHAR2(20),
          sysdate,                    -- B_DATUM         DATE,
          in_lam.lam_id,              -- LAM_ID          NUMBER,
          in_lam_bh_id,               -- LAM_BH_ID       NUMBER,
          in_lam_bh_typ,              -- LAM_BH_TYP      VARCHAR2(2)
          NULL,                       -- LEITZAHL        NUMBER,
          NULL,                       -- FA_AG           NUMBER,
          NULL,                       -- FA_UPOS         NUMBER
          in_lam.fa_ag,               -- LAM_AG          NUMBER
          v_brutto_kg,                -- BRUTTO_KG
          NULL,                       -- TEXT            VARCHAR2(40),
          NULL,                       -- ERR_NR          NUMBER);               -- BRUTTO_KG
          v_user.username,            -- USER_NAME       VARCHAR2(100)
          in_lam.res_id,              -- RES_ID          NUMBER
          NULL,                       -- SEND_ID         NUMBER
          NULL,                       -- MA_LAST_S_GRUND NUMBER
          v_user.pers_nr,             -- PERS_NR         NUMBER (Personalnummer der Buchung lesen
          in_lam.labor_text,          -- SPER_GRUND      VARCHAR2(30)
          in_quell_lgr,               -- LAGERPLATZ N VARCHAR2(10)  Y     Lagerplatz im ISI
          in_ziel_lgr,                -- ZLAGERPLATZ  N VARCHAR2(10)  Y     Ziellagerplatz im ISI
          in_lam.labor_status,        -- LABOR_STATUS N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
          in_lam.lam_sel1,            -- LAM_SEL1 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel2,            -- LAM_SEL2 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel3,            -- LAM_SEL3 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel4,            -- LAM_SEL4 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel5,            -- LAM_SEL5 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel6,            -- LAM_SEL6 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel7,            -- LAM_SEL7 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel8,            -- LAM_SEL8 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel9,            -- LAM_SEL9 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel10,           -- LAM_SEL10  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          v_lte.lte_name,             -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
          in_order_pos.auf_id,        -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
          v_ruest_zeit_erf,           -- RUEST_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
          v_prod_zeit_erf);           -- PROD_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden

  end write_host_bew_menge;

  --------------------------------------------------------------------------------
  -- function überträgt die daten aus der BEW-Tabelle an den HOST
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure SEND_HOST_BEW(io_bew    in out s_send_bew%rowtype
                         ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    --v_err_nr    number;
    --v_err_text  varchar2(255);

    v_sid               isi_sid%rowtype;
    v_lam                lvs_lam%rowtype;           -- Lagerbestand
    --v_found             boolean;
    v_bew_tabelle         varchar2(100);
    v_aktion              varchar2(100);
    v_sap_bus             varchar2(100);
    v_bestand             number;
    v_bew_id              s_send_bew.bew_id%type;
    v_status              varchar2(10);

    v_arbeitsplatz        isi_arbeitsplatz%rowtype;
    -- DIAF ist abgeschaltet
    -- v_s_diav_bew          s_diaf_send_bew%rowtype;
    v_s_erp_bew           s_erp_send_bew%rowtype;
    v_s_eus_sap_bew       s_eus_sap_send_bew%rowtype;
    v_s_sqd_sap_bew       s_sqd_sap_send_bew%rowtype;
    v_s_sas_sap_bew       s_sas_sap_send_bew%rowtype;
    v_s_sqd_sap_bew_pe    s_sqd_sap_send_bew%rowtype;
    v_res_zust_akt        isi_resource_zust_akt%rowtype;
    v_menge               number;
    v_mens                varchar2(20);
    v_artikel             isi_artikel%rowtype;
    v_auftr               s_rcv_auftr%rowtype;
    v_order_pos_auf       isi_order_pos%rowtype;

    v_found               boolean;

    v_sql                 varchar2(2000);

    v_scanner             isi_scanner_cfg%rowtype;
    v_bde_fa_kopf         bde_fa_kopf%rowtype;
    v_bde_fa_ag           bde_fa_auftrag%rowtype;
    v_fa_ag               bde_fa_auftrag.fa_ag%type;
    v_nve                 varchar2(20);

    v_q_lte_id            lvs_lte.lte_id%type;
    v_q_lte_r_menge       lvs_lam.menge%type;
    v_z_lte_id            lvs_lte.lte_id%type;
    v_max_date_tc              date;

    -- Wurde nur temporär bei Euscher benötigt
    --v_eus_sap_rcv_fa_auf  s_eus_sap_rcv_fa_auf%rowtype;
    --v_eus_sap_rcv_auftr  s_eus_sap_rcv_auftr%rowtype;

    v_order_pos          isi_order_pos%rowtype;     -- ISI-Order Position
    v_s_qs_babtec_wee    s_qs_babtec_wee%rowtype;

    CURSOR c_sid is
      select *
        from isi_sid s
        where s.sid_my_sid = 1;

    CURSOR c_auftr is
      select *
        from s_rcv_auftr s
       where s.firma_nr = io_bew.firma_nr
         and s.auf_id = io_bew.auf_id;

    CURSOR c_order is
      select *
        from isi_order_pos p
       where p.firma_nr = io_bew.firma_nr
         and p.auf_id_extern = io_bew.auf_id;

    CURSOR c_arbeitsplatz is
      select *
        from isi_arbeitsplatz a
       where a.arbeitsplatz_id = io_bew.arbeitsplatz_id;

    --DIAF ist abgeschaltet
    /*
    CURSOR c_s_diav_send_bew is
      select t.*
        from s_diaf_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and t.herkunft = io_bew.herkunft
         and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
         and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
         and t.aktion = v_aktion
         and t.status is NULL
         and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
         and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
         and t.lte_nr = io_bew.lte_nr
         and t.charge = io_bew.charge
         and t.artikel = io_bew.artikel;
    */
    CURSOR c_s_eus_sap_send_bew is
      select t.*
        from s_eus_sap_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and t.herkunft = io_bew.herkunft
          -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
         and nvl(t.tabelle, 'keine') = nvl(decode(io_bew.tabelle, 'S_AUF', 'S_AUFTR', io_bew.tabelle), 'keine')
         and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
         and t.aktion = v_aktion
         and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
         and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
         and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
         and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
         and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
         and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
         and t.lte_nr = io_bew.lte_nr
         and t.charge = io_bew.charge
         and t.artikel = io_bew.artikel
         and nvl(t.lagerort, '-1') = nvl(io_bew.lagerort, '-1')
         and nvl(t.zlagerort, '-1') = nvl(io_bew.zlagerort, '-1');

    CURSOR c_eus_sap_send_bew_auftr is
      select *
        from s_eus_sap_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and nvl(t.tabelle, 'keine') = nvl(decode(io_bew.tabelle, 'S_AUF', 'S_AUFTR', io_bew.tabelle), 'keine')
         and t.auf_id = io_bew.auf_id
         and t.aktion = v_aktion;

    CURSOR c_s_erp_send_bew is
      select t.*
        from s_erp_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and t.herkunft = io_bew.herkunft
          -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
         and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
         and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
         and t.aktion = v_aktion
         and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
         and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
         and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
         and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
         and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
         and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
         and t.lte_nr = io_bew.lte_nr
         and t.charge = io_bew.charge
         and t.artikel = io_bew.artikel
         and nvl(t.lagerort, '-1') = nvl(io_bew.lagerort, '-1')
         and nvl(t.zlagerort, '-1') = nvl(io_bew.zlagerort, '-1')
         and nvl(t.labor_status, 'LABOR') = nvl(io_bew.labor_status, 'LLABOR')
         and nvl(t.zlagerplatz, 'LGR_P_x') = nvl(io_bew.zlagerplatz, 'LGR_P_x')
         and nvl(t.lagerplatz, 'LGR_P_x') = nvl(io_bew.lagerplatz, 'LGR_P_x')
         and nvl(t.lam_sel1, 'SELx') = nvl(io_bew.lam_sel1, 'SELx')
         and nvl(t.lam_sel2, 'SELx') = nvl(io_bew.lam_sel2, 'SELx')
         and nvl(t.lam_sel3, 'SELx') = nvl(io_bew.lam_sel3, 'SELx')
         and nvl(t.lam_sel4, 'SELx') = nvl(io_bew.lam_sel4, 'SELx')
         and nvl(t.lam_sel5, 'SELx') = nvl(io_bew.lam_sel5, 'SELx')
         and nvl(t.lam_sel6, 'SELx') = nvl(io_bew.lam_sel6, 'SELx')
         and nvl(t.lam_sel7, 'SELx') = nvl(io_bew.lam_sel7, 'SELx')
         and nvl(t.lam_sel8, 'SELx') = nvl(io_bew.lam_sel8, 'SELx')
         and nvl(t.lam_sel9, 'SELx') = nvl(io_bew.lam_sel9, 'SELx')
         and nvl(t.lam_sel10, 'SELx') = nvl(io_bew.lam_sel10, 'SELx')
         and nvl(t.komm_q_lte_id, 'KOMQLte') = nvl(v_q_lte_id, 'KOMQLte');

    -- Wurde nur temporär bei Euscher benötigt
    /*
    CURSOR c_eus_sap_rcv_fa_auf is
      select *
        from s_eus_sap_rcv_fa_auf t
       where t.firma_nr = io_bew.firma_nr
         and t.leitzahl = io_bew.leitzahl
         and t.fa_ag = io_bew.fa_ag
         and t.fa_upos = io_bew.fa_upos;

    CURSOR c_eus_sap_rcv_auftr is
      select *
        from s_eus_sap_rcv_auftr t
       where t.firma_nr = io_bew.firma_nr
         and t.auf_id = io_bew.auf_id;
    */
    CURSOR c_s_sas_sap_send_bew is
      select t.*
        from s_sas_sap_send_bew t
       where t.slb_buchnr = v_sap_bus
         and t.slb_mat_nr = io_bew.artikel
         and t.slb_charge = io_bew.charge
         and nvl(t.slb_von_lgr_ort, '-1') = nvl(io_bew.lagerort, '-1')
         and nvl(t.slb_nach_lgr_ort, '-1') = nvl(io_bew.zlagerort, '-1')
         and t.sap_fb = v_aktion
         and t.slb_meins = v_mens
         and t.status = 'N'
         and t.slb_von_lgr_ort = io_bew.lagerort
         and nvl(t.slb_auftrnr, -1) = nvl(v_bde_fa_kopf.fa_nr_ext, -1);

    CURSOR c_s_sqd_sap_send_bew_tc is -- Last Time Confirmation
      select max(to_date(t.b_datum, 'dd.mm.yyyy hh24:mi:ss'))
        from s_sqd_sap_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and t.herkunft = io_bew.herkunft
         --and (t.status = 'UE'  -- Hier ist der neue Status 'UE' bereits übertragen
         --  or t.status = 'U'   -- Hier ist der neue Status 'U' beim übertragen
         --  or t.status = 'NW') -- Hier ist der neue Status 'WN' warte neu aktuell PE
         and t.aktion in ('SG', 'PS', 'SB', 'PE', 'SE')
         and t.leitzahl = v_bde_fa_ag.leitzahl
         and t.fa_ag = v_bde_fa_ag.fa_ag
         and t.fa_upos = v_bde_fa_ag.fa_upos;

    CURSOR c_s_sqd_sap_send_bew_pe is -- Time Confirmation for all LHM in Status W
      select t.*
        from s_sqd_sap_send_bew t
       where t.leitzahl = io_bew.leitzahl
         and t.fa_ag = io_bew.fa_ag
         and t.fa_upos = io_bew.fa_upos
         and t.aktion = 'XPE'
         and t.status = 'W'
       order by t.ts;

    CURSOR c_s_sqd_sap_send_bew is
      select t.*
        from s_sqd_sap_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and t.herkunft = io_bew.herkunft
         and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
         and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
         and t.aktion = v_aktion
         and t.status = 'W'  -- Hier ist der neue Status 'N' und nicht NULL
         and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
         and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
         and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
         and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
         and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
         and t.lte_nr = io_bew.lte_nr
         and t.lhm_nr = v_nve
         and t.charge = io_bew.charge
         and t.artikel = io_bew.artikel
         and nvl(t.lagerort, '-1') = nvl(io_bew.lagerort, '-1')
         and nvl(t.zlagerort, '-1') = nvl(io_bew.zlagerort, '-1');

    CURSOR c_s_sqd_sap_send_bew_wei is
      select t.*
        from s_sqd_sap_send_bew t
       where t.firma_nr = io_bew.firma_nr
         and t.aktion = v_aktion
         and t.status = 'W'  -- Hier ist der neue Status 'N' und nicht NULL
         and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
         and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
         and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
         and t.lte_nr = io_bew.lte_nr
       order by t.ts;

    CURSOR c_scanner is
      select *
        from isi_scanner_cfg s
       where s.res_id = io_bew.res_id;

    CURSOR c_bde_fa_kopf is
      select t.*
        from bde_fa_kopf t
       where t.firma_nr = io_bew.firma_nr
         and t.fa_nr = io_bew.leitzahl;

    CURSOR c_s_qs_babtec_wee is
      select *
        from s_qs_babtec_wee t
       where t.bestellnummer = v_order_pos.vorgang_id
         and t.bestellposition = v_order_pos.pos_nr
         and t.artikel = v_artikel.artikel
         and t.lteid = io_bew.lte_nr;

  CURSOR c_fa_auftrag is
    select *
      from bde_fa_auftrag fa
     where fa.sid = v_lam.sid
       and fa.firma_nr = v_lam.firma_nr
       and fa.leitzahl = v_lam.leitzahl
       and (fa.fa_ag = v_lam.fa_ag
         or (v_lam.fa_ag is NULL
         and fa.kenz_letzt_ag = 1)
           )
       and fa.ag_artikel_id = v_lam.artikel_id;

  CURSOR c_get_komm_quelle is
    select lbh.lte_id,
           sum(nvl(lam.menge, 0))
      from lvs_lam_bh lbh
      left join lvs_lam lam on lam.lte_id = lbh.lte_id
     where lbh.vorg_id = (select x.vorg_id from lvs_lam_bh x where x.lam_bh_id = io_bew.lam_bh_id)
       and lbh.menge < 0
       group by lbh.lte_id;

  begin
    if not v_send_host_aktiv -- Nichts zum Host senden
    then
      return;
    end if;

    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    -- Bei ERP_STD alles schreiben
    if v_sid.sid_schnittstelle != 'ERP_STD'
    then
      -- AA für Tabelle S_AUF nur dann senden, wenn eine Lieferschein eingetragen. estellung nicht melden
      if   io_bew.tabelle = 'S_AUF'
      and  io_bew.aktion = 'AA'
      and  nvl(io_bew.ext_lief_nr, '0') = '0'
      then
        return;
      end if;
    end if;

    /*
    ----------------------------------------------------------------------------------------
      Neue AFAS XML Schnittstelle
    ----------------------------------------------------------------------------------------
    */
    if v_sid.sid_schnittstelle = 'SMI_AFAS_XML'
    then
      v_bew_tabelle := io_bew.tabelle;
      v_aktion := io_bew.aktion;
      -- Schnittstelle AFAS bei Smithuis
      if v_bew_tabelle is NULL
      or v_aktion != 'LIF'
      then
        return;
      end if;

      -- -AG- 20201209 Die Aufträge könen auch über TMS_Kunden_uftrag kommen.
      -- Dann sind keine Daten in der S_RCV_AUFTR sondern dann nur in der ISI-Order
      begin
        OPEN c_auftr;
        FETCH c_auftr into v_auftr;
        v_found := c_auftr%found;
        CLOSE c_auftr;
      exception
        when others then
          v_found := FALSE;
      end;

      begin
        if not v_found
        then
          OPEN c_order;
          FETCH c_order into v_order_pos_auf;
          CLOSE c_order;
          v_auftr.soll_mg := v_order_pos_auf.soll_menge;
          v_auftr.auftrag := v_order_pos_auf.auftrag;
          v_auftr.pos_nr := v_order_pos_auf.pos_nr;
          v_auftr.upos_nr := v_order_pos.upos_nr;
        end if;
      exception
        when others then
          v_found := FALSE;
          v_auftr.soll_mg := NULL;
          v_auftr.auftrag := NULL;
          v_auftr.pos_nr := NULL;
          v_auftr.upos_nr := NULL;
      end;

      insert into s_smi_send_bew
         values (
            io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
            io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
            v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
            io_bew.auf_id,               -- AUF_ID          NUMBER,
            'N',                         -- STATUS          VARCHAR2(3),
            v_aktion,                    -- AKTION          VARCHAR2(3),
            io_bew.leitzahl,             -- FA
            io_bew.fa_ag,                -- FA_AG
            io_bew.fa_upos,              -- FA_UPOS
            io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
            io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER(3),
            io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
            io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
            io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
            io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
            io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
            v_auftr.soll_mg,             -- Menge_SOLL      NUMBER
            io_bew.menge,                -- MENGE           NUMBER(12,3),
            io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
            io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
            io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
            io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
            io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
            v_artikel.mengeneinheit,     -- Aus Artikel lesen
            io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
            io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
            io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
            io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
            io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
            v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
            v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
            io_bew.charge,               -- CHARGE          VARCHAR2(20),
            io_bew.serie,                -- SERIE           VARCHAR2(20),
            io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
            io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
            io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
            to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss'),
                                         -- B_DATUM         DATE,
            io_bew.bew_id,               -- TS
            io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
            NULL,                        -- RET_CODE        VARCHAR2(20),
            0);                          -- CYCLE           NUMBER

        io_bew.send_id := io_bew.bew_id;

    end if;

    if v_sid.sid_schnittstelle = 'ERP_STD'
    then
      if io_bew.aktion = 'L' -- Gelöscht nicht an SAP senden
      then
        return;
      end if;

      -- Bei SAP soll nur Fertig gemeldet werden
      if io_bew.auf_id is NULL then
        v_bew_tabelle := NULL;
      else
        v_bew_tabelle := io_bew.tabelle;
      end if;

      v_aktion := io_bew.aktion;

      if not lvs_p_base.get_lam(v_sid.sid, io_bew.firma_nr, io_bew.lam_id, v_lam)
      then
        v_lam := NULL;
      end if;

      if not isi_allg.get_artikel_by_artikel_nr(io_bew.artikel,
                                                v_artikel)
      then
        v_artikel := NULL;
      end if;
      v_auftr := NULL;
      v_auftr.auftrag := NULL;
      v_auftr.pos_nr := NULL;

      -- -AG- 20201209 Die Aufträge könen auch über TMS_Kunden_uftrag kommen.
      -- Dann sind keine Daten in der S_RCV_AUFTR sondern dann nur in der ISI-Order
      begin
        OPEN c_auftr;
        FETCH c_auftr into v_auftr;
        v_found := c_auftr%found;
        CLOSE c_auftr;
      exception
        when others then
          v_found := FALSE;
      end;

      begin
        if not v_found
        then
          OPEN c_order;
          FETCH c_order into v_order_pos_auf;
          CLOSE c_order;
          v_auftr.soll_mg := v_order_pos_auf.soll_menge;
          v_auftr.auftrag := v_order_pos_auf.auftrag;
          v_auftr.pos_nr := v_order_pos_auf.pos_nr;
          v_auftr.upos_nr := v_order_pos_auf.upos_nr;
          v_auftr.tour := v_order_pos_auf.vorgang_id;
          v_auftr.vorgang := v_order_pos_auf.vorgang_id;
        end if;
      exception
        when others then
          v_found := FALSE;
          v_auftr.soll_mg := NULL;
          v_auftr.auftrag := NULL;
          v_auftr.pos_nr := NULL;
          v_auftr.upos_nr := NULL;
          v_auftr.tour := NULL;
          v_auftr.vorgang := NULL;
      end;

      v_q_lte_id := null;
      v_z_lte_id := null;
      v_q_lte_r_menge := null;

      if (io_bew.aktion = 'KOM')
      then
        open c_get_komm_quelle;
        fetch c_get_komm_quelle into v_q_lte_id,
                                     v_q_lte_r_menge;
        close c_get_komm_quelle;
        v_z_lte_id := io_bew.lte_nr;
      end if;

      if isi_allg.c_get_firma_cfg_param(v_sid.sid,
                                        io_bew.firma_nr,
                                        'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'HOST_SUM_LTE',        -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'HOST',                -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      then
        OPEN c_s_erp_send_bew;
        FETCH c_s_erp_send_bew into v_s_erp_bew;
        v_found := c_s_erp_send_bew%found;
        CLOSE c_s_erp_send_bew;
      else
        v_found := false;
      end if;

      if v_found
      then
        -- Beim ERP führen 0 Mengen buchungen oft zu Fehler daher nicht schreiben
        -- IST_BESTAND ist nur bei Bestandsabgleich und Gezählter Inventur
        -- Relevant. Diese sollen immer geschickt werden
        if  0 = nvl(v_s_erp_bew.menge, 0)     + nvl(io_bew.menge, 0)
        and 0 = nvl(v_s_erp_bew.menge_b, 0)   + nvl(io_bew.menge_b, 0)
        and 0 = nvl(v_s_erp_bew.schrott, 0)   + nvl(io_bew.schrott, 0)
        and 0 = nvl(v_s_erp_bew.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0)
        and v_s_erp_bew.aktion != 'TF'
        and v_s_erp_bew.aktion != 'F'
        and v_s_erp_bew.aktion != 'LIF'
        and v_s_erp_bew.aktion != 'BLF'
        and v_s_erp_bew.aktion != 'BEF'
        and v_s_erp_bew.aktion != 'BAG'
        and v_s_erp_bew.aktion != 'IVZ'
        and v_s_erp_bew.aktion != 'SB'
        and v_s_erp_bew.aktion != 'SE'
        and v_s_erp_bew.aktion != 'SW'
        and v_s_erp_bew.aktion != 'RS'
        and v_s_erp_bew.aktion != 'RE'
        and v_s_erp_bew.aktion != 'PS'
        and v_s_erp_bew.aktion != 'PE'
        and v_s_erp_bew.aktion != 'SG'
        and v_s_erp_bew.aktion != 'KOM'
        then
          delete s_erp_send_bew t
           where t.firma_nr = io_bew.firma_nr
             and t.herkunft = io_bew.herkunft
             -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
             and nvl(t.tabelle, 'keine') = nvl(decode(io_bew.tabelle, 'S_AUF', 'S_AUFTR', io_bew.tabelle), 'keine')
             and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
             and t.aktion = v_aktion
             and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
             and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
             and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
             and t.lte_nr = io_bew.lte_nr
             and t.charge = io_bew.charge
             and t.artikel = io_bew.artikel
             and t.bew_id = v_s_erp_bew.bew_id;
        elsif v_s_erp_bew.aktion != 'SB'
          and v_s_erp_bew.aktion != 'SE'
          and v_s_erp_bew.aktion != 'SW'
          and v_s_erp_bew.aktion != 'RS'
          and v_s_erp_bew.aktion != 'RE'
          and v_s_erp_bew.aktion != 'PS'
          and v_s_erp_bew.aktion != 'PE'
          and v_s_erp_bew.aktion != 'SG'
          and v_s_erp_bew.aktion != 'KOM'
        then
          update s_erp_send_bew t
             set t.menge = nvl(t.menge, 0)         + nvl(io_bew.menge, 0),
                 t.menge_b = nvl(t.menge_b, 0)     + nvl(io_bew.menge_b, 0),
                 t.schrott = nvl(t.schrott, 0)     + nvl(io_bew.schrott, 0),
                 t.brutto_kg = nvl(t.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0),
                 t.ist_bestand = io_bew.ist_bestand,
                 t.lhm_nr = NULL
           where t.firma_nr = io_bew.firma_nr
             and t.herkunft = io_bew.herkunft
             -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
             and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
             and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
             and t.aktion = v_aktion
             and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
             and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
             and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
             and t.lte_nr = io_bew.lte_nr
             and t.charge = io_bew.charge
             and t.artikel = io_bew.artikel
             and t.bew_id = v_s_erp_bew.bew_id;
          if sql%rowcount != 1
          then
            update s_erp_send_bew t
               set t.menge = nvl(t.menge, 0)         - nvl(io_bew.menge, 0),
                   t.menge_b = nvl(t.menge_b, 0)     - nvl(io_bew.menge_b, 0),
                   t.schrott = nvl(t.schrott, 0)     - nvl(io_bew.schrott, 0),
                   t.brutto_kg = nvl(t.brutto_kg, 0) - nvl(io_bew.brutto_kg, 0)
             where t.firma_nr = io_bew.firma_nr
               and t.herkunft = io_bew.herkunft
               -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
               and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
               and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
               and t.aktion = v_aktion
               and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
               and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
               and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
               and t.lte_nr = io_bew.lte_nr
               and t.charge = io_bew.charge
               and t.artikel = io_bew.artikel
             and t.bew_id = v_s_erp_bew.bew_id;
            v_found := FALSE;
          end if;
        else
          if v_s_erp_bew.aktion = 'KOM'
          then
            update s_erp_send_bew t
               set t.menge = nvl(t.menge, 0)         + nvl(io_bew.menge, 0),
                   t.menge_b = nvl(t.menge_b, 0)     + nvl(io_bew.menge_b, 0),
                   t.schrott = nvl(t.schrott, 0)     + nvl(io_bew.schrott, 0),
                   t.brutto_kg = nvl(t.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0),
                   t.ist_bestand = io_bew.ist_bestand,
                   t.lhm_nr = NULL,
                   t.komm_q_rest_lte = v_q_lte_r_menge
             where t.firma_nr = io_bew.firma_nr
               and t.herkunft = io_bew.herkunft
             -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
               and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
               and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
               and t.aktion = v_aktion
               and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
               and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
               and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
               and t.lte_nr = io_bew.lte_nr
               and t.charge = io_bew.charge
               and t.artikel = io_bew.artikel
               and t.bew_id = v_s_erp_bew.bew_id;
          else
             v_found := FALSE;
          end if;
        end if;
      end if;

      if not v_found
      then
        -- -AG- 20200923 - Weitere Paramert in die Schnittstelle geschrieben (LAM_SEL und NR_PRUEFUNG)
        insert into s_erp_send_bew
           values (
              io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
              io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
              v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
              io_bew.auf_id,               -- AUF_ID          NUMBER,
              'N',                         -- STATUS          VARCHAR2(3),
              v_aktion,                    -- AKTION          VARCHAR2(3),
              io_bew.leitzahl,             -- FA
              io_bew.fa_ag,                -- FA_AG
              io_bew.fa_upos,              -- FA_UPOS
              io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
              io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER(3),
              io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
              io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
              io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
              io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
              io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
              io_bew.menge,                -- MENGE           NUMBER(12,3),
              io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
              io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
              io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
              io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
              io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
              v_artikel.mengeneinheit,     -- Euscher SAP hat alle ME in Grossbuchstaben
                                           -- Aus Artikel lesen
              io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
              io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
              io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
              v_auftr.tour,                -- EXT_TOUR  N VARCHAR2(20)  Y     Tornummer aus ERP oder anderer Erfassung oder = Vorgang_ID
              v_auftr.vorgang,             -- VORGANG_ID  N NUMBER  Y     Nummer um die Positionen zu Klammern Z.B. Tourennummer
              v_auftr.auftrag,             -- EXT_AUFTRAG N NUMBER  Y     Auftragsnummer / Bestellung im DIAF
              v_auftr.pos_nr,              -- EXT_POS_NR  N NUMBER  Y     Positionsnummer
              v_auftr.upos_nr,             -- EXT_UPOS_NR N NUMBER  Y     Unterposition Bsp.: Eine Position mit n Chargen etc.
              io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
              io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
              v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
              v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
              io_bew.charge,               -- CHARGE          VARCHAR2(20),
              io_bew.serie,                -- SERIE           VARCHAR2(20),
              io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
              io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
              io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
              to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss'),
                                           -- B_DATUM         DATE,
              io_bew.bew_id,               -- bew_id
              io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
              NULL,                        -- RET_CODE        VARCHAR2(20),
              0,                           -- CYCLE           NUMBER
              sysdate,
              v_lam.lieferant_nr,
              -- Umpackn bei Kommisssionierung wird dierekt aus KOMM-Dialog geschrieben
              v_q_lte_id,                  --KOMM_Q_LTE_ID  N VARCHAR2(20)  Y     Quell LTE bei Kommissionierung
              v_z_lte_id,                  --KOMM_Z_LTE_ID  N VARCHAR2(20)  Y     Ziel LTE bei Kommissionierung
              NULL,                        --KOMM_Q_LHM_ID  N VARCHAR2(20)  Y     Quell LHM bei Kommissionierung
              NULL,                        --KOMM_Z_LHM_ID  N VARCHAR2(20)  Y     Ziel LHM bei Kommissionierung
              v_q_lte_r_menge,             --KOMM_Q_REST_LTE  N NUMBER  Y     Dann Rest in LTE
              NULL,                        --KOMM_Q_REST_LHM  N NUMBER  Y     Dann Rest in LHM
              NULL,                        --AKTION_HOST    Customer Host_AKTION
              nvl(io_bew.lagerplatz,       --LAGERPLATZ N VARCHAR2(10)  Y     Lagerplatz im ISI
                  v_lam.lgr_platz),
              io_bew.zlagerplatz,          --ZLAGERPLATZ  N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,                        -- WICKELPROGRAMM  N VARCHAR2(4) Y     Wickel Programm Nr. mit der die LTE aktuell gewickelt werden soll
              NULL,                        -- INVENTURDIFFERENZ N NUMBER  Y     Inventurdifferenz
              NULL,                        -- EXT_HOST_REFERENZ N VARCHAR2(20)  Y     Externe Referenz Hostsystem z.B. IDOC Nr. (Wird nich von den ISIPLus-Standardprozessen gefüllt)
              nvl(io_bew.labor_status,        -- LABOR_STATUS N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                  v_lam.labor_status),
              nvl(io_bew.lam_sel1,            -- LAM_SEL1 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel1),
              nvl(io_bew.lam_sel2,            -- LAM_SEL2 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel2),
              nvl(io_bew.lam_sel3,            -- LAM_SEL3 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel3),
              nvl(io_bew.lam_sel4,            -- LAM_SEL4 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel4),
              nvl(io_bew.lam_sel5,            -- LAM_SEL5 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel5),
              nvl(io_bew.lam_sel6,            -- LAM_SEL6 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel6),
              nvl(io_bew.lam_sel7,            -- LAM_SEL7 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel7),
              nvl(io_bew.lam_sel8,            -- LAM_SEL8 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel8),
              nvl(io_bew.lam_sel9,            -- LAM_SEL9 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel9),
              nvl(io_bew.lam_sel10,           -- LAM_SEL10  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                  v_lam.lam_sel10),
              io_bew.lte_name,            -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              nvl(io_bew.order_pos_auf_id,    -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                  v_lam.order_pos_auf_id),
              v_lam.nr_pruefung,              -- PRUEF_PLAN_NUMMERN          Prüfplannummern, die für diese Charge vergeben wurde (Prüfnummer, nicht die ID des Prüfplans). Alle Prüfplannummern, die in der LTE enthalten sind konkateniert.
              sysdate,                    -- CREATED_DATE
              -1,                         -- CREATED_LOGIN_ID
              NULL,                       -- LAST_CHANGE_DATE
              NULL,                       -- LAST_CHANGE_LOGIN_ID
              io_bew.ruest_zeit_erf,      -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              io_bew.prod_zeit_erf        -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              );

      end if;

      io_bew.send_id := io_bew.bew_id;
    end if;

    ---------------------------------------------------------------------------------------------
    -- EUSCHER SAP              EUSCHER SAP              EUSCHER SAP              EUSCHER SAP
    --               EUSCHER SAP              EUSCHER SAP              EUSCHER SAP
    ---------------------------------------------------------------------------------------------
    if v_sid.sid_schnittstelle = 'EUS_SAP'
    then
      if io_bew.lam_id is not NULL
      then
        -- Bei eus_sap dürfen keine Lagerbewegungen mit Zwischenprodukten
        -- (LAM_AG != NULL) übertragen werden !!!
        if io_bew.lam_ag is not NULL
        then
          return;
        end if;
      end if;
      if io_bew.aktion = 'L' -- Gelöscht nicht an SAP senden
      then
        return;
      end if;

      -- Bei Euscher soll nur Fertig gemeldet werden
      if io_bew.auf_id is NULL then
        v_bew_tabelle := NULL;
      else
        -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
        if io_bew.tabelle = 'S_AUF'
        then
           v_bew_tabelle := 'S_AUFTR';
         else
           v_bew_tabelle := io_bew.tabelle;
         end if;
      end if;

      v_aktion := io_bew.aktion;

      -- WAI im SAP nur mit FA-Auftrag oder Lieferung
      if v_bew_tabelle is NULL
      and v_aktion = 'WAI'
      then
        return;
      end if;

      -- -AG- 05.01.2009 Im SAP Kommission nicht uebermitteln
      if v_aktion = 'WAK'
      or v_aktion = 'WEK'
      then
        return;
      end if;

      OPEN c_eus_sap_send_bew_auftr;
      FETCH c_eus_sap_send_bew_auftr into v_s_eus_sap_bew;
      v_found := c_eus_sap_send_bew_auftr%found;
      CLOSE c_eus_sap_send_bew_auftr;

      if v_found
      then
        if v_aktion = 'BLF'
        then
          return;
        end if;
      end if;

      if lvs_p_base.get_lam(v_sid.sid, io_bew.firma_nr, io_bew.lam_id, v_lam)
      then
        if v_lam.owner_address_id is NOT null            -- KONSI Bestand
        and v_aktion != 'KWE'                            -- Diese Buchungen dürfen dann an SAP nicht gemeldet werden
        and v_aktion != 'KWA'
        and v_aktion != 'WKE'
        then
          return;
        end if;
      end if;

      v_found := FALSE;

      -- Bestellung fertig kommt immer nur aus SAP und wird nicht zurückgemeldet
      if v_aktion = 'BEF'
      then
        return;
      end if;
      if v_aktion in ('WAS', 'WAI', 'WEI', 'WAE', 'WEE', 'INV', 'WUI', 'KWE', 'KWA', 'LIF')
      then
        if (v_aktion = 'WEE'
         or v_aktion = 'KWE'
         or v_aktion = 'LIF')
        and v_bew_tabelle is not NULL
        then
          if not isi_allg.get_artikel_by_artikel_nr(io_bew.artikel,
                                                    v_artikel)
          then
            v_artikel := NULL;
          end if;
          v_auftr := NULL;
          v_auftr.auftrag := NULL;
          v_auftr.pos_nr := NULL;

          OPEN c_auftr;
          FETCH c_auftr into v_auftr;
          CLOSE c_auftr;


          if io_bew.aktion != 'LIF'
          then
            if isi_p_order_base.get_order_be_pos(v_sid.sid,
                                                 v_auftr.auftrag,
                                                 v_auftr.auftrag,
                                                 v_auftr.pos_nr,
                                                 v_order_pos)
            and v_artikel.artikel_p1 is not NULL
            then

              OPEN c_s_qs_babtec_wee;
              FETCH c_s_qs_babtec_wee into v_s_qs_babtec_wee;
              v_found := c_s_qs_babtec_wee%found;
              CLOSE c_s_qs_babtec_wee;

              if not v_found
              then
                insert into s_qs_babtec_wee
                            (BESTELLNUMMER,
                             BESTELLPOSITION,
                             ARTIKEL,
                             LIEFERANTENNR,
                             LIEFERSCHEINNR,
                             LIEFERTERMIN,
                             LIEFERDATUM,
                             LIEFERMENGESOLL,
                             LIEFERMENGEIST,
                             BESTELLDATUM,
                             LTEID,
                             PREISPROEINHEIT,
                             SOLLTERMIN,
                             LAGERPLATZ,
                             CHARGE,
                             ME,
                             BENUTZER1,
                             BENUTZER2,
                             BENUTZER3,
                             BENUTZER4,
                             BENUTZER5,
                             BENUTZER6,
                             status,
                             erstell_datum,
                             bearb_datum,
                             fehler_code,
                             fehler_text)
                         values
                            (v_order_pos.vorgang_id,
                             v_order_pos.pos_nr,
                             v_artikel.artikel,
                             v_auftr.adr_nr,
                             v_lam.li_nr_lief,
                             null,
                             sysdate,
                             v_order_pos.soll_menge,
                             nvl(io_bew.menge, 0),
                             v_order_pos.order_datum,
                             io_bew.lte_nr,
                             nvl(v_artikel.preis_standard,
                                 v_artikel.preis_gleitend),
                             v_order_pos.liefer_datum,
                             io_bew.lagerort,
                             io_bew.charge,
                             upper(v_artikel.mengeneinheit),      -- Euscher SAP hat alle ME in Grossbuchstaben,
                             NULL,                                -- BENUTZER1
                             NULL,                                -- BENUTZER2
                             NULL,                                -- BENUTZER3
                             NULL,                                -- BENUTZER4
                             NULL,                                -- BENUTZER5
                             NULL,                                -- BENUTZER6
                             'N',
                             sysdate,
                             NULL,
                             NULL,
                             NULL
                );
              else
                update s_qs_babtec_wee t
                   set t.liefermengeist = nvl(t.liefermengeist, 0) + nvl(io_bew.menge, 0)
                 where t.bestellnummer = v_order_pos.vorgang_id
                   and t.bestellposition = v_order_pos.pos_nr
                   and t.artikel = v_artikel.artikel
                   and t.lteid = io_bew.lte_nr;
              end if;
            end if;

          else
            begin
              if isi_p_order_base.get_order_pos(v_sid.sid,
                                                io_bew.order_pos_auf_id,
                                                v_order_pos)
              then
                insert into s_qs_babtec_wa_lief
                  (auftragnummer,
                   artikel,
                   lieferscheinnr,
                   lieferscheinpos,
                   lieferdatum,
                   liefermengesoll,
                   liefermengeist,
                   sollterminliefern,
                   istterminliefern,
                   kundennr,
                   bestellnr,
                   bestelldatum,
                   status,
                   erstell_datum,
                   bearb_datum,
                   fehler_code,
                   fehler_text)
                values
                  (v_order_pos.auf_id,
                   v_artikel.artikel,
                   v_order_pos.li_nr,
                   v_order_pos.li_pos_nr,
                   v_order_pos.fertig_datum,
                   v_order_pos.soll_menge,
                   nvl(io_bew.menge, 0),
                   v_order_pos.liefer_datum,
                   v_order_pos.fertig_datum,
                   v_auftr.adr_nr,
                   v_order_pos.best_nr_kunde,
                   v_order_pos.order_datum,
                   'N',
                   sysdate,
                   NULL,
                   NULL,
                   NULL);
              end if;
            exception
              when others then NULL; -- Eintrag ist schon da
            end;
          end if;
        end if;
        OPEN c_s_eus_sap_send_bew;
        FETCH c_s_eus_sap_send_bew into v_s_eus_sap_bew;
        v_found := c_s_eus_sap_send_bew%found;
        CLOSE c_s_eus_sap_send_bew;

        if v_found
        then
          if (v_aktion = 'WUI'
          or  v_aktion = 'WAS'
          or  v_aktion = 'INV'
          or  v_aktion = 'IVZ')
          and v_lam.labor_status != c.LAB_STAT_F
          then
            v_found := FALSE;
            isi_p_log.db_act_log('s_eus_sap_send_bew', 'insert into s_eus_sap_send_bew', 'insert into s_eus_sap_send_bew', 'insert', 'insert into wegen gesperrter Ware.');
          else
            -- Bei SAP führen 0 Mengen buchungen zum Fehler daher nicht schreiben
            -- IST_BESTAND ist nur bei Bestandsabgleich und Gezählter Inventur
            -- Relevant. Diese sollen immer geschickt werden
            if  0 = nvl(v_s_eus_sap_bew.menge, 0)     + nvl(io_bew.menge, 0)
            and 0 = nvl(v_s_eus_sap_bew.menge_b, 0)   + nvl(io_bew.menge_b, 0)
            and 0 = nvl(v_s_eus_sap_bew.schrott, 0)   + nvl(io_bew.schrott, 0)
            and 0 = nvl(v_s_eus_sap_bew.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0)
            and v_s_eus_sap_bew.aktion != 'TF'
            and v_s_eus_sap_bew.aktion != 'F'
            and v_s_eus_sap_bew.aktion != 'LIF'
            and v_s_eus_sap_bew.aktion != 'BLF'
            and v_s_eus_sap_bew.aktion != 'BEF'
            and v_s_eus_sap_bew.aktion != 'BAG'
            and v_s_eus_sap_bew.aktion != 'IVZ'
            and v_s_eus_sap_bew.aktion != 'SB'
            and v_s_eus_sap_bew.aktion != 'SE'
            and v_s_eus_sap_bew.aktion != 'SW'
            and v_s_eus_sap_bew.aktion != 'RS'
            and v_s_eus_sap_bew.aktion != 'RE'
            and v_s_eus_sap_bew.aktion != 'PS'
            and v_s_eus_sap_bew.aktion != 'PE'
            and v_s_eus_sap_bew.aktion != 'SG'
            then
              delete s_eus_sap_send_bew t
               where t.firma_nr = io_bew.firma_nr
                 and t.herkunft = io_bew.herkunft
                 -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
                 and nvl(t.tabelle, 'keine') = nvl(decode(io_bew.tabelle, 'S_AUF', 'S_AUFTR', io_bew.tabelle), 'keine')
                 and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
                 and t.aktion = v_aktion
                 and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
                 and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
                 and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
                 and t.lte_nr = io_bew.lte_nr
                 and t.charge = io_bew.charge
                 and t.artikel = io_bew.artikel
                 and t.ts = v_s_eus_sap_bew.ts;
            elsif v_s_eus_sap_bew.aktion != 'SB'
              and v_s_eus_sap_bew.aktion != 'SE'
              and v_s_eus_sap_bew.aktion != 'SW'
              and v_s_eus_sap_bew.aktion != 'RS'
              and v_s_eus_sap_bew.aktion != 'RE'
              and v_s_eus_sap_bew.aktion != 'PS'
              and v_s_eus_sap_bew.aktion != 'PE'
              and v_s_eus_sap_bew.aktion != 'SG'
            then
              update s_eus_sap_send_bew t
                 set t.menge = nvl(t.menge, 0)         + nvl(io_bew.menge, 0),
                     t.menge_b = nvl(t.menge_b, 0)     + nvl(io_bew.menge_b, 0),
                     t.schrott = nvl(t.schrott, 0)     + nvl(io_bew.schrott, 0),
                     t.brutto_kg = nvl(t.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0),
                     t.ist_bestand = io_bew.ist_bestand,
                     t.lhm_nr = NULL
               where t.firma_nr = io_bew.firma_nr
                 and t.herkunft = io_bew.herkunft
                 -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
                 and nvl(t.tabelle, 'keine') = nvl(decode(io_bew.tabelle, 'S_AUF', 'S_AUFTR', io_bew.tabelle), 'keine')
                 and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
                 and t.aktion = v_aktion
                 and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
                 and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
                 and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
                 and t.lte_nr = io_bew.lte_nr
                 and t.charge = io_bew.charge
                 and t.artikel = io_bew.artikel
                 and t.ts = v_s_eus_sap_bew.ts;
              if sql%rowcount != 1
              then
                update s_eus_sap_send_bew t
                   set t.menge = nvl(t.menge, 0)         - nvl(io_bew.menge, 0),
                       t.menge_b = nvl(t.menge_b, 0)     - nvl(io_bew.menge_b, 0),
                       t.schrott = nvl(t.schrott, 0)     - nvl(io_bew.schrott, 0),
                       t.brutto_kg = nvl(t.brutto_kg, 0) - nvl(io_bew.brutto_kg, 0)
                 where t.firma_nr = io_bew.firma_nr
                   and t.herkunft = io_bew.herkunft
                   -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
                   and nvl(t.tabelle, 'keine') = nvl(decode(io_bew.tabelle, 'S_AUF', 'S_AUFTR', io_bew.tabelle), 'keine')
                   and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
                   and t.aktion = v_aktion
                   and t.status = 'N'  -- Hier ist der neue Status 'N' und nicht NULL
                   and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
                   and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
                   and t.lte_nr = io_bew.lte_nr
                   and t.charge = io_bew.charge
                   and t.artikel = io_bew.artikel
                   and t.ts = v_s_eus_sap_bew.ts;
                v_found := FALSE;
              end if;
            else
              v_found := FALSE;
            end if;
          end if;
        end if;
      else
        v_found := false;
      end if;
      if not v_found
      then
        -- Bei SAP führen 0 Mengen buchungen zum Fehler daher nicht schreiben
        if  0 = nvl(io_bew.menge, 0)
        and io_bew.aktion != 'AA'
        and io_bew.aktion != 'RF'
        and io_bew.aktion != 'TF'
        and io_bew.aktion != 'F'
        and io_bew.aktion != 'LIF'
        and io_bew.aktion != 'BLF'
        and io_bew.aktion != 'BEF'
        and io_bew.aktion != 'BAG'
        and io_bew.aktion != 'IVZ'
        and io_bew.aktion != 'SB'
        and io_bew.aktion != 'SE'
        and io_bew.aktion != 'SW'
        and io_bew.aktion != 'RS'
        and io_bew.aktion != 'RE'
        and io_bew.aktion != 'PS'
        and io_bew.aktion != 'PE'
        and io_bew.aktion != 'SG'
        then
          return;
        end if;
        if not isi_allg.get_artikel_by_artikel_nr(io_bew.artikel,
                                                  v_artikel)
        then
          v_artikel := NULL;
        end if;

        v_auftr := NULL;
        v_auftr.auftrag := NULL;
        v_auftr.pos_nr := NULL;

        if v_aktion = 'WEE'                -- Bestellung
        or v_aktion = 'KWE'
        then
          -- -AG- Anpassung SAP aus Worshop vom 30.10.2014
          io_bew.ext_lief_nr := v_lam.li_nr_lief;

          OPEN c_auftr;
          FETCH c_auftr into v_auftr;
          CLOSE c_auftr;
          if v_auftr.satzart = 'RK'                          -- Reture kunde
          then
            if v_aktion = 'WEE'                              -- Bestellung Wareneingan extern
            then
              v_aktion := 'REE';                             -- Retouren Wareneingan muss im SAP in Lieferungen übergeben werden
              io_bew.ext_lief_nr  := v_auftr.li_nr;          -- EXT_LIEF_NR     VARCHAR2(15),
              io_bew.ext_lief_pos := v_auftr.li_pos_nr;      -- EXT_LIEF_POS    VARCHAR2(5),
            end if;
          end if;

        end if;

        -- -AG- 2010.05.05 Erweiterung Proj 5356-2010
        if v_aktion = 'WUI'
        or v_aktion = 'WAS'
        or (v_aktion = 'INV'
         and io_bew.menge < 0)
        or (v_aktion = 'IVZ'
         and io_bew.menge < 0)
        then
          if v_lam.labor_status != c.LAB_STAT_F
          then
            insert into s_eus_sap_send_bew     -- Aus dem gesperretn Bestand auf dem Host in den freien buchen
               values (
                  io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                  io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                  v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                  io_bew.auf_id,               -- AUF_ID          NUMBER,
                  'N',                         -- STATUS          VARCHAR2(3),
                  'FRE',                       -- AKTION          VARCHAR2(3),
                  io_bew.leitzahl,             -- FA
                  io_bew.fa_ag,                -- FA_AG
                  io_bew.fa_upos,              -- FA_UPOS
                  io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                  io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER(3),
                  io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                  io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                  io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                  io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
                  null,                        -- ZLAGERORT       VARCHAR2(10),
                  abs(io_bew.menge),           -- MENGE           NUMBER(12,3),
                  io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                  io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                  io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                  io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                  io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                  upper(v_artikel.mengeneinheit),      -- Euscher SAP hat alle ME in Grossbuchstaben
                                               -- Aus Artikel lesen
                  io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                  io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                  io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                  io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                  io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                  v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                  v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                  io_bew.charge,               -- CHARGE          VARCHAR2(20),
                  io_bew.serie,                -- SERIE           VARCHAR2(20),
                  io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                  io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                  io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                  to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss'),
                                               -- B_DATUM         DATE,
                  io_bew.bew_id,               -- TS
                  io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                  NULL,                        -- RET_CODE        VARCHAR2(20),
                  0,                           -- CYCLE           NUMBER
                  sysdate,
                  null);
            select seq_s_send_bew_id.nextval into io_bew.bew_id from dual;
          end if;
        end if;

        insert into s_eus_sap_send_bew
           values (
              io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
              io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
              v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
              io_bew.auf_id,               -- AUF_ID          NUMBER,
              'N',                         -- STATUS          VARCHAR2(3),
              decode (v_aktion,
                      'WAK', 'WAI',        -- eus_sap kennt keine Kommissionierung Direkt
                      'WEK', 'WEI',        -- eus_sap kennt keine Kommissionierung Direkt
                      v_aktion),           -- AKTION          VARCHAR2(3),
              io_bew.leitzahl,             -- FA
              io_bew.fa_ag,                -- FA_AG
              io_bew.fa_upos,              -- FA_UPOS
              io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
              io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER(3),
              io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
              io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
              io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
              io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
              io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
              io_bew.menge,                -- MENGE           NUMBER(12,3),
              io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
              io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
              io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
              io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
              io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
              upper(v_artikel.mengeneinheit),      -- Euscher SAP hat alle ME in Grossbuchstaben
                                           -- Aus Artikel lesen
              io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
              io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
              io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
              io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
              io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
              v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
              v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
              io_bew.charge,               -- CHARGE          VARCHAR2(20),
              io_bew.serie,                -- SERIE           VARCHAR2(20),
              io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
              io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
              io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
              to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss'),
                                           -- B_DATUM         DATE,
              io_bew.bew_id,               -- TS
              io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
              NULL,                        -- RET_CODE        VARCHAR2(20),
              0,                           -- CYCLE           NUMBER
              sysdate,
              v_lam.lieferant_nr);

          io_bew.send_id := io_bew.bew_id;

        if v_aktion = 'WUI'
        or (v_aktion = 'INV'
         and io_bew.menge > 0)
        or (v_aktion = 'IVZ'
         and io_bew.menge > 0)
        then
          if v_lam.labor_status != c.LAB_STAT_F
          then
            select seq_s_send_bew_id.nextval into io_bew.bew_id from dual;
            insert into s_eus_sap_send_bew     -- Jetzt wirder in den Sperrbestand
               values (
                  io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                  io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                  v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                  io_bew.auf_id,               -- AUF_ID          NUMBER,
                  'N',                         -- STATUS          VARCHAR2(3),
                  'SPR',                       -- AKTION          VARCHAR2(3),
                  io_bew.leitzahl,             -- FA
                  io_bew.fa_ag,                -- FA_AG
                  io_bew.fa_upos,              -- FA_UPOS
                  io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                  io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER(3),
                  io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                  io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                  io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                  decode (v_aktion,
                          'WUI', io_bew.zlagerort,
                          io_bew.lagerort),    -- LAGERORT        VARCHAR2(10),
                  null,                        -- ZLAGERORT       VARCHAR2(10),
                  io_bew.menge,                -- MENGE           NUMBER(12,3),
                  io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                  io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                  io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                  io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                  io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                  upper(v_artikel.mengeneinheit),      -- Euscher SAP hat alle ME in Grossbuchstaben
                                               -- Aus Artikel lesen
                  io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                  io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                  io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                  io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                  io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                  v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                  v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                  io_bew.charge,               -- CHARGE          VARCHAR2(20),
                  io_bew.serie,                -- SERIE           VARCHAR2(20),
                  io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                  io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                  io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                  to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss'),
                                               -- B_DATUM         DATE,
                  io_bew.bew_id,               -- TS
                  io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                  NULL,                        -- RET_CODE        VARCHAR2(20),
                  0,                           -- CYCLE           NUMBER
                  sysdate,
                  null);
          end if;
        end if;
      end if;
    end if;

    ---------------------------------------------------------------------------------------------
    -- SEAQUIST SAP              SEAQUIST SAP              SEAQUIST SAP              SEAQUIST SAP
    --               SEAQUIST SAP              SEAQUIST SAP              SEAQUIST SAP
    ---------------------------------------------------------------------------------------------
    if v_sid.sid_schnittstelle = 'SQD_SAP'
    then
      if io_bew.aktion = 'WAI'
      and io_bew.menge <= 0
      then
        return;
      end if;
      if io_bew.lam_id is not NULL
      then
        -- Bei sqd_sap dürfen keine Lagerbewegungen mit Zwischenprodukten
        -- (LAM_AG != NULL) übertragen werden !!!
        if io_bew.lam_ag is not NULL
        then
          return;
        end if;
      end if;
      if io_bew.aktion = 'L' -- Gelöscht nicht an SAP senden
      then
        return;
      end if;
      v_aktion := io_bew.aktion;
      if v_aktion != 'WUI'
      then
        v_bde_fa_ag := NULL;
        v_bde_fa_ag.abnr := 0;
        if v_aktion = 'WEI'             -- HU nur senden, wenn Wareneingang
        or v_aktion = 'PE'
        or v_aktion = 'PS'
        or v_aktion = 'LTE'
        or v_aktion = 'LHM'             -- Melden an SAP z.B. Menden
        then
          if not bde_p_base.get_fa_ag(v_sid.sid,
                                      io_bew.firma_nr,
                                      io_bew.leitzahl,
                                      io_bew.fa_ag,
                                      io_bew.fa_upos,
                                      v_bde_fa_ag)
          then
            v_bde_fa_ag := NULL;
            v_bde_fa_ag.abnr := 0;
          end if;
        end if;
        if v_aktion = 'TF'
        or v_aktion = 'F'
        then
          if isi_p_base.get_resource_zust_akt(v_sid.sid,
                                              io_bew.res_id,
                                              v_res_zust_akt)
          then
            io_bew.ma_s_grund := v_res_zust_akt.status_id;
          end if;
          v_bde_fa_ag.leitzahl := io_bew.leitzahl;
          v_bde_fa_ag.fa_ag := io_bew.fa_ag;
          v_bde_fa_ag.fa_upos := io_bew.fa_upos;
        end if;
      else
        if io_bew.lagerort != io_bew.zlagerort -- Lagerumbuchungen dürfen nicht gebucht werden
        then
          return;
        end if;
        v_res_zust_akt.status_id := io_bew.ma_s_grund;
        v_bde_fa_ag := NULL;
        v_bde_fa_ag.abnr := 0;
        if lvs_p_base.get_lam(v_sid.sid, io_bew.firma_nr, io_bew.lam_id, v_lam)
        then
          OPEN c_fa_auftrag;
          FETCH c_fa_auftrag into v_bde_fa_ag;
          v_found := c_fa_auftrag%FOUND;
          CLOSE c_fa_auftrag;
          if not v_found
          then
            v_bde_fa_ag := NULL;
            v_bde_fa_ag.abnr := 0;
          end if;
        end if;
        if v_bde_fa_ag.abnr != 0 -- Daten eintragen
        then
          io_bew.leitzahl := v_bde_fa_ag.leitzahl;
          io_bew.fa_ag := v_bde_fa_ag.fa_ag;
          io_bew.fa_upos := v_bde_fa_ag.fa_upos;
        end if;
      end if;

      v_bew_tabelle := io_bew.tabelle;

      -- Bei Seaquist soll nur Fertig gemeldet werden
      if io_bew.auf_id is NULL then
        v_bew_tabelle := NULL;
      end if;

      v_aktion := io_bew.aktion;

      -- WAI im SAP nur mit FA-Auftrag oder Lieferung
      if v_bew_tabelle is NULL
      and v_aktion = 'WAI'
      then
        return;
      end if;
      -- -AG- 05.01.2009 Im SAP Kommission nicht uebermitteln
      if v_aktion = 'WAK'
      or v_aktion = 'WEK'
      then
        return;
      end if;
      v_found := FALSE;

      -- Bestellung fertig kommt immer nur aus SAP und wird nicht zurückgemeldet
      if v_aktion = 'BEF'
      then
        return;
      end if;

      if v_aktion = 'WEI'
      then
        v_nve := '740485532' || substr(io_bew.lhm_nr, 8, 8);
        v_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_nve);

        -- lagerort mapping für HU-Management
        if v_bde_fa_ag.abnr != 0          -- Mit Kundenrelevanz
        then
          if io_bew.lagerort = '1121'
          then
            io_bew.lagerort := '1021';
          elsif io_bew.lagerort = '1122'
          then
            io_bew.lagerort := '1022';
          elsif io_bew.lagerort = '1123'
          then
            io_bew.lagerort := '1023';
          elsif io_bew.lagerort = '1124'
          then
            io_bew.lagerort := '1024';
          end if;
          if io_bew.zlagerort = '1121'
          then
            io_bew.zlagerort := '1021';
          elsif io_bew.zlagerort = '1122'
          then
            io_bew.zlagerort := '1022';
          elsif io_bew.zlagerort = '1123'
          then
            io_bew.zlagerort := '1023';
          elsif io_bew.zlagerort = '1124'
          then
            io_bew.zlagerort := '1024';
          end if;
        end if;

        OPEN c_s_sqd_sap_send_bew;
        FETCH c_s_sqd_sap_send_bew into v_s_sqd_sap_bew;
        v_found := c_s_sqd_sap_send_bew%found;
        CLOSE c_s_sqd_sap_send_bew;

        if v_found
        then
          -- Bei SAP führen 0 Mengen buchungen zum Fehler daher nicht schreiben
          -- IST_BESTAND ist nur bei Bestandsabgleich und Gezählter Inventur
          -- Relevant. Diese sollen immer geschickt werden
          if  0 = nvl(v_s_sqd_sap_bew.menge, 0)     + nvl(io_bew.menge, 0)
          and 0 = nvl(v_s_sqd_sap_bew.menge_b, 0)   + nvl(io_bew.menge_b, 0)
          and 0 = nvl(v_s_sqd_sap_bew.schrott, 0)   + nvl(io_bew.schrott, 0)
          and 0 = nvl(v_s_sqd_sap_bew.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0)
          then
            delete s_sqd_sap_send_bew t
             where t.firma_nr = io_bew.firma_nr
               and t.herkunft = io_bew.herkunft
               and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
               and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
               --and t.aktion = v_aktion
               and t.status = 'W'  -- Hier ist der neue Status 'N' und nicht NULL
               and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
               and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
               and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
               and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
               and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
               and t.lte_nr = io_bew.lte_nr
               and t.lhm_nr = v_nve
               and t.charge = io_bew.charge
               and t.artikel = io_bew.artikel
               and nvl(t.lagerort, '-1') = nvl(io_bew.lagerort, '-1')
               and nvl(t.zlagerort, '-1') = nvl(io_bew.zlagerort, '-1');
          else
            update s_sqd_sap_send_bew t
               set t.menge = nvl(t.menge, 0)         + nvl(io_bew.menge, 0),
                   t.menge_b = nvl(t.menge_b, 0)     + nvl(io_bew.menge_b, 0),
                   t.schrott = nvl(t.schrott, 0)     + nvl(io_bew.schrott, 0),
                   t.brutto_kg = nvl(t.brutto_kg, 0) + nvl(io_bew.brutto_kg, 0),
                   t.ist_bestand = io_bew.ist_bestand
             where t.firma_nr = io_bew.firma_nr
               and t.herkunft = io_bew.herkunft
               and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
               and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
               --and t.aktion = v_aktion
               and t.status = 'W'  -- Hier ist der neue Status 'N' und nicht NULL
               and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
               and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
               and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
               and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
               and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
               and t.lte_nr = io_bew.lte_nr
               and t.lhm_nr = v_nve
               and t.charge = io_bew.charge
               and t.artikel = io_bew.artikel
               and nvl(t.lagerort, '-1') = nvl(io_bew.lagerort, '-1')
               and nvl(t.zlagerort, '-1') = nvl(io_bew.zlagerort, '-1');
            if sql%rowcount != 3
            then
              update s_sqd_sap_send_bew t
                 set t.menge = nvl(t.menge, 0)         - nvl(io_bew.menge, 0),
                     t.menge_b = nvl(t.menge_b, 0)     - nvl(io_bew.menge_b, 0),
                     t.schrott = nvl(t.schrott, 0)     - nvl(io_bew.schrott, 0),
                     t.brutto_kg = nvl(t.brutto_kg, 0) - nvl(io_bew.brutto_kg, 0)
               where t.firma_nr = io_bew.firma_nr
                 and t.herkunft = io_bew.herkunft
                 and nvl(t.tabelle, 'keine') = nvl(io_bew.tabelle, 'keine')
                 and nvl(t.auf_id, -1) = nvl(io_bew.auf_id, -1)
                 --and t.aktion = v_aktion
                 and t.status = 'W'  -- Hier ist der neue Status 'N' und nicht NULL
                 and nvl(t.ext_lief_nr, -1) = nvl(io_bew.ext_lief_nr, -1)
                 and nvl(t.ext_lief_pos, -1) = nvl(io_bew.ext_lief_pos, -1)
                 and nvl(t.leitzahl, -1) = nvl(io_bew.leitzahl, -1)
                 and nvl(t.fa_ag, -1) = nvl(io_bew.fa_ag, -1)
                 and nvl(t.fa_upos, -1) = nvl(io_bew.fa_upos, -1)
                 and t.lte_nr = io_bew.lte_nr
                 and t.lhm_nr = v_nve
                 and t.charge = io_bew.charge
                 and t.artikel = io_bew.artikel
                 and nvl(t.lagerort, '-1') = nvl(io_bew.lagerort, '-1')
                 and nvl(t.zlagerort, '-1') = nvl(io_bew.zlagerort, '-1');
              v_found := FALSE;
            end if;
          end if;
        end if;
      else
        v_found := false;
      end if;

      if not v_found
      then
        -- Bei SAP führen 0 Mengen buchungen zum Fehler daher nicht schreiben
        if  0 = nvl(io_bew.menge, 0)
        and io_bew.aktion != 'AA'
        and io_bew.aktion != 'RF'
        and io_bew.aktion != 'TF'
        and io_bew.aktion != 'F'
        and io_bew.aktion != 'LTE'
        and io_bew.aktion != 'LHM'
        and io_bew.aktion != 'LIF'
        and io_bew.aktion != 'BLF'
        and io_bew.aktion != 'BEF'
        and io_bew.aktion != 'BAG'
        and io_bew.aktion != 'IVZ'
        and io_bew.aktion != 'SB'
        and io_bew.aktion != 'SE'
        and io_bew.aktion != 'SW'
        and io_bew.aktion != 'RS'
        and io_bew.aktion != 'RE'
        and io_bew.aktion != 'PS'
        and io_bew.aktion != 'PE'
        and io_bew.aktion != 'SG'
        then
          return;
        end if;
        if not isi_allg.get_artikel_by_artikel_nr(io_bew.artikel,
                                                  v_artikel)
        then
          v_artikel := NULL;
        end if;

        if   io_bew.aktion = 'RF'
        or   io_bew.aktion = 'RS'
        or   io_bew.aktion = 'RE'
        or   (io_bew.aktion = 'SG'
         and (io_bew.ma_s_grund = 209
           or io_bew.ma_s_grund = 200
           or io_bew.ma_last_s_grund = 209))
        then
          io_bew.fa_ag := '20';
        end if;

        if  io_bew.aktion = 'SG'  -- Beim Rüsten nur Rüsten start und Rüsten Ende senden
        and io_bew.ma_s_grund != 209
        and io_bew.ma_last_s_grund != 209
        and io_bew.ma_status = 'R'
        then
          return;
        end if;

        if (io_bew.aktion = 'SE'  -- Beim Rüsten nur Rüsten start und Rüsten Ende senden
         or io_bew.aktion = 'SB')
        and io_bew.ma_status = 'R'
        then
          return;
        end if;

        if io_bew.ma_status = 'R'
        and io_bew.aktion = 'PE'
        then
          update bde_fa_auftrag fa
             set fa.ruest_zeit_ist = nvl(fa.ruest_zeit_ist, 0) + 1 / 60,
                 fa.rcv_ruest_zeit_ist = nvl(fa.rcv_ruest_zeit_ist, 0) + 1 / 60
           where fa.sid = v_sid.sid
             and fa.firma_nr = io_bew.firma_nr
             and fa.leitzahl = io_bew.leitzahl
             and fa.fa_ag = io_bew.fa_ag
             and fa.fa_upos = io_bew.fa_upos
             and nvl(fa.rcv_ruest_zeit_ist, 0) = 0;
        end if;

        v_auftr := NULL;
        v_auftr.auftrag := NULL;
        v_auftr.pos_nr := NULL;

        if v_aktion = 'WUI'                  -- Umlagerung Intern dann karton zur Übergabe aktivieren (WEI)
        then
          v_nve := '740485532' || substr(io_bew.lhm_nr, 8, 8);
          v_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_nve);
          io_bew.lhm_nr := v_nve;
        end if;

        if v_aktion != 'WEI'                 -- Nicht bei Wareneingang (Diese meldung immer auf warten)
        then
          if  v_aktion = 'LTE'               -- Palettenwechsel
          and io_bew.leitzahl is not NULL    -- Innerhalb des Auftrags
          and v_bde_fa_ag.abnr != 0          -- Mit Kundenrelevanz
          then
            v_aktion := 'WEI';               -- Alle offenen WEI für diese Palette lesen
            OPEN c_s_sqd_sap_send_bew_wei;
            v_aktion := 'LTE';
            LOOP
              FETCH c_s_sqd_sap_send_bew_wei into v_s_sqd_sap_bew;
              EXIT when c_s_sqd_sap_send_bew_wei%notfound;

              -- Ab hier Lagerort Mapping
              if v_s_sqd_sap_bew.lagerort = '1121'
              then
                v_s_sqd_sap_bew.lagerort := '1021';
              elsif v_s_sqd_sap_bew.lagerort = '1122'
              then
                v_s_sqd_sap_bew.lagerort := '1022';
              elsif v_s_sqd_sap_bew.lagerort = '1123'
              then
                v_s_sqd_sap_bew.lagerort := '1023';
              elsif v_s_sqd_sap_bew.lagerort = '1124'
              then
                v_s_sqd_sap_bew.lagerort := '1024';
              end if;
              if v_s_sqd_sap_bew.zlagerort = '1121'
              then
                v_s_sqd_sap_bew.zlagerort := '1021';
              elsif v_s_sqd_sap_bew.zlagerort = '1122'
              then
                v_s_sqd_sap_bew.zlagerort := '1022';
              elsif v_s_sqd_sap_bew.zlagerort = '1123'
              then
                v_s_sqd_sap_bew.zlagerort := '1023';
              elsif v_s_sqd_sap_bew.zlagerort = '1124'
              then
                v_s_sqd_sap_bew.zlagerort := '1024';
              end if;

              -- Artikel passend lesen
              if not isi_allg.get_artikel_by_artikel_nr(v_s_sqd_sap_bew.artikel,
                                                        v_artikel)
              then
                v_artikel := NULL;
              end if;

              -- In Tabelle schreiben (WUI)
              select seq_s_send_bew_id.nextval into v_bew_id from dual;
              insert into s_sqd_sap_send_bew
                 values (
                    io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                    io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                    v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                    io_bew.auf_id,               -- AUF_ID          NUMBER,
                    'N',                         -- STATUS          VARCHAR2(3),
                    'WUI',                       -- AKTION          VARCHAR2(3),
                    io_bew.leitzahl,             -- FA
                    io_bew.fa_ag,                -- FA_AG
                    io_bew.fa_upos,              -- FA_UPOS
                    io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                    io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER,
                    io_bew.ma_last_s_grund,      -- MA_LAST_S_GRUND NUMBER,
                    io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                    io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                    v_s_sqd_sap_bew.lhm_nr,      -- LHM_NR          VARCHAR2(20),
                    v_s_sqd_sap_bew.lagerort,    -- LAGERORT        VARCHAR2(10),
                    v_s_sqd_sap_bew.zlagerort,   -- ZLAGERORT       VARCHAR2(10),
                    v_s_sqd_sap_bew.menge,       -- MENGE           NUMBER(12,3),
                    0,                           -- MENGE_B         NUMBER(12,3),
                    0,                           -- SCHROTT         NUMBER(12,3),
                    0,                           -- R_MENGE         NUMBER(12,3),
                    0,                           -- R_MENGE_B       NUMBER(12,3),
                    0,                           -- R_SCHROTT       NUMBER(12,3),
                    upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                                 -- Aus Artikel lesen
                    0,                           -- STOERZEIT_IST   NUMBER,
                    0,                           -- RUESTZEIT_IST   NUMBER,
                    0,                           -- PRODZEIT_IST    NUMBER,
                    NULL,                        -- EXT_LIEF_NR     VARCHAR2(15),
                    NULL,                        -- EXT_LIEF_POS    VARCHAR2(5),
                    v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                    v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                    v_s_sqd_sap_bew.charge,      -- CHARGE          VARCHAR2(20),
                    v_s_sqd_sap_bew.serie,       -- SERIE           VARCHAR2(20),
                    v_s_sqd_sap_bew.arbeitsplatz_id, -- ARBEITSPLATZ_ID VARCHAR2(20),
                    v_s_sqd_sap_bew.ist_bestand, -- IST_BESTAND     NUMBER,
                    v_s_sqd_sap_bew.artikel,     -- ARTIKEL         VARCHAR2(20),
                    to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss'),
                                                 -- B_DATUM         DATE,
                    v_bew_id,                    -- TS
                    v_s_sqd_sap_bew.brutto_kg,   -- BRUTTO_KG       NUMBER(12,3),
                    NULL,                        -- RET_CODE        VARCHAR2(20),
                    0,                           -- CYCLE           NUMBER
                    io_bew.pers_nr,              -- PERS_NR         NUMBER
                    NULL,
                    NULL,
                    NULL,
                    NULL);
            end LOOP;
            CLOSE c_s_sqd_sap_send_bew_wei;
          end if;

          if v_aktion != 'WUI'               -- Nicht Umlagerung Intern dann keine Palettennummer
          then
            io_bew.lte_nr := NULL;
          else
            if io_bew.menge <= 0             -- Nur den Zugang auf die Palette melden
            then
              return;                        -- Bei WUI und < 0
            end if;
          end if;

          -- Bei Auftragsende oder Palettenwechsel
          -- Alle offenen Einträge schicken (XPE und XPS sind hier die nicht gesendeten Rückmeldungen Produktion)
          if v_aktion = 'PE'
          or v_aktion = 'LTE'
          or v_aktion = 'LHM'
          or v_aktion = 'TF'
          or v_aktion = 'F'
          then
            -- -AG- alle LHMs mit Status W müssen noch an das SAP gesendet werden.
            -- Die Time Confirmation an das SAP muss für jede LHM geprüft werden.
            -- Falls die reihenfolge nicht stimmt, dann muss der Zeitpunkt verschoben
            -- werden, da SAP sonst nicht buchen kann
            OPEN c_s_sqd_sap_send_bew_pe;
            FETCH c_s_sqd_sap_send_bew_pe into v_s_sqd_sap_bew_pe;
            LOOP
              EXIT when c_s_sqd_sap_send_bew_pe%NOTFOUND;

              OPEN c_s_sqd_sap_send_bew_tc;
              FETCH c_s_sqd_sap_send_bew_tc into v_max_date_tc;
              CLOSE c_s_sqd_sap_send_bew_tc;
              v_max_date_tc := nvl(v_max_date_tc, io_bew.b_datum);

              if v_max_date_tc < sysdate
              then
                v_max_date_tc := sysdate;
              else
                v_max_date_tc := v_max_date_tc + (1 / 86400);
              end if;

              begin -- Bei Fehler, diese markieren und weiter machen
                v_nve := '740485532' || substr(io_bew.lhm_nr, 8, 8);
                v_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_nve);

                if v_aktion <> 'LHM'
                or v_nve = v_s_sqd_sap_bew_pe.lhm_nr
                then
                  v_nve := v_s_sqd_sap_bew_pe.lhm_nr;

                  if io_bew.ma_s_grund > 200
                  then
                    select seq_s_send_bew_id.nextval into v_bew_id from dual;
                      update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                       set t.status = 'NW',            -- Alle offenen Einträge schicken
                           t.lhm_nr = NULL,            -- evtl. ohne Boxnummer
                           t.lte_nr = NULL,            -- WEI immer ohne Palettennummer
                           t.aktion = 'PS',
                           t.menge = 0,
                           t.menge_b = 0,
                           t.schrott = 0,
                           t.ma_s_grund = 0,
                           t.ma_last_s_grund = 0,
                           t.charge = NULL,
                           t.b_datum = to_char(v_max_date_tc, 'dd.mm.yyyy hh24:mi:ss'),
                           t.ts = v_bew_id
                     where t.aktion = 'XPE'
                       and t.status = 'W'
                       and t.leitzahl = io_bew.leitzahl
                       and t.fa_ag = io_bew.fa_ag
                       and t.lhm_nr = v_nve;
                    select seq_s_send_bew_id.nextval into v_bew_id from dual;
                    update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                       set t.status = 'NW',            -- Alle offenen Einträge schicken
                           t.lhm_nr = NULL,            -- evtl. ohne Boxnummer
                           t.lte_nr = NULL,            -- WEI immer ohne Palettennummer
                           t.aktion = 'SG',
                           t.menge_b = 0,
                           t.schrott = 0,
                           t.ma_s_grund = nvl(io_bew.ma_s_grund, 206),
                           t.ma_last_s_grund = 0,
                           t.charge = NULL,
                           t.b_datum = to_char(v_max_date_tc + (1 / 86400), 'dd.mm.yyyy hh24:mi:ss'),
                           t.ts = v_bew_id
                     where t.aktion = 'XPS'
                       and t.status = 'W'
                       and t.leitzahl = io_bew.leitzahl
                       and t.fa_ag = io_bew.fa_ag
                       and t.lhm_nr = v_nve;
                  else
                    select seq_s_send_bew_id.nextval into v_bew_id from dual;
                    update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                       set t.status = 'NW',            -- Alle offenen Einträge schicken
                           t.lhm_nr = NULL,
                           t.lte_nr = NULL,             -- WEI immer ohne Palettennummer
                           t.aktion = 'SG',
                           t.menge_b = 0,
                           t.schrott = 0,
                           t.ma_s_grund = 206,
                           t.ma_last_s_grund = 0,
                           t.charge = NULL,
                           t.b_datum = to_char(v_max_date_tc, 'dd.mm.yyyy hh24:mi:ss'),
                           t.ts = v_bew_id
                     where t.aktion = 'XPE'
                       and t.status = 'W'
                       and t.leitzahl = io_bew.leitzahl
                       and t.fa_ag = io_bew.fa_ag
                       and t.lhm_nr = v_nve;
                    select seq_s_send_bew_id.nextval into v_bew_id from dual;
                    update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                       set t.status = 'NW',            -- Alle offenen Einträge schicken
                           t.lhm_nr = NULL,-- evtl. ohne Boxnummer
                           t.lte_nr = NULL,             -- WEI immer ohne Palettennummer
                           t.aktion = 'PS',
                           t.menge = 0,
                           t.menge_b = 0,
                           t.schrott = 0,
                           t.ma_s_grund = 0,
                           t.ma_last_s_grund = 0,
                           t.charge = NULL,
                           t.b_datum = to_char(v_max_date_tc + (1 / 86400), 'dd.mm.yyyy hh24:mi:ss'),
                           t.ts = v_bew_id
                     where t.aktion = 'XPS'
                       and t.status = 'W'
                       and t.leitzahl = io_bew.leitzahl
                       and t.fa_ag = io_bew.fa_ag
                       and t.lhm_nr = v_nve;
                  end if;
                end if;
              exception
                when others then
                  update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                     set t.status = 'ERR'            -- Merken hier ist ein Fehler
                   where t.status = 'W'
                     and t.leitzahl = io_bew.leitzahl
                     and t.fa_ag = io_bew.fa_ag
                     and t.lhm_nr = v_nve;
              end;
              FETCH c_s_sqd_sap_send_bew_pe into v_s_sqd_sap_bew_pe;
            end LOOP;
            CLOSE c_s_sqd_sap_send_bew_pe;

            -- -AG- BugFix: Nur in diesen Fällen den Wareneingang buchen
            if v_aktion = 'PE'
            or v_aktion = 'LTE'
            then
              -- Wareneingann jetzt übertragen
              update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                 set t.status = 'N',             -- Alle offenen Einträge schicken
                     t.lhm_nr = decode(v_bde_fa_ag.abnr, -- Wenn ABNR is NULL dann Lagerauftrag
                                       0, NULL,  -- SEAQUIST lagerauftrag
                                       t.lhm_nr),-- evtl. ohne Boxnummer
                     t.lte_nr = NULL             -- WEI immer ohne Palettennummer
               where t.leitzahl = io_bew.leitzahl
                 and t.fa_ag = io_bew.fa_ag
                 and t.fa_upos = io_bew.fa_upos
                 and ((t.aktion = 'WEI'
                   and t.status = 'W')
                   or  t.status = 'NW');
            end if;
            if v_aktion = 'LHM'
            then
              -- Wareneingann jetzt übertragen
              update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                 set t.status = 'N',             -- Alle offenen Einträge schicken
                     t.lhm_nr = decode(v_bde_fa_ag.abnr, -- Wenn ABNR is NULL dann Lagerauftrag
                                       0, NULL,  -- SEAQUIST lagerauftrag
                                       t.lhm_nr),-- evtl. ohne Boxnummer
                     t.lte_nr = NULL             -- WEI immer ohne Palettennummer
               where t.leitzahl = io_bew.leitzahl
                 and t.fa_ag = io_bew.fa_ag
                 and t.fa_upos = io_bew.fa_upos
                 and t.status = 'NW'
                 or t.lhm_nr = v_nve
                 and t.status = 'W';
            end if;
          end if;

          if v_bde_fa_ag.abnr = 0            -- SEAQUIST lagerauftrag
          or  (v_aktion != 'WEI'             -- HU nur senden, wenn Wareneingang
           and v_aktion != 'WUI')            --    oder Umlagen
          then
            io_bew.lte_nr := NULL;
            io_bew.lhm_nr := NULL;
          end if;
        end if;

        if v_aktion = 'WUI'                  -- Umlagerung Intern dann karton zur Übergabe aktivieren (WEI)
        then
          if isi_p_base.get_resource_zust_akt(v_sid.sid,
                                              io_bew.res_id,
                                              v_res_zust_akt)
          then
            OPEN c_s_sqd_sap_send_bew_tc;
            FETCH c_s_sqd_sap_send_bew_tc into v_max_date_tc;
            CLOSE c_s_sqd_sap_send_bew_tc;
            v_max_date_tc := nvl(v_max_date_tc, io_bew.b_datum);

            if v_max_date_tc < sysdate
            then
              v_max_date_tc := sysdate;
            else
              v_max_date_tc := v_max_date_tc + (1 / 86400);
            end if;

            if v_res_zust_akt.status_id > 200
            then
              select seq_s_send_bew_id.nextval into v_bew_id from dual;
              update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                 set t.status = 'N',             -- Alle offenen Einträge schicken
                     t.lhm_nr = NULL,            -- evtl. ohne Boxnummer
                     t.lte_nr = NULL,            -- WEI immer ohne Palettennummer
                     t.aktion = 'PS',
                     t.menge = 0,
                     t.menge_b = 0,
                     t.schrott = 0,
                     t.ma_s_grund = 0,
                     t.ma_last_s_grund = 0,
                     t.charge = NULL,
                     t.b_datum = to_char(v_max_date_tc, 'dd.mm.yyyy hh24:mi:ss'),
                     t.ts = v_bew_id
               where t.aktion = 'XPE'
                 and t.status = 'W'
                 and t.lhm_nr = v_nve;
              select seq_s_send_bew_id.nextval into v_bew_id from dual;
              update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                 set t.status = 'N',             -- Alle offenen Einträge schicken
                     t.lhm_nr = NULL,            -- evtl. ohne Boxnummer
                     t.lte_nr = NULL,            -- WEI immer ohne Palettennummer
                     t.aktion = 'SG',
                     t.menge_b = 0,
                     t.schrott = 0,
                     t.ma_s_grund = v_res_zust_akt.status_id,
                     t.ma_last_s_grund = 0,
                     t.charge = NULL,
                     t.b_datum = to_char(v_max_date_tc + (1 / 86400), 'dd.mm.yyyy hh24:mi:ss'),
                     t.ts = v_bew_id
               where t.aktion = 'XPS'
                 and t.status = 'W'
                 and t.lhm_nr = v_nve;
            else
              select seq_s_send_bew_id.nextval into v_bew_id from dual;
              update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                 set t.status = 'N',             -- Alle offenen Einträge schicken
                     t.lhm_nr = NULL,-- evtl. ohne Boxnummer
                     t.lte_nr = NULL,             -- WEI immer ohne Palettennummer
                     t.aktion = 'SG',
                     t.menge_b = 0,
                     t.schrott = 0,
                     t.ma_s_grund = 206,
                     t.ma_last_s_grund = 0,
                     t.charge = NULL,
                     t.b_datum = to_char(v_max_date_tc, 'dd.mm.yyyy hh24:mi:ss'),
                     t.ts = v_bew_id
               where t.aktion = 'XPE'
                 and t.status = 'W'
                 and t.lhm_nr = v_nve;
              select seq_s_send_bew_id.nextval into v_bew_id from dual;
              update s_sqd_sap_send_bew t        -- Bei Auftragsende oder Palettenwechsel
                 set t.status = 'N',             -- Alle offenen Einträge schicken
                     t.lhm_nr = NULL,-- evtl. ohne Boxnummer
                     t.lte_nr = NULL,             -- WEI immer ohne Palettennummer
                     t.aktion = 'PS',
                     t.menge = 0,
                     t.menge_b = 0,
                     t.schrott = 0,
                     t.ma_s_grund = 0,
                     t.ma_last_s_grund = 0,
                     t.charge = NULL,
                     t.b_datum = to_char(v_max_date_tc + (1 / 86400), 'dd.mm.yyyy hh24:mi:ss'),
                     t.ts = v_bew_id
               where t.aktion = 'XPS'
                 and t.status = 'W'
                 and t.lhm_nr = v_nve;
            end if;
          end if;
          update s_sqd_sap_send_bew t
             set t.status = 'N',
                 t.lhm_nr = io_bew.lhm_nr,
                 t.lte_nr = NULL
           where t.aktion = 'WEI'
             and t.status = 'W'  -- Hier ist der neue Status 'N' und nicht NULL
             and t.lhm_nr = v_nve;
          if v_bde_fa_ag.abnr = 0 -- Ohne ABNR nicht buchen
          then
            return;
          end if;
        end if;

        -- lagerort mapping für HU-Management
        if v_bde_fa_ag.abnr != 0          -- Mit Kundenrelevanz
        then
          if io_bew.lagerort = '1121'
          then
            io_bew.lagerort := '1021';
          elsif io_bew.lagerort = '1122'
          then
            io_bew.lagerort := '1022';
          elsif io_bew.lagerort = '1123'
          then
            io_bew.lagerort := '1023';
          elsif io_bew.lagerort = '1124'
          then
            io_bew.lagerort := '1024';
          end if;
          if io_bew.zlagerort = '1121'
          then
            io_bew.zlagerort := '1021';
          elsif io_bew.zlagerort = '1122'
          then
            io_bew.zlagerort := '1022';
          elsif io_bew.zlagerort = '1123'
          then
            io_bew.zlagerort := '1023';
          elsif io_bew.zlagerort = '1124'
          then
            io_bew.zlagerort := '1024';
          end if;
        end if;

        if io_bew.lhm_nr is not NULL
        and length(io_bew.lhm_nr) = 15
        then
          v_nve := '740485532' || substr(io_bew.lhm_nr, 8, 8);
          v_nve := lvs_p_lte_lhm.lvs_lte_lhm_pruefziffer_mod10(v_nve);
          io_bew.lhm_nr := v_nve;
        end if;

        if v_aktion = 'WEI'
        and (v_bde_fa_ag.freig_status = 'AR'
          or v_bde_fa_ag.freig_status = 'AP')
        then
          v_s_sqd_sap_bew.status := 'W';
        else
          if v_aktion = 'WEI'
          then
            io_bew.lte_nr := NULL;
            if v_bde_fa_ag.abnr = 0            -- SEAQUIST lagerauftrag
            then
              io_bew.lhm_nr := NULL;
            end if;
          end if;
          v_s_sqd_sap_bew.status := 'N';
        end if;

        if v_aktion = 'WEI' -- Wareneingang muss auch rückmelden (PE und PS)
        then
          select seq_s_send_bew_id.nextval into v_bew_id from dual;
          insert into s_sqd_sap_send_bew
             values (
                io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                io_bew.auf_id,               -- AUF_ID          NUMBER,
                v_s_sqd_sap_bew.status,      -- STATUS          VARCHAR2(3),
                'XPE',                       -- AKTION          VARCHAR2(3),
                io_bew.leitzahl,             -- FA
                io_bew.fa_ag,                -- FA_AG
                io_bew.fa_upos,              -- FA_UPOS
                io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER,
                io_bew.ma_last_s_grund,      -- MA_LAST_S_GRUND NUMBER,
                io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
                io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
                io_bew.menge,                -- MENGE           NUMBER(12,3),
                io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                             -- Aus Artikel lesen
                io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                io_bew.charge,               -- CHARGE          VARCHAR2(20),
                io_bew.serie,                -- SERIE           VARCHAR2(20),
                io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                to_char(io_bew.b_datum - 2 / 86400, 'dd.mm.yyyy hh24:mi:ss'),
                                             -- B_DATUM         DATE,
                v_bew_id,                    -- TS
                io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                NULL,                        -- RET_CODE        VARCHAR2(20),
                0,                           -- CYCLE           NUMBER
                io_bew.pers_nr,              -- PERS_NR         NUMBER
                NULL,
                NULL,
                NULL,
                NULL);
          select seq_s_send_bew_id.nextval into v_bew_id from dual;
          insert into s_sqd_sap_send_bew
             values (
                io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                io_bew.auf_id,               -- AUF_ID          NUMBER,
                v_s_sqd_sap_bew.status,      -- STATUS          VARCHAR2(3),
                'XPS',                       -- AKTION          VARCHAR2(3),
                io_bew.leitzahl,             -- FA
                io_bew.fa_ag,                -- FA_AG
                io_bew.fa_upos,              -- FA_UPOS
                io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER,
                io_bew.ma_last_s_grund,      -- MA_LAST_S_GRUND NUMBER,
                io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
                io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
                io_bew.menge,                -- MENGE           NUMBER(12,3),
                io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                             -- Aus Artikel lesen
                io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                io_bew.charge,               -- CHARGE          VARCHAR2(20),
                io_bew.serie,                -- SERIE           VARCHAR2(20),
                io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                to_char(io_bew.b_datum - 1 / 86400, 'dd.mm.yyyy hh24:mi:ss'),
                                             -- B_DATUM         DATE,
                v_bew_id,                    -- TS
                io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                NULL,                        -- RET_CODE        VARCHAR2(20),
                0,                           -- CYCLE           NUMBER
                io_bew.pers_nr,              -- PERS_NR         NUMBER
                NULL,
                NULL,
                NULL,
                NULL);

        end if;

        if v_aktion = 'PS' -- Darf nur gesendet werden, wenn gerüstet
        then
          -- -AG- 2011.06.08Pruefen ob fue AG 20 (= Ruesten) schon ein eintrag gebucht wenn nicht dann ergebnis NULL
          v_fa_ag := v_bde_fa_ag.fa_ag;
          v_bde_fa_ag.fa_ag := 20;
          OPEN c_s_sqd_sap_send_bew_tc;
          FETCH c_s_sqd_sap_send_bew_tc into v_max_date_tc;
          CLOSE c_s_sqd_sap_send_bew_tc;
          v_bde_fa_ag.fa_ag := v_fa_ag;

          if nvl(v_bde_fa_ag.ruest_zeit_ist, 0) = 0
          or v_max_date_tc is NULL -- wenn NULL dann noch nichts gebucht für AG20 Ruesten (Fürt dann zu SAP Fehler)
          then
            insert into s_sqd_sap_send_bew
               values (
                  io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                  io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                  v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                  io_bew.auf_id,               -- AUF_ID          NUMBER,
                  v_s_sqd_sap_bew.status,      -- STATUS          VARCHAR2(3),
                  'PS',                        -- AKTION          VARCHAR2(3),
                  io_bew.leitzahl,             -- FA
                  '20',                        -- FA_AG
                  io_bew.fa_upos,              -- FA_UPOS
                  io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                  io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER,
                  io_bew.ma_last_s_grund,      -- MA_LAST_S_GRUND NUMBER,
                  io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                  io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                  io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                  io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
                  io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
                  io_bew.menge,                -- MENGE           NUMBER(12,3),
                  io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                  io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                  io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                  io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                  io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                  upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                               -- Aus Artikel lesen
                  io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                  io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                  io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                  io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                  io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                  v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                  v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                  io_bew.charge,               -- CHARGE          VARCHAR2(20),
                  io_bew.serie,                -- SERIE           VARCHAR2(20),
                  io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                  io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                  io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                  to_char(io_bew.b_datum - 2 / 86400, 'dd.mm.yyyy hh24:mi:ss'),
                                               -- B_DATUM         DATE,
                  io_bew.bew_id,               -- TS
                  io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                  NULL,                        -- RET_CODE        VARCHAR2(20),
                  0,                           -- CYCLE           NUMBER
                  io_bew.pers_nr,              -- PERS_NR         NUMBER
                  NULL,
                  NULL,
                  NULL,
                  NULL);
              select seq_s_send_bew_id.nextval into io_bew.bew_id from dual;
            insert into s_sqd_sap_send_bew
               values (
                  io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                  io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                  v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                  io_bew.auf_id,               -- AUF_ID          NUMBER,
                  v_s_sqd_sap_bew.status,      -- STATUS          VARCHAR2(3),
                  'PE',                        -- AKTION          VARCHAR2(3),
                  io_bew.leitzahl,             -- FA
                  '20',                        -- FA_AG
                  io_bew.fa_upos,              -- FA_UPOS
                  io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                  io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER,
                  io_bew.ma_last_s_grund,      -- MA_LAST_S_GRUND NUMBER,
                  io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                  io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                  io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                  io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
                  io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
                  io_bew.menge,                -- MENGE           NUMBER(12,3),
                  io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                  io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                  io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                  io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                  io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                  upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                               -- Aus Artikel lesen
                  io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                  io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                  io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                  io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                  io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                  v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                  v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                  io_bew.charge,               -- CHARGE          VARCHAR2(20),
                  io_bew.serie,                -- SERIE           VARCHAR2(20),
                  io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                  io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                  io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                  to_char(io_bew.b_datum - 1 / 86400, 'dd.mm.yyyy hh24:mi:ss'),
                                               -- B_DATUM         DATE,
                  io_bew.bew_id,               -- TS
                  io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                  NULL,                        -- RET_CODE        VARCHAR2(20),
                  0,                           -- CYCLE           NUMBER
                  io_bew.pers_nr,              -- PERS_NR         NUMBER
                  NULL,
                  NULL,
                  NULL,
                  NULL);
              select seq_s_send_bew_id.nextval into io_bew.bew_id from dual;
            update bde_fa_auftrag fa
               set fa.ruest_zeit_ist = nvl(fa.ruest_zeit_ist, 0) + 1 / 60,
                   fa.rcv_ruest_zeit_ist = nvl(fa.rcv_ruest_zeit_ist, 0) + 1 / 60
             where fa.sid = v_sid.sid
               and fa.firma_nr = io_bew.firma_nr
               and fa.leitzahl = io_bew.leitzahl
               and fa.fa_ag = io_bew.fa_ag
               and fa.fa_upos = io_bew.fa_upos
               and nvl(fa.rcv_ruest_zeit_ist, 0) = 0;
          end if;
        end if;

        if v_aktion = 'PS' -- Darf nur gesendet werden, wenn keine Stoerung
        then
          if io_bew.ma_s_grund > 200 -- ist bereits unterbrochen
          then
            return;
          end if;
        end if;

        v_max_date_tc := io_bew.b_datum;
        if v_aktion = 'PE' -- Darf nur gesendet werden, wenn Auftragsmenge erreicht
        and v_bde_fa_ag.ag_ist_mg < v_bde_fa_ag.ag_soll_mg
        then
          if io_bew.ma_s_grund > 200 -- ist bereits unterbrochen
          then
            return;
          end if;
          v_aktion := 'SG';
          io_bew.ma_s_grund := 206;
          io_bew.ma_last_s_grund := 0;
        end if;

        if v_aktion = 'PE' -- Produktionsende währen Störung
        and io_bew.ma_s_grund > 200
        and io_bew.ma_s_grund != 209
        then
          v_bew_id := io_bew.bew_id;
          OPEN c_s_sqd_sap_send_bew_tc;
          FETCH c_s_sqd_sap_send_bew_tc into v_max_date_tc;
          CLOSE c_s_sqd_sap_send_bew_tc;
          v_max_date_tc := nvl(v_max_date_tc, io_bew.b_datum);

          if v_max_date_tc >= io_bew.b_datum
          then
            select seq_s_send_bew_id.nextval into v_bew_id from dual;
            v_max_date_tc := v_max_date_tc + (2 / 86400);
          else
            v_max_date_tc := io_bew.b_datum;
          end if;
          insert into s_sqd_sap_send_bew
             values (
                io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
                io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
                v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
                io_bew.auf_id,               -- AUF_ID          NUMBER,
                v_s_sqd_sap_bew.status,      -- STATUS          VARCHAR2(3),
                'SG',                        -- AKTION          VARCHAR2(3),
                io_bew.leitzahl,             -- FA
                io_bew.fa_ag,                -- FA_AG
                io_bew.fa_upos,              -- FA_UPOS
                io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
                0,                           -- MA_S_GRUND      NUMBER,
                io_bew.ma_s_grund,           -- MA_LAST_S_GRUND NUMBER,
                io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
                io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
                io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
                io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
                io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
                io_bew.menge,                -- MENGE           NUMBER(12,3),
                io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
                io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
                io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
                io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
                io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
                upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                             -- Aus Artikel lesen
                io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
                io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
                io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
                io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
                io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
                v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
                v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
                io_bew.charge,               -- CHARGE          VARCHAR2(20),
                io_bew.serie,                -- SERIE           VARCHAR2(20),
                io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
                io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
                io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
                to_char(v_max_date_tc - 1 / 86400, 'dd.mm.yyyy hh24:mi:ss'),
                                             -- B_DATUM         DATE,
                v_bew_id,                    -- TS
                io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
                NULL,                        -- RET_CODE        VARCHAR2(20),
                0,                           -- CYCLE           NUMBER
                io_bew.pers_nr,              -- PERS_NR         NUMBER
                NULL,
                NULL,
                NULL,
                NULL);
            select seq_s_send_bew_id.nextval into io_bew.bew_id from dual;
          io_bew.ma_s_grund := 0;
          io_bew.ma_last_s_grund := 0;
        end if;

        v_bew_id := io_bew.bew_id;
        v_max_date_tc := io_bew.b_datum;
        if v_aktion in ('SG', 'PS', 'SB', 'PE', 'SE')
        then
          OPEN c_s_sqd_sap_send_bew_tc;
          FETCH c_s_sqd_sap_send_bew_tc into v_max_date_tc;
          CLOSE c_s_sqd_sap_send_bew_tc;
          v_max_date_tc := nvl(v_max_date_tc, io_bew.b_datum);
          if v_max_date_tc >= io_bew.b_datum
          then
            select seq_s_send_bew_id.nextval into v_bew_id from dual;
            v_max_date_tc := v_max_date_tc + (1 / 86400);
          else
            v_max_date_tc := io_bew.b_datum;
          end if;
        end if;

        insert into s_sqd_sap_send_bew
           values (
              io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
              io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
              v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
              io_bew.auf_id,               -- AUF_ID          NUMBER,
              v_s_sqd_sap_bew.status,      -- STATUS          VARCHAR2(3),
              decode (v_aktion,
                      'WAK', 'WAI',        -- sqd_sap kennt keine Kommissionierung Direkt
                      'WEK', 'WEI',        -- sqd_sap kennt keine Kommissionierung Direkt
                      v_aktion),           -- AKTION          VARCHAR2(3),
              io_bew.leitzahl,             -- FA
              io_bew.fa_ag,                -- FA_AG
              io_bew.fa_upos,              -- FA_UPOS
              io_bew.ma_status,            -- MA_STATUS       VARCHAR2(1),
              io_bew.ma_s_grund,           -- MA_S_GRUND      NUMBER,
              io_bew.ma_last_s_grund,      -- MA_LAST_S_GRUND NUMBER,
              io_bew.ma_id,                -- MA_ID           VARCHAR2(10),
              io_bew.lte_nr,               -- LTE_NR          VARCHAR2(20),
              io_bew.lhm_nr,               -- LHM_NR          VARCHAR2(20),
              io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
              io_bew.zlagerort,            -- ZLAGERORT       VARCHAR2(10),
              io_bew.menge,                -- MENGE           NUMBER(12,3),
              io_bew.menge_b,              -- MENGE_B         NUMBER(12,3),
              io_bew.schrott,              -- SCHROTT         NUMBER(12,3),
              io_bew.r_menge,              -- R_MENGE         NUMBER(12,3),
              io_bew.r_menge_b,            -- R_MENGE_B       NUMBER(12,3),
              io_bew.r_schrott,            -- R_SCHROTT       NUMBER(12,3),
              upper(v_artikel.mengeneinheit),      -- Seaquist SAP hat alle ME in Grossbuchstaben
                                           -- Aus Artikel lesen
              io_bew.stoerzeit_ist,        -- STOERZEIT_IST   NUMBER,
              io_bew.ruestzeit_ist,        -- RUESTZEIT_IST   NUMBER,
              io_bew.prodzeit_ist,         -- PRODZEIT_IST    NUMBER,
              io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
              io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
              v_auftr.auftrag,             -- EXT_best_NR     VARCHAR2(15),
              v_auftr.pos_nr,              -- EXT_best_POS    VARCHAR2(5),
              io_bew.charge,               -- CHARGE          VARCHAR2(20),
              io_bew.serie,                -- SERIE           VARCHAR2(20),
              io_bew.arbeitsplatz_id,      -- ARBEITSPLATZ_ID VARCHAR2(20),
              io_bew.ist_bestand,          -- IST_BESTAND     NUMBER,
              io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
              to_char(v_max_date_tc, 'dd.mm.yyyy hh24:mi:ss'),
                                           -- B_DATUM         DATE,
              v_bew_id,                    -- TS
              io_bew.brutto_kg,            -- BRUTTO_KG       NUMBER(12,3),
              NULL,                        -- RET_CODE        VARCHAR2(20),
              0,                           -- CYCLE           NUMBER
              io_bew.pers_nr,              -- PERS_NR         NUMBER
              NULL,
              NULL,
              NULL,
              NULL);

          io_bew.send_id := v_bew_id;
      end if;
    end if;

    if v_sid.sid_schnittstelle = 'NAV_RRK'
    then
      if io_bew.aktion = 'WAI'
      then
        v_sql := 'insert into s_rrk_send_lv_ausgang (rollennr, ' ||
                                                    'tabgang) ' ||
                 ' values (''' || io_bew.lte_nr || '''' ||
                          ', to_date(''' || to_char(io_bew.b_datum, 'dd.mm.yyyy hh24:mi:ss') || ''', ''dd.mm.yyyy hh24:mi:ss'')' ||
                           ')';
        begin
          execute immediate v_sql;
        exception
          when others then
            isi_p_log.db_act_log('s_rrk_send_lv_ausgang', v_sql, v_sql, 'insert', 'Error by insert into s_rrk_send_lv_ausgang');
        end;
      end if;
    end if;

    if v_sid.sid_schnittstelle = 'ACHILLES115' then
      if io_bew.auf_id is NULL then
        v_bew_tabelle := NULL;
      else
        v_bew_tabelle := io_bew.tabelle;
      end if;
      v_aktion := io_bew.aktion;
      if io_bew.aktion = 'WAI'
      or io_bew.aktion = 'WAK'
      then
        v_aktion := 'WAE';
      end if;
      if io_bew.aktion = 'WEI'
      or io_bew.aktion = 'WEK'
      then
        v_aktion := 'WEE';
      end if;

      v_bestand := io_bew.ist_bestand;
      if io_bew.aktion = 'INV'
      then
        if io_bew.menge < 0
        then
          v_bestand := 0;
        else
          v_bestand := io_bew.menge;
        end if;
      end if;

      insert into s_ach_send_bew
         values (
            io_bew.firma_nr,             -- FIRMA_NR        NUMBER(3),
            io_bew.herkunft,             -- HERKUNFT        VARCHAR2(3),
            v_bew_tabelle,               -- TABELLE         VARCHAR2(5),
            io_bew.auf_id,               -- AUF_ID          NUMBER,
            NULL,                        -- STATUS          VARCHAR2(3),
            v_aktion,                    -- AKTION          VARCHAR2(3),
            io_bew.lte_nr,               -- LTE_ID          VARCHAR2(20),
            io_bew.lhm_nr,               -- LHM_ID          VARCHAR2(20),
            io_bew.lagerort,             -- LAGERORT        VARCHAR2(10),
            io_bew.menge,                -- MENGE           NUMBER(12,3),
            io_bew.ext_lief_nr,          -- EXT_LIEF_NR     VARCHAR2(15),
            io_bew.ext_lief_pos,         -- EXT_LIEF_POS    VARCHAR2(5),
            v_bestand,                   -- IST_BESTAND     NUMBER,
            io_bew.artikel,              -- ARTIKEL         VARCHAR2(20),
            io_bew.b_datum,              -- B_DATUM         DATE,
            io_bew.text,                 -- TEXT            VARCHAR2(40),
            io_bew.err_nr,               -- ERR_NR          NUMBER,
            io_bew.bew_id);              -- Bew-ID
      io_bew.send_id := io_bew.bew_id;
    end if;

    if v_sid.sid_schnittstelle = 'HUF'
    then
      if io_bew.aktion = 'L'
      then
        if io_bew.tabelle = 'S_AUF'
        then
          delete s_rcv_auftr s
            where s.auf_id = io_bew.auf_id;
        end if;
      end if;

      if  (io_bew.aktion = 'WAI'
        or io_bew.aktion = 'WAE')
      and io_bew.menge > 0
      then
        v_aktion := '4';  -- BEW Abgang bei HUF = 4
      elsif  (io_bew.aktion = 'WEI'
           or io_bew.aktion = 'WEE')
      and io_bew.menge > 0
      then
        v_aktion := '3';  -- BEW Zugang bei HUF = 3
      elsif  (io_bew.aktion = 'WEI'
           or io_bew.aktion = 'WEE')
      and io_bew.menge < 0
      then
        v_aktion := '4';  -- BEW Abgang bei HUF = 4 (Huf kann nicht neg)
      elsif  (io_bew.aktion = 'WAI'
           or io_bew.aktion = 'WAE')
      and io_bew.menge < 0
      then
        v_aktion := '3';  -- BEW Zugang bei HUF = 3 (Huf kann nicht neg)
      elsif  (io_bew.aktion = 'INV')
      and io_bew.menge > 0
      then
        v_aktion := '3';  -- BEW Zugang bei HUF = 3
      elsif  (io_bew.aktion = 'INV')
      and io_bew.menge < 0
      then
        v_aktion := '4';  -- BEW Abgang bei HUF = 4 (Huf kann nicht neg)
      elsif  (io_bew.aktion = 'IVZ')
      then
        return; -- -WK- 20.02.2007: bei Huf gezählte Inventur nicht in die Schnittstelle schreiben (keine Bewegungsart definiert)
        /*
        if io_bew.menge > 0
        then
          v_aktion := '?'; -- gezählte Inv. Zugang
        elsif io_bew.menge < 0
        then
          v_aktion := '?'; -- gezählte Inv. Abgang
        else
          return;
        end if;*/
      else
        return;
      end if;
      v_arbeitsplatz := NULL;
      OPEN c_arbeitsplatz;
      FETCH c_arbeitsplatz into v_arbeitsplatz;
      CLOSE c_arbeitsplatz;
      insert into s_huf_send_bew t
        values (v_aktion,                 -- BEWEGUNGSART NUMBER(2) not null,
                'N',                      -- STATUS       VARCHAR2(1) not null,
                 io_bew.b_datum,          -- MELDEDATUM   DATE,
                 io_bew.artikel,          -- TEILE_NR     NUMBER(8) not null,
                 io_bew.lam_ag,            -- MELDE_POS    NUMBER(3),
                 abs(io_bew.menge),       -- MG1          NUMBER(8) not null,
                 sysdate,                 -- SATZDATUM    DATE not null,
                 nvl(io_bew.user_name, 'KEIN'),        -- USERNAME     VARCHAR2(30) default 'USER' not null,
                 nvl(v_arbeitsplatz.orts_kz,
                     'KEINE'),            -- USERABT      VARCHAR2(40),
                 1);                      -- UPDNR        NUMBER default 1 not null

    end if;
    if v_sid.sid_schnittstelle = 'ESSEX'
    then
      v_status := '1';             -- CTC Regal Einlagern Spule

      if  (io_bew.aktion != 'WEI'
       and io_bew.aktion != 'WEE')
      then
        if  io_bew.aktion = 'WAI'                         -- Warenabgang Intern
        and lower(user) = 'essar01'                       -- In Bad Arolsen
        and io_bew.res_id = 1                             -- RES_ID 1 = CTC-Lager
        then
          v_status := '0';                                -- CTC-Lager mit WAI soll Status 0 haben
        else
          return;
        end if;
      end if;

      if  io_bew.lte_nr like 'LTE_VL%'
      then
        v_status := '0';           -- Palletierlager

        select nvl(t.res_ziel_lte_id, t.lte_id) into io_bew.lte_nr
          from lvs_lam t
         where t.lhm_id = io_bew.lhm_nr;
      end if;

      if length(io_bew.lte_nr) > 8   -- 710 Spule
      then
        return;                      -- Nicht an AS400 melden
      end if;

      insert into s_essex_send_bew t
        values (io_bew.send_id,      -- SEND_ID     NUMBER not null,
                'N',                 -- SEND_STATUS VARCHAR2(2) not null,
                sysdate,             -- SEND_TS     DATE not null,
                io_bew.firma_nr,     -- FIRMA_NR    NUMBER(3),
                io_bew.aktion,       -- AKTION      VARCHAR2(25),
                v_status,            -- STATUS      VARCHAR2(2),
                io_bew.lhm_nr,       -- LHM_ID      VARCHAR2(8),
                io_bew.lte_nr);      -- LTE_ID      VARCHAR2(8)
    end if;
    if v_sid.sid_schnittstelle = 'SAS_SAP'
    then
      v_menge := io_bew.menge;
      v_scanner := NULL;

      OPEN c_scanner;
      FETCH c_scanner into v_scanner;
      CLOSE c_scanner;

      if io_bew.lagerort != 'WBBL' -- Nur auf diesen Lagerorten Buchen bei sasol
      and io_bew.lagerort != 'WFKH' --
      and io_bew.lagerort != 'HRLK' --
      then
        return;
      end if;

      if io_bew.lagerort is NULL
      then
        io_bew.lagerort := 'WBBL'; -- Eigentlich bei Sasol nur auf diesem lagerort möglich
      end if;
      -- Hier kommt immer nur ein Scann je Palette
      v_mens := 'Kg';
      if v_scanner.barcode_bez = 'Organik'
      then
        v_mens := 'PAL';
        v_menge := 1;
      end if;
      v_bde_fa_kopf := NULL;
      open c_bde_fa_kopf;
      fetch c_bde_fa_kopf into v_bde_fa_kopf;
      close c_bde_fa_kopf;
      v_aktion := NULL;
      if  io_bew.aktion = 'WEI'
      then
        v_aktion := 'Z_SCANS_WE_PRODUKTION';
        v_sap_bus := '1';
        if v_bde_fa_kopf.erzeuger = 'HOST'
        then
          v_aktion := 'Z_SCANS_WE_PRAUF';
        end if;
      elsif  io_bew.aktion = 'WAI'
      then
        v_aktion := 'Z_SCANS_VERBRAUCH_PRODUKTION';
        v_sap_bus := '4';
        if v_bde_fa_kopf.erzeuger = 'HOST'
        then
          v_aktion := 'Z_SCANS_VERBRAUCH_PRAUF';
        end if;
      -- Noch offen
      -- Z_SCANS_UMLAGERUNG_AUSGANG
      -- Z_SCANS_UMLAGERUNG_EINGANG
      -- Z_SCANS_VERBRAUCH_PRODUKTION (BUS 4)
      end if;
      if v_aktion is not NULL
      then
        v_s_sas_sap_bew := NULL;
        OPEN c_s_sas_sap_send_bew;
        FETCH c_s_sas_sap_send_bew into v_s_sas_sap_bew;
        v_found := c_s_sas_sap_send_bew%FOUND;
        CLOSE c_s_sas_sap_send_bew;
        if v_found
        then
          update s_sas_sap_send_bew t
             set t.slb_menge = t.slb_menge + v_menge,
                 t.slb_last_scan = io_bew.b_datum
           where t.send_id = v_s_sas_sap_bew.send_id;
          io_bew.send_id := v_s_sas_sap_bew.send_id;
        else
          select seq_sas_sap_job_id.nextval into io_bew.send_id from dual;
          insert into s_sas_sap_send_bew
            values (io_bew.send_id,             -- JOB_ID             NUMBER not null,
                    sysdate,                    -- TS                 DATE not null,
                    v_aktion,                   -- SAP_FB             VARCHAR2(30) not null,
                    v_sap_bus,                  -- SLB_BUCHNR         NUMBER,
                    io_bew.artikel,             -- SLB_MAT_NR         VARCHAR2(6),
                    io_bew.charge,              -- SLB_CHARGE         VARCHAR2(6),
                    v_menge,                    -- SLB_MENGE          NUMBER,
                    io_bew.lagerort,            -- SLB_VON_LGR_ORT    VARCHAR2(4),
                    io_bew.zlagerort,           -- SLB_NACH_LGR_ORT   VARCHAR2(4),
                    io_bew.b_datum,             -- SLB_FIRST_SCAN     DATE,
                    io_bew.b_datum,             -- SLB_LAST_SCAN      DATE,
                    v_mens,                     -- SLB_MEINS          VARCHAR2(3),
                    'N',                        -- STATUS             VARCHAR2(10),
                    NULL,                       -- SLB_FB_RET_CODE    NUMBER,
                    NULL,                       -- SLB_FB_RET_MESSAGE VARCHAR2(50),
                    '0',                        -- SLB_CYCLE          VARCHAR2(2),
                    '6030',                     -- SLB_EXP_STATUS     NUMBER(4)
                    v_bde_fa_kopf.fa_nr_ext);   -- SLB_AUFTRNR        VARCHAR2(10),
        end if;


      end if;
    end if;
  end send_host_bew;

  --------------------------------------------------------------------------------
  -- procedure write_host_platz_lte_update mach ein UPDATE auf die Bewegungssätze
  -- einer LTE die noch keinen Lagerplatz hate. Dieses erfolgt normalerweise beim
  -- scannen im Wareneingang. Ausserdem kuemmert sich die Procedure um das UP-Date
  -- der ISI-Order für diese Palette
  --------------------------------------------------------------------------------
  -- Achtung diese Procedure ist fuer Lagerzugaenge geschrieben
  --******************************************************************************
  procedure WRITE_HOST_PLATZ_LTE_UPDATE (in_lte      in  lvs_lte%rowtype
                                        ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(255);

    v_found     boolean;                                -- Daten Gefunfen?
    --v_result    number;

    v_ort                lvs_lgr_ort%rowtype;       -- Lagerort Quelle
    v_lgr                lvs_lgr%rowtype;           -- Lagerplatz Quelle
    v_lam                lvs_lam%rowtype;           -- Lagerbestand
    v_lam_bh             lvs_lam_bh%rowtype;        -- Lagerbuchung
    v_order_pos          isi_order_pos%rowtype;     -- ISI-Order Position
    v_send_bew           s_send_bew%rowtype;        -- Lagerbew. fuer Schnittstelle
    v_anz_pos            number;                    -- Anzahl der AUF_ID's diesen Vorgangs

    v_buch_date          date;
    v_tabelle            varchar2(10);

    v_sid               isi_sid%rowtype;

    CURSOR c_sid is
      select *
        from isi_sid s
        where s.sid_my_sid = 1;

    CURSOR c_lgr is                             -- Lesen des Lagerpltz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lte.lgr_platz
         and lgr.sid = in_lte.sid;

    CURSOR c_lgr_ort is                             -- Lesen des Lagerort
      select *
        from lvs_lgr_ort ort
       where ort.lgr_ort = v_lgr.lgr_ort
         and ort.sid = in_lte.sid;

    CURSOR c_lam is
      select *
        from lvs_lam lam
       where lam.sid = in_lte.sid
         and lam.firma_nr = in_lte.firma_nr
         and lam.lte_id = in_lte.lte_id;

    CURSOR c_lam_bh is
      select *
        from lvs_lam_bh bh
       where bh.lam_id = v_lam.lam_id
         and bh.bus in (c.LAM_BH_BUS_ZUG, c.LAM_BH_BUS_ZUG_KOMM, c.LAM_BH_BUS_ZUG_KONSI);

    CURSOR c_order_pos is
      select *
        from isi_order_pos pos
       where pos.sid = in_lte.sid
         and pos.firma_nr = in_lte.firma_nr
         and pos.vorgang_typ in ('WEE', 'KWE')
         and pos.auf_id_extern = v_send_bew.auf_id;

     CURSOR c_send_bew is
       select *
         from s_send_bew bew
        where bew.lam_bh_id = v_lam_bh.lam_bh_id
          and bew.status is NULL;

    CURSOR c_pos_anz is
      select count(auf_id)
        from isi_order_pos pos
       where pos.sid = in_lte.sid
         and pos.vorgang_typ in ('WEE', 'KWE')
         and pos.vorgang_id = v_order_pos.vorgang_id
         and pos.auf_id != v_order_pos.auf_id
         and nvl(pos.status, 'n') != 'E'
       group by pos.vorgang_typ, pos.vorgang_id;

  begin
    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    if v_sid.sid_schnittstelle is NULL then
      return;
    end if;

    v_err_nr := NULL;
    v_err_text := NULL;
    v_buch_date := sysdate;

    -- Jetzt erst mal die Lagerdaten lesen. Wenn etwas fehlt sofort abbrechen !!!
    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if v_found
    then
      OPEN c_lgr_ort;
      FETCH c_lgr_ort into v_ort;
      v_found := c_lgr_ort%FOUND;
      CLOSE c_lgr_ort;
      if not v_found
      then
        v_err_nr := 10;
        v_err_text := 'Fehler: Lagerort ''' || NVL(to_char(v_lgr.lgr_ort), '<NULL>') || ''' fehlt.';
        RAISE v_error;
      end if;
    else
      v_err_nr := 20;
      v_err_text := 'Fehler: Lagerplatz ''' || NVL(in_lte.lgr_platz, '<NULL>') || ''' fehlt.';
      RAISE v_error;
    end if;
    v_err_nr := NULL;
    v_err_text := NULL;

    -- Jetzt alle Materialbestände dieser Palette lesen
    OPEN c_lam;
    LOOP
      FETCH c_lam into v_lam;
      -- Kein weiterer gefunden
      EXIT when c_lam%NOTFOUND;

      -- Jetzt die passende Zugansbuchung lesen
      OPEN c_lam_bh;
      FETCH c_lam_bh into v_lam_bh;
      v_found := c_lam_bh%FOUND;
      CLOSE c_lam_bh;

      if v_found
      then
        -- Ist in dieser Buchung ist noch kein Lagerplatz erfasst dann eintragen
        if v_lam_bh.lgr_platz is NULL
        then
          update lvs_lam_bh bh
             set bh.lgr_platz = in_lte.lgr_platz,
                 bh.buch_datum = v_buch_date
           where bh.sid = v_lam.sid
             and bh.firma_nr = v_lam.firma_nr
             and bh.lam_id = v_lam.lam_id
             and (bh.bus = c.LAM_BH_BUS_ZUG
              or  bh.bus = c.LAM_BH_BUS_ZUG_KOMM)
             and bh.lgr_platz is NULL;
        end if;
        if v_lam_bh.abnr_extern is NULL
        then
          v_tabelle := NULL;
        else
          -- Bei Euscher SAP muss die Tabelle in der Rueckmeldung S_AUFTR heissen
          if v_sid.sid_schnittstelle = 'EUS_SAP'
          then
            v_tabelle := 'S_AUFTR';
          else
            v_tabelle := 'S_AUF';
          end if;
        end if;
      else
        v_err_nr := 30;
        v_err_text := 'Fehler: Lagerzugangsbuchung für lam_ID:  ''' || NVL(to_char(v_lam.lam_id), '<NULL>') || ''' fehlt.';
        RAISE v_error;
      end if;
      v_err_nr := NULL;
      v_err_text := NULL;

      -- Lese den Eintrag für die Schnittstelle
      OPEN c_send_bew;
      FETCH c_send_bew into v_send_bew;
      v_found := c_send_bew%FOUND;
      CLOSE c_send_bew;

      -- Eintrag gefunden und noch nicht gesendet (bew.status is NULL)
      if v_found
      then
        -- Jetzt senden mit richtigen Lagerort
        update s_send_bew bew
           set bew.status = 'UE',
               bew.lagerort = v_ort.host_lgr_ort,
               bew.lagerplatz = in_lte.lgr_platz
         where bew.bew_id = v_send_bew.bew_id;

        OPEN c_order_pos;
        FETCH c_order_pos into v_order_pos;
        v_found := c_order_pos%FOUND;
        CLOSE c_order_pos;

        -- Evtl. muss noch ein ISI-Ordereintrag aktuallisiert werden
        if v_found
        then
          if  v_order_pos.leitzahl > 0
          and v_order_pos.fa_ag > 0
          then
            update bde_fa_auftrag fa
               set fa.ag_ist_mg = nvl(fa.ag_ist_mg, 0) + v_lam.menge
             where fa.sid = in_lte.sid
               and fa.firma_nr = in_lte.firma_nr
               and fa.leitzahl = v_order_pos.leitzahl
               and fa.fa_ag = v_order_pos.fa_ag
               and fa.fa_upos = nvl(v_order_pos.fa_upos, 0);
          end if;
          if v_order_pos.menge_basis = c.BASIS_LTE
          then
            v_order_pos.ist_menge := v_order_pos.ist_menge + 1;
          else
            v_order_pos.ist_menge := v_order_pos.ist_menge + v_lam.menge;
          end if;
          --v_order_pos.status := 'T';                                    -- Status ist jetzt (T)ransport minimum

          if v_order_pos.ist_menge >= v_order_pos.soll_menge -- Auftrag ist fertig
          then
            if v_order_pos.besteller = 'ISI' -- Ersteller ist ISIPlus und kein HOST-System
            then
              delete isi_order_pos pos
               where pos.sid = in_lte.sid
                 and pos.firma_nr = in_lte.firma_nr
                 and pos.vorgang_typ in ('WEE', 'KWE')
                 and pos.auf_id_extern = v_send_bew.auf_id;
              -- Pruefen ob es noch offene Positionen gibt !!
              OPEN c_pos_anz;
              FETCH c_pos_anz into v_anz_pos;
              v_found := c_pos_anz%FOUND;
              CLOSE c_pos_anz;
              -- Keine Positionen mehr offen dann loeschen !!!
              if not v_found then
                delete isi_order_kopf kopf
                 where kopf.sid = in_lte.sid
                   and kopf.vorgang_typ = v_order_pos.vorgang_typ
                   and kopf.vorgang_id = v_order_pos.vorgang_id;
              end if;
            else
              update isi_order_pos pos
                 set pos.status = 'E',
                     pos.ist_menge = v_order_pos.ist_menge
               where pos.sid = in_lte.sid
                 and pos.firma_nr = in_lte.firma_nr
                 and pos.vorgang_typ in ('WEE', 'KWE')
                 and pos.auf_id_extern = v_send_bew.auf_id;
              -- Position ist erledigt, dies muss an die Schnittstelle gemeldet werden
              -- Die Felder für das Schnittstelleschreiben verbiegen
              if v_order_pos.status = 'E'
              then
                -- Wenn schon beendet, dann nur noch diffrenzmenge melden
                if v_order_pos.menge_basis = c.BASIS_LTE
                then
                  v_order_pos.ist_menge := 1;
                else
                  v_order_pos.ist_menge := v_lam.menge;
                end if;
              end if;

              v_order_pos.status := 'E';
              v_order_pos.vorgang_typ := 'BEF';
              v_lam.lte_id := NULL;
              v_lam.artikel_id := NULL;
              v_lam.charge_id := NULL;
              v_lam.fa_upos := NULL;
              v_lam.fa_ag := NULL;
              v_lam.leitzahl:= NULL;
              s_schnittstelle.write_host_bew(v_order_pos,             -- in_order_pos   in isi_order_pos%rowtype,
                                             v_lam,                   -- in_lam         in lvs_lam%rowtype,
                                             NULL,                    -- in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                             NULL,                    -- in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                             NULL,                    -- in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                             'S_AUF',                 -- in_tabelle     in varchar2,
                                             'UE',                    -- in_status      in s_send_bew.status%type,
                                             NULL,                    -- in_quell_lgr   in lvs_lgr%rowtype,
                                             NULL,                    -- in_ziel_lgr    in lvs_lgr%rowtype,
                                             v_order_pos.ist_menge);  -- in_menge       in number default NULL

              -- Pruefen ob es noch offene Positionen gibt !!
              OPEN c_pos_anz;
              FETCH c_pos_anz into v_anz_pos;
              v_found := c_pos_anz%FOUND;
              CLOSE c_pos_anz;
              -- Keine Positionen mehr offen dann markieren
              if not v_found
              or nvl(v_anz_pos, 0) = 0
              then
                update isi_order_kopf kopf
                   set kopf.status = 'E'
                 where kopf.sid = in_lte.sid
                   and kopf.vorgang_typ in ('WEE', 'KWE')
                   and kopf.vorgang_id = v_order_pos.vorgang_id;
              end if;
            end if;
          else
            -- Auftrag noch nicht erfuellt dann Mengen und Staus aktualisieren
            update isi_order_pos pos
               set pos.status = v_order_pos.status,
                   pos.ist_menge = v_order_pos.ist_menge
             where pos.sid = in_lte.sid
               and pos.firma_nr = in_lte.firma_nr
               and pos.vorgang_typ in ('WEE', 'KWE')
               and pos.auf_id_extern = v_send_bew.auf_id;
          end if;
        end if;
      end if;
    end LOOP;
    CLOSE c_lam;
  EXCEPTION
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      if c_lam%ISOPEN
      then
        CLOSE c_lam;
      end if;
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;
  end write_host_platz_lte_update;

  --------------------------------------------------------------------------------
  -- function überträgt die daten aus der BEW-Tabelle an den HOST
  --
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure WRITE_AUFTR_UPDATE(in_auf_id      in s_rcv_auftr.auf_id%type,
                               in_status      in s_rcv_auftr.status%type,
                               in_lvs_info    in s_rcv_auftr.lvs_info%type,
                               in_ist_menge   in s_rcv_auftr.ist_menge%type
                              ) is
  begin
    null;
  end;


  --------------------------------------------------------------------------------
  -- function trägt alle Daten in die BEW-Tabelle ein, Diese Tabelle ist für den
  -- Datentransfer von ISIPlus --> HOST
  -- -AG- Erweiterung in HOST-Interfaces (Senden der Personalnimmer bei Auftragsende
  --      und senden des aktuellen Zustands der Maschine
  --------------------------------------------------------------------------------
  --******************************************************************************
  function WRITE_HOST_PROD_BEW(in_sid         in isi_sid.sid%type,
                               in_firma_nr    in isi_firma.firma_nr%type,
                               in_fa_auftrag  in bde_fa_auftrag%rowtype,
                               in_lam         in lvs_lam%rowtype,
                               in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                               in_lam_bh_bus  in lvs_lam_bh.bus%type,
                               in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                               in_tabelle     in varchar2,
                               in_status      in s_send_bew.status%type
                             ) return number is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_result    number;

    v_ort                lvs_lgr_ort.lgr_ort%type;  -- Für nachlesen des Lagerorts
    v_lgr                lvs_lgr%rowtype;
    v_quell_ort          lvs_lgr_ort%rowtype;       -- Lagerort
    v_lte                lvs_lte%rowtype;

    v_charge             varchar2(255);
    v_art                isi_artikel%rowtype;       -- Artikel Daten
    v_res_zus            isi_resource_zust_akt%rowtype;     --  Aktueller Zustands dieser Maschine

    v_vorgang_typ        s_send_bew.aktion%type;    -- WAE, WAI, WUI ... Warenabgang Extern, intern ...

    v_mg                 s_send_bew.menge%type;
    v_mg_b               s_send_bew.menge_b%type;
    v_schrott            s_send_bew.schrott%type;
    v_r_mg               s_send_bew.r_menge%type;
    v_r_mg_b             s_send_bew.r_menge_b%type;
    v_r_schrott          s_send_bew.r_schrott%type;
    v_prod_zeit          s_send_bew.prodzeit_ist%type;
    v_ruest_zeit         s_send_bew.ruestzeit_ist%type;
    v_stoer_zeit         s_send_bew.stoerzeit_ist%type;
    v_ruest_zeit_erf     s_send_bew.ruestzeit_ist%type;
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
    v_prod_zeit_erf      s_send_bew.stoerzeit_ist%type;
    v_brutto_kg          number;

    v_sid               isi_sid%rowtype;

    CURSOR c_sid is
      select *
        from isi_sid s
        where s.sid_my_sid = 1;

    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lte_id = in_lam.lte_id;

    CURSOR c_lgr is                             -- Lesen des Lagerpltz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lam.lgr_platz
         and lgr.sid = in_lam.sid;

    CURSOR c_lgr_ort is                             -- Lesen des Lagerort
      select *
        from lvs_lgr_ort ort
       where ort.lgr_ort = v_ort
         and ort.sid = in_lam.sid;

    CURSOR c_charge is
      select chg.charge_bez
        from lvs_charge chg
       where chg.sid = in_sid
         and chg.charge_id = in_fa_auftrag.charge_id;

    CURSOR c_art is                        -- Lesen des Artikels
      select *
       from isi_artikel art
      where art.sid = in_sid
        and art.artikel_id = in_fa_auftrag.ag_artikel_id;
  begin
    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    if v_sid.sid_schnittstelle is NULL then
      return NULL;
    end if;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    OPEN c_charge;                                   -- Lesen der charge
    FETCH c_charge into v_charge;
    CLOSE c_charge;

    OPEN c_art;
    FETCH c_art into v_art;
    CLOSE c_art;

    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    v_quell_ort := NULL;
    OPEN c_lgr_ort;
    FETCH c_lgr_ort into v_quell_ort;
    CLOSE c_lgr_ort;

    v_mg                 := NULL;
    v_mg_b               := NULL;
    v_schrott            := NULL;
    v_r_mg               := NULL;
    v_r_mg_b             := NULL;
    v_r_schrott          := NULL;
    v_prod_zeit          := NULL;
    v_ruest_zeit         := NULL;
    v_stoer_zeit         := NULL;
    v_ruest_zeit_erf     := NULL;
    v_prod_zeit_erf      := NULL;

    if in_lam_bh_bus = c.lam_bh_bus_zug then
      v_mg                 := in_lam.menge;
      v_brutto_kg := in_lam.lam_kg;
      v_vorgang_typ := 'WEI';
    end if;
    if in_lam_bh_bus = c.lam_bh_bus_abg then
      v_mg                 := in_lam.menge;
      v_brutto_kg := in_lam.lam_kg;
      v_vorgang_typ := 'WAI';
    end if;
    if in_lam_bh_bus is NULL
    then
      if not isi_p_base.get_resource_zust_akt(in_sid,
                                              in_fa_auftrag.res_id,
                                              v_res_zus)
      then
        v_res_zus := NULL;
        v_res_zus.status_id := 0;
      end if;

      if isi_allg.c_get_firma_cfg_param(in_sid,
                                        in_firma_nr,
                                        'BDE_FA_AB',           -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        NULL,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'VALUE_ABSOLUT'  ,    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'BDE_DB',              -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                        'T',                   -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.C_TRUE  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
      then
        v_mg                 := in_fa_auftrag.ag_ist_mg;
        v_mg_b               := in_fa_auftrag.ag_ist_mg_b;
        v_schrott            := in_fa_auftrag.ag_ist_mg_schrott;
        v_r_mg               := nvl(in_fa_auftrag.ag_ist_mg_ruesten, 0);
        v_r_mg_b             := NULL;
        v_r_schrott          := NULL;
        v_prod_zeit          := in_fa_auftrag.prod_zeit_ist;
        v_ruest_zeit         := in_fa_auftrag.ruest_zeit_ist;
        v_stoer_zeit         := in_fa_auftrag.stoer_zeit_ist;
        v_vorgang_typ        := in_fa_auftrag.freig_status;
        v_brutto_kg          := NULL;
        v_ruest_zeit_erf     := in_fa_auftrag.ruest_zeit_erf;
        v_prod_zeit_erf      := in_fa_auftrag.prod_zeit_erf;
      else
        v_mg                 := in_fa_auftrag.ag_ist_mg - nvl(in_fa_auftrag.rcv_ag_ist_mg, 0);
        v_mg_b               := in_fa_auftrag.ag_ist_mg_b - nvl(in_fa_auftrag.rcv_ag_ist_mg_b, 0);
        v_schrott            := in_fa_auftrag.ag_ist_mg_schrott - nvl(in_fa_auftrag.rcv_ag_ist_mg_schrott, 0);
        v_r_mg               := nvl(in_fa_auftrag.ag_ist_mg_ruesten, 0) - nvl(in_fa_auftrag.rcv_ag_ist_mg_ruesten, 0);
        v_r_mg_b             := NULL;
        v_r_schrott          := NULL;
        v_prod_zeit          := in_fa_auftrag.prod_zeit_ist - nvl(in_fa_auftrag.rcv_prod_zeit_ist, 0);
        v_ruest_zeit         := in_fa_auftrag.ruest_zeit_ist - nvl(in_fa_auftrag.rcv_ruest_zeit_ist, 0);
        v_stoer_zeit         := in_fa_auftrag.stoer_zeit_ist - nvl(in_fa_auftrag.rcv_stoer_zeit_ist, 0);
        v_vorgang_typ        := in_fa_auftrag.freig_status;
        v_brutto_kg          := NULL;
        v_prod_zeit_erf      := in_fa_auftrag.prod_zeit_erf - nvl(in_fa_auftrag.rcv_prod_zeit_erf, 0);
        v_ruest_zeit_erf     := in_fa_auftrag.ruest_zeit_erf - nvl(in_fa_auftrag.rcv_ruest_zeit_erf, 0);
      end if;
    end if;

    insert into s_send_bew send
       values (
          NULL,                       -- BEW_ID          NUMBER,
          in_firma_nr,                -- FIRMA_NR        NUMBER(3),
          'ISI',                      -- HERKUNFT        VARCHAR2(3),
          in_tabelle,                 -- TABELLE         VARCHAR2(5),
          in_fa_auftrag.ag_id,        -- AUF_ID          NUMBER,
          in_status,                  -- STATUS          VARCHAR2(3),
          v_vorgang_typ,              -- AKTION          VARCHAR2(3),
          NULL,                       -- MA_STATUS       VARCHAR2(1),
          v_res_zus.status_id,        -- MA_S_GRUND      NUMBER(3),
          NULL,                       -- MA_ID           VARCHAR2(10),
          in_lam.lte_id,              -- LTE_NR          VARCHAR2(20),
          in_lam.lhm_id,              -- LHM_NR          VARCHAR2(20),
          v_quell_ort.host_lgr_ort,   -- LAGERORT        VARCHAR2(10),
          NULL,                       -- ZLAGERORT       VARCHAR2(10),
          v_mg,                       -- MENGE           NUMBER(12,3),
          v_mg_b,                     -- MENGE_B         NUMBER(12,3),
          v_schrott,                  -- SCHROTT         NUMBER(12,3),
          v_r_mg,                     -- R_MENGE         NUMBER(12,3),
          v_r_mg_b,                   -- R_MENGE_B       NUMBER(12,3),
          v_r_schrott,                -- R_SCHROTT       NUMBER(12,3),
          v_stoer_zeit,               -- STOERZEIT_IST   NUMBER,
          v_ruest_zeit,               -- RUESTZEIT_IST   NUMBER,
          v_prod_zeit,                -- PRODZEIT_IST    NUMBER,
          NULL,                       -- EXT_LIEF_NR     VARCHAR2(15),
          NULL,                       -- EXT_LIEF_POS    VARCHAR2(5),
          v_charge,                   -- CHARGE          VARCHAR2(20),
          NULL,                       -- SERIE           VARCHAR2(20),
          NULL,                       -- ARBEITSPLATZ_ID VARCHAR2(20),
          NULL,                       -- IST_BESTAND     NUMBER,
          v_art.artikel,              -- ARTIKEL         VARCHAR2(20),
          sysdate,                    -- B_DATUM         DATE,
          in_lam.lam_id,              -- LAM_ID          NUMBER,
          in_lam_bh_id,               -- LAM_BH_ID       NUMBER,
          in_lam_bh_typ,              -- LAM_BH_TYP      VARCHAR2(2)
          in_fa_auftrag.leitzahl,     -- LEITZAHL        NUMBER,
          in_fa_auftrag.fa_ag,        -- FA_AG           NUMBER,
          in_fa_auftrag.fa_upos,      -- FA_UPOS         NUMBER
          in_lam.fa_ag,               -- LAM_AG          NUMBER
          v_brutto_kg,                -- BRUTTO_KG
          NULL,                       -- TEXT            VARCHAR2(40),
          NULL,                       -- ERR_NR          NUMBER
          NULL,                       -- USER
          in_lam.res_id,              -- RES_ID          NUMBER
          NULL,                       -- SEND_ID         NUMBER
          v_res_zus.status_id,        -- MA_LAST_S_GRUND NUMBER
          v_res_zus.pers_nr,          -- PERS_NR         NUMBER (Personalnummer der Buchung lesen
          in_lam.labor_text,          -- SPER_GRUND      VARCHAR2(30)
          in_lam.lgr_platz,           -- LAGERPLATZ N VARCHAR2(10)  Y     Lagerplatz im ISI
          NULL,                       -- ZLAGERPLATZ  N VARCHAR2(10)  Y     Ziellagerplatz im ISI
          in_lam.labor_status,        -- LABOR_STATUS N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
          in_lam.lam_sel1,            -- LAM_SEL1 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel2,            -- LAM_SEL2 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel3,            -- LAM_SEL3 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel4,            -- LAM_SEL4 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel5,            -- LAM_SEL5 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel6,            -- LAM_SEL6 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel7,            -- LAM_SEL7 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel8,            -- LAM_SEL8 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel9,            -- LAM_SEL9 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel10,           -- LAM_SEL10  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          v_lte.lte_name,             -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
          NULL,                       -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
          v_ruest_zeit_erf,           -- RUEST_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
          v_prod_zeit_erf)           -- PROD_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
        returning bew_id into v_result;
  return v_result;
  end write_host_prod_bew;

  --------------------------------------------------------------------------------
  -- function trägt alle Daten in die BEW-Tabelle ein, Diese Tabelle ist für den
  -- Datentransfer von ISIPlus --> HOST (Update der Menge)
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure WRITE_HOST_PROD_BEW_MENGE(in_sid         in isi_sid.sid%type,
                                      in_firma_nr    in isi_firma.firma_nr%type,
                                      in_fa_auftrag  in bde_fa_auftrag%rowtype,
                                      in_lam         in lvs_lam%rowtype,
                                      in_lam_bh_id   in lvs_lam_bh.lam_bh_id%type,
                                      in_lam_bh_bus  in lvs_lam_bh.bus%type,
                                      in_lam_bh_typ  in lvs_lam_bh.vorg_typ%type,
                                      in_tabelle     in varchar2,
                                      in_status      in s_send_bew.status%type,
                                      in_menge       in number,
                                      in_login_id    in number
                                    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    --v_err_nr    number;
    --v_err_text  varchar2(255);

    --v_found     boolean;                                -- Daten Gefunfen?

    v_lgr                lvs_lgr%rowtype;
    v_lte                lvs_lte%rowtype;
    v_quelle_ort         lvs_lgr_ort%rowtype;       -- Lagerort Quelle
    v_user               isi_user%rowtype;

    v_charge             varchar2(255);
    v_art                isi_artikel%rowtype;       -- Artikel Daten
    v_vorgang_typ        s_send_bew.aktion%type;    -- WAE, WAI, WUI ... Warenabgang Extern, intern ...

    v_mg                 s_send_bew.menge%type;
    v_mg_b               s_send_bew.menge_b%type;
    v_schrott            s_send_bew.schrott%type;
    v_r_mg               s_send_bew.r_menge%type;
    v_r_mg_b             s_send_bew.r_menge_b%type;
    v_r_schrott          s_send_bew.r_schrott%type;
    v_prod_zeit          s_send_bew.prodzeit_ist%type;
    v_ruest_zeit         s_send_bew.ruestzeit_ist%type;
    v_stoer_zeit         s_send_bew.stoerzeit_ist%type;
    v_brutto_kg          number;
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
    v_ruest_zeit_erf     s_send_bew.ruestzeit_ist%type;
    v_prod_zeit_erf      s_send_bew.stoerzeit_ist%type;

    v_sid               isi_sid%rowtype;

    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lte_id = in_lam.lte_id;

    CURSOR c_sid is
      select *
        from isi_sid s
        where s.sid_my_sid = 1;

    CURSOR c_lgr is                             -- Lesen des Lagerpltz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lam.lgr_platz
         and lgr.sid = in_lam.sid;

    CURSOR c_lgr_ort is                             -- Lesen des Lagerort
      select *
        from lvs_lgr_ort ort
       where ort.lgr_ort = v_lgr.lgr_ort
         and ort.sid = in_lam.sid;

    CURSOR c_charge is
      select chg.charge_bez
        from lvs_charge chg
       where chg.sid = in_sid
         and chg.charge_id = in_lam.charge_id;

    CURSOR c_art is                        -- Lesen des Artikels
      select *
       from isi_artikel art
      where art.sid = in_sid
        and art.artikel_id = in_lam.artikel_id;
  begin
    v_user := NULL;

    OPEN c_sid;
    FETCH c_sid into v_sid;
    CLOSE c_sid;

    if v_sid.sid_schnittstelle is NULL then
      return;
    end if;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    -- Lesen der User-Daten zum übermitteln der Personalnummer zu Hostsystemen
    if not isi_allg.get_user_by_login_id(v_sid.sid, in_login_id, v_user)
    then
      v_user.pers_nr := NULL;
      v_user.username := NULL;
    end if;


    OPEN c_charge;                                   -- Lesen der charge
    FETCH c_charge into v_charge;
    CLOSE c_charge;

    OPEN c_art;
    FETCH c_art into v_art;
    CLOSE c_art;

    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    v_quelle_ort.host_lgr_ort := NULL;
    v_quelle_ort := NULL;
    OPEN c_lgr_ort;
    FETCH c_lgr_ort into v_quelle_ort;
    CLOSE c_lgr_ort;

    v_mg                 := NULL;
    v_mg_b               := NULL;
    v_schrott            := NULL;
    v_r_mg               := NULL;
    v_r_mg_b             := NULL;
    v_r_schrott          := NULL;
    v_prod_zeit          := NULL;
    v_ruest_zeit         := NULL;
    v_stoer_zeit         := NULL;
    v_ruest_zeit_erf     := NULL;
    v_prod_zeit_erf      := NULL;

    v_brutto_kg := NULL;
    if in_lam_bh_bus = c.lam_bh_bus_zug then
      v_mg                 := in_menge;
      v_brutto_kg := in_lam.lam_kg;
      v_vorgang_typ := 'WEI';
    end if;
    if in_lam_bh_bus = c.lam_bh_bus_abg
    or in_lam_bh_bus = c.lam_bh_bus_q then
      v_mg                 := in_menge;
      v_brutto_kg := in_lam.lam_kg;
      v_vorgang_typ := 'WAI';
    end if;

    insert into s_send_bew send
       values (
          NULL,                       -- BEW_ID          NUMBER,
          in_firma_nr,                -- FIRMA_NR        NUMBER(3),
          'ISI',                      -- HERKUNFT        VARCHAR2(3),
          in_tabelle,                 -- TABELLE         VARCHAR2(5),
          in_fa_auftrag.ag_id,        -- AUF_ID          NUMBER,
          in_status,                  -- STATUS          VARCHAR2(3),
          v_vorgang_typ,              -- AKTION          VARCHAR2(3),
          NULL,                       -- MA_STATUS       VARCHAR2(1),
          NULL,                       -- MA_S_GRUND      NUMBER(3),
          NULL,                       -- MA_ID           VARCHAR2(10),
          in_lam.lte_id,              -- LTE_NR          VARCHAR2(20),
          in_lam.lhm_id,              -- LHM_NR          VARCHAR2(20),
          v_quelle_ort.host_lgr_ort,  -- LAGERORT        VARCHAR2(10),
          NULL,                       -- ZLAGERORT       VARCHAR2(10),
          v_mg,                       -- MENGE           NUMBER(12,3),
          v_mg_b,                     -- MENGE_B         NUMBER(12,3),
          v_schrott,                  -- SCHROTT         NUMBER(12,3),
          v_r_mg,                     -- R_MENGE         NUMBER(12,3),
          v_r_mg_b,                   -- R_MENGE_B       NUMBER(12,3),
          v_r_schrott,                -- R_SCHROTT       NUMBER(12,3),
          v_stoer_zeit,               -- STOERZEIT_IST   NUMBER,
          v_ruest_zeit,               -- RUESTZEIT_IST   NUMBER,
          v_prod_zeit,                -- PRODZEIT_IST    NUMBER,
          NULL,                       -- EXT_LIEF_NR     VARCHAR2(15),
          NULL,                       -- EXT_LIEF_POS    VARCHAR2(5),
          v_charge,                   -- CHARGE          VARCHAR2(20),
          NULL,                       -- SERIE           VARCHAR2(20),
          NULL,                       -- ARBEITSPLATZ_ID VARCHAR2(20),
          NULL,                       -- IST_BESTAND     NUMBER,
          v_art.artikel,              -- ARTIKEL         VARCHAR2(20),
          sysdate,                    -- B_DATUM         DATE,
          in_lam.lam_id,              -- LAM_ID          NUMBER,
          in_lam_bh_id,               -- LAM_BH_ID       NUMBER,
          in_lam_bh_typ,              -- LAM_BH_TYP      VARCHAR2(2)
          in_fa_auftrag.leitzahl,     -- LEITZAHL        NUMBER,
          in_fa_auftrag.fa_ag,        -- FA_AG           NUMBER,
          in_fa_auftrag.fa_upos,      -- FA_UPOS         NUMBER
          in_lam.fa_ag,               -- LAM_AG          NUMBER
          v_brutto_kg,                -- BRUTTO_KG
          NULL,                       -- TEXT            VARCHAR2(40),
          NULL,                       -- ERR_NR          NUMBER
          v_user.username,            -- USER
          in_lam.res_id,              -- RES_ID          NUMBER
          NULL,                       -- SEND_ID         NUMBER
          NULL,                       -- MA_LAST_S_GRUND NUMBER
          v_user.pers_nr,             -- PERS_NR         NUMBER (Personalnummer der Buchung lesen
          in_lam.labor_text,         -- SPER_GRUND      VARCHAR2(30)
          in_lam.lgr_platz,           -- LAGERPLATZ N VARCHAR2(10)  Y     Lagerplatz im ISI
          NULL,                       -- ZLAGERPLATZ  N VARCHAR2(10)  Y     Ziellagerplatz im ISI
          in_lam.labor_status,        -- LABOR_STATUS N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
          in_lam.lam_sel1,            -- LAM_SEL1 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel2,            -- LAM_SEL2 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel3,            -- LAM_SEL3 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel4,            -- LAM_SEL4 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel5,            -- LAM_SEL5 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel6,            -- LAM_SEL6 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel7,            -- LAM_SEL7 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel8,            -- LAM_SEL8 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel9,            -- LAM_SEL9 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          in_lam.lam_sel10,           -- LAM_SEL10  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
          v_lte.lte_name,             -- LTE_NAME N VARCHAR2(15)  Y     Art, Name der Transporteinheit
          NULL,                       -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
          v_ruest_zeit_erf,           -- RUEST_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
          v_prod_zeit_erf);           -- PROD_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden

  end write_host_prod_bew_menge;

  --------------------------------------------------------------------------------
  -- function überträgt die daten in die Tabelle und gibt die auf_id zurueck
  -- Achtung der Funktion kann auch eine auf_id uebergeben werden. Diese muss
  -- dann in der Datenbank eindeutig sein
  --------------------------------------------------------------------------------
  --******************************************************************************
  function c_write_mfr_auftrag(in_firma           in     s_mfr_rcv_auftr.FIRMA_NR%type,
                               in_auf_id          in     s_mfr_rcv_auftr.AUF_ID%type,
                               in_satzart         in     s_mfr_rcv_auftr.SATZART%type,
                               in_funktion        in     s_mfr_rcv_auftr.FUNKTION%type,
                               in_auftrag         in     s_mfr_rcv_auftr.AUFTRAG%type,
                               in_lte_id          in     s_mfr_rcv_auftr.LTE_ID%type,
                               in_quelle          in     s_mfr_rcv_auftr.QUELLE%type,
                               in_ziel            in     s_mfr_rcv_auftr.ZIEL%type,
                               in_telegramm       in     s_mfr_rcv_auftr.TELEGRAMM%type)
                               return s_mfr_rcv_auftr.auf_id%type is

    v_auf_id            s_mfr_rcv_auftr.auf_id%type;
  begin
    insert into s_mfr_rcv_auftr
       values (in_firma,            -- FIRMA_NR        NUMBER(2) not null,
               in_auf_id,           -- AUF_ID          NUMBER not null,
               in_satzart,          -- SATZART   VARCHAR2(2),
               in_funktion,         -- FUNKTION  NUMBER(4),
               in_auftrag,          -- AUFTRAG   NUMBER(10),
               in_lte_id,           -- LTE_ID    VARCHAR2(19),
               sysdate,             -- GEN_DATUM DATE,
               in_quelle,           -- QUELLE    VARCHAR2(20),
               in_ziel,             -- ZIEL      VARCHAR2(20),
               in_telegramm         -- TELEGRAMM VARCHAR2(512) not null
               ) returning auf_id into v_auf_id;
    commit;
    return (v_auf_id);
  end c_write_mfr_auftrag;

  --------------------------------------------------------------------------------
  -- function überträgt die daten in die Tabelle und gibt die offline_id zurueck
  --------------------------------------------------------------------------------
  --******************************************************************************
  function c_write_mfr_send_offline(in_firma           in     s_mfr_send_offline.FIRMA_NR%type,
                                    in_auf_id          in     s_mfr_send_offline.AUF_ID%type,
                                    in_satzart         in     s_mfr_send_offline.SATZART%type,
                                    in_funktion        in     s_mfr_send_offline.FUNKTION%type,
                                    in_auftrag         in     s_mfr_send_offline.AUFTRAG%type,
                                    in_lte_id          in     s_mfr_send_offline.LTE_ID%type,
                                    in_quelle          in     s_mfr_send_offline.QUELLE%type,
                                    in_ziel            in     s_mfr_send_offline.ZIEL%type,
                                    in_telegramm       in     s_mfr_send_offline.TELEGRAMM%type,
                                    in_gruppe          in     s_mfr_send_offline.gruppe%type)
                                    return s_mfr_send_offline.offline_id%type is

    v_offline_id          s_mfr_send_offline.offline_id%type;
  begin
    insert into s_mfr_send_offline
       values (in_firma,            -- FIRMA_NR   NUMBER(2) not null,
               NULL,                -- OFFLINE_ID NUMBER not null,
               in_auf_id,           -- AUF_ID     NUMBER not null,
               in_satzart,          -- SATZART    VARCHAR2(2),
               in_funktion,         -- FUNKTION   NUMBER(4),
               in_auftrag,          -- AUFTRAG    NUMBER(10),
               in_lte_id,           -- LTE_ID     VARCHAR2(19),
               sysdate,             -- GEN_DATUM  DATE,
               in_quelle,           -- QUELLE     VARCHAR2(20),
               in_ziel,             -- ZIEL       VARCHAR2(20),
               in_telegramm,        -- TELEGRAMM  VARCHAR2(512) not null
               in_Gruppe               -- gruppe     VARCHAR2(20) not null
               ) returning offline_id into v_offline_id;
    commit;
    return (v_offline_id);
  end c_write_mfr_send_offline;

begin
  -- Initialization
  v_send_host_aktiv := True;
end S_SCHNITTSTELLE;
/



-- sqlcl_snapshot {"hash":"0b1f0fd4bf03bf79f3849c8b84adc37c6c4444a5","type":"PACKAGE_BODY","name":"S_SCHNITTSTELLE","schemaName":"DIRKSPZM32","sxml":""}