
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_ZWAGEEVALUATIONPEREMPLOYEE" ("EmployeeId", "ShiftDay", "ShiftShortName", "DayAbsenceTypeId", "CostCenterId", "ExpectedWorkingHours", "DayOnSiteHours", "DayWorkingHours", "DayTotalWorkingHours", "ExpectedWorkingHoursDiff", "AbsenceHours", "TimeStart", "TimeEnd", "TimeStartCalculated", "TimeEndCalculated", "DayBreakHours", "OvertimeHours", "FlexiHours", "DayRecordedTimes", "DayCalculatedTimes", "DayAbsenceNames", "DayAbsenceValues", "DayWageTypeValues", "UNION_ORDER", "DataSourceInfo", "feiertagszuschlag", "nachtzuschlag", "sonntagszuschlag", "samstagszuschlag") AS 
  select
    loa_ausw."EmployeeId"
   ,loa_ausw."ShiftDay"    -- ts_datum
   ,loa_ausw."ShiftShortName"
   ,loa_ausw."DayAbsenceTypeId"
   ,loa_ausw."CostCenterId"

   ,loa_ausw."ExpectedWorkingHours"     -- ts_day_soll_std,
   ,loa_ausw."DayOnSiteHours"           -- ts_day_anwesenheit_std,
   ,loa_ausw."DayWorkingHours"          -- ts_day_arb_std,
   ,loa_ausw."DayTotalWorkingHours"     -- ts_ges_arb_std
   ,loa_ausw."ExpectedWorkingHoursDiff" -- (DayTotalWorkingHours.Value - ExpectedWorkingHours.Value)
   ,loa_ausw."AbsenceHours"             -- ts_day_abw_std,

   ,loa_ausw."TimeStart"                -- ze_ist_start,
   ,loa_ausw."TimeEnd"                  -- ze_ist_ende,
   ,loa_ausw."TimeStartCalculated"      -- ze_calc_start,
   ,loa_ausw."TimeEndCalculated"        -- ze_calc_ende,

   ,loa_ausw."DayBreakHours"            -- ts_day_pause_std,
   ,loa_ausw."OvertimeHours"            -- ts_day_ueb_std,
   ,loa_ausw."FlexiHours"               -- ts_day_flex_std,

   ,loa_ausw."DayRecordedTimes"         -- ist_zeiten_list_cr,
   ,loa_ausw."DayCalculatedTimes"       -- calc_zeiten_list_cr,
   ,loa_ausw."DayAbsenceNames"          -- aa_kurzname_list_cr
   ,loa_ausw."DayAbsenceValues"         -- aa_std_list_cr
   ,loa_ausw."DayWageTypeValues"        -- loa_list_cr

   ,loa_ausw.union_order
   ,loa_ausw."DataSourceInfo"

    -- Feiertagszuschlag (Lohnart 518)
   ,to_number(regexp_substr(loa_ausw."DayWageTypeValues", '518:.*?([0-9]+[.,]?[0-9]*)', 1, 1, null, 1)) as "feiertagszuschlag"

    -- Nachtzuschlag (Lohnart 516)
   ,to_number(regexp_substr(loa_ausw."DayWageTypeValues", '516:.*?([0-9]+[.,]?[0-9]*)', 1, 1, null, 1)) as "nachtzuschlag"

    -- Sonntagszuschlag (Lohnart 517)
   ,to_number(regexp_substr(loa_ausw."DayWageTypeValues", '517:.*?([0-9]+[.,]?[0-9]*)', 1, 1, null, 1)) as "sonntagszuschlag"

    -- Samstagszuschlag (Lohnart 519)
   ,to_number(regexp_substr(loa_ausw."DayWageTypeValues", '519:.*?([0-9]+[.,]?[0-9]*)', 1, 1, null, 1)) as "samstagszuschlag"
from pzm_v_WageEvaluationPerEmployee loa_ausw;


-- sqlcl_snapshot {"hash":"ff508c1dc36d012b3fb9221c713c42a85ea15746","type":"VIEW","name":"PZM_V_ZWAGEEVALUATIONPEREMPLOYEE","schemaName":"DIRKSPZM32","sxml":""}