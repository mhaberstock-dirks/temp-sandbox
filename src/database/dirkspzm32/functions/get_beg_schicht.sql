create or replace function dirkspzm32.get_beg_schicht (
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
        and   -- muß zwangläufig die Stempelzeit sein !!!
         tz.ze_ist_ende >= p_datum;

    v_sa_begin      date;
    v_sa_ende       date;
    v_ze_daten      pzm_zeiterfassung%rowtype;
    v_sa_kurzname   pzm_schichtarten.sa_kurzname%type;
    v_sa_std        number;
    v_stempel_zeit  date;
    v_schicht_datum date;
    v_pers_nr       number(6);
    v_result        integer;
begin
    v_stempel_zeit := p_datum;
    v_pers_nr := p_pers_nr;
    v_sa_kurzname := null;

  -- Jetzt hole erst den zugehörigen ZE-Satz
    open c_ze_begin;
    fetch c_ze_begin into v_ze_daten;

  -- Wenn gefunden dann setze Suchdatum auf ZE-Anfangdatum für Schichtsuche !!
    if c_ze_begin%found then
        v_stempel_zeit := v_ze_daten.ze_calc_ist_start;
        v_schicht_datum := v_ze_daten.ze_schicht_tag;
        if v_schicht_datum is not null then
            v_sa_kurzname := v_ze_daten.ze_sa_kurzname;
        end if;
    end if;

    close c_ze_begin;
    v_result := get_schicht_daten(v_pers_nr, v_stempel_zeit, v_schicht_datum, v_sa_kurzname, v_sa_begin,
                                  v_sa_ende, v_sa_std);

  -- Gueltige Schicht für diese Zeit gefunden dann den begin der Arbeitszeit ab Schichtbegin suchen!!
    if v_result = 1 then
        result := v_sa_begin;
    else
        result := null;
    end if;

    return ( result );
end;
/


-- sqlcl_snapshot {"hash":"9151d6376ff48f6dfeca26e5cfabf0dd18d26c30","type":"FUNCTION","name":"GET_BEG_SCHICHT","schemaName":"DIRKSPZM32","sxml":""}