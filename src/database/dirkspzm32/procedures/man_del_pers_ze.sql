create or replace procedure dirkspzm32.man_del_pers_ze (
    p_ze_id     in number,
    p_pers_nr   in number,
    p_ze_status in number,
    p_result    out number,
    p_res_info  out varchar2
) is
    v_schicht_tag date;
begin
    pzm_p_zeiterfassung.c_ze_loeschen(
        in_korr_pers_nr          => p_pers_nr, -- wir haben hier leider (historisch gesehen) nichts anderes
        in_ze_id                 => p_ze_id,
        in_schicht_tag_auswerten => false
    );

    p_result := 0;
    p_res_info := 'OK. Zeiterfassung erfolgreich geloescht.';
    select
        ze_schicht_tag
    into v_schicht_tag
    from
        pzm_zeiterfassung
    where
        ze_id = p_ze_id;

    update_pers_ze_tag(
        p_pers_nr  => p_pers_nr,
        p_datum    => v_schicht_tag,
        p_result   => p_result,
        p_res_info => p_res_info
    );

    pzm_abwes_plan_vorbereiten(
        in_start_date => v_schicht_tag,
        in_end_date   => v_schicht_tag,
        in_pers_nr    => p_pers_nr
    );
exception
    when others then
        p_result := abs(sqlcode) - 20000; -- Exception
        p_res_info := sqlerrm;
        pzm_p_log.log_exception(
            p_category => pzm_p_log.cat_zeiterfassung,
            p_module   => 'man_del_pers_ze',
            p_pers_nr  => p_pers_nr
        );

end;
/


-- sqlcl_snapshot {"hash":"a07cca0f915c9b7851da41ad3534347defad3b15","type":"PROCEDURE","name":"MAN_DEL_PERS_ZE","schemaName":"DIRKSPZM32","sxml":""}