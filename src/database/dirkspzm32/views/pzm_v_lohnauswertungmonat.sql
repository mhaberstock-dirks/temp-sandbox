
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_LOHNAUSWERTUNGMONAT" ("EmployeeId", "ShiftDay", "CostCenterId", "ShiftShortName", "DayAbsenceTypeId", "ExpectedWorkingHours", "TimeStart", "TimeEnd", "TimeStartCalculated", "TimeEndCalculated", "DayWorkingHours", "AbsenceHours", "DayOnSiteHours", "DayBreakHours", "OvertimeHours", "FlexiHours", "DayRecordedTimes", "DayCalculatedTimes", "DayAbsenceNames", "DayAbsenceValues", "DayWageTypeValues", "DayTotalWorkingHours", "ExpectedWorkingHoursDiff") AS 
  WITH a as (select
    ts.ts_pers_nr                                                 pers_nr,
    ts.ts_datum,
    ts.ts_day_kst_id                                              kst_id, -- (3) kein Funktionsaufruf mehr, kein Fallback da kst_id gesetzt
    ts.ts_sa_kurzname                                             sa_kurzname,
    case when pb.pb_extern = 'T' then null else ts.ts_aa_id end   aa_id,  -- (1) pb_extern aus JOIN
    round(nvl(sa.sa_std_pro_tag, sm.d_arb_std_pro_tag), 3)        ts_day_soll_std,
    to_char(ts.ts_day_ist_start,  'hh24:mi')                      ze_ist_start,
    to_char(ts.ts_day_ist_ende,   'hh24:mi')                      ze_ist_ende,
    to_char(ts.ts_day_wert_start, 'hh24:mi')                      ze_calc_start,
    to_char(ts.ts_day_wert_ende,  'hh24:mi')                      ze_calc_ende,
    round(ts.ts_day_arb_std,      3)                              ts_day_arb_std,
    round(ts.ts_day_abw_std,      3)                              ts_day_abw_std,
    round((ts.ts_day_ist_ende - ts.ts_day_ist_start) * 24, 3)     ts_day_anw_std,
    round(ts.ts_day_pause_std,    3)                              ts_day_pause_std,
    -- (4) nur "genehmigte" Ueberstunden ausgeben
    case when ts.ts_ueb_ok_datum     is null 
         then 0
         when ts.ts_ueb_storno_datum is null 
         then nvl(ts.ts_day_ueb_std,  0)
         else 0 end                                               ts_day_ueb_std,
    -- nur "genehmigte" Flexstunden ausgeben         
    case when ts.ts_ueb_ok_datum     is null 
         then 0
         when ts.ts_ueb_storno_datum is null 
         then nvl(ts.ts_day_flex_std, 0)
         else 0 
    end                                                           ts_day_flex_std,
    -- ts_ges_arb_std
    -- Gesamte Arbeitsstunden inkl. genehmigter Ueber- und Flexstunden
    nvl(ts.ts_day_arb_std, 0) 
    + nvl(ts.ts_day_korr_std, 0)
    + case when ts.ts_ueb_ok_datum     is null 
           then 0
           when ts.ts_ueb_storno_datum is null
           then nvl(ts.ts_day_ueb_std, 0)
              + nvl(ts.ts_day_flex_std, 0)
           else 0 
      end                                                        ts_ges_arb_std,
    -- (2) vier ZE-Scans ¿ ein JOIN + konditionaler LISTAGG
    listagg(
        case when ze.ze_aa_status is null 
               or pb.pb_extern = 'F'
             then case when ze.ze_ist_start is null 
                       then ' '
                       else to_char(ze.ze_ist_start, 'hh24:mi') || 
                            '-' || to_char(ze.ze_ist_ende, 'hh24:mi')
                  end
              end
      , cr_lf()) 
      within group (order by ze.ze_calc_ist_start, ze.ze_id)     ist_zeiten_list_cr,
    listagg(
        case when ze.ze_aa_status is null 
          or pb.pb_extern = 'F' 
        then case when ze.ze_calc_ist_start is null 
                  then ' '
                  else to_char(ze.ze_calc_ist_start, 'hh24:mi') || 
                       '-' || to_char(ze.ze_calc_ist_ende, 'hh24:mi')|| 
                       ' ' || decode(ze.ze_status, 4,'P', 5,'D', 6,'F', ' ')
                  end
        end
      , cr_lf()) 
      within group (order by ze.ze_calc_ist_start, ze.ze_id)     calc_zeiten_list_cr,
    listagg(case when ze.ze_aa_status is null or pb.pb_extern = 'F'
                 then case when ze.ze_aa_status is null then ' '
                           else nvl(aa.aa_kurzname, to_char(ze.ze_aa_status))
                      end
            end, cr_lf()) within group (order by ze.ze_calc_ist_start)               aa_kurzname_list_cr,
    listagg(case when ze.ze_aa_status is null or pb.pb_extern = 'F'
                 then case when ze.ze_aa_status is null then ' '
                           else case when ze.ze_std > 0 and ze.ze_std < 1 then '0' end
                             || round(ze.ze_std, 3)
                      end
            end, cr_lf()) within group (order by ze.ze_calc_ist_start)               aa_std_list_cr,
    -- loa_list_cr bleibt als Subquery (andere Quelle: pzm_ze_loa_ausw)
    (select listagg(
                loa_ausw.zeaw_lz_lohnart || ': '
                || case when loa_ausw.zeaw_lz_loa_std > 0
                             and loa_ausw.zeaw_lz_loa_std < 1 then '0' end
                || decode(loa.lz_einheit, 'HH24',
                          round(loa_ausw.zeaw_lz_loa_std, 3) || ' h',
                          round(loa_ausw.zeaw_lz_loa_std, 1) || ' d')
                || ' (' || loa.lz_bemerkungen || ')',
                cr_lf()) within group (order by loa_ausw.zeaw_lz_lohnart)
     from pzm_ze_loa_ausw loa_ausw
     left join pzm_lohnarten loa on loa.lz_id = loa_ausw.zeaw_lz_id
     where loa_ausw.zeaw_pers_nr = ts.ts_pers_nr
       and loa_ausw.zeaw_datum   = ts.ts_datum
       and (loa.lz_operator != 'ERP_ZUS_ZK' or pb.pb_extern = 'F')                   
       and nvl(loa.lz_operator, 'X') != 'ARBSTD')                                  loa_list_cr
from     pzm_ze_tagessatz         ts
    join pzm_personal             p   on p.pers_nr      = ts.ts_pers_nr
    join pzm_produktionsbereiche  pb  on pb.pb_id       = p.pers_pb_id   -- (1) einmalig
    join pzm_abteilungen          abt on abt.abt_id     = p.pers_abt_id
    left join pzm_schichtarten    sa  on sa.sa_kurzname = ts.ts_sa_kurzname
    left join pzm_schicht_modelle sm  on sm.sm_name     = nvl(p.pers_sm_name, abt.abt_standard_sm_name)
    left join pzm_zeiterfassung   ze  on ze.ze_pers_nr  = ts.ts_pers_nr  -- (2) einmalig
                                     and ze.ze_schicht_tag = ts.ts_datum
    left join pzm_abwesenheitsarten aa on aa.aa_id      = ze.ze_aa_status
where
    ts.ts_day_wert_ende is not null
group by
    ts.ts_pers_nr, ts.ts_datum, ts.ts_day_kst_id, p.pers_kst_id,
    pb.pb_extern, ts.ts_aa_id, ts.ts_sa_kurzname,
    sm.d_arb_std_pro_tag, sa.sa_std_pro_tag,
    ts.ts_day_ist_start, ts.ts_day_ist_ende,
    ts.ts_day_wert_start, ts.ts_day_wert_ende,
    ts.ts_day_arb_std, ts.ts_day_abw_std,
    ts.ts_day_pause_bez_std, ts.ts_day_pause_std,
    ts.ts_day_ueb_std, ts.ts_day_flex_std,
    ts.ts_ueb_ok_datum, ts.ts_ueb_storno_datum,
    ts.ts_day_korr_std
order by
    ts.ts_datum) 
