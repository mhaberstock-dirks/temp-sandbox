create or replace editionable trigger dirkspzm32.tr_isi_resource_zust_akt_biud after
    insert or update or delete on dirkspzm32.isi_resource_zust_akt
    for each row
declare
    v_resource   isi_resource%rowtype;
    v_fa_auftrag bde_fa_auftrag%rowtype;
    v_res_status isi_res_status%rowtype;
    v_user       isi_user%rowtype;
    v_daten      varchar2(1024);
    v_msg_mc     varchar2(50);
    v_mde_cfg    mde_cfg%rowtype;
    cursor c_res_status is
    select
        *
    from
        isi_res_status t
    where
            t.sid = v_resource.sid
        and t.firma_nr = v_resource.firma_nr
        and t.res_id = :new.res_id
        and t.st_start = :new.status_seit
        and t.res_st_id = :new.status_id;

--       isi_resource_zust_akt
    cursor c_resource is
    select
        t.*
    from
        isi_resource t
    where
        t.res_id = :new.res_id;

    cursor c_mde is
    select
        t.*
    from
        mde_cfg t
    where
        t.res_id = :new.res_id;

    cursor c_fa_auftrag is
    select
        t.*
    from
        bde_fa_auftrag t
    where
            t.sid = v_resource.sid
        and t.firma_nr = v_resource.firma_nr
        and t.leitzahl = nvl(:new.leitzahl,
                             :old.leitzahl)
        and t.fa_ag = nvl(:new.fa_ag,
                          :old.fa_ag)
        and nvl(t.fa_upos, 0) = nvl(
            nvl(:new.fa_upos,
                :old.fa_upos),
            0
        );

