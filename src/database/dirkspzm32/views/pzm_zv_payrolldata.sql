
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_ZV_PAYROLLDATA" ("Rfid", "EmployeeId", "Name", "Department", "CostCenter", "PayrollDate", "BilledCostCenter", "Type", "StartTime", "EndTime", "EvaluatedStartTime", "EvaluatedEndTime", "PauseTime", "ActualTime", "BilledTime", "DiffTime", "RESPONSIBLE_NR", "ProdBranchId", "ABT_ID", "ShiftTypeShortname") AS 
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
    FROM pzm_zv_payrolldata_base b
   WHERE b.ist_zeit > 0 
     AND NOT (    kommt IS NULL                                       -- ausgenommen  bezahlte Abwesenheit
              AND geht IS NULL) 
  UNION ALL
       ------- Zweig 2 - halbe Urlaubstage -------  
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
    FROM pzm_zv_payrolldata_base b
   WHERE b.ist_zeit > 0 AND b.kennz_urlaub = 'T'
  UNION ALL
       ------- Zweig 3 - verschiedene Abwesenheitseinträge  -------  
  SELECT b.rfid
       , b.persnr
       , b.name
       , b.abt_name                 AS abteilung
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
         END                        AS typ
       , NULL                       AS kommt
       , NULL                       AS geht
       -- , case when nvl(b.ist_zeit,0) >0 then b.gezaehlt_von else null end as gezaehlt_von
       -- , case when nvl(b.ist_zeit,0) >0 then b.gezaehlt_bis else null end as gezaehlt_bis
       , NULL                       AS gezaehlt_von
       , NULL                       AS gezaehlt_bis
       , NULL                       AS pause_dauer_min
       , ROUND (b.ist_zeit, 2)      AS ist_zeit
       , NULL                       AS gebuchte_zeit
       , NULL                       AS abweichung_minuten
       , b.responsible_nr
       , b.pb_id
       , b.f_abt_id
       , b.sa_kurzname
    FROM pzm_zv_payrolldata_base b
   WHERE (b.ist_zeit = 0
      OR (b.ist_zeit >0 and b.ts_aa_id is not null and kommt is null and geht is null)) -- bezahlte Abwesenheit
   --  and b.gezaehlt_von is not null and b.gezaehlt_bis is not null -- die werden im nächsten UNION-Zweig erfasst
  UNION ALL      
       ------- Zweig 4 - Unvollständig erfasste Zeiten  -------  
  select u4.rfid
       , u4.persnr
       , u4.name
       , u4.abteilung
       , u4.kostenstelle
       , u4.datum
       , u4.gebuchte_kostenstelle
       , cast(u4.typ as varchar2(22))                   
       , u4.kommt
       , u4.geht
       , u4.gezaehlt_von
       , u4.gezaehlt_bis
       , u4.pause_dauer_min
       , u4.ist_zeit
       , u4.gebuchte_zeit
       , u4.abweichung_minuten
       , u4.responsible_nr
       , u4.pb_id                              
       , u4.f_abt_id
       , u4.sa_kurzname 
    from pzm_zv_payrolldata_su4 u4
  ORDER BY persnr, datum;


-- sqlcl_snapshot {"hash":"2b7ebcd33a1599404039aefdb8e47c5c36f045e5","type":"VIEW","name":"PZM_ZV_PAYROLLDATA","schemaName":"DIRKSPZM32","sxml":""}