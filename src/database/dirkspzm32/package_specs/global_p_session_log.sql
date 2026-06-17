create or replace 
package DIRKSPZM32.GLOBAL_P_SESSION_LOG is
  -----------------------------------------------------------------------------------------------
  -- Package: global_p_session_log
  -- Zweck:   Generischer Session-basierter Log-Buffer fuer .NET Integration
  --
  -- Dieses Package stellt einen In-Memory Buffer fuer Log-Eintraege bereit,
  -- der von beliebigen kontextspezifischen Loggern (PZM, BDE, etc.) genutzt
  -- werden kann. Der .NET Client kann nach jedem DB-Call die gepufferten
  -- Logs abholen und an den zentralen .NET Logger weiterleiten.
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Log-Level Konstanten (kompatibel mit .NET/Serilog)
  -----------------------------------------------------------------------------------------------
  LEVEL_TRACE   constant number := 0;
  LEVEL_DEBUG   constant number := 1;
  LEVEL_INFO    constant number := 2;
  LEVEL_WARNING constant number := 3;
  LEVEL_ERROR   constant number := 4;
  LEVEL_FATAL   constant number := 5;

  -----------------------------------------------------------------------------------------------
  -- Record-Typ fuer Log-Eintraege (generisch)
  -----------------------------------------------------------------------------------------------
  type t_log_entry is record (
    log_id           number,
    log_timestamp    timestamp,
    log_level        number,
    log_category     varchar2(50 char),
    log_module       varchar2(100 char),
    log_message      varchar2(4000 char),
    log_error_code   integer,
    -- Kontext-Felder (generisch benannt)
    ctx_id1          integer,
    ctx_id2          integer,
    ctx_str1         varchar2(50 char),
    ctx_str2         varchar2(50 char),
    ctx_str3         varchar2(50 char),
    ctx_str4         varchar2(50 char),
    ctx_date1        date
  );
  
  type t_log_entries is table of t_log_entry;

  -----------------------------------------------------------------------------------------------
  -- Konfiguration
  -----------------------------------------------------------------------------------------------
  
  procedure enable_buffer(p_enabled in boolean default true);
  function is_buffer_enabled return boolean;
  procedure set_max_entries(p_max_entries in number);
  function get_max_entries return number;

  -----------------------------------------------------------------------------------------------
  -- Eintraege hinzufuegen
  -----------------------------------------------------------------------------------------------

  procedure add_entry(
    p_level      in number,
    p_category   in varchar2,
    p_module     in varchar2 default null,
    p_message    in varchar2,
    p_error_code in integer default null,
    p_ctx_id1    in integer default null,
    p_ctx_id2    in integer default null,
    p_ctx_str1   in varchar2 default null,
    p_ctx_str2   in varchar2 default null,
    p_ctx_str3   in varchar2 default null,
    p_ctx_str4   in varchar2 default null,
    p_ctx_date1  in date default null
  );

  -----------------------------------------------------------------------------------------------
  -- Eintraege abrufen (.NET Integration)
  -----------------------------------------------------------------------------------------------

  function get_entries(
    p_clear_buffer in boolean default true
  ) return t_log_entries pipelined;

  procedure get_entries_cursor(
    p_cursor       out sys_refcursor,
    p_clear_buffer in boolean default true
  );

  -----------------------------------------------------------------------------------------------
  -- Buffer-Verwaltung
  -----------------------------------------------------------------------------------------------

  procedure clear_buffer;
  function get_entry_count return number;

end;
/



-- sqlcl_snapshot {"hash":"060bc5c1f6ff886ac2b0e4a4bc6aff9371f03876","type":"PACKAGE_SPEC","name":"GLOBAL_P_SESSION_LOG","schemaName":"DIRKSPZM32","sxml":""}