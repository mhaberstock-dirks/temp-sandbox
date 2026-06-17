create or replace 
function DIRKSPZM32.get_schicht_daten(
  p_pers_nr in integer,           --# Personalnummer des Mitarbeiters für den die Schichtdaten geladen werden sollen
  p_stempel_zeit in date,         --# Zeitpunkt, auf dessen Basis die Schichtart und der Schichttag ermittelt werden
  p_schicht_datum in out date,    --# [optional/out] Übegabe eines Schichtdatums oder Rückgabe des ermittelten Schichtdatums
  p_sa_kurzname in out varchar2,  --# [optional/out] Übergabe der Schichtart oder Rückgabe der ermittelten Schichtart
  p_sa_beginn out date,           --# [out] Rückgabe der Uhrzeit für den Schichtbeginn (Schichtdatum als Basis)
  p_sa_ende out date,             --# [out] Rückgabe der Uhrzeit für das Schichtende (Schichtdatum als Basis)
  p_sa_std out number,            --# [out] Gesamtstunden der Schicht (berücksichtigt die durchschn. Arbeitsstd. p. Woche)
  p_zaehler in number default 0   --# Rekursionszähler, um Endlos-Rekursionen zu verhindern
) return integer is               --# Return: 0 = keine Schicht ermittelt, 1 = Schicht erfolgreich ermittelt
------------------------------------------------------------------------------------------------
--# Diese Funktion ermittelt die passende Schichtart und das Schichtdatum für einen Mitarbeiter
--# auf Basis der übergebenen Stempelzeit. Wenn die Schichtart und das Schichtdatum ermittelt
--# oder direkt übergeben wurden, werden Schichtbeginn, -ende und Gesamtstunden zurückggegeben.
--# Dabei wird bei Gleitzeit automatisch die Stempelzeit als Schichtbeginn übernommen, es sei
--# denn die Rahmenzeit der Gleitzeitschicht wurde überschritten. In dem Fall wird der
--# Schichtbeginn auf die Rahmenzeit gesetzt.
------------------------------------------------------------------------------------------------

  Result           integer;
  --v_SMName         pzm_personal_details.pd_sm_name%type;
  v_Kurzname       pzm_schichtarten.sa_kurzname%type;
  v_DayOfWeek      integer;
  v_schicht_modell pzm_schicht_modelle%rowtype;
  v_schichtart     pzm_schichtarten%rowtype;

  type T_CommonCursorRef is ref cursor;
  c_SchichtPerioden T_CommonCursorRef;

  v_sa_begin       date;
  v_sa_ende        date;
  v_sa_kurzname    pzm_schichtarten.sa_kurzname%type;
  v_sa_std         number;
  v_schicht_datum  date;

  v_merk_sa_kurzname pzm_schichtarten.sa_kurzname%type;
  v_merk_sa_begin    date;

  v_diff_akt       number;
  v_diff_merk      number;

  v_schicht_datum_vorgabe boolean;
