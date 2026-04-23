create or replace force editionable view dirkspzm32.pzm_v_ze_loa_12monate_sum (
    pers_nr,
    lz_lohnart,
    sum_loa_std_1,
    sum_loa_std_2,
    sum_loa_std_3,
    sum_loa_std_4,
    sum_loa_std_5,
    sum_loa_std_6,
    sum_loa_std_7,
    sum_loa_std_8,
    sum_loa_std_9,
    sum_loa_std_10,
    sum_loa_std_11,
    sum_loa_std_12
) as
    select
        p.pers_nr,
        t.lz_lohnart,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = trunc(sysdate, 'Month')
        ) sum_loa_std_1,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -1
                )
        ) sum_loa_std_2,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -2
                )
        ) sum_loa_std_3,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -3
                )
        ) sum_loa_std_4,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -4
                )
        ) sum_loa_std_5,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -5
                )
        ) sum_loa_std_6,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -6
                )
        ) sum_loa_std_7,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -7
                )
        ) sum_loa_std_8,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -8
                )
        ) sum_loa_std_9,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -9
                )
        ) sum_loa_std_10,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -10
                )
        ) sum_loa_std_11,
        (
            select
                sum(zeaw_lz_loa_std)
            from
                pzm_ze_loa_ausw
            where
                    zeaw_pers_nr = p.pers_nr
                and zeaw_lz_lohnart = t.lz_lohnart
                and trunc(zeaw_datum, 'Month') = add_months(
                    trunc(sysdate, 'Month'),
                    -11
                )
        ) sum_loa_std_12
    from
        pzm_lohnarten t,
        pzm_personal  p
    group by
        pers_nr,
        t.lz_lohnart;


-- sqlcl_snapshot {"hash":"f3e7f302bba7cade762286f5de5fe47b1f70379a","type":"VIEW","name":"PZM_V_ZE_LOA_12MONATE_SUM","schemaName":"DIRKSPZM32","sxml":""}