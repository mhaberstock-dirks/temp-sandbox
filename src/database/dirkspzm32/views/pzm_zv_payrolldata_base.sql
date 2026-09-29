
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_ZV_PAYROLLDATA_BASE" ("RESPONSIBLE_NR", "PB_ID", "F_ABT_ID", "NAME", "RFID", "PERSNR", "ABT_ID", "ABT_NAME", "KOSTENSTELLE", "DATUM", "GEBUCHTE_KOSTENSTELLE", "TS_AA_ID", "AA_KURZNAME", "KENNZ_URLAUB", "TS_DAY_ABW_STD", "KOMMT", "GEHT", "GEZAEHLT_VON", "GEZAEHLT_BIS", "ANTEIL_ZEIT", "IST_ZEIT", "GEBUCHTE_ZEIT", "ABWEICHUNG_MINUTEN", "ZE_ANW_STD", "TS_DAY_PAUSE_STD", "BLK_IST_START", "BLK_IST_ENDE", "BLK_CALC_IST_START", "BLK_CALC_IST_ENDE", "GDIFF_GES", "SA_KURZNAME") AS 
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
      (SELECT ze_pers_nr
            , ze_schicht_tag
            , ze_kst_id          
            , nvl(blk_ist_start, blk_calc_ist_start) as blk_ist_start      
            , nvl(blk_ist_ende, blk_calc_ist_ende) as blk_ist_ende      
            , blk_calc_ist_start
            , blk_calc_ist_ende 
            , ze_anw_std
            , ratio_to_report(ze_anw_std) over (partition by ze_pers_nr, ze_schicht_tag) as anteil_zeit
            , round(((least(nvl(blk_ist_start, blk_calc_ist_start),blk_calc_ist_start)-blk_calc_ist_start)+(blk_calc_ist_ende-greatest(nvl(blk_ist_ende, blk_calc_ist_ende),blk_calc_ist_ende)))*24,3) as gdiff_ges  
        FROM (select ze_pers_nr, ze_schicht_tag, ze_kst_id, ze_ist_start, ze_ist_ende, ze_calc_ist_start, ze_calc_ist_ende, ze_std, ze_status from pzm_zeiterfassung where ze_status=2)
       MATCH_RECOGNIZE (
           PARTITION BY ze_pers_nr, ze_schicht_tag
           ORDER BY ze_calc_ist_start
           MEASURES
               FIRST(strt.ze_ist_start)          AS blk_ist_start,
               MAX (anw.ze_ist_ende)             AS blk_ist_ende,
               FIRST(strt.ze_calc_ist_start)     AS blk_calc_ist_start,
               MAX(anw.ze_calc_ist_ende)        AS blk_calc_ist_ende,
               FIRST(strt.ze_kst_id)             AS ze_kst_id,
               SUM(anw.ze_std)                   AS ze_anw_std
           ONE ROW PER MATCH
           PATTERN ( strt folge* )
           SUBSET anw = (strt, folge)
           DEFINE
               strt  AS ze_status = 2,
               folge AS ze_status = 2 AND ze_kst_id = strt.ze_kst_id)),
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
            , upper(aa.kennz_urlaub)                                                                               as kennz_urlaub
            , ts_day_abw_std
            , TO_CHAR (qb_ze.blk_ist_start, 'hh24:mi')                                                             AS kommt
            , CASE
                WHEN TRUNC (qb_ze.blk_ist_start) < TRUNC (qb_ze.blk_ist_ende)
                THEN
                  TO_CHAR (TO_NUMBER (TO_CHAR (qb_ze.blk_ist_ende, 'hh24')) + 24) || TO_CHAR (qb_ze.blk_ist_ende, ':mi')
                ELSE
                  TO_CHAR (qb_ze.blk_ist_ende, 'hh24:mi')
              END                                                                                                  AS geht
            , TO_CHAR ( NVL(qb_ze.blk_calc_ist_start, t.ts_day_wert_start), 'hh24:mi')                             AS gezaehlt_von
            , CASE
                WHEN TRUNC (qb_ze.blk_calc_ist_start) < TRUNC (qb_ze.blk_calc_ist_ende)
                THEN
                  TO_CHAR (TO_NUMBER (TO_CHAR (NVL(qb_ze.blk_calc_ist_ende, t.ts_day_wert_ende), 'hh24')) + 24) || 
                                      TO_CHAR (NVL(qb_ze.blk_calc_ist_ende, t.ts_day_wert_ende), ':mi')
                ELSE
                  TO_CHAR (NVL(qb_ze.blk_calc_ist_ende, t.ts_day_wert_ende), 'hh24:mi')
              END                                                                                                  AS gezaehlt_bis
            , qb_ze.anteil_zeit
            , NVL (qb_ze.anteil_zeit, 1) * (t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std)               AS ist_zeit
            ,  NVL (qb_ze.anteil_zeit, 1)
