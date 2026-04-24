create or replace function dirkspzm32.get_pers_pause_std (
    in_pers_nr     in pzm_personal.pers_nr%type,
    in_schicht_tag in date,
    in_sa_kurzname in pzm_schichtarten.sa_kurzname%type,
    in_von_zeit    in date,
    in_bis_zeit    in date
) return number is

    status_pause     constant number := 4;
    v_tagessatz      pzm_ze_tagessatz%rowtype;
    cursor c_tagessatz is
    select
        t.*
    from
        pzm_ze_tagessatz t
    where
            t.ts_pers_nr = in_pers_nr
        and t.ts_datum = in_schicht_tag;

    v_ze_pausen      pzm_zeiterfassung%rowtype;
    cursor c_ze_pausen is
    select
        t.*
    from
        pzm_zeiterfassung t
    where
            t.ze_pers_nr = in_pers_nr
        and t.ze_schicht_tag = in_schicht_tag
        and t.ze_std > 0
        and t.ze_status = status_pause
    order by
        t.ze_calc_ist_start,
        t.ze_id;

    v_bez_pause      number;
  --v_unb_pause number;
    v_unb_pause_diff number;
    v_found          boolean;
    v_result         number;
begin
  -- feste Pausen berücksichtigen
    v_result := get_pause_time(in_sa_kurzname,
                               in_von_zeit,
                               in_bis_zeit,
                               get_pers_pb_id(in_pers_nr));
    v_bez_pause := 0;
  --v_unb_pause := 0;

  -- keine feste Pausen definiert?
    if v_result = 0 then
        open c_tagessatz;
        fetch c_tagessatz into v_tagessatz;
        v_found := c_tagessatz%found;
        close c_tagessatz;
        if v_found then
      -- abziehbare Pausen vorhanden?
            if nvl(v_tagessatz.ts_day_pause_std, 0) > 0 then
                open c_ze_pausen;
                loop
                    fetch c_ze_pausen into v_ze_pausen;
                    exit when c_ze_pausen%notfound;
                    v_unb_pause_diff := 0;
                    if
                        nvl(v_tagessatz.ts_day_pause_bez_std, 0) > 0
                        and v_bez_pause < v_tagessatz.ts_day_pause_bez_std
                    then
            -- bezahlte Pausen ignorieren
                        v_bez_pause := v_bez_pause + v_ze_pausen.ze_std;
                        if v_bez_pause > v_tagessatz.ts_day_pause_bez_std then
              -- diese Pause geht aus dem bezahlten in den unbezahlten Bereich über
                            v_unb_pause_diff := v_bez_pause - v_tagessatz.ts_day_pause_bez_std;
                            v_bez_pause := v_tagessatz.ts_day_pause_bez_std;
              -- Pausenstartzeit für weitere Berechnungen auf die unbezahlte Zeit korrigieren
                            v_ze_pausen.ze_calc_ist_start := v_ze_pausen.ze_calc_ist_ende - v_unb_pause_diff / 24;
                        end if;

                    else
            -- komplett unbezahlt
                        v_unb_pause_diff := v_ze_pausen.ze_std;
                    end if;

                    if v_unb_pause_diff > 0 then
                        if  /* Kollision 1 */ (
                            v_ze_pausen.ze_calc_ist_start <= in_von_zeit
                            and v_ze_pausen.ze_calc_ist_ende > in_von_zeit
                        )
                        or
                /* Kollision 2 */ (
                            v_ze_pausen.ze_calc_ist_start < in_bis_zeit
                            and v_ze_pausen.ze_calc_ist_ende >= in_bis_zeit
                        )
                        or
                /* Kollision 3 */ (
                            v_ze_pausen.ze_calc_ist_start <= in_von_zeit
                            and v_ze_pausen.ze_calc_ist_ende >= in_bis_zeit
                        )
                        or
                /* Kollision 4 */ (
                            v_ze_pausen.ze_calc_ist_start >= in_von_zeit
                            and v_ze_pausen.ze_calc_ist_ende <= in_bis_zeit
                        ) then
              -- nur bei Überlappungen (Kollisionen) wird die Pause berechnet
                            v_result := v_result + v_unb_pause_diff;
                            if v_ze_pausen.ze_calc_ist_start < in_von_zeit then
                -- dise Pause ist zum Teil nicht in dem abgefragten Zeitraum
                                v_result := v_result - ( in_von_zeit - v_ze_pausen.ze_calc_ist_start ) * 24;
                            elsif v_ze_pausen.ze_calc_ist_ende > in_bis_zeit then
                -- dise Pause ist zum Teil nicht in dem abgefragten Zeitraum
                                v_result := v_result - ( v_ze_pausen.ze_calc_ist_ende - in_bis_zeit ) * 24;
                            end if;

                        end if;
                    end if;

                end loop;

                close c_ze_pausen;
            end if;
        end if;

    end if;

    v_unb_pause_diff := get_pause_time_day(in_sa_kurzname,
                                           in_von_zeit,
                                           in_bis_zeit,
                                           (in_bis_zeit - in_von_zeit) * 24,
                                           v_result,
                                           get_pers_pb_id(in_pers_nr),
                                           v_bez_pause);

    if nvl(v_result, 0) < nvl(v_unb_pause_diff, 0) then
        v_result := v_unb_pause_diff;
    end if;

    return ( v_result );
end get_pers_pause_std;
/


-- sqlcl_snapshot {"hash":"fd54d8d9e04b776cff3c347008260c5d3879d9b1","type":"FUNCTION","name":"GET_PERS_PAUSE_STD","schemaName":"DIRKSPZM32","sxml":""}