create or replace procedure dirkspzm32.man_update_pers_ze_r55_2 (
    in_ze_id          in number,
    in_pers_nr        in number,
    in_schicht_tag    in date,
    in_calc_ist_start in date,
    in_calc_ist_ende  in date,
    in_status         in number,
    in_aa_status      in number,
    in_sm_name        in varchar2,
    in_sa_kurzname    in varchar2,
    in_korr_pers_nr   in number,
    in_kst_id         in isi_kostenstellen.kst_nr%type,
    in_work_location  in pzm_zeiterfassung.ze_work_location%type,
    out_result        out number,
    out_res_info      out varchar2
) is

    v_ze_schicht_tag pzm_zeiterfassung.ze_schicht_tag%type;
    v_ze_sa_kurzname pzm_zeiterfassung.ze_sa_kurzname%type;
    v_kst_id         pzm_zeiterfassung.ze_kst_id%type;
    v_work_location  pzm_zeiterfassung.ze_work_location%type;
begin
    select
        ze.ze_schicht_tag,
        ze.ze_sa_kurzname,
        ze.ze_kst_id,
        nvl(ze.ze_work_location, 1)
    into
        v_ze_schicht_tag,
        v_ze_sa_kurzname,
        v_kst_id,
        v_work_location
    from
        pzm_zeiterfassung ze
    where
        ze.ze_id = in_ze_id;

    if in_status = pzm_p_zeiterfassung.status_abwesend then
        pzm_p_zeiterfassung.c_abwesenheit_korrigieren(
            in_korr_pers_nr          => in_korr_pers_nr,
            in_ze_id                 => in_ze_id,
            in_ze_aa_id              => in_aa_status,
            in_schicht_tag           => in_schicht_tag,
            in_sa_kurzname           => in_sa_kurzname,
            in_start_zeit            => in_calc_ist_start,
            in_ende_zeit             => in_calc_ist_ende,
            in_schicht_tag_auswerten => false
        );

    else
        if
            in_calc_ist_start is null
            and in_calc_ist_ende is null
        then
      -- wir nutzen die Schicht-Korrektur, um eine Neuberechnung der Zeiten
      -- zu erzwingen (auch wenn die Schicht sich nicht wirklich geaendert hat)
            pzm_p_zeiterfassung.c_ze_schicht_korrigieren(
                in_ze_id                 => in_ze_id,
                in_schicht_tag_neu       => in_schicht_tag,
                in_sa_kurzname_neu       => in_sa_kurzname,
                in_schicht_tag_auswerten => false
            );
        else
            pzm_p_zeiterfassung.c_ze_zeiten_korrigieren(
                in_korr_pers_nr          => in_korr_pers_nr,
                in_ze_id                 => in_ze_id,
                in_ze_status             => in_status,
                in_schicht_tag           => in_schicht_tag,
                in_sa_kurzname           => in_sa_kurzname,
                in_start_zeit            => in_calc_ist_start,
                in_start_timezone_name   => 'Europe/Berlin',
                in_ende_zeit             => in_calc_ist_ende,
                in_ende_timezone_name    => null,
                in_schicht_tag_auswerten => false
            );
        end if;

        if
            in_work_location is not null
            and in_work_location != v_work_location
        then
            update pzm_zeiterfassung
            set
                ze_work_location = in_work_location
            where
                ze_id = in_ze_id;

            commit;
        end if;

    end if;

    if
        in_kst_id is not null
        and in_kst_id != v_kst_id
    then -- Kostenstelle wurde geaendert
        pzm_p_zeiterfassung.c_ze_zuordnung_korrigieren(
            in_ze_id                 => in_ze_id,
            in_kst_id                => in_kst_id,
            in_abt_id                => null,
            in_pb_id                 => null,
            in_schicht_tag_auswerten => false
        );
    end if;

    if v_ze_schicht_tag != in_schicht_tag -- der Schichttag wurde geaendert
    or v_ze_sa_kurzname != in_sa_kurzname then -- die Schichtart wurde geaendert
        pzm_p_zeiterfassung.c_ze_schicht_korrigieren(
            in_ze_id                 => in_ze_id,
            in_schicht_tag_neu       => in_schicht_tag,
            in_sa_kurzname_neu       => in_sa_kurzname,
            in_schicht_tag_auswerten => false
        );
    end if;

    if v_ze_schicht_tag != in_schicht_tag then -- der Schichttag wurde geaendert
    -- vorherigen Schichttag auch nochmal auswerten
        update_pers_ze_tag(
            p_pers_nr  => in_pers_nr,
            p_datum    => v_ze_schicht_tag,
            p_result   => out_result,
            p_res_info => out_res_info
        );

        pzm_abwes_plan_vorbereiten(
            in_start_date => v_ze_schicht_tag,
            in_end_date   => v_ze_schicht_tag,
            in_pers_nr    => in_pers_nr
        );
    end if;

    update_pers_ze_tag(
        p_pers_nr  => in_pers_nr,
        p_datum    => in_schicht_tag,
        p_result   => out_result,
        p_res_info => out_res_info
    );

    pzm_abwes_plan_vorbereiten(
        in_start_date => in_schicht_tag,
        in_end_date   => in_schicht_tag,
        in_pers_nr    => in_pers_nr
    );
exception
    when others then
        out_result := abs(sqlcode) - 20000; -- Exception
        out_res_info := sqlerrm;
        pzm_p_log.log_exception(
            p_category => pzm_p_log.cat_zeiterfassung,
            p_module   => 'man_update_pers_ze_r55_2',
            p_pers_nr  => in_pers_nr
        );

end;
/


-- sqlcl_snapshot {"hash":"f7e3c3927429f68ad437d7c2af177c599bab5bd6","type":"PROCEDURE","name":"MAN_UPDATE_PERS_ZE_R55_2","schemaName":"DIRKSPZM32","sxml":""}