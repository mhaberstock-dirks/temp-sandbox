create or replace 
function DIRKSPZM32.get_end_anw(p_pers_nr in number,
                                       p_datum in date
                                      ) return date is
  Result date;
  CURSOR c_ZE_Begin IS
  SELECT *
    FROM pzm_zeiterfassung tz
    WHERE tz.ze_pers_nr = p_pers_nr AND
        tz.ze_ist_start <= p_datum AND
        tz.ze_ist_ende >= p_datum;

  v_sa_begin       date;
  v_sa_ende        date;

  CURSOR c_Begin_Anw IS
    SELECT max(t1.ze_calc_ist_ende)
      FROM pzm_zeiterfassung t1
     WHERE t1.ze_pers_nr = p_pers_nr AND
           t1.ze_calc_ist_start >= v_sa_begin AND
           t1.ze_calc_ist_start <= v_sa_ende AND
           t1.ze_status = 2;

  v_ze_daten       pzm_zeiterfassung%rowtype;
  v_Sa_Kurzname    pzm_schichtarten.sa_kurzname%type;

  v_sa_std         number;
  v_stempel_zeit   date;
  v_schicht_datum  date;
  v_pers_nr        number(6);
  v_DayEnde        date;
  v_result         integer;
begin

  v_stempel_zeit := p_datum;
  v_pers_nr := p_pers_nr;

  -- Jetzt hole erst den zugehörigen ZE-Satz
  OPEN c_ZE_Begin;

  FETCH c_ZE_Begin INTO v_ze_daten;

  -- Wenn gefunden dann setze Suchdatum auf ZE-Anfangdatum für Schichtsuche !!
  if c_ze_Begin%FOUND then
    v_stempel_zeit := v_ze_daten.ze_calc_ist_start;
    v_schicht_datum := v_ze_daten.ze_schicht_tag;
  end if;

  CLOSE c_ZE_Begin;


  v_result := get_schicht_daten(v_pers_nr,
                                v_stempel_zeit,
                                v_schicht_datum,
                                v_Sa_Kurzname,
                                v_sa_begin,
                                v_sa_ende,
                                v_sa_std);

  -- Gueltige Schicht für diese Zeit gefunden dann den begin der Arbeitszeit ab Schichtbegin suchen!!
  if v_result != 1 then
     v_sa_begin := trunc(v_stempel_zeit);
     v_sa_ende  := trunc(v_stempel_zeit) + 1 - 1 / 86400;
  end if;

  -- Jetzt suchen wir den Ersten Eintrag an dem er anwesend war!!
  OPEN c_Begin_Anw;

  FETCH c_Begin_Anw INTO v_DayEnde;

  if c_Begin_Anw%NOTFOUND then
    Result := NULL;
  else
    Result := v_DayEnde;
  end if;

  CLOSE c_Begin_Anw;

  return(Result);
end GET_END_ANW;
/



-- sqlcl_snapshot {"hash":"70ebf44b8a0a519c4174ee766ca3ac58d4180939","type":"FUNCTION","name":"GET_END_ANW","schemaName":"DIRKSPZM32","sxml":""}