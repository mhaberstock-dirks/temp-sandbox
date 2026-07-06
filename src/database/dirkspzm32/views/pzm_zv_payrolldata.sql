
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_ZV_PAYROLLDATA" ("RFID", "Persnr", "Name", "Abteilung", "Kostenstelle", "Datum", "gebuchte_Kostenstelle", "Type", "Kommt", "Geht", "Gezaehlt_von", "Gezaehlt_bis", "Pause_Dauer_Min", "Ist_Zeit", "Gebuchte_Zeit", "Abweichung_Minuten", "RESPONSIBLE_NR", "PB_ID", "ABT_ID") AS 
  SELECT     u.transponder                                                                                         AS rfid
        ,erg.persnr                                                                                               "Persnr"
        ,erg.name                                                                                                 "Name"
        ,erg.abteilung                                                                                            "Abteilung"
        ,erg.kostenstelle                                                                                         "Kostenstelle"
        ,erg.datum                                                                                                "Datum"
        ,erg.gebuchte_kostenstelle                                                                                "gebuchte_Kostenstelle"
        ,erg.TYPE                                                                                                 "Type"
        ,TO_CHAR (erg.kommt, 'hh24:mi')                                                                           "Kommt"
        ,CASE
           WHEN TRUNC (erg.kommt) < TRUNC (erg.geht)
           THEN
             TO_CHAR (TO_NUMBER (TO_CHAR (erg.geht, 'hh24')) + 24) || TO_CHAR (erg.geht, ':mi')
           ELSE
             TO_CHAR (erg.geht, 'hh24:mi')
         END                                                                                                      "Geht"
        ,TO_CHAR (erg.gezählt_von, 'hh24:mi')                                                                    "Gezaehlt_von"
        ,CASE
           WHEN TRUNC (erg.gezählt_von) < TRUNC (erg.gezählt_bis)
           THEN
             TO_CHAR (TO_NUMBER (TO_CHAR (erg.gezählt_bis, 'hh24')) + 24) || TO_CHAR (erg.gezählt_bis, ':mi')
           ELSE
             TO_CHAR (erg.gezählt_bis, 'hh24:mi')
         END                                                                                                      "Gezaehlt_bis"
        ,erg.pause_dauer_min                                                                                      "Pause_Dauer_Min"
        ,ROUND (erg.ist_zeit, 2)                                                                                  "Ist_Zeit"
        ,ROUND (erg.gebuchte_zeit + (((erg.kommt - erg.gezählt_von) + (erg.gezählt_bis - erg.geht)) * -24), 2)  "Gebuchte_Zeit"
        ,ROUND (
           (((((erg.kommt - erg.gezählt_von) + (erg.gezählt_bis - erg.geht)) * -24) + (erg.gebuchte_zeit - erg.ist_zeit)) * 60)
          ,2)                                                                                                     "Abweichung_Minuten"
       , ap.responsible_nr 
       , ap.pb_id 
       , ap.abt_id             

    FROM (-- Teil 1: Normale Anwesenheit (an)
            SELECT t.ze_pers_nr                                                                                         AS persnr
       , p.pers_nname || ', ' || p.pers_vname                                                                  AS name
       , abt.abt_name                                                                                         AS abteilung
       , get_pers_kst_id (t.ze_pers_nr)                                                                       AS kostenstelle
       , t.ze_schicht_tag                                                                                     AS datum
       , t.ze_kst_id                                                                                          AS gebuchte_kostenstelle
       ,'an'                                                                                                  AS TYPE
       , nvl(t.ze_ist_start, t.ze_calc_ist_start)                                                             AS kommt
       , nvl(t.ze_ist_ende, t.ze_calc_ist_ende)                                                               AS geht
       , t.ze_calc_ist_start                                                                                  AS gezählt_von
       , t.ze_calc_ist_ende                                                                                   AS gezählt_bis
       , t.pause_std * 60                                                                                     AS pause_dauer_min
       , t.arb_std                                                                                            AS ist_zeit
         --!!! ts_day_arb_std + ts_day_ueb_std + ts_day_flex_std in pzm_zeiterfassung nicht vorhanden!
       , t.buch_std                                                                                           AS gebuchte_zeit  
          
            FROM hm_v_ze_report t
                 JOIN pzm_personal p ON t.ze_pers_nr = p.pers_nr
                 JOIN pzm_abteilungen abt ON t.ze_abt_id = abt.abt_id
                 LEFT JOIN pzm_abwesenheitsarten aa ON t.ze_aa_status = aa.aa_id AND aa.kennz_urlaub = 't'
           WHERE (t.arb_std) > 0
          UNION ALL
          -- Teil 2: Urlaub/Halbtags (uh)
          SELECT t.ts_pers_nr                                AS persnr
                ,p.pers_nname || ', ' || p.pers_vname        AS name
                ,abt.abt_name                                AS abteilung
                ,get_pers_kst_id (t.ts_pers_nr)              AS kostenstelle
                ,t.ts_datum                                  AS datum
                ,t.ts_day_kst_id                             AS gebuchte_kostenstelle
                ,DECODE (aa.aa_kurzname, NULL, 'an', 'uh')   AS TYPE
                ,NULL                                        AS kommt
                ,NULL                                        AS geht
                ,NULL                                        AS gezählt_von
                ,NULL                                        AS gezählt_bis
                ,NULL                                        AS pause_dauer_min
                ,t.ts_day_abw_std                            AS ist_zeit
                ,NULL                                        AS gebuchte_zeit
            FROM pzm_ze_tagessatz t
                 JOIN pzm_personal p ON t.ts_pers_nr = p.pers_nr
                 JOIN pzm_abteilungen abt ON t.ts_day_abt_id = abt.abt_id
                 JOIN pzm_abwesenheitsarten aa ON t.ts_aa_id = aa.aa_id
           WHERE (t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std) > 0
             AND aa.kennz_urlaub = 'T'
          UNION ALL
          -- Teil 3: Abwesenheiten ohne Arbeitszeit
          SELECT t.ts_pers_nr                          AS persnr
                ,p.pers_nname || ', ' || p.pers_vname  AS name
                ,abt.abt_name                          AS abteilung
                ,get_pers_kst_id (t.ts_pers_nr)        AS kostenstelle
                ,t.ts_datum                            AS datum
                ,t.ts_day_kst_id                       AS gebuchte_kostenstelle
                ,CASE
                   WHEN aa.aa_id = 39 THEN 'ut'
                   WHEN aa.aa_id = 22 THEN 'fu'
                   WHEN aa.aa_id =  6 THEN 'kkr'
                   WHEN aa.aa_id = 63 THEN 'kpdl'
                   WHEN aa.aa_id = 13 THEN 'uu'
                   WHEN aa.aa_id = 23 THEN 'uu'
                   WHEN aa.aa_id = 40 THEN 'keau'
                   WHEN aa.aa_id = 35 THEN 'kb'
                   WHEN aa.aa_id =  5 THEN 'ko'
                   WHEN aa.aa_id =  2 THEN 'km'
                   ELSE '<' || NVL (aa.aa_kurzname, TO_CHAR (t.ts_aa_id)) || '>'
                 END                                   AS TYPE
                ,NULL                                  AS kommt
                ,NULL                                  AS geht
                ,NULL                                  AS gezählt_von
                ,NULL                                  AS gezählt_bis
                ,NULL                                  AS pause_dauer_min
                ,NULL                                  AS ist_zeit
                ,NULL                                  AS gebuchte_zeit
            FROM pzm_ze_tagessatz t
                 JOIN pzm_personal p ON t.ts_pers_nr = p.pers_nr
                 JOIN pzm_abteilungen abt ON t.ts_day_abt_id = abt.abt_id
                 LEFT JOIN pzm_abwesenheitsarten aa ON t.ts_aa_id = aa.aa_id
           WHERE (t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std) = 0
) erg left join pzm_v_get_assigned_personal ap ON ap.pers_nr = erg.persnr
      join isi_user u  on u.pers_nr = erg.persnr                                                                          
ORDER BY erg.persnr, erg.datum;


-- sqlcl_snapshot {"hash":"392fe0878fd595a8b586ebe96a4da4b9d837b89d","type":"VIEW","name":"PZM_ZV_PAYROLLDATA","schemaName":"DIRKSPZM32","sxml":""}