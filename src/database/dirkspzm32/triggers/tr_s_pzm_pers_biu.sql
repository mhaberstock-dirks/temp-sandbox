
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_PZM_PERS_BIU" 
  before insert or update on DIRKSPZM32.s_pzm_pers
  for each row
declare
  -- local variables here
  v_found                               boolean;

  v_vertragsarten                       pzm_vertragsarten%rowtype;
  v_pers_nr                             pzm_personal.pers_nr%type;
  v_urlaub_anspr_aa_id                  pzm_personal.pers_urlaub_anspr_aa_id%type;
  v_urlaub_anspr_wert                   pzm_personal.pers_urlaub_anspr_wert%type;

  CURSOR c_pzm_vertragsarten is
    select *
      from pzm_vertragsarten t
     where t.va_id = :new.VERTRAGSART;

  CURSOR c_pzm_personal is
    select t.pers_nr
      from pzm_personal t
     where t.pers_nr = :new.PERS_NR;

  CURSOR c_isi_user is
    select t.pers_nr
      from isi_user t
     where t.pers_nr = :new.PERS_NR;
begin
  if :new.vertragsart is not NULL
  then
    OPEN c_pzm_vertragsarten;
    FETCH c_pzm_vertragsarten into v_vertragsarten;
    v_found := c_pzm_vertragsarten%FOUND;
    CLOSE c_pzm_vertragsarten;

    if not v_found
    then
      insert into pzm_vertragsarten
        values (
            :new.VERTRAGSART,      --  VA_ID     NUMBER(3),
            :new.VERTRAGSART_TX,   --  VA_NAME  VARCHAR2(50),
            NULL,                  --  VA_BEMERKUNG    VARCHAR2(255),
            NULL,                  --  VA_RESET_MONATS_ENDE scheinbar zuvor VA_ZEITARBEITNEHMER NUMBER(1)
            'F',                   --  VA_ Stundenabrechnung ist F = Gehalt
            'F',                    -- VA_BIS_MONAT_ENDE_SIM	N	VARCHAR2(1)	N	'F'		N	N		Diese Arbeiter werden im vorraus abgerechnet und der Restmonat wird simuliert
            NULL,                   -- VA_BIS_STD_AUSZAHLEN  N NUMBER(3,2) Y     N N   Bis zu dieser Grenze weden die Stunden ausgezahlt ohne Überstundenprozente
            NULL);                  -- VA_BIS_STD_AUSZAHLEN_ZEITEINHEIT  N VARCHAR2(2) Y     N N   DD = Tag, WW = Woche, MM = Monat - Bis zu diser Einheit weden die Anzahl Stunden in va_bis_std_auszahlen ausgezahlt. z.B. 40 Stunden je Woche
            
            
    else
      update pzm_vertragsarten t
         set t.va_name = decode(:new.VERTRAGSART_TX,
                                NULL,
                                t.va_name,
                                :new.VERTRAGSART_TX)   --  VA_BEMERKUNG  VARCHAR2(20),
       where t.va_id = :new.VERTRAGSART                --  VERTRAGSART     NUMBER(3),
         and nvl(t.va_name, 'fehlt')
                     != :new.VERTRAGSART_TX;           --  VERTRAGSART_TX  VARCHAR2(20),
    end if;
  end if;


  OPEN c_pzm_personal;
  FETCH c_pzm_personal into v_pers_nr;
  v_found := c_pzm_personal%FOUND;
  CLOSE c_pzm_personal;

  v_urlaub_anspr_wert := null;
  v_urlaub_anspr_aa_id := null;
  if :new.URLAUBSTAGE is not null
  then
    v_urlaub_anspr_wert := :new.URLAUBSTAGE;
    v_urlaub_anspr_aa_id := 1; -- aa_id = 1 = Tarifurlaub (in Tagen)
  end if;
  if not v_found
  then
    insert into pzm_personal
      (pers_nr, 
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
       pers_startdatum)
      values 
      (   :new.PERS_NR,          --  PERS_NR         NUMBER,
          :new.ANREDE,           --  ANREDE          VARCHAR2(20),
          :new.NNAME,            --  NNAME           VARCHAR2(255),
          :new.VNAME,
          NULL,                  -- Land
          NULL,                  -- Region,
          NULL,                  --  Produktionsbereich - Wird in default von der Abteilung uebernommen
          NULL,                  --  PD_ABT_ID       Abteilungs ID
          NULL,                  --  Kostenstelle Default aus der Abteilung
          :new.TAETIGKEIT,       --  TAETIGKEIT      VARCHAR2(100),
          :new.VERTRAGSART,      --  VERTRAGSART     NUMBER(3),
          :new.EINTRITTSDATUM,   --  EINTRITTSDATUM  DATE,
          :new.AUSTRITTDATUM,    --  AUSTRITTDATUM   DATE,
          :new.SM_NAME,          --  SM_NAME         VARCHAR2(100),
          :new.SM_BEGINN,        --  SM_BEGINN       DATE,
          :new.BEFRISTET_BIS,    --  BEFRISTET_BIS   DATE,
          nvl(:new.USTD_FREISTD,
              'AZ'),             --  USTD_FREISTD    VARCHAR2(10) default 'AZ',
          :new.MAX_FREISTD,      --  MAX_FREISTD     NUMBER default 20,
          :new.ZK_VON1_FREISTD,  --  ZK_VON1_FREISTD NUMBER,
          :new.ZK_BIS1_FREISTD,  --  ZK_BIS1_FREISTD NUMBER,
          :new.ZK_VON2_FREISTD,  --  ZK_VON2_FREISTD NUMBER,
          :new.ZK_BIS2_FREISTD,  --  ZK_BIS2_FREISTD NUMBER
          nvl(:new.KENNZ_ZEITERF,
              1),                --  KENNZ_ZEITERF   NUMBER(1),
          :new.SCHNITTSTELLE,    --  SCHNITTSTELLE   NUMBER(1),
          :new.PERSONALTEILBER,  --  PERSONALTEILBER VARCHAR2(15),
          null,
          null,
          'F',
          v_urlaub_anspr_wert,
          v_urlaub_anspr_aa_id,
          NULL,                   -- pd_sm_beginn_woche     NUMBER
          to_date('31.03.' || to_char(sysdate, 'yyyy'), 'dd.mm.yyyy'), -- PD_VERFALL_VORJAHR    DATE,
          NULL                    -- Region_code
      );
  else
    update pzm_personal t
       set t.pers_anrede =        decode(:new.ANREDE,
                                         NULL,
                                         t.pers_anrede,
                                         :new.ANREDE),           --  ANREDE          VARCHAR2(20),
           t.pers_nname =         decode(:new.NNAME,
                                         NULL,
                                         t.pers_nname,
                                         :new.NNAME),            --  NNAME           VARCHAR2(255),
           t.pers_vname =         decode(:new.VNAME,
                                         NULL,
                                         t.pers_vname,
                                         :new.VNAME),     --  VNAME           VARCHAR2(255),
           t.pers_taetigkeit = decode(:new.TAETIGKEIT,
                                    NULL,
                                    t.pers_taetigkeit,
                                    :new.TAETIGKEIT),          --  TAETIGKEIT      VARCHAR2(100),
           t.pers_vertragsart = decode(:new.VERTRAGSART,
                                     NULL,
                                     t.pers_vertragsart,
                                     :new.VERTRAGSART),        --  VERTRAGSART     NUMBER(3),
           t.pers_eintrittsdatum = decode(:new.EINTRITTSDATUM,
                                        NULL,
                                        t.pers_eintrittsdatum,
                                        :new.EINTRITTSDATUM),  --  EINTRITTSDATUM  DATE,
           t.pers_austrittdatum = decode(:new.AUSTRITTDATUM,
                                       NULL,
                                       t.pers_austrittdatum,
                                       :new.AUSTRITTDATUM),    --  AUSTRITTDATUM   DATE,
           t.pers_sm_name = decode(:new.SM_NAME,
                                 NULL,
                                 t.pers_sm_name,
                                 :new.SM_NAME),                --  SM_NAME         VARCHAR2(100),
           t.pers_sm_beginn = decode(:new.SM_BEGINN,
                                   NULL,
                                   t.pers_sm_beginn,
                                   :new.SM_BEGINN),            --  SM_BEGINN       DATE,
           t.pers_befristet_bis = decode(:new.BEFRISTET_BIS,
                                       NULL,
                                       t.pers_befristet_bis,
                                       :new.BEFRISTET_BIS),    --  BEFRISTET_BIS   DATE,
           t.pers_ustd_freistd = decode(:new.USTD_FREISTD,
                                      NULL,
                                      t.pers_ustd_freistd,
                                      :new.USTD_FREISTD),      --  USTD_FREISTD    VARCHAR2(10) default 'AZ',
           t.pers_max_freistd = decode(:new.MAX_FREISTD,
                                     NULL,
                                     t.pers_max_freistd,
                                     :new.MAX_FREISTD),        --  MAX_FREISTD     NUMBER default 20,
           t.pers_zk_von1_freistd = decode(:new.ZK_VON1_FREISTD,
                                         NULL,
                                         t.pers_zk_von1_freistd,
                                         :new.ZK_VON1_FREISTD), --  ZK_VON1_FREISTD NUMBER,
           t.pers_zk_bis1_freistd = decode(:new.ZK_BIS1_FREISTD,
                                         NULL,
                                         t.pers_zk_bis1_freistd,
                                         :new.ZK_BIS1_FREISTD), --  ZK_BIS1_FREISTD NUMBER,
           t.pers_zk_von2_freistd = decode(:new.ZK_VON2_FREISTD,
                                         NULL,
                                         t.pers_zk_von2_freistd,
                                         :new.ZK_VON2_FREISTD), --  ZK_VON2_FREISTD NUMBER,
           t.pers_zk_bis2_freistd = decode(:new.ZK_BIS2_FREISTD,
                                         NULL,
                                         t.pers_zk_bis2_freistd,
                                         :new.ZK_BIS2_FREISTD), --  ZK_BIS2_FREISTD NUMBER,
           t.pers_kennz_zeiterf = decode(:new.KENNZ_ZEITERF,
                                       NULL,
                                       t.pers_kennz_zeiterf,
                                       :new.KENNZ_ZEITERF),     --  KENNZ_ZEITERF   NUMBER(1),
           t.pers_schnittstelle = decode(:new.SCHNITTSTELLE,
                                       NULL,
                                       t.pers_schnittstelle,
                                       :new.SCHNITTSTELLE),     --  SCHNITTSTELLE   NUMBER(1),
           t.pers_personalteilber = decode(:new.PERSONALTEILBER,
                                         NULL,
                                         t.pers_personalteilber,
                                         :new.PERSONALTEILBER),  --  PERSONALTEILBER VARCHAR2(15),
           t.pers_urlaub_anspr_wert = decode(v_urlaub_anspr_wert,
                                         NULL,
                                         t.pers_urlaub_anspr_wert,
                                         v_urlaub_anspr_wert),  --  urlaub_anspr_wert number,
           t.pers_urlaub_anspr_aa_id = decode(v_urlaub_anspr_aa_id,
                                         NULL,
                                         t.pers_urlaub_anspr_aa_id,
                                         v_urlaub_anspr_aa_id)   --  urlaub_anspr_wert number,
               
     where t.pers_nr =            :new.PERS_NR;          --  PERS_NR         NUMBER,
  end if;


  OPEN c_isi_user;
  FETCH c_isi_user into v_pers_nr;
  v_found := c_isi_user%FOUND;
  CLOSE c_isi_user;
  if not v_found
  then
    insert into isi_user
      values (
          null,                  --  sid             varchar2(2),
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
          null);                 --  fax             varchar2(50)
  else
    update isi_user t
       set
         t.firma_nr              = decode(:new.FIRMA_NR,
                                          NULL,
                                          t.firma_nr,
                                          :new.FIRMA_NR),         --  FIRMA_NR        NUMBER(2) not null,
         t.username              = decode(:new.USERNAME,
                                          NULL,
                                          t.username,
                                          :new.USERNAME),         --  USERNAME        VARCHAR2(50),
         t.passwort              = decode(:new.PASSWORT,
                                          NULL,
                                          t.passwort,
                                          :new.PASSWORT),         --  PASSWORT        VARCHAR2(20),
         t.anrede                = decode(:new.ANREDE,
                                          NULL,
                                          t.anrede,
                                          :new.ANREDE),           --  ANREDE          VARCHAR2(20),
         t.nachname              = decode(:new.NNAME,
                                          NULL,
                                          t.nachname,
                                          :new.NNAME),            --  NNAME           VARCHAR2(255),
         t.vorname               = decode(:new.VNAME,
                                          NULL,
                                          t.vorname,
                                          :new.VNAME),            --  VNAME           VARCHAR2(255),
         t.anschrift             = decode(:new.ANSCHRIFT,
                                          NULL,
                                          t.anschrift,
                                          :new.ANSCHRIFT),        --  ANSCHRIFT       VARCHAR2(255),
         t.plz                   = decode(:new.PLZ,
                                          NULL,
                                          t.plz,
                                          :new.PLZ),              --  PLZ             NUMBER(5),
         t.wohnort               = decode(:new.WOHNORT,
                                          NULL,
                                          t.wohnort,
                                          :new.WOHNORT),          --  WOHNORT         VARCHAR2(255),
         t.telefon_nr            = decode(:new.TELEFON_NR,
                                          NULL,
                                          t.telefon_nr,
                                          :new.TELEFON_NR),       --  TELEFON_NR      VARCHAR2(50),
         t.kuerzel               = decode(:new.KUERZEL,
                                          NULL,
                                          t.kuerzel,
                                          :new.KUERZEL)           --  KUERZEL         VARCHAR2(5),
     where t.pers_nr =            :new.PERS_NR;                 --  PERS_NR         NUMBER,
  end if;

end tr_s_pzm_pers_biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_PZM_PERS_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"a3f3fab93a9658d3a10e502aabbbcd246fce60ca","type":"TRIGGER","name":"TR_S_PZM_PERS_BIU","schemaName":"DIRKSPZM32","sxml":""}