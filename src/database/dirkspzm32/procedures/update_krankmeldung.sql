create or replace 
procedure DIRKSPZM32.UPDATE_KRANKMELDUNG(p_km_id in number,
                                                p_beginn in date,
                                                p_ende in date,
                                                p_aa_id in number,
                                                p_sa_kurzname in varchar2,
                                                p_vorerkrankung in number,
                                                p_aend_pers_nr in number,
                                                p_result out number,
                                                p_res_info out varchar2) is

  CURSOR c_Vorerkrankung IS
    SELECT gesamt_anz_tage
      FROM pzm_abwesenheitsmeldungen
     WHERE km_id = p_vorerkrankung;

  v_AnzTage number;
  v_VorGesamtAnzTage number;
  v_GesamtAnzTage number;

  CURSOR c_Krankmeldungen IS
    SELECT * FROM pzm_abwesenheitsmeldungen WHERE km_id = p_km_id
       FOR UPDATE OF beginn,
                     ende,
                     aa_id,
                     sa_kurzname,
                     vorerkrankung,
                     aend_datum,
                     aend_pers_nr,
                     anz_tage,
                     gesamt_anz_tage;

  v_Krankmeldung pzm_abwesenheitsmeldungen%ROWTYPE;
  v_Changed boolean;
begin
  p_result := -1;
  p_res_info := 'Keine Änderungen zum Speichern vorhanden';
  v_Changed := false;

  -- TODO: Prüfen, ob Kollisionen für den neuen Zeitraum vorhanden sind

  v_AnzTage := (TRUNC(p_ende) - TRUNC(p_beginn)) + 1;
  v_VorGesamtAnzTage := 0;

  if p_vorerkrankung is not NULL then
    OPEN c_Vorerkrankung;

    FETCH c_Vorerkrankung INTO v_VorGesamtAnzTage;

    CLOSE c_Vorerkrankung;
  end if;

  v_GesamtAnzTage := v_AnzTage + v_VorGesamtAnzTage;

  OPEN c_Krankmeldungen;

  FETCH c_Krankmeldungen INTO v_Krankmeldung;

  if c_Krankmeldungen%NOTFOUND then
    p_result := 1;
    p_res_info := 'Der Datensatz für die Änderungen konnte nicht gefunden werden.';
    CLOSE c_Krankmeldungen;
    return;
  end if;

  if p_beginn is not NULL AND not (v_Krankmeldung.beginn = TRUNC(p_beginn)) then
    UPDATE pzm_abwesenheitsmeldungen
       SET beginn = TRUNC(p_beginn)
     WHERE CURRENT OF c_Krankmeldungen;
    v_Changed := true;
  end if;

  if p_ende is not NULL AND not (v_Krankmeldung.ende = TRUNC(p_ende)) then
    UPDATE pzm_abwesenheitsmeldungen
       SET ende = TRUNC(p_ende)
     WHERE CURRENT OF c_Krankmeldungen;
    v_Changed := true;
  end if;

  if p_aa_id is not NULL AND not (v_Krankmeldung.aa_id = p_aa_id) then
    UPDATE pzm_abwesenheitsmeldungen
       SET aa_id = p_aa_id
     WHERE CURRENT OF c_Krankmeldungen;
    v_Changed := true;
  end if;

  if NVL(v_Krankmeldung.sa_kurzname, '') <> NVL(p_sa_kurzname, '') then
    UPDATE pzm_abwesenheitsmeldungen
       SET sa_kurzname = p_sa_kurzname
     WHERE CURRENT OF c_Krankmeldungen;
    v_Changed := true;
  end if;

  if NVL(v_Krankmeldung.vorerkrankung, -1) <> NVL(p_vorerkrankung, -1) then
    UPDATE pzm_abwesenheitsmeldungen
       SET vorerkrankung = p_vorerkrankung
     WHERE CURRENT OF c_Krankmeldungen;
    v_Changed := true;
  end if;

  if v_Changed then
    UPDATE pzm_abwesenheitsmeldungen SET
           aend_datum = SYSDATE,
           aend_pers_nr = p_aend_pers_nr,
           anz_tage = v_AnzTage,
           gesamt_anz_tage = v_GesamtAnzTage
     WHERE CURRENT OF c_Krankmeldungen;
    p_result := 0;
    p_res_info := 'Die Änderungen wurden gespeichert.';
  end if;

  CLOSE c_Krankmeldungen;

  COMMIT;

  -- TODO: Prüfen, ob in der Zeiterfassung offene Abwesenheiten in dem Zeitraum der
  --       Krankmeldung vorhanden sind. Wenn ja, dann ggf die Abwesenheitsart und Schicht
  --       übernehmen

end UPDATE_KRANKMELDUNG;
/



-- sqlcl_snapshot {"hash":"50ac60ba0757d8f1cdf9daa025c98dc0ec8bf19a","type":"PROCEDURE","name":"UPDATE_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}