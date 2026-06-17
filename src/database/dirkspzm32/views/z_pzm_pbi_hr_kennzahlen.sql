
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."Z_PZM_PBI_HR_KENNZAHLEN" ("BU_ID", "BU_NAME", "LNR", "JAHR", "MONAT", "NAME", "VORNAME", "PLNR", "PERSONALNUMMER", "KSTNR", "KST_NAME", "ABTEILUNG", "EINTRITT", "AUSTRITT", "GEBURTSDATUM", "ZEITSALDO", "URLAUBSALDO", "LAST_CHANGE_DATE") AS 
  select   b.bu_id,
         b.bu_name,
         'ZEIT' ||
         to_char(p.pers_nr) ||
         get_pers_kst_id(p.pers_nr) ||
         to_char(trunc(sysdate, 'month') -1, 'ddmmyyyy') lnr,
         to_char(trunc(sysdate, 'month') -1, 'yyyy') jahr,
         to_char(trunc(sysdate, 'month') -1, 'mm') monat,
         substr(p.pers_nname, 1, 59) name,
         substr(p.pers_vname, 1, 50) vorname,
         a.abt_pb_id plnr,
         p.pers_nr personalnummer,
         get_pers_kst_id(p.pers_nr) kstnr,
         kst.kst_name,
         substr(a.abt_name, 1, 50) abteilung,
         p.pers_eintrittsdatum eintritt,
         p.pers_austrittdatum austritt,
         null geburtsdatum,
         pzm_kontoverwaltung.zk_get_monat_saldo('01', 1,
                                                p.pers_nr,
                                                'ZK',
                                                to_char(trunc(sysdate, 'month') -1, 'mm'),
                                                to_char(trunc(sysdate, 'month') -1, 'yyyy')) Zeitsaldo,
         pzm_kontoverwaltung.zk_get_monat_saldo('01', 1,
                                                p.pers_nr,
                                                'UKS',
                                                to_char(trunc(sysdate, 'month') -1, 'mm'),
                                                to_char(trunc(sysdate, 'month') -1, 'yyyy')) urlaubsaldo,
         nvl((select max(bh.buch_datum) from pzm_konten_bh bh where bh.pers_nr = p.pers_nr and bh.typ = 'ZK' and bh.zk_start < trunc(sysdate, 'month')), trunc(sysdate, 'month')) last_change_date
         --trunc(sysdate, 'month') + 9 last_change_date
    from pzm_personal p,
         pzm_abteilungen a,
         isi_kostenstellen kst,
         pzm_produktionsbereiche_bu bu,
         pzm_prod_business_units_bereiche b
   where a.abt_id = get_pers_abt_id(p.pers_nr)
     and a.abt_pb_id = bu.pb_id(+)
     and bu.bu_id = b.bu_id(+)
     and kst.kst_nr(+) = get_pers_kst_id(p.pers_nr)
     and p.pers_nr >= 10000
;


-- sqlcl_snapshot {"hash":"3202c64d907e49716e5f3a59f7ff5c229196f6e1","type":"VIEW","name":"Z_PZM_PBI_HR_KENNZAHLEN","schemaName":"DIRKSPZM32","sxml":""}