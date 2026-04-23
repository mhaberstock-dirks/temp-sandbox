create or replace force editionable view dirkspzm32.z_pzm_pbi_hr_kennzahlen (
    bu_id,
    bu_name,
    lnr,
    jahr,
    monat,
    name,
    vorname,
    plnr,
    personalnummer,
    kstnr,
    kst_name,
    abteilung,
    eintritt,
    austritt,
    geburtsdatum,
    zeitsaldo,
    urlaubsaldo,
    last_change_date
) as
    select
        b.bu_id,
        b.bu_name,
        'ZEIT'
        || to_char(p.pers_nr)
        || get_pers_kst_id(p.pers_nr)
        || to_char(trunc(sysdate, 'month') - 1,
                   'ddmmyyyy')                          lnr,
        to_char(trunc(sysdate, 'month') - 1,
                'yyyy')                      jahr,
        to_char(trunc(sysdate, 'month') - 1,
                'mm')                        monat,
        substr(p.pers_nname, 1, 59)          name,
        substr(p.pers_vname, 1, 50)          vorname,
        a.abt_pb_id                          plnr,
        p.pers_nr                            personalnummer,
        get_pers_kst_id(p.pers_nr)           kstnr,
        kst.kst_name,
        substr(a.abt_name, 1, 50)            abteilung,
        p.pers_eintrittsdatum                eintritt,
        p.pers_austrittdatum                 austritt,
        null                                 geburtsdatum,
        pzm_kontoverwaltung.zk_get_monat_saldo('01',
                                               1,
                                               p.pers_nr,
                                               'ZK',
                                               to_char(trunc(sysdate, 'month') - 1,
                                                       'mm'),
                                               to_char(trunc(sysdate, 'month') - 1,
                                                       'yyyy')) zeitsaldo,
        pzm_kontoverwaltung.zk_get_monat_saldo('01',
                                               1,
                                               p.pers_nr,
                                               'UKS',
                                               to_char(trunc(sysdate, 'month') - 1,
                                                       'mm'),
                                               to_char(trunc(sysdate, 'month') - 1,
                                                       'yyyy')) urlaubsaldo,
        nvl((
            select
                max(bh.buch_datum)
            from
                pzm_konten_bh bh
            where
                    bh.pers_nr = p.pers_nr
                and bh.typ = 'ZK'
                and bh.zk_start < trunc(sysdate, 'month')
        ),
            trunc(sysdate, 'month'))         last_change_date
         --trunc(sysdate, 'month') + 9 last_change_date
    from
        pzm_personal                     p,
        pzm_abteilungen                  a,
        isi_kostenstellen                kst,
        pzm_produktionsbereiche_bu       bu,
        pzm_prod_business_units_bereiche b
    where
            a.abt_id = get_pers_abt_id(p.pers_nr)
        and a.abt_pb_id = bu.pb_id (+)
        and bu.bu_id = b.bu_id (+)
        and kst.kst_nr (+) = get_pers_kst_id(p.pers_nr)
        and p.pers_nr >= 10000;


-- sqlcl_snapshot {"hash":"1d9010b9414e29bee7b9356d0f2b0cb2456c8456","type":"VIEW","name":"Z_PZM_PBI_HR_KENNZAHLEN","schemaName":"DIRKSPZM32","sxml":""}