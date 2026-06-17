create or replace 
package DIRKSPZM32.pzm_p_base is

  /*
  __________________________________________________
  Author
  WKROEKER (-WK-)  17.03.2009 15:21:24
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

  v_release_major  constant number := 3;
  v_release_minor  constant number := 4;
  v_revision       constant number := 9;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '17.03.2009';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  --v_version_str    constant  varchar2(20) := '3.4.9.1 / 17.03.2009';
  function get_release return varchar2;
  function get_version return varchar2;
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2);

  /*
   *  Revision history
   *  date       | revision   | Info
   *  ---------------------------------------------------------------------------------
   *  17.03.2009 | 3.4.9      | (-WK-) package created
   */

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/

  -------------------------------------------------------------------------------------------------------
  --* this function retrieves a record of pzm_pers_details identified by in_pers_nr
  -------------------------------------------------------------------------------------------------------
  function get_personal(in_pers_nr       in pzm_personal.pers_nr%type, --* pers_nr für die die Details geholt werden sollen
                        out_personal out pzm_personal%rowtype --* the resulting record of pzm_pers_details
                          ) return boolean;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_schicht_modell(in_pers_nr          in pzm_personal.pers_nr%type,
                              out_schicht_modelle out pzm_schicht_modelle%rowtype
                            ) return boolean;
  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_schichtart(in_sa_name     in  pzm_schichtarten.sa_name%type,
                          out_schichtart out pzm_schichtarten%rowtype
                         ) return boolean;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_schichtart_by_uix(in_sa_kurzname in  pzm_schichtarten.sa_kurzname%type,
                                 out_schichtart out pzm_schichtarten%rowtype
                                ) return boolean;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_lohnart(in_lz_id       in pzm_lohnarten.lz_id%type,
                          out_lohnart out pzm_lohnarten%rowtype
                         ) return boolean;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_lohnart_by_loa(in_loa         in pzm_lohnarten.lz_lohnart%type,
                              in_aa_id       in pzm_abwesenheitsarten.aa_id%type,
                              out_lohnart out pzm_lohnarten%rowtype
                              ) return boolean;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_lohnart_by_alternative_lz_id(in_lz_id       in pzm_lohnarten.lz_id%type,
                                            out_lohnart out pzm_lohnarten%rowtype
                                           ) return boolean;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_abwesenheitsart(in_aa_id            in pzm_abwesenheitsarten.aa_id%type,
                               out_abwesenheitsart out pzm_abwesenheitsarten%rowtype
                              ) return boolean;

  function get_allg_parameter_mandant(in_pb_id      in pzm_produktionsbereiche.pb_id%type,    
                                      in_param_name in pzm_allg_parameter.ap_name%type) 
                              return varchar2;

end pzm_p_base;
/



-- sqlcl_snapshot {"hash":"65014f2c1b45b7ef9dad58858eaf807bb1ccb451","type":"PACKAGE_SPEC","name":"PZM_P_BASE","schemaName":"DIRKSPZM32","sxml":""}