begin
  Result := 0;

  if p_zaehler >= 2
  then
    return (Result);
  end if;

  if p_stempel_zeit is NULL
  then
    return(Result);
  end if;

  v_schicht_datum_vorgabe := true;
  if p_schicht_datum is null
  then
    p_schicht_datum := trunc(p_stempel_zeit);
    v_schicht_datum_vorgabe := false;
  end if;

  -- 1. Personaldaten holen
  if not pzm_p_base.get_schicht_modell(p_pers_nr, v_schicht_modell) 
  then
    -- keine Schichtzuweisung bei den Personaldaten gefunden
    return(Result);
  end if;

  if p_sa_kurzname is not null
  then
    -- Es ist bereits eine Schicht in der ZEITERFASSUNGSSATZ gefunden oder Gesetzt worden
    -- ACHTUNG !!!! Dann gilt die gesetzte Schicht, auch wenn es von der zeit nicht passt !!!!

    if p_schicht_datum is null
    then
      v_schicht_datum := null;
      v_sa_kurzname := null;
      Result := get_schicht_daten(p_pers_nr,
                                  p_stempel_zeit,
                                  v_schicht_datum,
                                  v_sa_kurzname,
                                  v_sa_begin,
                                  v_sa_ende,
                                  v_sa_std,
                                  nvl(p_zaehler, 0) + 1);

      if Result = 1
      then
        p_schicht_datum := v_schicht_datum;
      end if;
    end if;

    Result := is_schichtart_in_time(p_sa_kurzname,
                                    p_stempel_zeit,
                                    p_schicht_datum,
                                    v_schicht_modell.d_arb_std_pro_tag,
                                    p_sa_beginn,
                                    p_sa_ende,
                                    p_sa_std);

    if Result != 1
    then
      -- wir sind gezwungen, die schicht zu nehmen, da sie mögl. weise von hand gesetzt wurde
      Result := 1;
    end if;
    return(Result);
  end if;

  -- 2. Wochentag herausfinden
  -- Buggy BWE   v_DayOfWeek := to_number(to_char(p_schicht_datum, 'D')); -- INFO: 1 = Mo, 2 = Di, ...
  --v_DayOfWeek = trunc(p_schicht_datum), - , get_schicht_daten
  v_DayOfWeek := isi_utils.Iso_WeekDay(nvl(p_schicht_datum, SYSDATE)); -- 1 = Mo, 2 = Di, ...
  -- 2a. Schichtperioden durchgehen, und schauen, ob an dem gegebenen Wochentag die
  --     Schichtzeiten mit den registrierten Zeiten übereinstimmen
  if v_DayOfWeek = 1  -- Mo
  then
    open c_SchichtPerioden for
      select sp_sa_wot_mo
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  elsif v_DayOfWeek = 2 -- Di
  then
    open c_SchichtPerioden for
      select sp_sa_wot_di
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  elsif v_DayOfWeek = 3 -- Mi
  then
    open c_SchichtPerioden for
      select sp_sa_wot_mi
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  elsif v_DayOfWeek = 4
  then
    open c_SchichtPerioden for
      select sp_sa_wot_do
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  elsif v_DayOfWeek = 5
  then
    open c_SchichtPerioden for
      select sp_sa_wot_fr
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  elsif v_DayOfWeek = 6
  then
    open c_SchichtPerioden for
      select sp_sa_wot_sa
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  elsif v_DayOfWeek = 7
  then
    open c_SchichtPerioden for
      select sp_sa_wot_so
        from pzm_schicht_perioden
       where sp_sm_name = v_schicht_modell.sm_name;
  end if;

  v_merk_sa_kurzname := null;
  loop -- jede angelegte Woche durchlaufen
    exit when not c_SchichtPerioden%isopen;

    fetch c_SchichtPerioden into v_Kurzname;
    exit when c_SchichtPerioden%notfound;

    if v_Kurzname is not null
    then
      result := is_schichtart_in_time(v_Kurzname,
                                      p_stempel_zeit,
                                      p_schicht_datum,
                                      v_schicht_modell.d_arb_std_pro_tag,
                                      p_sa_beginn,
                                      p_sa_ende,
                                      p_sa_std);

      if result = 1
      then
        if v_merk_sa_kurzname is null
        then
          v_merk_sa_kurzname := v_Kurzname;
          v_merk_sa_begin := p_sa_beginn;
        else
          v_diff_akt := p_stempel_zeit - p_sa_beginn;
          v_diff_merk := p_stempel_zeit - v_merk_sa_begin;

           -- MWe 2018.05.16 Ticket:P70460-14
          if pzm_p_base.get_schichtart_by_uix(v_Kurzname, v_schichtart)
          then
             if (abs(v_diff_akt) <= abs(v_diff_merk)) or (v_schichtart.sa_bewertung_beginn = 1 and v_diff_akt <= v_diff_merk)
             then -- es gibt eine passendere schicht
                v_merk_sa_kurzname := v_Kurzname;
                v_merk_sa_begin := p_sa_beginn;
             end if;
          else
             if abs(v_diff_akt) <= abs(v_diff_merk)  -- MWe Backup
             then -- es gibt eine passendere schicht
                v_merk_sa_kurzname := v_Kurzname;
                v_merk_sa_begin := p_sa_beginn;
              end if;
          end if;

        end if;
      end if;
    end if;
  end loop;

  if c_SchichtPerioden%isopen
  then
    CLOSE c_SchichtPerioden;
  end if;

  v_Kurzname := null;
  if v_merk_sa_kurzname is not null
  then -- die beste (gemerkte) schicht nochmal holen, da wir möglicherweise mehr als eine gültige haben
    if pzm_p_base.get_schichtart_by_uix(v_merk_sa_kurzname, v_schichtart)
    then
      if v_schichtart.calc_basis = 'GLEITZ' and p_zaehler > 0
      then
        -- bei Gleitzeit soll keine Rückwärtssuche erfolgen
        Result := 0;
        return(Result);
      end if;
    end if;

    v_Kurzname := v_merk_sa_kurzname;
    Result := is_schichtart_in_time(v_Kurzname,
                                    p_stempel_zeit,
                                    p_schicht_datum,
                                    v_schicht_modell.d_arb_std_pro_tag,
                                    p_sa_beginn,
                                    p_sa_ende,
                                    p_sa_std);
    p_sa_kurzname := v_Kurzname;
  end if;

  if (v_Kurzname is null or Result = 0)
     and not v_schicht_datum_vorgabe
  then -- Immer noch nichts gefunden
    -- bis 06:00 vorherigen Tag prüfen, ansonsten Überstunden
    p_sa_kurzname := null;
    p_schicht_datum := null;
    Result := 0;
    -- AG das muss geprüft werden. 
    -- Urspruenglch stand da if p_stempel_zeit < trunc(p_stempel_zeit) + 6/24
    -- Was auch eigendlich falsch ist
    if p_stempel_zeit < trunc(p_stempel_zeit) + 4/24
    then
      Result := get_schicht_daten (p_pers_nr,
                                   trunc(p_stempel_zeit) - 1 / 1440,
                                   p_schicht_datum,
                                   p_sa_kurzname,
                                   p_sa_beginn,
                                   p_sa_ende,
                                   p_sa_std,
                                   nvl(p_zaehler, 0) + 1);
    end if;

    if Result = 1
    then
      v_Kurzname := p_sa_kurzname;
      Result := is_schichtart_in_time(v_Kurzname,
                                      p_stempel_zeit,
                                      p_schicht_datum,
                                      v_schicht_modell.d_arb_std_pro_tag,
                                      p_sa_beginn,
                                      p_sa_ende,
                                      p_sa_std);
      p_sa_kurzname := v_Kurzname;
    end if;

    if Result = 0
    then
      v_Kurzname := pzm_utils.get_standard_schicht_by_pers_nr(p_pers_nr);
      p_schicht_datum := trunc(p_stempel_zeit); -- ggf. wieder auf heute stellen
      Result := is_schichtart_in_time(v_Kurzname,
                                      p_stempel_zeit,
                                      p_schicht_datum,
                                      v_schicht_modell.d_arb_std_pro_tag,
                                      p_sa_beginn,
                                      p_sa_ende,
                                      p_sa_std);
      p_sa_kurzname := v_Kurzname;
      if v_Kurzname is not null
      then
        Result := 1;
      end if;
    end if;
  end if;

  return(Result);
end;
/



-- sqlcl_snapshot {"hash":"bfa9c70da7d15b679123a97975c7b7b55e8e061e","type":"FUNCTION","name":"GET_SCHICHT_DATEN","schemaName":"DIRKSPZM32","sxml":""}