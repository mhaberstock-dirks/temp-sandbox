
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_V_PERS_SOLL_WOCHENTAG" ("PERS_NR", "ISO_WOCHENTAG") AS 
  with soll as (
  -- Soll-Flags je Schichtmodell, Union ueber alle Perioden-Wochen
  select sp_sm_name,
         max(case when sp_sa_wot_mo is not null then 1 else 0 end) as soll_mo,
         max(case when sp_sa_wot_di is not null then 1 else 0 end) as soll_di,
         max(case when sp_sa_wot_mi is not null then 1 else 0 end) as soll_mi,
         max(case when sp_sa_wot_do is not null then 1 else 0 end) as soll_do,
         max(case when sp_sa_wot_fr is not null then 1 else 0 end) as soll_fr,
         max(case when sp_sa_wot_sa is not null then 1 else 0 end) as soll_sa,
         max(case when sp_sa_wot_so is not null then 1 else 0 end) as soll_so
    from pzm_schicht_perioden
   group by sp_sm_name
),
wochentage as (
  select level as iso_wochentag from dual connect by level <= 7
)
select pm.pers_nr,
       w.iso_wochentag
  from pzm_v_pers_schicht_modell pm
  join soll s on s.sp_sm_name = pm.sm_name
 cross join wochentage w
 where case w.iso_wochentag
         when 1 then s.soll_mo
         when 2 then s.soll_di
         when 3 then s.soll_mi
         when 4 then s.soll_do
         when 5 then s.soll_fr
         when 6 then s.soll_sa
         else        s.soll_so
       end = 1;


-- sqlcl_snapshot {"hash":"7b7b17021eca4ea6b835a3c0d87ce8593b14f14f","type":"VIEW","name":"PZM_V_PERS_SOLL_WOCHENTAG","schemaName":"DIRKSPZM32","sxml":""}