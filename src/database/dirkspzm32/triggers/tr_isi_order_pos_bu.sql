create or replace editionable trigger dirkspzm32.tr_isi_order_pos_bu before
    update on dirkspzm32.isi_order_pos
    for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
    v_error exception;
    v_err_nr        number;
    v_err_text      varchar2(255);

  -- local variables here
    v_art           isi_artikel%rowtype;
    v_found         boolean;
    v_anz_lam_res   number;                         -- Anzahl der noch rreservierten LAM's für diese AUF_ID

    v_status_new    s_rcv_auftr.status%type;
    v_status_old    s_rcv_auftr.status%type;
    v_lvs_info_new  s_rcv_auftr.lvs_info%type;
    v_lvs_info_old  s_rcv_auftr.lvs_info%type;
    v_ist_menge_new s_rcv_auftr.ist_menge%type;
    v_ist_menge_old s_rcv_auftr.ist_menge%type;
    v_status        s_rcv_auftr.status%type;
    v_bew_id        s_send_bew.bew_id%type;
    cursor c_art is
    select
        *
    from
        isi_artikel art
    where
            art.sid = :new.sid
        and art.artikel_id = :new.artikel_id;

    cursor c_lam is
    select
        count(lam.lte_id)
    from
        lvs_lam lam
    where
            lam.sid = :new.sid
        and lam.order_pos_auf_id = :new.auf_id
    group by
        lam.lte_id;

    cursor c_s_send_bew is
    select
        t.bew_id
    from
        s_send_bew t
    where
        t.auf_id = :new.auf_id_extern;

begin
    open c_art;                         -- Artikeldaten lesen
    fetch c_art into v_art;
    v_found := c_art%found;             -- Artikeldaten gefunden ?
    close c_art;
    if not v_found then
        v_err_nr := 10;
        v_err_text := 'Fehler: Artikeldaten fehlen für Artikel ID '
                      || :new.artikel_id
                      || ' Auf ID '
                      || :new.auf_id;

        raise v_error;
    end if;

    if :new.mengeneinheit != v_art.mengeneinheit_basis then
        :new.mengeneinheit := v_art.mengeneinheit_basis;
    end if;

    if :new.menge_basis != v_art.menge_basis then
        :new.menge_basis := v_art.menge_basis;
    end if;

    if :new.status = 'F' then
        :new.status := 'E';
        return;
    end if;

    if
        :old.status = 'N'
        and :new.status = 'D'
    then
        update isi_order_kopf kopf
        set
            kopf.status = 'D'
        where
                kopf.sid = :new.sid
            and kopf.firma_nr = :new.firma_nr
            and kopf.vorgang_typ = 'WAE'
            and kopf.vorgang_id = :new.vorgang_id
            and kopf.satzart = 'LI'
            and kopf.status = 'N';

    end if;

    if :new.besteller = 'HOST'
    or :new.besteller = 'WAWI' then
        v_status_new := :new.status;
        v_status_old := :old.status;
        v_lvs_info_new := :new.lvs_info;
        v_lvs_info_old := :old.lvs_info;
        v_ist_menge_new := :new.ist_menge;
        v_ist_menge_old := :old.ist_menge;

    /*
    if (nvl(v_status_new, 'NULL') = nvl(v_status_old, 'NULL')
        or v_status_new = 'L'
        or v_status_old = 'L'
       )
       and :new.satzart = 'MA'
    */
        if :new.satzart = 'MA' then
            return;
        end if;
        if nvl(v_status_new, 'NULL') != nvl(v_status_old, 'NULL')
        or nvl(v_ist_menge_new, 0) != nvl(v_ist_menge_old, 0)
        or nvl(v_lvs_info_new, 'NULL') != nvl(v_lvs_info_old, 'NULL') then
      -- L ist in isiorder ein LOCK und vom HOST bedeutet es Loeschen
            if :new.status = 'L' then
                return;
            end if;
            if
                ( :old.status is null  -- War neu
                  or :old.status = 'N' )
                and :new.status != 'N'  -- Ist nicht mehr neu und nicht NULL
                and :new.status not in ( 'E', 'X', 'x', 'Z', 'L' ) -- STATUS in ('N', 'E', 'V', 'F',  'X', 'Z', 'L', 'R', 'D', 'T','x')
            then
                if :old.besteller = 'HOST'
                or :old.besteller = 'WAWI' then
                    open c_s_send_bew;
                    fetch c_s_send_bew into v_bew_id;
                    v_found := c_s_send_bew%found;
                    close c_s_send_bew;
                    if not v_found then
            -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
                        insert into s_send_bew s values ( null,               -- BEW_ID          NUMBER not null,
                                                          :new.firma_nr,      -- FIRMA_NR        NUMBER(3),
                                                          'ISI',              -- HERKUNFT        VARCHAR2(3),
                                                          'S_AUF',            -- TABELLE         VARCHAR2(5),
                                                          :new.auf_id_extern, -- AUF_ID          NUMBER,
                                                          'UE',               -- STATUS          VARCHAR2(3), -- Sofort uebernehmen
                                                          'AA',               -- AKTION          VARCHAR2(3),
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
                                                          :new.li_nr,         -- EXT_LIEF_NR     VARCHAR2(15),
                                                          :new.li_pos_nr,     -- EXT_LIEF_POS    VARCHAR2(5),
                                                          null,               -- CHARGE          VARCHAR2(20),
                                                          null,               -- SERIE           VARCHAR2(20),
                                                          null,               -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                          null,               -- IST_BESTAND     NUMBER,
                                                          v_art.artikel,      -- ARTIKEL         VARCHAR2(20),
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
                                                          :new.auf_id,             -- ORDER_POS_AUF_ID  N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                          null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                          null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                    end if;

                end if;

            end if;

      /*
      -AG- DIAF ist abgeschlatet. Rueckmeldungen nur noch eber s_send_bew
      update s_rcv_auftr auft
         set auft.status = v_status_new,
             auft.ist_menge = :new.ist_menge,
             auft.lvs_info = :new.lvs_info
       where auft.auf_id = :new.auf_id_extern;
       */
        end if;

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
end tr_isi_order_pos_bu;
/

alter trigger dirkspzm32.tr_isi_order_pos_bu enable;


-- sqlcl_snapshot {"hash":"d329bb55d9f189635756c01a312051f92a80b649","type":"TRIGGER","name":"TR_ISI_ORDER_POS_BU","schemaName":"DIRKSPZM32","sxml":""}