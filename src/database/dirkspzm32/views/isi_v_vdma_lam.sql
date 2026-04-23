create or replace force editionable view dirkspzm32.isi_v_vdma_lam (
    artikel,
    art_bez,
    get_ausw_begin,
    get_ausw_ende,
    lgr_ort,
    lgr_ort_text,
    akt_menge,
    dw_d_menge,
    abg_menge,
    mengeneinheit_basis,
    lagerumschlagshaeufigkeit,
    d_lagerdauer,
    lager_zinssatz,
    lagerreichweite_monate,
    d_lagerreichweite_monate
) as
    select
        d.artikel,
        d.art_bez,
        d.get_ausw_begin,
        d.get_ausw_ende,
        d.lgr_ort,
        d.lgr_ort_text,
        d.akt_menge,
        d.dw_d_menge,
        d.abg_menge,
        d.mengeneinheit_basis,
        d.lagerumschlagshaeufigkeit,
        case
            when nvl(d.lagerumschlagshaeufigkeit, 0) = 0 then
                360
            else
                360 / d.lagerumschlagshaeufigkeit
        end       d_lagerdauer,
        nvl(
            case
                when nvl(d.lagerumschlagshaeufigkeit, 0) = 0 then
                    0
                else
                    360 / d.lagerumschlagshaeufigkeit
            end
        * dw.get_zins_proz / 360,
            0)    lager_zinssatz,
        nvl(
            case
                when nvl(d.abg_menge, 0) = 0 then
                    1200 -- 10 Jahre
                else
                    (d.akt_menge / d.abg_menge) *((dw.get_ausw_ende - dw.get_ausw_begin) / 360) * 12
            end,
            1200) lagerreichweite_monate,
        nvl(
            case
                when nvl(d.abg_menge, 0) = 0 then
                    1200 -- 10 Jahre
                else
                    (d.dw_d_menge / d.abg_menge) *((dw.get_ausw_ende - dw.get_ausw_begin) / 360) * 12
            end,
            1200) d_lagerreichweite_monate
    from
        (
            select -- a.artikel_id,
                a.artikel,
                a.bezeichnung1
                || ' '
                || a.bezeichnung2
                || ' '
                || a.bezeichnung3                         art_bez,
                dw.get_ausw_begin,
                dw.get_ausw_ende,
                lo.lgr_ort,
                lo.lgr_ort_text,
                nvl((
                    select
                        sum(lam.menge)
                    from
                        lvs_lam lam,
                        lvs_lgr lgr
                    where
                            a.artikel_id = lam.artikel_id
                        and lam.lgr_platz = lgr.lgr_platz
                        and lgr.lgr_ort = lo.lgr_ort
                        and lam.fa_ag is null
                ),
                    0)                                    akt_menge,
                sum(dwb.sum_menge) / count(dwb.sum_menge) dw_d_menge,
                (
                    select
                        sum(abg.sum_menge)
                    from
                        dw_lvs_bestand abg
                    where
                            a.artikel_id = abg.artikel_id
                        and abg.fa_ag is null
                        and abg.stat_name like 'DW_LAM_ART_ABG_LAGERORT_TAG_%'
                        and abg.wert_datum >= ( dw.get_ausw_begin )
                        and abg.wert_datum <= ( dw.get_ausw_ende )
                )                                         abg_menge,
                dwb.mengeneinheit_basis,
                round(
                    nvl((
                        select
                            sum(abg.sum_menge) * - 1
                        from
                            dw_lvs_bestand abg
                        where
                                a.artikel_id = abg.artikel_id
                            and abg.fa_ag is null
                            and abg.stat_name like 'DW_LAM_ART_ABG_LAGERORT_TAG_%'
                            and abg.wert_datum >=(dw.get_ausw_begin)
                            and abg.wert_datum <=(dw.get_ausw_ende)
                            and abg.lgr_ort = dwb.lgr_ort
                    ) /(sum(dwb.sum_menge) / count(dwb.sum_menge)) *(360 /(dw.get_ausw_ende - dw.get_ausw_begin)),
                        0),
                    2
                )                                         lagerumschlagshaeufigkeit
            from
                isi_artikel    a,
                lvs_lgr_ort    lo,
                dw_lvs_bestand dwb
            where
                    lo.lgr_ort = dwb.lgr_ort
                and a.artikel_id = dwb.artikel_id
                and dwb.fa_ag is null
                and dwb.stat_name like 'DW_LAM_ART_MENGE_IN_LAGERORT_%'
                and dwb.wert_datum >= ( dw.get_ausw_begin )
                and dwb.wert_datum <= ( dw.get_ausw_ende )
            group by
                a.artikel_id,
                a.artikel,
                a.bezeichnung1,
                a.bezeichnung2,
                a.bezeichnung3,
                lo.lgr_ort,
                lo.lgr_ort_text,
                dwb.lgr_ort,
                dwb.mengeneinheit_basis,
                dwb.artikel_id,
                a.preis_gleitend,
                a.preis_standard
        ) d;


-- sqlcl_snapshot {"hash":"892314898da155d8ecdfe9762aa0cee297bbbf77","type":"VIEW","name":"ISI_V_VDMA_LAM","schemaName":"DIRKSPZM32","sxml":""}