create or replace package dirkspzm32.dw_bde_funktionen is

  -- Author  : HJGOEDEKE
  -- Created : 14.12.2007 16:17:55
  -- Purpose : Zur schnellen Auswertung von DW-Daten

  -- Public variable declarations

    v_ausw_funk varchar2(50);
    v_ausw_begin date;
    v_ausw_ende date;
    v_ausw_res_id isi_resource.res_id%type;
    v_ausw_leitzahl bde_fa_auftrag.leitzahl%type;
    v_ausw_fa_ag bde_fa_auftrag.fa_ag%type;
    v_auftr_wechsel number;
    v_anmeld_std number;
    v_prod_std number;
    v_ruest_std number;
    v_unterb_std number;
    v_f_prod_std number;
    v_f_ruest_std number;
    v_f_unterb_std number;
    v_s_prod_std number;
    v_s_ruest_std number;
    v_s_unterb_std number;
    v_n_prod_std number;
    v_n_ruest_std number;
    v_n_unterb_std number;
    v_bde_gut_mg number;
    v_bde_b_mg number;
    v_bde_schrott_mg number;
    v_bde_f_gut_mg number;
    v_bde_f_b_mg number;
    v_bde_f_schrott_mg number;
    v_bde_s_gut_mg number;
    v_bde_s_b_mg number;
    v_bde_s_schrott_mg number;
    v_bde_n_gut_mg number;
    v_bde_n_b_mg number;
    v_bde_n_schrott_mg number;
    v_gut_mg number;
    v_b_mg number;
    v_schrott_mg number;
    v_micro_stops number;
    v_f_gut_mg number;
    v_f_b_mg number;
    v_f_schrott_mg number;
    v_f_micro_stops number;
    v_s_gut_mg number;
    v_s_b_mg number;
    v_s_schrott_mg number;
    v_s_micro_stops number;
    v_n_gut_mg number;
    v_n_b_mg number;
    v_n_schrott_mg number;
    v_n_micro_stops number;
    v_prod_tage number;
    v_prod_schichten number;

  -- Public function and procedure declarations
    procedure dw_bde_kenz_tagesab (
        in_sid        in isi_sid.sid%type,
        in_firma_nr   in isi_firma.firma_nr%type,
        in_start      in date,
        in_ende       in date,
        in_raster_std in number
    );

    procedure dw_bde_tagesabschluss (
        in_datum in date
    );

    procedure dw_bde_tagesabschluss_von_bis (
        in_datum_von in date,
        in_datum_bis in date
    );

    procedure get_dw_bde_daten (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_begin    in bde_pd_kopf.pd_kopf_beginn%type,
        in_ende     in bde_pd_kopf.pd_kopf_ende%type,
        in_res_id   in isi_resource.res_id%type
    );

  -- BDE ----------------------------------------------------------------------------
    function get_bde_gut_mengen (
        in_sid       in isi_resource.sid%type,
        in_firma_nr  in isi_resource.firma_nr%type,
        in_res_id    in isi_resource.res_id%type,
        in_von_datum in date,
        in_bis_datum in date
    ) return number;

    function get_bde_b_mengen return number;

    function get_bde_schrott_mengen return number;

    function get_bde_f_gut_mengen return number;

    function get_bde_f_b_mengen return number;

    function get_bde_f_schrott_mengen return number;

    function get_bde_s_gut_mengen return number;

    function get_bde_s_b_mengen return number;

    function get_bde_s_schrott_mengen return number;

    function get_bde_n_gut_mengen return number;

    function get_bde_n_b_mengen return number;

    function get_bde_n_schrott_mengen return number;

    function get_res_prod_std (
        in_sid       in isi_resource.sid%type,
        in_firma_nr  in isi_resource.firma_nr%type,
        in_res_id    in isi_resource.res_id%type,
        in_von_datum in date,
        in_bis_datum in date
    ) return number;

    function get_res_ruest_std return number;

    function get_res_unterbr_std return number;

    function get_res_f_prod_std return number;

    function get_res_f_ruest_std return number;

    function get_res_f_unterbr_std return number;

    function get_res_s_prod_std return number;

    function get_res_s_ruest_std return number;

    function get_res_s_unterbr_std return number;

    function get_res_n_prod_std return number;

    function get_res_n_ruest_std return number;

    function get_res_n_unterbr_std return number;

    function get_res_auf_wechsel return number;

    function get_anmelde_std (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_begin    in bde_pd_kopf.pd_kopf_beginn%type,
        in_ende     in bde_pd_kopf.pd_kopf_ende%type,
        in_res_id   in isi_resource.res_id%type
    ) return number;

    function get_res_auf_wechsel (
        in_sid      in isi_sid.sid%type,
        in_firma_nr in isi_firma.firma_nr%type,
        in_begin    in bde_pd_kopf.pd_kopf_beginn%type,
        in_ende     in bde_pd_kopf.pd_kopf_ende%type,
        in_res_id   in isi_resource.res_id%type
    ) return number;

end dw_bde_funktionen;
/


-- sqlcl_snapshot {"hash":"67c3139d1d5ec880e723b333f0e06b25a2b246fd","type":"PACKAGE_SPEC","name":"DW_BDE_FUNKTIONEN","schemaName":"DIRKSPZM32","sxml":""}