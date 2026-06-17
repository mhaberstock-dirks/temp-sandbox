create or replace 
package body DIRKSPZM32.pzm_p_base is

  v_build_number constant number := 1;
  /*
   *  Build history
   *  date       | version    | info
   *  ---------------------------------------------------------------------------------
   *  17.03.2009 | 3.4.9.1    | (-WK-) package created
   */

  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
    return(v_release_str);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2
                          ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/


  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_personal(in_pers_nr       in pzm_personal.pers_nr%type,
                           out_personal  out pzm_personal%rowtype
                          ) return boolean is
    v_result boolean;
    cursor c_personal is
      select t.*
        from pzm_personal t
       where t.pers_nr = in_pers_nr;
  begin
    open c_personal;
    fetch c_personal into out_personal;
    v_result := c_personal%found;
    close c_personal;

    return (v_result);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_schicht_modell(in_pers_nr          in pzm_personal.pers_nr%type,
                              out_schicht_modelle out pzm_schicht_modelle%rowtype
                             ) return boolean is
    v_result boolean;
    cursor c_schicht_modelle is
      select sm.*
        from pzm_personal p,
             isi_kostenstellen k,
             pzm_abteilungen a,
             pzm_schicht_modelle sm
       where p.pers_nr = in_pers_nr
         and a.abt_id = p.pers_abt_id
         and nvl(p.pers_kst_id, a.abt_kst_id) = k.kst_nr(+)
         and sm.sm_name = nvl(nvl(p.pers_sm_name, k.kst_standard_sm_name), a.abt_standard_sm_name);
  begin
    open c_schicht_modelle;
    fetch c_schicht_modelle into out_schicht_modelle;
    v_result := c_schicht_modelle%found;
    close c_schicht_modelle;

    return (v_result);
  end;


  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_schichtart(in_sa_name     in  pzm_schichtarten.sa_name%type,
                          out_schichtart out pzm_schichtarten%rowtype
                         ) return boolean is
    v_result boolean;
    cursor c_schichtart is
      select t.*
        from pzm_schichtarten t
       where t.sa_name = in_sa_name;
  begin
    open c_schichtart;
    fetch c_schichtart into out_schichtart;
    v_result := c_schichtart%found;
    close c_schichtart;

    return (v_result);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_schichtart_by_uix(in_sa_kurzname in  pzm_schichtarten.sa_kurzname%type,
                                 out_schichtart out pzm_schichtarten%rowtype
                                ) return boolean is
    v_result boolean;
    cursor c_schichtart is
      select t.*
        from pzm_schichtarten t
       where t.sa_kurzname = in_sa_kurzname;
  begin
    open c_schichtart;
    fetch c_schichtart into out_schichtart;
    v_result := c_schichtart%found;
    close c_schichtart;

    return (v_result);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_lohnart(in_lz_id       in pzm_lohnarten.lz_id%type,
                          out_lohnart out pzm_lohnarten%rowtype
                         ) return boolean is
    v_result boolean;
    cursor c_lohnart is
      select t.*
        from pzm_lohnarten t
       where t.lz_id = in_lz_id;
  begin
    open c_lohnart;
    fetch c_lohnart into out_lohnart;
    v_result := c_lohnart%found;
    close c_lohnart;

    return (v_result);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_lohnart_by_loa(in_loa         in pzm_lohnarten.lz_lohnart%type,
                              in_aa_id       in pzm_abwesenheitsarten.aa_id%type,
                              out_lohnart out pzm_lohnarten%rowtype
                             ) return boolean is
    v_result boolean;
    cursor c_lohnart is
      select t.*
        from pzm_lohnarten t,
             pzm_abwesenheitsarten a
       where t.lz_lohnart = in_loa
         and t.lz_id = a.lz_id(+)
         and in_aa_id = a.aa_id(+);
  begin
    open c_lohnart;
    fetch c_lohnart into out_lohnart;
    v_result := c_lohnart%found;
    close c_lohnart;

    return (v_result);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_lohnart_by_alternative_lz_id(in_lz_id       in pzm_lohnarten.lz_id%type,
                                            out_lohnart out pzm_lohnarten%rowtype
                                           ) return boolean is
    v_result boolean;
    cursor c_lohnart is
      select t.*
        from pzm_lohnarten t
       where t.lz_alternativ_loa_id = in_lz_id;
  begin
    open c_lohnart;
    fetch c_lohnart into out_lohnart;
    v_result := c_lohnart%found;
    close c_lohnart;

    return (v_result);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_abwesenheitsart(in_aa_id            in pzm_abwesenheitsarten.aa_id%type,
                               out_abwesenheitsart out pzm_abwesenheitsarten%rowtype
                              ) return boolean is
    v_result boolean;
    cursor c_abwesenheitsart is
      select t.*
        from pzm_abwesenheitsarten t
       where t.aa_id = in_aa_id;
  begin
    open c_abwesenheitsart;
    fetch c_abwesenheitsart into out_abwesenheitsart;
    v_result := c_abwesenheitsart%found;
    close c_abwesenheitsart;

    return (v_result);
  end;

  function get_allg_parameter_mandant(in_pb_id      in pzm_produktionsbereiche.pb_id%type,    
                                      in_param_name in pzm_allg_parameter.ap_name%type) 
                              return varchar2 is
    Result varchar2(255);

    CURSOR c_AllgParam IS
      SELECT ap_value 
        FROM pzm_allg_parameter p
       WHERE LOWER(p.ap_name) = LOWER(in_param_name)
         and nvl(p.ap_pb_id, in_pb_id) = in_pb_id
       order by decode(p.ap_pb_id, NULL, 1,0); -- Der korrekte produktionsbereich / mandant zuerst

  begin
    OPEN c_AllgParam;

    FETCH c_AllgParam INTO Result;

    if c_AllgParam%NOTFOUND then
      Result := NULL;
    end if;

    CLOSE c_AllgParam;

    return(Result);
  end;  

end pzm_p_base;
/



-- sqlcl_snapshot {"hash":"1d254c96bd5bdf4df2e620f6c211338e5d8744d8","type":"PACKAGE_BODY","name":"PZM_P_BASE","schemaName":"DIRKSPZM32","sxml":""}