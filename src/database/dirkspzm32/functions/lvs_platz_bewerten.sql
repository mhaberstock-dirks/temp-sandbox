create or replace function dirkspzm32.lvs_platz_bewerten (
    in_sid                 in lvs_lgr.sid%type,
    in_firma_nr            in lvs_lgr.firma_nr%type,
    in_lgr_ort_typ         in lvs_lgr.lgr_typ%type,
    in_res_string          in lvs_lte.res_string%type,
    in_lte_res_art         in lvs_lte.res_artikel_id%type,
    in_lte_abc             in lvs_lte.abc%type,
    in_lte_waren_typ       in lvs_lte.waren_typ%type,
    in_lgr_platz_gruppe    in lvs_lgr.lgr_platz_gruppe%type,
    in_lgr_res_artikel_id  in lvs_lgr.res_artikel_id%type,
    in_lgr_res_string      in lvs_lgr.res_string%type,
    in_lgr_abc             in lvs_lgr.abc%type,
    in_ref_dim_lager_platz in lvs_lgr.lgr_dim_platz%type,
    in_ref_dim_lager_ort   in lvs_lgr.lgr_ort%type,
    in_lte_lte_akt_kg      in lvs_lte.lte_akt_kg%type,
    in_lte_lte_vol_hoehe   in lvs_lte.lte_vol_hoehe%type,
    in_lte_lte_vol_tiefe   in lvs_lte.lte_vol_tiefe%type,
    in_lte_lte_vol_breite  in lvs_lte.lte_vol_breite%type,
    in_lgr_platz           in lvs_lgr.lgr_platz%type,
    in_lgr_opti            in lvs_lgr_ort.lgr_einl_opti%type,
    in_sych_transport      in isi_transport.lgr_platz_quelle%type,
    in_fahrzeuge_ids       in varchar2,
    in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
    in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
    in_lgr_dim_g           in lvs_lgr.lgr_dim_g%type,
    in_lgr_dim_r           in lvs_lgr.lgr_dim_r%type,
    in_lgr_dim_p           in lvs_lgr.lgr_dim_p%type,
    in_lgr_dim_e           in lvs_lgr.lgr_dim_e%type,
    in_lgr_dim_t           in lvs_lgr.lgr_dim_t%type,
    in_r_g_u_gegenueber    in lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type,
    in_lgr                 in lvs_lgr%rowtype
) return number is
    -------------------------------------------------------------------------
    v_error exception;
    v_err_nr                     number;
    v_err_text                   varchar2(255);
    v_ref_dim_lager_platz        lvs_lgr.lgr_dim_platz%type;
    v_found                      boolean;
    v_fuellgrad                  number;
    v_fuellgrad_seg              number;
    v_multiplikator              number;
    v_dispo_faktor_seg           number;
    v_lgr_regal_ebene_faktor_seg number;
    v_lgr_dim_platz_seg          lvs_lgr.lgr_dim_platz%type;
    v_lgr_dim_ort_seg            lvs_lgr.lgr_ort%type;
    v_max_kg_seg                 lvs_lgr.lgr_max_kg%type;
    v_akt_kg_seg                 lvs_lgr.lgr_akt_kg%type;
    v_frei_hoehe_seg             lvs_lgr.lgr_frei_hoehe%type;
    v_frei_breite_seg            lvs_lgr.lgr_frei_breite%type;
    v_frei_tiefe_seg             lvs_lgr.lgr_frei_tiefe%type;
    v_fuellgrad_seg_akt          number;
    v_sonst_faktor               number;
    v_dispo_faktor               number;
    v_lgr_platz_gegenueber       lvs_lgr.lgr_platz_gruppe_gegenueber%type;
    v_lgr_gruppe                 lvs_lgr.gruppe%type;
    v_lgr_dim_platz              lvs_lgr.lgr_dim_platz%type;
    v_lgr_dim_platz_calc         lvs_lgr.lgr_dim_platz%type;
    v_lgr_dim_tiefe              lvs_lgr.lgr_dim_platz%type;
    v_lgr_dim_p                  lvs_lgr.lgr_dim_p%type;
    v_lgr_dim_t                  lvs_lgr.lgr_dim_platz%type;
    v_lgr_dim_ort                lvs_lgr.lgr_ort%type;
    v_max_kg                     lvs_lgr.lgr_max_kg%type;
    v_akt_kg                     lvs_lgr.lgr_akt_kg%type;
    v_max_te                     lvs_lgr.lgr_max_te%type;
    v_akt_te                     lvs_lgr.lgr_akt_te%type;
    v_diff                       number;
    v_frei_hoehe                 lvs_lgr.lgr_frei_hoehe%type;
    v_frei_breite                lvs_lgr.lgr_frei_breite%type;
    v_frei_tiefe                 lvs_lgr.lgr_frei_tiefe%type;
    v_lgr_dim_fifo               lvs_lgr.lgr_dim_fifo_nr%type;
    v_lgr_einl_te_v              lvs_lgr.lgr_einl_te_verfueg%type;
    v_lgr_ausl_te_d              lvs_lgr.lgr_einl_te_verfueg%type;
    v_r_g_u_gegenueber           lvs_lgr_ort.lgr_dim_r_g_u_gegenueber%type;
    v_ort                        lvs_lgr_ort%rowtype;
    cursor c_lgr_kanal is
    select
        ( ( sum(lgr2.lgr_dispo_ausl_te * v_ort.strat_platz_ausl_dispo /* C.LGR_PLATZ_AUSL_DISPO */) + 1 ) + sum(nvl(lgr2.lgr_order_res_te
        , 0) * v_ort.strat_order_reservierung /*C.LGR_ORDER_RESERVIERUNG*/) ) * ( decode(
            nvl(in_lgr_res_string, ''),
                    -- Jetzt sind die werte im Lagerort
            in_res_string,
            min(v_ort.strat_platz_res_string), -- C.LGR_PLATZ_RES_STRING,
            decode(in_lgr_res_string,
                   null,
                   min(v_ort.strat_platz_leer), -- C.LGR_PLATZ_LEER,
                   decode(in_lgr_res_string,
                          c.lgr_m_k,
                          min(v_ort.strat_platz_misch_kanal), -- C.LGR_PLATZ_MISCH_KANAL,
                          decode(in_lgr_res_string,
                                 c.lgr_m_p,
                                 min(v_ort.strat_platz_falsch), -- C.LGR_PLATZ_MISCH_PAL,
                                 min(v_ort.strat_platz_falsch) -- c.LGR_PLATZ_FALSCH
                                 )))
        ) ) as ausl_dispo_faktor,
        decode(in_lte_waren_typ,
               c.fertigware,
               min(v_ort.strat_regal_hoehe_fw), -- C.LGR_HOEHE_FW_WERT,
               decode(in_lte_waren_typ,
                      c.rohware,
                      min(v_ort.strat_regal_hoehe_rw), -- C.LGR_HOEHE_RW_WERT,
                      decode(in_lte_waren_typ,
                             c.halbware,
                             min(v_ort.strat_regal_hoehe_hw), -- C.LGR_HOEHE_HW_WERT,
                             decode(in_lte_waren_typ,
                                    c.mischpal,
                                    min(v_ort.strat_regal_hoehe_mp), -- C.LGR_HOEHE_MP_WERT,
                                    0)))) * min(lgr2.lgr_dim_e),
        min(lgr2.lgr_dim_platz),
        min(lgr2.lgr_ort),
        sum(lgr2.lgr_max_te),
        sum(lgr2.lgr_akt_te),
        max(lgr2.lgr_max_kg),
        min(lgr2.lgr_akt_kg),
        max(lgr2.lgr_frei_hoehe),
        max(lgr2.lgr_frei_breite),
        max(lgr2.lgr_frei_tiefe),
        max(lgr2.lgr_einl_te_verfueg_gruppe)
    from
        lvs_lgr lgr2
    where
            lgr2.sid = in_sid
        and lgr2.firma_nr = in_firma_nr
        and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
        and ( ( lgr2.lgr_dim_g = in_lgr_dim_g
                and lgr2.lgr_dim_r = in_lgr_dim_r
                and lgr2.lgr_dim_p = in_lgr_dim_p
                and lgr2.lgr_dim_e = in_lgr_dim_e )
              or ( lgr2.lgr_typ != c.seg1
                   and lgr2.lgr_typ != c.seg_duedo1 ) )
    group by
        lgr2.lgr_platz_gruppe,
        lgr2.abc;

    cursor c_lgr_kanal_block is
    select
        max(lte.lte_letzte_buchung),
        min(lgr2.lgr_dim_platz),
        min(lgr2.lgr_dim_p),
        min(lgr2.lgr_dim_t),
        min(lgr2.lgr_ort),
        max(lgr2.lgr_max_kg),
        min(lgr2.lgr_akt_kg),
        max(lgr2.lgr_frei_hoehe),
        max(lgr2.lgr_frei_breite),
        max(lgr2.lgr_frei_tiefe)
    from
        lvs_lte lte,
        lvs_lgr lgr2
    where
            lgr2.sid = in_sid
        and lgr2.firma_nr = in_firma_nr
        and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
        and lte.res_artikel_id (+) = to_char(in_lte_res_art)
        and lte.lgr_platz (+) = lgr2.lgr_platz
    group by
        lte.lgr_platz_gruppe,
        lgr2.lgr_ort; --,
             --lgr2.lgr_dim_platz,
             --lgr2.lgr_max_kg, lgr2.lgr_akt_kg,
             --lgr2.lgr_frei_hoehe, lgr2.lgr_, lgr2.lgr_frei_tiefe;
    cursor c_lgr_block is
    select
        count(lte.lte_id) + count(lte2.lte_id)      as ausl_dispo_faktor,
        ( decode((power((count(lte.lte_id) + count(lte2.lte_id)) * min(v_ort.strat_lgr_platz_akt_lte) /* C.LGR_PLATZ_AKT_LTE */,
                        2)),
                 0,
                 decode(
                      sum(lgr2.lgr_max_te),
                      sum(lgr2.lgr_einl_te_verfueg),
                      1,
                      0.001
                  ),
                 (power((count(lte.lte_id) + count(lte2.lte_id)) * min(v_ort.strat_lgr_platz_akt_lte) /* C.LGR_PLATZ_AKT_LTE */,
                        2))) * ( sum(lgr2.lgr_einl_te_verfueg) * min(v_ort.strat_lgr_platz_verfueg) /* C.LGR_PLATZ_VERFUEG */ + 1 ) ) / (
                        ( sum(lgr2.lgr_dispo_ausl_te) * min(v_ort.strat_platz_ausl_dispo) /* C.LGR_PLATZ_AUSL_DISPO */ + 1 + nvl(
            sum(lgr2.lgr_order_res_te),
            0
        ) * min(v_ort.strat_order_reservierung) /*C.LGR_ORDER_RESERVIERUNG*/ ) ) as ausl_dispo_bestand,
        nvl(
            max(lte2.lte_letzte_buchung),
            max(lte.lte_letzte_buchung)
        )                                           l_buchung,
        min(lgr2.lgr_dim_platz),
        min(lgr2.lgr_ort),
        max(lgr2.lgr_max_kg),
        min(lgr2.lgr_akt_kg),
        max(lgr2.lgr_frei_hoehe),
        max(lgr2.lgr_frei_breite),
        max(lgr2.lgr_frei_tiefe)
    from
        lvs_lgr lgr2,
        lvs_lte lte,
        lvs_lte lte2
    where
            lgr2.sid = in_sid
        and lgr2.firma_nr = in_firma_nr
        and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe
        and lte.sid (+) = in_sid
        and lte.firma_nr (+) = in_firma_nr
        and lte.lgr_platz_gruppe (+) = lgr2.lgr_platz_gruppe
        and lte.res_artikel_id (+) = in_lte_res_art
        and lte2.sid (+) = in_sid
        and lte2.firma_nr (+) = in_firma_nr
        and lte2.ziel_lgr_platz (+) = lgr2.lgr_platz
        and lte2.res_artikel_id (+) = in_lte_res_art
    group by
        lgr2.lgr_ort,
        lgr2.lgr_platz_gruppe,
                -- -AG- --lgr2.lgr_dim_platz,
        lte.lgr_platz_gruppe,
        lte2.lgr_platz_gruppe;

    cursor c_lgr_epl is
    select
        lgr2.lgr_dim_platz,
        lgr2.lgr_ort,
        lgr2.lgr_max_kg,
        lgr2.lgr_akt_kg,
        lgr2.lgr_frei_hoehe,
        lgr2.lgr_frei_breite,
        lgr2.lgr_frei_tiefe
    from
        lvs_lgr lgr2
    where
            lgr2.sid = in_sid
        and lgr2.firma_nr = in_firma_nr
        and lgr2.lgr_platz_gruppe = in_lgr_platz_gruppe;

    cursor c_lgr_sat_epl_platz is
    select
        lgr.lgr_dim_platz,
        lgr.lgr_dim_p,
        lgr.lgr_ort,
        lgr.lgr_max_kg,
        lgr.lgr_akt_kg,
        lgr.lgr_frei_hoehe,
        lgr.lgr_frei_breite,
        lgr.lgr_frei_tiefe,
        lgr.lgr_dim_fifo_nr,
        lgr.gruppe,
        lgr.lgr_platz_gruppe_gegenueber,
        decode(in_lte_waren_typ,
               c.fertigware,
               v_ort.strat_regal_hoehe_fw, -- C.LGR_HOEHE_FW_WERT,
               decode(in_lte_waren_typ,
                      c.rohware,
                      v_ort.strat_regal_hoehe_rw, -- C.LGR_HOEHE_RW_WERT,
                      decode(in_lte_waren_typ,
                             c.halbware,
                             v_ort.strat_regal_hoehe_hw, -- C.LGR_HOEHE_HW_WERT,
                             decode(in_lte_waren_typ, c.mischpal, v_ort.strat_regal_hoehe_mp, -- C.LGR_HOEHE_MP_WERT,
                              0)))) * lgr.lgr_dim_e,
        lgr.lgr_einl_te_verfueg_gruppe
    from
        lvs_lgr lgr
    where
            lgr.sid = in_sid
        and lgr.firma_nr = in_firma_nr
        and lgr.lgr_platz = in_lgr_platz;

    cursor c_lgr_sat_epl_gegenueber is
    select
        lgr2.lgr_einl_te_verfueg,
        lgr2.lgr_dispo_ausl_te
    from
        lvs_lgr lgr2
    where
            lgr2.sid = in_sid
        and lgr2.firma_nr = in_firma_nr
        and lgr2.lgr_platz = v_lgr_platz_gegenueber;

    cursor c_lgr_sat_epl_gruppe is
    select
        sum(lgr2.lgr_einl_te_verfueg),
        sum(lgr2.lgr_dispo_ausl_te)
    from
        lvs_lgr lgr2
    where
            lgr2.sid = in_sid
        and lgr2.firma_nr = in_firma_nr
        and lgr2.gruppe = v_lgr_gruppe
        and lgr2.lgr_dispo_ausl_te > 0
    group by
        lgr2.gruppe;

