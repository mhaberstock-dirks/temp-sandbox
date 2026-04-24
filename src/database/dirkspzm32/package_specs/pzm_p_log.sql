create or replace package dirkspzm32.pzm_p_log is
  -----------------------------------------------------------------------------------------------
  -- Package: pzm_p_log
  -- Zweck:   Zentrales Logging fuer PZM-Module
  --
  -- Features:
  --   - Schreibt in dedizierte PZM_LOG Tabelle
  --   - Autonome Transaktionen (Log ueberlebt Rollback)
  --   - PZM-spezifischer Kontext (pers_nr, ze_id, schicht_tag, etc.)
  --   - Session-Buffer via global_p_session_log (fuer .NET Integration)
  --   - Retention-Management (Aufraeumlogik)
  --
  -- Abhaengigkeiten:
  --   - global_p_session_log
  --   - PZM_LOG Tabelle
  --   - SEQ_PZM_LOG_ID Sequenz
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Log-Level Konstanten
  -----------------------------------------------------------------------------------------------
    level_trace constant number := global_p_session_log.level_trace;
    level_debug constant number := global_p_session_log.level_debug;
    level_info constant number := global_p_session_log.level_info;
    level_warning constant number := global_p_session_log.level_warning;
    level_error constant number := global_p_session_log.level_error;
    level_fatal constant number := global_p_session_log.level_fatal;

  -----------------------------------------------------------------------------------------------
  -- Kategorie-Konstanten
  -----------------------------------------------------------------------------------------------
    cat_zeiterfassung constant varchar2(50 char) := 'Zeiterfassung';
    cat_terminal constant varchar2(50 char) := 'Terminal';
    cat_tagessatz constant varchar2(50 char) := 'Tagessatz';
    cat_lohnauswert constant varchar2(50 char) := 'Lohnauswertung';
    cat_system constant varchar2(50 char) := 'System';

  -----------------------------------------------------------------------------------------------
  -- Konfiguration
  -----------------------------------------------------------------------------------------------

    procedure set_log_level (
        p_level in number
    );

    function get_log_level return number;

  -----------------------------------------------------------------------------------------------
  -- Logging API (Einfach)
  -----------------------------------------------------------------------------------------------

    procedure trace (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    );

    procedure debug (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    );

    procedure info (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    );

    procedure warning (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    );

    procedure error (
        p_message    in varchar2,
        p_category   in varchar2 default cat_zeiterfassung,
        p_module     in varchar2 default null,
        p_error_code in integer default null
    );

    procedure fatal (
        p_message    in varchar2,
        p_category   in varchar2 default cat_zeiterfassung,
        p_module     in varchar2 default null,
        p_error_code in integer default null
    );

  -----------------------------------------------------------------------------------------------
  -- Logging API (Erweitert mit PZM-Kontext)
  -----------------------------------------------------------------------------------------------

    procedure log_data (
        p_level       in number,
        p_message     in varchar2,
        p_category    in varchar2 default cat_zeiterfassung,
        p_module      in varchar2 default null,
        p_error_code  in integer default null,
        p_stacktrace  in varchar2 default null,
    -- PZM-Kontext
        p_pers_nr     in integer default null,
        p_ze_rfid     in varchar2 default null,
        p_ze_id       in integer default null,
        p_schicht_tag in date default null,
        p_terminal_id in varchar2 default null,
        p_aktion      in varchar2 default null,
        p_quelle      in varchar2 default null
    );

  -----------------------------------------------------------------------------------------------
  -- Exception-Logging
  -----------------------------------------------------------------------------------------------

    function format_exception return varchar2;

    procedure log_exception (
        p_category    in varchar2 default cat_zeiterfassung,
        p_module      in varchar2 default null,
        p_context     in varchar2 default null,
        p_pers_nr     in integer default null,
        p_ze_id       in integer default null,
        p_schicht_tag in date default null
    );

  -----------------------------------------------------------------------------------------------
  -- Retention Management
  -----------------------------------------------------------------------------------------------

    procedure cleanup_old_logs (
        p_retention_days  in number default 30,
        p_batch_size      in number default 10000,
        p_max_runtime_sec in number default 300,
        p_deleted_count   out number,
        p_result_message  out varchar2
    );

    procedure get_log_statistics (
        p_total_count    out number,
        p_oldest_entry   out timestamp,
        p_newest_entry   out timestamp,
        p_size_mb        out number,
        p_count_by_level out sys_refcursor
    );

end;
/


-- sqlcl_snapshot {"hash":"57cef2328e6ca4b571a32e93cd7d8b399dfb8f9e","type":"PACKAGE_SPEC","name":"PZM_P_LOG","schemaName":"DIRKSPZM32","sxml":""}