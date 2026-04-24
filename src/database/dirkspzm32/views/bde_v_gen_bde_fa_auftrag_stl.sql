create or replace force editionable view dirkspzm32.bde_v_gen_bde_fa_auftrag_stl (
    sid,
    firma_nr,
    fa_ag_stl_id,
    leitzahl,
    fa_ag,
    fa_upos,
    ma_fa_ag,
    ma_upos,
    stueckliste_pos_id,
    stueckliste_pos_nr,
    prod_reihenfolge,
    prod_menge_p_einheit,
    prod_menge_p_einheit_op,
    prod_menge_ix,
    ma_res_id
) as
    select
        fa.sid,
        fa.firma_nr,
        fa.leitzahl * 1000000 + fam.fa_ag * 1000 + fam.fa_upos fa_ag_stl_id,         -- STL_ID ist immer die Artikel-ID
        fa.leitzahl /*kopfid*/,               -- eindeutige ID des Arbeitsplans
        fa.fa_ag, -- ID des Vorgangs innerhalb des Arbeitsplans
        fa.fa_upos                                             fa_upos, -- Eindeutige ID des Ausgangsvorgangssplits
        fam.fa_ag                                              ma_fa_ag,                 -- ID des Vorgangs innerhalb des Arbeitsplans
        fam.fa_upos                                            ma_upos,               -- Eindeutige ID des Ausgangsvorgangssplits
        fam.fa_ag + fam.fa_upos                                stueckliste_pos_id,
        fam.fa_ag + fam.fa_upos                                stueckliste_pos_nr,
        fam.fa_ag                                              prod_reihenfolge,
        fam.ag_soll_mg /
        case
            when fa.ag_soll_mg = 0 then
                        case
                            when fam.ag_soll_mg = 0 then
                                1
                            else
                                fam.ag_soll_mg
                        end
            else
                1
        end
        prod_menge_p_einheit,
        'MUL'                                                  prod_menge_p_einheit_op,
        1                                                      prod_menge_ix,
        null                                                   ma_res_id
    from
        bde_fa_auftrag fav,
        bde_fa_auftrag fa,
        bde_fa_auftrag fam
    where
        not exists (
            select
                x.leitzahl
            from
                bde_fa_auftrag x
            where
                    x.leitzahl = fa.leitzahl
                and x.kenz_letzt_ag = 1
                and x.freig_status = 'F'
        )
            and fav.leitzahl = fa.leitzahl
            and fav.fa_ag < fa.fa_ag
            and fav.fa_ag = (
            select
                max(x.fa_ag)
            from
                bde_fa_auftrag x
            where
                    x.leitzahl = fa.leitzahl
                and x.satzart = 'V'
                and fa.fa_ag < x.fa_ag
        )
            and fav.satzart = 'V'
            and fa.satzart = 'V'
            and fa.leitzahl = fam.leitzahl
            and fav.fa_ag < fam.fa_ag
            and fa.fa_ag > fam.fa_ag
            and fam.satzart = 'MA'
            and isi_allg.c_get_firma_cfg_param(fa.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
             fa.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
             'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'BDE_APS_GEN_FA_REL',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'BDE',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                c.r_c_true,             -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                'BOOLEAN') = c.r_c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
    union
    select
        fa.sid,
        fa.firma_nr,
        fa.leitzahl * 1000000 + fam.fa_ag * 1000 + fam.fa_upos fa_ag_stl_id,         -- STL_ID ist immer die Artikel-ID
        fa.leitzahl /*kopfid*/,               -- eindeutige ID des Arbeitsplans
        fa.fa_ag, -- ID des Vorgangs innerhalb des Arbeitsplans
        fa.fa_upos                                             fa_upos, -- Eindeutige ID des Ausgangsvorgangssplits
        fam.fa_ag                                              ma_fa_ag,                 -- ID des Vorgangs innerhalb des Arbeitsplans
        fam.fa_upos                                            ma_upos,               -- Eindeutige ID des Ausgangsvorgangssplits
        fam.fa_ag + fam.fa_upos                                stueckliste_pos_id,
        fam.fa_ag + fam.fa_upos                                stueckliste_pos_nr,
        fam.fa_ag                                              prod_reihenfolge,
        fam.ag_soll_mg /
        case
            when fa.ag_soll_mg = 0 then
                        case
                            when fam.ag_soll_mg = 0 then
                                1
                            else
                                fam.ag_soll_mg
                        end
            else
                1
        end
        prod_menge_p_einheit,
        'MUL'                                                  prod_menge_p_einheit_op,
        1                                                      prod_menge_ix,
        null                                                   ma_res_id
    from
        bde_fa_auftrag fa,
        bde_fa_auftrag fam
    where
        not exists (
            select
                x.leitzahl
            from
                bde_fa_auftrag x
            where
                    x.leitzahl = fa.leitzahl
                and x.kenz_letzt_ag = 1
                and x.freig_status = 'F'
        )
            and not exists (
            select
                x.leitzahl
            from
                bde_fa_auftrag x
            where
                    x.leitzahl = fa.leitzahl
                and x.fa_ag < fa.fa_ag
                and x.satzart = 'V'
        )
            and fa.satzart = 'V'
            and fa.leitzahl = fam.leitzahl
            and fa.fa_ag > fam.fa_ag
            and fam.satzart = 'MA'
            and isi_allg.c_get_firma_cfg_param(fa.sid,                    -- in_sid                   in isi_firma_cfg.sid%type,
             fa.firma_nr,               -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
             'CFG',                 -- in_kategorie             in isi_firma_cfg.kategorie%type,
             null,                  -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
             'BDE_APS_GEN_FA_REL',  -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                               'BDE',                 -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                'CFG',                 -- in_typ                   in isi_firma_cfg.typ%type,
                                                c.r_c_true,             -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                'BOOLEAN') = c.r_c_true  -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
                                               ;


-- sqlcl_snapshot {"hash":"7e8a50e66d89d96d2c5fd05ba15ab7b4e3d86256","type":"VIEW","name":"BDE_V_GEN_BDE_FA_AUFTRAG_STL","schemaName":"DIRKSPZM32","sxml":""}