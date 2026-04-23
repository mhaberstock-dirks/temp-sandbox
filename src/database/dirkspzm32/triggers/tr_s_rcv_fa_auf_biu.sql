create or replace editionable trigger dirkspzm32.tr_s_rcv_fa_auf_biu before
    insert or update on dirkspzm32.s_rcv_fa_auf
    for each row
declare
    v_error exception;
    v_err_nr         number;
    v_err_text       varchar2(255);
    v_leitzahl_count number;

  -- local variables here
    v_found          boolean;
    v_sid            isi_sid%rowtype;
    v_fa_auftrag     bde_fa_auftrag%rowtype;
    v_ab_artikel_id  bde_fa_auftrag.ab_artikel_id%type;
    v_ag_artikel_id  bde_fa_auftrag.ag_artikel_id%type;
    v_artikel_kd     isi_artikel_kunde%rowtype;
    v_res            isi_resource%rowtype;
    v_fa_hist        bde_fa_auftrag_hist%rowtype;
    v_fa_res         s_rcv_fa_auf_res%rowtype;
    v_charge_id      lvs_charge.charge_id%type;
    cursor c_sid is
    select
        *
    from
        isi_sid s
    where
        s.sid_my_sid = 1;

    cursor c_artikel (
        p_artikel isi_artikel.artikel%type
    ) is
    select
        art.artikel_id
    from
        isi_artikel art
    where
            art.sid = v_sid.sid
        and art.artikel = p_artikel;

    cursor c_artikel_kd is
    select
        *
    from
        isi_artikel_kunde art_kd
    where
            art_kd.sid = v_sid.sid
        and art_kd.artikel_id = v_ag_artikel_id
        and art_kd.kunden_nr = :new.kunden_nr;

    cursor c_fa_auftrag is
    select
        *
    from
        bde_fa_auftrag auft
    where
            auft.sid = v_sid.sid
        and auft.firma_nr = :new.firma_nr
        and auft.leitzahl = :new.leitzahl
        and auft.fa_ag = nvl(:new.fa_ag,
                             0)
        and auft.fa_upos = nvl(:new.fa_upos,
                               0);

    cursor c_res is
    select
        *
    from
        isi_resource res
    where
            res.sid = v_sid.sid
        and res.firma_nr = :new.firma_nr
        and ( res.res_ext_name = :new.maschine
              or res.res_name = :new.maschine );

    cursor c_fa_hist is
    select
        *
    from
        bde_fa_auftrag_hist t
    where
            t.leitzahl = :new.leitzahl
        and t.fa_ag = :new.fa_ag
        and t.fa_upos = :new.fa_upos;

    cursor c_fa_res is
    select
        *
    from
        s_rcv_fa_auf_res t
    where
            t.sid = v_sid.sid
        and t.firma_nr = :new.firma_nr
        and t.leitzahl = :new.leitzahl
        and t.fa_ag = :new.fa_ag
        and t.fa_upos = :new.fa_upos;

    cursor c_fa_res_zust_akt is
    select
        count(*)
    from
        isi_resource_zust_akt t
    where
        t.leitzahl = :new.leitzahl;

