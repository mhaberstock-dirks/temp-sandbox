
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DIRKSPZM32"."LVS_V_LGR_DISPO_FEHLER" ("ID", "FEHLER", "RES_STRING", "TRANSP_ID", "LGR_PLATZ", "LGR_PLATZ_GRUPPE", "LGR_MAX_TE", "LGR_AKT_TE", "LGR_AKT_KG", "LGR_DISPO_EINL_TE", "LGR_DISPO_EINL_KG", "LGR_EINL_TE_VERFUEG", "LGR_EINL_TE_VERFUEG_GRUPPE", "LGR_DISPO_AUSL_TE", "LGR_DISPO_AUSL_KG") AS 
  (select 1 ID, '[1] Storage Dispo In is wrong' Fehler, lgr.res_string, 0 transp_id,
                lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te, lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from lvs_lgr lgr
  where lgr.lgr_dispo_einl_te <> ( select count(tr.transp_id)
                                     from isi_transport tr
                                    where tr.lgr_platz_ziel = lgr.lgr_platz )
    and lgr_verwendung in ('Lager', 'Puffer'))
union
(select 3 ID, '[3] Storage Dispo Out is wrong' Fehler, lgr.res_string,  0 transp_id,
        lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te, lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from lvs_lgr lgr
  where lgr_verwendung in ('Lager', 'Puffer')
    and lgr.lgr_dispo_ausl_te <> (select count (tr.transp_id)
                                          from isi_transport tr
                                         where tr.lgr_platz_Quelle = lgr.lgr_platz
                                           and tr.status in ('F', 'B'))
    )
union
(select 4 ID, '[4] Storage Actual Amount > Max Amount' Fehler, lgr.res_string,  0 transp_id,
        lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te, lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from lvs_lgr lgr
  where lgr.lgr_akt_te > lgr.lgr_max_te
    and lgr_verwendung in ('Lager', 'Puffer'))
union
(select 5 ID, '[5] Storage Actual Amount is wrong' Fehler, lgr.res_string,  0 transp_id,
        lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te, lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from lvs_lgr lgr
  where lgr.lgr_akt_te <> (select Count(*) from lvs_lte lte where lte.lgr_platz = lgr.lgr_platz)
    and lgr_verwendung in ('Lager', 'Puffer'))
union
(select 6 ID, '[6] Storage Actual Amount of free is wrong' Fehler, lgr.res_string,  0 transp_id,
        lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te, lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from lvs_lgr lgr
  where (lgr.lgr_einl_te_verfueg_gruppe <> (Select sum(lgr_g.verfueg) verfueg_g
                                              from (select lgr_x.lgr_max_te - lgr_x.lgr_akt_te - lgr_x.lgr_dispo_einl_te verfueg
                                                      from lvs_lgr lgr_x
                                                     where lgr_x.lgr_platz_gruppe = lgr.lgr_platz_gruppe
                                                       and   ((lgr_x.lgr_dim_g = lgr.lgr_dim_g
                                                          and lgr_x.lgr_dim_r = lgr.lgr_dim_r
                                                          and lgr_x.lgr_dim_p = lgr.lgr_dim_p
                                                          and lgr_x.lgr_dim_e = lgr.lgr_dim_e)
                                                        or  ( lgr_x.lgr_typ != c.R_SEG1
                                                          and lgr_x.lgr_typ != c.R_SEG_DUEDO1))
                                                    ) lgr_g
                                            )
      or
         lgr.lgr_einl_te_verfueg <> (Select lgr_x.lgr_max_te - lgr_x.lgr_akt_te - lgr_x.lgr_dispo_einl_te
                                       from lvs_lgr lgr_x
                                      where lgr_x.lgr_platz = lgr.lgr_platz)
       )
    and lgr_verwendung in ('Lager', 'Puffer'))
union
(select 7 ID, '[7] Storage reservation string is wrong' Fehler , lgr.res_string,  0 transp_id,
        lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te, lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from lvs_lgr lgr
  where lgr.res_string is not null
    and lgr_verwendung in ('Lager', 'Puffer')
    and (select (sum(lgr_x.lgr_akt_te) + sum(lgr_x.lgr_dispo_einl_te)) dispos
           from lvs_lgr lgr_x
          where lgr_x.lgr_platz_gruppe = lgr.lgr_platz_gruppe) = 0)
union
(select 8 ID, '[8] Transport Error, Transport Unit is removed in System' Fehler, lgr.res_string,  tr.transp_id transp_id,
        lgr.lgr_platz, lgr.lgr_platz_gruppe,lgr.lgr_max_te, lgr.lgr_akt_te, lgr.lgr_akt_kg, lgr.lgr_dispo_einl_te,
        lgr.lgr_dispo_einl_kg, lgr.lgr_einl_te_verfueg,  lgr.lgr_einl_te_verfueg_gruppe,  lgr.lgr_dispo_ausl_te, lgr.lgr_dispo_ausl_kg
   from isi_transport tr,
        lvs_lgr lgr
  where 1=1
    and tr.lgr_platz_ziel = lgr.lgr_platz(+)
    and (   not exists (select y.lte_id from lvs_lam y where y.lte_id = tr.lte_id)
         or not exists (select z.lte_id from lvs_lte z where z.lte_id = tr.lte_id)))
;


-- sqlcl_snapshot {"hash":"688bf0381e579ebcf5547aa8a1bdaa6558bb4749","type":"VIEW","name":"LVS_V_LGR_DISPO_FEHLER","schemaName":"DIRKSPZM32","sxml":""}