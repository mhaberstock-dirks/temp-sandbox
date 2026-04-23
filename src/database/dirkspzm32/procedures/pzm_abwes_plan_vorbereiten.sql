create or replace procedure dirkspzm32.pzm_abwes_plan_vorbereiten (
    in_start_date in date,
    in_end_date   in date,
    in_pers_nr    in pzm_abwes_plan.pers_nr%type
) is

    v_start_date   date;
    v_end_date     date;
    v_current_date date;
    v_pers_nr      number;
    v_pb_id        number;
    v_abt_id       number;
    v_kst_id       number;
    v_anw_std      number;
    v_aa_id        number;
    v_aa_kurzname  pzm_abwes_plan.aa_kurzname%type;
    v_aa_farbe     number;
    v_feiertag     pzm_abwes_plan.kennz_feiertag%type;
    v_wochentag    pzm_abwes_plan.wochentag_kurz%type;
    v_sakurzname   pzm_schichtarten.sa_kurzname%type; -- varchar2(10);
    v_sabeginn     pzm_schichtarten.sa_beginn%type; --  date;
    v_saende       pzm_schichtarten.sa_ende%type; -- date;
    v_sastdprotag  number;
    v_schicht_vorh boolean;
    cursor c_pers is
    select
        t.pers_nr,
        t.pers_abt_id,
        t.pers_pb_id,
        t.pers_kst_id
    from
        pzm_personal t
    where
        t.pers_nr = in_pers_nr
        or in_pers_nr is null;

    cursor c_ze is
    select
        nvl(t.ts_day_anw_std, 0),
        t.ts_aa_id,
        aa.aa_kurzname,
        aa.aa_farbe
    from
        pzm_ze_tagessatz      t,
        pzm_abwesenheitsarten aa
    where
            t.ts_pers_nr = v_pers_nr
        and t.ts_datum = v_current_date
       --and (nvl(t.ts_day_anw_std, 0) = 0 and aa.aa_kurzname = 'FLX-Abbau' or aa.aa_kurzname != 'FLX-Abbau')
        and aa.aa_id (+) = t.ts_aa_id;

    cursor c_am is
    select
        t.aa_id,
        aa.aa_kurzname,
        aa.aa_farbe
    from
        pzm_abwesenheitsmeldungen t,
        pzm_abwesenheitsarten     aa
    where
            t.pers_nr = v_pers_nr
        and t.beginn <= v_current_date
        and t.ende >= v_current_date
        and aa.aa_id = t.aa_id;

    cursor c_ua is
    select
        t.au_abwes_art,
        aa.aa_kurzname,
        aa.aa_farbe
    from
        pzm_abwesenheits_antr t,
        pzm_abwesenheitsarten aa
    where
            t.au_pers_nr = v_pers_nr
        and t.au_beginn <= v_current_date
        and t.au_ende >= v_current_date
        and t.au_status = 1 -- geprüft und genehmigt
        and aa.aa_id = t.au_abwes_art;

    v_found        boolean;
begin
    v_start_date := in_start_date; --to_date(:start_date, 'dd.mm.yyyy');
    v_end_date := in_end_date; --to_date(:end_date, 'dd.mm.yyyy');

    v_current_date := v_start_date;
    while v_current_date <= v_end_date loop
        v_wochentag := to_char(v_current_date, 'Dy');
        open c_pers;
        loop
            fetch c_pers into
                v_pers_nr,
                v_pb_id,
                v_abt_id,
                v_kst_id;
            exit when c_pers%notfound;
            v_feiertag := 'F';
            if check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, v_current_date) in ( 'F', 'SF' ) then
                v_feiertag := 'T';
            end if;

            v_sakurzname := null;
            v_schicht_vorh := get_schicht_daten(v_pers_nr, v_current_date, v_current_date, v_sakurzname, v_sabeginn,
                                                v_saende, v_sastdprotag) = 1;

            delete pzm_abwes_plan t
            where
                    t.pers_nr = v_pers_nr
                and t.abwes_plan_tag = v_current_date;

            commit;
            open c_ze; -- Zeiterfassung
            fetch c_ze into
                v_anw_std,
                v_aa_id,
                v_aa_kurzname,
                v_aa_farbe;
            v_found := c_ze%found;
            close c_ze;
            if
                v_aa_kurzname like 'K%'
                and v_aa_kurzname != 'KUG'
            then  -- Krank immer durchgehen Zählen
                v_schicht_vorh := true;
            elsif v_aa_kurzname = 'V-ARB-Zeit' then
                v_schicht_vorh := false;
            end if;

            if v_found then
                if
                    v_feiertag = 'F'
                    and v_schicht_vorh
                    and nvl(v_anw_std, 0) = 0
                then
                    insert into pzm_abwes_plan values ( v_pers_nr,
                                                        v_current_date,
                                                        v_feiertag,
                                                        v_wochentag,
                                                        trunc(v_current_date, 'Month'),
                                                        v_aa_id,
                                                        v_aa_kurzname,
                                                        null, --v_aa_farbe,
                                                        'ZE' );

                    commit;
                end if;
            else
                open c_am; -- Abwesenheitsmeldung
                fetch c_am into
                    v_aa_id,
                    v_aa_kurzname,
                    v_aa_farbe;
                v_found := c_am%found;
                close c_am;
                if v_found then
                    if
                        v_feiertag = 'F'
                        and v_schicht_vorh
                    then
                        insert into pzm_abwes_plan values ( v_pers_nr,
                                                            v_current_date,
                                                            v_feiertag,
                                                            v_wochentag,
                                                            trunc(v_current_date, 'Month'),
                                                            v_aa_id,
                                                            v_aa_kurzname,
                                                            null, --v_aa_farbe,
                                                            'ABWM' );

                        commit;
                    end if;
                else
                    open c_ua; -- Urlaubsantrag
                    fetch c_ua into
                        v_aa_id,
                        v_aa_kurzname,
                        v_aa_farbe;
                    v_found := c_ua%found;
                    close c_ua;
                    if v_found then
                        if
                            v_feiertag = 'F'
                            and v_schicht_vorh
                        then
                            insert into pzm_abwes_plan values ( v_pers_nr,
                                                                v_current_date,
                                                                v_feiertag,
                                                                v_wochentag,
                                                                trunc(v_current_date, 'Month'),
                                                                v_aa_id,
                                                                v_aa_kurzname,
                                                                null, --v_aa_farbe,
                                                                'UA' );

                            commit;
                        end if;
                    end if;

                end if;

            end if;

        end loop;

        close c_pers;
        v_current_date := v_current_date + 1;
    end loop;

end;
/


-- sqlcl_snapshot {"hash":"1f58c58921ad04dc70311495f997379f5b99544c","type":"PROCEDURE","name":"PZM_ABWES_PLAN_VORBEREITEN","schemaName":"DIRKSPZM32","sxml":""}