begin
    v_ref_dim_lager_platz := in_ref_dim_lager_platz;
    v_r_g_u_gegenueber := in_r_g_u_gegenueber;
    if
        v_r_g_u_gegenueber = c.c_true
        and lvs_p_base.get_lgr_ort(in_sid, in_firma_nr, 1, v_ort)
    then
        v_ref_dim_lager_platz := v_ref_dim_lager_platz / 1000000000000;
        if mod(
            abs(v_ref_dim_lager_platz),
            2
        ) = 1 -- Regal Ungrade4 auf grade setzen für Abstand
         then
            v_ref_dim_lager_platz := in_ref_dim_lager_platz + 1000000000000;
        else
            v_ref_dim_lager_platz := in_ref_dim_lager_platz;
        end if;

    else
        v_r_g_u_gegenueber := c.c_false;
    end if;

    lvs_platz.v_dat_lgr_l_buchung := null;
    lvs_platz.v_dat_lgr_bestand_ausl_faktor := null;
    lvs_platz.v_lgr_abstand_faktor := 0;
    v_sonst_faktor := 0;
    v_fuellgrad_seg := 1000;
    
    -- Erst mal die Daten lesen

    if in_lgr_ort_typ = c.sat1
    or in_lgr_ort_typ = c.kanal1
    or in_lgr_ort_typ = c.durchl1
    -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
    or in_lgr_ort_typ = c.seg1         -- Segmetlager müssen wie Kanäle betrachtet werden
    or in_lgr_ort_typ = c.seg_duedo1   -- die jedoch eine Gruppe über mehrere Kanaele haben
     then
        open c_lgr_kanal;
        fetch c_lgr_kanal into
            v_dispo_faktor,
            lvs_platz.v_dat_lgr_regal_ebene_faktor,
            v_lgr_dim_platz,
            v_lgr_dim_ort,
            v_max_te,
            v_akt_te,
            v_max_kg,
            v_akt_kg,
            v_frei_hoehe,
            v_frei_breite,
            v_frei_tiefe,
            v_fuellgrad_seg_akt;

        v_found := c_lgr_kanal%found;
        close c_lgr_kanal;
      
      -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
        if in_lgr_ort_typ = c.seg1         -- Segmetlager müssen wie Kanäle betrachtet werden
        or in_lgr_ort_typ = c.seg_duedo1   -- die jedoch eine Gruppe über mehrere Kanaele haben
         then
            v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
        --v_dispo_faktor := v_dispo_faktor / 100;
        --v_dispo_faktor := v_dispo_faktor / v_fuellgrad_seg;
        end if;

    elsif in_lgr_ort_typ = c.kanal_bkl1
    or in_lgr_ort_typ = c.reg_fach1
    or in_lgr_ort_typ = c.stap_flae1
    or in_lgr_ort_typ = c.stap_flae2 then
        open c_lgr_kanal_block;
        fetch c_lgr_kanal_block into
            lvs_platz.v_dat_lgr_l_buchung,
            v_lgr_dim_platz,
            v_lgr_dim_p,
            v_lgr_dim_t,
            v_lgr_dim_ort,
            v_max_kg,
            v_akt_kg,
            v_frei_hoehe,
            v_frei_breite,
            v_frei_tiefe;

        v_found := c_lgr_kanal_block%found;
        close c_lgr_kanal_block;
        if
            v_found
            and lvs_platz.v_dat_lgr_l_buchung is not null
        then
            v_dispo_faktor := v_ort.strat_platz_res_string; -- C.LGR_PLATZ_RES_STRING;
        else
            v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
        end if;

        v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
    elsif in_lgr_ort_typ = c.pp_epl1 then
        open c_lgr_epl;
        fetch c_lgr_epl into
            v_lgr_dim_platz,
            v_lgr_dim_ort,
            v_max_kg,
            v_akt_kg,
            v_frei_hoehe,
            v_frei_breite,
            v_frei_tiefe;
        v_found := c_lgr_epl%found;
        close c_lgr_epl;
        v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
      --ToDo Hier den Platz richtig bewerten
    elsif in_lgr_ort_typ = c.epl1 then
      -- Bei Einzelplatz kann es nur Leere Plätze geben !!!
        open c_lgr_epl;
        fetch c_lgr_epl into
            v_lgr_dim_platz,
            v_lgr_dim_ort,
            v_max_kg,
            v_akt_kg,
            v_frei_hoehe,
            v_frei_breite,
            v_frei_tiefe;
        v_found := c_lgr_epl%found;
        close c_lgr_epl;
        v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;
    elsif in_lgr_ort_typ = c.sat_epl1
    or in_lgr_ort_typ = c.sat_epl2
    -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
    -- or in_lgr_ort_typ = c.SEG1         -- Segmetlager müssen wie Kanäle betrachtet werden
    -- or in_lgr_ort_typ = c.SEG_DUEDO1   -- die jedoch eine Gruppe über mehrere Kanaele haben
     then
      -- Bei Sateliten Einzelplaetzen ist immer Gut, wen der gegenüberliegende Platz frei ist
        open c_lgr_sat_epl_platz;
        fetch c_lgr_sat_epl_platz into
            v_lgr_dim_platz,
            v_lgr_dim_p,
            v_lgr_dim_ort,
            v_max_kg,
            v_akt_kg,
            v_frei_hoehe,
            v_frei_breite,
            v_frei_tiefe,
            v_lgr_dim_fifo,
            v_lgr_gruppe,
            v_lgr_platz_gegenueber,
            lvs_platz.v_dat_lgr_regal_ebene_faktor,
            v_fuellgrad_seg_akt;

        v_found := c_lgr_sat_epl_platz%found;
        close c_lgr_sat_epl_platz;
        if in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2 then
            if v_found then
                open c_lgr_sat_epl_gegenueber;
                fetch c_lgr_sat_epl_gegenueber into
                    v_lgr_einl_te_v,
                    v_lgr_ausl_te_d;
                v_found := c_lgr_sat_epl_gegenueber%found;
                close c_lgr_sat_epl_gegenueber;
                if in_lgr_ort_typ = c.sat_epl1 then
                    if mod(v_lgr_dim_p, 2) != mod(v_lgr_dim_fifo, 2)
                    or v_lgr_einl_te_v = 0 then
                        v_lgr_einl_te_v := null;
                    end if;
                else
                    if v_lgr_einl_te_v = 0 then
                        v_lgr_einl_te_v := null;
                    end if;
                end if;

            else
                v_lgr_einl_te_v := null;
            end if;

            if v_lgr_einl_te_v is null then
                v_dispo_faktor := v_ort.strat_platz_leer; -- C.LGR_PLATZ_LEER;  -- Einfach nur eine leerer Platz
            else
                v_dispo_faktor := ( v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ + v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */
                ) / 2;                              -- Dann ist das ein besonder guter Platz
            end if;

            if in_lgr_ort_typ = c.sat_epl2                         -- Segment der Einzelplätze füllen Komremieren

             then
                open c_lgr_kanal;
                fetch c_lgr_kanal into
                    v_dispo_faktor_seg,
                    v_lgr_regal_ebene_faktor_seg,
                    v_lgr_dim_platz_seg,
                    v_lgr_dim_ort_seg,
                    v_max_te,
                    v_akt_te,
                    v_max_kg_seg,
                    v_akt_kg_seg,
                    v_frei_hoehe_seg,
                    v_frei_breite_seg,
                    v_frei_tiefe_seg,
                    v_fuellgrad_seg_akt;

                v_found := c_lgr_kanal%found;
                close c_lgr_kanal;
                v_fuellgrad_seg := ( v_akt_te + 1 ) / v_max_te * 1000;
            end if;

            if in_lgr_opti = c.c_true then
                if v_lgr_ausl_te_d = 1 then
                    v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ / 100;    -- Besser geht nicht (Wechselspiel)
                else
                    if v_lgr_einl_te_v is not null then
                        open c_lgr_sat_epl_gruppe;
                        fetch c_lgr_sat_epl_gruppe into
                            v_lgr_einl_te_v,
                            v_lgr_ausl_te_d;
                        v_found := c_lgr_sat_epl_gruppe%found;
                        close c_lgr_sat_epl_gruppe;
                        if v_found then
                            v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */ / 10;    -- Besser geht nicht (Wechselspiel)
                        end if;
                    end if;
                end if;
            end if;

            if in_sych_transport = v_lgr_platz_gegenueber then
                v_dispo_faktor := v_dispo_faktor / 100;
                v_dispo_faktor := v_dispo_faktor / v_fuellgrad_seg;
            end if;

        else
            if in_res_string = in_lgr_res_string then
                v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */;
            else
                if in_lgr_res_string is null then
                    v_dispo_faktor := v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */;
                else
                    v_dispo_faktor := v_ort.strat_platz_falsch /* c.LGR_PLATZ_FALSCH*/;
                end if;
            end if;

            v_fuellgrad_seg := nvl(v_fuellgrad_seg_akt, 1000);
        end if;

    else
        open c_lgr_block;
        fetch c_lgr_block into
            v_dispo_faktor,
            lvs_platz.v_dat_lgr_bestand_ausl_faktor,
            lvs_platz.v_dat_lgr_l_buchung,
            v_lgr_dim_platz,
            v_lgr_dim_ort,
            v_max_kg,
            v_akt_kg,
            v_frei_hoehe,
            v_frei_breite,
            v_frei_tiefe;

        v_found := c_lgr_block%found;
        close c_lgr_block;
      --if v_dispo_faktor > 0 then
      --  v_dispo_faktor := C.LGR_PLATZ_RES_STRING;
      --else
      --  v_dispo_faktor := C.LGR_PLATZ_LEER;
      --end if;
        if
            v_found
            and lvs_platz.v_dat_lgr_l_buchung is not null
        then
            v_dispo_faktor := v_ort.strat_platz_res_string /* c.LGR_PLATZ_RES_STRING */;
        else
            v_dispo_faktor := v_ort.strat_platz_leer /* C.LGR_PLATZ_LEER */;
        end if;

    end if;

    lvs_platz.v_faktor_belegung_akt := v_dispo_faktor;
    -- Gewicht und Platz berücksichtigen
    if v_ort.strat_gewicht_relevanz /* c.LGR_GEWICHT_RELEVANZ */ is not null then
        if in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2
        or in_lgr_ort_typ = c.kanal1
        or in_lgr_ort_typ = c.durchl1
        or in_lgr_ort_typ = c.epl1
        or in_lgr_ort_typ = c.reg_fach1
        or in_lgr_ort_typ = c.stap_flae1
        or in_lgr_ort_typ = c.stap_flae2
        or in_lgr_ort_typ = c.seg1
        or in_lgr_ort_typ = c.seg_duedo1
        or in_lgr_ort_typ = c.pp_epl1 then
        -- Differenz bilden + 1 damit 0 (Nuetral wirkt multiplikation)
            v_diff := nvl(nvl(v_max_kg,
                              nvl(in_lte_lte_akt_kg, 0)) - nvl(v_akt_kg, 0) - nvl(in_lte_lte_akt_kg, 0),
                          0) + 1;
        -- wenn das Gewicht < 1 dann ist die LTE sowiso zu schwer
            if v_diff < 1 then
                v_diff := 5000;
            end if;
        elsif in_lgr_ort_typ = c.kanal_bkl1
        or in_lgr_ort_typ = c.bkl1 then
            v_diff := 1;
        end if;

        v_sonst_faktor := ( ( v_diff ) * v_ort.strat_gewicht_relevanz /* c.LGR_GEWICHT_RELEVANZ */ );
    end if;
    -- Hoehe
    if v_ort.strat_hoehe_relevanz /* c.LGR_HOEHE_RELEVANZ */ is not null then
        if in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2
        or in_lgr_ort_typ = c.kanal1
        or in_lgr_ort_typ = c.durchl1
        or in_lgr_ort_typ = c.epl1
        or in_lgr_ort_typ = c.reg_fach1
        or in_lgr_ort_typ = c.stap_flae1
        or in_lgr_ort_typ = c.stap_flae2
        or in_lgr_ort_typ = c.seg1
        or in_lgr_ort_typ = c.seg_duedo1
        or in_lgr_ort_typ = c.pp_epl1 then
            v_diff := nvl(v_frei_hoehe - in_lte_lte_vol_hoehe, 0) + 1;
            if v_diff < 1 then
                v_diff := 5000;
            end if;
        elsif in_lgr_ort_typ = c.kanal_bkl1
        or in_lgr_ort_typ = c.bkl1 then
            v_diff := 1;
        end if;

        v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_hoehe_relevanz /* c.LGR_HOEHE_RELEVANZ */ );
    end if;
    -- Breite
    if v_ort.strat_breite_relevanz /* c.LGR_BREITE_RELEVANZ */ is not null then
        if in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2
        or in_lgr_ort_typ = c.kanal1
        or in_lgr_ort_typ = c.durchl1
        or in_lgr_ort_typ = c.epl1
        or in_lgr_ort_typ = c.reg_fach1
        or in_lgr_ort_typ = c.stap_flae1
        or in_lgr_ort_typ = c.stap_flae2
        or in_lgr_ort_typ = c.seg1
        or in_lgr_ort_typ = c.seg_duedo1
        or in_lgr_ort_typ = c.pp_epl1 then
            v_diff := nvl(v_frei_breite - in_lte_lte_vol_breite, 0) + 1;
            if v_diff < 1 then
                v_diff := 5000;
            end if;
        elsif in_lgr_ort_typ = c.kanal_bkl1
        or in_lgr_ort_typ = c.bkl1 then
            v_diff := 1;
        end if;

        v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_breite_relevanz /* c.LGR_BREITE_RELEVANZ */ );
    end if;
    -- Breite
    if v_ort.strat_tiefe_relevanz /* c.LGR_TIEFE_RELEVANZ */ is not null then
        if in_lgr_ort_typ = c.sat1
        or in_lgr_ort_typ = c.sat_epl1
        or in_lgr_ort_typ = c.sat_epl2
        or in_lgr_ort_typ = c.kanal1
        or in_lgr_ort_typ = c.durchl1
        or in_lgr_ort_typ = c.epl1
        or in_lgr_ort_typ = c.reg_fach1
        or in_lgr_ort_typ = c.stap_flae1
        or in_lgr_ort_typ = c.stap_flae2
        or in_lgr_ort_typ = c.seg1
        or in_lgr_ort_typ = c.seg_duedo1
        or in_lgr_ort_typ = c.pp_epl1 then
            v_diff := nvl(v_frei_tiefe - in_lte_lte_vol_tiefe, 0) + 1;
            if v_diff < 1 then
                v_diff := 5000;
            end if;
        elsif in_lgr_ort_typ = c.kanal_bkl1
        or in_lgr_ort_typ = c.bkl1 then
            v_diff := 1;
        end if;

        v_sonst_faktor := v_sonst_faktor + ( ( v_diff ) * v_ort.strat_tiefe_relevanz /* c.LGR_TIEFE_RELEVANZ */ );
    end if;

    if lvs_platz.v_lgr_abstand_faktor = 0 then
        lvs_platz.v_lgr_abstand_faktor := 1;
    end if;
    if v_sonst_faktor = 0 then
        v_sonst_faktor := 1;
    end if;
    if v_found then
      -- jetzt ABC
        v_sonst_faktor := v_sonst_faktor * ( abs(in_lgr_abc * v_ort.strat_abc - in_lte_abc * v_ort.strat_abc) + 1 );
     -- jetzt Artikelres
        if in_lte_res_art = to_char(in_lgr_res_artikel_id) then
            v_dispo_faktor := v_dispo_faktor / v_ort.strat_art_res;
        elsif
            in_lte_res_art != to_char(in_lgr_res_artikel_id)
            and in_lgr_res_artikel_id is not null
        then
            v_dispo_faktor := v_dispo_faktor * v_ort.strat_art_res /* C.LGR_ART_RES */;
        end if;

        if v_ort.strat_ort_abstand_faktor /* c.LGR_ORT_ABSTAND_FAKTOR */ < 0 then
            lvs_platz.v_lgr_abstand_faktor := lvs_platz.v_lgr_abstand_faktor * abs((nvl(
                abs(v_lgr_dim_ort - in_ref_dim_lager_ort),
                0
            )) * v_ort.strat_ort_abstand_faktor /* c.LGR_ORT_ABSTAND_FAKTOR */ + 1);
        end if;

        if v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ <= 0                     -- Gleiche Ware möglichtst zusammenstellen
        or v_dispo_faktor = v_ort.strat_platz_res_string           -- oder Kanal, Platz hat gleichen Reservirungsstring
        or in_lgr_gruppe_id is null                      -- oder es gibt keine Guppierung im Lager
         then
            if
                v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ > 0
                and v_dispo_faktor = v_ort.strat_platz_res_string        -- Gleichverteilung und Kanal, Platz hat gleichen Reservirungsstring
            then                                           -- dann in jedem Fall zusammenfahren
                v_multiplikator := -1;
            else                                           -- sonst mach was im Parameter steht
                v_multiplikator := v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */;
            end if;

            v_lgr_dim_platz_calc := v_lgr_dim_platz / 1000000000000;
            if
                mod(
                    abs(v_lgr_dim_platz_calc),
                    2
                ) = 1
                and v_r_g_u_gegenueber = c.c_true
            then
                v_lgr_dim_platz := v_lgr_dim_platz + 1000000000000;
            end if;

            if in_lgr_ort_typ = c.stap_flae1
            or in_lgr_ort_typ = c.stap_flae2 then
                if abs(v_lgr_dim_p - in_lgr_dim_p) > abs(v_lgr_dim_t - in_lgr_dim_t) then
                    v_ref_dim_lager_platz := abs(v_lgr_dim_p - in_lgr_dim_p);
                else
                    v_ref_dim_lager_platz := abs(v_lgr_dim_t - in_lgr_dim_t);
                end if;

                lvs_platz.v_lgr_abstand_faktor := lvs_platz.v_lgr_abstand_faktor * ( abs(v_ref_dim_lager_platz * v_multiplikator) + 1
                );

            else
                lvs_platz.v_lgr_abstand_faktor := lvs_platz.v_lgr_abstand_faktor * ( abs(nvl(
                    abs(v_lgr_dim_platz - v_ref_dim_lager_platz),
                    0
                ) * v_multiplikator) + 1 ) / 100000000; -- Tiefe und Platz Rausnehmen;
            end if;

            lvs_platz.v_lgr_abstand_faktor := lvs_platz.v_lgr_abstand_faktor + v_sonst_faktor;
        else
            if
                v_ort.strat_ort_abstand_faktor /* c.LGR_ABSTAND_FAKTOR */ > 0
                and v_ort.strat_fuellgrad_relevanz /* c.LGR_FUELLGRAD_RELEVANZ */ > 0
            then
                if lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab.exists(in_lgr_gruppe_id) then
                    v_fuellgrad := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab(in_lgr_gruppe_id);
                else
                    v_fuellgrad := lvs_p_lgr_grp_fahrzeuge.lgr_grp_fuellgrad(in_sid,               -- in_sid                 in isi_sid.sid%type,
                     in_firma_nr,          -- in_firma_nr            in isi_firma.firma_nr%type,
                     v_lgr_dim_ort,        -- in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                     in_lgr_gruppe_id,     -- in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
                     in_ref_dim_lager_ort, -- in_ref_lgr_ort         in lvs_lgr_ort.lgr_ort%type,
                                                                             in_ref_lgr_gruppe_id, -- in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
                                                                              in_res_string         -- in_res_string          in    lvs_lte.res_string%type
                                                                             );

                    lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab(in_lgr_gruppe_id) := v_fuellgrad;
                end if;
          -- BugFix AG 20.09.2010
          -- v_lgr_abstand_faktor := v_lgr_abstand_faktor - v_sonst_faktor;
                lvs_platz.v_lgr_abstand_faktor := lvs_platz.v_lgr_abstand_faktor + v_sonst_faktor;
                lvs_platz.v_lgr_abstand_faktor := lvs_platz.v_lgr_abstand_faktor + v_fuellgrad * v_ort.strat_fuellgrad_relevanz/* c.LGR_FUELLGRAD_RELEVANZ */
                ;
            end if;

            lvs_platz.v_last_lgr_ort := v_lgr_dim_ort;
        end if;

    end if;

    return ( v_dispo_faktor );
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
end lvs_platz_bewerten;
/


-- sqlcl_snapshot {"hash":"0ea140f55e003bd9309c444ca24b47a620c1c8d3","type":"FUNCTION","name":"LVS_PLATZ_BEWERTEN","schemaName":"DIRKSPZM32","sxml":""}