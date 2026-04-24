create or replace editionable trigger dirkspzm32.tr_s_rcv_auftr_biu before
    insert or update on dirkspzm32.s_rcv_auftr
    for each row
declare
    v_error exception;
    v_err_nr          number;
    v_err_text        varchar2(255);

  -- local variables here
    v_found           boolean;
    v_sid             isi_sid%rowtype;
    v_adr_liefer      isi_adressen.adr_liefer%type;
    v_adress_id       isi_adressen.adress_id%type;
    v_adress_id_li    isi_adressen.adress_id%type;
    v_artikel_id      isi_artikel.artikel_id%type;
    v_mengeneinheit   isi_artikel.mengeneinheit%type;
    v_menge_basis     isi_artikel.menge_basis%type;
    v_order_kopf      isi_order_kopf%rowtype;
    v_order_pos       isi_order_pos%rowtype;
    v_charge_id       lvs_charge.charge_id%type;
    v_anz_pos         number;                         -- Anzahl der AUF_ID's diesen Vorgangs

    v_status_new      s_rcv_auftr.status%type;
    v_status_old      s_rcv_auftr.status%type;
    v_lvs_info_new    s_rcv_auftr.lvs_info%type;
    v_lvs_info_old    s_rcv_auftr.lvs_info%type;
    v_ist_menge_new   s_rcv_auftr.ist_menge%type;
    v_ist_menge_old   s_rcv_auftr.ist_menge%type;
    v_leitzahl        isi_order_pos.leitzahl%type;
    v_fa_ag           isi_order_pos.fa_ag%type;
    v_fa_upos         isi_order_pos.fa_upos%type;
    v_std_anbruch_lte s_rcv_auftr.anbruch%type;
    v_neu_std_strateg s_rcv_auftr.strategie%type;
    v_tour            isi_order_tour%rowtype;
    cursor c_sid is
    select
        *
    from
        isi_sid s
    where
        s.sid_my_sid = 1;

    cursor c_adressen is
    select
        adr.adress_id
    from
        isi_adressen adr
    where
            adr.sid = v_sid.sid
        and adr.firma_nr = :new.firma_nr
        and adr.adr_art = :new.adr_art
        and adr.adr_nr = :new.adr_nr
        and adr.adr_liefer = v_adr_liefer;

    cursor c_artikel is
    select
        art.artikel_id,
        art.mengeneinheit,
        art.menge_basis
    from
        isi_artikel art
    where
            art.sid = v_sid.sid
        and art.artikel = :new.artikel;

    cursor c_order_tour is
    select
        *
    from
        isi_order_tour tour
    where
        tour.vorgang_id = :new.vorgang;

    cursor c_order_kopf is
    select
        *
    from
        isi_order_kopf kopf
    where
            kopf.sid = v_sid.sid
        and kopf.firma_nr = :new.firma_nr
        and kopf.vorgang_id = decode(:new.satzart,
                                     'BE',
                                     :new.auftrag,
                                     'BK',
                                     :new.auftrag,
                                     'RK',
                                     :new.auftrag,
                                     :new.vorgang)    -- VORGANG_ID        NUMBER,
        and kopf.satzart = decode(:new.satzart,
                                  'BE',
                                  'BE', -- Satzart
                                  'RK',
                                  'RK', -- Satzart
                                  'RL',
                                  'RL', -- Satzart
                                  'MA',
                                  'MA',
                                  'BK',
                                  'BK',
                                  'LK',
                                  'LK',
                                  'LNK',
                                  'LNK',
                                  'LI')
        and kopf.li_nr = decode(:new.satzart,
                                'BE',
                                0,
                                'BK',
                                0,
                                'RK',
                                0,
                                :new.li_nr);

    cursor c_order_pos is
    select
        *
    from
        isi_order_pos pos
    where
            pos.sid = v_sid.sid
        and pos.firma_nr = :new.firma_nr
        and pos.vorgang_id = :new.vorgang    -- VORGANG_ID        NUMBER,
      -- and pos.vorgang_pos = :new.pos_nr
        and pos.satzart = decode(:new.satzart,
                                 'BE',
                                 'BE', -- Satzart
                                 'RK',
                                 'RK', -- Satzart
                                 'RL',
                                 'RL', -- Satzart
                                 'MA',
                                 'MA',
                                 'BK',
                                 'BK',
                                 'LK',
                                 'LK',
                                 'LNK',
                                 'LNK',
                                 'LI')
        and pos.li_nr = :new.li_nr
        and nvl(pos.li_pos_nr, 0) = nvl(:new.li_pos_nr,
                                        0)
        and pos.auf_id_extern = :new.auf_id
        and nvl(pos.auftrag, -1) = nvl(:new.auftrag,
                                       -1)
        and nvl(pos.pos_nr, -1) = nvl(:new.pos_nr,
                                      -1)
        and nvl(pos.upos_nr, -1) = nvl(:new.upos_nr,
                                       -1);

    cursor c_pos_anz is
    select
        count(auf_id)
    from
        isi_order_pos pos
    where
            pos.sid = v_sid.sid
        and pos.vorgang_typ = decode(:new.satzart,
                                     'BE',
                                     'WEE',           -- VORGANG_ID_TYP
                                     'RK',
                                     'WEE',           -- VORGANG_ID_TYP
                                     'RL',
                                     'WAE',           -- VORGANG_ID_TYP
                                     'MA',
                                     'WAI',
                                     'BK',
                                     'KWE',
                                     'LK',
                                     'KWA',
                                     'LNK',
                                     'WUI',
                                     'WAE')
        and pos.vorgang_id = :new.vorgang    -- VORGANG_ID        NUMBER,
        and pos.auf_id != :old.auf_id
        and nvl(pos.status, 'x') != 'E'
    group by
        pos.vorgang_typ,
        pos.vorgang_id;

