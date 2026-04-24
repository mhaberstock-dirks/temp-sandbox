create or replace procedure dirkspzm32.update_all_ze_tag (
    p_datum in date
) is
-- Diese Funktion wird von einem DBMS_JOB aufgerufen
-- Der Das Datum vom einem Tag vorher übergibt. (SYSDATE -1)

-- Änderungen:
-- MWe 20180601 Abrechnung zum Monatsende passt nicht Ticket: P70074-30

    cursor c_personal is
    --SELECT pd_pers_nr FROM pzm_personal_details WHERE pd_austrittdatum is NULL or pd_austrittdatum > TRUNC(SYSDATE);    -- MWe Backup
    --SELECT pd_pers_nr FROM pzm_personal_details WHERE pd_austrittdatum is NULL or pd_austrittdatum > TRUNC(p_datum);    -- MWe Add
    -- MWe 20190807 Ticket: W20310-395
    select
        p.pers_nr
    from
        pzm_personal p
    where
        ( p.pers_austrittdatum is null
          or p.pers_austrittdatum >= trunc(p_datum) )
        and ( p.pers_eintrittsdatum is null
              or p.pers_eintrittsdatum <= trunc(p_datum) );

    v_persnr           pzm_personal.pers_nr%type;
    v_tagesauswresult  number;
    v_tagesauswresinfo varchar2(255);
begin
    open c_personal;

  -- MWe 20180313 Log Eintrag
    isi_p_log.isi_system_meldung('01', 1, 'PZM update_all_ze_tag', 'ORA-DB PZM', 'UPDATE_ALL_ZE_TAG',
                                 null, null, -1, null, null,
                                 'Start der Procedure: UPDATE_ALL_ZE_TAG', 'I', 4);

    loop
        fetch c_personal into v_persnr;
        exit when c_personal%notfound;
        begin
            update_pers_ze_tag(v_persnr, p_datum, v_tagesauswresult, v_tagesauswresinfo);
        exception
            when others then
                null;
        end;

    end loop;

    -- MWe 20180313 Log Eintrag
    isi_p_log.isi_system_meldung('01', 1, 'PZM update_all_ze_tag', 'ORA-DB PZM', 'UPDATE_ALL_ZE_TAG',
                                 null, null, -1, null, null,
                                 'Ende der Procedure: UPDATE_ALL_ZE_TAG', 'I', 4);

    close c_personal;
end update_all_ze_tag;
/


-- sqlcl_snapshot {"hash":"851708903b759c347a96123ac145875750e4300c","type":"PROCEDURE","name":"UPDATE_ALL_ZE_TAG","schemaName":"DIRKSPZM32","sxml":""}