create or replace package dirkspzm32.lvs_lager_opt is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  18.09.2004 12:42:24
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

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

    function lvs_lort_format (
        in_lo_a in varchar2
    ) return varchar2;

    function lvs_lort_count (
        in_lo in varchar2
    ) return number;

    function lvs_lort_ix (
        in_str_a    in varchar2,
        in_position in number
    ) return lvs_lgr.lgr_ort%type;

    function lvs_lort_log_und (
        in_lo_a  in varchar2,
        in_lo_b  in varchar2,
        out_lo_e out varchar2
    ) return varchar2;

    procedure lvs_kanal_kontrolle (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    );

    procedure c_kompress (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_lgr_ort          in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz_grp    in varchar2,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_login_id         in isi_user.login_id%type
    );

    procedure lvs_c_lager_reset;

    procedure lvs_c_transp_suche_einl_opti (
        in_lte_id         in lvs_lte.lte_id%type,
        in_transport_id   in isi_transport.transp_id%type,
        in_synch_trans_id in isi_transport.transp_id%type,
        in_fahrzeuge_ids  in varchar2,
        out_lgr_platz     out lvs_lgr.lgr_platz%type,
        out_lte_id        out lvs_lte.lte_id%type,
        out_prio          out number
    );

    procedure lvs_c_transp_suche_einl_2s_opt (
        in_transport_id         in isi_transport.transp_id%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    );

    procedure lvs_c_suche_opti_einl_platz (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_transport_id            in isi_transport.transp_id%type,
        in_synch_trans             in isi_transport%rowtype,
        in_fahrzeuge_ids           in varchar2,
        in_lgr_orte                in varchar2,
        out_lgr_platz              out lvs_lgr%rowtype
    );

    function lte_platz_einl_pruef_err_text (
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        in_fahrzeuge_ids in varchar2
    ) return varchar2;

    function lvs_lgr_abstand_faktor return number;

    function lvs_platz_regal_ebene_faktor return number;

    function lvs_platz_bestand_ausl_faktor return number;

    function lvs_platz_l_buchung return date;

    function lvs_platz_faktor_belegung_akt return number;

    procedure lvs_lte_freifahren (
        in_lte              in lvs_lte%rowtype,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_prio             in isi_transport.prio%type,
        in_fahrzeuge_ids    in varchar2
    );

end lvs_lager_opt;
/


-- sqlcl_snapshot {"hash":"ae3c3a7d6453111cacf73ff9ffd0ff78618953f9","type":"PACKAGE_SPEC","name":"LVS_LAGER_OPT","schemaName":"DIRKSPZM32","sxml":""}