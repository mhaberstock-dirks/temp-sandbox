
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."ISI_V_VDMA_LAM" ("ARTIKEL", "ART_BEZ", "GET_AUSW_BEGIN", "GET_AUSW_ENDE", "LGR_ORT", "LGR_ORT_TEXT", "AKT_MENGE", "DW_D_MENGE", "ABG_MENGE", "MENGENEINHEIT_BASIS", "LAGERUMSCHLAGSHAEUFIGKEIT", "D_LAGERDAUER", "LAGER_ZINSSATZ", "LAGERREICHWEITE_MONATE", "D_LAGERREICHWEITE_MONATE") AS 
  select d."ARTIKEL",
       d."ART_BEZ",
       d."GET_AUSW_BEGIN",
       d."GET_AUSW_ENDE",
       d."LGR_ORT",
       d."LGR_ORT_TEXT",
       d."AKT_MENGE",
       d."DW_D_MENGE",
       d."ABG_MENGE",
       d."MENGENEINHEIT_BASIS",
       d."LAGERUMSCHLAGSHAEUFIGKEIT",
       case when nvl(d.lagerumschlagshaeufigkeit, 0) = 0
         then 360
         else 360 / d.lagerumschlagshaeufigkeit
         end d_lagerdauer,
       nvl(case  when nvl(d.lagerumschlagshaeufigkeit, 0) = 0
                 then 0
                 else 360 / d.lagerumschlagshaeufigkeit
                 end * dw.get_zins_proz / 360, 0) lager_zinssatz,
       nvl(case  when nvl(d.abg_menge, 0) = 0
                 then 1200 -- 10 Jahre
                 else (d.akt_menge / d.abg_menge) * ((dw.get_ausw_ende - dw.get_ausw_begin) / 360) * 12
                 end, 1200) Lagerreichweite_Monate,
       nvl(case  when nvl(d.abg_menge, 0) = 0
                 then 1200 -- 10 Jahre
                 else (d.dw_d_menge / d.abg_menge) * ((dw.get_ausw_ende - dw.get_ausw_begin) / 360) * 12
                 end, 1200) d_Lagerreichweite_Monate
 from (select -- a.artikel_id,
             a.artikel,
             a.bezeichnung1 || ' ' || a.bezeichnung2 || ' ' || a.bezeichnung3 art_bez,
             dw.get_ausw_begin,
             dw.get_ausw_ende,
             lo.lgr_ort,
             lo.lgr_ort_text,
             nvl((select sum(lam.menge)
                    from lvs_lam lam,
                         lvs_lgr lgr
                   where a.artikel_id = lam.artikel_id
                     and lam.lgr_platz = lgr.lgr_platz
                     and lgr.lgr_ort = lo.lgr_ort
                     and lam.fa_ag is NULL), 0) akt_menge,
             sum(dwb.sum_menge) / count(dwb.sum_menge) dw_d_menge,
             (select sum(abg.sum_menge)
                from dw_lvs_bestand abg
               where a.artikel_id = abg.artikel_id
                 and abg.fa_ag is NULL
                 and abg.stat_name like 'DW_LAM_ART_ABG_LAGERORT_TAG_%'
                 and abg.wert_datum >= (dw.get_ausw_begin)
                 and abg.wert_datum <= (dw.get_ausw_ende)
             )  abg_menge,
             dwb.mengeneinheit_basis,
             round(nvl((select sum(abg.sum_menge) * -1
                          from dw_lvs_bestand abg
                         where a.artikel_id = abg.artikel_id
                           and abg.fa_ag is NULL
                           and abg.stat_name like 'DW_LAM_ART_ABG_LAGERORT_TAG_%'
                           and abg.wert_datum >= (dw.get_ausw_begin)
                           and abg.wert_datum <= (dw.get_ausw_ende)
                           and abg.lgr_ort = dwb.lgr_ort
                       ) / (sum(dwb.sum_menge) / count(dwb.sum_menge)) * (360 / (dw.get_ausw_ende - dw.get_ausw_begin)), 0), 2) lagerumschlagshaeufigkeit
        from isi_artikel a,
             lvs_lgr_ort lo,
             dw_lvs_bestand dwb
       where lo.lgr_ort = dwb.lgr_ort
         and a.artikel_id = dwb.artikel_id
         and dwb.fa_ag is NULL
         and dwb.stat_name like 'DW_LAM_ART_MENGE_IN_LAGERORT_%'
         and dwb.wert_datum >= (dw.get_ausw_begin)
         and dwb.wert_datum <= (dw.get_ausw_ende)
       group by a.artikel_id,
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
                a.preis_standard) d
;


-- sqlcl_snapshot {"hash":"2e740e7bdb4012b09506995ac4c346a9103eca6d","type":"VIEW","name":"ISI_V_VDMA_LAM","schemaName":"DIRKSPZM32","sxml":""}