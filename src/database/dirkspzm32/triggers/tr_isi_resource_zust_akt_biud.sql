
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_RESOURCE_ZUST_AKT_BIUD" 
  after  Insert  or  Update  or  Delete  on DIRKSPZM32.ISI_RESOURCE_ZUST_AKT
  for each row

declare
  v_resource                     isi_resource%rowtype;
  v_fa_auftrag                   bde_fa_auftrag%rowtype;
  v_res_status                   isi_res_status%rowtype;
  v_user                         isi_user%rowtype;

  v_daten                        varchar2(1024);
  v_msg_mc                       varchar2(50);

  v_mde_cfg                      mde_cfg%rowtype;

  CURSOR c_res_status is
    select *
      from isi_res_status t
     where t.sid = v_resource.sid
       and t.firma_nr = v_resource.firma_nr
       and t.res_id = :new.res_id
       and t.st_start = :new.status_seit
       and t.res_st_id = :new.status_id;

--       isi_resource_zust_akt

  CURSOR c_resource is
    select t.*
      from isi_resource t
     where t.res_id = :new.res_id;

  CURSOR c_mde is
    select t.*
      from mde_cfg t
     where t.res_id = :new.res_id;

  CURSOR c_fa_auftrag is
    select t.*
      from bde_fa_auftrag t
     where t.sid = v_resource.sid
       and t.firma_nr = v_resource.firma_nr
       and t.leitzahl = nvl(:new.leitzahl, :old.leitzahl)
       and t.fa_ag = nvl(:new.fa_ag, :old.fa_ag)
       and nvl(t.fa_upos, 0) = nvl(nvl(:new.fa_upos, :old.fa_upos), 0);

