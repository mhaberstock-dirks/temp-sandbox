
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_ZV_PAYROLLDATA_SU4" ("RFID", "PERSNR", "NAME", "ABTEILUNG", "KOSTENSTELLE", "DATUM", "GEBUCHTE_KOSTENSTELLE", "TYP", "KOMMT", "GEHT", "GEZAEHLT_VON", "GEZAEHLT_BIS", "PAUSE_DAUER_MIN", "IST_ZEIT", "GEBUCHTE_ZEIT", "ABWEICHUNG_MINUTEN", "RESPONSIBLE_NR", "PB_ID", "F_ABT_ID", "SA_KURZNAME", "F_ZE_TREFFER", "TREFFER") AS 
  with 
  /**
   * Sub-View nur zur Verwendung in für PZM_ZV_PAYROLLDATA vorgesehen:
   * liste alle Einträge in PZM_ZEITERFASSUNG bei den es nur eine KOMMEN oder GEHEN Buchung gibt.
   * (siehe Jira-Ticket W24120.492)
   * ACHTUNG: Ohne Filter auf "responsible_nr" liefert der View ein kartesisches Produkt!
   * --------
   * Empfohlene Nutzung mit folgendem Query:
   *    SELECT *
   *      FROM pzm_zv_payrolldata_su4
   *     WHERE datum BETWEEN :fromdate AND :todate
   *       AND responsible_nr = :responsibleid
   *       AND (pb_id = :prodbranchid OR :prodbranchid IS NULL)
   *       AND (f_abt_id = :departmentid OR :departmentid IS NULL)      
   */

    qb_pa     /******************************************************************************
               * separater query_block für "pzm_v_get_assigned_personal";
               * nötig, damit Oracle-Optimizer den Filter auf Responsible_Nr per "PUSH_PRED"
               * nach innen führt und somit die Performance auf die View-Abfrage
               * gewährleistet bleibt. 
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
              LEFT JOIN isi_user u ON u.pers_nr = ap.pers_nr)
  /*********************
   * Eigentlicher View, filtert ausschließlich auf PZM_ZEITERFASSUNG
   * OUTER JOIN zu PZM_ZE_TAGESSARTZ is optional und wird im 
   * moment lediglich zu Analyse-Zwecken in SQL - außerhalb der BO-/PL
   * verwendet. 
   * select * from hm_zv_payroll_union4  
    WHERE  datum BETWEEN :fromdate AND :todate 
     and responsible_nr = :ResponsibleId
     AND (pb_id = :prodbranchid OR :prodbranchid IS NULL)
     AND (f_abt_id = :departmentid OR :departmentid IS NULL)

   */              
  SELECT qb_pa.rfid                               as RFID
       , qb_pa.pers_nr                            as persnr
       , qb_pa.name                               as name
       , abt.abt_name                             AS abteilung
       , get_pers_kst_id (qb_pa.pers_nr )         AS kostenstelle
       , z.ze_schicht_tag                         as datum
       , z.ze_kst_id                              as gebuchte_kostenstelle
       , cast('op' as varchar2(22))               as typ                   
       , to_char(z.ze_ist_start, 'hh24:mi')       AS kommt
       , CASE 
           WHEN TRUNC (z.ze_ist_start) < TRUNC (z.ze_ist_ende)
           THEN
             TO_CHAR (TO_NUMBER (TO_CHAR (z.ze_ist_ende, 'hh24')) + 24) || TO_CHAR (z.ze_ist_ende, ':mi')
           ELSE
             TO_CHAR (z.ze_ist_ende, 'hh24:mi')
           END                                    AS geht
       , to_char(z.ze_calc_ist_start, 'hh24:mi')  AS gezaehlt_von
      , CASE
          WHEN TRUNC (z.ze_calc_ist_start) < TRUNC (z.ze_calc_ist_ende)
          THEN
            TO_CHAR (TO_NUMBER (TO_CHAR (z.ze_calc_ist_ende, 'hh24')) + 24) || TO_CHAR (z.ze_calc_ist_ende, ':mi')
          ELSE
            TO_CHAR (z.ze_calc_ist_ende, 'hh24:mi')
        END                                       AS gezaehlt_bis
       , NULL                                     AS pause_dauer_min
       , NULL                                     AS ist_zeit
       , NULL                                     AS gebuchte_zeit
       , NULL                                     AS abweichung_minuten
       , qb_pa.responsible_nr
       , qb_pa.pb_id                              as pb_id
       , qb_pa.f_abt_id
       , z.ze_sa_kurzname                         as sa_kurzname
       /**
        * optionale Spalten zur Analyse in SQL außerhalb BO/PL
        */ 
       , case when (z.ze_calc_ist_start is null     and ze_calc_ist_ende  is null) then 'no calc'
              when (z.ze_ist_start      is not null and ze_ist_ende       is null) then 'kommt ohne geht'
              when (z.ze_ist_ende       is not null and ze_ist_start      is null) then 'geht ohne kommt' 
              when (z.ze_calc_ist_start is not null and ze_calc_ist_ende  is null) then 'calc_kommt ohne calc_geht'
              when (z.ze_calc_ist_ende  is not null and ze_calc_ist_start is null) then 'calc_geht ohne calc_commt'
              else '?'
         end as f_ze_treffer
       , case when (t.TS_PERS_NR is null ) then 'kein tagessatz'
              when (t.TS_DAY_WERT_START IS NULL AND t.ts_day_wert_ende IS NULL) then    'no ts calc'
              else '?'
              end as treffer 
    FROM pzm_zeiterfassung z 
    join qb_pa on z.ze_pers_nr=qb_pa.pers_nr
    join pzm_abteilungen abt on abt.abt_id = z.ze_abt_id
    /** optionaler join zu SQL-Analyse außerhalb BO/PL 
      */ 
    left join pzm_ze_tagessatz t on t.ts_pers_nr=z.ze_pers_nr and t.TS_DATUM=z.ze_schicht_tag
   where (  (z.ze_ist_start      is not null and ze_ist_ende       is null)
         or (z.ze_ist_ende       is not null and ze_ist_start      is null)
         or (z.ze_calc_ist_start is not null and ze_calc_ist_ende  is null)
         or (z.ze_calc_ist_ende  is not null and ze_calc_ist_start is null)
         or (z.ze_calc_ist_start is null     and ze_calc_ist_ende  is null)
         )
     and (  (t.TS_PERS_NR is null ) -- existiert nicht
         or (t.TS_DAY_WERT_START IS NULL AND t.ts_day_wert_ende IS NULL)  -- Anforderung von Adriano
         );


-- sqlcl_snapshot {"hash":"353f7fb8979e11eae1be681238e23a8aeb934895","type":"VIEW","name":"PZM_ZV_PAYROLLDATA_SU4","schemaName":"DIRKSPZM32","sxml":""}