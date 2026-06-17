create or replace 
package DIRKSPZM32.pzm_bde_utils is

  -- Author  : hjgoedeke
  -- Created : 11.11.2024
  -- Purpose :

  /*
  __________________________________________________
  Author
  hjgoedeke (-AG-)  13.11.2024 15:21:24
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  13.11.2024   5.5.x       (-AG-)   Für BDE-Zeiterfassung aus dem PZM
  */

  TYPE PZM_Schicht_perioden_refcur_t IS REF CURSOR RETURN pzm_schicht_perioden%ROWTYPE;

  v_release_major  constant number := 5;
  v_release_minor  constant number := 5;
  v_revision       constant number := 1;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '16.12.2009';
  v_release_str    constant  varchar2(20) := to_char(v_release_major) || '.' ||
                                             to_char(v_release_minor) || '.' ||
                                             to_char(v_revision) || ' / ' ||
                                             v_rev_date;

  v_sid                         isi_sid%rowtype;
  v_firma                       isi_firma.firma_nr%type;
  v_sid_found                   boolean;
  v_isi_user                    isi_user%rowtype;
  
  CURSOR c_sid is
   select *
     from isi_sid s
    where s.sid_my_sid = 1;



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

    function c_start_zeit_fa_pers_nr(in_pers_nr in isi_user.pers_nr%type,
                                     in_ts_datum    in pzm_ze_bde_zeiten.ze_bde_datum%type,
                                     in_leitzahl    in bde_fa_auftrag.leitzahl%type,
                                     in_fa_ag       in bde_fa_auftrag.fa_ag%type,
                                     in_fa_upos     in bde_fa_auftrag.fa_upos%type,
                                     in_datum       in bde_fa_auftrag.termin_start_ist%type) 
                                     return number;
    
    function c_pzm_pers_nr_zeit_fa_buchen(in_pers_nr      in pzm_personal.pers_nr%type,
                                          in_sa_kurz_name in bde_pd_kopf.sa_kurzname%type,
                                          in_datum_beg    in bde_pd_kopf.pd_kopf_beginn%type,
                                          in_datum_ende   in bde_pd_kopf.pd_kopf_ende%type,
                                          in_zeit_std     in number,
                                          in_datum        in pzm_ze_tagessatz.ts_datum%type) 
                                          return number;
                                        
    function pzm_pers_nr_zeit_fa_buchen(in_pers_nr      in pzm_personal.pers_nr%type,
                                        in_sa_kurz_name in bde_pd_kopf.sa_kurzname%type,
                                        in_datum_beg    in bde_pd_kopf.pd_kopf_beginn%type,
                                        in_datum_ende   in bde_pd_kopf.pd_kopf_ende%type,
                                        in_zeit_std     in number,
                                        in_datum        in pzm_ze_tagessatz.ts_datum%type) 
                                        return number;

    function c_pzm_ze_tagessatz_buchen(in_datum        in pzm_ze_tagessatz.ts_datum%type) 
                                      return number;

end;
/



-- sqlcl_snapshot {"hash":"971a17f953bb24614d79acd5ce86b18c74589b4f","type":"PACKAGE_SPEC","name":"PZM_BDE_UTILS","schemaName":"DIRKSPZM32","sxml":""}