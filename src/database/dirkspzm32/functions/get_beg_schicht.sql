create or replace 
function DIRKSPZM32.get_beg_schicht(p_pers_nr in number, p_datum in date) return date is
  Result date;

  CURSOR c_ZE_Begin IS
  SELECT *
    FROM pzm_zeiterfassung tz
    WHERE tz.ze_pers_nr = p_pers_nr AND
        tz.ze_ist_start <= p_datum AND   -- muß zwangläufig die Stempelzeit sein !!!
        tz.ze_ist_ende >= p_datum;

  v_sa_begin       date;
  v_sa_ende        date;

  v_ze_daten       pzm_zeiterfassung%rowtype;
  v_sa_kurzname    pzm_schichtarten.sa_kurzname%type;

  v_sa_std         number;
  v_stempel_zeit   date;
  v_schicht_datum  date;
  v_pers_nr        number(6);
  v_result         integer;
begin

  v_stempel_zeit := p_datum;
  v_pers_nr := p_pers_nr;
  v_sa_kurzname := NULL;

  -- Jetzt hole erst den zugehörigen ZE-Satz
  OPEN c_ZE_Begin;

  FETCH c_ZE_Begin INTO v_ze_daten;

  -- Wenn gefunden dann setze Suchdatum auf ZE-Anfangdatum für Schichtsuche !!
  if c_ze_Begin%FOUND then
    v_stempel_zeit := v_ze_daten.ze_calc_ist_start;
    v_schicht_datum := v_ze_daten.ze_schicht_tag;
    if v_schicht_datum is not NULL then
      v_sa_kurzname := v_ze_daten.ze_sa_kurzname;
    end if;
  end if;

  CLOSE c_ZE_Begin;

  v_result := GET_SCHICHT_DATEN(v_pers_nr,
                                v_stempel_zeit,
                                v_schicht_datum,
                                v_Sa_Kurzname,
                                v_sa_begin,
                                v_sa_ende,
                                v_sa_std);

  -- Gueltige Schicht für diese Zeit gefunden dann den begin der Arbeitszeit ab Schichtbegin suchen!!
  if v_result = 1 then
     Result := v_sa_begin;
  else
     Result := NULL;
  end if;
  return(Result);
end;
/



-- sqlcl_snapshot {"hash":"f92fdb4ca0e9eba7102c3ac0600fbd0008358b4e","type":"FUNCTION","name":"GET_BEG_SCHICHT","schemaName":"DIRKSPZM32","sxml":""}