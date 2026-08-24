create or replace 
procedure MHABERSTOCK.hm_prc_at_test is 
    v_scn      NUMBER;
    v_txn_id   VARCHAR2(50);
    
    CURSOR c_log IS
    SELECT log_id, log_time, caller_level, event_text, local_txn_id,
           current_scn, is_autonomous, is_committed, session_id
    FROM hm_at_test_log
    ORDER BY log_id;
    
    procedure putl (i_text in varchar2)
    is 
    begin
      dbms_output.put_line( to_char(systimestamp, 'hh24:mi:ssxFF') || ' ' || i_text ); 
    end;
    
    procedure hdr
    is 
    begin 
      dbms_output.put_line( 'LOG_ID LOG_TIME           CALLER_LEVEL      EVENT_TEXT                              LOCAL_TXN_ID CURRENT_SCN    AUTO COMM SID' );
      dbms_output.put_line( '------ ------------------ ----------------- --------------------------------------- ------------ -------------- ---- ---- ------' );
    end hdr;
    
    procedure cout( i_log   c_log%rowtype)
    is 
    begin
      
      dbms_output.put( lpad(to_char(i_log.log_id), 6 ) || ' ');
      DBMS_OUTPUT.PUT( to_char(i_log.log_time, 'hh24:mi:ssxff') || ' ');
      dbms_output.put( rpad(i_log.caller_level, 18) );
      dbms_output.put( rpad(i_log.event_text, 40) );
      dbms_output.put( rpad(i_log.local_txn_id, 13 ) );
      dbms_output.put( lpad(i_log.current_scn, 14) || ' ');
      dbms_output.put( rpad(i_log.is_autonomous, 5)); 
      dbms_output.put( rpad(i_log.is_committed, 5)); 
      dbms_output.put( lpad(i_log.session_id, 6)); 
      dbms_output.new_line;
    end cout;
    
    procedure tout Is
    begin
      hdr;
      for r_log in c_log loop
        cout( r_log);
      end loop;
    end tout;
        
BEGIN

    
    -- Direkter Log-Eintrag im Testblock (Haupttransaktion)
    v_scn    := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;
    v_txn_id := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(TRUE);

    INSERT INTO hm_at_test_log (
        caller_level, event_text, session_id,
        local_txn_id, current_scn, is_autonomous
    ) VALUES (
        'TEST_BLOCK', 'Direkter Insert vor autonomen Aufrufen',
        SYS_CONTEXT('USERENV','SID'), v_txn_id, v_scn, 'N'
    );
    putl('--- Schritt 1: Direkter Insert MAIN --- TXN-ID: ' || v_txn_id || '  SCN: ' || v_scn);
    tout;
    

    -- Package-Aufruf für Haupttransaktion
    hm_pkg_at_test.log_event('MAIN', 'Start Haupttransaktion', 'N');
    putl('--- Schritt 2: log_event MAIN aufgerufen ---');
    tout;
    
    -- Geschachtelte autonome Transaktionen
    hm_pkg_at_test.nested_autonomous_level1;
    putl('--- Schritt 3: nested_autonomous_level1 (inkl. Level2) abgeschlossen ---');
    
    
    -- Weiterer direkter Insert, vor Rollback
    v_scn    := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;
    v_txn_id := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(TRUE);

    INSERT INTO hm_at_test_log (
        caller_level, event_text, session_id,
        local_txn_id, current_scn, is_autonomous
    ) VALUES (
        'TEST_BLOCK', 'Direkter Insert vor Rollback',
        SYS_CONTEXT('USERENV','SID'), v_txn_id, v_scn, 'N'
    );
    putl('--- Schritt 4: Direkter Insert vor ROLLBACK --- TXN-ID: ' || v_txn_id || '  SCN: ' || v_scn);
    putl('Diese beiden MAIN/TEST_BLOCK-Zeilen sind JETZT sichtbar, werden aber durch den nachfolgenden ROLLBACK entfernt.');
    tout;
    
    -- Haupttransaktion zurückrollen
    ROLLBACK;
    putl('--- Schritt 5: ROLLBACK ausgefuehrt ---');
    
    -- Verifikations-Eintrag nach Rollback (autonom, bleibt erhalten)
    hm_pkg_at_test.log_event_autonomous('VERIFY', 'Verifikation nach Rollback');
    putl('--- Schritt 6: VERIFY-Eintrag (autonom) nach Rollback geschrieben ---');
    putl('Test abgeschlossen. Bitte hm_at_test_log auswerten.');
    tout;
    -- delete from HM_AT_TEST_LOG;
    commit;    
END;
/



-- sqlcl_snapshot {"hash":"23f363b40b89cff082a42fc9a31b70bce380af5e","type":"PROCEDURE","name":"HM_PRC_AT_TEST","schemaName":"MHABERSTOCK","sxml":""}