begin

  -- sid
    open c_sid;
    fetch c_sid into v_sid;
    v_found := c_sid%found;
    close c_sid;
    if not v_found then
        v_sid.sid := '01';
    end if;
    if :new.satzart not in ( 'BE', 'BK', 'RK' ) then
        open c_order_tour;
        fetch c_order_tour into v_tour;
        v_found := c_order_tour%found;
        close c_order_tour;
        if not v_found then
            insert into isi_order_tour values ( :new.vorgang,
                                                nvl(:new.tour,
                                                    to_char(:new.vorgang)),
                                                null,
                                                null,
                                                null,
                                                null );

            :new.tour := nvl(:new.tour,
                             to_char(:new.vorgang));

        else
            :new.tour := v_tour.tour;
        end if;

    else
        :new.tour := nvl(:new.tour,
                         to_char(:new.auftrag));
    end if;

    v_std_anbruch_lte := nvl(:new.anbruch,
                             isi_allg.get_firma_cfg_param(v_sid.sid,
                                                          :new.firma_nr,
                                                          'ORDER_NEU_STD',
                                                          :new.satzart,
                                                          'ANBRUCH_LTE',
                                                          'order',
                                                          'CFG',
                                                          'I',
                                                          'STRING'));

    v_neu_std_strateg := nvl(:new.strategie,
                             isi_allg.get_firma_cfg_param(v_sid.sid,
                                                          :new.firma_nr,
                                                          'ORDER_NEU_STD',
                                                          :new.satzart,
                                                          'STRATEGIE',
                                                          'order',
                                                          'CFG',
                                                          'FIFO',
                                                          'STRING'));

    if (
        :new.status != 'L'
        and :new.status != 'e'
    )
    or :new.status is null then
        v_status_new := :new.status;
        v_status_old := :old.status;
        v_lvs_info_new := :new.lvs_info;
        v_lvs_info_old := :old.lvs_info;
        v_ist_menge_new := :new.ist_menge;
        v_ist_menge_old := :old.ist_menge;

    -- Diese werte können nur aus ISIPlus geaendert worden sein
    -- und brauchen deshalb nicht in dei ORDER-Tabellen geladen werden
        if
            ( nvl(v_status_new, 'NULL') != nvl(v_status_old, 'NULL')
            or nvl(v_ist_menge_new, 0) != nvl(v_ist_menge_old, 0)
            or nvl(v_lvs_info_new, 'NULL') != nvl(v_lvs_info_old, 'NULL') )
            and not inserting
        then
            if v_sid.sid_schnittstelle is not null then
                s_schnittstelle.write_auftr_update(:new.auf_id,
                                                   :new.status,
                                                   :new.lvs_info,
                                                   :new.ist_menge);
            end if;

            return;
        end if;

    -- c_adressen
        v_adr_liefer := 0;
        open c_adressen;
        fetch c_adressen into v_adress_id;
        v_found := c_adressen%found;
        close c_adressen;
        if not v_found then
            v_err_nr := 15;
            v_err_text := 'Fehler: Adressdaten fehlen für Nummer <'
                          || nvl(:new.adr_nr,
                                 'NULL')
                          || '>';

            raise v_error;
            v_adress_id := null;
        end if;

        if
            nvl(:new.vorgang,
                0) = 0
            and :new.satzart != 'BE'
            and :new.satzart != 'RK'
            and :new.satzart != 'BK'
        then
            :new.vorgang := :new.li_nr;
        end if;

        v_adr_liefer := :new.adr_liefer;
        open c_adressen;
        fetch c_adressen into v_adress_id_li;
    --v_found := c_adressen%FOUND;
        close c_adressen;
        if not v_found then
            v_adress_id_li := null;
        end if;

    -- c_artikel
        open c_artikel;
        fetch c_artikel into
            v_artikel_id,
            v_mengeneinheit,
            v_menge_basis;
        v_found := c_artikel%found;
        close c_artikel;
        if not v_found then
            v_err_nr := 20;
            v_err_text := 'Fehler: Artikeldaten fehlen für Artikel <'
                          || nvl(:new.artikel,
                                 'NULL')
                          || '>';

            raise v_error;
        end if;

    -- c_order_kopf
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if not v_found then
            insert into isi_order_kopf kopf (
                kopf.sid,                       -- SID      VARCHAR2(2) not null,
                kopf.firma_nr,                  -- FIRMA_NR NUMBER(2) not null,
                kopf.vorgang_id,                -- VORGANG_ID        NUMBER,
                kopf.vorgang_typ,
                kopf.satzart,                   -- SATZART           VARCHAR2(2),
                kopf.li_nr
            )                     -- LI_NR             NUMBER(10),
             values ( v_sid.sid,                          -- SID      VARCHAR2(2) not null,

                       :new.firma_nr,                  -- FIRMA_NR NUMBER(2) not null,
                       :new.vorgang,                   -- VORGANG_ID        NUMBER,
                       decode(:new.satzart,
                              'BE',
                              'WEE',           -- VORGANG_ID_TYP
                              'RK',
                              'WEE',           -- VORGANG_ID_TYP
                              'RL',
                              'WAE',           -- VORGANG_ID_TYP
                              'MA',
                              'WAI',
                              'BK',
                              'KWE',
                              'LK',
                              'KWA',
                              'LNK',
                              'WUI',
                              'WAE'),
                       decode(:new.satzart,
                              'BE',
                              'BE',           -- VORGANG_ID_TYP
                              'RK',
                              'RK',           -- VORGANG_ID_TYP
                              'RL',
                              'RL',           -- VORGANG_ID_TYP
                              'MA',
                              'MA',
                              'BK',
                              'BK',
                              'LK',
                              'LK',
                              'LNK',
                              'LNK',
                              'LI'),          -- SATZART           VARCHAR2(2),
                       decode(:new.satzart,
                              'BE',
                              0,
                              'BK',
                              0,
                              'RK',
                              0,
                              :new.li_nr) )      -- LI_NR             NUMBER(10),
                               returning kopf.be_nr into v_order_kopf.be_nr;

            open c_order_kopf;
            fetch c_order_kopf into v_order_kopf;
            close c_order_kopf;
        end if;

    -- Hier kommen nur noch Aenderungen oder Erweiterungen. Bei Abgeschlossenen Aufträgen nicht mehr moeglich
        if v_order_kopf.status = 'E' then
            v_err_nr := 25;
            v_err_text := v_err_text
                          || 'Ein Auftrag mit Status <'
                          || nvl(:old.status,
                                 'NULL')
                          || '> darf nicht mehr verändert werden. Vorgang ID: '
                          || v_order_kopf.vorgang_id;

            raise v_error;
        end if;

        update isi_order_kopf kopf
        set                                              -- SID               VARCHAR2(2) not null,
                                                        -- FIRMA_NR          NUMBER(2) not null,
                                                        -- VORGANG_TYP       VARCHAR2(3),
                                                        -- VORGANG_ID        NUMBER,
                                                        -- LI_NR             NUMBER(10),
            kopf.be_nr = decode(:new.satzart,
                                'BL',
                                :new.auftrag,
                                null),               -- BE_NR             NUMBER(10),
                                                        -- SATZART           VARCHAR2(2),
           -- -AG- 20190414 Bei R4 sind die Adressen getauscht. Lieferadresse in adress_id und Kundenhautadresse in order_adress_id
            kopf.adress_id = nvl(v_adress_id_li, v_adress_id),     -- ADRESS_ID         NUMBER,
            kopf.order_adress_id = v_adress_id,          -- ORDER_ADRESS_ID   NUMBER,
                                                        -- LOGIN_ID          NUMBER,
            kopf.arbeitsplatz_id = nvl(:new.arbeitsplatz_id,
                                       kopf.arbeitsplatz_id),
                                                        -- ARBEITSPLATZ_ID   NUMBER,
            kopf.strategie = v_neu_std_strateg,    -- STRATEGIE         VARCHAR2(10),
            kopf.order_info = :new.kom_info,        -- ORDER_INFO        VARCHAR2(40),
                                                        -- STATUS            VARCHAR2(1),
                                                        -- QUELL_LAGERORTE   VARCHAR2(200),
                                                        -- QUELLE            VARCHAR2(30),
            kopf.ziel = :new.ziel,            -- ZIEL              VARCHAR2(30),
            kopf.wae_ziel = :new.wa_ziel,         -- WAE_ZIEL          VARCHAR2(6),
            kopf.besteller = nvl(:new.besteller,
                                 'HOST'),                -- BESTELLER         VARCHAR2(10),
            kopf.freigabe = 'M',                  -- FREIGABE          CHAR(1),
                                                        -- FREIGABE_DATUM    DATE,
                                                        -- FREIGEGEBEN_DATUM DATE,
            kopf.order_datum = :new.gen_datum,       -- ORDER_DATUM       DATE,
                                                        -- LIEFER_DATUM      DATE,
                                                        -- FERTIG_DATUM      DATE,
            kopf.lvs_info = decode(:new.satzart,
                                   'BL',
                                   'Beistellung zur Bestellung: ' || to_char(:new.auftrag),
                                   null),               -- LVS_INFO          VARCHAR2(40),
            kopf.prioritaet = :new.prioritaet,      -- PRIORITAET        NUMBER(1),
            kopf.anbruch = v_std_anbruch_lte,    -- ANBRUCH           CHAR(1)
            kopf.liefer_datum = :new.liefer_datum     --
        where
                kopf.sid = v_sid.sid
            and kopf.firma_nr = :new.firma_nr
            and kopf.vorgang_id = decode(:new.satzart,
                                         'BE',
                                         :new.auftrag,
                                         'BK',
                                         :new.auftrag,
                                         'RK',
                                         :new.auftrag,
                                         :new.vorgang)    -- VORGANG_ID        NUMBER,
            and kopf.satzart = decode(:new.satzart,
                                      'BE',
                                      'BE', -- Satzart
                                      'RK',
                                      'RK',           -- VORGANG_ID_TYP
                                      'RL',
                                      'RL',           -- VORGANG_ID_TYP
                                      'MA',
                                      'MA',
                                      'BK',
                                      'BK',
                                      'LK',
                                      'LK',
                                      'LNK',
                                      'LNK',
                                      'LI')
            and kopf.li_nr = decode(:new.satzart,
                                    'BE',
                                    0,
                                    'BK',
                                    0,
                                    'RK',
                                    0,
                                    :new.li_nr);

    -- c_order_pos
        open c_order_pos;
        fetch c_order_pos into v_order_pos;
        v_found := c_order_pos%found;
        close c_order_pos;
        if not v_found then
            if :new.auf_id is null then
                select
                    seq_isi_order_auf_id.nextval
                into :new.auf_id
                from
                    dual;

            end if;

            insert into isi_order_pos pos (
                pos.sid,                       -- SID      VARCHAR2(2) not null,
                pos.firma_nr,                  -- FIRMA_NR NUMBER(2) not null,
                pos.vorgang_typ,
                pos.vorgang_id,                -- VORGANG_ID        NUMBER,
                pos.vorgang_pos,               -- VORGANG_ID        NUMBER,
                pos.satzart,                   -- SATZART           VARCHAR2(2),
                pos.li_nr,                     -- LI_NR             NUMBER(10),
                pos.li_pos_nr,
                pos.auftrag,
                pos.pos_nr,
                pos.upos_nr,
                pos.artikel_id,                -- ARTIKEL_ID        NUMBER,
                pos.ist_menge,                 -- IST_MENGE         NUMBER(12,3),
                pos.auf_id_extern,
                pos.besteller
            )             -- AUF_ID_EXTERN
             values ( v_sid.sid,                          -- SID      VARCHAR2(2) not null,
                       :new.firma_nr,                  -- FIRMA_NR NUMBER(2) not null,
                       decode(:new.satzart,
                              'BE',
                              'WEE',           -- VORGANG_ID_TYP
                              'RK',
                              'WEE',           -- VORGANG_ID_TYP
                              'RL',
                              'WAE',           -- VORGANG_ID_TYP
                              'MA',
                              'WAI',
                              'BK',
                              'KWE',           -- VORGANG_ID_TYP
                              'LK',
                              'KWA',           -- VORGANG_ID_TYP
                              'LNK',
                              'WUI',
                              'WAE'),
                       :new.vorgang,    -- VORGANG_ID        NUMBER,
                       null,
                       decode(:new.satzart,
                              'BE',
                              'BE',           -- VORGANG_ID_TYP
                              'RL',
                              'RL',           -- VORGANG_ID_TYP
                              'RK',
                              'RK',           -- VORGANG_ID_TYP
                              'MA',
                              'MA',
                              'BK',
                              'BK',
                              'LK',
                              'LK',
                              'LNK',
                              'LNK',
                              'LI'),          -- SATZART           VARCHAR2(2),
                       :new.li_nr,
                       :new.li_pos_nr,
                       :new.auftrag,
                       :new.pos_nr,
                       :new.upos_nr,
                       v_artikel_id,                   -- ARTIKEL_ID        NUMBER,
                       :new.ist_menge,                 -- IST_MENGE         NUMBER(12,3),
                       :new.auf_id,
                       nvl(:new.besteller,
                           'HOST') ) returning pos.auf_id_extern into v_order_pos.auf_id_extern;

            open c_order_pos;
            fetch c_order_pos into v_order_pos;
            close c_order_pos;
        end if;

        :new.auf_id := v_order_pos.auf_id_extern;
        if :new.charge is not null then
            v_charge_id := get_charge_id(v_sid.sid,
                                         :new.firma_nr,
                                         null,
                                         :new.charge,
                                         v_artikel_id);
        else
            v_charge_id := null;
        end if;

        if :new.satzart not in ( 'BE', 'MA', 'RK', 'BK' ) then
            if :new.satzart = 'BL' then
                v_fa_ag := :new.fa_ag;                 -- FA_AG             NUMBER,
                if nvl(v_fa_ag, 0) != 0 then
                    v_leitzahl := :new.leitzahl;                       --              NUMBER,
                    v_fa_ag := bde_get_last_v_ag(v_sid.sid,
                                                 :new.firma_nr,
                                                 v_leitzahl,
                                                 v_fa_ag);

                    if v_fa_ag is null then
                        return;
                    end if;
                else
                    v_leitzahl := :new.leitzahl;
                    v_fa_ag := null;
                end if;

                v_fa_upos := null;                                -- FA_UPOS           NUMBER,
            else
                v_leitzahl := :new.leitzahl;                       -- LEITZAHL          NUMBER,
                v_fa_ag := null;                                -- FA_AG             NUMBER,
                v_fa_upos := null;                                -- FA_UPOS           NUMBER,
            end if;
        else
            v_leitzahl := :new.leitzahl;                    -- LEITZAHL          NUMBER,
            v_fa_ag := :new.fa_ag;                       -- FA_AG             NUMBER,
            v_fa_upos := null;                             -- FA_UPOS           NUMBER,
        end if;

        update isi_order_pos pos
        set                                             -- SID               VARCHAR2(2) not null,
                                                       -- FIRMA_NR          NUMBER(2) not null,
                                                       -- AUF_ID            NUMBER not null,
                                                       -- AUF_ID_EXTERN     NUMBER,
                                                       -- VORGANG_TYP       VARCHAR2(3),
                                                       -- VORGANG_ID        NUMBER,
                                                       -- VORGANG_POS       NUMBER,
                                                       -- TRANSPORT_GRUPPE  NUMBER,
                                                       -- SATZART           VARCHAR2(2),
            pos.auftrag = :new.auftrag,         -- AUFTRAG           NUMBER(10),
            pos.pos_nr = :new.pos_nr,          -- POS_NR            NUMBER(10),
            pos.upos_nr = :new.upos_nr,         -- UPOS_NR           NUMBER(10),
            pos.artikel_id = v_artikel_id,         -- ARTIKEL_ID        NUMBER,
            pos.ware_disponiert = c.c_false,            -- WARE_DISPONIERT   CHAR(1),
                                                       -- LOGIN_ID          NUMBER,
            pos.arbeitsplatz_id = nvl(:new.arbeitsplatz_id,
                                      v_order_kopf.arbeitsplatz_id),
                                                       -- ARBEITSPLATZ_ID   NUMBER,
            pos.leitzahl = v_leitzahl,           -- LEITZAHL          NUMBER,
            pos.fa_ag = v_fa_ag,              -- FA_AG             NUMBER,
            pos.fa_upos = v_fa_upos,            -- FA_UPOS           NUMBER,
            pos.charge_id = v_charge_id,          -- CHARGE_ID         NUMBER,
                                                       -- SERIENNR_ID       NUMBER,
            pos.strategie = v_neu_std_strateg,    -- STRATEGIE         VARCHAR2(10),
            pos.mhd = :new.mhd,             -- MHD               DATE,
            pos.li_extern = decode(:new.satzart,
                                   'BL',
                                   'B',
                                   c.c_true),     -- LI_EXTERN         CHAR(1),
            pos.li_nr = :new.li_nr,           -- LI_NR             NUMBER(10),
            pos.li_pos_nr = :new.li_pos_nr,       -- LI_POS_NR         NUMBER(10),
            pos.order_info = :new.kom_info,        -- ORDER_INFO        VARCHAR2(40),
            pos.soll_menge = :new.soll_mg,         -- SOLL_MENGE        NUMBER(12,3),
                                                       -- IST_MENGE         NUMBER(12,3),
            pos.menge_basis = v_menge_basis,        -- MENGE_BASIS       VARCHAR2(3),
            pos.mengeneinheit = v_mengeneinheit,      -- MENGENEINHEIT     VARCHAR2(10),
            pos.status = :new.status,          -- STATUS            VARCHAR2(1),
                                                       -- QUELL_LAGERORTE   VARCHAR2(200),
                                                       -- QUELLE            VARCHAR2(30),
            pos.ziel = :new.ziel,            -- ZIEL              VARCHAR2(30),
            pos.wae_ziel = :new.wa_ziel,         -- WAE_ZIEL          VARCHAR2(6),
            pos.besteller = nvl(:new.besteller,
                                'HOST'),              -- BESTELLER         VARCHAR2(10),
            pos.freigabe = 'M',                  -- FREIGABE          CHAR(1),
                                                       -- FREIGABE_DATUM    DATE,
                                                       -- FREIGEGEBEN_DATUM DATE,
            pos.order_datum = :new.gen_datum,       -- ORDER_DATUM       DATE,
                                                       -- LIEFER_DATUM      DATE,
                                                       -- FERTIG_DATUM      DATE,
            pos.lvs_info = decode(:new.satzart,
                                  'BL',
                                  'Beistellung zur Bestellung: ' || to_char(:new.auftrag),
                                  null),                 -- LVS_INFO          VARCHAR2(40),
            pos.prioritaet = :new.prioritaet,      -- PRIORITAET        NUMBER(1),
            pos.anbruch = v_std_anbruch_lte,    -- ANBRUCH           CHAR(1)
            pos.best_nr_kunde = :new.best_nr_kunde,   -- BEST_NR_KUNDE     VARCHAR2(30)
            pos.liefer_datum = :new.liefer_datum,
            pos.lam_sel1 = :new.lam_sel1,       -- LAM_SEL1  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel2 = :new.lam_sel2,       -- LAM_SEL2  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel3 = :new.lam_sel3,       -- LAM_SEL3  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel4 = :new.lam_sel4,       -- LAM_SEL4  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel5 = :new.lam_sel5,       -- LAM_SEL5  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel6 = :new.lam_sel6,       -- LAM_SEL6  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel7 = :new.lam_sel7,       -- LAM_SEL7  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel8 = :new.lam_sel8,       -- LAM_SEL8  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel9 = :new.lam_sel9,       -- LAM_SEL9  N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.lam_sel10 = :new.lam_sel10,      -- LAM_SEL10 N  VARCHAR2(30)  Y      Parameter zusätzliche Selectionsparameter
            pos.wa_menge_ueberlief = :new.ueber_unter_liefern --  UEBER_UNTER_LIEFERN  N VARCHAR2(4) Y
        where
                pos.sid = v_sid.sid
            and pos.firma_nr = :new.firma_nr
            and pos.auf_id = v_order_pos.auf_id;

    elsif :new.status = 'e' then
        open c_order_kopf;
        fetch c_order_kopf into v_order_kopf;
        v_found := c_order_kopf%found;
        close c_order_kopf;
        if v_found then
            open c_order_pos;
            fetch c_order_pos into v_order_pos;
            v_found := c_order_pos%found;
            close c_order_pos;
            if v_found then
                update isi_order_pos pos
                set
                    pos.status = 'F'
                where
                        pos.sid = v_sid.sid
                    and pos.firma_nr = :new.firma_nr
                    and pos.vorgang_id = :new.vorgang    -- VORGANG_ID        NUMBER,
                    and pos.satzart = decode(:new.satzart,
                                             'BE',
                                             'BE', -- Satzart
                                             'RK',
                                             'RK', -- Satzart
                                             'RL',
                                             'RL', -- Satzart
                                             'MA',
                                             'MA',
                                             'BK',
                                             'BK', -- Satzart
                                             'LK',
                                             'LK', -- Satzart
                                             'LNK',
                                             'LNK',
                                             'LI')
                    and pos.li_nr = :new.li_nr
                    and pos.li_pos_nr = :new.li_pos_nr
                    and pos.auftrag = :new.auftrag
                    and pos.pos_nr = :new.pos_nr
                    and pos.upos_nr = :new.upos_nr;

                if v_order_pos.vorgang_typ = 'WAE' then
                    isi_p_order.lte_lief_ende(v_order_pos, -1);
                end if;

            end if;

            open c_pos_anz;                         -- Auftragsdaten lesen lesen
            fetch c_pos_anz into v_anz_pos;
            v_found := c_pos_anz%found;             -- Artikeldaten gefunden ?
            close c_pos_anz;
            if v_anz_pos = 0
            or not v_found then
                update isi_order_kopf kopf
                set
                    kopf.status = 'E'
                where
                        kopf.sid = v_sid.sid
                    and kopf.vorgang_typ = decode(:old.satzart,
                                                  'BE',
                                                  'WEE',           -- VORGANG_ID_TYP
                                                  'RK',
                                                  'WEE',           -- VORGANG_ID_TYP
                                                  'RL',
                                                  'WAE',           -- VORGANG_ID_TYP
                                                  'MA',
                                                  'WAI',
                                                  'BK',
                                                  'KWE',           -- VORGANG_ID_TYP
                                                  'LK',
                                                  'KWA',           -- VORGANG_ID_TYP
                                                  'LNK',
                                                  'LNK',
                                                  'WAE')
                    and kopf.vorgang_id = decode(:old.satzart,
                                                 'BE',
                                                 :old.auftrag,
                                                 'BK',
                                                 :old.auftrag,
                                                 'RK',
                                                 :old.auftrag,
                                                 :old.vorgang);    -- VORGANG_ID        NUMBER,
            end if;

        end if;

        :new.status := 'F';
    else
        if :old.status is null
           or :old.status = 'N'
        or :old.status = 'F'
        or :old.status = 'L' then
            delete isi_order_pos pos
            where
                    pos.sid = v_sid.sid
                and pos.firma_nr = :old.firma_nr
                and pos.auf_id_extern = :old.auf_id;

      -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
            insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                 :old.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                 'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                 'S_AUF',                 -- TABELLE         VARCHAR2(5),
                                                 :old.auf_id,             -- AUF_ID          NUMBER,
                                                 'UE',                    -- STATUS          VARCHAR2(3),
                                                 'L',                     -- AKTION          VARCHAR2(3),
                                                 null,                    -- MA_STATUS       VARCHAR2(1),
                                                 null,                    -- MA_S_GRUND      NUMBER(3),
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
                                                 :old.li_nr,              -- EXT_LIEF_NR     VARCHAR2(15),
                                                 :old.li_pos_nr,          -- EXT_LIEF_POS    VARCHAR2(5),
                                                 null,                    -- CHARGE          VARCHAR2(20),
                                                 null,                    -- SERIE           VARCHAR2(20),
                                                 null,                    -- ARBEITSPLATZ_ID VARCHAR2(20),
                                                 null,                    -- IST_BESTAND     NUMBER,
                                                 :old.artikel,            -- ARTIKEL         VARCHAR2(20),
                                                 sysdate,                 -- B_DATUM         DATE,
                                                 null,                    -- LAM_ID          NUMBER,
                                                 null,                    -- LAM_BH_ID       NUMBER,
                                                 null,                    -- LAM_BH_TYP      VARCHAR2(2)
                                                 null,                    -- LEITZAHL        NUMBER,
                                                 null,                    -- FA_AG           NUMBER,
                                                 null,                    -- FA_UPOS         NUMBER
                                                 null,                    -- LAM_AG          NUMBER
                                                 null,                    -- BRUTTO_KG
                                                 null,                    -- TEXT            VARCHAR2(40),
                                                 null,                    -- ERR_NR          NUMBER
                                                 null,                    -- USER_NAME       VARCHAR2(100),
                                                 null,                    -- RES_ID          NUMBER
                                                 null,                    -- SEND_ID         NUMBER
                                                 null,                    -- MA_LAST_S_GRUND NUMBER
                                                 null,                    -- PERS_NR          NUMBER
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
            open c_pos_anz;                         -- Artikeldaten lesen
            fetch c_pos_anz into v_anz_pos;
            v_found := c_pos_anz%found;             -- Artikeldaten gefunden ?
            close c_pos_anz;
            if not v_found then
                delete isi_order_kopf kopf
                where
                        kopf.sid = v_sid.sid
                    and kopf.vorgang_typ = decode(:old.satzart,
                                                  'BE',
                                                  'WEE',           -- VORGANG_ID_TYP
                                                  'RK',
                                                  'WEE',           -- VORGANG_ID_TYP
                                                  'RL',
                                                  'WAE',           -- VORGANG_ID_TYP
                                                  'MA',
                                                  'WAI',
                                                  'BK',
                                                  'KWE',
                                                  'LK',
                                                  'KWA',
                                                  'LNK',
                                                  'WUI',
                                                  'WAE')
                    and kopf.vorgang_id = decode(:old.satzart,
                                                 'BE',
                                                 :old.auftrag,
                                                 'BK',
                                                 :old.auftrag,
                                                 'RK',
                                                 :old.auftrag,
                                                 :old.vorgang)     -- VORGANG_ID        NUMBER,
                    and ( nvl(kopf.li_nr, -1) = nvl(:old.li_nr,
                                                    -1)
                          or kopf.satzart not in ( 'BL', 'LI' ) );

            end if;

            if v_anz_pos = 0 then
                update isi_order_kopf kopf
                set
                    kopf.status = 'E'
                where
                        kopf.sid = v_sid.sid
                    and kopf.vorgang_typ = decode(:old.satzart,
                                                  'BE',
                                                  'WEE',           -- VORGANG_ID_TYP
                                                  'RK',
                                                  'WEE',           -- VORGANG_ID_TYP
                                                  'RL',
                                                  'WAE',           -- VORGANG_ID_TYP
                                                  'MA',
                                                  'WAI',
                                                  'BK',
                                                  'KWE',
                                                  'LK',
                                                  'KWA',
                                                  'LNK',
                                                  'WUI',
                                                  'WAE')
                    and kopf.vorgang_id = decode(:old.satzart,
                                                 'BE',
                                                 :old.auftrag,
                                                 'BK',
                                                 :old.auftrag,
                                                 'RK',
                                                 :old.auftrag,
                                                 :old.vorgang);    -- VORGANG_ID        NUMBER,
            end if;

        else
            v_err_text := 'Fehler:';
            if :new.satzart = 'BE' then
                v_err_text := v_err_text
                              || ' Bestellung '
                              || :new.auftrag
                              || '/'
                              || :new.pos_nr;

            elsif :new.satzart = 'BK' then
                v_err_text := v_err_text
                              || ' Bestellung KONSI'
                              || :new.auftrag
                              || '/'
                              || :new.pos_nr;
            elsif :new.satzart = 'LK' then
                v_err_text := v_err_text
                              || ' Rücklieferung KONSI'
                              || :new.auftrag
                              || '/'
                              || :new.pos_nr;
            elsif :new.satzart = 'LNK' then
                v_err_text := v_err_text
                              || ' Einlagerung mit Kommissionierung'
                              || :new.auftrag
                              || '/'
                              || :new.pos_nr;
            elsif :new.satzart = 'RL' then
                v_err_text := v_err_text
                              || ' Retoure Lieferant '
                              || :new.vorgang
                              || '/'
                              || :new.li_pos_nr;
            elsif :new.satzart = 'RK' then
                v_err_text := v_err_text
                              || ' Retoure Kunde '
                              || :new.auftrag
                              || '/'
                              || :new.pos_nr;
            else
                v_err_text := v_err_text
                              || ' Lieferschein '
                              || :new.vorgang
                              || '/'
                              || :new.li_pos_nr;
            end if;

            v_err_nr := 30;
            v_err_text := v_err_text
                          || ' mit Status <'
                          || :old.status
                          || '> darf nicht gelöscht werden.';
            raise v_error;
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
end tr_s_rcv_auftr_biu;
/

alter trigger dirkspzm32.tr_s_rcv_auftr_biu enable;


-- sqlcl_snapshot {"hash":"018f5c7c662589537b87a3899909ffa73790def5","type":"TRIGGER","name":"TR_S_RCV_AUFTR_BIU","schemaName":"DIRKSPZM32","sxml":""}