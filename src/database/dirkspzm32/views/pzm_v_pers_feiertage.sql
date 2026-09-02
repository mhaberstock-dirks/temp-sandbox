
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_V_PERS_FEIERTAGE" ("PERS_NR", "PERS_REGION_CODE", "F_DATUM", "F_NAME", "F_NAME_EN", "F_SONDER_FEIERTAG", "F_COUNTRY", "F_REGION_CODES_CSV") AS 
  select v.pers_nr,
       v.pers_region_code,
       f.f_datum,
       f.f_name,
       f.f_name_en,
       f.f_sonder_feiertag,
       f.f_country,
       f.region_codes_csv as f_region_codes_csv
  from pzm_v_pers_region v
  join isi_feiertage f
    on f.f_country = v.pers_land
   and exists (
         select 1
           from table(strsplit(f.region_codes_csv, ';')) rc
          where nvl(v.pers_region_code, rc.column_value) like rc.column_value || '%'
       );


-- sqlcl_snapshot {"hash":"a26e84ede9e827c94c644bb4b7250b8d585b1afe","type":"VIEW","name":"PZM_V_PERS_FEIERTAGE","schemaName":"DIRKSPZM32","sxml":""}