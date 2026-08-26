create or replace 
PACKAGE BODY MHABERSTOCK.hm_pkg_at_test AS

    -- Normale (nicht-autonome) Protokollierung -> läuft in der Haupttransaktion
    PROCEDURE log_event(
        p_caller_level  IN VARCHAR2,
        p_event_text    IN VARCHAR2,
        p_is_autonomous IN VARCHAR2 DEFAULT 'N'
    ) IS
        v_scn NUMBER;
        v_trn VARCHAR2(50);
    BEGIN
        v_scn := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;
        v_trn := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(create_transaction => TRUE);        

        INSERT INTO hm_at_test_log (
            caller_level, event_text, session_id,
            local_txn_id, current_scn, is_autonomous
        ) VALUES (
            p_caller_level, p_event_text, SYS_CONTEXT('USERENV','SID'),
            v_trn, v_scn, p_is_autonomous
        );
    END log_event;

    -- Autonome Protokollierung -> eigene Sub-Transaktion mit eigenem Commit
    PROCEDURE log_event_autonomous(
        p_caller_level  IN VARCHAR2,
        p_event_text    IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        v_scn NUMBER;
        v_trn varchar2(50);
    BEGIN
        v_scn := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;
        v_trn := DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(create_transaction => TRUE); 

        INSERT INTO hm_at_test_log (
            caller_level, event_text, session_id,
            local_txn_id, current_scn, is_autonomous, is_committed
        ) VALUES (
            p_caller_level, p_event_text, SYS_CONTEXT('USERENV','SID'),
            v_trn, v_scn, 'Y', 'Y'
        );

        COMMIT;  -- Pflicht innerhalb einer autonomen Transaktion vor Rückkehr
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END log_event_autonomous;

    -- Level 1: autonome Prozedur, die selbst wieder eine autonome Prozedur aufruft
    PROCEDURE nested_autonomous_level1 IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        log_event('LEVEL1_AUTONOMOUS', 'Start Level1 (autonom)', 'Y');
        nested_autonomous_level2;   -- geschachtelte Autonomous Transaction
        log_event('LEVEL1_AUTONOMOUS', 'Ende Level1 (autonom)', 'Y');
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END nested_autonomous_level1;

    -- Level 2: zweite, tiefer geschachtelte Autonomous Transaction
    PROCEDURE nested_autonomous_level2 IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        log_event('LEVEL2_AUTONOMOUS', 'Level2 (autonom, verschachtelt)', 'Y');
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END nested_autonomous_level2;

END hm_pkg_at_test;
/



-- sqlcl_snapshot {"hash":"fb7a66341de6ab3ce267173257dc3542a28853eb","type":"PACKAGE_BODY","name":"HM_PKG_AT_TEST","schemaName":"MHABERSTOCK","sxml":""}