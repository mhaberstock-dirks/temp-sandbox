create or replace package body dirkspzm32.pzm_p_log is
  -----------------------------------------------------------------------------------------------
  -- Package Body: pzm_p_log
  -----------------------------------------------------------------------------------------------

  -- Session-Variable fuer Tabellen-Persistierung Level
    g_table_log_level number := level_trace;

  -----------------------------------------------------------------------------------------------
  -- Private: In PZM_LOG Tabelle schreiben (autonome Transaktion)
  -----------------------------------------------------------------------------------------------
    procedure write_to_table (
        p_level       in number,
        p_message     in varchar2,
        p_category    in varchar2,
        p_module      in varchar2,
        p_error_code  in integer,
        p_stacktrace  in varchar2,
        p_pers_nr     in integer,
        p_ze_rfid     in varchar2,
        p_ze_id       in integer,
        p_schicht_tag in date,
        p_terminal_id in varchar2,
        p_aktion      in varchar2,
        p_quelle      in varchar2
    ) is
        pragma autonomous_transaction;
    begin
        insert into pzm_log (
            log_id,
            log_timestamp,
            log_level,
            log_category,
            log_module,
            log_message,
            log_error_code,
            log_stacktrace,
            pers_nr,
            ze_rfid,
            ze_id,
            schicht_tag,
            terminal_id,
            aktion,
            quelle,
            os_user,
            client_host,
            client_info,
            client_identifier
        ) values ( seq_pzm_log_id.nextval,
                   systimestamp,
                   p_level,
                   substr(p_category, 1, 50),
                   substr(p_module, 1, 100),
                   substr(p_message, 1, 4000),
                   p_error_code,
                   substr(p_stacktrace, 1, 4000),
                   p_pers_nr,
                   substr(p_ze_rfid, 1, 50),
                   p_ze_id,
                   p_schicht_tag,
                   substr(p_terminal_id, 1, 50),
                   substr(p_aktion, 1, 50),
                   substr(p_quelle, 1, 50),
                   sys_context('USERENV', 'OS_USER'),
                   sys_context('USERENV', 'TERMINAL'),
                   sys_context('USERENV', 'CLIENT_INFO'),
                   sys_context('USERENV', 'CLIENT_IDENTIFIER') );

        commit;
    exception
        when others then
      -- Logging darf nie die Haupttransaktion stoeren
            rollback;
    end;

  -----------------------------------------------------------------------------------------------
  -- Private: In Session-Buffer schreiben (via global_p_session_log)
  -----------------------------------------------------------------------------------------------
    procedure write_to_buffer (
        p_level       in number,
        p_message     in varchar2,
        p_category    in varchar2,
        p_module      in varchar2,
        p_error_code  in integer,
        p_pers_nr     in integer,
        p_ze_rfid     in varchar2,
        p_ze_id       in integer,
        p_schicht_tag in date,
        p_terminal_id in varchar2,
        p_aktion      in varchar2,
        p_quelle      in varchar2
    ) is
    begin
    -- Mapping PZM-Kontext auf generische Felder:
    --   ctx_id1   = pers_nr
    --   ctx_id2   = ze_id
    --   ctx_text1 = ze_rfid
    --   ctx_text2 = terminal_id
    --   ctx_text3 = aktion
    --   ctx_text4 = quelle
    --   ctx_date1 = schicht_tag
        global_p_session_log.add_entry(
            p_level      => p_level,
            p_category   => p_category,
            p_module     => p_module,
            p_message    => p_message,
            p_error_code => p_error_code,
            p_ctx_id1    => p_pers_nr,
            p_ctx_id2    => p_ze_id,
            p_ctx_str1   => p_ze_rfid,
            p_ctx_str2   => p_terminal_id,
            p_ctx_str3   => p_aktion,
            p_ctx_str4   => p_quelle,
            p_ctx_date1  => p_schicht_tag
        );
    end;

  -----------------------------------------------------------------------------------------------
  -- Konfiguration
  -----------------------------------------------------------------------------------------------

    procedure set_log_level (
        p_level in number
    ) is
    begin
        g_table_log_level := p_level;
    end;

    function get_log_level return number is
    begin
        return g_table_log_level;
    end;

  -----------------------------------------------------------------------------------------------
  -- Zentrale Log-Funktion
  -----------------------------------------------------------------------------------------------

    procedure log_data (
        p_level       in number,
        p_message     in varchar2,
        p_category    in varchar2 default cat_zeiterfassung,
        p_module      in varchar2 default null,
        p_error_code  in integer default null,
        p_stacktrace  in varchar2 default null,
        p_pers_nr     in integer default null,
        p_ze_rfid     in varchar2 default null,
        p_ze_id       in integer default null,
        p_schicht_tag in date default null,
        p_terminal_id in varchar2 default null,
        p_aktion      in varchar2 default null,
        p_quelle      in varchar2 default null
    ) is
    begin
    -- In Tabelle schreiben (wenn Level erreicht)
        if p_level >= g_table_log_level then
            write_to_table(p_level, p_message, p_category, p_module, p_error_code,
                           p_stacktrace, p_pers_nr, p_ze_rfid, p_ze_id, p_schicht_tag,
                           p_terminal_id, p_aktion, p_quelle);
        end if;

    -- In Session-Buffer schreiben (Level-Filterung erfolgt in global_p_session_log)
        write_to_buffer(p_level, p_message, p_category, p_module, p_error_code,
                        p_pers_nr, p_ze_rfid, p_ze_id, p_schicht_tag, p_terminal_id,
                        p_aktion, p_quelle);

    end;

  -----------------------------------------------------------------------------------------------
  -- Convenience-Funktionen
  -----------------------------------------------------------------------------------------------

    procedure trace (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    ) is
    begin
        log_data(
            p_level    => level_trace,
            p_message  => p_message,
            p_category => p_category,
            p_module   => p_module
        );
    end;

    procedure debug (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    ) is
    begin
        log_data(level_debug, p_message, p_category, p_module);
    end;

    procedure info (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    ) is
    begin
        log_data(level_info, p_message, p_category, p_module);
    end;

    procedure warning (
        p_message  in varchar2,
        p_category in varchar2 default cat_zeiterfassung,
        p_module   in varchar2 default null
    ) is
    begin
        log_data(level_warning, p_message, p_category, p_module);
    end;

    procedure error (
        p_message    in varchar2,
        p_category   in varchar2 default cat_zeiterfassung,
        p_module     in varchar2 default null,
        p_error_code in integer default null
    ) is
    begin
        log_data(level_error, p_message, p_category, p_module, p_error_code);
    end;

    procedure fatal (
        p_message    in varchar2,
        p_category   in varchar2 default cat_zeiterfassung,
        p_module     in varchar2 default null,
        p_error_code in integer default null
    ) is
    begin
        log_data(level_fatal, p_message, p_category, p_module, p_error_code);
    end;

  -----------------------------------------------------------------------------------------------
  -- Exception-Logging
  -----------------------------------------------------------------------------------------------

    function format_exception return varchar2 is
    begin
        return 'ORA'
               || sqlcode
               || ': '
               || sqlerrm;
    end;

    procedure log_exception (
        p_category    in varchar2 default cat_zeiterfassung,
        p_module      in varchar2 default null,
        p_context     in varchar2 default null,
        p_pers_nr     in integer default null,
        p_ze_id       in integer default null,
        p_schicht_tag in date default null
    ) is
        v_message    varchar2(4000 char);
        v_stacktrace varchar2(4000 char);
    begin
        v_message := format_exception;
        if p_context is not null then
            v_message := p_context
                         || ' - '
                         || v_message;
        end if;

        v_stacktrace := dbms_utility.format_error_backtrace;
        log_data(
            p_level       => level_error,
            p_message     => v_message,
            p_category    => p_category,
            p_module      => p_module,
            p_error_code  => sqlcode,
            p_stacktrace  => v_stacktrace,
            p_pers_nr     => p_pers_nr,
            p_ze_id       => p_ze_id,
            p_schicht_tag => p_schicht_tag
        );

    end;

  -----------------------------------------------------------------------------------------------
  -- Retention Management
  -----------------------------------------------------------------------------------------------

    procedure cleanup_old_logs (
        p_retention_days  in number default 30,
        p_batch_size      in number default 10000,
        p_max_runtime_sec in number default 300,
        p_deleted_count   out number,
        p_result_message  out varchar2
    ) is

        v_cutoff_date     timestamp;
        v_start_time      timestamp;
        v_elapsed_seconds number;
        v_batch_deleted   number;
        v_total_deleted   number := 0;
        v_iterations      number := 0;
        v_max_iterations  number := 1000;
    begin
    -- Validierung
        if p_retention_days < 1 then
            p_deleted_count := 0;
            p_result_message := 'FEHLER: retention_days muss mindestens 1 sein';
            return;
        end if;

        v_cutoff_date := systimestamp - p_retention_days;
        v_start_time := systimestamp;

    -- Log Start
        info('Cleanup gestartet: retention_days='
             || p_retention_days
             || ', cutoff='
             || to_char(v_cutoff_date, 'DD.MM.YYYY HH24:MI:SS')
             || ', batch_size='
             || p_batch_size,
             cat_system,
             'cleanup_old_logs');

    -- Batch-weise loeschen
        loop
            v_iterations := v_iterations + 1;

      -- Sicherheitslimit
            if v_iterations > v_max_iterations then
                p_result_message := 'ABBRUCH: Max. Iterationen erreicht ('
                                    || v_max_iterations
                                    || ')';
                exit;
            end if;

      -- Laufzeit pruefen
            v_elapsed_seconds := extract(second from ( systimestamp - v_start_time )) + extract(minute from ( systimestamp - v_start_time
            )) * 60 + extract(hour from ( systimestamp - v_start_time )) * 3600;

            if v_elapsed_seconds >= p_max_runtime_sec then
                p_result_message := 'TIMEOUT: Max. Laufzeit erreicht ('
                                    || p_max_runtime_sec
                                    || 's)';
                exit;
            end if;

      -- Batch loeschen
            delete from pzm_log
            where
                    log_timestamp < v_cutoff_date
                and rownum <= p_batch_size;

            v_batch_deleted := sql%rowcount;
            v_total_deleted := v_total_deleted + v_batch_deleted;
            commit;

      -- Fertig wenn keine Zeilen mehr
            if v_batch_deleted = 0 then
                p_result_message := 'OK: Cleanup abgeschlossen';
                exit;
            end if;

      -- Kurze Pause zwischen Batches
      --if v_batch_deleted = p_batch_size then
      --  dbms_lock.sleep(0.1);
      --end if;
        end loop;

        p_deleted_count := v_total_deleted;

    -- Abschliessendes Log
        v_elapsed_seconds := extract(second from ( systimestamp - v_start_time )) + extract(minute from ( systimestamp - v_start_time
        )) * 60 + extract(hour from ( systimestamp - v_start_time )) * 3600;

        info('Cleanup beendet: '
             || v_total_deleted
             || ' Eintraege geloescht'
             || ', Dauer='
             || round(v_elapsed_seconds, 1)
             || 's'
             || ', Iterationen='
             || v_iterations
             || ', Status='
             || p_result_message,
             cat_system,
             'cleanup_old_logs');

    exception
        when others then
            p_deleted_count := v_total_deleted;
            p_result_message := 'FEHLER: ' || sqlerrm;
            error('Cleanup fehlgeschlagen: ' || sqlerrm, cat_system, 'cleanup_old_logs');
    end;

  -----------------------------------------------------------------------------------------------
  -- Statistiken
  -----------------------------------------------------------------------------------------------

    procedure get_log_statistics (
        p_total_count    out number,
        p_oldest_entry   out timestamp,
        p_newest_entry   out timestamp,
        p_size_mb        out number,
        p_count_by_level out sys_refcursor
    ) is
    begin
    -- Gesamtanzahl und Zeitraum
        select
            count(*),
            min(log_timestamp),
            max(log_timestamp)
        into
            p_total_count,
            p_oldest_entry,
            p_newest_entry
        from
            pzm_log;

    -- Groesse (ungefaehr)
        begin
            select
                bytes / 1024 / 1024
            into p_size_mb
            from
                user_segments
            where
                    segment_name = 'PZM_LOG'
                and segment_type = 'TABLE';

        exception
            when no_data_found then
                p_size_mb := 0;
        end;

    -- Anzahl pro Level
        open p_count_by_level for select
                                                              log_level,
                                                              case log_level
                                                                  when 0 then
                                                                      'TRACE'
                                                                  when 1 then
                                                                      'DEBUG'
                                                                  when 2 then
                                                                      'INFO'
                                                                  when 3 then
                                                                      'WARNING'
                                                                  when 4 then
                                                                      'ERROR'
                                                                  when 5 then
                                                                      'FATAL'
                                                                  else
                                                                      'UNKNOWN'
                                                              end      as level_name,
                                                              count(*) as entry_count
                                                          from
                                                              pzm_log
                                 group by
                                     log_level
                                 order by
                                     log_level desc;

    end;

end;
/


-- sqlcl_snapshot {"hash":"b280d25f85bb87ce88bde1760f5a2da0af0418aa","type":"PACKAGE_BODY","name":"PZM_P_LOG","schemaName":"DIRKSPZM32","sxml":""}