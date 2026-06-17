
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_POS_BD" 
  before delete on DIRKSPZM32.isi_order_pos
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);
  v_result    number;

  v_lam_lte_id       lvs_lam.lte_id%type;

   CURSOR c_lam is
     select t.lte_id from lvs_lam t
      where t.order_pos_auf_id = :old.auf_id
      group by t.lte_id;

begin
  delete isi_komm_order t
    where t.auf_id = :old.auf_id;

  OPEN c_lam;
  FETCH c_lam into v_lam_lte_id;
  LOOP
    EXIT when c_lam%NOTFOUND;
    v_result := lvs_ausl.lvs_lte_res_rueck (:old.sid,
                                            :old.firma_nr,
                                            :old.vorgang_id,
                                            :old.auf_id,
                                            v_lam_lte_id,
                                            :old.vorgang_id,
                                            NULL,
                                            c.c_true);


    FETCH c_lam into v_lam_lte_id;
  end LOOP;
  CLOSE c_lam;

  if :old.besteller = 'HOST'
  then
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
    insert into s_send_bew s
       values  (NULL,               -- BEW_ID          NUMBER not null,
                :old.firma_nr,      -- FIRMA_NR        NUMBER(3),
                'ISI',              -- HERKUNFT        VARCHAR2(3),
                'S_AUF',            -- TABELLE         VARCHAR2(5),
                :old.auf_id_extern, -- AUF_ID          NUMBER,
                'UE',               -- STATUS          VARCHAR2(3), -- Sofort uebernehmen
                'L',                -- AKTION          VARCHAR2(3),
                NULL,               -- MA_STATUS       VARCHAR2(1),
                NULL,               -- MA_S_GRUND      NUMBER(3),
                NULL,               -- MA_ID           VARCHAR2(10),
                NULL,               -- LTE_NR          VARCHAR2(20),
                NULL,               -- LHM_NR          VARCHAR2(20),
                NULL,               -- LAGERORT        VARCHAR2(10),
                NULL,               -- ZLAGERORT       VARCHAR2(10),
                NULL,               -- MENGE           NUMBER(12,3),
                NULL,               -- MENGE_B         NUMBER(12,3),
                NULL,               -- SCHROTT         NUMBER(12,3),
                NULL,               -- R_MENGE         NUMBER(12,3),
                NULL,               -- R_MENGE_B       NUMBER(12,3),
                NULL,               -- R_SCHROTT       NUMBER(12,3),
                NULL,               -- STOERZEIT_IST   NUMBER,
                NULL,               -- RUESTZEIT_IST   NUMBER,
                NULL,               -- PRODZEIT_IST    NUMBER,
                NULL,               -- EXT_LIEF_NR     VARCHAR2(15),
                NULL,               -- EXT_LIEF_POS    VARCHAR2(5),
                NULL,               -- CHARGE          VARCHAR2(20),
                NULL,               -- SERIE           VARCHAR2(20),
                NULL,               -- ARBEITSPLATZ_ID VARCHAR2(20),
                NULL,               -- IST_BESTAND     NUMBER,
                NULL,               -- ARTIKEL         VARCHAR2(20),
                NULL,               -- B_DATUM         DATE,
                NULL,               -- LAM_ID          NUMBER,
                NULL,               -- LAM_BH_ID       NUMBER,
                NULL,               -- LAM_BH_TYP      VARCHAR2(2),
                NULL,               -- LEITZAHL        NUMBER,
                NULL,               -- FA_AG           NUMBER,
                NULL,               -- FA_UPOS         NUMBER,
                NULL,               -- LAM_AG          NUMBER,
                NULL,               -- BRUTTO_KG       NUMBER,
                NULL,               -- TEXT            VARCHAR2(250),
                NULL,               -- ERR_NR          NUMBER
                NULL,               -- USER_NAME       VARCHAR2(100),
                NULL,               -- RES_ID          NUMBER
                NULL,               -- SEND_ID         NUMBER
                NULL,               -- MA_LAST_S_GRUND NUMBER
                NULL,               -- PERS_NR          NUMBER
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
                :old.auf_id,             -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                NULL,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                NULL);                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
  end if;
exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace;
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
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
end TR_ISI_ORDER_POS_BD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_POS_BD" ENABLE;


-- sqlcl_snapshot {"hash":"f66bcf87ff1c2f9db31a25a26027222fa01f6cd9","type":"TRIGGER","name":"TR_ISI_ORDER_POS_BD","schemaName":"DIRKSPZM32","sxml":""}