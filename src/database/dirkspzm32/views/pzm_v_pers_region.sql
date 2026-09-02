
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_V_PERS_REGION" ("PERS_NR", "PERS_LAND", "PERS_REGION_CODE") AS 
  select p.pers_nr,
       -- Rang 1 (Person): pers_land/pers_region_code direkt auf pzm_personal,
       --   nur wenn BEIDE gesetzt sind gilt dieser Rang als vollstaendig.
       case
         when p.pers_land is not null and p.pers_region_code is not null
           then p.pers_land
         -- Rang 2 (Kostenstelle): ueber isi_kostenstellen -> isi_adressen.
         when akst.land_kurz is not null and akst.region_code is not null
           then nvl(p.pers_land, akst.land_kurz)
         -- Rang 3 (Abteilung): ueber pzm_abteilungen -> isi_adressen.
         when aabt.land_kurz is not null and aabt.region_code is not null
           then nvl(p.pers_land, nvl(akst.land_kurz, aabt.land_kurz))
         -- Rang 4 (Produktionsbereich): ueber pzm_produktionsbereiche -> isi_adressen.
         when apb.land_kurz is not null and apb.region_code is not null
           then nvl(p.pers_land, nvl(akst.land_kurz, nvl(aabt.land_kurz, apb.land_kurz)))
         -- Rang 5 (Tenant-Fallback): Mandanten-Adresse (adr_art='E', adr_nr=1, adr_liefer=0).
         else nvl(p.pers_land, nvl(akst.land_kurz, nvl(aabt.land_kurz, nvl(apb.land_kurz, atn.land_kurz))))
       end as pers_land,
       case
         -- Rang 1 (Person)
         when p.pers_land is not null and p.pers_region_code is not null
           then p.pers_region_code
         -- Rang 2 (Kostenstelle)
         when akst.land_kurz is not null and akst.region_code is not null
           then nvl(p.pers_region_code, akst.region_code)
         -- Rang 3 (Abteilung)
         when aabt.land_kurz is not null and aabt.region_code is not null
           then nvl(p.pers_region_code, nvl(akst.region_code, aabt.region_code))
         -- Rang 4 (Produktionsbereich)
         when apb.land_kurz is not null and apb.region_code is not null
           then nvl(p.pers_region_code, nvl(akst.region_code, nvl(aabt.region_code, apb.region_code)))
         -- Rang 5 (Tenant-Fallback)
         else nvl(p.pers_region_code, nvl(akst.region_code, nvl(aabt.region_code, nvl(apb.region_code, atn.region_code))))
       end as pers_region_code
  from pzm_personal p
       -- Abteilung der Person (fuer Rang 3 und als Zwischenschritt zu Rang 2/4)
  left join pzm_abteilungen abt on abt.abt_id = p.pers_abt_id
       -- Produktionsbereich: direkt an der Person, sonst ueber die Abteilung (Rang 4)
  left join pzm_produktionsbereiche pb on pb.pb_id = nvl(p.pers_pb_id, abt.abt_pb_id)
       -- Kostenstelle: direkt an der Person, sonst Abteilungs- bzw. PB-Standard-Kostenstelle (Rang 2)
  left join isi_kostenstellen kst on kst.kst_nr = nvl(p.pers_kst_id, nvl(abt.abt_kst_id, pb.pb_kst_id))
  left join isi_adressen akst on akst.adress_id = kst.kst_adress_id
  left join isi_adressen aabt on aabt.adress_id = abt.abt_adress_id
  left join isi_adressen apb on apb.adress_id = pb.pb_adress_id
       -- Tenant-Fallback-Adresse (Rang 5); liefert NULL statt Crash, wenn sie fehlt
  left join isi_adressen atn on atn.adr_art = 'E' and atn.adr_nr = 1 and atn.adr_liefer = 0;


-- sqlcl_snapshot {"hash":"ecf56ff7ffb9c2d5a16b9e49fcdf3216436bdc0f","type":"VIEW","name":"PZM_V_PERS_REGION","schemaName":"DIRKSPZM32","sxml":""}