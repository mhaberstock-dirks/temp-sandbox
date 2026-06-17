create or replace 
procedure DIRKSPZM32.UPDATE_ALL_ZE_TAG_271(p_datum in date) is
-- Diese Funktion wird von einem DBMS_JOB aufgerufen
-- Der Das Datum vom einem Tag vorher übergibt. (SYSDATE -1)

-- Änderungen:
-- MWe 20180601 Abrechnung zum Monatsende passt nicht Ticket: P70074-30

  CURSOR c_Personal IS
    --SELECT pd_pers_nr FROM pzm_personal_details WHERE pd_austrittdatum is NULL or pd_austrittdatum > TRUNC(SYSDATE);    -- MWe Backup
    --SELECT pd_pers_nr FROM pzm_personal_details WHERE pd_austrittdatum is NULL or pd_austrittdatum > TRUNC(p_datum);    -- MWe Add
    -- MWe 20190807 Ticket: W20310-395
    select p.pers_nr
      from pzm_personal p
    where (p.pers_austrittdatum is NULL or
           p.pers_austrittdatum >= trunc(p_datum))
      and (p.pers_eintrittsdatum is NULL or
           p.pers_eintrittsdatum <= trunc(p_datum))
      and p.pers_pb_id = 271;

  v_PersNr   pzm_personal.pers_nr%TYPE;
  v_TagesauswResult number;
  v_TagesauswResInfo varchar2(255);
begin
  OPEN c_Personal;

  -- MWe 20180313 Log Eintrag
  isi_p_log.isi_system_meldung('01',
                               1,
                               'PZM update_all_ze_tag',
                               'ORA-DB PZM',
                               'UPDATE_ALL_ZE_TAG',
                               null,
                               null,
                               -1,
                               null,
                               null,
                               'Start der Procedure: UPDATE_ALL_ZE_TAG',
                               'I',
                               4);


  LOOP
    FETCH c_Personal INTO v_PersNr;
    EXIT WHEN c_Personal%NOTFOUND;

    begin
      UPDATE_PERS_ZE_TAG(v_PersNr, p_datum, v_TagesauswResult, v_TagesauswResInfo);
    exception
      when others then
        NULL;
    end;
  END LOOP;

    -- MWe 20180313 Log Eintrag
  isi_p_log.isi_system_meldung('01',
                               1,
                               'PZM update_all_ze_tag',
                               'ORA-DB PZM',
                               'UPDATE_ALL_ZE_TAG',
                               null,
                               null,
                               -1,
                               null,
                               null,
                               'Ende der Procedure: UPDATE_ALL_ZE_TAG',
                               'I',
                               4);


  CLOSE c_Personal;
end UPDATE_ALL_ZE_TAG_271;
/



-- sqlcl_snapshot {"hash":"7dfa1dc0feb09eb8f8491670c5cc14558f17686a","type":"PROCEDURE","name":"UPDATE_ALL_ZE_TAG_271","schemaName":"DIRKSPZM32","sxml":""}