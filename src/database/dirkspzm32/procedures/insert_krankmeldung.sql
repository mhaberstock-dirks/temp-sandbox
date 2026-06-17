create or replace 
procedure DIRKSPZM32.INSERT_KRANKMELDUNG(p_pers_nr in number,
                                                p_beginn in date,
                                                p_ende in date,
                                                p_aa_id in number,
                                                p_sa_kurzname in varchar2,
                                                p_vorerkrankung in number,
                                                p_erz_pers_nr in number,
                                                p_result out number,
                                                p_res_info out varchar2) is

  CURSOR c_Vorerkrankung IS
    SELECT gesamt_anz_tage
      FROM pzm_abwesenheitsmeldungen
     WHERE km_id = p_vorerkrankung;

  v_AnzTage number;
  v_VorGesamtAnzTage number;
  v_GesamtAnzTage number;
begin
  -- TODO: Prüfen, ob Kollisionen vorhanden sind

  v_AnzTage := (TRUNC(p_ende) - TRUNC(p_beginn)) + 1;
  v_VorGesamtAnzTage := 0;

  if p_vorerkrankung is not NULL then
    OPEN c_Vorerkrankung;

    FETCH c_Vorerkrankung INTO v_VorGesamtAnzTage;

    CLOSE c_Vorerkrankung;
  end if;

  v_GesamtAnzTage := v_AnzTage + v_VorGesamtAnzTage;

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
  ) values (
    null, -- km_id (trigger fügt wert aus sequence ein)
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
    v_AnzTage,
    v_GesamtAnzTage
  );
  commit;

  p_result := 0;
  p_res_info := 'Krankmeldung erfolgreich eingetragen.';
end INSERT_KRANKMELDUNG;
/



-- sqlcl_snapshot {"hash":"7a387ee8c7a2286ece5b2c1c2f1a7b5568e4522e","type":"PROCEDURE","name":"INSERT_KRANKMELDUNG","schemaName":"DIRKSPZM32","sxml":""}