begin
  -- c_sid
    open c_sid;
    fetch c_sid into v_sid;
    v_found := c_sid%found;
    close c_sid;
    if not v_found then
        v_sid.sid := '01';
    end if;
    open c_fa_res_zust_akt;
    fetch c_fa_res_zust_akt into v_leitzahl_count;
    close c_fa_res_zust_akt;
    if :new.ag_status != 'L'
    or :new.ag_status is null then
        open c_fa_auftrag;
        fetch c_fa_auftrag into v_fa_auftrag;
        close c_fa_auftrag;

    -- c_artikel: ab_artikel
        open c_artikel(:new.ab_artikel);
        fetch c_artikel into v_ab_artikel_id;
        v_found := c_artikel%found;
        close c_artikel;
        if not v_found then
            v_ab_artikel_id := null;
        end if;

    -- c_artikel: ag_artikel
        open c_artikel(:new.ag_artikel);
        fetch c_artikel into v_ag_artikel_id;
        v_found := c_artikel%found;
        close c_artikel;
        if not v_found then
            if :new.satzart = 'V'
            or :new.satzart = 'MA' then
                v_err_nr := 1;
                v_err_text := 'Fehler:'
                              || '  Fertigungsauftrag '
                              || :new.leitzahl
                              || '/'
                              || :new.fa_ag
                              || ' Artikel <'
                              || :new.ag_artikel
                              || '> fehlt.';

                raise v_error;
            end if;

            v_ag_artikel_id := null;
        end if;

        open c_artikel_kd;
        fetch c_artikel_kd into v_artikel_kd;
        close c_artikel_kd;

    -- c_fa_auftrag
        open c_fa_auftrag;
        fetch c_fa_auftrag into v_fa_auftrag;
        v_found := c_fa_auftrag%found;
        close c_fa_auftrag;

    -- if not already in BDE_FA_AUFTRAG insert new record
        if not v_found then
            if :new.auf_id is null then
                select
                    seq_isi_order_auf_id.nextval
                into :new.auf_id
                from
                    dual;

            end if;

            insert into bde_fa_auftrag auft (
                auft.sid,              -- SID      VARCHAR2(2) not null,
                auft.firma_nr,         -- FIRMA_NR NUMBER(2) not null,
                auft.leitzahl,         -- LEITZAHL NUMBER not null,
                auft.fa_ag,            -- FA_AG              NUMBER,
                auft.fa_upos,          -- FA_UPOS            NUMBER,
                auft.satzart,          -- SATZART            VARCHAR2(2),        returning auft.leitzahl
                auft.ab_ist_mg,        -- AB_IST_MG          NUMBER,
                auft.ag_ist_mg,        -- AG_IST_MG          NUMBER,
                auft.ag_ist_mg_b,      -- AG_IST_MG_B        NUMBER,
                auft.ag_ist_mg_schrott,-- AG_IST_MG_SCHROTT  NUMBER,
                auft.ag_ist_mg_ruesten,-- AG_IST_MG_RUESTEN  NUMBER,
                auft.ruest_zeit_ist,   -- RUEST_ZEIT_IST     NUMBER,
                auft.prod_zeit_ist,    -- PROD_ZEIT_IST      NUMBER,
                auft.stoer_zeit_ist,   -- STOER_ZEIT_IST     NUMBER,
                auft.freig_status,     -- FREIG_STATUS       VARCHAR2(2),
                auft.ag_id
            )            -- AG_ID              VARCHAR2(20),
             values ( v_sid.sid,             -- SID      VARCHAR2(2) not null,
                       :new.firma_nr,         -- FIRMA_NR NUMBER(2) not null,
                       :new.leitzahl,         -- LEITZAHL NUMBER not null,
                       nvl(:new.fa_ag,
                           0),     -- FA_AG              NUMBER,
                       nvl(:new.fa_upos,
                           0),   -- FA_UPOS            NUMBER,
                       :new.satzart,          -- SATZART            VARCHAR2(2),        returning auft.leitzahl
                       nvl(:new.ab_ist,
                           0),    -- AB_IST_MG          NUMBER,
                       nvl(:new.ag_ist_mg,
                           0), -- AG_IST_MG          NUMBER,
                       nvl(:new.ag_ist_mg_b,
                           0),   -- AG_IST_MG_B        NUMBER,
                       nvl(:new.ag_ist_schrott,
                           0),-- AG_IST_MG_SCHROTT  NUMBER,
                       nvl(:new.ag_ist_ruesten,
                           0),-- AG_IST_MG_RUESTEN  NUMBER,
                       nvl(:new.ruest_zeit_ist,
                           0),-- RUEST_ZEIT_IST     NUMBER,
                       nvl(:new.prod_zeit_ist,
                           0), -- PROD_ZEIT_IST      NUMBER,
                       nvl(:new.stoer_zeit_ist,
                           0),-- STOER_ZEIT_IST     NUMBER,
                       'N',                       -- FREIG_STATUS       VARCHAR2(2),
                       nvl(:new.auf_id,
                           0) );       -- AG_ID              VARCHAR2(20),
            :new.ag_status := 'UE';
        end if;

        open c_res;
        fetch c_res into v_res;
        close c_res;
        :new.charge := nvl(:new.charge,
                           :new.leitzahl
                           || '/'
                           || :new.fa_ag);

        if :new.charge is not null then
            v_charge_id := get_charge_id(v_sid.sid,
                                         :new.firma_nr,
                                         null,
                                         :new.charge,
                                         v_ag_artikel_id);
        else
            v_charge_id := null;
        end if;

        v_fa_hist := null;
        open c_fa_hist;
        fetch c_fa_hist into v_fa_hist;
        close c_fa_hist;

    -- if record already exists in BDE_FA_AUFTRAG update record
        update bde_fa_auftrag auft
        set                                                           -- SID                VARCHAR2(2) not null,
                                                                     -- FIRMA_NR           NUMBER(2) not null,
            auft.abnr = :new.auftrag,                 -- ABNR               VARCHAR2(20),
                                                                     -- LEITZAHL           NUMBER not null,
                                                                     -- FA_AG              NUMBER,
                                                                     -- FA_UPOS            NUMBER,
            auft.satzart = :new.satzart,                 -- SATZART            VARCHAR2(2),
            auft.res_id = v_res.res_id,                 -- RES_ID             NUMBER,
                                                                     -- ANZ_RES            NUMBER,
            auft.ab_artikel_id = v_ab_artikel_id,              -- AB_ARTIKEL_ID      NUMBER,
            auft.ab_soll_mg = :new.ab_soll,                 -- AB_SOLL_MG         NUMBER,
                                                                     -- AB_IST_MG          NUMBER,
            auft.ab_text1 = :new.ab_text1,                -- AB_TEXT1           VARCHAR2(255),
            auft.ab_text2 = :new.ab_text2,                -- AB_TEXT2           VARCHAR2(255),
            auft.ab_text3 = :new.ab_text3,                -- AB_TEXT3           VARCHAR2(255),
            auft.ab_ende_status = :new.ab_status,               -- AB_ENDE_STATUS     VARCHAR2(3),
            auft.ag_soll_mg = :new.ag_soll_mg,              -- AG_SOLL_MG         NUMBER,
           -- Da ein Update nur kommen kann, wenn der Auftrag nicht läuft, kann der Wert immer übernommen werden
           -- Diese Änderung war nötig, da im SAP Umfeld bei Aptar (Seaquist) initial manchmal ein falscher Wert
           -- gekommen ist.
            auft.ag_ist_mg = :new.ag_ist_mg,               -- AG_IST_MG          NUMBER,
                                                                     -- AG_IST_MG_B        NUMBER,
                                                                     -- AG_IST_MG_SCHROTT  NUMBER,
                                                                     -- AG_IST_MG_RUESTEN  NUMBER,
            auft.ruest_zeit_gepl = :new.ruest_zeit_gepl,         -- RUEST_ZEIT_GEPL    NUMBER,
                                                                     -- RUEST_ZEIT_IST     NUMBER,
            auft.prod_zeit_gepl = :new.prod_zeit_gepl,          -- PROD_ZEIT_GEPL     NUMBER,
                                                                     -- PROD_ZEIT_IST      NUMBER,
            auft.stoer_zeit_gepl = :new.stoer_zeit_gepl,         -- STOER_ZEIT_GEPL    NUMBER,
                                                                     -- STOER_ZEIT_IST     NUMBER,
            auft.zeit_einheit = :new.zeit_einheit,            -- ZEIT_EINHEIT       NUMBER,
            auft.termin_start_gepl = nvl(auft.termin_start_gepl,
                                         :new.start_gepl),         -- TERMIN_START_GEPL  DATE,
            auft.termin_ende_gepl = :new.ende_gepl,               -- TERMIN_ENDE_GEPL   DATE,
                                                                     -- TERMIN_START_IST   DATE,
                                                                     -- TERMIN_ENDE_IST    DATE,
            auft.freig_status = nvl(:new.freig_status,
                                    auft.freig_status),       -- FREIG_STATUS       VARCHAR2(3),
                                                                     -- FREIG_WER          NUMBER,
                                                                     -- FREIG_WANN         DATE,
                                                                     -- STATUS_RES_ID      NUMBER,
                                                                     -- STATUS_ID          NUMBER,
                                                                     -- SATTUS_BEGIN       DATE,
            auft.kunden_nr = :new.kunden_nr,               -- KUNDEN_NR          NUMBER,
            auft.ag_artikel_id = v_ag_artikel_id,              -- AG_ARTIKEL_ID      NUMBER,
            auft.kd_art_nr = nvl(:new.kd_art_nr,
                                 v_artikel_kd.kd_art_nr),      -- KD_ART_NR          VARCHAR2(30),
            auft.ag_bez1 = :new.ag_bez1,                 -- AG_BEZ1            VARCHAR2(255),
            auft.ag_bez2 = :new.ag_bez2,                 -- AG_BEZ2            VARCHAR2(255),
            auft.ag_text1 = :new.ag_text1,                -- AG_TEXT1           VARCHAR2(255),
            auft.ag_text2 = :new.ag_text2,                -- AG_TEXT2           VARCHAR2(255),
            auft.ag_text3 = :new.ag_text3,                -- AG_TEXT3           VARCHAR2(255),
            auft.zeichnung = :new.zeichnung,               -- ZEICHNUNG          VARCHAR2(255),
                                                                     -- SCHROTT_PROZ       NUMBER,
                                                                     -- NUTZEN             NUMBER,
                                                                     -- GEWICHT            NUMBER,
                                                                     -- SCHROTT            NUMBER,
                                                                     -- VERBRAUCH          NUMBER,
                                                                     -- EINSATZ            NUMBER,
            auft.max_takt_ausf_zeit = :new.max_tak_ausf_zeit,       -- MAX_TAKT_AUSF_ZEIT NUMBER,
            auft.min_takt_zeit = :new.min_tak_zeit,            -- MIN_TAKT_ZEIT      NUMBER,
            auft.max_takt_zeit = :new.max_tak_zeit,            -- MAX_TAKT_ZEIT      NUMBER,
                                                                     -- STATUS_FREIGABE    NUMBER,
            auft.ag_id = :new.auf_id,                  -- AG_ID              VARCHAR2(20),
            auft.charge_id = v_charge_id,                  -- CHARGE_ID          NUMBER,
            auft.lhm_name = :new.lhm_name,                -- LHM_NAME           VARCHAR2(10),
            auft.lhm_menge = decode(
                nvl(:new.lhm_menge,
                    0),
                0,
                auft.lhm_menge,
                :new.lhm_menge
            ),       -- LAM_MENG           NUMBER,
                                                                     -- KENZ_LETZT_AG      NUMBER(1),
            auft.lte_name = :new.lte_name,                -- LTE_NAME           VARCHAR2(10),
            auft.lte_menge = :new.lte_menge,               -- LTE_MENG           NUMBER,
            auft.zeichnung_index = :new.zeichnung_index,         -- ZEICHNUNG_INDEX   VARCHAR2(2),
            auft.best_nr_kunde = :new.best_nr_kunde,           -- BEST_NR_KUNDE      VARCHAR2(30),
            auft.kenz_lhm_druck = :new.kenz_lhm_druck,          -- KENZ_LHM_DRUCK     VARCHAR2(1)
            auft.mde_ist_mg = v_fa_hist.mde_ist_mg,         -- MDE_IST_MG  NUMBER  Y      Bereits gefertigte Menge in diesem AG aus MDE
            auft.mde_ist_mg_b = v_fa_hist.mde_ist_mg_b,       -- MDE_IST_MG_B  NUMBER  Y      Angefalle Menge in B-Qualität für diesen AG aus MDE
            auft.mde_ist_mg_schrott = v_fa_hist.mde_ist_mg_schrott, -- MDE_IST_MG_SCHROTT  NUMBER  Y      Angefalle Schrottmenge für diesen AG aus MDE
            auft.mde_ist_mg_ruesten = v_fa_hist.mde_ist_mg_ruesten, -- MDE_IST_MG_RUESTEN  NUMBER  Y      Angefalle Menge beim Rüsten und Anfahren für diesen AG aus MDE
            auft.mde_micro_stop = v_fa_hist.mde_micro_stop,     -- MDE_MICRO_STOP  NUMBER  Y      Angefallene Microstops aus MDE
            auft.mde_ist_mg_t = v_fa_hist.mde_ist_mg_t,       -- MDE_IST_MG_T  NUMBER  Y      Bereits gefertigte Menge in diesem AG aus MDE Tag
            auft.mde_ist_mg_b_t = v_fa_hist.mde_ist_mg_b_t,     -- MDE_IST_MG_B_T  NUMBER  Y      Angefalle Menge in B-Qualität für diesen AG aus MDE Tag
            auft.mde_ist_mg_schrott_t = v_fa_hist.mde_ist_mg_schrott_t,-- MDE_IST_MG_SCHROTT_T  NUMBER  Y      Angefalle Schrottmenge für diesen AG aus MDE Tag
            auft.mde_ist_mg_ruesten_t = v_fa_hist.mde_ist_mg_ruesten_t,-- MDE_IST_MG_RUESTEN_T  NUMBER  Y      Angefalle Menge beim Rüsten und Anfahren für diesen AG aus MDE Tag
            auft.mde_micro_stop_t = v_fa_hist.mde_micro_stop_t,   -- MDE_MICRO_STOP_T  NUMBER  Y      Angefallene Microstops aus MDE Tag
            auft.lte_lhm_lagen = :new.lte_lhm_lagen,           -- LTE_LHM_LAGEN  NUMBER(2)  Y      Aus ISI_ARTIKEL oder Schnittstelle
            auft.lte_lhm_pro_lage = :new.lte_lhm_pro_lage,        -- LTE_LHM_PRO_LAGE  NUMBER(2)  Y      Aus ISI_ARTIKEL oder Schnittstelle
                                                                     -- LTE_ANZ  NUMBER  Y      Sollmenge Anz. LTE
                                                                     -- LTE_ANZ_IST  NUMBER  Y      Istmenge Anz. LTE
                                                                     -- LHM_ANZ  NUMBER  Y      Sollmenge Anz. Gebinde
                                                                     -- LHM_ANZ_IST  NUMBER  Y      Istmenge Anz. Gebinde
                                                                     -- ABFUELL_ABSCHALT_GROB  NUMBER  Y      Absch. Grob
                                                                     -- ABFUELL_ABSCHALT_MITTEL  NUMBER  Y      Absch. Mittel
                                                                     -- ABFUELL_ABSCHALT_FEIN  NUMBER  Y      Absch. Fein
                                                                     -- ABFUELL_TOLERANZ_PLUS  NUMBER  Y      Toleranz Plus
                                                                     -- ABFUELL_TOLERANZ_MINUS  NUMBER  Y      Toleranz Minus
                                                                     -- ABFUELL_SILO  VARCHAR2(30)  Y      Silo für Abfüllung
                                                                     -- ABFUELL_SOLL  NUMBER  Y      Sollmenge für die Abfüllung
            auft.prod_params = :new.prod_params,             -- PROD_PARAMS  VARCHAR2(4000)  Y      Optional: Parameter die ggf. zusammen mit dem Maschinenprogr. an die Resource gesendet werden.
                                                                     -- NIO_RES_ID  NUMBER  Y      Resource, auf der NIO Teile Nachbearbeitet werden können. Kann auch als Ausschleuspunkt genutzt werden
                                                                     -- QUITT_GRUPPE_AG  NUMBER  Y      Quittierungs-Gruppe der quittierenden Pos_Nr, sonst eigene Pos_Nr.
                                                                     -- PROD_MENGE_P_EINHEIT  NUMBER  Y  1    Menge je Einheit als Abs. Multiplikator oder Divisor. Bedarfsmenge zum AG
                                                                     -- PROD_MENGE_P_EINHEIT_OP  VARCHAR2(10)  Y  'MUL'    'ABS' = Absolute -> Immer genau diese Menge 'MUL' = Multiplizieren, 'DIV' = Dividieren
            auft.kunden_nr_adr_liefer = :new.kunden_nr_adr_liefer,    -- kunden_nr_adr_liefer
            auft.ag_los_mg = :new.ag_los_mg,               -- AG_LOS_MG  NUMBER  Y      Sollmenge in diesem AG die als Produktionsmenge zur Maschiene gesendet werden soll (Teilmenge für dieses Produktionslos)
            auft.rcv_ag_ist_mg = :new.rcv_ag_ist_mg,           -- RCV_AG_IST_MG  NUMBER  Y      Bereits gefertigte Menge in diesem AG die zum HOST gesendet wurde
            auft.rcv_ag_ist_mg_b = :new.rcv_ag_ist_mg_b,         -- RCV_AG_IST_MG_B  NUMBER  Y      Angefalle Menge in B-Qualität für diesen AG die zum HOST gesendet wurde
            auft.rcv_ag_ist_mg_schrott = :new.rcv_ag_ist_mg_schrott,   -- RCV_AG_IST_MG_SCHROTT  NUMBER  Y      Angefalle Schrottmenge für diesen AG die zum HOST gesendet wurde
            auft.rcv_ag_ist_mg_ruesten = :new.rcv_ag_ist_mg_ruesten,   -- RCV_AG_IST_MG_RUESTEN  NUMBER  Y      Angefalle Menge beim Rüsten und Anfahren für diesen AG die zum HOST gesendet wurde
            auft.rcv_ruest_zeit_ist = :new.rcv_ruest_zeit_ist,      -- RCV_RUEST_ZEIT_IST  NUMBER  Y      Angefallene Rüstzeit in Minuten die zum HOST gesendet wurde
            auft.rcv_prod_zeit_ist = :new.rcv_prod_zeit_ist,       -- RCV_PROD_ZEIT_IST  NUMBER  Y      Angefallene netto Produktionszeit in Minuten die zum HOST gesendet wurde
            auft.rcv_stoer_zeit_ist = :new.rcv_stoer_zeit_ist,      -- RCV_STOER_ZEIT_IST  NUMBER  Y      Angefallene netto Produktionszeit in Minuten die zum HOST gesendet wurde
                                                                     -- PACKSCHEMA_KOPF_ID  N VARCHAR2(20)  Y     ID / Name des Packschemas
            auft.ag_art_laenge = :new.ag_art_laenge,                  -- AG_ART_LAENGE N NUMBER  Y     Länge
            auft.ag_art_breite = :new.ag_art_breite,                  -- AG_ART_BREITE N NUMBER  Y     Breite
            auft.ag_art_dicke = :new.ag_art_dicke,                    -- AG_ART_DICKE  N NUMBER  Y     Dicke
            auft.ag_art_durch = :new.ag_art_durch,                    -- AG_ART_DURCH  N NUMBER  Y     Durchmesser
            auft.kunden_ab = :new.kunden_ab,                          -- KUNDEN_AB N VARCHAR2(20)  Y     AB Nummer des Kundenauftrags
            auft.kunden_ab_pos = :new.kunden_ab_pos,                  -- KUNDEN_AB_POS N VARCHAR2(20)  Y     AB Positionsnummer des Kundenauftrags
            auft.kunden_ab_upos = :new.kunden_ab_upos,                -- KUNDEN_AB_UPOS  N VARCHAR2(20)  Y     AB Unterposition des Kundenauftrags
            auft.term_wunsch = :new.term_wunsch,                      -- TERM_WUNSCH N DATE  Y     Wunschtermin in dd.mm.yyyy hh24:mi:ss
            auft.term_best = :new.term_best,                          -- TERM_BEST N DATE  Y     Bestätigter Termin in dd.mm.yyyy hh24:mi:ss
            auft.transp_zeit = :new.transp_zeit,                      -- TRANSP_ZEIT N NUMBER  Y     Transportzeit für die Lieferung zum Kunden in STD
            auft.anz_rohstoffe = :new.anz_rohstoffe,                  -- ANZ_ROHSTOFFE N NUMBER  Y     Anzahl der benötigten Drähte
            auft.ausgef_ende = :new.ausgef_ende,                      -- AUSGEF_ENDE N VARCHAR2(1) Y     AUSGEFÜHRTES ENDE
            auft.ag_prod_frei = :new.ag_prod_frei,                    -- AG_PROD_FREI  N VARCHAR2(1) Y     T = Freigegeben für Produktion, F = Nur für Planung
            auft.ag_ueberlappen = :new.ag_ueberlappen,                -- AG_UEBERLAPPEN  N NUMBER(12,3)  Y     Anzahl die fertig sein müssen, um den  nächsten AG zu beginnen nächsten AG zu beginne
            auft.ag_opt_grp = :new.ag_opt_grp,
            auft.prioritaet = :new.prioritaet,
            auft.vorgangsqualifikation = :new.vorgangsqualifikation,
            auft.anz_mitarbeiter = :new.anz_mitarbeiter,
            auft.lueckenfueller = :new.lueckenfueller,
            auft.start_batch_by_order_start = :new.start_batch_by_order_start,
            auft.termin_start_frueh = :new.start_gepl,
            auft.ext_arbeits_anweisung = :new.ext_arbeits_anweisung,
            auft.kunden_ab_text = :new.kunden_ab_text,
            auft.seq_nr = :new.seq_nr,                               -- SEQ_NR  N NUMBER  Y     N   Sequenz-Nummer, für das Zielprodukt auf der Fertigungslinie Montage - Ab DB31
            auft.lead_leitzahl = :new.lead_leitzahl,                 -- LEAD_LEITZAHL N NUMBER  Y     N   Leitzahl des Vorgängerauftrags
            auft.primaer_leitzahl = :new.primaer_leitzahl,           -- PRIMAER_LEITZAHL  N NUMBER  Y     N   Leitzahl des Primärauftrag
            auft.fremd_zeichnung = :new.fremd_zeichnung,
            auft.zeichnungname = :new.zeichnungname
        where
                auft.sid = v_sid.sid
            and auft.firma_nr = :new.firma_nr
            and auft.leitzahl = :new.leitzahl
            and auft.fa_ag = nvl(:new.fa_ag,
                                 0)
            and auft.fa_upos = nvl(:new.fa_upos,
                                   0);

        update bde_fa_auftrag
        set
            kenz_letzt_ag = null
        where
                sid = v_sid.sid
            and firma_nr = :new.firma_nr
            and leitzahl = :new.leitzahl;

    -- -AG- 202190327 Einbau der Tabelle wenn eine FA erstellt wurde
        delete s_rcv_fa_auf_rel t
        where
            t.leitzahl = :new.leitzahl;

        update bde_fa_auftrag f1
        set
            kenz_letzt_ag = 1
        where
                f1.sid = v_sid.sid
            and f1.firma_nr = :new.firma_nr
            and f1.leitzahl = :new.leitzahl
            and f1.fa_ag = (
                select
                    max(f2.fa_ag)
                from
                    bde_fa_auftrag f2
                where
                        f1.sid = f2.sid
                    and f1.firma_nr = f2.firma_nr
                    and f1.leitzahl = f2.leitzahl
                    and f2.satzart like ( 'V%' )
                group by
                    f2.sid,
                    f2.firma_nr,
                    f2.leitzahl
            )
            and f1.fa_upos = (
                select
                    max(f2.fa_upos)
                from
                    bde_fa_auftrag f2
                where
                        f1.sid = f2.sid
                    and f1.firma_nr = f2.firma_nr
                    and f1.leitzahl = f2.leitzahl
                    and f1.fa_ag = f2.fa_ag
                    and f2.satzart like ( 'V%' )
                group by
                    f2.sid,
                    f2.firma_nr,
                    f2.leitzahl,
                    f2.fa_ag
            );
    -- -AG- 202190327 Einbau der Tabelle wenn eine FA erstellt wurde
        insert into s_rcv_fa_auf_rel
            select
                *
            from
                bde_v_gen_bde_fa_auftrag_rel t
            where
                t.leitzahl = :new.leitzahl;

    -- -AG- 20200713 Einbau der Tabelle wenn eine FA erstellt wurde
        delete bde_fa_auftrag_stl t
        where
            t.leitzahl = :new.leitzahl;

        insert into bde_fa_auftrag_stl
            select
                *
            from
                bde_v_gen_bde_fa_auftrag_stl t
            where
                t.leitzahl = :new.leitzahl;

        open c_fa_res;
        fetch c_fa_res into v_fa_res;
        v_found := c_fa_res%found;
        close c_fa_res;
        if
            not v_found
            and :new.satzart like 'V%'
            and v_res.res_id is not null
        then
            insert into s_rcv_fa_auf_res values ( v_sid.sid,
                                                  :new.firma_nr,
                                                  :new.auf_id,
                                                  :new.auftrag,
                                                  :new.leitzahl,
                                                  :new.fa_ag,
                                                  :new.fa_upos,
                                                  :new.satzart,
                                                  v_res.res_id,
                                                  :new.prod_zeit_gepl,
                                                  :new.ruest_zeit_gepl );

        end if;

    else
        if :old.ag_status like 'A%' then
            v_err_nr := 10;
            v_err_text := 'Fehler:'
                          || '  Fertigungsauftrag '
                          || :old.leitzahl
                          || '/'
                          || :old.fa_ag
                          || ' mit Status <'
                          || :old.ag_status
                          || '> darf nicht gelöscht werden.';

            raise v_error;
        elsif v_leitzahl_count > 0 then
      -- TS20131017: wenn der Fertigungsauftrag in Resource Zustand Aktuell an einer Maschine angemeldet ist, nicht löschen
            v_err_nr := 10;
            v_err_text := 'Fehler:'
                          || '  Fertigungsauftrag '
                          || :new.leitzahl
                          || ' ist bereits angemeldet und darf nicht mehr gelöscht werden!';
            raise v_error;
        else
    -- c_fa_auftrag
            open c_fa_auftrag;
            fetch c_fa_auftrag into v_fa_auftrag;
            close c_fa_auftrag;
     --if v_fa_auftrag.kenz_letzt_ag = 1 then
            delete bde_fa_auftrag auft
            where
                    auft.sid = v_sid.sid
                and auft.firma_nr = :new.firma_nr
                and auft.leitzahl = :new.leitzahl
                and auft.fa_ag = :new.fa_ag
                and nvl(auft.fa_upos, 0) = nvl(:new.fa_upos,
                                               0);

            update bde_fa_auftrag
            set
                kenz_letzt_ag = null
            where
                    sid = v_sid.sid
                and firma_nr = :new.firma_nr
                and leitzahl = :new.leitzahl;

            update bde_fa_auftrag f1
            set
                kenz_letzt_ag = 1
            where
                    f1.sid = v_sid.sid
                and f1.firma_nr = :new.firma_nr
                and f1.leitzahl = :new.leitzahl
                and f1.fa_ag = (
                    select
                        max(f2.fa_ag)
                    from
                        bde_fa_auftrag f2
                    where
                            f1.sid = f2.sid
                        and f1.firma_nr = f2.firma_nr
                        and f1.leitzahl = f2.leitzahl
                        and f2.satzart like ( 'V%' )
                    group by
                        f2.sid,
                        f2.firma_nr,
                        f2.leitzahl
                )
                and f1.fa_upos = (
                    select
                        max(f2.fa_upos)
                    from
                        bde_fa_auftrag f2
                    where
                            f1.sid = f2.sid
                        and f1.firma_nr = f2.firma_nr
                        and f1.leitzahl = f2.leitzahl
                        and f1.fa_ag = f2.fa_ag
                        and f2.satzart like ( 'V%' )
                    group by
                        f2.sid,
                        f2.firma_nr,
                        f2.leitzahl,
                        f2.fa_ag
                );

     --end if;
            delete s_rcv_fa_auf_fhm t
            where
                    t.sid = v_sid.sid
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag;

            delete s_rcv_fa_auf_res t
            where
                    t.sid = v_sid.sid
                and t.firma_nr = :new.firma_nr
                and t.leitzahl = :new.leitzahl
                and t.fa_ag = :new.fa_ag
                and t.fa_upos = :new.fa_upos;
    -- -AG- 202190327 Einbau der Tabelle wenn eine FA erstellt wurde
            delete s_rcv_fa_auf_rel t
            where
                t.leitzahl = :new.leitzahl;

            insert into s_rcv_fa_auf_rel
                select
                    *
                from
                    bde_v_gen_bde_fa_auftrag_rel t
                where
                    t.leitzahl = :new.leitzahl;

     -- -AG- 20190917 - Einbau mitarbeiteranmeldung an Maschine zu FA mit Arbeitszeiterfassung
            insert into s_send_bew send values ( null,                    -- BEW_ID          NUMBER,
                                                 :new.firma_nr,           -- FIRMA_NR        NUMBER(3),
                                                 'ISI',                   -- HERKUNFT        VARCHAR2(3),
                                                 'S_FA',                  -- TABELLE         VARCHAR2(5),
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
                                                 null,                    -- RES_ID          NUMBER
                                                 null,                    -- SEND_ID         NUMBER
                                                 null,                    -- MA_LAST_S_GRUND NUMBER
                                                 null,                    -- PERS_NR         NUMBER
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
                                                 null,                   -- ORDER_POS_AUF_ID N NUMBER  Y     Reserveriert für Auftrag in ISI_Order (oder -1 = für manuelle Auslagerung, -2 = für manuelle Umlagerung)
                                                 null,                    -- RUEST_ZEIT_ERF  N NUMBER(*,12)  Y     N   Erfasste Rüstzeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
                                                 null );                   -- PROD_ZEIT_ERF N NUMBER(*,12)  Y     N   Erfasste netto Produktionszeit in Minuten - Aus Anmeldungen in BDE_PROD_KOPF_MA - Mitarbeiterstunden
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
end tr_s_rcv_fa_auf_biu;
/

alter trigger dirkspzm32.tr_s_rcv_fa_auf_biu enable;


-- sqlcl_snapshot {"hash":"83a7a829aa55b0df4f160681ee5cb51914b3563b","type":"TRIGGER","name":"TR_S_RCV_FA_AUF_BIU","schemaName":"DIRKSPZM32","sxml":""}