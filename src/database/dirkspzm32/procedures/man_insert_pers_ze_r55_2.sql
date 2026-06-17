create or replace 
procedure DIRKSPZM32.MAN_INSERT_PERS_ZE_R55_2(
  in_pers_nr in number,
  in_schicht_tag in date,
  in_calc_ist_start in date,
  in_calc_ist_ende in date,
  in_status in number,
  in_aa_status in number,
  in_sm_name in varchar2,
  in_sa_kurzname in varchar2,
  in_korr_pers_nr in number,
  in_kst_id in number,
  in_work_location in pzm_zeiterfassung.ze_work_location%type,
  out_new_ze_id out number,
  out_result out number,
  out_res_info out varchar2
) is
  v_ze_id pzm_zeiterfassung.ze_id%type;
begin
  if in_status = pzm_p_zeiterfassung.STATUS_ABWESEND then
    v_ze_id := pzm_p_zeiterfassung.c_abwesenheit_anlegen(
      in_korr_pers_nr => in_korr_pers_nr,
      in_pers_nr => in_pers_nr,
      in_ze_aa_id => in_aa_status,
      in_schicht_tag => in_schicht_tag,
      in_sa_kurzname => in_sa_kurzname,
      in_start_zeit => in_calc_ist_start,
      in_ende_zeit => in_calc_ist_ende,
      in_schicht_tag_auswerten => false -- wir muessen das hier manuell ausfuehren, wegen 'p_result'
    );
  else
    v_ze_id := pzm_p_zeiterfassung.c_ze_zeiten_anlegen(
      in_korr_pers_nr => in_korr_pers_nr,
      in_pers_nr => in_pers_nr,
      in_ze_status => in_status,
      in_schicht_tag => in_schicht_tag,
      in_sa_kurzname => in_sa_kurzname,
      in_start_zeit => in_calc_ist_start,
      in_start_timezone_name => 'Europe/Berlin',
      in_ende_zeit => in_calc_ist_ende,
      in_ende_timezone_name => null,
      in_work_location => in_work_location,
      in_schicht_tag_auswerten => false -- wir muessen das hier manuell ausfuehren, wegen 'p_result'
    );
  end if;

  if v_ze_id is not null and in_kst_id is not null then
    pzm_p_zeiterfassung.c_ze_zuordnung_korrigieren(
      in_ze_id => v_ze_id,
      in_kst_id => in_kst_id,
      in_abt_id => null,
      in_pb_id => null,
      in_schicht_tag_auswerten => false
    );
  end if;

  out_new_ze_id := v_ze_id;
  out_result := 0;
  out_res_info := 'OK. Zeiterfassung erfolgreich erstellt.';
  if out_new_ze_id is null then
    out_result := -1;
    out_res_info := 'Fehler! Keine Zeiterfassung erstellt.';
    pzm_p_log.error(
      p_message => out_res_info,
      p_category => pzm_p_log.CAT_ZEITERFASSUNG,
      p_module => 'man_insert_pers_ze',
      p_error_code => out_result
    );
    return;
  end if;

  update_pers_ze_tag(
    p_pers_nr => in_pers_nr,
    p_datum => in_schicht_tag,
    p_result => out_result,
    p_res_info => out_res_info);

  pzm_abwes_plan_vorbereiten(
    in_start_date => in_schicht_tag,
    in_end_date => in_schicht_tag,
    in_pers_nr => in_pers_nr);
exception
  when others then
    out_result := abs(sqlcode) - 20000; -- Exception
    out_res_info := sqlerrm;
    pzm_p_log.log_exception(
      p_category => pzm_p_log.CAT_ZEITERFASSUNG,
      p_module => 'man_insert_pers_ze_r55_2',
      p_pers_nr => in_pers_nr
    );
end;
/



-- sqlcl_snapshot {"hash":"8b143b5987b6839eb61e8e910832b99e43a87acc","type":"PROCEDURE","name":"MAN_INSERT_PERS_ZE_R55_2","schemaName":"DIRKSPZM32","sxml":""}