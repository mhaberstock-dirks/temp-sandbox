create or replace force editionable view dirkspzm32.pzm_v_ze_ts_loa_monat (
    pers_nr,
    ts_datum,
    kst_id,
    sa_kurzname,
    aa_id,
    d_arb_std_pro_tag,
    sa_std_pro_tag,
    ts_day_soll_std,
    ze_ist_start,
    ze_ist_ende,
    ze_calc_start,
    ze_calc_ende,
    ts_day_arb_std,
    ts_day_abw_std,
    ts_day_anwesenheit_std,
    ts_day_pause_bez_std,
    ts_day_pause_bez_min,
    ts_day_pause_std,
    ts_day_pause_min,
    ts_day_ueb_std,
    ts_day_flex_std,
    ts_ges_arb_std,
    ist_zeiten_list_cr,
    calc_zeiten_list_cr,
    aa_kurzname_list_cr,
    aa_std_list_cr,
    loa_list_cr
) as
    select
        ts.ts_pers_nr                                                        pers_nr,
        ts.ts_datum,
        nvl(ts.ts_day_kst_id,
            get_pers_kst_id(ts.ts_pers_nr))                                  kst_id,
        ts.ts_sa_kurzname                                                    sa_kurzname,
        decode((
            select
                pb.pb_extern
            from
                pzm_personal            p, pzm_produktionsbereiche pb
            where
                    p.pers_nr = ts.ts_pers_nr
                and p.pers_pb_id = pb.pb_id
        ), 'T', null, ts.ts_aa_id)                                           aa_id,
        round(sm.d_arb_std_pro_tag, 3)                                       d_arb_std_pro_tag,
        round(sa.sa_std_pro_tag, 3)                                          sa_std_pro_tag,
        round(
            decode(sa.sa_std_pro_tag, null, sm.d_arb_std_pro_tag, sa.sa_std_pro_tag),
            3
        )                                                                    ts_day_soll_std,
        to_char(ts.ts_day_ist_start, 'hh24:mi')                              ze_ist_start,
        to_char(ts.ts_day_ist_ende, 'hh24:mi')                               ze_ist_ende,
        to_char(ts.ts_day_wert_start, 'hh24:mi')                             ze_calc_start,
        to_char(ts.ts_day_wert_ende, 'hh24:mi')                              ze_calc_ende,
        round(ts.ts_day_arb_std, 3)                                          ts_day_arb_std,
        round(ts.ts_day_abw_std, 3)                                          ts_day_abw_std,
        round((ts.ts_day_ist_ende - ts.ts_day_ist_start) * 24, 3)            ts_day_anwesenheit_std,
        round(ts.ts_day_pause_bez_std, 3)                                    ts_day_pause_bez_std,
        round(ts.ts_day_pause_bez_std * 60)                                  ts_day_pause_bez_min,
        round(ts.ts_day_pause_std, 3)                                        ts_day_pause_std,
        round(ts.ts_day_pause_std * 60)                                      ts_day_pause_min,
        decode(ts.ts_ueb_ok_datum,
               null,
               0,
               decode(ts.ts_ueb_storno_datum,
                      null,
                      nvl(ts.ts_day_ueb_std, 0), -- genehmigte Überstunden
                      0))                                                    ts_day_ueb_std,
        decode(ts.ts_ueb_ok_datum,
               null,
               0,
               decode(ts.ts_ueb_storno_datum,
                      null,
                      nvl(ts.ts_day_flex_std, 0), -- genehmigte Flexi-Stunden
                      0))                                                    ts_day_flex_std,
        ( decode(ts.ts_ueb_ok_datum,
                 null,
                 0,
                 decode(ts.ts_ueb_storno_datum,
                        null,
                        nvl(ts.ts_day_ueb_std, 0) + nvl(ts.ts_day_flex_std, 0), -- genehmigte Überstunden und Flexi-Stunden
                        0)) + nvl(ts.ts_day_arb_std, 0) + nvl(ts.ts_day_korr_std, 0) ) ts_ges_arb_std,
        (
            select
                listagg(decode(ze.ze_ist_start,
                               null,
                               ' ',
                               to_char(ze.ze_ist_start, 'hh24:mi')
                               || '-'
                               || to_char(ze.ze_ist_ende, 'hh24:mi')),
                        cr_lf())
            from
                (
                    select
                        ze1.ze_ist_start,
                        ze1.ze_ist_ende
                    from
                        pzm_zeiterfassung ze1
                    where
                            ze1.ze_pers_nr = ts.ts_pers_nr
                        and ze1.ze_schicht_tag = ts.ts_datum
                        and ( ze1.ze_aa_status is null
                              or (
                            select
                                pb.pb_extern
                            from
                                pzm_personal            p,
                                pzm_produktionsbereiche pb
                            where
                                    p.pers_nr = ts.ts_pers_nr
                                and p.pers_pb_id = pb.pb_id
                        ) = 'F' )
                    order by
                        ze1.ze_calc_ist_start,
                        ze1.ze_id
                ) ze
        )                                                                    ist_zeiten_list_cr,
        (
            select
                listagg(decode(ze.ze_calc_ist_start,
                               null,
                               ' ',
                               to_char(ze.ze_calc_ist_start, 'hh24:mi')
                               || '-'
                               || to_char(ze.ze_calc_ist_ende, 'hh24:mi')
                               || ' '
                               || ze.status_txt),
                        cr_lf())
            from
                (
                    select
                        ze1.ze_calc_ist_start,
                        ze1.ze_calc_ist_ende,
                        decode(ze1.ze_status, 4, 'P', 5, 'D',
                               6, 'F', ' ') status_txt
                    from
                        pzm_zeiterfassung ze1
                    where
                            ze1.ze_pers_nr = ts.ts_pers_nr
                        and ze1.ze_schicht_tag = ts.ts_datum
                        and ( ze1.ze_aa_status is null
                              or (
                            select
                                pb.pb_extern
                            from
                                pzm_personal            p,
                                pzm_produktionsbereiche pb
                            where
                                    p.pers_nr = ts.ts_pers_nr
                                and p.pers_pb_id = pb.pb_id
                        ) = 'F' )
                    order by
                        ze1.ze_calc_ist_start,
                        ze1.ze_id
                ) ze
        )                                                                    calc_zeiten_list_cr,
        (
            select
                listagg(decode(ze.ze_aa_status,
                               null,
                               ' ',
                               nvl(ze.aa_kurzname, ze.ze_aa_status)),
                        cr_lf())
            from
                (
                    select
                        ze1.ze_aa_status,
                        aa1.aa_kurzname
                    from
                        pzm_zeiterfassung     ze1,
                        pzm_abwesenheitsarten aa1
                    where
                            ze1.ze_pers_nr = ts.ts_pers_nr
                        and ze1.ze_schicht_tag = ts.ts_datum
                        and aa1.aa_id (+) = ze1.ze_aa_status
                        and ( ze1.ze_aa_status is null
                              or (
                            select
                                pb.pb_extern
                            from
                                pzm_personal            p,
                                pzm_produktionsbereiche pb
                            where
                                    p.pers_nr = ts.ts_pers_nr
                                and p.pers_pb_id = pb.pb_id
                        ) = 'F' )
                    order by
                        ze1.ze_calc_ist_start
                ) ze
        )                                                                    aa_kurzname_list_cr,
        (
            select
                listagg(decode(ze.ze_aa_status,
                               null,
                               ' ',
                               case
                                   when ze.ze_std > 0
                                        and ze.ze_std < 1 then
                                                    '0'
                                   else
                                       ''
                               end -- display leading '0'
                               || round(ze.ze_std, 3)),
                        cr_lf())
            from
                (
                    select
                        ze1.ze_aa_status,
                        round(ze1.ze_std, 3) ze_std
                    from
                        pzm_zeiterfassung ze1
                    where
                            ze1.ze_pers_nr = ts.ts_pers_nr
                        and ze1.ze_schicht_tag = ts.ts_datum
                        and ( ze1.ze_aa_status is null
                              or (
                            select
                                pb.pb_extern
                            from
                                pzm_personal            p,
                                pzm_produktionsbereiche pb
                            where
                                    p.pers_nr = ts.ts_pers_nr
                                and p.pers_pb_id = pb.pb_id
                        ) = 'F' )
                    order by
                        ze1.ze_calc_ist_start
                ) ze
        )                                                                    aa_std_list_cr,
        (
            select
                listagg(loa_ausw.zeaw_lz_lohnart
                        || ': '
                        ||
                        case
                            when loa_ausw.zeaw_lz_loa_std > 0
                                 and loa_ausw.zeaw_lz_loa_std < 1 then
                                '0'
                            else
                                ''
                        end -- display leading '0'
                        || decode(loa.lz_einheit,
                                  'HH24',
                                  round(loa_ausw.zeaw_lz_loa_std, 3)
                                  || ' h',
                                  round(loa_ausw.zeaw_lz_loa_std, 1)
                                  || ' d')
                        || ' ('
                        || loa.lz_bemerkungen
                        || ')',
                        cr_lf()) within group(
                order by
                    loa_ausw.zeaw_lz_lohnart
                )
            from
                pzm_ze_loa_ausw loa_ausw
                left join pzm_lohnarten   loa on loa.lz_id = loa_ausw.zeaw_lz_id
            where
                    loa_ausw.zeaw_pers_nr = ts.ts_pers_nr
                and loa_ausw.zeaw_datum = ts.ts_datum
                and ( loa.lz_operator != 'ERP_ZUS_ZK'
                      or (
                    select
                        pb.pb_extern
                    from
                        pzm_personal            p,
                        pzm_produktionsbereiche pb
                    where
                            p.pers_nr = ts.ts_pers_nr
                        and p.pers_pb_id = pb.pb_id
                ) = 'F' )
                and nvl(loa.lz_operator, 'X') != 'ARBSTD'
        )                                                                    loa_list_cr
    from
             pzm_ze_tagessatz ts
        join pzm_personal        p on p.pers_nr = ts.ts_pers_nr
        join pzm_abteilungen     abt on abt.abt_id = p.pers_abt_id
        left join pzm_schichtarten    sa on sa.sa_kurzname = ts.ts_sa_kurzname
        left join pzm_schicht_modelle sm on sm.sm_name = nvl(p.pers_sm_name, abt.abt_standard_sm_name)
    where
        ts.ts_day_wert_ende is not null -- aktuelle Anwesenheit ausblenden
    order by
        ts.ts_datum;


-- sqlcl_snapshot {"hash":"9f63eb23552756c86ee16e70b7267af0065e35b2","type":"VIEW","name":"PZM_V_ZE_TS_LOA_MONAT","schemaName":"DIRKSPZM32","sxml":""}