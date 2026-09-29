
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PZM_V_VORGANGSQUAL_PERS_SUCHE" ("DATUM", "ABT_L_PERS_NR", "VQ_ID", "VQ_ABT_ID", "ABT_NAME", "WOCHENTAG", "SCHICHT_NR", "ZEITEN", "PERS_BEDARF", "PERSONAL_PLAN", "GEPL_PERSONAL", "PERS_NR_VORSCHL") AS 
  select d_list.datum,
       vqb.abt_l_pers_nr,
       vqb.vq_id,
       vqb.vq_abt_id,
       vqb.abt_name,
       isi_utils.Iso_WeekDay(d_list.datum) wochentag,
       vqb.schicht_nr,
       vqb.Zeiten,
       case when isi_utils.Iso_WeekDay(d_list.datum) = 1
            then
                 vqb.pers_bedarf_mo
            when isi_utils.Iso_WeekDay(d_list.datum) = 2
            then
                 vqb.pers_bedarf_di
            when isi_utils.Iso_WeekDay(d_list.datum) = 3
            then
                 vqb.pers_bedarf_mi
            when isi_utils.Iso_WeekDay(d_list.datum) = 4
            then
                 vqb.pers_bedarf_do
            when isi_utils.Iso_WeekDay(d_list.datum) = 5
            then
                 vqb.pers_bedarf_fr
            when isi_utils.Iso_WeekDay(d_list.datum) = 6
            then
                 vqb.pers_bedarf_sa
            else
                 vqb.pers_bedarf_so
            end pers_bedarf,
            sum(vqp.plan_einsatz_wert) personal_plan,
            stradd_cr(vqp.pers_nr ||
                      '(' || replace(to_char(nvl(vqp.plan_einsatz_wert,0), '0.99'), '.', ',') || ')' ||
                      p.pers_nname || decode(p.pers_vname, NULL, NULL, ',') || p.pers_vname || ' ' ||
                      decode (vqp.plan_von_zeit,
                      NULL, decode (vqb.Zeiten,
                                    ' - ', NULL,
                                    vqb.Zeiten),
                      to_char(vqp.plan_von_zeit, 'hh24:mi') || ' - ' || to_char(vqp.plan_bis_zeit, 'hh24:mi'))
                      )  gepl_personal,
            vqb.pers_nr_vorschl
 from (select to_date('04.08.2025') + level - 1 as datum
         from dual
         connect by level <= 7
     ) d_list,
     pzm_v_vorgangsqual_pers_bedarf_liste vqb,
     pzm_vorgangsqual_einsatz_plan vqp,
     pzm_personal p

where 1=1
  and vqb.abt_l_pers_nr = 10211
  and vqb.vq_id = vqp.plan_vq_id(+)
  and d_list.datum = vqp.plan_datum(+)
  and vqb.schicht_nr = vqp.plan_schicht(+)
  and vqp.pers_nr = p.pers_nr(+)
group by d_list.datum,
       vqb.abt_l_pers_nr,
       vqb.vq_id,
       vqb.vq_abt_id,
       vqb.abt_name,
       d_list.datum,
       vqb.schicht_nr,
       vqb.Zeiten,
       vqb.pers_bedarf_mo,
       vqb.pers_bedarf_di,
       vqb.pers_bedarf_mi,
       vqb.pers_bedarf_do,
       vqb.pers_bedarf_fr,
       vqb.pers_bedarf_sa,
       vqb.pers_bedarf_so,
       vqb.pers_nr_vorschl;


-- sqlcl_snapshot {"hash":"caddb91551a61c5b9572e76cf12646f60bc3062d","type":"VIEW","name":"PZM_V_VORGANGSQUAL_PERS_SUCHE","schemaName":"DIRKSPZM32","sxml":""}