begin
    if updating then
        v_fa_auftrag := null;
        open c_resource;
        fetch c_resource into v_resource;
        close c_resource;

    -- -AG- Neue Funktion -> Status an den Host senden über S_BEW und DIS
        if isi_allg.get_firma_cfg_param(:new.sid,
                                        :new.firma_nr,
                                        v_resource.typ,           -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                        null,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                        'RES_SEND_SATUS_HOST',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                        'DB',                     -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.c_true     -- in_default_param_typ
                                         then
            open c_fa_auftrag;
            fetch c_fa_auftrag into v_fa_auftrag;
            close c_fa_auftrag;

      /* Schichtwechsel nicht senden (*  Evet zündet, wenn Maschine auf Stillstand geht
      if nvl(:new.pers_nr, -99999999) != nvl(:old.pers_nr, -99999999)
      then
        if nvl(:new.pers_nr, 0) != 0
        and nvl(:old.pers_nr, 0) = 0
        then
          v_msg_mc := 'SB';
        elsif nvl(:new.pers_nr, 0) = 0
        and nvl(:old.pers_nr, 0) != 0
        then
          v_msg_mc := 'SE';
        else
          v_msg_mc := 'SW';
        end if;

        insert into s_send_bew send
           values (
              NULL,                    -- BEW_ID          NUMBER,
              :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
              'ISI',                   -- HERKUNFT        VARCHAR2(3),
              'S_FA',                  -- TABELLE         VARCHAR2(5),
              v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
              'UE',                    -- STATUS          VARCHAR2(3),
              v_msg_mc,                -- AKTION          VARCHAR2(3),
              :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
              :new.status_id,          -- MA_S_GRUND      NUMBER(3),
              NULL,                    -- MA_ID           VARCHAR2(10),
              NULL,                    -- LTE_NR          VARCHAR2(20),
              NULL,                    -- LHM_NR          VARCHAR2(20),
              NULL,                    -- LAGERORT        VARCHAR2(10),
              NULL,                    -- ZLAGERORT       VARCHAR2(10),
              NULL,                    -- MENGE           NUMBER(12,3),
              NULL,                    -- MENGE_B         NUMBER(12,3),
              NULL,                    -- SCHROTT         NUMBER(12,3),
              NULL,                    -- R_MENGE         NUMBER(12,3),
              NULL,                    -- R_MENGE_B       NUMBER(12,3),
              NULL,                    -- R_SCHROTT       NUMBER(12,3),
              NULL,                    -- STOERZEIT_IST   NUMBER,
              NULL,                    -- RUESTZEIT_IST   NUMBER,
              NULL,                    -- PRODZEIT_IST    NUMBER,
              NULL,                    -- EXT_LIEF_NR     VARCHAR2(15),
              NULL,                    -- EXT_LIEF_POS    VARCHAR2(5),
              NULL,                    -- CHARGE          VARCHAR2(20),
              NULL,                    -- SERIE           VARCHAR2(20),
              NULL,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
              NULL,                    -- IST_BESTAND     NUMBER,
              NULL,                    -- ARTIKEL         VARCHAR2(20),
              sysdate,                 -- B_DATUM         DATE,
              NULL,                    -- LAM_ID          NUMBER,
              NULL,                    -- LAM_BH_ID       NUMBER,
              NULL,                    -- LAM_BH_TYP      VARCHAR2(2)
              :new.leitzahl,           -- LEITZAHL        NUMBER,
              :new.fa_ag,              -- FA_AG           NUMBER,
              :new.fa_upos,            -- FA_UPOS         NUMBER
              NULL,                    -- LAM_AG          NUMBER
              NULL,                    -- BRUTTO_KG
              NULL,                    -- TEXT            VARCHAR2(40),
              NULL,                    -- ERR_NR          NUMBER
              NULL,                    -- USER_NAME       VARCHAR2(100),
              :new.res_id,             -- RES_ID          NUMBER
              NULL,                    -- SEND_ID         NUMBER
              :old.status_id,          -- MA_LAST_S_GRUND NUMBER
              :new.pers_nr);           -- PERS_NR        NUMBER

      end if;
      */

            if
                nvl(:new.leitzahl,
                    0) = nvl(:old.leitzahl,
                             0)
                and :new.akt_aufgabe = 'P'
                and :old.akt_aufgabe = 'R'
            then
                v_msg_mc := 'RE';
        -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
                insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                     :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                     'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                     'S_FA',                  -- TABELLE         VARCHAR2(5),
                                                     v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
                                                     'UE',                    -- STATUS          VARCHAR2(3),
                                                     v_msg_mc,                -- AKTION          VARCHAR2(3),
                                                     :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
                                                     :new.status_id,          -- MA_S_GRUND      NUMBER(3),
                                                     null,                    -- MA_ID           VARCHAR2(10),
                                                     null,                    -- LTE_NR          VARCHAR2(20),
                                                     null,                    -- LHM_NR          VARCHAR2(20),
                                                     null,                    -- LAGERORT        VARCHAR2(10),
                                                     null,                    -- ZLAGERORT       VARCHAR2(10),
                                                     null,                    -- MENGE           NUMBER(12,3),
                                                     null,                    -- MENGE_B         NUMBER(12,3),
                                                     null,                    -- SCHROTT         NUMBER(12,3),
                                                     null,                    -- R_MENGE         NUMBER(12,3),
                                                     null,                    -- R_MENGE_B       NUMBER(12,3),
                                                     null,                    -- R_SCHROTT       NUMBER(12,3),
                                                     null,                    -- STOERZEIT_IST   NUMBER,
                                                     null,                    -- RUESTZEIT_IST   NUMBER,
                                                     null,                    -- PRODZEIT_IST    NUMBER,
                                                     null,                    -- EXT_LIEF_NR     VARCHAR2(15),
                                                     null,                    -- EXT_LIEF_POS    VARCHAR2(5),
                                                     null,                    -- CHARGE          VARCHAR2(20),
                                                     null,                    -- SERIE           VARCHAR2(20),
                                                     null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                     null,                    -- IST_BESTAND     NUMBER,
                                                     null,                    -- ARTIKEL         VARCHAR2(20),
                                                     sysdate,                 -- B_DATUM         DATE,
                                                     null,                    -- LAM_ID          NUMBER,
                                                     null,                    -- LAM_BH_ID       NUMBER,
                                                     null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                     v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
                                                     v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
                                                     v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
                                                     null,                    -- LAM_AG          NUMBER
                                                     null,                    -- BRUTTO_KG
                                                     null,                    -- TEXT            VARCHAR2(40),
                                                     null,                    -- ERR_NR          NUMBER
                                                     null,                    -- USER_NAME       VARCHAR2(100),
                                                     :new.res_id,             -- RES_ID          NUMBER
                                                     null,                    -- SEND_ID         NUMBER
                                                     :old.status_id,          -- MA_LAST_S_GRUND NUMBER
                                                     :new.pers_nr,            -- PERS_NR         NUMBER
                                                     null,                    -- SPER_GRUND      VARCHAR2(30)
                                                     null,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                                                     null,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                                                     null,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                                                     null,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                                                     null,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                     null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                     null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                v_msg_mc := 'RF';
                insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                     :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                     'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                     'S_FA',                  -- TABELLE         VARCHAR2(5),
                                                     v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
                                                     'UE',                    -- STATUS          VARCHAR2(3),
                                                     v_msg_mc,                -- AKTION          VARCHAR2(3),
                                                     :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
                                                     :new.status_id,          -- MA_S_GRUND      NUMBER(3),
                                                     null,                    -- MA_ID           VARCHAR2(10),
                                                     null,                    -- LTE_NR          VARCHAR2(20),
                                                     null,                    -- LHM_NR          VARCHAR2(20),
                                                     null,                    -- LAGERORT        VARCHAR2(10),
                                                     null,                    -- ZLAGERORT       VARCHAR2(10),
                                                     0,                       -- MENGE           NUMBER(12,3),
                                                     0,                       -- MENGE_B         NUMBER(12,3),
                                                     0,                       -- SCHROTT         NUMBER(12,3),
                                                     0,                       -- R_MENGE         NUMBER(12,3),
                                                     0,                       -- R_MENGE_B       NUMBER(12,3),
                                                     0,                       -- R_SCHROTT       NUMBER(12,3),
                                                     0,                       -- STOERZEIT_IST   NUMBER,
                                                     0,                       -- RUESTZEIT_IST   NUMBER,
                                                     0,                       -- PRODZEIT_IST    NUMBER,
                                                     null,                    -- EXT_LIEF_NR     VARCHAR2(15),
                                                     null,                    -- EXT_LIEF_POS    VARCHAR2(5),
                                                     null,                    -- CHARGE          VARCHAR2(20),
                                                     null,                    -- SERIE           VARCHAR2(20),
                                                     null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                     null,                    -- IST_BESTAND     NUMBER,
                                                     null,                    -- ARTIKEL         VARCHAR2(20),
                                                     sysdate,                 -- B_DATUM         DATE,
                                                     null,                    -- LAM_ID          NUMBER,
                                                     null,                    -- LAM_BH_ID       NUMBER,
                                                     null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                     v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
                                                     v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
                                                     v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
                                                     null,                    -- LAM_AG          NUMBER
                                                     null,                    -- BRUTTO_KG
                                                     null,                    -- TEXT            VARCHAR2(40),
                                                     null,                    -- ERR_NR          NUMBER
                                                     null,                    -- USER_NAME       VARCHAR2(100),
                                                     :new.res_id,             -- RES_ID          NUMBER
                                                     null,                    -- SEND_ID         NUMBER
                                                     :old.status_id,          -- MA_LAST_S_GRUND NUMBER
                                                     :new.pers_nr,            -- PERS_NR         NUMBER
                                                     null,                    -- SPER_GRUND      VARCHAR2(30)
                                                     null,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                                                     null,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                                                     null,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                                                     null,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                                                     null,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                     null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                     null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                v_msg_mc := 'PS';
                insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                     :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                     'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                     'S_FA',                  -- TABELLE         VARCHAR2(5),
                                                     v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
                                                     'UE',                    -- STATUS          VARCHAR2(3),
                                                     v_msg_mc,                -- AKTION          VARCHAR2(3),
                                                     :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
                                                     :new.status_id,          -- MA_S_GRUND      NUMBER(3),
                                                     null,                    -- MA_ID           VARCHAR2(10),
                                                     null,                    -- LTE_NR          VARCHAR2(20),
                                                     null,                    -- LHM_NR          VARCHAR2(20),
                                                     null,                    -- LAGERORT        VARCHAR2(10),
                                                     null,                    -- ZLAGERORT       VARCHAR2(10),
                                                     null,                    -- MENGE           NUMBER(12,3),
                                                     null,                    -- MENGE_B         NUMBER(12,3),
                                                     null,                    -- SCHROTT         NUMBER(12,3),
                                                     null,                    -- R_MENGE         NUMBER(12,3),
                                                     null,                    -- R_MENGE_B       NUMBER(12,3),
                                                     null,                    -- R_SCHROTT       NUMBER(12,3),
                                                     null,                    -- STOERZEIT_IST   NUMBER,
                                                     null,                    -- RUESTZEIT_IST   NUMBER,
                                                     null,                    -- PRODZEIT_IST    NUMBER,
                                                     null,                    -- EXT_LIEF_NR     VARCHAR2(15),
                                                     null,                    -- EXT_LIEF_POS    VARCHAR2(5),
                                                     null,                    -- CHARGE          VARCHAR2(20),
                                                     null,                    -- SERIE           VARCHAR2(20),
                                                     null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                     null,                    -- IST_BESTAND     NUMBER,
                                                     null,                    -- ARTIKEL         VARCHAR2(20),
                                                     sysdate,                 -- B_DATUM         DATE,
                                                     null,                    -- LAM_ID          NUMBER,
                                                     null,                    -- LAM_BH_ID       NUMBER,
                                                     null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                     v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
                                                     v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
                                                     v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
                                                     null,                    -- LAM_AG          NUMBER
                                                     null,                    -- BRUTTO_KG
                                                     null,                    -- TEXT            VARCHAR2(40),
                                                     null,                    -- ERR_NR          NUMBER
                                                     null,                    -- USER_NAME       VARCHAR2(100),
                                                     :new.res_id,             -- RES_ID          NUMBER
                                                     null,                    -- SEND_ID         NUMBER
                                                     :old.status_id,          -- MA_LAST_S_GRUND NUMBER
                                                     :new.pers_nr,            -- PERS_NR         NUMBER
                                                     null,                    -- SPER_GRUND      VARCHAR2(30)
                                                     null,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                                                     null,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                                                     null,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                                                     null,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                                                     null,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                     null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                     null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
            end if;

            if nvl(:new.leitzahl,
                   0) != nvl(:old.leitzahl,
                             0) then
                if nvl(:new.leitzahl,
                       0) != 0 then
                    if :new.akt_aufgabe = 'R' then
                        v_msg_mc := 'RS';
                    else
                        v_msg_mc := 'PS';
                    end if;
                else
                    if :old.akt_aufgabe = 'R' then
                        v_msg_mc := 'RE';
                    else
                        v_msg_mc := 'PE';
                    end if;
                end if;

                insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                     :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                     'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                     'S_FA',                  -- TABELLE         VARCHAR2(5),
                                                     v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
                                                     'UE',                    -- STATUS          VARCHAR2(3),
                                                     v_msg_mc,                -- AKTION          VARCHAR2(3),
                                                     :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
                                                     :new.status_id,          -- MA_S_GRUND      NUMBER(3),
                                                     null,                    -- MA_ID           VARCHAR2(10),
                                                     null,                    -- LTE_NR          VARCHAR2(20),
                                                     null,                    -- LHM_NR          VARCHAR2(20),
                                                     null,                    -- LAGERORT        VARCHAR2(10),
                                                     null,                    -- ZLAGERORT       VARCHAR2(10),
                                                     null,                    -- MENGE           NUMBER(12,3),
                                                     null,                    -- MENGE_B         NUMBER(12,3),
                                                     null,                    -- SCHROTT         NUMBER(12,3),
                                                     null,                    -- R_MENGE         NUMBER(12,3),
                                                     null,                    -- R_MENGE_B       NUMBER(12,3),
                                                     null,                    -- R_SCHROTT       NUMBER(12,3),
                                                     null,                    -- STOERZEIT_IST   NUMBER,
                                                     null,                    -- RUESTZEIT_IST   NUMBER,
                                                     null,                    -- PRODZEIT_IST    NUMBER,
                                                     null,                    -- EXT_LIEF_NR     VARCHAR2(15),
                                                     null,                    -- EXT_LIEF_POS    VARCHAR2(5),
                                                     null,                    -- CHARGE          VARCHAR2(20),
                                                     null,                    -- SERIE           VARCHAR2(20),
                                                     null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                     null,                    -- IST_BESTAND     NUMBER,
                                                     null,                    -- ARTIKEL         VARCHAR2(20),
                                                     sysdate,                 -- B_DATUM         DATE,
                                                     null,                    -- LAM_ID          NUMBER,
                                                     null,                    -- LAM_BH_ID       NUMBER,
                                                     null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                     v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
                                                     v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
                                                     v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
                                                     null,                    -- LAM_AG          NUMBER
                                                     null,                    -- BRUTTO_KG
                                                     null,                    -- TEXT            VARCHAR2(40),
                                                     null,                    -- ERR_NR          NUMBER
                                                     null,                    -- USER_NAME       VARCHAR2(100),
                                                     :new.res_id,             -- RES_ID          NUMBER
                                                     null,                    -- SEND_ID         NUMBER
                                                     :old.status_id,          -- MA_LAST_S_GRUND NUMBER
                                                     :new.pers_nr,            -- PERS_NR         NUMBER
                                                     null,                    -- SPER_GRUND      VARCHAR2(30)
                                                     null,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                                                     null,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                                                     null,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                                                     null,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                                                     null,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                     null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                     null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
            end if;

            if :new.status_id != :old.status_id then
                v_msg_mc := 'SG';
                v_res_status := null;
                open c_res_status;
                fetch c_res_status into v_res_status;
                close c_res_status;
                if not isi_allg.get_user_by_login_id(:new.sid,
                                                     v_res_status.ls_login_id,
                                                     v_user) then
                    v_user.pers_nr := null;
                end if;

                insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                     :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                     'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                     'S_FA',                  -- TABELLE         VARCHAR2(5),
                                                     v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
                                                     'UE',                    -- STATUS          VARCHAR2(3),
                                                     v_msg_mc,                -- AKTION          VARCHAR2(3),
                                                     :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
                                                     :new.status_id,          -- MA_S_GRUND      NUMBER(3),
                                                     null,                    -- MA_ID           VARCHAR2(10),
                                                     null,                    -- LTE_NR          VARCHAR2(20),
                                                     null,                    -- LHM_NR          VARCHAR2(20),
                                                     null,                    -- LAGERORT        VARCHAR2(10),
                                                     null,                    -- ZLAGERORT       VARCHAR2(10),
                                                     null,                    -- MENGE           NUMBER(12,3),
                                                     null,                    -- MENGE_B         NUMBER(12,3),
                                                     null,                    -- SCHROTT         NUMBER(12,3),
                                                     null,                    -- R_MENGE         NUMBER(12,3),
                                                     null,                    -- R_MENGE_B       NUMBER(12,3),
                                                     null,                    -- R_SCHROTT       NUMBER(12,3),
                                                     null,                    -- STOERZEIT_IST   NUMBER,
                                                     null,                    -- RUESTZEIT_IST   NUMBER,
                                                     null,                    -- PRODZEIT_IST    NUMBER,
                                                     null,                    -- EXT_LIEF_NR     VARCHAR2(15),
                                                     null,                    -- EXT_LIEF_POS    VARCHAR2(5),
                                                     null,                    -- CHARGE          VARCHAR2(20),
                                                     null,                    -- SERIE           VARCHAR2(20),
                                                     null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                     null,                    -- IST_BESTAND     NUMBER,
                                                     null,                    -- ARTIKEL         VARCHAR2(20),
                                                     sysdate,                 -- B_DATUM         DATE,
                                                     null,                    -- LAM_ID          NUMBER,
                                                     null,                    -- LAM_BH_ID       NUMBER,
                                                     null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                     :new.leitzahl,           -- LEITZAHL        NUMBER,
                                                     :new.fa_ag,              -- FA_AG           NUMBER,
                                                     :new.fa_upos,            -- FA_UPOS         NUMBER
                                                     null,                    -- LAM_AG          NUMBER
                                                     null,                    -- BRUTTO_KG
                                                     null,                    -- TEXT            VARCHAR2(40),
                                                     null,                    -- ERR_NR          NUMBER
                                                     null,                    -- USER_NAME       VARCHAR2(100),
                                                     :new.res_id,             -- RES_ID          NUMBER
                                                     null,                    -- SEND_ID         NUMBER
                                                     :old.status_id,          -- MA_LAST_S_GRUND NUMBER
                                                     v_user.pers_nr,          -- PERS_NR         NUMBER
                                                     null,                    -- SPER_GRUND      VARCHAR2(30)
                                                     null,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                                                     null,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                                                     null,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                                                     null,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                                                     null,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                     null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                     null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
            end if;

            if nvl(:new.lte_id,
                   'keine') != :old.lte_id    -- Nur wenn eine Palette an der maschine gemeldet war
                    then
                v_msg_mc := 'LTE';
                insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                     :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                     'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                     'S_FA',                  -- TABELLE         VARCHAR2(5),
                                                     v_fa_auftrag.ag_id,      -- AUF_ID          NUMBER,
                                                     'UE',                    -- STATUS          VARCHAR2(3),
                                                     v_msg_mc,                -- AKTION          VARCHAR2(3),
                                                     :new.akt_aufgabe,        -- MA_STATUS       VARCHAR2(1),
                                                     :new.status_id,          -- MA_S_GRUND      NUMBER(3),
                                                     null,                    -- MA_ID           VARCHAR2(10),
                                                     :old.lte_id,             -- LTE_NR          VARCHAR2(20),
                                                     null,                    -- LHM_NR          VARCHAR2(20),
                                                     null,                    -- LAGERORT        VARCHAR2(10),
                                                     null,                    -- ZLAGERORT       VARCHAR2(10),
                                                     null,                    -- MENGE           NUMBER(12,3),
                                                     null,                    -- MENGE_B         NUMBER(12,3),
                                                     null,                    -- SCHROTT         NUMBER(12,3),
                                                     null,                    -- R_MENGE         NUMBER(12,3),
                                                     null,                    -- R_MENGE_B       NUMBER(12,3),
                                                     null,                    -- R_SCHROTT       NUMBER(12,3),
                                                     null,                    -- STOERZEIT_IST   NUMBER,
                                                     null,                    -- RUESTZEIT_IST   NUMBER,
                                                     null,                    -- PRODZEIT_IST    NUMBER,
                                                     null,                    -- EXT_LIEF_NR     VARCHAR2(15),
                                                     null,                    -- EXT_LIEF_POS    VARCHAR2(5),
                                                     null,                    -- CHARGE          VARCHAR2(20),
                                                     null,                    -- SERIE           VARCHAR2(20),
                                                     null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                     null,                    -- IST_BESTAND     NUMBER,
                                                     null,                    -- ARTIKEL         VARCHAR2(20),
                                                     sysdate,                 -- B_DATUM         DATE,
                                                     null,                    -- LAM_ID          NUMBER,
                                                     null,                    -- LAM_BH_ID       NUMBER,
                                                     null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                     :new.leitzahl,           -- LEITZAHL        NUMBER,
                                                     :new.fa_ag,              -- FA_AG           NUMBER,
                                                     :new.fa_upos,            -- FA_UPOS         NUMBER
                                                     null,                    -- LAM_AG          NUMBER
                                                     null,                    -- BRUTTO_KG
                                                     null,                    -- TEXT            VARCHAR2(40),
                                                     null,                    -- ERR_NR          NUMBER
                                                     null,                    -- USER_NAME       VARCHAR2(100),
                                                     :new.res_id,             -- RES_ID          NUMBER
                                                     null,                    -- SEND_ID         NUMBER
                                                     :old.status_id,          -- MA_LAST_S_GRUND NUMBER
                                                     :new.pers_nr,            -- PERS_NR         NUMBER
                                                     null,                    -- SPER_GRUND      VARCHAR2(30)
                                                     null,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
                                                     null,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
                                                     null,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
                                                     null,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
                                                     null,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
                                                     null,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                     null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                     null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
            end if;

        end if;

        v_fa_auftrag := null;
        if v_resource.typ != 'MS' then
            return;
        end if;
        open c_mde;
        fetch c_mde into v_mde_cfg;
        close c_mde;
        if v_mde_cfg.res_id = :new.res_id then
            v_daten := '"'
                       || c.c_msg_mde_masch_name
                       || '='
                       || v_resource.res_ext_name
                       || '", ';

            if nvl(:new.pers_nr,
                   -1) != nvl(:old.pers_nr,
                              -1) then
                if
                    nvl(:new.pers_nr,
                        0) != 0
                    and nvl(:old.pers_nr,
                            0) = 0
                then
                    v_msg_mc := c.msg_mc_mde_schicht_anfang;
                elsif
                    nvl(:new.pers_nr,
                        0) = 0
                    and nvl(:old.pers_nr,
                            0) != 0
                then
                    v_msg_mc := c.msg_mc_mde_schicht_ende;
                else
                    v_msg_mc := c.msg_mc_mde_schicht_wechsel;
                end if;

                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

                 null,                              -- in_sender_module_name          in     varchar2,

                 null,                              -- in_sender_application_handle   in     varchar2,

                 null,                              -- in_recipient_name              in     varchar2,

                 'mde_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                                c.msg_mt_mde_server,               -- in_message_type                in     number,
                                                v_msg_mc,                          -- in_message_command             in     number,
                                                0,                                 -- in_data_type                   in     number,
                                                v_daten);                          -- in_data                        in     varchar2)
            end if;

            if nvl(:new.leitzahl,
                   0) != nvl(:old.leitzahl,
                             0) then
                if nvl(:new.leitzahl,
                       0) != 0 then
                    v_daten := v_daten
                               || c.c_msg_mde_leitzahl
                               || '='
                               || :new.leitzahl
                               || ',';

                    v_daten := v_daten
                               || c.c_msg_mde_fa_ag
                               || '='
                               || :new.fa_ag
                               || ',';

                    v_daten := v_daten
                               || c.c_msg_mde_fa_upos
                               || '='
                               || :new.fa_upos;

                    open c_fa_auftrag;
                    fetch c_fa_auftrag into v_fa_auftrag;
                    close c_fa_auftrag;
                    v_daten := v_daten || ',';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_soll_mg
                               || '='
                               || nvl(v_fa_auftrag.ag_soll_mg, 0)
                               || ',';

                    v_daten := v_daten
                               || c.c_msg_mde_fa_soll_lhm_mg
                               || '='
                               || nvl(v_fa_auftrag.lhm_menge, 0)
                               || ',';

                    v_daten := v_daten
                               || c.c_msg_mde_fa_ist_mg
                               || '='
                               || nvl(v_fa_auftrag.mde_ist_mg, 0);

                    if :new.akt_aufgabe = 'R' then
                        v_msg_mc := c.msg_mc_mde_auf_stat_ruesten;
                        v_daten := v_daten || ',';
                        v_daten := v_daten
                                   || c.c_msg_mde_fa_ist_mg_b
                                   || '=0,';
                        v_daten := v_daten
                                   || c.c_msg_mde_fa_ist_mg_s
                                   || '='
                                   || nvl(v_fa_auftrag.mde_ist_mg_ruesten, 0);

                    else
                        v_daten := v_daten || ',';
                        v_msg_mc := c.msg_mc_mde_auf_stat_produktion;
                        v_daten := v_daten
                                   || c.c_msg_mde_fa_ist_mg_b
                                   || '='
                                   || nvl(v_fa_auftrag.mde_ist_mg_b, 0)
                                   || ',';

                        v_daten := v_daten
                                   || c.c_msg_mde_fa_ist_mg_s
                                   || '='
                                   || nvl(v_fa_auftrag.mde_ist_mg_schrott, 0);

                    end if;

                else
                    v_daten := v_daten
                               || c.c_msg_mde_leitzahl
                               || '=0,';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_ag
                               || '=0,';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_upos
                               || '=0';
                    v_daten := v_daten || ',';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_soll_mg
                               || '=0,';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_soll_lhm_mg
                               || '=0,';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_ist_mg
                               || '=0';
                    v_msg_mc := c.msg_mc_mde_auf_stat_ruesten;
                    v_daten := v_daten || ',';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_ist_mg_b
                               || '=0,';
                    v_daten := v_daten
                               || c.c_msg_mde_fa_ist_mg_s
                               || '=0';
                    if :old.akt_aufgabe = 'R' then
                        v_msg_mc := c.msg_mc_mde_auf_stat_r_ende;
                    else
                        v_msg_mc := c.msg_mc_mde_auf_stat_p_ende;
                    end if;

                end if;

                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

                 null,                              -- in_sender_module_name          in     varchar2,

                 null,                              -- in_sender_application_handle   in     varchar2,

                 null,                              -- in_recipient_name              in     varchar2,

                 'mde_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                                c.msg_mt_mde_server,               -- in_message_type                in     number,
                                                v_msg_mc,                          -- in_message_command             in     number,
                                                0,                                 -- in_data_type                   in     number,
                                                v_daten);                          -- in_data                        in     varchar2)
            end if;

            if :new.status_id != :old.status_id then
                if :new.status_id < 0 then
                    v_daten := v_daten
                               || c.c_msg_mde_res_status_id
                               || '=999';
                else
                    v_daten := v_daten
                               || c.c_msg_mde_res_status_id
                               || '='
                               || :new.status_id;
                end if;

                isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

                 null,                              -- in_sender_module_name          in     varchar2,

                 null,                              -- in_sender_application_handle   in     varchar2,

                 null,                              -- in_recipient_name              in     varchar2,

                 'mde_server',                      -- in_recipient_module_name       in     varchar2,
                                               false,                             -- in_response_required           in     boolean,
                                                c.msg_mt_mde_server,               -- in_message_type                in     number,
                                                c.msg_mc_mde_res_status_wechsel,   -- in_message_command             in     number,
                                                0,                                 -- in_data_type                   in     number,
                                                v_daten);                          -- in_data                        in     varchar2)
            end if;

            return;
        end if;

        v_daten := '"'
                   || c.c_msg_res_res_id
                   || '='
                   || v_resource.res_id
                   || '", ';

        v_daten := v_daten
                   || '"'
                   || c.c_msg_res_masch_name
                   || '='
                   || v_resource.res_ext_name
                   || '", ';

        if nvl(:new.pers_nr,
               -1) != nvl(:old.pers_nr,
                          -1) then
            if
                nvl(:new.pers_nr,
                    0) != 0
                and nvl(:old.pers_nr,
                        0) = 0
            then
                v_msg_mc := c.msg_mc_res_schicht_anfang;
            elsif
                nvl(:new.pers_nr,
                    0) = 0
                and nvl(:old.pers_nr,
                        0) != 0
            then
                v_msg_mc := c.msg_mc_res_schicht_ende;
            else
                v_msg_mc := c.msg_mc_res_schicht_wechsel;
            end if;

            isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

             null,                              -- in_sender_module_name          in     varchar2,

             null,                              -- in_sender_application_handle   in     varchar2,

             null,                              -- in_recipient_name              in     varchar2,

             null,                              -- in_recipient_module_name       in     varchar2,
                                           false,                             -- in_response_required           in     boolean,
                                            c.msg_mt_res_zust_chg,             -- in_message_type                in     number,
                                            v_msg_mc,                          -- in_message_command             in     number,
                                            0,                                 -- in_data_type                   in     number,
                                            v_daten);                          -- in_data                        in     varchar2)
        end if;

        if :new.akt_aufgabe = 'G' -- Erstelle Auftrag

         then
            return;
        end if;
        if nvl(:new.leitzahl,
               0) != nvl(:old.leitzahl,
                         0) then
            if nvl(:new.leitzahl,
                   0) != 0 then
                v_daten := v_daten
                           || c.c_msg_res_leitzahl
                           || '='
                           || :new.leitzahl
                           || ',';

                v_daten := v_daten
                           || c.c_msg_res_fa_ag
                           || '='
                           || :new.fa_ag
                           || ',';

                v_daten := v_daten
                           || c.c_msg_res_fa_upos
                           || '='
                           || :new.fa_upos;

                open c_fa_auftrag;
                fetch c_fa_auftrag into v_fa_auftrag;
                close c_fa_auftrag;
                v_daten := v_daten || ',';
                v_daten := v_daten
                           || c.c_msg_res_fa_soll_mg
                           || '='
                           || nvl(v_fa_auftrag.ag_soll_mg, 0)
                           || ',';

                v_daten := v_daten
                           || c.c_msg_res_fa_soll_lhm_mg
                           || '='
                           || nvl(v_fa_auftrag.lhm_menge, 0)
                           || ',';

                v_daten := v_daten
                           || c.c_msg_res_fa_ist_mg
                           || '='
                           || nvl(v_fa_auftrag.ag_ist_mg, 0);

                if :new.akt_aufgabe = 'R' then
                    v_msg_mc := c.msg_mc_res_auf_stat_ruesten;
                    v_daten := v_daten || ',';
                    v_daten := v_daten
                               || c.c_msg_res_fa_ist_mg_b
                               || '=0,';
                    v_daten := v_daten
                               || c.c_msg_res_fa_ist_mg_s
                               || '='
                               || nvl(v_fa_auftrag.ag_ist_mg_ruesten, 0);

                else
                    v_daten := v_daten || ',';
                    v_msg_mc := c.msg_mc_res_auf_stat_produktion;
                    v_daten := v_daten
                               || c.c_msg_res_fa_ist_mg_b
                               || '='
                               || nvl(v_fa_auftrag.ag_ist_mg_b, 0)
                               || ',';

                    v_daten := v_daten
                               || c.c_msg_res_fa_ist_mg_s
                               || '='
                               || nvl(v_fa_auftrag.ag_ist_mg_schrott, 0);

                end if;

            else
                v_daten := v_daten
                           || c.c_msg_res_leitzahl
                           || '=0,';
                v_daten := v_daten
                           || c.c_msg_res_fa_ag
                           || '=0,';
                v_daten := v_daten
                           || c.c_msg_res_fa_upos
                           || '=0';
                v_daten := v_daten || ',';
                v_daten := v_daten
                           || c.c_msg_res_fa_soll_mg
                           || '=0,';
                v_daten := v_daten
                           || c.c_msg_res_fa_soll_lhm_mg
                           || '=0,';
                v_daten := v_daten
                           || c.c_msg_res_fa_ist_mg
                           || '=0';
                v_msg_mc := c.msg_mc_res_auf_stat_ruesten;
                v_daten := v_daten || ',';
                v_daten := v_daten
                           || c.c_msg_res_fa_ist_mg_b
                           || '=0,';
                v_daten := v_daten
                           || c.c_msg_res_fa_ist_mg_s
                           || '=0';
                if :old.akt_aufgabe = 'R' then
                    v_msg_mc := c.msg_mc_res_auf_stat_r_ende;
                else
                    v_msg_mc := c.msg_mc_res_auf_stat_p_ende;
                end if;

            end if;

            isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

             null,                              -- in_sender_module_name          in     varchar2,

             null,                              -- in_sender_application_handle   in     varchar2,

             null,                              -- in_recipient_name              in     varchar2,

             null,                              -- in_recipient_module_name       in     varchar2,
                                           false,                             -- in_response_required           in     boolean,
                                            c.msg_mt_res_zust_chg,             -- in_message_type                in     number,
                                            v_msg_mc,                          -- in_message_command             in     number,
                                            0,                                 -- in_data_type                   in     number,
                                            v_daten);                          -- in_data                        in     varchar2)
        end if;

        if
            :new.auftrag_status != :old.auftrag_status
            and :new.auftrag_status = 'S' -- Auftrag gestoppt
        then
            v_daten := v_daten
                       || c.c_msg_mde_leitzahl
                       || '='
                       || :new.leitzahl
                       || ',';

            v_daten := v_daten
                       || c.c_msg_mde_fa_ag
                       || '='
                       || :new.fa_ag
                       || ',';

            v_daten := v_daten
                       || c.c_msg_mde_fa_upos
                       || '='
                       || :new.fa_upos;

            isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

             null,                              -- in_sender_module_name          in     varchar2,

             null,                              -- in_sender_application_handle   in     varchar2,

             null,                              -- in_recipient_name              in     varchar2,

             null,                              -- in_recipient_module_name       in     varchar2,
                                           false,                             -- in_response_required           in     boolean,
                                            c.msg_mt_res_zust_chg,             -- in_message_type                in     number,
                                            c.msg_mc_res_auf_stat_stop,        -- in_message_command             in     number,
                                            0,                                 -- in_data_type                   in     number,
                                            v_daten);                          -- in_data                        in     varchar2)
        end if;

        if :new.status_id != :old.status_id then
            v_daten := v_daten
                       || c.c_msg_mde_res_status_id
                       || '='
                       || :new.status_id;

            isi_message_board.send_message(null,                              -- in_sender_name                 in     varchar2,

             null,                              -- in_sender_module_name          in     varchar2,

             null,                              -- in_sender_application_handle   in     varchar2,

             null,                              -- in_recipient_name              in     varchar2,

             null,                              -- in_recipient_module_name       in     varchar2,
                                           false,                             -- in_response_required           in     boolean,
                                            c.msg_mt_res_zust_chg,             -- in_message_type                in     number,
                                            c.msg_mc_res_status_wechsel,       -- in_message_command             in     number,
                                            0,                                 -- in_data_type                   in     number,
                                            v_daten);                          -- in_data                        in     varchar2)
        end if;

    end if;
end tr_isi_resource_zust_akt_biud;
/

alter trigger dirkspzm32.tr_isi_resource_zust_akt_biud enable;


-- sqlcl_snapshot {"hash":"ddb42721cdfbda8cfd5c6bc9c53e0fbd971e37d5","type":"TRIGGER","name":"TR_ISI_RESOURCE_ZUST_AKT_BIUD","schemaName":"DIRKSPZM32","sxml":""}