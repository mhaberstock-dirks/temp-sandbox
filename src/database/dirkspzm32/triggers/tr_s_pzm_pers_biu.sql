create or replace editionable trigger dirkspzm32.tr_s_pzm_pers_biu before
    insert or update on dirkspzm32.s_pzm_pers
    for each row
declare
  -- local variables here
    v_found              boolean;
    v_vertragsarten      pzm_vertragsarten%rowtype;
    v_pers_nr            pzm_personal.pers_nr%type;
    v_urlaub_anspr_aa_id pzm_personal.pers_urlaub_anspr_aa_id%type;
    v_urlaub_anspr_wert  pzm_personal.pers_urlaub_anspr_wert%type;
    cursor c_pzm_vertragsarten is
    select
        *
    from
        pzm_vertragsarten t
    where
        t.va_id = :new.vertragsart;

    cursor c_pzm_personal is
    select
        t.pers_nr
    from
        pzm_personal t
    where
        t.pers_nr = :new.pers_nr;

    cursor c_isi_user is
    select
        t.pers_nr
    from
        isi_user t
    where
        t.pers_nr = :new.pers_nr;

begin
    if :new.vertragsart is not null then
        open c_pzm_vertragsarten;
        fetch c_pzm_vertragsarten into v_vertragsarten;
        v_found := c_pzm_vertragsarten%found;
        close c_pzm_vertragsarten;
        if not v_found then
            insert into pzm_vertragsarten values ( :new.vertragsart,      --  VA_ID     NUMBER(3),
                                                   :new.vertragsart_tx,   --  VA_NAME  VARCHAR2(50),
                                                   null,                  --  VA_BEMERKUNG    VARCHAR2(255),
                                                   null,                  --  VA_RESET_MONATS_ENDE scheinbar zuvor VA_ZEITARBEITNEHMER NUMBER(1)
                                                   'F',                   --  VA_ Stundenabrechnung ist F = Gehalt
                                                   'F',                    -- VA_BIS_MONAT_ENDE_SIM	N	VARCHAR2(1)	N	'F'		N	N		Diese Arbeiter werden im vorraus abgerechnet und der Restmonat wird simuliert
                                                   null,                   -- VA_BIS_STD_AUSZAHLEN  N NUMBER(3,2) Y     N N   Bis zu dieser Grenze weden die Stunden ausgezahlt ohne Überstundenprozente
                                                   null );                  -- VA_BIS_STD_AUSZAHLEN_ZEITEINHEIT  N VARCHAR2(2) Y     N N   DD = Tag, WW = Woche, MM = Monat - Bis zu diser Einheit weden die Anzahl Stunden in va_bis_std_auszahlen ausgezahlt. z.B. 40 Stunden je Woche
        else
            update pzm_vertragsarten t
            set
                t.va_name = decode(:new.vertragsart_tx,
                                   null,
                                   t.va_name,
                                   :new.vertragsart_tx)   --  VA_BEMERKUNG  VARCHAR2(20),
            where
                    t.va_id = :new.vertragsart                --  VERTRAGSART     NUMBER(3),
                and nvl(t.va_name, 'fehlt') != :new.vertragsart_tx;           --  VERTRAGSART_TX  VARCHAR2(20),
        end if;

    end if;

    open c_pzm_personal;
    fetch c_pzm_personal into v_pers_nr;
    v_found := c_pzm_personal%found;
    close c_pzm_personal;
    v_urlaub_anspr_wert := null;
    v_urlaub_anspr_aa_id := null;
    if :new.urlaubstage is not null then
        v_urlaub_anspr_wert := :new.urlaubstage;
        v_urlaub_anspr_aa_id := 1; -- aa_id = 1 = Tarifurlaub (in Tagen)
    end if;

    if not v_found then
        insert into pzm_personal (
            pers_nr,
            pers_anrede,
            pers_nname,
            pers_vname,
            pers_land,
            pers_region_code,
            pers_pb_id,
            pers_abt_id,
            pers_kst_id,
            pers_taetigkeit,
            pers_vertragsart,
            pers_eintrittsdatum,
            pers_austrittdatum,
            pers_sm_name,
            pers_sm_beginn,
            pers_befristet_bis,
            pers_ustd_freistd,
            pers_max_freistd,
            pers_zk_von1_freistd,
            pers_zk_bis1_freistd,
            pers_zk_von2_freistd,
            pers_zk_bis2_freistd,
            pers_kennz_zeiterf,
            pers_schnittstelle,
            pers_personalteilber,
            pers_kappung_me_ab_flx_std,
            pers_kappung_te_ab_flx_std,
            pers_kappung_schicht_ende,
            pers_urlaub_anspr_wert,
            pers_urlaub_anspr_aa_id,
            pers_sm_beginn_woche,
            pers_verfall_vorjahr,
            pers_startdatum
        ) values ( :new.pers_nr,          --  PERS_NR         NUMBER,
                   :new.anrede,           --  ANREDE          VARCHAR2(20),
                   :new.nname,            --  NNAME           VARCHAR2(255),
                   :new.vname,
                   null,                  -- Land
                   null,                  -- Region,
                   null,                  --  Produktionsbereich - Wird in default von der Abteilung uebernommen
                   null,                  --  PD_ABT_ID       Abteilungs ID
                   null,                  --  Kostenstelle Default aus der Abteilung
                   :new.taetigkeit,       --  TAETIGKEIT      VARCHAR2(100),
                   :new.vertragsart,      --  VERTRAGSART     NUMBER(3),
                   :new.eintrittsdatum,   --  EINTRITTSDATUM  DATE,
                   :new.austrittdatum,    --  AUSTRITTDATUM   DATE,
                   :new.sm_name,          --  SM_NAME         VARCHAR2(100),
                   :new.sm_beginn,        --  SM_BEGINN       DATE,
                   :new.befristet_bis,    --  BEFRISTET_BIS   DATE,
                   nvl(:new.ustd_freistd,
                       'AZ'),             --  USTD_FREISTD    VARCHAR2(10) default 'AZ',
                   :new.max_freistd,      --  MAX_FREISTD     NUMBER default 20,
                   :new.zk_von1_freistd,  --  ZK_VON1_FREISTD NUMBER,
                   :new.zk_bis1_freistd,  --  ZK_BIS1_FREISTD NUMBER,
                   :new.zk_von2_freistd,  --  ZK_VON2_FREISTD NUMBER,
                   :new.zk_bis2_freistd,  --  ZK_BIS2_FREISTD NUMBER
                   nvl(:new.kennz_zeiterf,
                       1),                --  KENNZ_ZEITERF   NUMBER(1),
                   :new.schnittstelle,    --  SCHNITTSTELLE   NUMBER(1),
                   :new.personalteilber,  --  PERSONALTEILBER VARCHAR2(15),
                   null,
                   null,
                   'F',
                   v_urlaub_anspr_wert,
                   v_urlaub_anspr_aa_id,
                   null,                   -- pd_sm_beginn_woche     NUMBER
                   to_date('31.03.' || to_char(sysdate, 'yyyy'),
                           'dd.mm.yyyy'), -- PD_VERFALL_VORJAHR    DATE,
                   null                    -- Region_code
                    );

    else
        update pzm_personal t
        set
            t.pers_anrede = decode(:new.anrede,
                                   null,
                                   t.pers_anrede,
                                   :new.anrede),           --  ANREDE          VARCHAR2(20),
            t.pers_nname = decode(:new.nname,
                                  null,
                                  t.pers_nname,
                                  :new.nname),            --  NNAME           VARCHAR2(255),
            t.pers_vname = decode(:new.vname,
                                  null,
                                  t.pers_vname,
                                  :new.vname),     --  VNAME           VARCHAR2(255),
            t.pers_taetigkeit = decode(:new.taetigkeit,
                                       null,
                                       t.pers_taetigkeit,
                                       :new.taetigkeit),          --  TAETIGKEIT      VARCHAR2(100),
            t.pers_vertragsart = decode(:new.vertragsart,
                                        null,
                                        t.pers_vertragsart,
                                        :new.vertragsart),        --  VERTRAGSART     NUMBER(3),
            t.pers_eintrittsdatum = decode(:new.eintrittsdatum,
                                           null,
                                           t.pers_eintrittsdatum,
                                           :new.eintrittsdatum),  --  EINTRITTSDATUM  DATE,
            t.pers_austrittdatum = decode(:new.austrittdatum,
                                          null,
                                          t.pers_austrittdatum,
                                          :new.austrittdatum),    --  AUSTRITTDATUM   DATE,
            t.pers_sm_name = decode(:new.sm_name,
                                    null,
                                    t.pers_sm_name,
                                    :new.sm_name),                --  SM_NAME         VARCHAR2(100),
            t.pers_sm_beginn = decode(:new.sm_beginn,
                                      null,
                                      t.pers_sm_beginn,
                                      :new.sm_beginn),            --  SM_BEGINN       DATE,
            t.pers_befristet_bis = decode(:new.befristet_bis,
                                          null,
                                          t.pers_befristet_bis,
                                          :new.befristet_bis),    --  BEFRISTET_BIS   DATE,
            t.pers_ustd_freistd = decode(:new.ustd_freistd,
                                         null,
                                         t.pers_ustd_freistd,
                                         :new.ustd_freistd),      --  USTD_FREISTD    VARCHAR2(10) default 'AZ',
            t.pers_max_freistd = decode(:new.max_freistd,
                                        null,
                                        t.pers_max_freistd,
                                        :new.max_freistd),        --  MAX_FREISTD     NUMBER default 20,
            t.pers_zk_von1_freistd = decode(:new.zk_von1_freistd,
                                            null,
                                            t.pers_zk_von1_freistd,
                                            :new.zk_von1_freistd), --  ZK_VON1_FREISTD NUMBER,
            t.pers_zk_bis1_freistd = decode(:new.zk_bis1_freistd,
                                            null,
                                            t.pers_zk_bis1_freistd,
                                            :new.zk_bis1_freistd), --  ZK_BIS1_FREISTD NUMBER,
            t.pers_zk_von2_freistd = decode(:new.zk_von2_freistd,
                                            null,
                                            t.pers_zk_von2_freistd,
                                            :new.zk_von2_freistd), --  ZK_VON2_FREISTD NUMBER,
            t.pers_zk_bis2_freistd = decode(:new.zk_bis2_freistd,
                                            null,
                                            t.pers_zk_bis2_freistd,
                                            :new.zk_bis2_freistd), --  ZK_BIS2_FREISTD NUMBER,
            t.pers_kennz_zeiterf = decode(:new.kennz_zeiterf,
                                          null,
                                          t.pers_kennz_zeiterf,
                                          :new.kennz_zeiterf),     --  KENNZ_ZEITERF   NUMBER(1),
            t.pers_schnittstelle = decode(:new.schnittstelle,
                                          null,
                                          t.pers_schnittstelle,
                                          :new.schnittstelle),     --  SCHNITTSTELLE   NUMBER(1),
            t.pers_personalteilber = decode(:new.personalteilber,
                                            null,
                                            t.pers_personalteilber,
                                            :new.personalteilber),  --  PERSONALTEILBER VARCHAR2(15),
            t.pers_urlaub_anspr_wert = decode(v_urlaub_anspr_wert, null, t.pers_urlaub_anspr_wert, v_urlaub_anspr_wert),  --  urlaub_anspr_wert number,
            t.pers_urlaub_anspr_aa_id = decode(v_urlaub_anspr_aa_id, null, t.pers_urlaub_anspr_aa_id, v_urlaub_anspr_aa_id)   --  urlaub_anspr_wert number,
        where
            t.pers_nr = :new.pers_nr;          --  PERS_NR         NUMBER,
    end if;

    open c_isi_user;
    fetch c_isi_user into v_pers_nr;
    v_found := c_isi_user%found;
    close c_isi_user;
    if not v_found then
        insert into isi_user values ( null,                  --  sid             varchar2(2),
                                      :new.firma_nr,         --  firma_nr        number(2) not null,
                                      null,                  --  login_id        number not null,
                                      :new.username,         --  username        varchar2(50),
                                      :new.passwort,         --  passwort        varchar2(20),
                                      :new.pers_nr,          --  pers_nr         number,
                                      null,                  --  transponder     varchar2(255),
                                      :new.anrede,           --  anrede          varchar2(20),
                                      :new.nname,            --  nname           varchar2(255),
                                      :new.vname,            --  vname           varchar2(255),
                                      :new.anschrift,        --  anschrift       varchar2(255),
                                      :new.plz,              --  plz             number(5),
                                      :new.wohnort,          --  wohnort         varchar2(255),
                                      :new.telefon_nr,       --  telefon_nr      varchar2(50),
                                      :new.kuerzel,          --  kuerzel         varchar2(5),
                                      1,                     --  sprache         number default 1,
                                      null,                  --  security_level  number,
                                      null,                  --  adress_id       number,
                                      null,                  --  email           varchar2(255),
                                      null );                 --  fax             varchar2(50)
    else
        update isi_user t
        set
            t.firma_nr = decode(:new.firma_nr,
                                null,
                                t.firma_nr,
                                :new.firma_nr),         --  FIRMA_NR        NUMBER(2) not null,
            t.username = decode(:new.username,
                                null,
                                t.username,
                                :new.username),         --  USERNAME        VARCHAR2(50),
            t.passwort = decode(:new.passwort,
                                null,
                                t.passwort,
                                :new.passwort),         --  PASSWORT        VARCHAR2(20),
            t.anrede = decode(:new.anrede,
                              null,
                              t.anrede,
                              :new.anrede),           --  ANREDE          VARCHAR2(20),
            t.nachname = decode(:new.nname,
                                null,
                                t.nachname,
                                :new.nname),            --  NNAME           VARCHAR2(255),
            t.vorname = decode(:new.vname,
                               null,
                               t.vorname,
                               :new.vname),            --  VNAME           VARCHAR2(255),
            t.anschrift = decode(:new.anschrift,
                                 null,
                                 t.anschrift,
                                 :new.anschrift),        --  ANSCHRIFT       VARCHAR2(255),
            t.plz = decode(:new.plz,
                           null,
                           t.plz,
                           :new.plz),              --  PLZ             NUMBER(5),
            t.wohnort = decode(:new.wohnort,
                               null,
                               t.wohnort,
                               :new.wohnort),          --  WOHNORT         VARCHAR2(255),
            t.telefon_nr = decode(:new.telefon_nr,
                                  null,
                                  t.telefon_nr,
                                  :new.telefon_nr),       --  TELEFON_NR      VARCHAR2(50),
            t.kuerzel = decode(:new.kuerzel,
                               null,
                               t.kuerzel,
                               :new.kuerzel)           --  KUERZEL         VARCHAR2(5),
        where
            t.pers_nr = :new.pers_nr;                 --  PERS_NR         NUMBER,
    end if;

end tr_s_pzm_pers_biu;
/

alter trigger dirkspzm32.tr_s_pzm_pers_biu enable;


-- sqlcl_snapshot {"hash":"36b91080cbdc981465be8b85f0a3a609f7b75481","type":"TRIGGER","name":"TR_S_PZM_PERS_BIU","schemaName":"DIRKSPZM32","sxml":""}