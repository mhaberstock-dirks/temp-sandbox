create or replace 
package DIRKSPZM32.PZM_UTILS is

  -- Author  : WKROEKER
  -- Created : 16.12.2009 14:04:19
  -- Purpose :

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
  27.11.2009   3.4.11.1    (-WK-)   Erwiterungen Euscher
  19.05.2026               (MHab)   added result-chached-function of Get_Pers_Kst_Id
  */

  TYPE PZM_Schicht_perioden_refcur_t IS REF CURSOR RETURN pzm_schicht_perioden%ROWTYPE;

  v_release_major  constant number := 3;
  v_release_minor  constant number := 4;
  v_revision       constant number := 11;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '16.12.2009';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  function get_release return varchar2;
  function get_version return varchar2;
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2);

  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------

  function get_abwes_liste_fuer_tag(p_pers_nr in number,
                                    p_datum in date,
                                    p_spalte in number DEFAULT 1,
                                    p_separator in varchar2 DEFAULT CHR(13)) return varchar2;
  function PZM_GET_ABT_ZU_PERS_NR(in_pers_nr in number) 
    return varchar2;
        
  procedure PZM_GET_PERS_URLAUB_DATEN(in_pers_nr                in pzm_personal.pers_nr%type,
                                     in_jahr                   in number,
                                     out_jahresanspruch       out pzm_konten.saldo%type,
                                     out_genehmigt            out pzm_konten.saldo%type,
                                     out_genommen             out pzm_konten.saldo%type,
                                     out_rest                 out pzm_konten.saldo%type,
                                     out_beantragt            out pzm_konten.saldo%type,
                                     out_restvorjahr          out pzm_konten.saldo%type,
                                     out_pers_verfall_vorjahr out pzm_personal.pers_verfall_vorjahr%type,
                                     out_flexiBeantragt       out pzm_konten.saldo%type,
                                     out_flexiGenehmigt       out pzm_konten.saldo%type,
                                     out_vorgesetzter         out pzm_personal.pers_nr%type);
  function PZM_GET_PERS_VORGESETZTER(in_abt_id                in  pzm_abt_leitung.abt_l_abt_id%type,
                                     out_Vorgesetzter         out pzm_personal.pers_nr%type)
    return varchar2;
  
  function pzm_get_sm_durch_std_tag(in_sm_name               in  pzm_schicht_perioden.sp_sm_name%type)
    return number;
  
  ---------------------------------------------------------------------------------------------
  -- Diese Tage sind zur Ermittlung der Soll-Arbeitstage
  ---------------------------------------------------------------------------------------------
  function get_pers_arb_tage (in_pers_nr       in pzm_personal.pers_nr%type,
                              in_kst_id        in pzm_personal.pers_kst_id%type,
                              in_datum_beg     in date,
                              in_datum_ende    in date
                             )
                            return number;
  
  ---------------------------------------------------------------------------------------------
  -- Diese Tage sind zur Ermittlung für den 13 Tage Std-Schnitt
  ---------------------------------------------------------------------------------------------
  function get_pers_arb_std_tage (in_pers_nr       in pzm_personal.pers_nr%type,
                                  in_kst_id        in pzm_personal.pers_kst_id%type,
                                  in_datum_beg     in date,
                                  in_datum_ende    in date
                                 )
                            return number;

  ---------------------------------------------------------------------------------------------
  -- Diese Tage sind die Anwesenheitstage
  ---------------------------------------------------------------------------------------------
  function get_pers_anw_tage (in_pers_nr       in pzm_personal.pers_nr%type,
                              in_kst_id        in pzm_personal.pers_kst_id%type,
                              in_datum_beg     in date,
                              in_datum_ende    in date
                             )
                            return number;
                            
  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind für die Ermittlung der gearbeiteten Stunden
  --     Wenn in_mit_U_K = true, dann ist das die Grundlage für die Ermittlung der Überstunden 
  --     auf Monatsbasis
  ---------------------------------------------------------------------------------------------
  function get_pers_arb_std (in_pers_nr       in pzm_personal.pers_nr%type,
                             in_kst_id        in pzm_personal.pers_kst_id%type,
                             in_datum_beg     in date,
                             in_datum_ende    in date,
                             in_mit_K         in boolean default false,  -- Incl. Krank Stunden
                             in_mit_U         in boolean default false   -- Incl. Urlaub Stunden
                         )
                            return number;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn wichtig (Z.B. Feiertage)
  ---------------------------------------------------------------------------------------------
  function get_pers_krank_std (in_pers_nr       in pzm_personal.pers_nr%type,
                               in_kst_id        in pzm_personal.pers_kst_id%type,
                               in_datum_beg     in date,
                               in_datum_ende    in date
                         )
                            return number;
  function get_pers_krank_tage(in_pers_nr       in pzm_personal.pers_nr%type,
                               in_kst_id        in pzm_personal.pers_kst_id%type,
                               in_datum_beg     in date,
                               in_datum_ende    in date
                              )
                              return number;
  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn wichtig (Z.B. Feiertage)
  ---------------------------------------------------------------------------------------------
  function get_pers_feiertags_std (in_pers_nr       in pzm_personal.pers_nr%type,
                                   in_kst_id        in pzm_personal.pers_kst_id%type,
                                   in_datum_beg     in date,
                                   in_datum_ende    in date
                         )
                            return number;
                                                        
  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die Ermittlung der Stunden für Kurzarbeit
  ---------------------------------------------------------------------------------------------
  function get_pers_kug_std (in_pers_nr       in pzm_personal.pers_nr%type,
                             in_kst_id        in pzm_personal.pers_kst_id%type,
                             in_datum_beg     in date,
                             in_datum_ende    in date
                            )
                              return number;
  function get_pers_kugf_std (in_pers_nr       in pzm_personal.pers_nr%type,
                              in_kst_id        in pzm_personal.pers_kst_id%type,
                              in_datum_beg     in date,
                              in_datum_ende    in date
                             )
                              return number;
                              
  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die Ermittlung der Zeit-Konten Stundenabbuchung für  die 
  -- Stundenlohnermittlung wichtig
  ---------------------------------------------------------------------------------------------
  function get_pers_zk_std (in_pers_nr       in pzm_personal.pers_nr%type,
                            in_kst_id        in pzm_personal.pers_kst_id%type,
                            in_datum_beg     in date,
                            in_datum_ende    in date
                           )
                           return number;
                               
  function get_schicht_modell_name(in_pers_nr          in pzm_personal.pers_nr%type,
                              out_schicht_modell_name out pzm_personal.pers_sm_name%type
                             ) return boolean;
                             
  procedure GENERATE_DUMMY_PZM_PERSONAL;

  function get_standard_schicht_by_pers_nr (in_pers_nr                in pzm_personal.pers_nr%type) 
    return varchar2;

  function get_standard_schicht_by_calc_basis (in_calc_basis          in pzm_schichtarten.calc_basis%type) 
    return varchar2;

  function get_feiertag_aa_id  
    return number;

  function get_feiertag_lz_id  
    return number;
    
  function ist_feiertag_sqlresult(in_pers_nr          in pzm_personal.pers_nr%type,
                                  in_pb_id            in pzm_produktionsbereiche.pb_id%type,
                                  in_abt_id           in pzm_abteilungen.abt_id%type,
                                  in_kst_id           in pzm_personal.pers_kst_id%type,
                                  in_datum            in date) return integer;
                                 
 ---------------------------------------------------------------------------------------------
  -- Diese Funktion dient zur änderung eine Personalnummer und änder alle Konten und andere 
  -- bewegungsdaten 
  ---------------------------------------------------------------------------------------------
  function chg_pers_nr (in_pers_nr       in pzm_personal.pers_nr%type,
                        in_to_pers_nr    in pzm_personal.pers_nr%type
                        )
                        return varchar2;
                        
  function pb_GET_PERS_KST_ID(in_pers_nr in  pzm_personal.pers_nr%type
                          ) return number;                      
end;
/



-- sqlcl_snapshot {"hash":"9b552d2695647b1fd12f2f1297a2d489d81a5f61","type":"PACKAGE_SPEC","name":"PZM_UTILS","schemaName":"DIRKSPZM32","sxml":""}