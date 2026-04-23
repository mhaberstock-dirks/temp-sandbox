create or replace function dirkspzm32.get_schicht_zeiten (
    in_pers_nr in number,
    in_datum   in date,
    out_begin  out date,
    out_ende   out date
) return varchar2 is

    result          pzm_schichtarten.sa_kurzname%type;
    cursor c_ze_begin is
    select
        *
    from
        pzm_zeiterfassung tz
    where
            tz.ze_pers_nr = in_pers_nr
        and tz.ze_ist_start <= in_datum
        and   -- muß zwangläufig die Stempelzeit sein !!!
         tz.ze_ist_ende >= in_datum;

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
    v_stempel_zeit := in_datum;
    v_pers_nr := in_pers_nr;

  -- Jetzt hole erst den zugehörigen ZE-Satz
    open c_ze_begin;
    fetch c_ze_begin into v_ze_daten;

  -- Wenn gefunden dann setze Suchdatum auf ZE-Anfangdatum für Schichtsuche !!
    if c_ze_begin%found then
        v_stempel_zeit := v_ze_daten.ze_calc_ist_start; -- 1. Stempelungszeitpunkt an den o. g. Datum holen
        v_schicht_datum := v_ze_daten.ze_schicht_tag;
    end if;

    close c_ze_begin;
    v_result := get_schicht_daten(v_pers_nr, v_stempel_zeit, v_schicht_datum, v_sa_kurzname, v_sa_begin,
                                  v_sa_ende, v_sa_std);

  -- Gueltige Schicht für diese Zeit gefunden dann den begin der Arbeitszeit ab Schichtbegin suchen!!
    if
        v_result = 1
        and ( v_sa_kurzname <> pzm_utils.get_standard_schicht_by_pers_nr(v_pers_nr)
        or v_sa_std = 0 )
    then
        result := v_sa_kurzname;
        out_begin := v_sa_begin;
        out_ende := v_sa_ende;
    else
        result := null;
        out_begin := null;
        out_ende := null;
    end if;

    return ( result );
end;
/


-- sqlcl_snapshot {"hash":"3be78ea4fbd2ea97b3f62959c5b8e995efb24590","type":"FUNCTION","name":"GET_SCHICHT_ZEITEN","schemaName":"DIRKSPZM32","sxml":""}