create or replace 
procedure DIRKSPZM32.UPDATE_PERSONAL_ZE_STATUS_DATE(
  p_pers_nr in number,          --# Personalnummer des Mitarbeiters der die Zeiterfassung ausführt.
  p_status in number,           --# Status für die Zeiterfassung (Kann nur ANWESEND, PAUSE und DIENSTGANG sein)
  p_buch_datum_zeit in date,          --# Datum der Buchung wenn NULL dann SYSDATE
  p_start_ende_flag in number,  --# 1 = Start-Flag = Status wird gestartet, !1 (0 oder 2) = Ende-Flag der aktuelle (offene) Status wird beendet.
  p_kst_id in number,           --# [optional] Aktuelle Kostenstelle des Mitarbeiters
  p_aa_status in number,        --# [deprecated] Abwesenheitsart (AA_ID) wenn in p_status "ABWESEND" übergeben wurde.
  p_vorgaenger_link in number,  --# [deprecated] Urprüngliches Konzept für die Verkettung von aufeinander folgenden Stempelzeiten
  p_abt_id in number,           --# [optional] Aktuelle Kostenstelle des Mitarbeiters
  p_result out number,          --# [out] -1 = keine Aktion/Ation fehlgeschlagen, ansonsten aktueller (offener) Status in der Zeiterfassung.
  p_res_info out varchar2       --# [out] Klartext für p_result (derzeit Hardcodiert in deutsch)
) is
------------------------------------------------------------------------------------------------
-- !!!OBSOLETE!!! Diese Funktion wird nach Einfuehrung von PZM_P_ZEITERFASSUNG geloescht!
-- Aktuell wird sie auf PZM_P_ZEITERFASSUNG upgeleitet
------------------------------------------------------------------------------------------------
  FLAG_START constant number := 1;

  v_aktion varchar2(1 char) := pzm_p_zeiterfassung.AKTION_KOMMEN;
  v_ze_id pzm_zeiterfassung.ze_id%type;
begin
  if p_status = pzm_p_zeiterfassung.STATUS_ANWESEND and p_start_ende_flag != FLAG_START then
    v_aktion := pzm_p_zeiterfassung.AKTION_GEHEN;
  elsif p_status = pzm_p_zeiterfassung.STATUS_PAUSE and p_start_ende_flag = FLAG_START then
    v_aktion := pzm_p_zeiterfassung.AKTION_PAUSE;
  elsif p_status = pzm_p_zeiterfassung.STATUS_DIENSTGANG and p_start_ende_flag = FLAG_START then
    v_aktion := pzm_p_zeiterfassung.AKTION_DIENSTGANG;
  end if;

  if p_buch_datum_zeit is null then
    v_ze_id := pzm_p_zeiterfassung.c_live_stempeln(
      in_pers_nr => p_pers_nr,
      in_aktion => v_aktion,
      in_timezone_name => null, -- intern wird DEFAULT_TIMEZONE (i.d.R. Europe/Berlin) verwendet
      in_kst_id => p_kst_id,
      in_abt_id => p_abt_id,
      in_work_location => null, -- default work location wird intern anhand der Status ermittelt
      in_frontend_name => null
    );
  else
    v_ze_id := pzm_p_zeiterfassung.c_stempelzeit_ze_sync(
      in_quelle => pzm_p_zeiterfassung.QUELLE_TERMINAL,
      in_pers_nr => p_pers_nr,
      in_aktion => v_aktion,
      in_zeitstempel => p_buch_datum_zeit,
      in_timezone_name => null, -- intern wird DEFAULT_TIMEZONE (i.d.R. Europe/Berlin) verwendet
      in_kst_id => p_kst_id,
      in_abt_id => p_abt_id,
      in_terminal_id => null,
      in_rfid => null,
      in_work_location => null -- default work location wird intern anhand der Status ermittelt
    );
  end if;

  p_result := nvl(v_ze_id, -1);
  p_res_info := 'OK. Zeiterfassung erfolgreich erstellt bzw. aktualisiert.';
  if p_result = -1 then
    p_res_info := 'Fehler! Keine Zeiterfassung erstellt oder aktualisiert.';
    pzm_p_log.error(
      p_message => p_res_info,
      p_category => pzm_p_log.CAT_ZEITERFASSUNG,
      p_module => 'update_personal_ze_status',
      p_error_code => p_result
    );
  end if;
exception
  when others then
    p_result := -1; -- Exception
    p_res_info := sqlerrm;
    pzm_p_log.log_exception(
      p_category => pzm_p_log.CAT_ZEITERFASSUNG,
      p_module => 'update_personal_ze_status_date',
      p_pers_nr => p_pers_nr
    );
end;
/



-- sqlcl_snapshot {"hash":"67826d57f255524f78632ec6948693f16c516de0","type":"PROCEDURE","name":"UPDATE_PERSONAL_ZE_STATUS_DATE","schemaName":"DIRKSPZM32","sxml":""}