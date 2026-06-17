
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_WAGEEVALUATIONPEREMPLOYEE" ("UNION_ORDER", "DataSourceInfo", "EmployeeId", "ShiftDay", "CostCenterId", "ShiftShortName", "DayAbsenceTypeId", "ExpectedWorkingHours", "TimeStart", "TimeEnd", "TimeStartCalculated", "TimeEndCalculated", "DayOnSiteHours", "AbsenceHours", "DayWorkingHours", "DayBreakHours", "OvertimeHours", "FlexiHours", "DayTotalWorkingHours", "DayRecordedTimes", "DayCalculatedTimes", "DayAbsenceNames", "DayAbsenceValues", "DayWageTypeValues", "ExpectedWorkingHoursDiff") AS 
  select 0 union_order,
       'ZE' "DataSourceInfo", -- data_src,  ZE = tägliche Zeiterfassung (time collection)
       vts."EmployeeId",
       vts."ShiftDay",
       to_char(vts."CostCenterId") "CostCenterId",
       vts."ShiftShortName",
       vts."DayAbsenceTypeId",

       vts."ExpectedWorkingHours", 

       vts."TimeStart",
       vts."TimeEnd",
       vts."TimeStartCalculated",
       vts."TimeEndCalculated",
       vts."DayOnSiteHours",
       vts."AbsenceHours",
       vts."DayWorkingHours",
       vts."DayBreakHours",

       vts."OvertimeHours",
       vts."FlexiHours",
       vts."DayTotalWorkingHours",
       

       vts."DayRecordedTimes",
       vts."DayCalculatedTimes",
       vts."DayAbsenceNames",
       vts."DayAbsenceValues",
       vts."DayWageTypeValues",
       vts."ExpectedWorkingHoursDiff"
       
  from PZM_V_LohnAuswertungMonat vts

union

-- ERP/HOST (Lohnbuchhaltungssoftware) Datensätze, die erst am Monatsende verfügbar sind
select 1 union_order,
       'LOA_EXP' "DataSourceInfo", -- für den Export generierte LOA-Daten
       loa_exp.Pers_Nr "EmployeId",
       trunc(loa_exp.datum) - 1 "ShiftDay",
       nvl(stradd_distinct(to_char(loa_exp.kst_id)), to_char(get_pers_kst_id(loa_exp.pers_nr))) "CostCenterId",
       null "ShiftShortName",
       null "DayAbsenceTypeId",

       null "ExpectedWorkingHours", 
       null "TimeStart",
       null "TimeEnd",
       null "TimeStartCalculated",
       null "TimeEndCalculated",
       null "DayOnSiteHours",
       null "AbsenceHours",
       null "DayWorkingHours",
       null "DayBreakHours",
       null "OvertimeHours",
       null "FlexiHours",
       null "DayTotalWorkingHours",
       null "DayRecordedTimes",
       null "DayCalculatedTimes",
       null "DayAbsenceNames",
       null "DayAbsenceValues",
       listagg(
         loa_exp.lohnart
           || ': '
           || case when loa_exp.loa_value > 0 and loa_exp.loa_value < 1 then '0' else '' end -- display leading '0'
           || decode(loa_exp.loa_unit,
                'HH24', round(loa_exp.loa_value, 2) || ' h',
                'STD', round(loa_exp.loa_value, 2) || ' h',
                loa_exp.loa_value || ' d'
              )
           || ' (' || loae.lz_bemerkungen || ')',
         cr_lf()
       ) within group (order by loa_exp.lohnart) "DayWageTypeValues",
       null "ExpectedWorkingHoursDiff"
       
  from pzm_ze_loa_exp_host loa_exp
       left join pzm_lohnarten loae
         on loae.lz_id = loa_exp.lz_id
 group by
       loa_exp.pers_nr,
       trunc(loa_exp.datum)--,
       --loa_exp.kst_id

union

-- Statistik-Werte aus der Zeiterfassung für ERP/HOST (Lohnbuchhaltungssoftware),
-- die erst am Monatsende verfügbar sind
select 2 union_order,
       'STAT_EXP' "DataSourceInfo", -- für den Export generierte LOA-Daten
       loa_stat.Pers_Nr "EmployeId",
       trunc(loa_stat.datum) - 1 "ShiftDay",
       to_char(get_pers_kst_id(loa_stat.pers_nr)) "CostCenterId",
       null "ShiftShortName",
       null "DayAbsenceTypeId",

       null "ExpectedWorkingHours", 
       null "TimeStart",
       null "TimeEnd",
       null "TimeStartCalculated",
       null "TimeEndCalculated",
       null "DayOnSiteHours",
       null "AbsenceHours",
       null "DayWorkingHours",
       null "DayBreakHours",
       null "OvertimeHours",
       null "FlexiHours",
       null "DayTotalWorkingHours",
       null "DayRecordedTimes",
       null "DayCalculatedTimes",
       null "DayAbsenceNames",
       null "DayAbsenceValues",
       listagg(
         loa_stat.stat_unit
           || ': '
           || case when loa_stat.stat_value > 0 and loa_stat.stat_value < 1 then '0' else '' end -- display leading '0'
           || decode(stat_cfg.value_unit,
                'HH24', round(loa_stat.stat_value, 2) || ' h',
                'STD', round(loa_stat.stat_value, 2) || ' h',
                loa_stat.stat_value || ' d'
              )
           || ' (' || stat_cfg.kommentar || ')',
         cr_lf()
       ) within group (order by loa_stat.stat_unit) "DayWageTypeValues",
       null "ExpectedWorkingHoursDiff"
  from pzm_ze_loa_statistik_exp_host loa_stat
       left join pzm_ze_loa_statistik_cfg stat_cfg
         on stat_cfg.stat_unit = loa_stat.stat_unit
 group by
       loa_stat.pers_nr,
       trunc(loa_stat.datum)

 order by "ShiftDay", union_order;


-- sqlcl_snapshot {"hash":"e8f14bd72e032254b46d3ce2bddbe9f71c642256","type":"VIEW","name":"PZM_V_WAGEEVALUATIONPEREMPLOYEE","schemaName":"DIRKSPZM32","sxml":""}