
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."PZM_V_GET_ASSIGNED_PERSONAL" ("RESPONSIBLE_NR", "RESPONSIBLE_ABT_ID", "RESPONSIBLE_TYPE", "PB_ID", "ABT_ID", "PERS_NR") AS 
  select pers.responsible_nr,
       pers.responsible_abt_id responsible_abt_id,
       stradd_distinct(pers.responsible_typ) responsible_type,
       pers.pb_id,
       pers.abt_id,
       pers.pers_nr
  from
  ( select rp.pers_nr responsible_nr,
           rp.pers_abt_id responsible_abt_id,
           'V' responsible_typ,
           nvl(p.pers_pb_id, a.abt_pb_id) pb_id,
           p.pers_abt_id abt_id,
           p.pers_nr
      from pzm_personal rp,
           pzm_abteilungen a,
           pzm_personal p
     where p.pers_abt_id = a.abt_id
       and a.abt_id in (select xa.abt_id
                          from pzm_abteilungen xa
                         start with xa.abt_id in (select xal.abt_l_abt_id from pzm_abt_leitung xal where xal.abt_l_pers_nr = rp.pers_nr)
                       connect by prior xa.abt_id = xa.abt_parent_abt_id)
     group by rp.pers_nr,
              rp.pers_abt_id,
              p.pers_nr,
              p.pers_abt_id,
              nvl(p.pers_pb_id, a.abt_pb_id)
    UNION
    select rp.pers_nr responsible_nr,
           ra.abt_id  responsible_abt_id,
           'P' responsible_typ,
           nvl(p.pers_pb_id, a.abt_pb_id) pb_id,
           a.abt_id,
           p.pers_nr
      from pzm_personal rp,
           pzm_abteilungen ra,
           pzm_produktionsbereiche pb,
           pzm_abteilungen a,
           pzm_personal p
     where rp.pers_abt_id = ra.abt_id
       and ra.abt_typ = 'PERSONALABTEILUNG'
       and pb.pb_id = a.abt_pb_id
       and p.pers_abt_id = a.abt_id
       and (a.abt_personal_abt_id = ra.abt_id
        or  a.abt_personal_abt_id = pb.pb_personal_abt_id)
   ) pers
 group by pers.responsible_nr,
          pers.responsible_abt_id,
          pers.pb_id,
          pers.abt_id,
          pers.pers_nr
 order by pers.responsible_nr,
          pers.pb_id,
          pers.abt_id,
          pers.pers_nr
;


-- sqlcl_snapshot {"hash":"ef542b62f006edf05e65fc54bd6172876ad1d1e0","type":"VIEW","name":"PZM_V_GET_ASSIGNED_PERSONAL","schemaName":"DIRKSPZM32","sxml":""}