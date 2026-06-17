create or replace 
function DIRKSPZM32.get_schicht_zeiten(in_pers_nr in number,
                                              in_datum in date,
                                              out_begin out date,
                                              out_ende out date) return varchar2 is
  Result pzm_schichtarten.sa_kurzname%type;

  CURSOR c_ZE_Begin IS
  SELECT *
    FROM pzm_zeiterfassung tz
    WHERE tz.ze_pers_nr = in_pers_nr AND
        tz.ze_ist_start <= in_datum AND   -- muß zwangläufig die Stempelzeit sein !!!
        tz.ze_ist_ende >= in_datum;

  v_sa_begin       date;
  v_sa_ende        date;

  v_ze_daten       pzm_zeiterfassung%rowtype;
  v_Sa_Kurzname    pzm_schichtarten.sa_kurzname%type;

  v_sa_std         number;
  v_stempel_zeit   date;
  v_schicht_datum  date;
  v_pers_nr        number(6);
  v_result         integer;
begin

  v_stempel_zeit := in_datum;
  v_pers_nr := in_pers_nr;

  -- Jetzt hole erst den zugehörigen ZE-Satz
  OPEN c_ZE_Begin;

  FETCH c_ZE_Begin INTO v_ze_daten;

  -- Wenn gefunden dann setze Suchdatum auf ZE-Anfangdatum für Schichtsuche !!
  if c_ze_Begin%FOUND then
    v_stempel_zeit := v_ze_daten.ze_calc_ist_start; -- 1. Stempelungszeitpunkt an den o. g. Datum holen
    v_schicht_datum := v_ze_daten.ze_schicht_tag;
  end if;

  CLOSE c_ZE_Begin;


  v_result := GET_SCHICHT_DATEN(v_pers_nr,
                                v_stempel_zeit,
                                v_schicht_datum,
                                v_sa_kurzname,
                                v_sa_begin,
                                v_sa_ende,
                                v_sa_std);

  -- Gueltige Schicht für diese Zeit gefunden dann den begin der Arbeitszeit ab Schichtbegin suchen!!
  if v_result = 1 
  and (v_sa_kurzname <> pzm_utils.get_standard_schicht_by_pers_nr(v_pers_nr)
       or v_sa_std = 0
      ) 
  then
     Result := v_sa_kurzname;
     out_begin := v_sa_begin;
     out_ende := v_sa_ende;
  else
     Result := NULL;
     out_begin := NULL;
     out_ende := NULL;
  end if;
  return(Result);
end;
/



-- sqlcl_snapshot {"hash":"bdf3d3907bbe083c594ce79ccef041ad2a6d196b","type":"FUNCTION","name":"GET_SCHICHT_ZEITEN","schemaName":"DIRKSPZM32","sxml":""}