select a.pers_nr             as "EmployeeId"                        --
     , a.ts_datum            as "ShiftDay"
     --ShiftDayOfWeek muss in Dot.Net abgeleitet werden wegen aktiver Spracheinstellung des Frontend (Deutsch/Englisch,Polnisch, etc)
     , a.kst_id              as "CostCenterId"
     , a.sa_kurzname         as "ShiftShortName"
     , a.aa_id               as "DayAbsenceTypeId"
     , a.ts_day_soll_std     as "ExpectedWorkingHours"
     , a.ze_ist_start        as "TimeStart"
     , a.ze_ist_ende         as "TimeEnd"
     , a.ze_calc_start       as "TimeStartCalculated"
     , a.ze_calc_ende        as "TimeEndCalculated"
     , a.ts_day_arb_std      as "DayWorkingHours"
     , a.ts_day_abw_std      as "AbsenceHours"
     , a.ts_day_anw_std      as "DayOnSiteHours"
     , a.ts_day_pause_std    as "DayBreakHours"
     , a.ts_day_ueb_std      as "OvertimeHours"
     , a.ts_day_flex_std     as "FlexiHours"
     , a.ist_zeiten_list_cr  as "DayRecordedTimes"
     , a.calc_zeiten_list_cr as "DayCalculatedTimes"
     , a.aa_kurzname_list_cr as "DayAbsenceNames"
     , a.aa_std_list_cr      as "DayAbsenceValues"
     , a.loa_list_cr         as "DayWageTypeValues"
     , a.ts_ges_arb_std      as "DayTotalWorkingHours"
     , case when a.ts_ges_arb_std = 0 
            then NULL 
            else case when lz.lz_operator in ('U', 'K', 'SU')
                 then NULL      -- Nicht berechnen bei Urlaub, Krankheit und SonderUrlaub 
                 else a.ts_ges_arb_std - a.ts_day_soll_std 
                 end
       end                   as "ExpectedWorkingHoursDiff" -->Saldo nur wenn  
  from a 
   left join pzm_abwesenheitsarten aa on aa.aa_id=a.aa_id 
   left join pzm_lohnarten lz on lz.lz_id=aa.lz_id
 order by a.ts_datum;


-- sqlcl_snapshot {"hash":"770cb39843dd6ca5d2126d22e680ba6e6ebd8c0a","type":"VIEW","name":"PZM_V_LOHNAUSWERTUNGMONAT","schemaName":"DIRKSPZM32","sxml":""}