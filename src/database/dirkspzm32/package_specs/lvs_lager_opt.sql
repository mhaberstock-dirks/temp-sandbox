create or replace 
package DIRKSPZM32.lvs_lager_opt is

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

  Function LVS_LORT_FORMAT(in_lo_a in varchar2) return varchar2;

  function LVS_LORT_COUNT(in_lo in varchar2) return number;

  Function LVS_LORT_IX(in_str_a in varchar2, in_position in number)
    return lvs_lgr.lgr_ort%TYPE;

  FUNCTION LVS_LORT_LOG_UND(in_lo_a  IN VARCHAR2,
                            in_lo_b  IN VARCHAR2,
                            out_lo_e OUT VARCHAR2) RETURN VARCHAR2;

  Procedure LVS_KANAL_KONTROLLE(in_lte in lvs_lte%ROWTYPE,
                                in_lgr in lvs_lgr%ROWTYPE);


  procedure c_kompress(in_sid                in     isi_sid.sid%type,
                       in_firma_nr           in     isi_firma.firma_nr%type,
                       in_lgr_ort            in     lvs_lgr_ort.lgr_ort%type,
                       in_lgr_platz_grp      in     varchar2,
                       in_modul_erzeuger     in     isi_transport.modul_erzeuger%type,
                       in_modul_bearbeiter   in     isi_transport.modul_bearbeiter%type,
                       in_login_id           in     isi_user.login_id%type
                    );

  procedure LVS_C_LAGER_RESET;

  procedure lvs_c_transp_suche_einl_opti(in_lte_id       in lvs_lte.lte_id%TYPE,
                                         in_transport_id in isi_transport.transp_id%type,
                                         in_synch_trans_id in isi_transport.transp_id%type,
                                         in_fahrzeuge_IDs  in varchar2,
                                         out_lgr_platz   out lvs_lgr.lgr_platz%TYPE,
                                         out_lte_id      out lvs_lte.lte_id%type,
                                         out_prio        out number);

  procedure lvs_c_transp_suche_einl_2s_opt(in_transport_id         in isi_transport.transp_id%type,
                                           in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                           in_lgr_orte             in varchar2,
                                           in_fahrzeuge_IDs        in varchar2,
                                           in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                           in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                           in_user_ID              in isi_user.login_id%TYPE,
                                           in_prio                 in isi_transport.Prio%TYPE,
                                           in_progr_nr             in isi_transport.progr_nr%TYPE,
                                           in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                           in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                           in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                           in_aktuelle_position    in lvs_lam.lam_text%type,
                                           out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                           out_transport_id        out number,
                                           out_res_id              out isi_resource.res_id%type);

  PROCEDURE LVS_C_SUCHE_OPTI_EINL_PLATZ(in_lte            in lvs_lte%ROWTYPE,
                                        in_basis_lte_name in lvs_lte_cfg.basis_lte_name%type,
                                        in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                                        in_transport_id   in isi_transport.transp_id%type,
                                        in_synch_trans    in isi_transport%rowtype,
                                        in_fahrzeuge_IDs  in varchar2,
                                        in_lgr_orte       in varchar2,
                                        out_lgr_platz     out lvs_lgr%ROWTYPE);

  function lte_platz_einl_pruef_err_text(in_lte_id            in lvs_lte.lte_id%type,
                                          in_lgr_platz         in lvs_lgr.lgr_platz%type,
                                          in_fahrzeuge_IDs     in varchar2)
                                          return varchar2;

  function LVS_LGR_ABSTAND_FAKTOR return number;

  function LVS_PLATZ_REGAL_EBENE_FAKTOR return number;

  function LVS_PLATZ_BESTAND_AUSL_FAKTOR return number;

  function LVS_PLATZ_L_BUCHUNG return date;

  function LVS_PLATZ_FAKTOR_BELEGUNG_AKT return number;

  procedure LVS_LTE_FREIFAHREN(in_lte              in lvs_lte%rowtype,
                               in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                               in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
                               in_prio             in isi_transport.prio%type,
                               in_fahrzeuge_IDs    in varchar2);

end lvs_lager_opt;
/



-- sqlcl_snapshot {"hash":"ca7fd3d4c5105f852d959a7bb6c44ef3416021e0","type":"PACKAGE_SPEC","name":"LVS_LAGER_OPT","schemaName":"DIRKSPZM32","sxml":""}