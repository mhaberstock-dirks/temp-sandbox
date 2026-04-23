create or replace force editionable view dirkspzm32.pzm_v_vorgangsqual_pers_suche (
    datum,
    abt_l_pers_nr,
    vorgangsqualifikation,
    vorgangsqualifikation_abt_id,
    abt_name,
    wochentag,
    schicht_nr,
    zeiten,
    pers_bedarf,
    personal_plan,
    gepl_personal,
    pers_nr_vorschl
) as
    select
        d_list.datum,
        vqb.abt_l_pers_nr,
        vqb.vorgangsqualifikation,
        vqb.vorgangsqualifikation_abt_id,
        vqb.abt_name,
        isi_utils.iso_weekday(d_list.datum)        wochentag,
        vqb.schicht_nr,
        vqb.zeiten,
        case
            when isi_utils.iso_weekday(d_list.datum) = 1 then
                vqb.pers_bedarf_mo
            when isi_utils.iso_weekday(d_list.datum) = 2 then
                vqb.pers_bedarf_di
            when isi_utils.iso_weekday(d_list.datum) = 3 then
                vqb.pers_bedarf_mi
            when isi_utils.iso_weekday(d_list.datum) = 4 then
                vqb.pers_bedarf_do
            when isi_utils.iso_weekday(d_list.datum) = 5 then
                vqb.pers_bedarf_fr
            when isi_utils.iso_weekday(d_list.datum) = 6 then
                vqb.pers_bedarf_sa
            else
                vqb.pers_bedarf_so
        end                                        pers_bedarf,
        sum(vqp.plan_einsatz_wert)                 personal_plan,
        stradd_cr(vqp.pers_nr
                  || '('
                  || replace(
            to_char(
                nvl(vqp.plan_einsatz_wert, 0),
                '0.99'
            ),
            '.',
            ','
        )
                  || ')'
                  || p.pers_nname
                  || decode(p.pers_vname, null, null, ',')
                  || p.pers_vname
                  || ' ' || decode(vqp.plan_von_zeit,
                                   null,
                                   decode(vqb.zeiten, ' - ', null, vqb.zeiten),
                                   to_char(vqp.plan_von_zeit, 'hh24:mi')
                                   || ' - '
                                   || to_char(vqp.plan_bis_zeit, 'hh24:mi'))) gepl_personal,
        vqb.pers_nr_vorschl
    from
        (
            select
                to_date('04.08.2025') + level - 1 as datum
            from
                dual
            connect by
                level <= 7
        )                                    d_list,
        pzm_v_vorgangsqual_pers_bedarf_liste vqb,
        pzm_vorgangsqual_einsatz_plan        vqp,
        pzm_personal                         p
    where
            1 = 1
        and vqb.abt_l_pers_nr = 10211
        and vqb.vorgangsqualifikation = vqp.plan_vorgangsqualifikation (+)
        and d_list.datum = vqp.plan_datum (+)
        and vqb.schicht_nr = vqp.plan_schicht (+)
        and vqp.pers_nr = p.pers_nr (+)
    group by
        d_list.datum,
        vqb.abt_l_pers_nr,
        vqb.vorgangsqualifikation,
        vqb.vorgangsqualifikation_abt_id,
        vqb.abt_name,
        d_list.datum,
        vqb.schicht_nr,
        vqb.zeiten,
        vqb.pers_bedarf_mo,
        vqb.pers_bedarf_di,
        vqb.pers_bedarf_mi,
        vqb.pers_bedarf_do,
        vqb.pers_bedarf_fr,
        vqb.pers_bedarf_sa,
        vqb.pers_bedarf_so,
        vqb.pers_nr_vorschl;


-- sqlcl_snapshot {"hash":"ed000eed5e40e08a662d2f69ff60d0066e52f492","type":"VIEW","name":"PZM_V_VORGANGSQUAL_PERS_SUCHE","schemaName":"DIRKSPZM32","sxml":""}