--              * qb_ze.gdiff_ges AS gebuchte_zeit
--              * ((t.ts_day_anw_std - t.ts_day_pause_std) + ((qb_ze.blk_ist_start - qb_ze.blk_calc_ist_start) + (qb_ze.blk_calc_ist_ende -  qb_ze.blk_ist_ende)) * -24)  AS gebuchte_zeit
              * ((t.ts_day_anw_std - t.ts_day_pause_std) + ((least(qb_ze.blk_ist_start, qb_ze.blk_calc_ist_start) - qb_ze.blk_calc_ist_start) + (qb_ze.blk_calc_ist_ende - greatest(qb_ze.blk_ist_ende, qb_ze.blk_calc_ist_ende))) * -24)  AS gebuchte_zeit
--              * ((t.ts_day_anw_std - t.ts_day_pause_std) + ((nvl(qb_ze.blk_ist_start,blk_calc_ist_start) - qb_ze.blk_calc_ist_start) + (qb_ze.blk_calc_ist_ende - nvl(qb_ze.blk_ist_ende,blk_calc_ist_ende))) * -24)  AS gebuchte_zeit
            ,   NVL (qb_ze.anteil_zeit, 1)
--              * ( qb_ze.gdiff_ges
--              * (  (  (((qb_ze.blk_ist_start - qb_ze.blk_calc_ist_start) + (qb_ze.blk_calc_ist_ende - qb_ze.blk_ist_ende)) * -24) -- Abweichung roh/calc
              * (  (  (((least(qb_ze.blk_ist_start, qb_ze.blk_calc_ist_start) - qb_ze.blk_calc_ist_start) + (qb_ze.blk_calc_ist_ende - greatest(qb_ze.blk_ist_ende, qb_ze.blk_calc_ist_ende))) * -24) -- Abweichung roh/calc
                + ( (t.ts_day_anw_std - t.ts_day_pause_std) -- gebucht pro Tag
                  - (t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std) -- Ist_Zeit pro Tag
                  ) -- Minuten
                ) * 60                                                                                            ) AS abweichung_minuten
            , qb_ze.ze_anw_std
            , t.ts_day_pause_std
         --   , qb_ze.ze_gez_kst_std
            , qb_ze.blk_ist_start
            , qb_ze.blk_ist_ende
            , qb_ze.blk_calc_ist_start
            , qb_ze.blk_calc_ist_ende
            , qb_ze.GDIFF_GES
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
--       , q.ZE_GEZ_KST_STD
       , q.blk_ist_start
       , q.blk_ist_ende
       , q.blk_calc_ist_start
       , q.blk_calc_ist_ende
       , q.gdiff_ges
       , q.sa_kurzname
    FROM qb_pa JOIN qb_ts q ON q.persnr = qb_pa.pers_nr;


-- sqlcl_snapshot {"hash":"818393a82a29c81b0d934c7037ba35c705dc9b04","type":"VIEW","name":"PZM_ZV_PAYROLLDATA_BASE","schemaName":"DIRKSPZM32","sxml":""}