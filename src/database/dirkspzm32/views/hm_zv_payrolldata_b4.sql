
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."HM_ZV_PAYROLLDATA_B4" ("RESPONSIBLE_NR", "PB_ID", "F_ABT_ID", "NAME", "RFID", "PERSNR", "ABT_ID", "ABT_NAME", "KOSTENSTELLE", "DATUM", "GEBUCHTE_KOSTENSTELLE", "TS_AA_ID", "AA_KURZNAME", "KENNZ_URLAUB", "TS_DAY_ABW_STD", "KOMMT", "GEHT", "GEZAEHLT_VON", "GEZAEHLT_BIS", "ANTEIL_ZEIT", "IST_ZEIT", "GEBUCHTE_ZEIT", "ABWEICHUNG_MINUTEN", "ZE_ANW_STD", "TS_DAY_PAUSE_STD", "ZE_GEZ_KST_STD", "KOMMT_DATUM", "GEHT_DATUM", "GEZ_VON_DATUM", "GEZ_BIS_DATUM", "SA_KURZNAME") AS 
  WITH
    qb_pa     /******************************************************************************
               * separater query_block für "pzm_v_get_assigned_personal";
               * nötig, damit Oracle-Optimizer den Filter auf Responsible_Nr per "PUSH_PRED"
               * nach innen führt und somit die Performance auf die View-Abfrage
               * gewährleistet bleibt 
               */   
    AS
      (SELECT ap.pers_nr
            , ap.responsible_nr
            , ap.pb_id
            , ap.abt_id                              AS f_abt_id -- filter für Abfrage
            , p.pers_nname || ', ' || p.pers_vname   AS name
            , u.transponder                          AS rfid
         FROM pzm_v_get_assigned_personal  ap
              JOIN pzm_personal p ON p.pers_nr = ap.pers_nr
              LEFT JOIN isi_user u ON u.pers_nr = ap.pers_nr),
    qb_ze    /****************************************************************************** 
              * Zeiterfassungs-Einträge je Kostenstelle 
              * samt prozentualer Anteil der Kostenstelle (anteil_zeit)
              * sowie Kommt-/Geht-Zeiten pro Tag zur späteren Berechnung gebuchter Zeiten 
              */
    AS
      (SELECT x.ze_pers_nr
            , x.ze_schicht_tag
            , x.ze_kst_id
            , x.kommt_kst
            , x.geht_kst
            , x.gez_von_kst
            , x.gez_bis_kst
            , x.ze_std
            , x.ze_anw_std
            , x.ze_gez_kst_std
            , ratio_to_report (x.ze_std) OVER (PARTITION BY x.ze_pers_nr, x.ze_schicht_tag)    AS anteil_zeit
            , MIN (x.kommt_kst) OVER (PARTITION BY x.ze_pers_nr, x.ze_schicht_tag)             AS kommt_datum
            , MAX (x.geht_kst) OVER (PARTITION BY x.ze_pers_nr, x.ze_schicht_tag)              AS geht_datum
            , MIN (x.gez_von_kst) OVER (PARTITION BY x.ze_pers_nr, x.ze_schicht_tag)           AS gez_von_datum
            , MAX (x.gez_bis_kst) OVER (PARTITION BY x.ze_pers_nr, x.ze_schicht_tag)           AS gez_bis_datum
         FROM (  SELECT z.ze_pers_nr
                      , z.ze_schicht_tag
                      , z.ze_kst_id
                      , MIN (NVL (z.ze_ist_start, z.ze_calc_ist_start))        AS kommt_kst
                      , MAX (NVL (z.ze_ist_ende, z.ze_calc_ist_ende))          AS geht_kst
                      , MIN (z.ze_calc_ist_start)                              AS gez_von_kst
                      , MAX (z.ze_calc_ist_ende)                               AS gez_bis_kst
                      , SUM (z.ze_std)                                         AS ze_std
                      , SUM ((z.ze_calc_ist_ende - z.ze_calc_ist_start) * 24)  AS ze_anw_std
                      , -- Anwesend je ZE_KST_ID
                        SUM (
                            (  (NVL (z.ze_ist_start, z.ze_calc_ist_start) - z.ze_calc_ist_start)
                             + (z.ze_calc_ist_ende)
                             - NVL (z.ze_ist_ende, z.ze_calc_ist_ende))
                          * -24)                                               AS ze_gez_kst_std
                   FROM pzm_zeiterfassung z
                  WHERE z.ze_status = 2
               GROUP BY z.ze_pers_nr, z.ze_schicht_tag, z.ze_kst_id) x),
    qb_ts    /******************************************************************************
              * Berechnung der Tagessatz-Datum je Kostenstelle
              */
    AS
      (SELECT t.ts_pers_nr                                                                                         AS persnr
            , t.ts_day_abt_id                                                                                      AS abt_id
            , abt.abt_name                                                                                         AS abt_name
            , get_pers_kst_id (t.ts_pers_nr)                                                                       AS kostenstelle
            , t.ts_datum                                                                                           AS datum
            , NVL (qb_ze.ze_kst_id, t.ts_day_kst_id)                                                               AS gebuchte_kostenstelle
            , t.ts_aa_id    
            , aa.aa_kurzname
            , aa.kennz_urlaub
            , ts_day_abw_std
            , TO_CHAR (qb_ze.kommt_kst, 'hh24:mi')                                                                  AS kommt
            , CASE
                WHEN TRUNC (qb_ze.kommt_kst) < TRUNC (qb_ze.geht_kst)
                THEN
                  TO_CHAR (TO_NUMBER (TO_CHAR (qb_ze.geht_kst, 'hh24')) + 24) || TO_CHAR (qb_ze.geht_kst, ':mi')
                ELSE
                  TO_CHAR (qb_ze.geht_kst, 'hh24:mi')
              END                                                                                                  AS geht
            , TO_CHAR (qb_ze.gez_von_kst, 'hh24:mi')                                                                AS gezaehlt_von
            , CASE
                WHEN TRUNC (qb_ze.gez_von_kst) < TRUNC (qb_ze.gez_bis_kst)
                THEN
                  TO_CHAR (TO_NUMBER (TO_CHAR (qb_ze.gez_bis_kst, 'hh24')) + 24) || TO_CHAR (qb_ze.gez_bis_kst, ':mi')
                ELSE
                  TO_CHAR (qb_ze.gez_bis_kst, 'hh24:mi')
              END                                                                                                  AS gezaehlt_bis
            , qb_ze.anteil_zeit
            , NVL (qb_ze.anteil_zeit, 1) * (t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std)               AS ist_zeit
            ,   NVL (qb_ze.anteil_zeit, 1)
              * ((t.ts_day_anw_std - t.ts_day_pause_std) + ((qb_ze.kommt_datum - qb_ze.gez_von_datum) + (qb_ze.gez_bis_datum - qb_ze.geht_datum)) * -24)  AS gebuchte_zeit
            ,   NVL (qb_ze.anteil_zeit, 1)
              * (  (  (((qb_ze.kommt_datum - qb_ze.gez_von_datum) + (qb_ze.gez_bis_datum - qb_ze.geht_datum)) * -24) -- Abweichung roh/calc
                    + ((t.ts_day_anw_std - t.ts_day_pause_std) -- gebucht pro Tag
                                                               - (t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std) -- Ist_Zeit pro Tag
                                                                                                                          ) -- Minuten
                                                                                                                           )
                 * 60)                                                                                             AS abweichung_minuten
            , qb_ze.ze_anw_std
            , t.ts_day_pause_std
            , qb_ze.ze_gez_kst_std
            , qb_ze.kommt_datum
            , qb_ze.geht_datum
            , qb_ze.gez_von_datum
            , qb_ze.gez_bis_datum
            , t.ts_sa_kurzname as sa_kurzname
         FROM pzm_ze_tagessatz  t
              JOIN pzm_abteilungen abt ON abt.abt_id = t.ts_day_abt_id
              LEFT JOIN pzm_abwesenheitsarten aa ON aa.aa_id = t.ts_aa_id
              LEFT JOIN qb_ze ON qb_ze.ze_pers_nr = t.ts_pers_nr AND qb_ze.ze_schicht_tag = t.ts_datum)
  /*******************************************************************************
   * Join über die Queryblöcke
   */              
  SELECT qb_pa.responsible_nr
       , qb_pa.pb_id
       , qb_pa.f_abt_id
       , qb_pa.name
       , qb_pa.rfid
       , q.PERSNR
       , q.ABT_ID
       , q.ABT_NAME
       , q.KOSTENSTELLE
       , q.DATUM
       , q.GEBUCHTE_KOSTENSTELLE
       , q.TS_AA_ID
       , q.AA_KURZNAME
       , q.KENNZ_URLAUB
       , q.TS_DAY_ABW_STD
       , q.KOMMT
       , q.GEHT
       , q.GEZAEHLT_VON
       , q.GEZAEHLT_BIS
       , q.ANTEIL_ZEIT
       , q.IST_ZEIT
       , q.GEBUCHTE_ZEIT
       , q.ABWEICHUNG_MINUTEN
       , q.ZE_ANW_STD
       , q.TS_DAY_PAUSE_STD
       , q.ZE_GEZ_KST_STD
       , q.kommt_datum
       , q.geht_datum
       , q.gez_von_datum
       , q.gez_bis_datum
       , q.sa_kurzname
    FROM qb_pa JOIN qb_ts q ON q.persnr = qb_pa.pers_nr;


-- sqlcl_snapshot {"hash":"908d2b4d9eb0e2ebf6fa57c0fbf264ef5fce36c5","type":"VIEW","name":"HM_ZV_PAYROLLDATA_B4","schemaName":"DIRKSPZM32","sxml":""}