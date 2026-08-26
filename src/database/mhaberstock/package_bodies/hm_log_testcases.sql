create or replace
package body MHABERSTOCK.HM_LOG_TESTCASES as

  g_pass_count pls_integer := 0;
  g_fail_count pls_integer := 0;

  -----------------------------------------------------------------------------------------------
  -- Private: Ausgabe/Protokoll eines einzelnen Testergebnisses
  -----------------------------------------------------------------------------------------------
  procedure report(
    p_test_name in varchar2,
    p_passed    in boolean,
    p_details   in varchar2 default null
  ) is
  begin
    if p_passed then
      g_pass_count := g_pass_count + 1;
    else
      g_fail_count := g_fail_count + 1;
    end if;

    dbms_output.put_line(
      '[' || case when p_passed then 'PASS' else 'FAIL' end || '] ' ||
      rpad(p_test_name, 55) || ' ' || nvl(p_details, '')
    );
  end report;

  -----------------------------------------------------------------------------------------------
  -- Private: autonome Hilfsprozedur OHNE abschliessenden COMMIT/ROLLBACK
  -----------------------------------------------------------------------------------------------
  procedure at_no_commit_helper(p_marker in varchar2) is
    pragma autonomous_transaction;
  begin
    insert into hm_at_test_log (
      caller_level, event_text, session_id, is_autonomous
    ) values (
      'AT_NO_COMMIT', p_marker, sys_context('USERENV', 'SID'), 'Y'
    );
    -- Bewusst KEIN COMMIT / ROLLBACK: Oracle bricht beim Verlassen mit ORA-06519 ab.
  end at_no_commit_helper;

  -----------------------------------------------------------------------------------------------
  -- Private: autonome Hilfsprozedur, die eine bereits (von der Haupttransaktion) gesperrte
  -- Zeile aendern will
  -----------------------------------------------------------------------------------------------
  procedure at_update_locked_row_helper(p_log_id in number) is
    pragma autonomous_transaction;
    c_module_name  constant varchar2(50) := dirkspzm32.current_unit_name();
    v_rows_updated pls_integer;
  begin
    update hm_at_test_log
       set event_text   = event_text || '_UPDATED_BY_AT',
           is_committed  = 'Y'
     where log_id = p_log_id;

    v_rows_updated := sql%rowcount;
    commit;

    if v_rows_updated = 0 then
      dbms_output.put_line('at_update_locked_row_helper: WARNUNG - 0 Zeilen fuer log_id=' || p_log_id ||
                            ' aktualisiert (Zeile fuer diese Transaktion nicht sichtbar/nicht vorhanden)');
    end if;
  exception
    when others then
      rollback;
      -- Kein Aufruf von raise_app_error* hier (echter ORA-00060 aus einem UPDATE) - deshalb
      -- direkt log_exception() ohne is_app_code()-Guard, es kann kein Doppel-Log entstehen.
      dirkspzm32.pzm_p_log.log_exception(
        p_category => dirkspzm32.pzm_p_log.CAT_SYSTEM,
        p_module   => c_module_name,
        p_context  => 'UPDATE hm_at_test_log SET event_text=..., is_committed=''Y'' WHERE log_id=' || p_log_id ||
                      ' (Zeile durch Haupttransaktion gesperrt)'
      );
      raise;
  end at_update_locked_row_helper;

  -----------------------------------------------------------------------------------------------
  -- Private: bildet das AKTUELLE Handler-Muster aus PZM_P_ZEITERFASSUNG nach:
  --   PRAGMA AUTONOMOUS_TRANSACTION ... EXCEPTION WHEN OTHERS THEN
  --     IF NOT dirkspzm32.pzm_p_lc.is_app_code(sqlcode) THEN dirkspzm32.pzm_p_log.log_exception(...); END IF;
  --     RAISE;
  -- Kein Wrapping mehr (PZM_P_LC.catch_and_rethrow() wurde entfernt) - der Aufrufer sieht immer
  -- den unveraenderten Original-Fehler.
  -- p_mode steuert, welcher Fehler ausgeloest wird:
  --   APP_ERROR      - ein PZM-Anwendungsfehler ueber raise_app_error() (-20xxx, protokolliert
  --                    sich bereits selbst)
  --   SYSTEM_ERROR   - ein echter Oracle-Systemfehler (ORA-01476)
  --   MISSING_COMMIT - eine verschachtelte AT (at_no_commit_helper) vergisst COMMIT/ROLLBACK
  --   SELF_DEADLOCK  - eine verschachtelte AT (at_update_locked_row_helper) kollidiert mit der
  --                    von der Haupttransaktion gehaltenen Sperre auf p_log_id
  -----------------------------------------------------------------------------------------------
  procedure at_handler_pattern_helper(
    p_mode   in varchar2,
    p_marker in varchar2,
    p_log_id in number default null
  ) is
    pragma autonomous_transaction;
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
    v_dummy number;
  begin
    if p_mode = 'APP_ERROR' then
      dirkspzm32.pzm_p_lc.raise_app_error(dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid, p_marker);
    elsif p_mode = 'SYSTEM_ERROR' then
      v_dummy := 1 / 0; -- ORA-01476: divisor is equal to zero
    elsif p_mode = 'MISSING_COMMIT' then
      at_no_commit_helper(p_marker);
    elsif p_mode = 'SELF_DEADLOCK' then
      at_update_locked_row_helper(p_log_id);
    end if;

    commit;
  exception
    when others then
      if not dirkspzm32.pzm_p_lc.is_app_code(sqlcode) then
        dirkspzm32.pzm_p_log.log_exception(
          p_category => dirkspzm32.pzm_p_log.CAT_ZEITERFASSUNG,
          p_module   => c_module_name,
          p_context  => p_marker
        );
      end if;
      raise;
  end at_handler_pattern_helper;

  -----------------------------------------------------------------------------------------------
  -- Private: rekursive Hilfsprozedur, die erst nach p_depth Ebenen einen ECHTEN Systemfehler
  -- (ORA-01476, kein PZM-Code) wirft - damit der Handler-Guard log_exception() tatsaechlich
  -- aufruft und der Backtrace-Ueberlauf-Bug (siehe PZM_P_LOG) reproduzierbar bleibt. Erzeugt
  -- dadurch einen entsprechend langen dbms_utility.format_error_backtrace()-String (ein Eintrag
  -- pro Rekursionsebene).
  -----------------------------------------------------------------------------------------------
  procedure recurse_and_fail(p_depth in pls_integer) is
    v_dummy number;
  begin
    if p_depth <= 0 then
      v_dummy := 1 / 0; -- ORA-01476
    else
      recurse_and_fail(p_depth - 1);
    end if;
  end recurse_and_fail;

  -----------------------------------------------------------------------------------------------
  -- Private: Handler-Muster wie at_handler_pattern_helper, aber mit einem Fehler aus tiefer
  -- Rekursion (fuer den Backtrace-Ueberlauf-Test).
  -----------------------------------------------------------------------------------------------
  procedure at_handler_pattern_deep_helper(p_marker in varchar2, p_depth in pls_integer) is
    pragma autonomous_transaction;
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
  begin
    recurse_and_fail(p_depth);
    commit;
  exception
    when others then
      if not dirkspzm32.pzm_p_lc.is_app_code(sqlcode) then
        dirkspzm32.pzm_p_log.log_exception(
          p_category => dirkspzm32.pzm_p_log.CAT_ZEITERFASSUNG,
          p_module   => c_module_name,
          p_context  => p_marker
        );
      end if;
      raise;
  end at_handler_pattern_deep_helper;

  -----------------------------------------------------------------------------------------------
  -- Private: Handler-Muster, das ZUSAETZLICH manuell vollen PZM-Kontext protokolliert, da
  -- raise_app_error()/raise_app_error_p() aktuell keine pers_nr/ze_id/schicht_tag kennen. Dieser
  -- Zusatz-Log-Aufruf ist bewusst NICHT durch is_app_code() geschuetzt, da er zusaetzliche,
  -- nicht-redundante Information (den PZM-Kontext) traegt statt den Fehler nur zu wiederholen.
  -----------------------------------------------------------------------------------------------
  procedure at_handler_pattern_full_ctx_helper(
    p_marker      in varchar2,
    p_pers_nr     in number,
    p_ze_id       in number,
    p_schicht_tag in date
  ) is
    pragma autonomous_transaction;
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
  begin
    dirkspzm32.pzm_p_lc.raise_app_error(dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid, p_marker);
    commit;
  exception
    when others then
      dirkspzm32.pzm_p_log.log_exception(
        p_category    => dirkspzm32.pzm_p_log.CAT_ZEITERFASSUNG,
        p_module      => c_module_name,
        p_context     => p_marker,
        p_pers_nr     => p_pers_nr,
        p_ze_id       => p_ze_id,
        p_schicht_tag => p_schicht_tag
      );
      raise;
  end at_handler_pattern_full_ctx_helper;

  -----------------------------------------------------------------------------------------------
  -- Test: fehlender COMMIT in einer autonomen Transaktion
  -----------------------------------------------------------------------------------------------
  procedure test_at_missing_commit is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
    v_marker   varchar2(50) := 'HMTC_NOCOMMIT_' || to_char(systimestamp, 'HH24MISSFF3');
    v_caught   boolean := false;
    v_sqlcode  pls_integer;
    v_cnt      pls_integer;
  begin
    begin
      at_no_commit_helper(v_marker);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
        -- ORA-06519 entsteht erst BEIM RUECKSPRUNG aus at_no_commit_helper - nur der Aufrufer
        -- (hier) kann das protokollieren.
        dirkspzm32.pzm_p_log.log_exception(
          p_category => dirkspzm32.pzm_p_log.CAT_SYSTEM,
          p_module   => c_module_name,
          p_context  => 'Ruecksprung aus at_no_commit_helper(p_marker=' || v_marker ||
                        ') ohne COMMIT/ROLLBACK der autonomen Transaktion'
        );
    end;

    if not v_caught or v_sqlcode != -6519 then
      report('test_at_missing_commit', false,
        'Erwartete ORA-06519, erhalten: SQLCODE=' || nvl(to_char(v_sqlcode), 'keine Exception'));
      return;
    end if;

    -- Oracle rollt die autonome Transaktion beim Abbruch selbst zurueck: die Zeile darf nicht existieren.
    select count(*) into v_cnt from hm_at_test_log where event_text = v_marker;

    if v_cnt = 0 then
      report('test_at_missing_commit', true,
        'ORA-06519 wie erwartet, INSERT wurde von Oracle automatisch zurueckgerollt');
    else
      report('test_at_missing_commit', false,
        'ORA-06519 kam, aber die Zeile ist trotzdem sichtbar (unerwartet)');
    end if;
  end test_at_missing_commit;

  -----------------------------------------------------------------------------------------------
  -- Test: autonome Transaktion aendert eine von der Haupttransaktion gesperrte Zeile (Self-Deadlock)
  -----------------------------------------------------------------------------------------------
  procedure test_at_self_deadlock_on_locked_row is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
    v_marker   varchar2(50) := 'HMTC_DEADLOCK_' || to_char(systimestamp, 'HH24MISSFF3');
    v_log_id   number;
    v_caught   boolean := false;
    v_sqlcode  pls_integer;
  begin
    -- Zeile muss erst COMMITTET werden, bevor sie gesperrt wird - ein bloss eingefuegter, noch
    -- nicht committeter Datensatz ist fuer JEDE andere Transaktion (auch fuer eine autonome
    -- Transaktion derselben Session) unsichtbar.
    insert into hm_at_test_log (
      caller_level, event_text, session_id, is_autonomous
    ) values (
      'MAIN_LOCK', v_marker, sys_context('USERENV', 'SID'), 'N'
    ) returning log_id into v_log_id;
    commit;

    update hm_at_test_log
       set event_text = event_text || '_LOCKED_BY_MAIN'
     where log_id = v_log_id;

    begin
      at_update_locked_row_helper(v_log_id);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
        dirkspzm32.pzm_p_log.log_exception(
          p_category => dirkspzm32.pzm_p_log.CAT_SYSTEM,
          p_module   => c_module_name,
          p_context  => 'Exception aus at_update_locked_row_helper(log_id=' || v_log_id ||
                        ') erhalten, Marker=' || v_marker
        );
    end;

    -- HM_AT_TEST_LOG ist eine reine Testtabelle - kein ROLLBACK, damit die tatsaechlich
    -- geschriebenen Daten fuer die Auswertung sichtbar bleiben.
    commit;

    if v_caught and v_sqlcode = -60 then
      report('test_at_self_deadlock_on_locked_row', true,
        'ORA-00060 (Deadlock) wie erwartet, log_id=' || v_log_id);
    else
      report('test_at_self_deadlock_on_locked_row', false,
        'Erwartete ORA-00060, erhalten: SQLCODE=' || nvl(to_char(v_sqlcode), 'keine Exception'));
    end if;
  end test_at_self_deadlock_on_locked_row;

  -----------------------------------------------------------------------------------------------
  -- Test: PZM_P_LOG verschluckt Schreibfehler in der autonomen Log-Transaktion
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_log_swallows_write_error is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
    v_marker      varchar2(200) := 'HMTC_SWALLOW_' || to_char(systimestamp, 'HH24MISSFF3');
    v_cnt_before  number;
    v_cnt_after   number;
    v_raised      boolean := false;
  begin
    select count(*) into v_cnt_before from dirkspzm32.pzm_log where log_message = v_marker;

    begin
      lock table dirkspzm32.pzm_log in exclusive mode;
      dirkspzm32.pzm_p_log.error(v_marker, dirkspzm32.pzm_p_log.CAT_SYSTEM, c_module_name);
    exception
      when others then
        v_raised := true;
    end;

    commit; -- Tabellensperre wieder freigeben (kein Datenverlust, es wurde nichts geschrieben)

    select count(*) into v_cnt_after from dirkspzm32.pzm_log where log_message = v_marker;

    if not v_raised and v_cnt_after = v_cnt_before then
      report('test_pzm_log_swallows_write_error', true,
        'PZM_P_LOG.error() hat keine Exception geworfen - der Log-Eintrag ist dabei aber verloren gegangen (stiller Datenverlust)');
    elsif v_raised then
      report('test_pzm_log_swallows_write_error', false,
        'Unerwartete Exception aus PZM_P_LOG.error() - der Fehler wurde NICHT wie im Code vorgesehen abgefangen');
    else
      report('test_pzm_log_swallows_write_error', false,
        'Log-Eintrag wurde trotz Tabellensperre geschrieben (unerwartet)');
    end if;
  end test_pzm_log_swallows_write_error;

  -----------------------------------------------------------------------------------------------
  -- Test: PZM_P_LC.is_app_code
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_is_app_code is
  begin
    if dirkspzm32.pzm_p_lc.is_app_code(-20000)
       and dirkspzm32.pzm_p_lc.is_app_code(-20999)
       and dirkspzm32.pzm_p_lc.is_app_code(-20035)
       and not dirkspzm32.pzm_p_lc.is_app_code(-19999)
       and not dirkspzm32.pzm_p_lc.is_app_code(-21000)
       and not dirkspzm32.pzm_p_lc.is_app_code(-1476)
       and not dirkspzm32.pzm_p_lc.is_app_code(100)
       and not dirkspzm32.pzm_p_lc.is_app_code(0)
    then
      report('test_pzm_lc_is_app_code', true,
        'Grenzwerte (-20000/-20999) korrekt als PZM-Code erkannt, Gegenbeispiele (-19999/-21000/-1476/100/0) korrekt ausgeschlossen');
    else
      report('test_pzm_lc_is_app_code', false, 'Mindestens ein Grenzfall falsch klassifiziert');
    end if;
  end test_pzm_lc_is_app_code;

  -----------------------------------------------------------------------------------------------
  -- Test: raise_app_error() protokolliert automatisch VOR dem Werfen
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_raise_app_error_logs_automatically is
    v_marker         varchar2(200) := 'HMTC_AUTOLOG_MSG_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode        pls_integer;
    v_sqlerrm        varchar2(4000 char);
    v_log_cnt        pls_integer;
    v_log_level      number;
    v_log_error_code number;
    v_log_stacktrace varchar2(4000 char);
  begin
    begin
      dirkspzm32.pzm_p_lc.raise_app_error(dirkspzm32.pzm_p_lc.cerr_pzm_pers_nr_404, v_marker);
    exception
      when others then
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    -- raise_app_error() ohne Token: log_message = Originaltext exakt (keine Formatierung).
    select count(*), max(log_level), max(log_error_code), max(log_stacktrace)
      into v_log_cnt, v_log_level, v_log_error_code, v_log_stacktrace
      from dirkspzm32.pzm_log
     where log_message = v_marker;

    if v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_pers_nr_404
       and instr(v_sqlerrm, v_marker) > 0
       and v_log_cnt = 1
       and v_log_level = dirkspzm32.pzm_p_log.LEVEL_ERROR
       and v_log_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_pers_nr_404
       and v_log_stacktrace is not null
       and instr(upper(v_log_stacktrace), 'HM_LOG_TESTCASES') > 0
    then
      report('test_pzm_lc_raise_app_error_logs_automatically', true,
        'raise_app_error() hat VOR dem Werfen selbststaendig einen vollstaendigen PZM_LOG-Eintrag ' ||
        '(Level=ERROR, error_code=' || v_log_error_code || ', Call-Stack vorhanden) erzeugt');
    else
      report('test_pzm_lc_raise_app_error_logs_automatically', false,
        'sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_level=' || v_log_level ||
        ' log_error_code=' || v_log_error_code);
    end if;
  end test_pzm_lc_raise_app_error_logs_automatically;

  -----------------------------------------------------------------------------------------------
  -- Test: raise_app_error_p() mit 1 Parameter protokolliert automatisch
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_raise_app_error_p1_logs_automatically is
    v_marker         varchar2(200) := 'HMTC_AUTOLOG_P1_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode        pls_integer;
    v_sqlerrm        varchar2(4000 char);
    v_log_cnt        pls_integer;
    v_log_error_code number;
    v_log_message    varchar2(4000 char);
  begin
    begin
      dirkspzm32.pzm_p_lc.raise_app_error_p(
        dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404,
        dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404,
        v_marker
      );
    exception
      when others then
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    select count(*), max(log_error_code), max(log_message)
      into v_log_cnt, v_log_error_code, v_log_message
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
       and instr(v_sqlerrm, dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404) > 0
       and instr(v_sqlerrm, '[' || v_marker || ']') > 0
       and v_log_cnt = 1
       and v_log_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
       and instr(v_log_message, dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404 || '@[' || v_marker || ']') > 0
    then
      report('test_pzm_lc_raise_app_error_p1_logs_automatically', true,
        'raise_app_error_p() mit 1 Parameter hat automatisch das TOKEN@[p1]-Format korrekt protokolliert: ' || v_log_message);
    else
      report('test_pzm_lc_raise_app_error_p1_logs_automatically', false,
        'sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_message=' || v_log_message);
    end if;
  end test_pzm_lc_raise_app_error_p1_logs_automatically;

  -----------------------------------------------------------------------------------------------
  -- Test: raise_app_error_p() mit 2 Parametern protokolliert automatisch
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_raise_app_error_p2_logs_automatically is
    v_marker         varchar2(200) := 'HMTC_AUTOLOG_P2_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode        pls_integer;
    v_sqlerrm        varchar2(4000 char);
    v_log_cnt        pls_integer;
    v_log_error_code number;
    v_log_message    varchar2(4000 char);
  begin
    begin
      dirkspzm32.pzm_p_lc.raise_app_error_p(
        dirkspzm32.pzm_p_lc.cerr_pzm_ze_status_mismatch,
        dirkspzm32.pzm_p_lc.O_TP2_PZM_ERROR_ZE_STATUS_MISMATCH,
        v_marker,
        'AKTION_TEST'
      );
    exception
      when others then
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    select count(*), max(log_error_code), max(log_message)
      into v_log_cnt, v_log_error_code, v_log_message
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_ze_status_mismatch
       and instr(v_sqlerrm, '[' || v_marker || '|AKTION_TEST]') > 0
       and v_log_cnt = 1
       and v_log_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_ze_status_mismatch
       and instr(v_log_message, '[' || v_marker || '|AKTION_TEST]') > 0
    then
      report('test_pzm_lc_raise_app_error_p2_logs_automatically', true,
        'raise_app_error_p() mit 2 Parametern hat automatisch das TOKEN@[p1|p2]-Format korrekt protokolliert: ' || v_log_message);
    else
      report('test_pzm_lc_raise_app_error_p2_logs_automatically', false,
        'sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_message=' || v_log_message);
    end if;
  end test_pzm_lc_raise_app_error_p2_logs_automatically;

  -----------------------------------------------------------------------------------------------
  -- Test: raise_app_error_p() mit PZM_P_LC.T_PARAMLIST protokolliert automatisch
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_raise_app_error_plist_logs_automatically is
    v_marker         varchar2(200) := 'HMTC_AUTOLOG_PLIST_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode        pls_integer;
    v_sqlerrm        varchar2(4000 char);
    v_log_cnt        pls_integer;
    v_log_error_code number;
    v_log_message    varchar2(4000 char);
  begin
    begin
      dirkspzm32.pzm_p_lc.raise_app_error_p(
        dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404,
        dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404,
        dirkspzm32.pzm_p_lc.t_paramlist(v_marker, 'p2_wert', 'p3_wert')
      );
    exception
      when others then
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    select count(*), max(log_error_code), max(log_message)
      into v_log_cnt, v_log_error_code, v_log_message
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
       and instr(v_sqlerrm, '[' || v_marker || '|p2_wert|p3_wert]') > 0
       and v_log_cnt = 1
       and v_log_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
       and instr(v_log_message, '[' || v_marker || '|p2_wert|p3_wert]') > 0
    then
      report('test_pzm_lc_raise_app_error_plist_logs_automatically', true,
        'raise_app_error_p() mit T_PARAMLIST (3 Werte) hat automatisch korrekt protokolliert: ' || v_log_message);
    else
      report('test_pzm_lc_raise_app_error_plist_logs_automatically', false,
        'sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_message=' || v_log_message);
    end if;
  end test_pzm_lc_raise_app_error_plist_logs_automatically;

  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_assert_condition_true_no_op is
    v_marker       varchar2(200) := 'HMTC_ASSERT_TRUE_' || to_char(systimestamp, 'HH24MISSFF3');
    v_no_exception boolean := false;
    v_log_cnt      pls_integer;
  begin
    begin
      dirkspzm32.pzm_p_lc.assert(
          in_condition => 1 = 1
        , in_code      => dirkspzm32.pzm_p_lc.cerr_pzm_buchung
        , in_message   => v_marker
      );
      v_no_exception := true;
    exception
      when others then
        v_no_exception := false;
    end;

    select count(*)
      into v_log_cnt
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_no_exception and v_log_cnt = 0 then
      report('test_pzm_lc_assert_condition_true_no_op', true,
        'assert() mit erfuellter Bedingung wirft keine Exception und schreibt keinen PZM_LOG-Eintrag.');
    else
      report('test_pzm_lc_assert_condition_true_no_op', false,
        'no_exception=' || case when v_no_exception then 'Y' else 'N' end || ' log_cnt=' || v_log_cnt);
    end if;
  end test_pzm_lc_assert_condition_true_no_op;

  -----------------------------------------------------------------------------------------------
  procedure test_pzm_lc_assert_condition_false_raises_and_logs is
    v_marker         varchar2(200) := 'HMTC_ASSERT_FALSE_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode        pls_integer;
    v_sqlerrm        varchar2(4000 char);
    v_log_cnt        pls_integer;
    v_log_error_code number;
    v_log_message    varchar2(4000 char);
  begin
    begin
      dirkspzm32.pzm_p_lc.assert(
          in_condition  => 1 = 2
        , in_code       => dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
        , in_const_name => dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404
        , in_p1         => v_marker
      );
    exception
      when others then
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    select count(*), max(log_error_code), max(log_message)
      into v_log_cnt, v_log_error_code, v_log_message
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
       and instr(v_sqlerrm, dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404) > 0
       and instr(v_sqlerrm, '[' || v_marker || ']') > 0
       and v_log_cnt = 1
       and v_log_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_abt_id_404
       and instr(v_log_message, dirkspzm32.pzm_p_lc.O_TP1_PZM_ERROR_ABT_ID_404 || '@[' || v_marker || ']') > 0
    then
      report('test_pzm_lc_assert_condition_false_raises_and_logs', true,
        'assert() mit verletzter Bedingung wirft ueber raise_app_error_p() und protokolliert automatisch: ' || v_log_message);
    else
      report('test_pzm_lc_assert_condition_false_raises_and_logs', false,
        'sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_message=' || v_log_message);
    end if;
  end test_pzm_lc_assert_condition_false_raises_and_logs;

  -----------------------------------------------------------------------------------------------
  -- Private Hilfsprozeduren/-funktionen fuer die CURRENT_UNIT_NAME()-Tests: bilden das
  -- eigentliche Einsatzmuster nach (c_module_name als Deklarations-Konstante).
  -----------------------------------------------------------------------------------------------
  procedure module_name_helper_a(o_name out varchar2) is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
  begin
    o_name := c_module_name;
  end module_name_helper_a;

  procedure module_name_helper_b(o_name out varchar2) is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
  begin
    o_name := c_module_name;
  end module_name_helper_b;

  function module_name_helper_fn return varchar2 is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
  begin
    return c_module_name;
  end module_name_helper_fn;

  procedure module_name_log_helper(p_marker in varchar2) is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
  begin
    begin
      dirkspzm32.pzm_p_lc.raise_app_error(dirkspzm32.pzm_p_lc.cerr_pzm_buchung, p_marker);
    exception
      when others then
        dirkspzm32.pzm_p_log.log_exception(
          p_category => dirkspzm32.pzm_p_log.CAT_SYSTEM,
          p_module   => c_module_name,
          p_context  => p_marker
        );
    end;
  end module_name_log_helper;

  -----------------------------------------------------------------------------------------------
  -- Test: dirkspzm32.current_unit_name() direkt aufgerufen liefert den Namen der aufrufenden Prozedur
  -----------------------------------------------------------------------------------------------
  procedure test_current_unit_name_direct_call is
    v_name varchar2(50);
  begin
    v_name := dirkspzm32.current_unit_name();

    if v_name = 'test_current_unit_name_direct_call' then
      report('test_current_unit_name_direct_call', true,
        'dirkspzm32.current_unit_name() liefert korrekt und kleingeschrieben den eigenen Prozedurnamen: ' || v_name);
    else
      report('test_current_unit_name_direct_call', false,
        'erwartet test_current_unit_name_direct_call, erhalten: ' || v_name);
    end if;
  end test_current_unit_name_direct_call;

  -----------------------------------------------------------------------------------------------
  -- Test: dirkspzm32.current_unit_name() als Deklarations-Konstante (das eigentliche Einsatzmuster)
  -----------------------------------------------------------------------------------------------
  procedure test_current_unit_name_via_declare_constant is
    v_name_a  varchar2(50);
    v_name_b  varchar2(50);
    v_name_fn varchar2(50);
  begin
    module_name_helper_a(v_name_a);
    module_name_helper_b(v_name_b);
    v_name_fn := module_name_helper_fn();

    if v_name_a = 'module_name_helper_a'
       and v_name_b = 'module_name_helper_b'
       and v_name_fn = 'module_name_helper_fn' then
      report('test_current_unit_name_via_declare_constant', true,
        'c_module_name := dirkspzm32.current_unit_name() liefert in zwei Prozeduren UND einer Funktion jeweils ' ||
        'korrekt den eigenen Namen (nicht den des Aufrufers, nicht den eines anderen Helpers): ' ||
        v_name_a || ' / ' || v_name_b || ' / ' || v_name_fn);
    else
      report('test_current_unit_name_via_declare_constant', false,
        'helper_a=' || v_name_a || ' helper_b=' || v_name_b || ' helper_fn=' || v_name_fn);
    end if;
  end test_current_unit_name_via_declare_constant;

  -----------------------------------------------------------------------------------------------
  -- Test (Referenz): dirkspzm32.current_unit_name() als p_module an log_exception() uebergeben
  -----------------------------------------------------------------------------------------------
  procedure test_current_unit_name_in_log_module is
    v_marker varchar2(200) := 'HMTC_CUN_LOG_' || to_char(systimestamp, 'HH24MISSFF3');
    v_cnt    pls_integer;
  begin
    module_name_log_helper(v_marker);

    select count(*) into v_cnt
      from dirkspzm32.pzm_log
     where log_module = 'module_name_log_helper'
       and log_message like '%' || v_marker || '%';

    if v_cnt = 1 then
      report('test_current_unit_name_in_log_module', true,
        'dirkspzm32.current_unit_name() als c_module_name-Konstante bei dirkspzm32.pzm_p_log.log_exception() eingesetzt ' ||
        'fuehrt zu korrektem log_module=''module_name_log_helper'' - kein manuelles Literal mehr noetig');
    else
      report('test_current_unit_name_in_log_module', false,
        'gefundene Zeilen mit korrektem log_module=' || v_cnt);
    end if;
  end test_current_unit_name_in_log_module;

  -----------------------------------------------------------------------------------------------
  -- Test: PZM_P_LOG.log_exception persistiert Fehlercode + Kontext einer gefangenen Exception
  -----------------------------------------------------------------------------------------------
  procedure test_pzm_log_log_exception_captures_context is
    c_module_name constant varchar2(50) := dirkspzm32.current_unit_name();
    v_marker      varchar2(200) := 'HMTC_LOGEXC_' || to_char(systimestamp, 'HH24MISSFF3');
    v_cnt         pls_integer;
    v_error_code  number;
  begin
    begin
      dirkspzm32.pzm_p_lc.raise_app_error(dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid, v_marker);
    exception
      when others then
        dirkspzm32.pzm_p_log.log_exception(
          p_category => dirkspzm32.pzm_p_log.CAT_SYSTEM,
          p_module   => c_module_name
        );
    end;

    select count(*), max(log_error_code)
      into v_cnt, v_error_code
      from dirkspzm32.pzm_log
     where log_module = c_module_name
       and log_message like '%' || v_marker || '%';

    if v_cnt = 1 and v_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid then
      report('test_pzm_log_log_exception_captures_context', true,
        'log_exception() hat Fehlercode ' || v_error_code || ' korrekt in PZM_LOG persistiert');
    else
      report('test_pzm_log_log_exception_captures_context', false,
        'gefundene Zeilen=' || v_cnt || ' error_code=' || v_error_code);
    end if;
  end test_pzm_log_log_exception_captures_context;

  -----------------------------------------------------------------------------------------------
  -- Test: Handler-Muster + bestehender App-Fehler -> ein einziger Log-Eintrag, Code unveraendert
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_preserves_app_error is
    v_marker         varchar2(200) := 'HMTC_PATTERN_APP_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode        pls_integer;
    v_caught         boolean := false;
    v_log_cnt        pls_integer;
    v_log_error_code number;
  begin
    begin
      at_handler_pattern_helper('APP_ERROR', v_marker);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
    end;

    select count(*), max(log_error_code)
      into v_log_cnt, v_log_error_code
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_caught and v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid
       and v_log_cnt = 1 and v_log_error_code = dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid then
      report('test_pattern_preserves_app_error', true,
        'App-Fehlercode ' || v_sqlcode || ' unveraendert (kein Wrapping mehr) an den Aufrufer weitergereicht; ' ||
        'GENAU EIN PZM_LOG-Eintrag (automatisch durch raise_app_error(), Handler-Guard hat Doppel-Log verhindert)');
    else
      report('test_pattern_preserves_app_error', false,
        'caller_sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_error_code=' || v_log_error_code);
    end if;
  end test_pattern_preserves_app_error;

  -----------------------------------------------------------------------------------------------
  -- Test: Handler-Muster + Systemfehler -> unveraendert weitergereicht, ein Log-Eintrag
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_propagates_system_error_unwrapped is
    v_marker          varchar2(200) := 'HMTC_PATTERN_SYS_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode         pls_integer;
    v_sqlerrm         varchar2(4000 char);
    v_caught          boolean := false;
    v_log_cnt         pls_integer;
    v_log_error_code  number;
    v_log_stacktrace  varchar2(4000 char);
  begin
    begin
      at_handler_pattern_helper('SYSTEM_ERROR', v_marker);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    select count(*), max(log_error_code), max(log_stacktrace)
      into v_log_cnt, v_log_error_code, v_log_stacktrace
      from dirkspzm32.pzm_log
     where log_module = 'at_handler_pattern_helper'
       and log_message like '%' || v_marker || '%';

    if v_caught and v_sqlcode = -1476
       and v_log_cnt = 1 and v_log_error_code = -1476 and v_log_stacktrace is not null then
      report('test_pattern_propagates_system_error_unwrapped', true,
        'Aufrufer sieht den ORIGINAL-Fehler ORA-01476 unveraendert (' || v_sqlerrm || ') - kein Wrapping mehr; ' ||
        'GENAU EIN PZM_LOG-Eintrag ueber den Handler-Guard (raise_app_error() wurde hier nie aufgerufen)');
    else
      report('test_pattern_propagates_system_error_unwrapped', false,
        'caller_sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_error_code=' || v_log_error_code);
    end if;
  end test_pattern_propagates_system_error_unwrapped;

  -----------------------------------------------------------------------------------------------
  -- Test: Handler-Muster + verschachtelte AT ohne COMMIT -> unveraendert weitergereicht
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_captures_missing_commit is
    v_marker          varchar2(200) := 'HMTC_PATTERN_NOCOMMIT_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode         pls_integer;
    v_caught          boolean := false;
    v_log_cnt         pls_integer;
    v_log_error_code  number;
  begin
    begin
      at_handler_pattern_helper('MISSING_COMMIT', v_marker);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
    end;

    select count(*), max(log_error_code)
      into v_log_cnt, v_log_error_code
      from dirkspzm32.pzm_log
     where log_module = 'at_handler_pattern_helper'
       and log_message like '%' || v_marker || '%';

    if v_caught and v_sqlcode = -6519
       and v_log_cnt = 1 and v_log_error_code = -6519 then
      report('test_pattern_captures_missing_commit', true,
        'ORA-06519 (fehlender COMMIT einer verschachtelten AT) wurde korrekt geloggt und UNVERAENDERT ' ||
        '(kein Wrapping mehr) an den Aufrufer weitergereicht');
    else
      report('test_pattern_captures_missing_commit', false,
        'caller_sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_error_code=' || v_log_error_code);
    end if;
  end test_pattern_captures_missing_commit;

  -----------------------------------------------------------------------------------------------
  -- Test: Handler-Muster + verschachtelte AT kollidiert mit gesperrter Zeile (Self-Deadlock)
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_captures_self_deadlock is
    v_marker          varchar2(200) := 'HMTC_PATTERN_DEADLOCK_' || to_char(systimestamp, 'HH24MISSFF3');
    v_log_id          number;
    v_sqlcode         pls_integer;
    v_caught          boolean := false;
    v_log_cnt         pls_integer;
    v_log_error_code  number;
  begin
    insert into hm_at_test_log (
      caller_level, event_text, session_id, is_autonomous
    ) values (
      'MAIN_LOCK', v_marker, sys_context('USERENV', 'SID'), 'N'
    ) returning log_id into v_log_id;
    commit;

    update hm_at_test_log
       set event_text = event_text || '_LOCKED_BY_MAIN'
     where log_id = v_log_id;

    begin
      at_handler_pattern_helper('SELF_DEADLOCK', v_marker, v_log_id);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
    end;

    -- HM_AT_TEST_LOG ist eine reine Testtabelle - kein ROLLBACK, damit die tatsaechlich
    -- geschriebenen Daten sichtbar bleiben.
    commit;

    select count(*), max(log_error_code)
      into v_log_cnt, v_log_error_code
      from dirkspzm32.pzm_log
     where log_module = 'at_handler_pattern_helper'
       and log_message like '%' || v_marker || '%';

    if v_caught and v_sqlcode = -60
       and v_log_cnt = 1 and v_log_error_code = -60 then
      report('test_pattern_captures_self_deadlock', true,
        'ORA-00060 (Self-Deadlock) wurde korrekt geloggt und unveraendert weitergereicht, log_id=' || v_log_id);
    else
      report('test_pattern_captures_self_deadlock', false,
        'caller_sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt || ' log_error_code=' || v_log_error_code);
    end if;
  end test_pattern_captures_self_deadlock;

  -----------------------------------------------------------------------------------------------
  -- Test: angehobene Session-Log-Schwelle unterdrueckt sowohl den automatischen als auch den
  -- manuellen Log-Aufruf
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_swallowed_when_log_level_raised is
    v_marker   varchar2(200) := 'HMTC_PATTERN_LEVELSKIP_' || to_char(systimestamp, 'HH24MISSFF3');
    v_log_cnt  pls_integer;
  begin
    dirkspzm32.pzm_p_log.set_log_level(dirkspzm32.pzm_p_log.LEVEL_FATAL); -- Schwelle ueber ERROR anheben

    begin
      at_handler_pattern_helper('APP_ERROR', v_marker);
    exception
      when others then
        null; -- hier interessiert nur, was in PZM_LOG landet
    end;

    select count(*) into v_log_cnt
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    dirkspzm32.pzm_p_log.set_log_level(dirkspzm32.pzm_p_log.LEVEL_TRACE); -- Session-Schwelle wieder zuruecksetzen

    if v_log_cnt = 0 then
      report('test_pattern_swallowed_when_log_level_raised', true,
        'Bei set_log_level(LEVEL_FATAL) schreibt weder der automatische Log-Aufruf in raise_app_error() ' ||
        'noch der Handler-Guard eine Zeile in PZM_LOG - nur der Session-Buffer erhaelt den Eintrag noch');
    else
      report('test_pattern_swallowed_when_log_level_raised', false,
        'Trotz angehobener Log-Schwelle wurde eine Zeile geschrieben (unerwartet), Anzahl=' || v_log_cnt);
    end if;
  exception
    when others then
      dirkspzm32.pzm_p_log.set_log_level(dirkspzm32.pzm_p_log.LEVEL_TRACE); -- Schwelle auch im Fehlerfall zuruecksetzen
      raise;
  end test_pattern_swallowed_when_log_level_raised;

  -----------------------------------------------------------------------------------------------
  -- Test: Backtrace > 4000 Zeichen laesst log_exception() selbst mit ORA-06502 abbrechen ->
  -- KEIN PZM_LOG-Eintrag, nicht einmal ein Hinweis auf den urspruenglichen Fehler.
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_loses_everything_on_deep_backtrace is
    c_depth    constant pls_integer := 120;
    v_marker   varchar2(200) := 'HMTC_PATTERN_DEEPBT_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode  pls_integer;
    v_sqlerrm  varchar2(4000 char);
    v_caught   boolean := false;
    v_log_cnt  pls_integer;
  begin
    begin
      at_handler_pattern_deep_helper(v_marker, c_depth);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
        v_sqlerrm := sqlerrm;
    end;

    select count(*) into v_log_cnt
      from dirkspzm32.pzm_log
     where log_module = 'at_handler_pattern_deep_helper'
       and log_message like '%' || v_marker || '%';

    if v_caught and v_sqlcode = -6502 and v_log_cnt = 0 then
      report('test_pattern_loses_everything_on_deep_backtrace', true,
        'BESTAETIGTE LUECKE (weiterhin in PZM_P_LOG.log_exception() vorhanden): Backtrace aus ' || c_depth ||
        ' Rekursionsebenen > 4000 Zeichen laesst log_exception() selbst mit ORA-06502 abbrechen - ' ||
        'weder der Originalfehler (ORA-01476) noch ein Hinweis landen in PZM_LOG. Aufrufer sieht nur: ' || v_sqlerrm);
    else
      report('test_pattern_loses_everything_on_deep_backtrace', false,
        'Erwartete SQLCODE=-6502 und log_cnt=0, erhalten: sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt);
    end if;
  end test_pattern_loses_everything_on_deep_backtrace;

  -----------------------------------------------------------------------------------------------
  -- Test (Referenz): ergaenzender manueller log_exception()-Aufruf mit vollem PZM-Kontext
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_full_context_is_captured is
    v_marker       varchar2(200) := 'HMTC_PATTERN_FULLCTX_' || to_char(systimestamp, 'HH24MISSFF3');
    c_pers_nr      constant number := 999999;
    c_ze_id        constant number := 888888;
    c_schicht_tag  constant date := trunc(sysdate);
    v_log_cnt      pls_integer;
  begin
    begin
      at_handler_pattern_full_ctx_helper(v_marker, c_pers_nr, c_ze_id, c_schicht_tag);
    exception
      when others then
        null; -- hier interessiert nur der PZM_LOG-Inhalt, nicht die Weitergabe an den Aufrufer
    end;

    -- Es koennen jetzt ZWEI Zeilen zu diesem Marker existieren: der automatische Eintrag aus
    -- raise_app_error() (ohne PZM-Kontext, da dafuer aktuell keine Parameter existieren) UND der
    -- manuelle, ergaenzende log_exception()-Aufruf mit vollem Kontext. Wir pruefen gezielt, ob
    -- MINDESTENS EINE Zeile den vollen Kontext traegt.
    select count(*)
      into v_log_cnt
      from dirkspzm32.pzm_log
     where log_module = 'at_handler_pattern_full_ctx_helper'
       and log_message like '%' || v_marker || '%'
       and pers_nr = c_pers_nr
       and ze_id   = c_ze_id
       and trunc(schicht_tag) = c_schicht_tag;

    if v_log_cnt >= 1 then
      report('test_pattern_full_context_is_captured', true,
        'Ein ergaenzender, manueller log_exception()-Aufruf mit vollem PZM-Kontext (pers_nr/ze_id/schicht_tag) ' ||
        'wird weiterhin korrekt in PZM_LOG erfasst - noetig, da raise_app_error()/raise_app_error_p() diesen ' ||
        'Kontext aktuell nicht kennen');
    else
      report('test_pattern_full_context_is_captured', false, 'Kein Eintrag mit vollem Kontext gefunden');
    end if;
  end test_pattern_full_context_is_captured;

  -----------------------------------------------------------------------------------------------
  -- Test: Handler-Muster + gesperrte PZM_LOG-Tabelle -> Aufrufer bekommt regulaeren Fehlercode,
  -- aber PZM_LOG bleibt vollstaendig leer (falscher Eindruck vollstaendiger Protokollierung).
  -----------------------------------------------------------------------------------------------
  procedure test_pattern_loses_everything_when_pzm_log_locked is
    v_marker   varchar2(200) := 'HMTC_PATTERN_LOCKED_' || to_char(systimestamp, 'HH24MISSFF3');
    v_sqlcode  pls_integer;
    v_caught   boolean := false;
    v_log_cnt  pls_integer;
  begin
    begin
      lock table dirkspzm32.pzm_log in exclusive mode;
      at_handler_pattern_helper('APP_ERROR', v_marker);
    exception
      when others then
        v_caught  := true;
        v_sqlcode := sqlcode;
    end;

    commit; -- Tabellensperre wieder freigeben (kein Datenverlust, es wurde nichts geschrieben)

    select count(*) into v_log_cnt
      from dirkspzm32.pzm_log
     where log_message like '%' || v_marker || '%';

    if v_caught and v_sqlcode = dirkspzm32.pzm_p_lc.cerr_pzm_ze_daten_invalid and v_log_cnt = 0 then
      report('test_pattern_loses_everything_when_pzm_log_locked', true,
        'Der Aufrufer bekommt ganz regulaer den unveraenderten Fehlercode ' || v_sqlcode || ' zurueck ' ||
        '(sieht also aus wie ordnungsgemaess behandelt), aber PZM_LOG enthaelt dazu KEINE Zeile: weder der ' ||
        'automatische Log-Aufruf in raise_app_error() (durch die Tabellensperre verschluckt) noch der ' ||
        'Handler-Guard (is_app_code=TRUE, daher ohnehin uebersprungen)');
    else
      report('test_pattern_loses_everything_when_pzm_log_locked', false,
        'caller_sqlcode=' || v_sqlcode || ' log_cnt=' || v_log_cnt);
    end if;
  end test_pattern_loses_everything_when_pzm_log_locked;

  -----------------------------------------------------------------------------------------------
  -- Aufraeumen
  -----------------------------------------------------------------------------------------------
  procedure cleanup_test_data is
    v_cnt pls_integer;
  begin
    -- log_module traegt seit dirkspzm32.current_unit_name() den exakten (kleingeschriebenen) Namen der
    -- jeweils protokollierenden Prozedur (z.B. 'at_handler_pattern_helper') statt eines
    -- gemeinsamen Package-Praefixes - und ist bei den automatischen Log-Aufrufen aus
    -- PZM_P_LC.raise_app_error()/raise_app_error_p() sogar NULL (die generische Bibliotheksfunktion
    -- kennt den Namen der aufrufenden Prozedur nicht). Deshalb sind ausnahmslos alle Test-Marker
    -- mit 'HMTC_' praefigiert und werden allein darueber zuverlaessig gefunden.
    delete from dirkspzm32.pzm_log
     where log_message like '%HMTC%';
    v_cnt := sql%rowcount;
    commit;
    dbms_output.put_line(v_cnt || ' Testzeile(n) aus PZM_LOG entfernt.');
  end cleanup_test_data;

  -----------------------------------------------------------------------------------------------
  -- Alle Testfaelle ausfuehren
  -----------------------------------------------------------------------------------------------
  procedure run_all is
  begin
    g_pass_count := 0;
    g_fail_count := 0;

    dbms_output.put_line('=== HM_LOG_TESTCASES.run_all - Start ===');

    dbms_output.put_line('--- Autonome Transaktionen ---');
    test_at_missing_commit;
    test_at_self_deadlock_on_locked_row;

    dbms_output.put_line('--- PZM_P_LOG ---');
    test_pzm_log_swallows_write_error;
    test_pzm_log_log_exception_captures_context;

    dbms_output.put_line('--- PZM_P_LC: automatisches Protokollieren in raise_app_error()/raise_app_error_p() ---');
    test_pzm_lc_is_app_code;
    test_pzm_lc_raise_app_error_logs_automatically;
    test_pzm_lc_raise_app_error_p1_logs_automatically;
    test_pzm_lc_raise_app_error_p2_logs_automatically;
    test_pzm_lc_raise_app_error_plist_logs_automatically;
    test_pzm_lc_assert_condition_true_no_op;
    test_pzm_lc_assert_condition_false_raises_and_logs;

    dbms_output.put_line('--- CURRENT_UNIT_NAME(): UTL_CALL_STACK statt Modulname-Literal ---');
    test_current_unit_name_direct_call;
    test_current_unit_name_via_declare_constant;
    test_current_unit_name_in_log_module;

    dbms_output.put_line('--- Handler-Muster wie PZM_P_ZEITERFASSUNG (is_app_code-Guard, kein Wrapping) ---');
    test_pattern_preserves_app_error;
    test_pattern_propagates_system_error_unwrapped;
    test_pattern_captures_missing_commit;
    test_pattern_captures_self_deadlock;
    test_pattern_swallowed_when_log_level_raised;

    dbms_output.put_line('--- Vollstaendigkeit der Protokollierung ---');
    test_pattern_loses_everything_on_deep_backtrace;
    test_pattern_full_context_is_captured;
    test_pattern_loses_everything_when_pzm_log_locked;

    dbms_output.put_line('=== Ergebnis: ' || g_pass_count || ' PASS / ' || g_fail_count || ' FAIL ===');
  end run_all;

end HM_LOG_TESTCASES;
/
