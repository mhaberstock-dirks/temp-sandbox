create or replace force editionable view dirkspzm32.z_pzm_pbi_pdler (
    bu_id,
    bu_name,
    lnr,
    datum,
    firma,
    plnr,
    personalnummer,
    nname,
    vname,
    kstnr,
    lohnart,
    lohnarttext,
    stunden,
    kst_anteil,
    verrechnungssatz,
    gor,
    last_change_date
) as
    select
        b.bu_id,
        b.bu_name,
        'PDL'
        || to_char(pdl.pers_nr)
        || to_char(pdl.datum, 'ddmmyyyy')
        || pdl.lohnart                              lnr,
        pdl.datum                                   datum,
        pdl.pb_id                                   firma,
        pdl.pb_abteilung_id                         plnr,
        pdl.pers_nr                                 personalnummer,
        substr(pdl.pers_nname, 1, 59)               nname,
        substr(pdl.pers_vname, 1, 50)               vname,
        pdl.kst_nr                                  kstnr,
       --kst.kst_name,
        pdl.lohnart,
        substr(la.lz_bemerkungen, 1, 91)            lohnarttext,
        pdl.loa_value                               stunden,
        pdl.kst_anteil                              kst_anteil,
        null                                        verrechnungssatz,
        'G'                                         gor,
        nvl(pdl.last_change_date, pdl.created_date) last_change_date
    from
        pzm_pdl_kst_equal_pay            pdl,
        pzm_personal                     p,
        pzm_lohnarten                    la,
        pzm_abteilungen                  a,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            1 = 1
   --and pdl.datum >= trunc(trunc(trunc(sysdate, 'month') -1, 'month') -1, 'month') -1
        and la.lz_lohnart = pdl.lohnart
        and la.lz_id = (
            select
                min(xla.lz_id)
            from
                pzm_lohnarten xla
            where
                xla.lz_lohnart = pdl.lohnart
        )
        and pdl.pers_nr = p.pers_nr
        and p.pers_abt_id = a.abt_id
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+);


-- sqlcl_snapshot {"hash":"e720724db47d9c5ba6f3822beec1bbf6bb1840a5","type":"VIEW","name":"Z_PZM_PBI_PDLER","schemaName":"DIRKSPZM32","sxml":""}