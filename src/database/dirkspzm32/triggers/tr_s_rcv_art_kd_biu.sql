create or replace editionable trigger dirkspzm32.tr_s_rcv_art_kd_biu before
    insert or update on dirkspzm32.s_rcv_art_kd
    for each row
declare
  -- local variables here
    v_found     boolean;
    v_sid       isi_sid.sid%type;
    v_artikel   isi_artikel%rowtype;
    v_kunden_nr isi_artikel_kunde.kunden_nr%type;
    cursor c_sid is
    select
        s.sid
    from
        isi_sid s
    where
        s.sid_my_sid = 1;

    cursor c_artikel is
    select
        *
    from
        isi_artikel art
    where
            art.sid = v_sid
        and art.artikel = :new.artikel;

    cursor c_artikel_kunde is
    select
        art_k.kunden_nr
    from
        isi_artikel_kunde art_k
    where
            art_k.sid = v_sid
        and art_k.artikel_id = v_artikel.artikel_id
        and art_k.kunden_nr = nvl(:new.kunden_nr,
                                  c.leer);

begin
  -- sid
    open c_sid;
    fetch c_sid into v_sid;
    v_found := c_sid%found;
    close c_sid;
    if not v_found then
        v_sid := '01';
    end if;

  -- c_artikel
    open c_artikel;
    fetch c_artikel into v_artikel;
    v_found := c_artikel%found;
    close c_artikel;
    if v_found then
    -- c_artikel_kunde
        open c_artikel_kunde;
        fetch c_artikel_kunde into v_kunden_nr;
        v_found := c_artikel_kunde%found;
        close c_artikel_kunde;
        if not v_found then
            begin
                insert into isi_artikel_kunde art (
                    art.sid,                     -- SID        VARCHAR2(2) not null,
                    art.artikel_id,              -- ARTIKEL_ID NUMBER not null,
                    art.kunden_nr
                )               -- KUNDEN_NR  VARCHAR2(10) not null,
                 values ( v_sid,                       -- SID        VARCHAR2(2) not null,
                           v_artikel.artikel_id,        -- ARTIKEL_ID NUMBER not null,
                           :new.kunden_nr )              -- KUNDEN_NR  VARCHAR2(10) not null,
                            returning art.kunden_nr into v_kunden_nr;

            exception
                when dup_val_on_index then
                    null;
            end;
        end if;

        update isi_artikel_kunde art
        set                                                                       -- SID                VARCHAR2(2) not null,
                                                                                 -- ARTIKEL_ID         NUMBER not null,
                                                                                 -- KUNDEN_NR          VARCHAR2(10) not null,
            art.kd_art_nr = :new.kd_art_nr,                                  -- KD_ART_NR          VARCHAR2(30),
            art.kd_art_text1 = :new.kd_art_text1,                               -- KD_ART_TEXT1       VARCHAR2(50),
            art.kd_art_text2 = :new.kd_art_text2,                               -- KD_ART_TEXT2       VARCHAR2(50),
                                                                                 -- KD_VERPACKUNGSTYPE VARCHAR2(10),
            art.lhm_name = nvl(:new.lhm_name,
                               art.lhm_name),                -- LHM_NAME           VARCHAR2(10),
            art.lhm_menge = nvl(:new.lhm_menge,
                                art.lhm_menge),              -- LHM_MENGE          NUMBER(10),
            art.lhm_gewicht_kg = nvl(:new.lhm_gewicht_kg,
                                     art.lhm_gewicht_kg),    -- LHM_GEWICHT_KG     NUMBER,
            art.lhm_ean = nvl(:new.lhm_ean,
                              art.lhm_ean),                  -- LHM_EAN            VARCHAR2(15),
            art.lte_name = nvl(:new.lte_name,
                               art.lte_name),                -- LTE_NAME           VARCHAR2(10),
            art.lte_menge = nvl(:new.lte_menge,
                                art.lte_menge),              -- LTE_MENGE          NUMBER(10),
            art.lte_gewicht_kg = nvl(:new.lte_gewicht_kg,
                                     art.lte_gewicht_kg),    -- LTE_GEWICHT_KG     NUMBER,
            art.lte_breite_max = nvl(:new.lte_breite_max,
                                     art.lte_breite_max),    -- LTE_BREITE_MAX     NUMBER,
            art.lte_tiefe_max = nvl(:new.lte_tiefe_max,
                                    art.lte_tiefe_max),      -- LTE_TIEFE_MAX      NUMBER,
            art.lte_hoehe_max = nvl(:new.lte_hoehe_max,
                                    art.lte_hoehe_max),      -- LTE_HOEHE_MAX      NUMBER,
            art.lte_lhm_menge = nvl(:new.lte_lhm_menge,
                                    art.lte_lhm_menge),      -- LTE_LHM_MENGE      NUMBER(8),
            art.lte_lhm_pro_lage = nvl(:new.lte_lhm_pro_lage,
                                       art.lte_lhm_pro_lage),
                                                                                 -- LTE_LHM_PRO_LAGE   NUMBER(2),
            art.lte_lhm_lagen = nvl(:new.lte_lhm_lagen,
                                    art.lte_lhm_lagen),      -- LTE_LHM_LAGEN      NUMBER(2),
            art.lte_ean = nvl(:new.lte_ean,
                              art.lte_ean),                  -- LTE_EAN            VARCHAR2(15),
            art.ean = nvl(:new.ean,
                          art.ean),                          -- EAN                VARCHAR2(15)
            art.lhm_hoehe_lage = nvl(:new.lte_hoehe_lage,
                                     art.lhm_hoehe_lage),    -- LHM_HOEHE_LAGE       NUMBER
            art.stk_liste_txt = nvl(:new.stk_liste_txt,
                                    art.stk_liste_txt),      -- STK_LISTE_TXT
            art.pack_vorschr = nvl(:new.pack_vorschr,
                                   art.pack_vorschr)         -- PACK_VORSCHR
        where
                art.sid = v_sid
            and art.artikel_id = v_artikel.artikel_id
            and art.kunden_nr = v_kunden_nr;

    end if;

end tr_s_rcv_art_kd_biu;
/

alter trigger dirkspzm32.tr_s_rcv_art_kd_biu enable;


-- sqlcl_snapshot {"hash":"b8bfc9055f28916250ac1fa07d82ada829f809c4","type":"TRIGGER","name":"TR_S_RCV_ART_KD_BIU","schemaName":"DIRKSPZM32","sxml":""}