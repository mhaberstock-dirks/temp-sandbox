
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_ZE_LOA_12MONATE_SUM" ("PERS_NR", "LZ_LOHNART", "SUM_LOA_STD_1", "SUM_LOA_STD_2", "SUM_LOA_STD_3", "SUM_LOA_STD_4", "SUM_LOA_STD_5", "SUM_LOA_STD_6", "SUM_LOA_STD_7", "SUM_LOA_STD_8", "SUM_LOA_STD_9", "SUM_LOA_STD_10", "SUM_LOA_STD_11", "SUM_LOA_STD_12") AS 
  select p.pers_nr,
       t.lz_lohnart,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = trunc(sysdate, 'Month')) sum_loa_std_1,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -1)) sum_loa_std_2,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -2)) sum_loa_std_3,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -3)) sum_loa_std_4,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -4)) sum_loa_std_5,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -5)) sum_loa_std_6,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -6)) sum_loa_std_7,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -7)) sum_loa_std_8,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -8)) sum_loa_std_9,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -9)) sum_loa_std_10,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -10)) sum_loa_std_11,
       (select sum(zeaw_lz_loa_std)
          from pzm_ze_loa_ausw
         where zeaw_pers_nr = p.pers_nr
           and zeaw_lz_lohnart = t.lz_lohnart
           and trunc(zeaw_datum, 'Month') = add_months(trunc(sysdate, 'Month'), -11)) sum_loa_std_12
  from pzm_lohnarten t,
       pzm_personal p
 group by pers_nr, t.lz_lohnart
;


-- sqlcl_snapshot {"hash":"d935d3621b4e1f685537909c62253bcb2f363511","type":"VIEW","name":"PZM_V_ZE_LOA_12MONATE_SUM","schemaName":"DIRKSPZM32","sxml":""}