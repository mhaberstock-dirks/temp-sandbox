create or replace editionable trigger dirkspzm32.tr_isi_order_pos_bd before
    delete on dirkspzm32.isi_order_pos
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr     number;
    v_err_text   varchar2(255);
    v_result     number;
    v_lam_lte_id lvs_lam.lte_id%type;
    cursor c_lam is
    select
        t.lte_id
    from
        lvs_lam t
    where
        t.order_pos_auf_id = :old.auf_id
    group by
        t.lte_id;

begin
    delete isi_komm_order t
    where
        t.auf_id = :old.auf_id;

    open c_lam;
    fetch c_lam into v_lam_lte_id;
    loop
        exit when c_lam%notfound;
        v_result := lvs_ausl.lvs_lte_res_rueck(:old.sid,
                                               :old.firma_nr,
                                               :old.vorgang_id,
                                               :old.auf_id,
                                               v_lam_lte_id,
                                               :old.vorgang_id,
                                               null,
                                               c.c_true);

        fetch c_lam into v_lam_lte_id;
    end loop;

    close c_lam;
    if :old.besteller = 'HOST' then
    -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
        insert into s_send_bew s values ( null,               -- BEW_ID          NUMBER not null,
                                          :old.firma_nr,      -- FIRMA_NR        NUMBER(3),
                                          'ISI',              -- HERKUNFT        VARCHAR2(3),
                                          'S_AUF',            -- TABELLE         VARCHAR2(5),
                                          :old.auf_id_extern, -- AUF_ID          NUMBER,
                                          'UE',               -- STATUS          VARCHAR2(3), -- Sofort uebernehmen
                                          'L',                -- AKTION          VARCHAR2(3),
                                          null,               -- MA_STATUS       VARCHAR2(1),
                                          null,               -- MA_S_GRUND      NUMBER(3),
                                          null,               -- MA_ID           VARCHAR2(10),
                                          null,               -- LTE_NR          VARCHAR2(20),
                                          null,               -- LHM_NR          VARCHAR2(20),
                                          null,               -- LAGERORT        VARCHAR2(10),
                                          null,               -- ZLAGERORT       VARCHAR2(10),
                                          null,               -- MENGE           NUMBER(12,3),
                                          null,               -- MENGE_B         NUMBER(12,3),
                                          null,               -- SCHROTT         NUMBER(12,3),
                                          null,               -- R_MENGE         NUMBER(12,3),
                                          null,               -- R_MENGE_B       NUMBER(12,3),
                                          null,               -- R_SCHROTT       NUMBER(12,3),
                                          null,               -- STOERZEIT_IST   NUMBER,
                                          null,               -- RUESTZEIT_IST   NUMBER,
                                          null,               -- PRODZEIT_IST    NUMBER,
                                          null,               -- EXT_LIEF_NR     VARCHAR2(15),
                                          null,               -- EXT_LIEF_POS    VARCHAR2(5),
                                          null,               -- CHARGE          VARCHAR2(20),
                                          null,               -- SERIE           VARCHAR2(20),
                                          null,               -- ARBEITSPLATZ_ID VARCHAR2(20),
                                          null,               -- IST_BESTAND     NUMBER,
                                          null,               -- ARTIKEL         VARCHAR2(20),
                                          null,               -- B_DATUM         DATE,
                                          null,               -- LAM_ID          NUMBER,
                                          null,               -- LAM_BH_ID       NUMBER,
                                          null,               -- LAM_BH_TYP      VARCHAR2(2),
                                          null,               -- LEITZAHL        NUMBER,
                                          null,               -- FA_AG           NUMBER,
                                          null,               -- FA_UPOS         NUMBER,
                                          null,               -- LAM_AG          NUMBER,
                                          null,               -- BRUTTO_KG       NUMBER,
                                          null,               -- TEXT            VARCHAR2(250),
                                          null,               -- ERR_NR          NUMBER
                                          null,               -- USER_NAME       VARCHAR2(100),
                                          null,               -- RES_ID          NUMBER
                                          null,               -- SEND_ID         NUMBER
                                          null,               -- MA_LAST_S_GRUND NUMBER
                                          null,               -- PERS_NR          NUMBER
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
                                          :old.auf_id,             -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                          null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                          null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
    end if;

exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
        v_err_text := v_err_text
                      || chr(13)
                      || chr(10)
                      || dbms_utility.format_error_backtrace;

        raise_application_error(-20000 - v_err_nr, v_err_text, true);
        raise;
    when others then
        if v_err_nr is not null then
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
        else
            v_err_text := dbms_utility.format_error_backtrace;
            if v_err_text not like 'ORA-%ORA-%' then
                v_err_text := lc.ec(lc.o_txt_db_error)
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000, v_err_text, true);
            end if;

            raise;
        end if;
end tr_isi_order_pos_bd;
/

alter trigger dirkspzm32.tr_isi_order_pos_bd enable;


-- sqlcl_snapshot {"hash":"d4504adc8f8057ebfa86e3fdeed9e9402f60daa7","type":"TRIGGER","name":"TR_ISI_ORDER_POS_BD","schemaName":"DIRKSPZM32","sxml":""}