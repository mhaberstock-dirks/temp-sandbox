create or replace package dirkspzm32.pzm_lohnauswertung is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  18.12.2003 10:48:38
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  27.11.2009   3.5.0.1     (-BW-)   Minor Release
  */

  /**************************************************************************************************
  * alle_ueb_std_pruefen
  * wie ueb_std_auszahlung_pruefen! Nur für ALLE Personalnummern bzw. fuer einen Personalnummern-Bereich.
  **************************************************************************************************/

    v_pzm_sim_on boolean := false;

  --------------------------------------------------------------------------
  -- Die Funktion prüt, ob die LOA für diesen Mitarbeiter gültigt ist (Tarif, Sichtart und Kostenstelle)
  -------------------------------------------------------------------------- 
    function get_pers_loa_is_gueltig (
        in_pers_nr     in pzm_personal.pers_nr%type,
        in_lz_id       in pzm_lohnarten.lz_id%type,
        in_sa_kurzname in pzm_schichtarten.sa_kurzname%type
    ) return number;

    function get_alternativ_loa (
        in_loa_id in pzm_lohnarten.lz_id%type
    ) return pzm_lohnarten.lz_lohnart%type;

    function ueb_std_auszahlung_pruefen_r32 (
        in_pers_nr    in number,
        in_monatsende in date,
        in_loa        in pzm_lohnarten.lz_lohnart%type
    ) return boolean;

    procedure ueb_std_auszahlen (
        in_pers_nr in number,
        in_monat   in integer,
        in_jahr    in integer,
        in_stunden in number
    );

    procedure c_ueb_std_auszahlen (
        in_pers_nr in number,
        in_monat   in integer,
        in_jahr    in integer,
        in_stunden in number
    );

    procedure c_ueb_std_auszahlen_storno (
        in_pers_nr in number,
        in_monat   in integer,
        in_jahr    in integer
    );

    procedure ueb_std_auszahlen_storno (
        in_pers_nr in number,
        in_monat   in integer,
        in_jahr    in integer
    );

    procedure set_lz_id_loa_std (
        in_pers_nr      in number,
        in_datum        in date,
        in_lz_id        in pzm_lohnarten.lz_id%type,
        in_loa_std      in number,
        in_aa_id        in number,
        in_std_ersetzen in boolean,
        in_kst_id       in pzm_ze_loa_ausw.zeaw_kst_id%type
    );

    procedure set_loa_std (
        in_pers_nr      in number,
        in_datum        in date,
        in_lohnart      in pzm_ze_loa_ausw.zeaw_lz_lohnart%type,
        in_loa_std      in number,
        in_aa_id        in number,
        in_std_ersetzen in boolean,
        in_loa_id       in pzm_ze_loa_ausw.zeaw_lz_id%type,
        in_kst_id       in pzm_ze_loa_ausw.zeaw_kst_id%type,
        in_passiv_loa   in pzm_ze_loa_ausw.passiv_loa%type default 'F'
    );

    procedure c_berechne_schichtzulagen (
        in_pers_nr     in number,
        in_schicht_tag in date,
        in_von         in date,
        in_bis         in date,
        in_sa_kurzname in varchar2,
        in_kst         in number
    );

    procedure c_reset_monatsende (
        p_pers_nr  in number,
        p_datum    in date,
        p_res_info out varchar2
    );

    procedure c_save_13_w_schnitt (
        in_pers_nr    in pzm_personal.pers_nr%type,
        in_monat_jahr in date
    );

    function c_loa_an_host (
        in_pers_nr in pzm_personal.pers_nr%type,
        in_monat   in number,
        in_jahr    in number,
        in_reset   in varchar2 default 'F' -- Immer neu ausrechnen
    ) return varchar2;

    function c_loa_an_host_r32 (
        in_pers_nr       pzm_personal.pers_nr%type,
        in_monat         in number,
        in_jahr          in number,
        in_ende_datum    in date,
        in_schnittstelle in pzm_produktionsbereiche.pb_schnittstelle%type,
        in_reset         in varchar2 default 'F'
    ) return varchar2;

    procedure c_pdl_equal_pay (
        in_pers_nr pzm_personal.pers_nr%type,
        in_datum   in date
    );

    function c_azk_urlaub_monat_abschluss (
        in_pers_nr pzm_personal.pers_nr%type,
        in_datum   in date
    ) return varchar2;

    function c_loa_im_host_aktivieren (
        in_pers_nr pzm_personal.pers_nr%type,
        in_monat   in number,
        in_jahr    in number
    ) return varchar2;

end;
/


-- sqlcl_snapshot {"hash":"25672d410eb4dd09391133dfbc8a82eb6ff10053","type":"PACKAGE_SPEC","name":"PZM_LOHNAUSWERTUNG","schemaName":"DIRKSPZM32","sxml":""}