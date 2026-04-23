create or replace package dirkspzm32.lvs_lager_abrechnung is

  -- Author  : HJGOEDEKE
  -- Created : 16.03.2012 08:16:07
  -- Purpose : Funktionen für die Lagerabrechnung

    v_release_major constant number := 3;
    v_release_minor constant number := 5;
    v_revision constant number := 3;
  -- the build number is counted in the package body
    v_rev_date constant varchar2(20) := '07.03.2009';
    v_release_str constant varchar2(20) := to_char(v_release_major)
                                           || '.'
                                           || to_char(v_release_minor)
                                           || '.'
                                           || to_char(v_revision)
                                           || ' / '
                                           || v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.4.10.1 / 27.02.2009';
    function get_release return varchar2;

    function get_version return varchar2;

    procedure get_version_ex (
        out_rel_major   out number,
        out_rel_minor   out number,
        out_revision    out number,
        out_buid_number out number,
        out_rev_date    out varchar2
    );

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die eingelagert wurden (Im Lagerort)
  -------------------------------------------------------------------------------------*/
    function get_lte_we (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert wurden (Etiketten und Kommission egal)
  -------------------------------------------------------------------------------------*/
    function get_lte_wa (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert wurden und nicht kommissioniert wurden mit
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lte_wa_o_komm_o_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert wurden und nicht kommissioniert wurden ohne
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lte_wa_ohne_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LTEs die ausgelagert und kommissioniert wurden Etikett egal
  -------------------------------------------------------------------------------------*/
    function get_lte_wa_mit_komm (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert wurden Etiketendruck egal
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert wurden mit Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_m_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert wurden mit Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_m_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert wurden ohne Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_o_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert ohne umpacken wurden
    Etiketendruck egal
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_oup (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert ohne Umpacken wurden mit
    Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_oup_m_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die LHMs die ausgelagert und kommissioniert ohne Umpacken wurden
    ohne Etiketendruck
  -------------------------------------------------------------------------------------*/
    function get_lhm_wa_komm_oup_o_eti (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

  /*-------------------------------------------------------------------------------------
    Funktion zählt die Benutzten Plätze in Tage für Lte-Name
  -------------------------------------------------------------------------------------*/
    function get_lte_platz_tage (
        in_sid           in isi_sid.sid%type,
        in_firma_nr      in isi_firma.firma_nr%type,
        in_lte_name      in lvs_lte_cfg.lte_name%type,
        in_lte_status    in lvs_lte.lte_status%type,
        in_ausw_start    in date,
        in_ausw_ende     in date,
        in_lgr_ort_liste in varchar
    ) return number;

end lvs_lager_abrechnung;
/


-- sqlcl_snapshot {"hash":"306fafbdb36561d25073059e3d5e20b81a87a779","type":"PACKAGE_SPEC","name":"LVS_LAGER_ABRECHNUNG","schemaName":"DIRKSPZM32","sxml":""}