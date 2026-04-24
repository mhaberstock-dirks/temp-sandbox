create or replace force editionable view dirkspzm32.z_pzm_pbi_auslastungsquote (
    bu_id,
    bu_name,
    lnr,
    mandant,
    name,
    nname,
    persnr,
    datum,
    wert,
    kostenstelle,
    wertart,
    sap_zuordnung,
    abteilung,
    last_change_date
) as
    select
        b.bu_id,
        b.bu_name,
        p.pers_nr * 1000000000 + to_number(to_char(ts.ts_datum, 'yyyymmdd')) * 10 lnr,
        get_pers_pb_id(p.pers_nr)                                                 mandant,
        substr(p.pers_nname, 1, 50)                                               name,
        substr(p.pers_vname, 1, 50)                                               nname,
        p.pers_nr                                                                 persnr,
        ts.ts_datum                                                               datum,
        round(ts.ts_day_arb_std + ts.ts_day_ueb_std + ts.ts_day_flex_std, 2)      wert,
        ts.ts_day_kst_id                                                          kostenstelle,
        'Anwesende Zeit'                                                          wertart,
        null                                                                      sap_zuordnung,
        substr(a.abt_name, 1, 50)                                                 abteilung,
        nvl(ts.last_change_date, ts.created_date)                                 last_change_date
    from
        pzm_personal                     p,
        pzm_ze_tagessatz                 ts,
        pzm_abteilungen                  a,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = ts.ts_pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and ts.ts_day_arb_std + ts.ts_day_ueb_std + ts.ts_day_flex_std > 0
        and ts.ts_datum > trunc(sysdate) - 31
        and ts.ts_datum < trunc(sysdate)
    union
    select
        b.bu_id,
        b.bu_name,
        p.pers_nr * 1000000000 + to_number(to_char(ts.ts_datum, 'yyyymmdd')) * 10 + 1 lnr,
        get_pers_pb_id(p.pers_nr)                                                     mandant,
        substr(p.pers_nname, 1, 50)                                                   name,
        substr(p.pers_vname, 1, 50)                                                   nname,
        p.pers_nr                                                                     persnr,
        ts.ts_datum                                                                   datum,
        round(ts.ts_day_abw_std, 2)                                                   wert,
        ts.ts_day_kst_id                                                              kostenstelle,
        substr(aa.aa_name, 1, 50)                                                     wertart,
        null                                                                          sap_zuordnung,
        substr(a.abt_name, 1, 50)                                                     abteilung,
        nvl(ts.last_change_date, ts.created_date)                                     last_change_date
    from
        pzm_personal                     p,
        pzm_ze_tagessatz                 ts,
        pzm_abteilungen                  a,
        pzm_abwesenheitsarten            aa,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            p.pers_nr = ts.ts_pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and ts.ts_day_abw_std > 0
        and ts.ts_aa_id = aa.aa_id
        and ts.ts_datum > trunc(sysdate) - 31
        and ts.ts_datum < trunc(sysdate);


-- sqlcl_snapshot {"hash":"6ec94cac38da6996865e54d9a65b0de1fdfc41c6","type":"VIEW","name":"Z_PZM_PBI_AUSLASTUNGSQUOTE","schemaName":"DIRKSPZM32","sxml":""}