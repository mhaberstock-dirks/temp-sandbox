create or replace procedure dirkspzm32.insert_krankmeldung (
    p_pers_nr       in number,
    p_beginn        in date,
    p_ende          in date,
    p_aa_id         in number,
    p_sa_kurzname   in varchar2,
    p_vorerkrankung in number,
    p_erz_pers_nr   in number,
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
begin
  -- TODO: Prüfen, ob Kollisionen vorhanden sind

    v_anztage := ( trunc(p_ende) - trunc(p_beginn) ) + 1;
    v_vorgesamtanztage := 0;
    if p_vorerkrankung is not null then
        open c_vorerkrankung;
        fetch c_vorerkrankung into v_vorgesamtanztage;
        close c_vorerkrankung;
    end if;

    v_gesamtanztage := v_anztage + v_vorgesamtanztage;
    insert into pzm_abwesenheitsmeldungen (
        km_id,
        pers_nr,
        beginn,
        ende,
        aa_id,
        sa_kurzname,
        vorerkrankung,
        erz_datum,
        erz_pers_nr,
        aend_datum,
        aend_pers_nr,
        anz_tage,
        gesamt_anz_tage
    ) values ( null, -- km_id (trigger fügt wert aus sequence ein)
               p_pers_nr,
               trunc(p_beginn),
               trunc(p_ende),
               p_aa_id,
               p_sa_kurzname,
               p_vorerkrankung,
               sysdate, -- erz_datum
               p_erz_pers_nr,
               null, -- aend_datum (keine änderung bei erzeugung)
               null, -- aend_pers_nr
               v_anztage,
               v_gesamtanztage );

    commit;
    p_result := 0;
    p_res_info := 'Krankmeldung erfolgreich eingetragen.';
end insert_krankmeldung;
/


-- sqlcl_snapshot {"hash":"3dc87eaeec218c5c147309a2a29bbf2cbb3284f6","type":"PROCEDURE","name":"INSERT_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}