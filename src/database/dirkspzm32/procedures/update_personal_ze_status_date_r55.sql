create or replace 
procedure DIRKSPZM32.UPDATE_PERSONAL_ZE_STATUS_DATE_R55(
  p_pers_nr in number,          --# Personalnummer des Mitarbeiters der die Zeiterfassung ausf?hrt.
  p_status in number,           --# Status f?r die Zeiterfassung (Kann nur ANWESEND, PAUSE und DIENSTGANG sein)
  p_buch_datum_zeit in date,    --# Datum der Buchung wenn NULL dann SYSDATE
  p_start_ende_flag in number,  --# 1 = Start-Flag = Status wird gestartet, !1 (0 oder 2) = Ende-Flag der aktuelle (offene) Status wird beendet.
  p_kst_id in number,           --# [optional] Aktuelle Kostenstelle des Mitarbeiters
  p_aa_status in number,        --# [deprecated] Abwesenheitsart (AA_ID) wenn in p_status "ABWESEND" ?bergeben wurde.
  p_vorgaenger_link in number,  --# [deprecated] Urpr?ngliches Konzept f?r die Verkettung von aufeinander folgenden Stempelzeiten
  p_abt_id in number,           --# [optional] Aktuelle Abteilung des Mitarbeiters
  p_work_location in pzm_zeiterfassung.ze_work_location%type,    --# Arbeitsort-ID
  p_result out number,          --# [out] -1 = keine Aktion/Ation fehlgeschlagen, ansonsten aktueller (offener) Status in der Zeiterfassung.
  p_res_info out varchar2       --# [out] Klartext f?r p_result (derzeit Hardcodiert in deutsch)
) is
------------------------------------------------------------------------------------------------
-- !!!OBSOLETE!!! Diese Funktion wird nach Einfuehrung von PZM_P_ZEITERFASSUNG geloescht!
-- Aktuell wird sie auf PZM_P_ZEITERFASSUNG upgeleitet
--
--# Diese Prozedur f?hrt eine Zeiterfassung f?r einen Mitarbeiter aus. Der ?bergebene Status
--# und der Start-/Ende-Flag steuert die Art der Zeiterfassung.
--# Z.B. erzeugt "p_status = STATUS_ANWESEND (2)" und "p_start_ende_flag = v_StatusStart (1)"
--# einen offenen Anwesenheitsdatensatz in der Tabelle PZM_ZEITERFASSUNG. Die Schichtart
--# und der aktuelle Schichttag wird beim ersten Eintrag eines Schichttages automatisch
--# ermittelt und in der Zeiterfassung eingetragen.
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
      in_work_location => p_work_location,
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
      in_work_location => p_work_location
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
      p_module => 'update_personal_ze_status_date_r55',
      p_pers_nr => p_pers_nr
    );
end;
/



-- sqlcl_snapshot {"hash":"d36f7a6488a24d27e7ed9b5d01be3164b26beda6","type":"PROCEDURE","name":"UPDATE_PERSONAL_ZE_STATUS_DATE_R55","schemaName":"DIRKSPZM32","sxml":""}