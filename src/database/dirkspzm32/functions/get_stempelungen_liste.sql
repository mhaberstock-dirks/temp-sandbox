create or replace function dirkspzm32.get_stempelungen_liste (
    p_pers_nr       in number,
    p_datum         in date,
    p_status_filter in number default null,
    p_separator     in varchar2 default chr(13)
) return varchar2 is

    result             varchar2(4000);
    v_anstempel_zeit   date;
    v_abstempel_zeit   date;
    v_zeit_start       date;
    v_zeit_ende        date;
    v_ze_status        number;
    v_ze_aa_status     number;
    v_kurzname         pzm_ze_statusinfo.stat_kurz_name%type;
    v_ze_std           number;
    v_ze_work_location pzm_zeiterfassung.ze_work_location%type;
    v_zeit_eintrag     varchar2(255);
    cursor c_zeiterfassung is
    select
        xze.ze_ist_start,
        xze.ze_ist_ende,
        xze.ze_calc_ist_start,
        xze.ze_calc_ist_ende,
        xze.ze_status,
        xze.ze_aa_status,
        xsi.stat_kurz_name,
        xze.ze_std,
        xze.ze_work_location
    from
        pzm_zeiterfassung xze,
        pzm_ze_statusinfo xsi
    where
            xze.ze_status = xsi.stat_id (+)
        and xze.ze_pers_nr = p_pers_nr
        and xze.ze_schicht_tag = trunc(p_datum)
       --and (xze.ze_aa_status is NULL or (select p.pers_kennz_zeiterf from pzm_personal p where p.pers_nr = p_pers_nr) = 1)
       --and (TRUNC(xze.ze_ist_start) = TRUNC(p_datum) OR TRUNC(xze.ze_calc_ist_start) = TRUNC(p_datum))
    order by
        decode(xze.ze_calc_ist_start, null, xze.ze_ist_start, xze.ze_calc_ist_start),
        xze.ze_id;

begin
    result := null;
    open c_zeiterfassung;
    loop
        fetch c_zeiterfassung into
            v_anstempel_zeit,
            v_abstempel_zeit,
            v_zeit_start,
            v_zeit_ende,
            v_ze_status,
            v_ze_aa_status,
            v_kurzname,
            v_ze_std,
            v_ze_work_location;

        exit when c_zeiterfassung%notfound;
        if v_ze_std is null then
            v_ze_std := 0;
        end if;
        v_zeit_eintrag := null;
        if p_status_filter is null
           or (
            p_status_filter is not null
            and p_status_filter = v_ze_status
        ) then
            v_zeit_eintrag := '--:-- --:--    ';
            if v_anstempel_zeit is not null
               or v_abstempel_zeit is not null then
                if v_anstempel_zeit is null then
                    v_zeit_eintrag := '--:-- ';
                else
                    v_zeit_eintrag := to_char(v_anstempel_zeit, 'hh24:mi')
                                      || '-';
                end if;

                if v_abstempel_zeit is null then
                    v_zeit_eintrag := v_zeit_eintrag || 'an:we';
                elsif v_abstempel_zeit = v_anstempel_zeit then
                    v_zeit_eintrag := v_zeit_eintrag || 'au:ab';
                else
                    v_zeit_eintrag := v_zeit_eintrag || to_char(v_abstempel_zeit, 'hh24:mi');
                end if;

                v_zeit_eintrag := v_zeit_eintrag || ' => ';
            end if;

            v_zeit_eintrag := v_zeit_eintrag
                              || to_char(v_zeit_start, 'hh24:mi')
                              || '-'
                              || to_char(v_zeit_ende, 'hh24:mi');

            if v_ze_work_location in ( 3, 4 ) then
                v_kurzname := v_kurzname || '-r';
            end if;

            if p_status_filter is null then
                v_zeit_eintrag := v_zeit_eintrag
                                  || ' ['
                                  || v_kurzname
                                  || ']';
            end if;

        end if;

        if v_zeit_eintrag is not null then
            if result is null then
                result := v_zeit_eintrag;
            else
        -- alle weiteren Einträge abschneiden
                if length(result) < 3900 then
                    result := result
                              || p_separator
                              || v_zeit_eintrag;
                end if;
            end if;
        end if;

    end loop;

    close c_zeiterfassung;
    return ( result );
end;
/


-- sqlcl_snapshot {"hash":"8e75bfbb18a40b8a5cc6a980512fe17409fcb23b","type":"FUNCTION","name":"GET_STEMPELUNGEN_LISTE","schemaName":"DIRKSPZM32","sxml":""}