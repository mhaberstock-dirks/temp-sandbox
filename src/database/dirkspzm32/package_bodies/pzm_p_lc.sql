create or replace 
package body DIRKSPZM32.PZM_P_LC is

  C_CP_TRENNER constant varchar2(1) := '@';
  C_PP_TRENNER constant varchar2(1) := '|';

  function is_app_code(p_code pls_integer) return boolean is
  begin
    return p_code between -20999 and -20000;
  end;

  function get_backtrace return clob is
  begin
    return dbms_utility.format_error_backtrace;
    -- alternativ/ergaenzend: utl_call_stack fuer noch feinere Kontrolle
  end;

  function get_error_stack return clob is
  begin
    return dbms_utility.format_error_stack;
  end;

  function build_message(
    p_user_message in varchar2,
    p_params       in clob default null,
    p_with_bt      in boolean default true
  ) return clob is
    v_msg  clob;
  begin
    v_msg := p_user_message;

    if p_params is not null then
      v_msg := v_msg || CHR(10) || 'Context: ' || p_params;
    end if;

    if p_with_bt then
      v_msg := v_msg || CHR(10) || 'Backtrace:' || CHR(10) || get_backtrace;
    end if;

    return v_msg;
  end;

  function truncate_for_error(p_msg clob) return varchar2 is
    c_max_length constant number := 250;  -- Reserve für ' [...]'
    v_result varchar2(256);
  begin
    if p_msg is null then
      return null;
    end if;
    
    if dbms_lob.getlength(p_msg) <= c_max_length then
      -- Passt komplett rein
      v_result := dbms_lob.substr(p_msg, c_max_length, 1);
    else
      -- Muss abgeschnitten werden
      v_result := dbms_lob.substr(p_msg, c_max_length, 1) || ' [...]';
    end if;
    
    return v_result;
  exception
    when others then
      -- Fallback bei Konvertierungsproblemen
      return 'Error message conversion failed: ' || sqlerrm;
  end;

  procedure raise_app_error(
    in_code     in pls_integer,
    in_message  in varchar2
  ) is
    v_code   pls_integer := nvl(in_code, PZM_ERROR_BUCHUNG);
  begin
    RAISE_APPLICATION_ERROR(v_code, truncate_for_error(in_message), true);
  end;

  procedure raise_app_error_p1(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2
  ) is
    v_msg    clob;
  begin
    v_msg := create_p1(in_const_name, in_p1);
    RAISE_APPLICATION_ERROR(in_code, truncate_for_error(v_msg), true);
  end;

  procedure raise_app_error_p2(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_p1         in varchar2,
    in_p2         in varchar2
  ) is
    v_msg    clob;
  begin
    v_msg := create_p2(in_const_name, in_p1, in_p2);
    RAISE_APPLICATION_ERROR(in_code, truncate_for_error(v_msg), true);
  end;


  procedure catch_and_rethrow(
    in_location       in varchar2,
    in_fallback_code  in pls_integer default pzm_error_buchung,
    in_user_message   in varchar2    default null
  ) is
    v_sqlcode   pls_integer := sqlcode;
    v_sqlerrm   varchar2(32767 char) := regexp_replace(sqlerrm, '^ORA-\d{5}:\s*', '');
    v_message   clob;
  begin
    -- Kontext zusammenbauen: Location + optionaler Domaenentext + Originalfehler

    if is_app_code(v_sqlcode) then
      -- Bereits ein eigener App-Fehler: Weitergeben, aber p_user_message/Context anhaengen
      v_message := nvl(in_user_message, v_sqlerrm);
      raise_app_error(v_sqlcode, v_message);
    else
      -- Systemfehler oder anderer Code: wrappen mit Fallback
      v_message := nvl(in_user_message, 'An unexpected error occurred');
      raise_app_error(in_fallback_code, v_message);
    end if;
  end;

  function create_p1(
    in_const_name in varchar2,
    in_p1 in varchar2
  ) return varchar2 is
  begin
    return in_const_name || C_CP_TRENNER || '[' || nvl(in_p1, '') || ']';
  end;

  function create_p2(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2
  ) return varchar2 is
  begin
    return in_const_name || C_CP_TRENNER || '[' || nvl(in_p1, '') || C_PP_TRENNER
                                              || nvl(in_p2, '') || ']';
  end;

  function create_p3(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2
  ) return varchar2 is
  begin
    return in_const_name || C_CP_TRENNER || '[' || nvl(in_p1, '') || C_PP_TRENNER
                                              || nvl(in_p2, '') || C_PP_TRENNER
                                              || nvl(in_p3, '') || ']';
  end;

  function create_p4(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2,
    in_p4 in varchar2
  ) return varchar2 is
  begin
    return in_const_name || C_CP_TRENNER || '[' || nvl(in_p1, '') || C_PP_TRENNER
                                              || nvl(in_p2, '') || C_PP_TRENNER
                                              || nvl(in_p3, '') || C_PP_TRENNER
                                              || nvl(in_p4, '') || ']';
  end;

  function create_p5(
    in_const_name in varchar2,
    in_p1 in varchar2,
    in_p2 in varchar2,
    in_p3 in varchar2,
    in_p4 in varchar2,
    in_p5 in varchar2
  ) return varchar2 is
  begin
    return in_const_name || C_CP_TRENNER || '[' || nvl(in_p1, '') || C_PP_TRENNER
                                              || nvl(in_p2, '') || C_PP_TRENNER
                                              || nvl(in_p3, '') || C_PP_TRENNER
                                              || nvl(in_p4, '') || C_PP_TRENNER
                                              || nvl(in_p5, '') || ']';
  end;

end;
/



-- sqlcl_snapshot {"hash":"4d6fa699724e00f1ec492b251e2e879b92a2aab8","type":"PACKAGE_BODY","name":"PZM_P_LC","schemaName":"DIRKSPZM32","sxml":""}