create or replace 
package body DIRKSPZM32.PZM_P_LC is

  C_CP_TRENNER constant varchar2(1) := '@';
  C_PP_TRENNER constant varchar2(1) := '|';
  C_MAX_ERROR_MESSAGE_LENGTH constant pls_integer := 2000; -- Sicherheitsmarge unter dem von RAISE_APPLICATION_ERROR akzeptierten Limit (~2048 Byte)


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

  function create_p( in_p1 in varchar2
                   , in_p2 in varchar2 default null)
                     return varchar2
  is 
  begin
    return C_CP_TRENNER || '[' || nvl(in_p1, '') ||
       CASE WHEN in_p2 is not null then C_PP_TRENNER || in_p2 end || 
    ']';
  end create_p;                   

  function create_p( in_params in t_paramlist)
                     return varchar2
  is 
    v_result varchar2(4000 char);
  begin
    if in_params is not null then
      for i in 1 .. in_params.count loop
        v_result := v_result || case when i > 1 then C_PP_TRENNER end || in_params(i);
      end loop;
    end if;
    return C_CP_TRENNER || '[' || v_result || ']';
  end create_p;

  -----------------------------------------------------------------------------------------------
  -- Private: einheitliches Protokollieren VOR dem eigentlichen RAISE_APPLICATION_ERROR.
  -- Bewusst NICHT log_exception()/format_error_backtrace() - an dieser Stelle ist noch keine
  -- Exception aktiv (SQLCODE waere hier 0). DBMS_UTILITY.FORMAT_CALL_STACK() liefert stattdessen
  -- die aktuelle Aufrufkette bis zu dieser Stelle, unabhaengig von einer aktiven Exception.
  -----------------------------------------------------------------------------------------------
  procedure log_before_raise(
    in_code    in pls_integer,
    in_message in varchar2
  ) is
  begin
    pzm_p_log.log_data(
      p_level      => pzm_p_log.LEVEL_ERROR,
      p_message    => in_message,
      p_error_code => in_code,
      p_stacktrace => dbms_utility.format_call_stack
    );
  end log_before_raise;

  procedure raise_app_error(
    in_code     in pls_integer,
    in_message  in varchar2
  ) is
    v_code    pls_integer := nvl(in_code, cerr_PZM_BUCHUNG);
    v_message varchar2(4000 char) := substr(in_message, 1, C_MAX_ERROR_MESSAGE_LENGTH);
  begin
    log_before_raise(v_code, v_message);
    raise_application_error(v_code, v_message, true);
  end;

  procedure raise_app_error_p(
      in_code       in pls_integer,
      in_const_name in varchar2,
      in_p1         in varchar2,
      in_p2         in varchar2 default null
    )
  is
    v_code    pls_integer := nvl(in_code, cerr_PZM_BUCHUNG);
    v_message varchar2(4000 char) := substr(in_const_name || create_p(in_p1, in_p2), 1, C_MAX_ERROR_MESSAGE_LENGTH);
  begin
    log_before_raise(v_code, v_message);
    raise_application_error(v_code, v_message, true);
  end raise_app_error_p;

  procedure raise_app_error_p(
    in_code       in pls_integer,
    in_const_name in varchar2,
    in_plist      in t_paramlist
  ) is
    v_code    pls_integer := nvl(in_code, cerr_PZM_BUCHUNG);
    v_message varchar2(4000 char) := substr(in_const_name || create_p(in_plist), 1, C_MAX_ERROR_MESSAGE_LENGTH);
  begin
    log_before_raise(v_code, v_message);
    raise_application_error(v_code, v_message, true);
  end raise_app_error_p;


/*    
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
*/

/*
  procedure catch_and_rethrow(
    --in_location       in varchar2,
    in_fallback_code  in pls_integer default cerr_pzm_buchung,
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
      -- Hinweis: 
      -- -------- 
      -- Oracle-Spezifische Meldungen werden hiermit durch einen generischen Fehler
      -- ohne Aussagekraft ersetzt! Das kann sinnvoll sein, um komplexe technische Informationen
      -- vor dem Anwender zu verbergen. Erschwert allerdings auch die Fehlersuche im Supportfall! 
      -- Aufruf daher ausschließlich im Exception-Handler *NACH* pzm_p_log.log_exception()! 
      v_message := nvl(in_user_message, 'An unexpected error occurred');
      raise_app_error(in_fallback_code, v_message);
    end if;
  end;
*/  
  
  /*
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
  */
end pzm_p_lc;
/



-- sqlcl_snapshot {"hash":"dae8b1dfad4b9ea7131e180ed9e65fa018cc4652","type":"PACKAGE_BODY","name":"PZM_P_LC","schemaName":"DIRKSPZM32","sxml":""}