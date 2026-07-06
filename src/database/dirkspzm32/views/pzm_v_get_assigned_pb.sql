
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_GET_ASSIGNED_PB" ("PERS_NR", "PB_ID", "PB_NAME", "RESP_ZWEIG") AS 
  with h as
(  -- Abteilungs-Hierarchie
   select root.abt_id   as root_abt_id
        , sub.abt_id    as sub_abt_id
        , sub.abt_pb_id as pb_id
   from pzm_abteilungen root
   join pzm_abteilungen sub
     on sub.abt_id in (
       select abt_id
         from pzm_abteilungen
        start with abt_id=root.abt_id
      connect by prior abt_id=abt_parent_abt_id
     )
)
, v as
( -- der eigentliche View ermittelt Produtionsbereiche entweder über
  -- 1. Hierarchische Verantwortlichkeit über Abt.-Leitung aller untergeordneter Abteilungen
select distinct l.abt_l_pers_nr as pers_nr, h.pb_id, 'L' as zweig
  from pzm_abt_leitung l
  join h on h.root_abt_id=l.abt_l_abt_id
union
 -- 2. MA in Personal-Abteilung: Ermittlung über Abteilungen
select distinct rp.pers_nr, a.abt_pb_id pb_id, 'PA' as zweig
  from pzm_personal rp
  join pzm_abteilungen ra on ra.abt_id=rp.PERS_ABT_ID
  join pzm_abteilungen a on a.abt_personal_abt_id = ra.abt_id
 where ra.abt_typ = 'PERSONALABTEILUNG'
union
-- 3. MA in Personal-Abteilung: Ermittlung über Produktionsbereiche
select distinct rp.pers_nr, pb.pb_id, 'PB' as zweig
  from pzm_personal rp
  join pzm_abteilungen ra on ra.abt_id = rp.pers_abt_id
  join pzm_produktionsbereiche pb on pb.pb_personal_abt_id=ra.abt_id
 where ra.abt_typ = 'PERSONALABTEILUNG'
)
select v.pers_nr, v.pb_id, p.pb_name, stradd_distinct(v.zweig) resp_zweig
 from v left join pzm_produktionsbereiche p on p.pb_id=v.pb_id
group by v.pers_nr, v.pb_id, p.pb_name
order by pb_id
;


-- sqlcl_snapshot {"hash":"071bd40d6e95b29d8f00c950fbad81a25f528db9","type":"VIEW","name":"PZM_V_GET_ASSIGNED_PB","schemaName":"DIRKSPZM32","sxml":""}