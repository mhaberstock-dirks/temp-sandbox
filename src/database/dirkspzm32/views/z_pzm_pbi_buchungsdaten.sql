create or replace force editionable view dirkspzm32.z_pzm_pbi_buchungsdaten (
    bu_id,
    bu_name,
    lnr,
    datum,
    firma,
    pd_mandant,
    mandant,
    persnr,
    name,
    vorname,
    abteilung,
    art,
    wert,
    kostenstelle,
    status,
    status_text,
    status_text2,
    sap_zuordnung,
    start_zeit,
    ende_zeit,
    last_change_date
) as
    select
        b.bu_id,
        b.bu_name,
        'ZE'
        || to_char(ze.ze_pers_nr)
        || to_char(ze.ze_calc_ist_start, 'ddmmyyyyhh24mi') lnr,
        ze.ze_schicht_tag                                  datum,
        case
            when nvl(pb.pb_extern, 'F') = 'T' then
                nvl(pb.pb_bemerkungen, ze.ze_pb_id)
            else
                to_char(ze.ze_pb_id)
        end                                                firma,
        get_pers_pb_id(p.pers_nr)                          pd_mandant,
        a.abt_pb_id                                        mandant,
        p.pers_nr                                          persnr,
        substr(p.pers_nname, 1, 50)                        name,
        substr(p.pers_vname, 1, 50)                        vorname,
        substr(a.abt_name, 1, 50)                          abteilung,
        to_char(nvl(ze.ze_aa_status, 0))                   art,
        case
            when nvl(pb.pb_extern, 'F') = 'T'
                 and ts.ts_ueb_ok_datum is not null then
                round(ze.ze_std /(ts.ts_day_anw_std) *(ts.ts_day_arb_std + ts.ts_day_ueb_std + ts.ts_day_flex_std), 3)
            else
                round(ze.ze_std /(ts.ts_day_anw_std) * ts.ts_day_arb_std, 3)
        end                                                wert,
        ze.ze_kst_id                                       kostenstelle,
        (
            select
                la.lz_lohnart
            from
                pzm_lohnarten la
            where
                'ARBSTD' = la.lz_operator
        )                                                  status,
        'Anwesende Zeit '
        || ze.ze_std
        || ' '
        || ts.ts_day_arb_std
        || ' P '
        || ts.ts_day_pause_std                             status_text,
        'ZE'                                               status_text2,
        null                                               sap_zuordnung,
        to_char(
            nvl(ze.ze_ist_start, ze.ze_calc_ist_start),
            'HH24:mi'
        )                                                  start_zeit,
        to_char(
            nvl(ze.ze_ist_ende, ze.ze_calc_ist_ende),
            'HH24:mi'
        )                                                  ende_zeit,
        nvl(ze.last_change_date, ze.created_date)          last_change_date
    from
        pzm_personal                     p,
        pzm_zeiterfassung                ze,
        pzm_ze_tagessatz                 ts,
        pzm_abteilungen                  a,
        pzm_produktionsbereiche          pb,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = ze.ze_pers_nr
        and ze.ze_pers_nr = ts.ts_pers_nr
        and ze.ze_schicht_tag = ts.ts_datum
        and ze.ze_abt_id = a.abt_id (+)
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
    --and ze.ze_schicht_tag > trunc(sysdate) - 61
        and ze.ze_schicht_tag < trunc(sysdate)
        and pb.pb_id (+) = ze.ze_pb_id
        and ( ts.ts_day_arb_std + ts.ts_day_ueb_std + ts.ts_day_flex_std ) > 0
        and ze.ze_calc_ist_ende > ze.ze_calc_ist_start
        and nvl(ze.ze_aa_status, 0) = 0
    union
    select
        b.bu_id,
        b.bu_name,
        'LOA'
        || loa.zeaw_lz_lohnart
        || loa.zeaw_pers_nr
        || to_char(loa.zeaw_datum, 'ddmmyyyy')    lnr,
        loa.zeaw_datum                            datum,
        case
            when nvl(pb.pb_extern, 'F') = 'T' then
                nvl(pb.pb_bemerkungen, loa.zeaw_pb_id)
            else
                to_char(loa.zeaw_pb_id)
        end                                       firma,
        get_pers_pb_id(p.pers_nr)                 pd_mandant,
        a.abt_pb_id                               mandant,
        p.pers_nr                                 persnr,
        substr(p.pers_nname, 1, 50)               name,
        substr(p.pers_vname, 1, 50)               vorname,
        substr(a.abt_name, 1, 50)                 abteilung,
        to_char(nvl(loa.aa_id, 0))                art,
        loa.zeaw_lz_loa_std                       wert,
        loa.zeaw_kst_id                           kostenstelle,
        case
            when pb.pb_extern = 'T'
                 and ( nvl(loa_cfg.lz_operator, 'x') in ( 'F', 'SF', 'K' )
                       or loa_cfg.lz_konto_name_kurz is not null ) then
                '1001'
            else
                loa.zeaw_lz_lohnart
        end                                       status,
       -- case when pb.pb_extern = 'T'
       --          and (   nvl(loa_cfg.lz_operator, 'x') in ('F', 'SF', 'K')
       --               or loa_cfg.lz_konto_name_kurz is not NULL
       --              )
       --     then 'Unbezahlt'
       --     else substr(loa_cfg.lz_bemerkungen, 1, 50)
       --     end status_text,
        substr(loa_cfg.lz_bemerkungen, 1, 50)     status_text,
        case
            when pb.pb_extern = 'T'
                 and ( nvl(loa_cfg.lz_operator, 'x') in ( 'F', 'SF', 'K' )
                       or loa_cfg.lz_konto_name_kurz is not null ) then
                'UNB'
            else
                substr(loa_cfg.lz_operator, 1, 50)
        end                                       status_text2,
        null                                      sap_zuordnung,
        '00:00'                                   start_zeit,
        '00:00'                                   ende_zeit,
        nvl(ts.last_change_date, ts.created_date) last_change_date
    from
        pzm_personal                     p,
        pzm_ze_loa_ausw                  loa,
        pzm_ze_tagessatz                 ts,
        pzm_abteilungen                  a,
        pzm_lohnarten                    loa_cfg,
        pzm_produktionsbereiche          pb,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = loa.zeaw_pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and loa.zeaw_lz_id = loa_cfg.lz_id
    --and loa.zeaw_datum > trunc(sysdate) - 61
        and loa.zeaw_datum < trunc(sysdate)
        and loa.zeaw_pers_nr = ts.ts_pers_nr
        and loa.zeaw_datum = ts.ts_datum
        and pb.pb_id (+) = loa.zeaw_pb_id
    --and nvl(loa_cfg.lz_operator, 'x') != 'UNB'
        and ( pb.pb_extern != 'T'
              or ( ( loa_cfg.lz_konto_name_kurz is null
                     or ( loa_cfg.lz_konto_name_kurz is not null
                          and loa.zeaw_lz_loa_std = get_pers_schicht_d_std(p.pers_nr) ) )
                   and isi_utils.iso_weekday(loa.zeaw_datum) < 6
                                 --and nvl(loa_cfg.lz_operator, 'x') not in ('F', 'SF', 'K')
                    ) )
    union
    select
        b.bu_id,
        b.bu_name,
        'PDL'
        || loa_ex.pers_nr
        || loa_ex.lohnart
        || to_char(loa_ex.datum, 'ddmmyyyy')              lnr,
        loa_ex.datum,
        case
            when nvl(pb.pb_extern, 'F') = 'T' then
                nvl(pb.pb_bemerkungen, pb.pb_id)
            else
                to_char(pb.pb_id)
        end                                               firma,
        get_pers_pb_id(p.pers_nr)                         pd_mandant,
        a.abt_pb_id                                       mandant,
        p.pers_nr                                         persnr,
        substr(p.pers_nname, 1, 50)                       name,
        substr(p.pers_vname, 1, 50)                       vorname,
        substr(a.abt_name, 1, 50)                         abteilung,
        '0'                                               art,
        loa_ex.loa_value                                  wert,
        get_pers_kst_id(p.pers_nr)                        kostenstelle,
        loa_ex.lohnart                                    status,
        substr(loa_cfg.lz_bemerkungen, 1, 50)             status_text,
        substr(loa_cfg.lz_operator, 1, 50)                status_text2,
        null                                              sap_zuordnung,
        '00:00'                                           start_zeit,
        '00:00'                                           ende_zeit,
        nvl(loa_ex.last_change_date, loa_ex.created_date) last_change_date
    from
        pzm_personal                     p,
        pzm_ze_loa_exp_ext_gutsch        loa_ex,
        pzm_abteilungen                  a,
        pzm_lohnarten                    loa_cfg,
        pzm_produktionsbereiche          pb,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = loa_ex.pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and loa_ex.lohnart = loa_cfg.lz_lohnart
    --and loa_ex.datum > trunc(sysdate) - 61
        and loa_ex.datum < trunc(sysdate)
        and pb.pb_id (+) = p.pers_pb_id
        and nvl(loa_cfg.lz_operator, 'x') in ( 'UESTDPROZ', 'UESTD' )
        and pb.pb_extern = 'T'
    union
    select
        b.bu_id,
        b.bu_name,
        'ABW'
        || am.aa_id
        || p.pers_nr
        || to_char(am.beginn, 'ddmmyyyy')
        || am.aa_id                                          lnr,
        am.beginn                                            datum,
        case
            when nvl(pb.pb_extern, 'F') = 'T' then
                nvl(pb.pb_bemerkungen,
                    get_pers_pb_id(p.pers_nr))
            else
                to_char(get_pers_pb_id(p.pers_nr))
        end                                                  firma,
        get_pers_pb_id(p.pers_nr)                            pd_mandant,
        a.abt_pb_id                                          mandant,
        p.pers_nr                                            persnr,
        substr(p.pers_nname, 1, 50)                          name,
        substr(p.pers_vname, 1, 50)                          vorname,
        substr(a.abt_name, 1, 50)                            abteilung,
        'ABW'                                                art,
        get_pers_schicht_d_std(p.pers_nr) * max(am.anz_tage) wert,
        get_pers_kst_id(p.pers_nr)                           kostenstelle,
        to_char(nvl(aa.aa_id, 0))                            status,
        substr(aa.aa_name, 1, 50)                            status_text,
        'von '
        || to_char(am.beginn, 'dd.mm.yyyy')
        || ' bis '
        || to_char(
            max(am.ende),
            'dd.mm.yyyy'
        )
        || ' '
        || substr(aa.aa_kurzname, 1, 50)                     status_text2,
        null                                                 sap_zuordnung,
        '00:00'                                              start_zeit,
        '00:00'                                              ende_zeit,
        nvl(
            max(am.aend_datum),
            max(am.erz_datum)
        )                                                    last_change_date
    from
        pzm_personal                     p,
        pzm_abwesenheitsmeldungen        am,
        pzm_abteilungen                  a,
        pzm_abwesenheitsarten            aa,
        pzm_produktionsbereiche          pb,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = am.pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and am.aa_id = aa.aa_id
        and am.ende > trunc(sysdate)
        and pb.pb_id (+) = get_pers_pb_id(p.pers_nr)
        and pb.pb_extern != 'T'
    group by
        b.bu_id,
        b.bu_name,
        am.aa_id,
        am.beginn,
        pb.pb_extern,
        pb.pb_bemerkungen,
        a.abt_pb_id,
        p.pers_nr,
        p.pers_nname,
        p.pers_vname,
        a.abt_name,
        aa.aa_id,
        aa.aa_kurzname,
        aa.aa_name
    union
    select
        b.bu_id,
        b.bu_name,
        'ABW-ANT'
        || aan.au_abwes_art
        || p.pers_nr
        || to_char(aan.au_beginn, 'ddmmyyyy')
        || aan.au_status                                      lnr,
        aan.au_beginn                                         datum,
        case
            when nvl(pb.pb_extern, 'F') = 'T' then
                nvl(pb.pb_bemerkungen,
                    get_pers_pb_id(p.pers_nr))
            else
                to_char(get_pers_pb_id(p.pers_nr))
        end                                                   firma,
        get_pers_pb_id(p.pers_nr)                             pd_mandant,
        a.abt_pb_id                                           mandant,
        p.pers_nr                                             persnr,
        substr(p.pers_nname, 1, 50)                           name,
        substr(p.pers_vname, 1, 50)                           vorname,
        substr(a.abt_name, 1, 50)                             abteilung,
        'ABW-ANT'                                             art,
        get_pers_schicht_d_std(p.pers_nr) * max(aan.au_utage) wert,
        get_pers_kst_id(p.pers_nr)                            kostenstelle,
        to_char(nvl(aa.aa_id, 0))                             status,
        substr(aa.aa_name
               || ' '
               || aan.au_bemerkung, 1, 50)                           status_text,
        'von '
        || to_char(aan.au_beginn, 'dd.mm.yyyy')
        || ' bis '
        || to_char(
            max(aan.au_ende),
            'dd.mm.yyyy'
        )
        || ' '
        || decode(aan.au_status,
                  0,
                  'beantragt',
                  1,
                  'genehmigt',
                  2,
                  'abgelehnt',
                  3,
                  'storniert',
                  to_char(aan.au_status))                               status_text2,
        null                                                  sap_zuordnung,
        '00:00'                                               start_zeit,
        '00:00'                                               ende_zeit,
        nvl(
            max(aan.au_datum),
            max(aan.au_ende)
        )                                                     last_change_date
    from
        pzm_personal                     p,
        pzm_abwesenheits_antr            aan,
        pzm_abteilungen                  a,
        pzm_abwesenheitsarten            aa,
        pzm_produktionsbereiche          pb,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = aan.au_pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and aan.au_abwes_art = aa.aa_id (+)
        and aan.au_ende > trunc(sysdate)
        and pb.pb_id (+) = get_pers_pb_id(p.pers_nr)
        and pb.pb_extern != 'T'
    group by
        b.bu_id,
        b.bu_name,
        aan.au_abwes_art,
        aan.au_beginn,
        pb.pb_extern,
        pb.pb_bemerkungen,
        a.abt_pb_id,
        p.pers_nr,
        p.pers_nname,
        p.pers_vname,
        a.abt_name,
        aa.aa_id,
        aa.aa_name,
        aan.au_bemerkung,
        aan.au_status;


-- sqlcl_snapshot {"hash":"043f1ae4807951e14c62322b871f065cc9215af4","type":"VIEW","name":"Z_PZM_PBI_BUCHUNGSDATEN","schemaName":"DIRKSPZM32","sxml":""}