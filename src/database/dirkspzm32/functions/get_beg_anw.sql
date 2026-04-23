create or replace function dirkspzm32.get_beg_anw (
    p_pers_nr in number,
    p_datum   in date
) return date is

    result          date;
    cursor c_ze_begin is
    select
        *
    from
        pzm_zeiterfassung tz
    where
            tz.ze_pers_nr = p_pers_nr
        and tz.ze_ist_start <= p_datum
        and tz.ze_ist_ende >= p_datum;

    v_sa_begin      date;
    v_sa_ende       date;
    cursor c_begin_anw is
    select
        min(t1.ze_calc_ist_start)
    from
        pzm_zeiterfassung t1
    where
            t1.ze_pers_nr = p_pers_nr
        and t1.ze_calc_ist_start >= v_sa_begin
        and t1.ze_calc_ist_start <= v_sa_ende
        and t1.ze_status = 2;

    v_ze_daten      pzm_zeiterfassung%rowtype;
    v_sa_kurzname   pzm_schichtarten.sa_kurzname%type;
    v_sa_std        number;
    v_stempel_zeit  date;
    v_schicht_datum date;
    v_pers_nr       number(6);
    v_zestart       date;
    v_daystart      date;
    v_result        integer;
begin
    v_stempel_zeit := p_datum;
    v_pers_nr := p_pers_nr;

  -- Jetzt hole erst den zugehörigen ZE-Satz
    open c_ze_begin;
    fetch c_ze_begin into v_ze_daten;

  -- Wenn gefunden dann setze Suchdatum auf ZE-Anfangdatum für Schichtsuche !!
    if c_ze_begin%found then
        v_stempel_zeit := v_ze_daten.ze_calc_ist_start;
        v_schicht_datum := v_ze_daten.ze_schicht_tag;
    end if;

    close c_ze_begin;
    v_result := get_schicht_daten(v_pers_nr, v_stempel_zeit, v_schicht_datum, v_sa_kurzname, v_sa_begin,
                                  v_sa_ende, v_sa_std);

  -- Gueltige Schicht für diese Zeit gefunden dann den begin der Arbeitszeit ab Schichtbegin suchen!!
    if v_result != 1 then
        v_sa_begin := trunc(v_stempel_zeit);
        v_sa_ende := trunc(v_stempel_zeit) + 1 - 1 / 86400;
    end if;

  -- Jetzt suchen wir den Ersten Eintrag an dem er anwesend war!!
    open c_begin_anw;
    fetch c_begin_anw into v_daystart;
    if c_begin_anw%notfound then
        result := null;
    else
        result := v_daystart;
    end if;

    close c_begin_anw;
    return ( result );
end get_beg_anw;
/


-- sqlcl_snapshot {"hash":"c1ec86fe8f3e9217cd71f14829c2335907f08466","type":"FUNCTION","name":"GET_BEG_ANW","schemaName":"DIRKSPZM32","sxml":""}