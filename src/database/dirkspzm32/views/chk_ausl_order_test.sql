create or replace force editionable view dirkspzm32.chk_ausl_order_test (
    vorgang_id,
    auf_id,
    artikel,
    lte_id,
    lgr_platz,
    reserviert,
    lgr_verwendung_lte_status,
    check_fa,
    q_lgr_ort_semikolon,
    lam_menge_ulhm,
    q_lgr_ort_order_lte,
    order_pos_auto_depal,
    order_pos_ware_disponiert,
    m_inv,
    labor_st,
    lam_sel1_10,
    charge,
    serie,
    mhd,
    min_mhd,
    anbruch,
    chk_reserv,
    konsi,
    p_datum,
    lgr_gesperrt,
    l_inv,
    l_orte,
    farzeug_ok,
    z_idx,
    z_menge,
    leitzahl,
    fa_ag,
    menge,
    reservierte_menge,
    "ReifeZeit",
    lam_text,
    zug_datum,
    labor_status,
    lam_res_fuer_auf_id,
    lte_res_fuer_vorgang_id,
    platz_gesp,
    lgr_verwendung,
    lam_mhd,
    res_mhd,
    charge_bez,
    min_mhd_r,
    ausl_sort,
    ausl_sort2,
    kunden_nr,
    name_1
) as
    select
        op.vorgang_id,
        op.auf_id,
        a.artikel,
        lte.lte_id,
        lte.lgr_platz,
        decode(
            nvl(lte.order_vorgang_id, lam.order_pos_auf_id),
            null,
            'Frei',
            'Reserviert'
        )                                                          reserviert,
        case
            when ( lgr.lgr_verwendung = c.r_lgr_typ_lager
                   and lte.lte_status = c.r_lte_lf_stat )
                 or ( lgr.lgr_verwendung = c.r_lgr_typ_we          -- Nur WE's wenn Palette grade fertig befüllt (Maschine)
                      and lte.lte_status = c.r_lte_bf_stat
                      and not exists (
                select
                    lgr_ort.lgr_ort           -- WE vom MFR sind TABU
                from
                    lvs_lgr_ort lgr_ort
                where
                        lgr_ort.sid = lgr.sid
                    and lgr_ort.firma_nr = lgr.firma_nr
                    and lgr_ort.lgr_ort = lgr.lgr_ort
                    and lgr_ort.lgr_ort_modul = 'MFR'
            ) )
                 or ( lgr.lgr_verwendung = c.r_lgr_typ_lagerp      -- Nur PP's wenn Palette grade fertig befüllt Palette kann raus
                      and lte.lte_status = c.r_lte_bf_stat ) then
                'OK LGR '
                || lgr.lgr_verwendung
                || ' mit LTE_Status '
                || lte.lte_status
            else
                case
                    when lte.lte_status = c.r_lte_lf_stat
                         or lte.lte_status = c.r_lte_bf_stat then
                            '??? LGR '
                            || lgr.lgr_verwendung
                            || ' mit LTE_Status '
                            || lte.lte_status
                    else
                        'ERR LGR '
                        || lgr.lgr_verwendung
                        || ' mit LTE_Status '
                        || lte.lte_status
                end
        end                                                        lgr_verwendung_lte_status,
        case
            when nvl(lam.leitzahl, -1) = nvl(op.leitzahl,
                                                 nvl(lam.leitzahl, -1)) -- Leitzahl beruecksichtigen
                 and nvl(lam.fa_ag, -1) = nvl(op.fa_ag, -1)-- Nur Ware die als Lagerware gilt !!!! AG <> NULL ist halbfertigware
                  then
                'OK FA'
            else
                'ERR FA'
        end                                                        check_fa,
        case
            when op.quell_lagerorte like '%;' then
                'OK'
            else
                'ERR: ' || op.quell_lagerorte
        end                                                        q_lgr_ort_semikolon,
        case
            when ( min(op.soll_menge) - min(op.ist_menge) ) < min(lam.menge)
                 and min(op.wa_menge_ueberlief) = 'ULHM' then
                'ERR: '
                || to_char((min(op.soll_menge) - min(op.ist_menge)))
                || ' < '
                || to_char(min(lam.menge))
            else
                'OK'
        end                                                        lam_menge_ulhm,
        case
            when op.quell_lagerorte like '%'
                                         || lte.lgr_ort
                                         || ';%' then
                'OK'
            else
                'ERR: '
                || op.quell_lagerorte
                || '-> '
                || lte.lgr_ort
        end                                                        q_lgr_ort_order_lte,
        case
            when lte.auto_depal = 'T' then
                'OK'
            else
                case
                    when op.komm_vorgabe_auto_depal = 'R' then
                            'ERR: LTE_AUTO_DEPAL!'
                    else
                        'OK'
                end
        end                                                        order_pos_auto_depal,
        case
            when op.ware_disponiert = 'F' then
                'OK'
            else
                'ERR: Ware bereits disponiert!'
        end                                                        order_pos_ware_disponiert,
        case
            when lam.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
             then
                'OK'
            else
                'ERR'
        end                                                        m_inv,
        case
            when lam.labor_status = nvl(op.labor_status, c.r_lab_stat_f) then
                'OK'
            else
                'ERR ' || lam.labor_status
        end                                                        labor_st,
        case
            when nvl(lam.lam_sel1, 'lam.lam_sel') = nvl(op.lam_sel1, 'lam.lam_sel')
                 and nvl(lam.lam_sel2, 'lam.lam_sel') = nvl(op.lam_sel2, 'lam.lam_sel')
                 and nvl(lam.lam_sel3, 'lam.lam_sel') = nvl(op.lam_sel3, 'lam.lam_sel')
                 and nvl(lam.lam_sel4, 'lam.lam_sel') = nvl(op.lam_sel4, 'lam.lam_sel')
                 and nvl(lam.lam_sel5, 'lam.lam_sel') = nvl(op.lam_sel5, 'lam.lam_sel')
                 and nvl(lam.lam_sel6, 'lam.lam_sel') = nvl(op.lam_sel6, 'lam.lam_sel')
                 and nvl(lam.lam_sel7, 'lam.lam_sel') = nvl(op.lam_sel7, 'lam.lam_sel')
                 and nvl(lam.lam_sel8, 'lam.lam_sel') = nvl(op.lam_sel8, 'lam.lam_sel')
                 and nvl(lam.lam_sel9, 'lam.lam_sel') = nvl(op.lam_sel9, 'lam.lam_sel')
                 and nvl(lam.lam_sel10, 'lam.lam_sel') = nvl(op.lam_sel10, 'lam.lam_sel') then
                'OK'
            else
                'ERR'
        end                                                        lam_sel1_10,
        case
            when nvl(lam.charge_id, -1) = nvl(op.charge_id,
                                              nvl(lam.charge_id, -1)) -- Charge Passt?
                                               then
                'OK'
            else
                'ERR'
        end                                                        charge,
        case
            when nvl(lam.serie_id, -1) = nvl(op.seriennr_id,
                                             nvl(lam.serie_id, -1)) -- SERIENNR passt?
                                              then
                'OK'
            else
                'ERR'
        end                                                        serie,
        case
            when trunc(lam.lam_mhd) = nvl(
                trunc(op.mhd),
                trunc(lam.lam_mhd)
            ) then
                'OK'
            else
                'ERR'
        end                                                        mhd,
        case
            when ( lam.lam_mhd >= nvl(sysdate + nvl(op.min_mhd_tage, 0),
                                      lam.lam_mhd) -- Wenn im Auftrag -1 als Min-MHD dann auch abgelaufene Ware OK
                   or op.mhd is not null ) then
                'OK'
            else
                'ERR'
        end                                                        min_mhd,
        case
            when ( nvl(op.anbruch, c.r_c_anbruch_ignore) = c.r_c_anbruch_ignore
                   or nvl(lte.lte_voll, c.r_lte_voll_a) = decode(op.anbruch, c.r_c_true, c.r_lte_voll_a, c.r_c_anbruch_vorzug, c.r_lte_voll_a
                   ,
                                                                 c.r_c_anbruch_ausnahme, c.r_lte_voll_a, c.r_lte_voll_v)
                   or nvl(lte.lte_voll, c.r_lte_voll_v) = decode(op.anbruch, c.r_c_false, c.r_lte_voll_v, c.r_c_anbruch_vorzug, c.r_lte_voll_v
                   ,
                                                                 c.r_c_anbruch_ausnahme, c.r_lte_voll_v, c.r_lte_voll_a) ) then
                'OK '
                || c.decode_lte_voll(lte.lte_voll)
            else
                'ERR '
                || c.decode_lte_voll(lte.lte_voll)
        end                                                        anbruch,
        case
            when nvl(lam.order_pos_auf_id, op.auf_id) != op.auf_id
                 or nvl(lte.order_vorgang_id, op.vorgang_id) != op.vorgang_id then
                'ERR'
            else
                'OK'
        end                                                        chk_reserv,
           -- Jetzt noch Prüfen ob KONSI
        case
            when ( ( lam.owner_address_id is null              -- Keine KONSI-Ware
                     and nvl(op.satzart, 'LK') = 'LK'              -- Kein KONSI Lieferschein
                      )
                   or ( lam.owner_address_id is not null          -- KONSI-Ware
                        and nvl(op.satzart, 'X') != 'LK'               -- KONSI Lieferschein
                         ) ) then
                'ERR'
            else
                'OK'
        end                                                        konsi,
        case
            when nvl(sysdate - lam.prod_datum, -1) >= decode(sysdate - lam.prod_datum,
                                                             null,
                                                             -1,
                                                             nvl(
                                                                  nvl(op.min_reifezeit * -1, -1),
                                                                  nvl(sysdate - lam.prod_datum, -1)
                                                              )) then
                'OK'
            else
                'ERR'
        end                                                        p_datum,
        case
            when lgr.gesperrt = c.r_lgr_gesperrt_f then
                'OK'
            else
                'ERR'
        end                                                        lgr_gesperrt,
        case
            when lgr.akt_inventur_id is null                      -- nur Ware reservieren die nicht in Inventur sind
             then
                'OK'
            else
                'ERR'
        end                                                        l_inv,
        case
            when op.quell_lagerorte like '%'
                                         || lte.lgr_ort
                                         || ';%'
                 or ( instr(
                nvl(
                    lvs_lager_opt.lvs_lort_format(op.kom_lgr_orte),
                    (
                        select
                            lvs_lager_opt.lvs_lort_format(ap.modul_parameter) lo
                        from
                            isi_arbeitsplatz_cfg ap
                        where
                                ap.arbeitsplatz_id = 1
                            and ap.modul_name = 'LVS'
                            and ap.modul_funktion = 'AUSL_ORTE'
                    )
                ),
                lpad(
                          to_char(lte.lgr_ort),
                          c.r_lort_laenge - 1,
                          '0'
                      )
                || ';'
            ) > 0 ) then
                'OK'
            else
                'ERR M '
                || lpad(
                    to_char(lte.lgr_ort),
                    c.r_lort_laenge - 1,
                    '0'
                )
                || ';'
                || ' O '
                || nvl(
                    lvs_lager_opt.lvs_lort_format(op.kom_lgr_orte),
                    (
                                select
                                    lvs_lager_opt.lvs_lort_format(ap.modul_parameter) lo
                                from
                                    isi_arbeitsplatz_cfg ap
                                where
                                        ap.arbeitsplatz_id = 1
                                    and ap.modul_name = 'LVS'
                                    and ap.modul_funktion = 'AUSL_ORTE'
                            )
                )
        end                                                        l_orte,
        lvs_p_lgr_grp_fahrzeuge.chk_lte_lgr_zugriff_ok(lte.lte_id) farzeug_ok,
          -- Berücksichtigen des Zeichnungsindex
        case
            when nvl(lam.zeichnung_index, 'Kein_I') = nvl(
                nvl(op.zeichnung_index, lam.zeichnung_index),
                'Kein_I'
            ) then
                'OK'
            else
                'ERR MI <'
                || lam.zeichnung_index
                || '>, OI <'
                || op.zeichnung_index
                || '>'
        end                                                        z_idx,
        case
            when nvl(
                sum(lam.menge),
                0
            ) > 0 then
                'OK'
            else
                'ERR'
        end                                                        z_menge,
        lam.leitzahl,
        lam.fa_ag,
        sum(lam.menge)                                             menge,
        sum(lam.res_menge)                                         reservierte_menge,
        ( trunc(sysdate) - trunc(min(lam.zug_datum)) )             as "ReifeZeit",
        lam.lam_text,
        lam.zug_datum,
        lam.labor_status,
        lam.order_pos_auf_id                                       lam_res_fuer_auf_id,
        lte.order_vorgang_id                                       lte_res_fuer_vorgang_id,
        lgr.gesperrt                                               platz_gesp,
        lgr.lgr_verwendung,
        lam.lam_mhd,
        lte.res_mhd,
        ch.charge_bez,
        nvl(op.min_mhd_tage, c.r_mhd_fw_min_tage)                  min_mhd_r,
        trunc(lvs_ausl.lvs_lte_platz_bewerten(op.sid,
                                              op.firma_nr,
                                              op.strategie,
                                              op.anbruch,
                                              lte.lte_voll,
                                              nvl(
                                                 min(lam.lam_mhd),
                                                 lte.res_mhd
                                             ),
                                              trunc(min(lam.prod_datum)),
                                              lte.lte_id,
                                              lte.lgr_platz,
                                              lte.res_string,
                                              lgr.lgr_platz_gruppe,
                                              lgr.lgr_typ,
                                              a.artikel_id))                                            ausl_sort,
        lvs_ausl.lvs_lte_platz_bewerten(op.sid,
                                        op.firma_nr,
                                        op.strategie,
                                        op.anbruch,
                                        lte.lte_voll,
                                        nvl(
                                   min(lam.lam_mhd),
                                   lte.res_mhd
                               ),
                                        trunc(min(lam.prod_datum)),
                                        lte.lte_id,
                                        lte.lgr_platz,
                                        lte.res_string,
                                        lgr.lgr_platz_gruppe,
                                        lgr.lgr_typ,
                                        a.artikel_id)                                     ausl_sort2,
        min(lam.kunden_nr)                                         kunden_nr,
        min(adr.name_1)                                            name_1
    from
        lvs_lte       lte,
        lvs_lam       lam,
        lvs_lgr       lgr,
        lvs_charge    ch,
        isi_adressen  adr,
        isi_artikel   a,
        isi_order_pos op
    where
            lte.sid = lam.sid
        and lte.lte_id = lam.lte_id
        and lte.lte_status not in ( 'AF', 'AG', 'KF' )
        and lgr.sid = op.sid
        and lgr.lgr_platz = lte.lgr_platz
        and lam.sid = op.sid
        and lam.firma_nr = op.firma_nr
        and lam.artikel_id = a.artikel_id
        and a.artikel_id = op.artikel_id
        and lam.sid = ch.sid (+)
        and lam.charge_id = ch.charge_id (+)
        and adr.sid (+) = lam.sid
        and adr.firma_nr (+) = lam.firma_nr
        and adr.adr_art (+) = 'K'
        and adr.adr_nr (+) = lam.kunden_nr
        and adr.adr_liefer (+) = 0
    group by
        lgr.sid,
        lgr.firma_nr,
        lgr.lgr_ort,
        lte.lte_id,
        lte.lte_voll,
        lam.lam_mhd,
        lam.artikel_id,
        lam.order_pos_auf_id,
        trunc(lam.prod_datum),
        lam.lam_text,
        lam.charge_id,
        lam.labor_status,
        lam.akt_inventur_id,
        a.artikel_id,
        a.artikel,
        lam.zug_datum,
        ch.charge_bez,
        lgr.lgr_platz,
        lgr.gesperrt,
        lte.lgr_ort,
        lte.lgr_platz,
        lte.res_string,
        lte.res_mhd,
        lte.order_vorgang_id,
        lgr.lgr_platz_gruppe,
        lgr.lgr_typ,
        lgr.akt_inventur_id,
        lam.mengeneinheit_basis,
        lam.leitzahl,
        lam.fa_ag,
        lte.lte_status,
        lgr.lgr_verwendung,
        op.leitzahl,
        op.fa_ag,
        op.labor_status,
        op.komm_vorgabe_auto_depal,
        op.soll_menge,
        lam.lam_sel1,
        lam.lam_sel2,
        lam.lam_sel3,
        lam.lam_sel4,
        lam.lam_sel5,
        lam.lam_sel6,
        lam.lam_sel7,
        lam.lam_sel8,
        lam.lam_sel9,
        lam.lam_sel10,
        lam.charge_id,
        lam.serie_id,
        lam.owner_address_id,
        lam.prod_datum,
        lam.zeichnung_index,
        op.seriennr_id,
        trunc(op.mhd),
        op.satzart,
        op.min_mhd_tage,
        op.charge_id,
        op.lam_sel1,
        op.lam_sel2,
        op.lam_sel3,
        op.lam_sel4,
        op.lam_sel5,
        op.lam_sel6,
        op.lam_sel7,
        op.lam_sel8,
        op.lam_sel9,
        op.lam_sel10,
        op.anbruch,
        op.strategie,
        op.auf_id,
        op.vorgang_id,
        op.min_reifezeit,
        op.zeichnung_index,
        op.kom_lgr_orte,
        op.sid,
        op.firma_nr,
        op.mhd,
        op.quell_lagerorte,
        op.ware_disponiert,
        lte.auto_depal,
        op.auto_depal
    order by
        decode(lte.order_vorgang_id, op.vorgang_id, 0, 1),
        ausl_sort,
        lgr.lgr_platz_gruppe,
        ausl_sort2;


-- sqlcl_snapshot {"hash":"12fc8dc6246e9f7515372035d6758a2376c38fb4","type":"VIEW","name":"CHK_AUSL_ORDER_TEST","schemaName":"DIRKSPZM32","sxml":""}