
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."HM_ZV_PAYROLLDATA_4" ("Rfid", "EmployeeId", "Name", "Department", "CostCenter", "PayrollDate", "BilledCostCenter", "Type", "StartTime", "EndTime", "EvaluatedStartTime", "EvaluatedEndTime", "PauseTime", "ActualTime", "BilledTime", "DiffTime", "RESPONSIBLE_NR", "ProdBranchId", "ABT_ID", "ShiftTypeShortname") AS 
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
           WHEN b.ts_aa_id =  6 THEN 'kkr'
           WHEN b.ts_aa_id = 63 THEN 'kpdl'
           WHEN b.ts_aa_id = 13 THEN 'uu'
           WHEN b.ts_aa_id = 23 THEN 'uu'
           WHEN b.ts_aa_id = 40 THEN 'keau'
           WHEN b.ts_aa_id = 35 THEN 'kb'
           WHEN b.ts_aa_id =  5 THEN 'ko'
           WHEN b.ts_aa_id =  2 THEN 'km'
           -- Sonderfall für Kommen ohne Gehen
           WHEN b.gezaehlt_von IS NULL AND b.gezaehlt_bis IS NULL THEN 'op'  
           ELSE '<' || NVL (b.aa_kurzname, TO_CHAR (b.ts_aa_id)) || '>'
         END         AS typ
       , CASE WHEN b.gezaehlt_von IS NULL AND b.gezaehlt_bis IS NULL THEN b.kommt else null end AS kommt
       , CASE WHEN b.gezaehlt_von IS NULL AND b.gezaehlt_bis IS NULL THEN b.geht else null end AS geht
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


-- sqlcl_snapshot {"hash":"4cf8c8c0d00e4e9ce4cf6c09df66947750f6825c","type":"VIEW","name":"HM_ZV_PAYROLLDATA_4","schemaName":"DIRKSPZM32","sxml":""}