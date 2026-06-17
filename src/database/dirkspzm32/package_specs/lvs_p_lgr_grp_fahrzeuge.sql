create or replace 
package DIRKSPZM32.lvs_p_lgr_grp_fahrzeuge is

  /*
  __________________________________________________
  Author
  HJGOEDEKE (-AG-)  26.07.2005 10:51:22
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
  type t_fuellgrad is table of number
      index by binary_integer;
  type t_fahrzeuge is table of boolean
      index by binary_integer;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;
  v_g_fah_text                    varchar2(255);

  v_fuellgrad_tab                 t_fuellgrad;
  v_fuellgrad_tab_empty           t_fuellgrad;
--  v_fahrzeuge_tab                 t_fahrzeuge;
--  v_fahrzeuge_tab_empty           t_fahrzeuge;

  -- Public function and procedure declarations
  function chk_lgr_platz_zugriff_ok(in_lgr_platz      in   lvs_lgr.lgr_platz%type
                                   )
                                    return varchar2;

  function chk_lgr_grp_zugriff_ok(in_lgr            in   lvs_lgr%rowtype,
                                  in_lte            in   lvs_lte%rowtype,
                                  in_fahrzeuge_IDs  in   varchar2
                                 )
                                  return varchar2;

  function lgr_grp_fuellgrad (in_sid                 in isi_sid.sid%type,
                              in_firma_nr            in isi_firma.firma_nr%type,
                              in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                              in_lgr_gruppe_id       in lvs_lgr.lgr_gruppe_id%type,
                              in_ref_lgr_ort         in lvs_lgr_ort.lgr_ort%type,
                              in_ref_lgr_gruppe_id   in lvs_lgr.lgr_gruppe_id%type,
                              in_res_string          in    lvs_lte.res_string%type
                             ) return number;

  function chk_lte_lgr_zugriff_ok(in_lte_id         in   lvs_lte.lte_id%type
                                 ) return varchar2;

  procedure c_set_fahrzeug_status (in_res_id              in   isi_resource.res_id%type,
                                   in_status_OK           in   lvs_fahrzeuge.fahrzeug_ok%type,
                                   in_anz_test_lte        in   lvs_fahrzeuge.anz_test_lte%type,
                                   in_ausl_status_OK      in   lvs_fahrzeuge.fahrzeug_ok%type
                                   );

  procedure c_set_lgr_grp_to_fahrzeug(in_sid                 in isi_sid.sid%type,
                                      in_firma_nr            in isi_firma.firma_nr%type,
                                      in_lgr_ort             in lvs_lgr_ort.lgr_ort%type,
                                      in_lgr_gruppe_set      in lvs_lgr.lgr_gruppe_id%type,
                                      in_lgr_gruppe_rest     in lvs_lgr.lgr_gruppe_id%type,
                                      in_lgr_dim_g           in lvs_lgr.lgr_dim_g%type,
                                      in_lgr_dim_r           in lvs_lgr.lgr_dim_r%type,
                                      in_lgr_dim_p_von       in lvs_lgr.lgr_dim_p%type,
                                      in_lgr_dim_p_bis       in lvs_lgr.lgr_dim_p%type,
                                      in_lgr_dim_e_von       in lvs_lgr.lgr_dim_e%type,
                                      in_lgr_dim_e_bis       in lvs_lgr.lgr_dim_e%type,
                                      in_anz_plaetze         in number);

  procedure c_chk_fahrzeug_defekt_st(in_sid                 in isi_sid.sid%type,
                                     in_firma_nr            in isi_firma.firma_nr%type);

end lvs_p_lgr_grp_fahrzeuge;
/



-- sqlcl_snapshot {"hash":"5c771ec95f7be4ae6f4ae1d9aad99d49df31466d","type":"PACKAGE_SPEC","name":"LVS_P_LGR_GRP_FAHRZEUGE","schemaName":"DIRKSPZM32","sxml":""}