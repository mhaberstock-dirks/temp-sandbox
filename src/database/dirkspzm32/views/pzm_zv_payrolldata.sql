
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_ZV_PAYROLLDATA" ("Rfid", "EmployeeId", "Name", "Department", "CostCenter", "PayrollDate", "BilledCostCenter", "Type", "StartTime", "EndTime", "EvaluatedStartTime", "EvaluatedEndTime", "PauseTime", "ActualTime", "BilledTime", "DiffTime", "RESPONSIBLE_NR", "ProdBranchId", "ABT_ID", "ShiftTypeShortname") AS 
  SELECT
  /**
   * View für PresentationLogic "PayrollDataAnalysisReport"
   * Bei Abfrage ist mindestens ein Filter auf RESPONSIBLE_NR nötig, da andernfalls
   * ein kartesisches Produkt gebildet wird, das zu gravierenden Ressourcen-Belastungen
   * des Datenbank-Servers führt! 
   * Der View benötigt 2 Sub-Views
   *  - PZM_ZV_PAYROLLDATA_BASE: 
   *    sammelt Daten aus PZM_ZE_TAGESSATZ und PZM_ZEITERFASSUNG
   *    Die Ergebnisse werden in 3 verschiedenen Union-Zweigen 
   *    gefiltert: 
   *    Zweig 1: Alle Arbeitszeiten je Mitarbeiter und Tag, versehen mit Type='an'
   *    Zweig 2: Alle Urlaubszeiten an Tagen mit Arbeitszei (halbe Urlaubstage markiert
   *             mit Type='uh'
   *    Zweig 3: Alle gebuchten Abwesenheitszeiten, markiert mit verschiedenen 
   *             "Type"-Werten
   *  - PZM_ZV_PAYROLLDATA_SU4:
   *    listet sämtliche vermutlich unvollständig erfassten Arbeitszeiteinträge,
   *    markiert mit Type='op'.
   *    Das sind solche in PZM_ZEITERFASSUNG bei denen ze_calc_ist_start und 
   *    ze_calc_ist_ende nicht gesetzt sind, sowie "Kommt" ohne "Geht"-Einträge
   *    und "Geht" ohne Kommt"Einträge (soweit sie nicht durch die erste Bedingung 
   *    schon gefunden werden. Das Ergebnis wird in UNION-Zweig 4 gefiltert.      
   */
       ------- Zweig 1 - Anwesenheits-Einträge -------  
         b.rfid                                                          
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
    FROM PZM_ZV_PAYROLLDATA_BASE b
   WHERE b.ist_zeit > 0 AND b.kennz_urlaub = 'T'
  UNION ALL
       ------- Zweig 3 - verschiedene Abwesenheitseinträge  -------  
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
     and b.gezaehlt_von is not null and b.gezaehlt_bis is not null -- die werden im nächsten UNION-Zweig erfasst
  UNION ALL      
       ------- Zweig 4 - Unvollständig erfasste Zeiten  -------  
  select u4.RFID
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


-- sqlcl_snapshot {"hash":"14e23f9fa7f4171298161327a4447a642f262c35","type":"VIEW","name":"PZM_ZV_PAYROLLDATA","schemaName":"DIRKSPZM32","sxml":""}