begin

  if updating
  then
    v_fa_auftrag := NULL;

    OPEN c_resource;
    FETCH c_resource into v_resource;
    CLOSE c_resource;

    -- -AG- Neue Funktion -> Status an den Host senden über S_BEW und DIS
    if isi_allg.get_firma_cfg_param(:new.sid,
                                    :new.firma_nr,
                                    v_resource.typ,           -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                    NULL,                     -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                    'RES_SEND_SATUS_HOST',    -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                    'DB',                     -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                    'CFG',                    -- in_typ                   in isi_firma_cfg.typ%type,
                                    'F',                      -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                    'BOOLEAN') = c.C_TRUE     -- in_default_param_typ
   then

      OPEN c_fa_auftrag;
      FETCH c_fa_auftrag into v_fa_auftrag;
      CLOSE c_fa_auftrag;

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

      if nvl(:new.leitzahl, 0) = nvl(:old.leitzahl, 0)
      and :new.akt_aufgabe = 'P'
      and :old.akt_aufgabe = 'R'
      then
        v_msg_mc := 'RE';
        -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
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
              v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
              v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
              v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
              NULL,                    -- LAM_AG          NUMBER
              NULL,                    -- BRUTTO_KG
              NULL,                    -- TEXT            VARCHAR2(40),
              NULL,                    -- ERR_NR          NUMBER
              NULL,                    -- USER_NAME       VARCHAR2(100),
              :new.res_id,             -- RES_ID          NUMBER
              NULL,                    -- SEND_ID         NUMBER
              :old.status_id,          -- MA_LAST_S_GRUND NUMBER
              :new.pers_nr,            -- PERS_NR         NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
        v_msg_mc := 'RF';
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
              0,                       -- MENGE           NUMBER(12,3),
              0,                       -- MENGE_B         NUMBER(12,3),
              0,                       -- SCHROTT         NUMBER(12,3),
              0,                       -- R_MENGE         NUMBER(12,3),
              0,                       -- R_MENGE_B       NUMBER(12,3),
              0,                       -- R_SCHROTT       NUMBER(12,3),
              0,                       -- STOERZEIT_IST   NUMBER,
              0,                       -- RUESTZEIT_IST   NUMBER,
              0,                       -- PRODZEIT_IST    NUMBER,
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
              v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
              v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
              v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
              NULL,                    -- LAM_AG          NUMBER
              NULL,                    -- BRUTTO_KG
              NULL,                    -- TEXT            VARCHAR2(40),
              NULL,                    -- ERR_NR          NUMBER
              NULL,                    -- USER_NAME       VARCHAR2(100),
              :new.res_id,             -- RES_ID          NUMBER
              NULL,                    -- SEND_ID         NUMBER
              :old.status_id,          -- MA_LAST_S_GRUND NUMBER
              :new.pers_nr,            -- PERS_NR         NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden

        v_msg_mc := 'PS';
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
              v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
              v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
              v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
              NULL,                    -- LAM_AG          NUMBER
              NULL,                    -- BRUTTO_KG
              NULL,                    -- TEXT            VARCHAR2(40),
              NULL,                    -- ERR_NR          NUMBER
              NULL,                    -- USER_NAME       VARCHAR2(100),
              :new.res_id,             -- RES_ID          NUMBER
              NULL,                    -- SEND_ID         NUMBER
              :old.status_id,          -- MA_LAST_S_GRUND NUMBER
              :new.pers_nr,            -- PERS_NR         NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
      end if;

      if nvl(:new.leitzahl, 0) != nvl(:old.leitzahl, 0)
      then

        if nvl(:new.leitzahl, 0) != 0
        then

          if :new.akt_aufgabe = 'R'
          then
            v_msg_mc := 'RS';
          else
            v_msg_mc := 'PS';
          end if;
        else
          if :old.akt_aufgabe = 'R'
          then
            v_msg_mc := 'RE';
          else
            v_msg_mc := 'PE';
          end if;
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
              v_fa_auftrag.leitzahl,   -- LEITZAHL        NUMBER,
              v_fa_auftrag.fa_ag,      -- FA_AG           NUMBER,
              v_fa_auftrag.fa_upos,    -- FA_UPOS         NUMBER
              NULL,                    -- LAM_AG          NUMBER
              NULL,                    -- BRUTTO_KG
              NULL,                    -- TEXT            VARCHAR2(40),
              NULL,                    -- ERR_NR          NUMBER
              NULL,                    -- USER_NAME       VARCHAR2(100),
              :new.res_id,             -- RES_ID          NUMBER
              NULL,                    -- SEND_ID         NUMBER
              :old.status_id,          -- MA_LAST_S_GRUND NUMBER
              :new.pers_nr,            -- PERS_NR         NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden

      end if;

      if :new.status_id != :old.status_id
      then
        v_msg_mc := 'SG';

        v_res_status := NULL;
        OPEN c_res_status;
        FETCH c_res_status into v_res_status;
        CLOSE c_res_status;

        if not isi_allg.get_user_by_login_id(:new.sid, v_res_status.ls_login_id, v_user)
        then
          v_user.pers_nr := NULL;
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
              v_user.pers_nr,          -- PERS_NR         NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
      end if;

      if nvl(:new.lte_id, 'keine') != :old.lte_id    -- Nur wenn eine Palette an der maschine gemeldet war
      then
        v_msg_mc := 'LTE';

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
              :old.lte_id,             -- LTE_NR          VARCHAR2(20),
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
              :new.pers_nr,            -- PERS_NR         NUMBER
              NULL,                    -- SPER_GRUND      VARCHAR2(30)
              NULL,                    -- LAGERPLATZ  N VARCHAR2(10)  Y     Lagerplatz im ISI
              NULL,                    -- ZLAGERPLATZ N VARCHAR2(10)  Y     Ziellagerplatz im ISI
              NULL,                    -- LABOR_STATUS  N CHAR(1) Y     Laborstatus Q=Quarantäne Q-Prüfung, G= Gesperrt, F=Frei, U=Undefiniert Prüfsystem war offline, W=Warenausgangsprüfung, S=Sonderprüfung
              NULL,                    -- LAM_SEL1  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL2  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL3  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL4  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL5  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL6  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL7  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL8  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL9  N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LAM_SEL10 N VARCHAR2(30)  Y     Parameter zusätzliche Selectionsparameter
              NULL,                    -- LTE_NAME  N VARCHAR2(15)  Y     Art, Name der Transporteinheit
              NULL,                    -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
              NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
              NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
      end if;
    end if;

    v_fa_auftrag := NULL;

    if v_resource.typ != 'MS'
    then
      return;
    end if;

    OPEN c_mde;
    FETCH c_mde into v_mde_cfg;
    CLOSE c_mde;

    if v_mde_cfg.res_id = :new.res_id
    then

      v_daten := '"' || c.C_MSG_MDE_MASCH_NAME || '=' || v_resource.res_ext_name || '", ';
      if nvl(:new.pers_nr, -1) != nvl(:old.pers_nr, -1)
      then
        if nvl(:new.pers_nr, 0) != 0
        and nvl(:old.pers_nr, 0) = 0
        then
          v_msg_mc := c.MSG_MC_MDE_SCHICHT_ANFANG;
        elsif nvl(:new.pers_nr, 0) = 0
        and nvl(:old.pers_nr, 0) != 0
        then
          v_msg_mc := c.MSG_MC_MDE_SCHICHT_ENDE;
        else
          v_msg_mc := c.MSG_MC_MDE_SCHICHT_WECHSEL;
        end if;
        isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                       NULL,                              -- in_sender_module_name          in     varchar2,
                                       NULL,                              -- in_sender_application_handle   in     varchar2,
                                       NULL,                              -- in_recipient_name              in     varchar2,
                                       'mde_server',                      -- in_recipient_module_name       in     varchar2,
                                       FALSE,                             -- in_response_required           in     boolean,
                                       c.MSG_MT_MDE_SERVER,               -- in_message_type                in     number,
                                       v_msg_mc,                          -- in_message_command             in     number,
                                       0,                                 -- in_data_type                   in     number,
                                       v_daten);                          -- in_data                        in     varchar2)
      end if;

      if nvl(:new.leitzahl, 0) != nvl(:old.leitzahl, 0)
      then

        if nvl(:new.leitzahl, 0) != 0
        then
          v_daten := v_daten || c.C_MSG_MDE_LEITZAHL || '=' || :new.leitzahl || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_AG || '=' || :new.fa_ag || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_UPOS || '=' || :new.fa_UPOS;

          OPEN c_fa_auftrag;
          FETCH c_fa_auftrag into v_fa_auftrag;
          CLOSE c_fa_auftrag;

          v_daten := v_daten || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_SOLL_MG || '=' || nvl(v_fa_auftrag.ag_soll_mg, 0) || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_SOLL_LHM_MG || '=' || nvl(v_fa_auftrag.lhm_menge, 0) || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG || '=' || nvl(v_fa_auftrag.mde_ist_mg, 0);

          if :new.akt_aufgabe = 'R'
          then
            v_msg_mc := c.MSG_MC_MDE_AUF_STAT_RUESTEN;
            v_daten := v_daten || ',';
            v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG_B || '=0,';
            v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG_S || '=' || nvl(v_fa_auftrag.mde_ist_mg_ruesten, 0);
          else
            v_daten := v_daten || ',';
            v_msg_mc := c.MSG_MC_MDE_AUF_STAT_PRODUKTION;
            v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG_B || '=' || nvl(v_fa_auftrag.mde_ist_mg_b, 0) || ',';
            v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG_S || '=' || nvl(v_fa_auftrag.mde_ist_mg_schrott, 0);
          end if;
        else
          v_daten := v_daten || c.C_MSG_MDE_LEITZAHL || '=0,';
          v_daten := v_daten || c.C_MSG_MDE_FA_AG || '=0,';
          v_daten := v_daten || c.C_MSG_MDE_FA_UPOS || '=0';

          v_daten := v_daten || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_SOLL_MG || '=0,';
          v_daten := v_daten || c.C_MSG_MDE_FA_SOLL_LHM_MG || '=0,';
          v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG || '=0';

          v_msg_mc := c.MSG_MC_MDE_AUF_STAT_RUESTEN;
          v_daten := v_daten || ',';
          v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG_B || '=0,';
          v_daten := v_daten || c.C_MSG_MDE_FA_IST_MG_S || '=0';

          if :old.akt_aufgabe = 'R'
          then
            v_msg_mc := c.MSG_MC_MDE_AUF_STAT_R_ENDE;
          else
            v_msg_mc := c.MSG_MC_MDE_AUF_STAT_P_ENDE;
          end if;
        end if;

        isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                       NULL,                              -- in_sender_module_name          in     varchar2,
                                       NULL,                              -- in_sender_application_handle   in     varchar2,
                                       NULL,                              -- in_recipient_name              in     varchar2,
                                       'mde_server',                      -- in_recipient_module_name       in     varchar2,
                                       FALSE,                             -- in_response_required           in     boolean,
                                       c.MSG_MT_MDE_SERVER,               -- in_message_type                in     number,
                                       v_msg_mc,                          -- in_message_command             in     number,
                                       0,                                 -- in_data_type                   in     number,
                                       v_daten);                          -- in_data                        in     varchar2)
      end if;

      if :new.status_id != :old.status_id
      then
        if :new.status_id < 0
        then
          v_daten := v_daten || c.C_MSG_MDE_RES_STATUS_ID || '=999';
        else
          v_daten := v_daten || c.C_MSG_MDE_RES_STATUS_ID || '=' || :new.status_id;
        end if;

        isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                       NULL,                              -- in_sender_module_name          in     varchar2,
                                       NULL,                              -- in_sender_application_handle   in     varchar2,
                                       NULL,                              -- in_recipient_name              in     varchar2,
                                       'mde_server',                      -- in_recipient_module_name       in     varchar2,
                                       FALSE,                             -- in_response_required           in     boolean,
                                       c.MSG_MT_MDE_SERVER,               -- in_message_type                in     number,
                                       c.MSG_MC_MDE_RES_STATUS_WECHSEL,   -- in_message_command             in     number,
                                       0,                                 -- in_data_type                   in     number,
                                       v_daten);                          -- in_data                        in     varchar2)

      end if;
      return;
    end if;

    v_daten := '"' || c.C_MSG_RES_RES_ID || '=' || v_resource.res_id || '", ';
    v_daten := v_daten || '"' || c.C_MSG_RES_MASCH_NAME || '=' || v_resource.res_ext_name || '", ';
    if nvl(:new.pers_nr, -1) != nvl(:old.pers_nr, -1)
    then
      if nvl(:new.pers_nr, 0) != 0
      and nvl(:old.pers_nr, 0) = 0
      then
        v_msg_mc := c.MSG_MC_RES_SCHICHT_ANFANG;
      elsif nvl(:new.pers_nr, 0) = 0
      and nvl(:old.pers_nr, 0) != 0
      then
        v_msg_mc := c.MSG_MC_RES_SCHICHT_ENDE;
      else
        v_msg_mc := c.MSG_MC_RES_SCHICHT_WECHSEL;
      end if;
      isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                     NULL,                              -- in_sender_module_name          in     varchar2,
                                     NULL,                              -- in_sender_application_handle   in     varchar2,
                                     NULL,                              -- in_recipient_name              in     varchar2,
                                     NULL,                              -- in_recipient_module_name       in     varchar2,
                                     FALSE,                             -- in_response_required           in     boolean,
                                     c.MSG_MT_RES_ZUST_CHG,             -- in_message_type                in     number,
                                     v_msg_mc,                          -- in_message_command             in     number,
                                     0,                                 -- in_data_type                   in     number,
                                     v_daten);                          -- in_data                        in     varchar2)
    end if;

    if :new.akt_aufgabe = 'G' -- Erstelle Auftrag
    then
      return;
    end if;

    if nvl(:new.leitzahl, 0) != nvl(:old.leitzahl, 0)
    then

      if nvl(:new.leitzahl, 0) != 0
      then
        v_daten := v_daten || c.C_MSG_RES_LEITZAHL || '=' || :new.leitzahl || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_AG || '=' || :new.fa_ag || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_UPOS || '=' || :new.fa_UPOS;

        OPEN c_fa_auftrag;
        FETCH c_fa_auftrag into v_fa_auftrag;
        CLOSE c_fa_auftrag;

        v_daten := v_daten || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_SOLL_MG || '=' || nvl(v_fa_auftrag.ag_soll_mg, 0) || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_SOLL_LHM_MG || '=' || nvl(v_fa_auftrag.lhm_menge, 0) || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_IST_MG || '=' || nvl(v_fa_auftrag.ag_ist_mg, 0);

        if :new.akt_aufgabe = 'R'
        then
          v_msg_mc := c.MSG_MC_RES_AUF_STAT_RUESTEN;
          v_daten := v_daten || ',';
          v_daten := v_daten || c.C_MSG_RES_FA_IST_MG_B || '=0,';
          v_daten := v_daten || c.C_MSG_RES_FA_IST_MG_S || '=' || nvl(v_fa_auftrag.ag_ist_mg_ruesten, 0);
        else
          v_daten := v_daten || ',';
          v_msg_mc := c.MSG_MC_RES_AUF_STAT_PRODUKTION;
          v_daten := v_daten || c.C_MSG_RES_FA_IST_MG_B || '=' || nvl(v_fa_auftrag.ag_ist_mg_b, 0) || ',';
          v_daten := v_daten || c.C_MSG_RES_FA_IST_MG_S || '=' || nvl(v_fa_auftrag.ag_ist_mg_schrott, 0);
        end if;
      else
        v_daten := v_daten || c.C_MSG_RES_LEITZAHL || '=0,';
        v_daten := v_daten || c.C_MSG_RES_FA_AG || '=0,';
        v_daten := v_daten || c.C_MSG_RES_FA_UPOS || '=0';

        v_daten := v_daten || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_SOLL_MG || '=0,';
        v_daten := v_daten || c.C_MSG_RES_FA_SOLL_LHM_MG || '=0,';
        v_daten := v_daten || c.C_MSG_RES_FA_IST_MG || '=0';

        v_msg_mc := c.MSG_MC_RES_AUF_STAT_RUESTEN;
        v_daten := v_daten || ',';
        v_daten := v_daten || c.C_MSG_RES_FA_IST_MG_B || '=0,';
        v_daten := v_daten || c.C_MSG_RES_FA_IST_MG_S || '=0';

        if :old.akt_aufgabe = 'R'
        then
          v_msg_mc := c.MSG_MC_RES_AUF_STAT_R_ENDE;
        else
          v_msg_mc := c.MSG_MC_RES_AUF_STAT_P_ENDE;
        end if;
      end if;

      isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                     NULL,                              -- in_sender_module_name          in     varchar2,
                                     NULL,                              -- in_sender_application_handle   in     varchar2,
                                     NULL,                              -- in_recipient_name              in     varchar2,
                                     NULL,                              -- in_recipient_module_name       in     varchar2,
                                     FALSE,                             -- in_response_required           in     boolean,
                                     c.MSG_MT_RES_ZUST_CHG,             -- in_message_type                in     number,
                                     v_msg_mc,                          -- in_message_command             in     number,
                                     0,                                 -- in_data_type                   in     number,
                                     v_daten);                          -- in_data                        in     varchar2)
    end if;
    if :new.auftrag_status != :old.auftrag_status
    and :new.auftrag_status = 'S' -- Auftrag gestoppt
    then
      v_daten := v_daten || c.C_MSG_MDE_LEITZAHL || '=' || :new.leitzahl || ',';
      v_daten := v_daten || c.C_MSG_MDE_FA_AG || '=' || :new.fa_ag || ',';
      v_daten := v_daten || c.C_MSG_MDE_FA_UPOS || '=' || :new.fa_UPOS;
      isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                     NULL,                              -- in_sender_module_name          in     varchar2,
                                     NULL,                              -- in_sender_application_handle   in     varchar2,
                                     NULL,                              -- in_recipient_name              in     varchar2,
                                     NULL,                              -- in_recipient_module_name       in     varchar2,
                                     FALSE,                             -- in_response_required           in     boolean,
                                     c.MSG_MT_RES_ZUST_CHG,             -- in_message_type                in     number,
                                     c.MSG_MC_RES_AUF_STAT_STOP,        -- in_message_command             in     number,
                                     0,                                 -- in_data_type                   in     number,
                                     v_daten);                          -- in_data                        in     varchar2)

    end if;
    if :new.status_id != :old.status_id
    then
      v_daten := v_daten || c.C_MSG_MDE_RES_STATUS_ID || '=' || :new.status_id;
      isi_message_board.send_message(NULL,                              -- in_sender_name                 in     varchar2,
                                     NULL,                              -- in_sender_module_name          in     varchar2,
                                     NULL,                              -- in_sender_application_handle   in     varchar2,
                                     NULL,                              -- in_recipient_name              in     varchar2,
                                     NULL,                              -- in_recipient_module_name       in     varchar2,
                                     FALSE,                             -- in_response_required           in     boolean,
                                     c.MSG_MT_RES_ZUST_CHG,             -- in_message_type                in     number,
                                     c.MSG_MC_RES_STATUS_WECHSEL,       -- in_message_command             in     number,
                                     0,                                 -- in_data_type                   in     number,
                                     v_daten);                          -- in_data                        in     varchar2)

    end if;
  end if;


end TR_ISI_RESOURCE_ZUST_AKT_BIUD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_RESOURCE_ZUST_AKT_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"bbfd778a41795cc563e1c2980aa809487893ed92","type":"TRIGGER","name":"TR_ISI_RESOURCE_ZUST_AKT_BIUD","schemaName":"DIRKSPZM32","sxml":""}