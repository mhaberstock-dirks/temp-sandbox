create or replace function dirkspzm32.get_anz_arbeitstage_r32 (
    p_pers_nr     in integer,
    p_start_datum in date,
    p_ende_datum  in date
) return number is

    result           number(15, 1);
    i                integer;
    tage             integer;
    v_sakurzname     varchar2(10);
    v_sabeginn       date;
    v_saende         date;
    v_sastdprotag    number(4, 2);
    v_datum          date;
    v_dayofweek      integer;
    v_sonderfeiertag varchar2(20);
    v_isfeiertag     boolean;
    v_pers_nr        number;
    v_pb_id          number;
    v_abt_id         number;
    v_kst_id         number;
    cursor c_pers is
    select
        t.pers_nr,
        t.pers_pb_id,
        t.pers_abt_id,
        t.pers_kst_id
    from
        pzm_personal t
    where
        t.pers_nr = p_pers_nr;

begin
    result := 0;
    open c_pers;
    fetch c_pers into
        v_pers_nr,
        v_pb_id,
        v_abt_id,
        v_kst_id;
    close c_pers;
    if v_kst_id is null then
        v_kst_id := get_pers_kst_id(v_pers_nr);
    end if;
    if v_pb_id is null then
        v_pb_id := get_pers_pb_id(v_pers_nr);
    end if;
    tage := ( trunc(p_ende_datum) - trunc(p_start_datum) );
    for i in 0..tage loop
        v_datum := p_start_datum + i;
        v_sakurzname := null;
        if get_schicht_daten(p_pers_nr, v_datum, v_datum, v_sakurzname, v_sabeginn,
                             v_saende, v_sastdprotag) = 1 then
            v_isfeiertag := ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_datum,
                                         v_sonderfeiertag) = 1;

            if
                not v_isfeiertag
                and v_sakurzname <> pzm_utils.get_standard_schicht_by_pers_nr(v_pers_nr)
                and v_sastdprotag > 0
            then
                result := result + 1.0;
        -- DKr - F90080-107 - Heiligabend und Silvester sind in DE halbe Feiertage -> halbe Urlaubstage moglich
            elsif
                v_isfeiertag
                and ( v_sakurzname <> pzm_utils.get_standard_schicht_by_pers_nr(v_pers_nr)
                or v_sastdprotag = 0 )
                and ( to_char(v_datum, 'dd.mm.') = '24.12.'
                or to_char(v_datum, 'dd.mm.') = '31.12.' )
            then
                result := result + 0.5;
            end if;

        else
      -- wenn keine Schichtdaten vohanden sind, nehmen wir die 5 Werktage Woche
      --v_DayOfWeek := to_number(to_char(v_Datum, 'D')); -- INFO: 1 = Mo, 2 = Di, ...
            v_dayofweek := isi_utils.iso_weekday(v_datum);-- INFO: 1 = Mo, 2 = Di, ...

            if
                ( v_dayofweek >= 1 )
                and ( v_dayofweek <= 5 )
            then
                if ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_datum,
                                v_sonderfeiertag) = 0 then
                    result := result + 1.0;
          -- DKr - F90080-107 - Heiligabend und Silvester sind in DE halbe Feiertage -> halbe Urlaubstage moglich
                elsif
                    ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_datum,
                                 v_sonderfeiertag) = 1
                    and ( to_char(v_datum, 'dd.mm.') = '24.12.'
                    or to_char(v_datum, 'dd.mm.') = '31.12.' )
                then
                    result := result + 0.5;
                end if;

            end if;

        end if;

    end loop;

    return ( result );
end;
/


-- sqlcl_snapshot {"hash":"5ff3507c435648692845c20fe089679d11b827d3","type":"FUNCTION","name":"GET_ANZ_ARBEITSTAGE_R32","schemaName":"DIRKSPZM32","sxml":""}