
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_ZV_PAYROLLDATA" ("RFID", "Persnr", "Name", "Abteilung", "Kostenstelle", "Datum", "gebuchte_Kostenstelle", "Type", "Kommt", "Geht", "Gezaehlt_von", "Gezaehlt_bis", "Pause_Dauer_Min", "Ist_Zeit", "Gebuchte_Zeit", "Abweichung_Minuten", "RESPONSIBLE_NR", "PB_ID", "ABT_ID", "Schichtart") AS 
  SELECT b.rfid
       , b.persnr
       , b.name
       , b.abt_name                                                    AS abteilung
       , b.kostenstelle
       , b.datum
       , b.gebuchte_kostenstelle
       , 'an'                                                          AS typ
       , b.kommt
       , b.geht
       , b.gezaehlt_von
       , b.gezaehlt_bis
       , ROUND (NVL (b.anteil_zeit, 1) * b.ts_day_pause_std * 60, 2)   AS pause_dauer_min
       , ROUND (b.ist_zeit, 2)                                         AS ist_zeit
       , ROUND (b.gebuchte_zeit, 2)                                    AS gebuchte_zeit
       , ROUND (b.abweichung_minuten, 2)                               AS abweichung_minuten
       , b.responsible_nr
       , b.pb_id
       , b.f_abt_id
       , b.sa_kurzname
    FROM PZM_ZV_PAYROLLDATA_BASE b
   WHERE b.ist_zeit > 0
  UNION ALL
  SELECT b.rfid
       , b.persnr
       , b.name
       , b.abt_name                    AS abteilung
       , b.kostenstelle
       , b.datum
       , b.gebuchte_kostenstelle
       , 'uh'                          AS typ
       , NULL                          AS kommt
       , NULL                          AS geht
       , NULL                          AS gezaehlt_von
       , NULL                          AS gezaehlt_bis
       , NULL                          AS pause_dauer_min
       , ROUND (b.ts_day_abw_std, 2)   AS ist_zeit
       , NULL                          AS gebuchte_zeit
       , NULL                          AS abweichung_minuten
       , b.responsible_nr
       , b.pb_id
       , b.f_abt_id
       , b.sa_kurzname
    FROM PZM_ZV_PAYROLLDATA_BASE b
   WHERE b.ist_zeit > 0 AND b.kennz_urlaub = 'T'
  UNION ALL
  SELECT b.rfid
       , b.persnr
       , b.name
       , b.abt_name  AS abteilung
       , b.kostenstelle
       , b.datum
       , b.gebuchte_kostenstelle
       , CASE
           WHEN b.ts_aa_id = 39 THEN 'ut'
           WHEN b.ts_aa_id = 22 THEN 'fu'
           WHEN b.ts_aa_id = 6 THEN 'kkr'
           WHEN b.ts_aa_id = 63 THEN 'kpdl'
           WHEN b.ts_aa_id = 13 THEN 'uu'
           WHEN b.ts_aa_id = 23 THEN 'uu'
           WHEN b.ts_aa_id = 40 THEN 'keau'
           WHEN b.ts_aa_id = 35 THEN 'kb'
           WHEN b.ts_aa_id = 5 THEN 'ko'
           WHEN b.ts_aa_id = 2 THEN 'km'
           ELSE '<' || NVL (b.aa_kurzname, TO_CHAR (b.ts_aa_id)) || '>'
         END         AS typ
       , NULL        AS kommt
       , NULL        AS geht
       , NULL        AS gezaehlt_von
       , NULL        AS gezaehlt_bis
       , NULL        AS pause_dauer_min
       , NULL        AS ist_zeit
       , NULL        AS gebuchte_zeit
       , NULL        AS abweichung_minuten
       , b.responsible_nr
       , b.pb_id
       , b.f_abt_id
       , b.sa_kurzname
    FROM PZM_ZV_PAYROLLDATA_BASE b
   WHERE b.ist_zeit = 0
  ORDER BY persnr, datum;


-- sqlcl_snapshot {"hash":"8200087f36d83090ebefafb8299bedeca8d96b6b","type":"VIEW","name":"PZM_ZV_PAYROLLDATA","schemaName":"DIRKSPZM32","sxml":""}