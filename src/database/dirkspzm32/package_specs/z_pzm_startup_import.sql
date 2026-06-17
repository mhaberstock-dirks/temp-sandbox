create or replace 
package DIRKSPZM32.z_pzm_startup_import is

  /*
  -- Author  : hjgoedeke
  -- Created : 11.11.2024
  -- Purpose :

  /*
  __________________________________________________
  Author
  hjgoedeke (-AG-)  28.11.2024 13:00:00
  __________________________________________________
  Description
  __________________________________________________
  TODO
  none
  __________________________________________________
  Date         Ver.        AUTOR    Comment
  -----------  ---------   ------   ---------------
  28.11.2024   5.5.x       (-AG-)   Für PZM-Zeiterfassung - Startup 
  */

  v_release_major  constant number := 5;
  v_release_minor  constant number := 5;
  v_revision       constant number := 1;
  -- the build number is counted in the package body
  v_rev_date       constant varchar2(20) := '28.11.2024';
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
    
  procedure pzm_urlaub_flex_start_import(in_del_kontobuchungen   in varchar2,
                                         in_zk_start             in date);
  procedure pzm_stempelzeiten_import;
  procedure pzm_update_pers_nr;
  procedure pzm_update_pers_nr_transponder;

end z_pzm_startup_import;
/



-- sqlcl_snapshot {"hash":"d460acd1d3cbc40d5a95223f56f5756ad38eefd6","type":"PACKAGE_SPEC","name":"Z_PZM_STARTUP_IMPORT","schemaName":"DIRKSPZM32","sxml":""}