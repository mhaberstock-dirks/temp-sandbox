create or replace package dirkspzm32.lvs_util is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  04.09.2006 13:45:38
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
	             3.4.1.1              Fehler bein Rückholen einer LTE aus den Historie
	             3.3.4.0              Einbau der Versionierung
  */

    v_version_str constant varchar2(20) := '3.5.0.1 / 27.11.2009';
    function get_version return varchar2;

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
    v_bestand_von number;
    v_bestand_bis number;
    v_veraenderung_bis number;
    v_zugang_von_bis number;
    v_abgang_von_bis number;
    v_sonst_von_bis number;
    v_lam_bh lvs_lam_bh%rowtype;
    v_lam lvs_lam%rowtype;

  -- Public function and procedure declarations
    function get_artikel_menge_bis (
        in_artikel_id      in isi_artikel.artikel_id%type,
        in_fa_ag           in lvs_lam.fa_ag%type,
        in_akt_bestand     in lvs_lam.menge%type,
        in_bestand_dat_von in date,
        in_bestand_dat_bis in date,
        in_akt_date        in date
    ) return number;

    function get_veraendrung_bis return number;

    function get_bestand_von return number;

    function get_bestand_bis return number;

    function get_zugang_von_bis return number;

    function get_abgang_von_bis return number;

    function get_sonst_von_bis return number;

    function get_lte_last_buch (
        in_sid      in lvs_lam_bh.sid%type,
        in_firma_nr in lvs_lam_bh.firma_nr%type,
        in_lte_id   in lvs_lam_bh.lte_id%type,
        in_bus      in lvs_lam_bh.bus%type
    ) return lvs_lam_bh.buch_datum%type;

    function get_lte_last_lam_id (
        in_sid      in lvs_lam_bh.sid%type,
        in_firma_nr in lvs_lam_bh.firma_nr%type,
        in_lte_id   in lvs_lam_bh.lte_id%type,
        in_bus      in lvs_lam_bh.bus%type
    ) return lvs_lam.lam_id%type;

    function get_lte_last_charge_id (
        in_sid      in lvs_lam_bh.sid%type,
        in_firma_nr in lvs_lam_bh.firma_nr%type,
        in_lte_id   in lvs_lam_bh.lte_id%type,
        in_bus      in lvs_lam_bh.bus%type
    ) return lvs_lam.charge_id%type;

    function get_lvs_v_lam (
        in_lam_id in lvs_lam.lam_id%type
    ) return lvs_lam%rowtype;

    function get_v_lam_best_nr (
        in_lam_id in lvs_lam.lam_id%type
    ) return lvs_lam.best_nr%type;

    function get_lam_kunde_by_lte_id (
        in_lte_id in lvs_lam.lte_id%type
    ) return lvs_lam.kunden_nr%type;

    function get_lam_kunde_by_lhm_id (
        in_lhm_id in lvs_lam.lhm_id%type
    ) return lvs_lam.kunden_nr%type;

    function get_artikel_last_buch (
        in_artikel_id in isi_artikel.artikel_id%type
    ) return date;

    function c_get_lte_aus_historie (
        in_lte_id in lvs_lte.lte_id%type
    ) return number;

    function get_res_string (
        in_sid            in isi_firma.sid%type,
        in_firma_nr       in isi_firma.firma_nr%type,
        in_waren_typ      in lvs_lte.waren_typ%type,
        in_res_artikel_id in lvs_lte.res_artikel_id%type,
        in_fa_ag          in lvs_lam.fa_ag%type,
        in_charge_id      in lvs_lam.charge_id%type,
        in_serie_id       in lvs_lam.serie_id%type,
        in_leitzahl       in lvs_lam.leitzahl%type,
        in_kunden_nr      in lvs_lam.kunden_nr%type,
        in_lieferant_nr   in lvs_lam.lieferant_nr%type,
        in_bestellung     in lvs_lam.best_nr%type,
        in_lam_mhd        in lvs_lam.lam_mhd%type,
        in_artikel_tage   in isi_artikel.einlager_tage%type,
        in_labor_status   in lvs_lam.labor_status%type,
        in_lte_voll       in lvs_lte.lte_voll%type,
        in_out_res_mhd    in out date
    ) return varchar2;

    function get_res_string_v357 (
        in_sid              in isi_firma.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_waren_typ        in lvs_lte.waren_typ%type,
        in_res_artikel_id   in lvs_lte.res_artikel_id%type,
        in_fa_ag            in lvs_lam.fa_ag%type,
        in_charge_id        in lvs_lam.charge_id%type,
        in_serie_id         in lvs_lam.serie_id%type,
        in_leitzahl         in lvs_lam.leitzahl%type,
        in_kunden_nr        in lvs_lam.kunden_nr%type,
        in_lieferant_nr     in lvs_lam.lieferant_nr%type,
        in_bestellung       in lvs_lam.best_nr%type,
        in_lam_mhd          in lvs_lam.lam_mhd%type,
        in_artikel_tage     in isi_artikel.einlager_tage%type,
        in_labor_status     in lvs_lam.labor_status%type,
        in_lte_voll         in lvs_lte.lte_voll%type,
        in_lam_owner_adr_id in lvs_lam.owner_address_id%type,
        in_out_res_mhd      in out date
    ) return varchar2;

    function get_res_string_v359 (
        in_sid              in isi_firma.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_waren_typ        in lvs_lte.waren_typ%type,
        in_res_artikel_id   in lvs_lte.res_artikel_id%type,
        in_hersteller_list  in lvs_lam.hersteller_kuerzel_liste%type,
        in_fa_ag            in lvs_lam.fa_ag%type,
        in_charge_id        in lvs_lam.charge_id%type,
        in_serie_id         in lvs_lam.serie_id%type,
        in_leitzahl         in lvs_lam.leitzahl%type,
        in_kunden_nr        in lvs_lam.kunden_nr%type,
        in_lieferant_nr     in lvs_lam.lieferant_nr%type,
        in_bestellung       in lvs_lam.best_nr%type,
        in_lam_mhd          in lvs_lam.lam_mhd%type,
        in_artikel_tage     in isi_artikel.einlager_tage%type,
        in_labor_status     in lvs_lam.labor_status%type,
        in_lte_voll         in lvs_lte.lte_voll%type,
        in_lam_owner_adr_id in lvs_lam.owner_address_id%type,
        in_out_res_mhd      in out date
    ) return varchar2;

    procedure c_set_lam_qs_status (
        in_sid       in lvs_lam.sid%type,
        in_firma_nr  in lvs_lam.firma_nr%type,
        in_lhm_id    in lvs_lam.lhm_id%type,
        in_qs_status in lvs_lam.qs_status%type
    );

    procedure c_set_lam_charge_u_prod_datum (
        in_sid        in lvs_lam.sid%type,
        in_firma_nr   in lvs_lam.firma_nr%type,
        in_lam_id     in lvs_lam.lam_id%type,
        in_charge_bez in lvs_charge.charge_bez%type,
        in_prod_datum in lvs_lam.prod_datum%type
    );

end lvs_util;
/


-- sqlcl_snapshot {"hash":"be3d3373e1ba93fb164bda8654e9a98d29c0a138","type":"PACKAGE_SPEC","name":"LVS_UTIL","schemaName":"DIRKSPZM32","sxml":""}