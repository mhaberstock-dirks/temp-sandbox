create or replace procedure dirkspzm32.update_krankmeldung (
    p_km_id         in number,
    p_beginn        in date,
    p_ende          in date,
    p_aa_id         in number,
    p_sa_kurzname   in varchar2,
    p_vorerkrankung in number,
    p_aend_pers_nr  in number,
    p_result        out number,
    p_res_info      out varchar2
) is

    cursor c_vorerkrankung is
    select
        gesamt_anz_tage
    from
        pzm_abwesenheitsmeldungen
    where
        km_id = p_vorerkrankung;

    v_anztage          number;
    v_vorgesamtanztage number;
    v_gesamtanztage    number;
    cursor c_krankmeldungen is
    select
        *
    from
        pzm_abwesenheitsmeldungen
    where
        km_id = p_km_id
    for update of beginn,
                  ende,
                  aa_id,
                  sa_kurzname,
                  vorerkrankung,
                  aend_datum,
                  aend_pers_nr,
                  anz_tage,
                  gesamt_anz_tage;

    v_krankmeldung     pzm_abwesenheitsmeldungen%rowtype;
    v_changed          boolean;
begin
    p_result := -1;
    p_res_info := 'Keine Änderungen zum Speichern vorhanden';
    v_changed := false;

  -- TODO: Prüfen, ob Kollisionen für den neuen Zeitraum vorhanden sind

    v_anztage := ( trunc(p_ende) - trunc(p_beginn) ) + 1;
    v_vorgesamtanztage := 0;
    if p_vorerkrankung is not null then
        open c_vorerkrankung;
        fetch c_vorerkrankung into v_vorgesamtanztage;
        close c_vorerkrankung;
    end if;

    v_gesamtanztage := v_anztage + v_vorgesamtanztage;
    open c_krankmeldungen;
    fetch c_krankmeldungen into v_krankmeldung;
    if c_krankmeldungen%notfound then
        p_result := 1;
        p_res_info := 'Der Datensatz für die Änderungen konnte nicht gefunden werden.';
        close c_krankmeldungen;
        return;
    end if;

    if
        p_beginn is not null
        and not ( v_krankmeldung.beginn = trunc(p_beginn) )
    then
        update pzm_abwesenheitsmeldungen
        set
            beginn = trunc(p_beginn)
        where
            current of c_krankmeldungen;

        v_changed := true;
    end if;

    if
        p_ende is not null
        and not ( v_krankmeldung.ende = trunc(p_ende) )
    then
        update pzm_abwesenheitsmeldungen
        set
            ende = trunc(p_ende)
        where
            current of c_krankmeldungen;

        v_changed := true;
    end if;

    if
        p_aa_id is not null
        and not ( v_krankmeldung.aa_id = p_aa_id )
    then
        update pzm_abwesenheitsmeldungen
        set
            aa_id = p_aa_id
        where
            current of c_krankmeldungen;

        v_changed := true;
    end if;

    if nvl(v_krankmeldung.sa_kurzname, '') <> nvl(p_sa_kurzname, '') then
        update pzm_abwesenheitsmeldungen
        set
            sa_kurzname = p_sa_kurzname
        where
            current of c_krankmeldungen;

        v_changed := true;
    end if;

    if nvl(v_krankmeldung.vorerkrankung, -1) <> nvl(p_vorerkrankung, -1) then
        update pzm_abwesenheitsmeldungen
        set
            vorerkrankung = p_vorerkrankung
        where
            current of c_krankmeldungen;

        v_changed := true;
    end if;

    if v_changed then
        update pzm_abwesenheitsmeldungen
        set
            aend_datum = sysdate,
            aend_pers_nr = p_aend_pers_nr,
            anz_tage = v_anztage,
            gesamt_anz_tage = v_gesamtanztage
        where
            current of c_krankmeldungen;

        p_result := 0;
        p_res_info := 'Die Änderungen wurden gespeichert.';
    end if;

    close c_krankmeldungen;
    commit;

  -- TODO: Prüfen, ob in der Zeiterfassung offene Abwesenheiten in dem Zeitraum der
  --       Krankmeldung vorhanden sind. Wenn ja, dann ggf die Abwesenheitsart und Schicht
  --       übernehmen
end update_krankmeldung;
/


-- sqlcl_snapshot {"hash":"d8f8e938c8420adb5ed3a0bff2ee05466eed369d","type":"PROCEDURE","name":"UPDATE_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}