create or replace 
package body DIRKSPZM32.GLOBAL_P_SESSION_LOG is
  -----------------------------------------------------------------------------------------------
  -- Package Body: global_p_session_log
  -----------------------------------------------------------------------------------------------

  g_buffer_enabled boolean := false;
  g_max_entries    number := 1000;
  g_seq            number := 0;

  type t_buffer_entry is record (
    log_id           number,
    log_timestamp    timestamp,
    log_level        number,
    log_category     varchar2(50 char),
    log_module       varchar2(100 char),
    log_message      varchar2(4000 char),
    log_error_code   integer,
    ctx_id1          integer,
    ctx_id2          integer,
    ctx_str1         varchar2(50 char),
    ctx_str2         varchar2(50 char),
    ctx_str3         varchar2(50 char),
    ctx_str4         varchar2(50 char),
    ctx_date1        date
  );
  
  type t_buffer is table of t_buffer_entry index by pls_integer;
  g_buffer t_buffer;

  -----------------------------------------------------------------------------------------------
  -- Konfiguration
  -----------------------------------------------------------------------------------------------

  procedure enable_buffer(p_enabled in boolean default true) is
  begin
    g_buffer_enabled := p_enabled;
    if not p_enabled then
      g_buffer.delete;
      g_seq := 0;
    end if;
  end;

  function is_buffer_enabled return boolean is
  begin
    return g_buffer_enabled;
  end;

  procedure set_max_entries(p_max_entries in number) is
  begin
    if p_max_entries > 0 then
      g_max_entries := p_max_entries;
    end if;
  end;

  function get_max_entries return number is
  begin
    return g_max_entries;
  end;

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
  ) is
    v_entry t_buffer_entry;
  begin
    if not g_buffer_enabled then
      return;
    end if;
    
    g_seq := g_seq + 1;
    
    v_entry.log_id := g_seq;
    v_entry.log_timestamp := systimestamp;
    v_entry.log_level := p_level;
    v_entry.log_category := substr(p_category, 1, 50);
    v_entry.log_module := substr(p_module, 1, 100);
    v_entry.log_message := substr(p_message, 1, 4000);
    v_entry.log_error_code := p_error_code;
    v_entry.ctx_id1 := p_ctx_id1;
    v_entry.ctx_id2 := p_ctx_id2;
    v_entry.ctx_str1 := substr(p_ctx_str1, 1, 50);
    v_entry.ctx_str2 := substr(p_ctx_str2, 1, 50);
    v_entry.ctx_str3 := substr(p_ctx_str3, 1, 50);
    v_entry.ctx_str4 := substr(p_ctx_str4, 1, 50);
    v_entry.ctx_date1 := p_ctx_date1;
    
    g_buffer(g_seq) := v_entry;
    
    while g_buffer.count > g_max_entries loop
      g_buffer.delete(g_buffer.first);
    end loop;
  end;

  -----------------------------------------------------------------------------------------------
  -- Eintraege abrufen
  -----------------------------------------------------------------------------------------------

  function get_entries(
    p_clear_buffer in boolean default true
  ) return t_log_entries pipelined is
    v_entry t_log_entry;
    v_idx   pls_integer;
  begin
    v_idx := g_buffer.first;
    
    while v_idx is not null loop
      v_entry.log_id := g_buffer(v_idx).log_id;
      v_entry.log_timestamp := g_buffer(v_idx).log_timestamp;
      v_entry.log_level := g_buffer(v_idx).log_level;
      v_entry.log_category := g_buffer(v_idx).log_category;
      v_entry.log_module := g_buffer(v_idx).log_module;
      v_entry.log_message := g_buffer(v_idx).log_message;
      v_entry.log_error_code := g_buffer(v_idx).log_error_code;
      v_entry.ctx_id1 := g_buffer(v_idx).ctx_id1;
      v_entry.ctx_id2 := g_buffer(v_idx).ctx_id2;
      v_entry.ctx_str1 := g_buffer(v_idx).ctx_str1;
      v_entry.ctx_str2 := g_buffer(v_idx).ctx_str2;
      v_entry.ctx_str3 := g_buffer(v_idx).ctx_str3;
      v_entry.ctx_str4 := g_buffer(v_idx).ctx_str4;
      v_entry.ctx_date1 := g_buffer(v_idx).ctx_date1;
      
      pipe row(v_entry);
      
      v_idx := g_buffer.next(v_idx);
    end loop;
    
    if p_clear_buffer then
      g_buffer.delete;
      g_seq := 0;
    end if;
    
    return;
  end;

  procedure get_entries_cursor(
    p_cursor       out sys_refcursor,
    p_clear_buffer in boolean default true
  ) is
  begin
    open p_cursor for
      select log_id, log_timestamp, log_level, log_category, log_module,
             log_message, log_error_code,
             ctx_id1, ctx_id2, ctx_str1, ctx_str2, ctx_str3, ctx_str4, ctx_date1
        from table(get_entries(p_clear_buffer));
  end;

  -----------------------------------------------------------------------------------------------
  -- Buffer-Verwaltung
  -----------------------------------------------------------------------------------------------

  procedure clear_buffer is
  begin
    g_buffer.delete;
    g_seq := 0;
  end;

  function get_entry_count return number is
  begin
    return g_buffer.count;
  end;

end;
/



-- sqlcl_snapshot {"hash":"8acc5784c647c8a7ce69c7e159c9b51eb4249e67","type":"PACKAGE_BODY","name":"GLOBAL_P_SESSION_LOG","schemaName":"DIRKSPZM32","sxml":""}