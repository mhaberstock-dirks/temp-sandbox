create or replace procedure dirkspzm32.bde_pd_prod_r_ag_e
/*
In dieser Procedure wird Produktion Auftrag Rüsten Ende gebucht
Diese Procedur ist ein Deckel, der für den Aufruf von bde_pd_prod_r_ag_e_p benötigt wird,
Zusätzlich wird hie in Abhängigkeit der ISI_FIRMA_CFG bde_pd_prod_p_ag_b aufgerufen die
wiederum bde_pd_prod_r_ag_e_p aufruft. Ohne diese Procedure würde eine Ringbezug erzeugt,
der beim Compilieren nicht aufgelöst werden könnte.

-- Die procedure fuehrt ein Commit durch
-- HISTORY
-- 11.02.2015 -AG- Kommentare in JavaDoc-Style geändert
-- 10.03.2020 -DTs- Alle MA von der Maschine abmelden außer den Schichtführer. (E20BDE-17)

@author -AG- Hans Joachim Gödeke
@raises v_error Fehler werden hier nicht erzeugt

@param in_sid             in isi_sid.sid
@param in_firma_nr        in isi_firma.firma_nr
@param in_leitzahl        in bde_fa_auftrag.leitzahl           Fertigungsauftrag
@param in_fa_ag           in bde_fa_auftrag.fa_ag              Arbeitsgang
@param in_fa_upos         in bde_fa_auftrag.fa_upos            Unterposition bzw. Split
@param in_res_id          in isi_resource.res_id               RES_ID der Maschine auf der Gebucht werden soll
@param in_sysdate         in date                              Buchungsdatum
@param in_menge_a         in bde_pd_prod.Menge_a               Menge A-Qualität Wenn alle Mengen NULL oder 0, dann werden diese aus den Bucungen in der BDE_PD_PROD ermittelt
@param in_menge_b         in bde_pd_prod.Menge_b               Menge B-Qualität - 2te Wahl
@param in_schrott         in bde_pd_prod.schrott               Schrottmenge
@param in_ls_login_id     in isi_user.login_id                 Login_ID des angemeldeten USER

*/ (
    in_sid         in isi_sid.sid%type,
    in_firma_nr    in isi_firma.firma_nr%type,
    in_leitzahl    in bde_fa_auftrag.leitzahl%type,
    in_fa_ag       in bde_fa_auftrag.fa_ag%type,
    in_fa_upos     in bde_fa_auftrag.fa_upos%type,
    in_res_id      in isi_resource.res_id%type,
    in_sysdate     date,
    in_menge_a     in bde_pd_prod.menge_a%type,
    in_menge_b     in bde_pd_prod.menge_b%type,
    in_schrott     in bde_pd_prod.schrott%type,
    in_ls_login_id in isi_user.login_id%type
) is

 --------------------------------------------------------------------------------------------------------------------
 -- Variablendeklaration
 --------------------------------------------------------------------------------------------------------------------

 --------------------------------------------------------------------------------------------------------------------

begin
    bde_pd_prod_r_ag_e_p(in_sid,                -- in_sid        in  bde_fa_auftrag.sid%type,
                         in_firma_nr,           -- in_firma_nr   in  bde_fa_auftrag.firma_nr%type,
                         in_leitzahl,           -- in_fa_nr      in  bde_fa_auftrag.leitzahl%type,
                         in_fa_ag,              -- in_fa_ag      in  bde_fa_auftrag.fa_ag%type,
                         nvl(in_fa_upos, 0),
                         in_res_id,
                         sysdate,
                         in_menge_a,
                         in_menge_b,
                         in_schrott,
                         in_ls_login_id);

    if
        isi_allg.c_get_firma_cfg_param(in_sid, in_firma_nr, 'CFG',                   -- in_kategorie             in isi_firma_cfg.kategorie%type,
         null,                    -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
         'RUEST_MG_IN_PROD_MG',   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                       'BDE',                   -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                        'CFG',                   -- in_typ                   in isi_firma_cfg.typ%type,
                                        'F',                     -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                        'BOOLEAN') = c.c_true    -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type,
        and in_menge_a > 0
    then
        bde_pd_prod_p_ag_b(in_sid,                -- in_sid        in  bde_fa_auftrag.sid%type,
                           in_firma_nr,           -- in_firma_nr   in  bde_fa_auftrag.firma_nr%type,
                           in_leitzahl,           -- in_fa_nr      in  bde_fa_auftrag.leitzahl%type,
                           in_fa_ag,              -- in_fa_ag      in  bde_fa_auftrag.fa_ag%type,
                           nvl(in_fa_upos, 0),
                           in_res_id,
                           null,
                           in_ls_login_id);

        bde_pd_prod_p_ag_e(in_sid,                -- in_sid        in  bde_fa_auftrag.sid%type,
                           in_firma_nr,           -- in_firma_nr   in  bde_fa_auftrag.firma_nr%type,
                           in_leitzahl,           -- in_fa_nr      in  bde_fa_auftrag.leitzahl%type,
                           in_fa_ag,              -- in_fa_ag      in  bde_fa_auftrag.fa_ag%type,
                           nvl(in_fa_upos, 0),
                           in_res_id,
                           sysdate,
                           in_menge_a,
                           in_menge_b,
                           in_schrott,
                           in_ls_login_id);

    end if;

  ---------------------------------------------------------------------------------------------------------------------
  -- DTs20200309, E20BDE-17
  -- Abmelden Rüsten
  -- Der Parameter Wert wird aus "isi_firma_cfg" ermittelt,
  -- bzw. eingetragen wenn diese nicht vorhanden ist
    if isi_allg.c_get_firma_cfg_param(in_sid,                                  -- in_sid
     in_firma_nr,                             -- in_firma_nr
     'BDE',                                   -- in_kategorie
     null,                                    -- in_kategorie_ix
     'BDE_ABMELD_PERS_RES_FA_ABMELDEN_RUEST', -- in_parameter_name (Abmelden Rüsten)
                                      'BDE',                                   -- in_modul_name
                                       'CFG',                                   -- in_typ
                                       'F',                                     -- in_default_param_wert
                                       'BOOLEAN'                                -- in_default_param_typ
                                      ) = c.c_true then
    -- Alle MA von der Maschine abmelden
    -- außer den Schichtverantwortlichen
    -- der noch an der Maschine angemeldet ist
        update bde_pd_kopf_ma t
        set
            t.pd_kopf_ende = sysdate
        where
                t.sid = in_sid
            and t.firma_nr = in_firma_nr
            and t.res_id = in_res_id
            and t.pd_kopf_ende is null
            and t.pers_nr not in (
                select
                    k.pers_nr
                from
                    bde_pd_kopf k
                where
                        k.res_id = in_res_id
                    and k.pd_kopf_ende is null
            );

    end if;
  ---------------------------------------------------------------------------------------------------------------------

    commit;
end bde_pd_prod_r_ag_e;
/


-- sqlcl_snapshot {"hash":"0ddd98863692337e2fea25e2a014daec977c6e76","type":"PROCEDURE","name":"BDE_PD_PROD_R_AG_E","schemaName":"DIRKSPZM32","sxml":""}