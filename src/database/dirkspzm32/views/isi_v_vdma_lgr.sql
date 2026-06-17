
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."ISI_V_VDMA_LGR" ("LGR_ORT", "LGR_ORT_TEXT", "LGR_TYP", "AKT_TE", "MAX_TE", "LAGERNUTZGRAD") AS 
  select lgr.lgr_ort,
         lo.lgr_ort_text,
         lgr.lgr_typ,
         case when lgr.lgr_typ = '_BKL1' --or lgr.lgr_typ = 'KANBKL1'
              then
                sum (case when lgr.lgr_akt_te > 0
                          then 1
                          else 0
                          end)
            else
              sum (lgr.lgr_akt_te)
            end akt_te,
         case when lgr.lgr_typ = '_BKL1' --or lgr.lgr_typ = 'KANBKL1'
           then
             sum(1)
           else
             sum (lgr.lgr_max_te)
           end max_te,
         case when lgr.lgr_typ = '_BKL1' --or lgr.lgr_typ = 'KANBKL1'
           then
             round(sum (case when lgr.lgr_akt_te > 0
                        then 1
                        else 0
                        end) / sum (1) * 100, 2)
           else
             round(sum (lgr.lgr_akt_te) / sum (lgr.lgr_max_te) * 100, 2)
           end lagernutzgrad
    from lvs_lgr lgr,
         lvs_lgr_ort lo
   where lgr.lgr_verwendung = 'Lager'
     and lgr.lgr_ort = lo.lgr_ort
   group by lgr.lgr_ort,
         lo.lgr_ort_text,
         lgr.lgr_typ
;


-- sqlcl_snapshot {"hash":"23e4191e2c294eccc7cd9acab81a51b3da796c8e","type":"VIEW","name":"ISI_V_VDMA_LGR","schemaName":"DIRKSPZM32","sxml":""}