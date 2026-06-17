create or replace 
procedure DIRKSPZM32.UPDATE_PERS_ZE_TAG(p_pers_nr in number,
                                               p_datum in date,
                                               p_result out number,
                                               p_res_info out varchar2,
                                               p_zaehler number default 0) is
/*
    ---- HISTORIE ---
    12.06.2018 -MWe-  P70460-15 halbe Urlaubstage
    07.08.2019 -MWe-  W20310-395 Lohnart von nicht aktiven Mitarbeitern nicht berechnen
    05.05.2026 -MHa-  W24120-554 Berechnung FlexiStd bei Arbeitszeit während Urlaub

*/

  type T_CommonCursorRef is ref cursor;

  -- Konstanten
  STATUS_ANWESEND    constant number := 2;
  STATUS_ABWESEND    constant number := 0;
  STATUS_PAUSE       constant number := 4;
  STATUS_DIENSTGANG  constant number := 5;
  STATUS_FEIERTAG    constant number := 6;
  STATUS_URLAUB_HALB constant number := 41;

  v_schicht_datum    date;

  cursor c_ZETag is
    select ze_id,
           ze_ist_start,
           ze_ist_ende,
           ze_status,
           ze_aa_status,
           ze_calc_ist_start,
           ze_calc_ist_ende,
           ze_sa_kurzname,
           ze_std,
           ze_typ,
           ze_work_location
      from pzm_zeiterfassung
     where ze_pers_nr = p_pers_nr
       and trunc(ze_schicht_tag) = trunc(v_schicht_datum)
     order by
           ze_calc_ist_start,
           ze_id; -- chronologisch sortieren

  cursor c_ZETag_All is
    select *
      from pzm_zeiterfassung
     where ze_pers_nr = p_pers_nr
       and trunc(ze_schicht_tag) = trunc(v_schicht_datum)
     order by
           ze_calc_ist_start,
           ze_id; -- chronologisch sortieren

  c_abwesenheitsmeldungen    T_CommonCursorRef;
  v_abwesenheitsart          pzm_abwesenheitsarten%rowtype;
  v_lohnart                  pzm_lohnarten%rowtype;

  v_ID               number;
  v_Start            date;
  v_Ende             date;
  v_Status           number;
  v_aa_status        number;
  v_CalcStart        date;
  v_CalcEnde         date;
  v_SAKurzname       pzm_zeiterfassung.ze_sa_kurzname%type;
  v_Std              number;
  v_ZETyp            pzm_zeiterfassung.ze_typ%type;
  v_zeWorkLocation   pzm_zeiterfassung.ze_work_location%type;
  v_PauseStd         number;
  v_pers_nr          pzm_personal.pers_nr%type;
  v_pb_id            number;
  v_abt_id           number;
  v_kst_id           number;
  v_kst_id_ze        number;

  v_Found            boolean;
  v_Found_wiedereing boolean;
  v_FoundNotClosed   boolean;
  v_FoundInvalid     boolean;

  -- Schichtdaten (bereits umgerechnet auf den Schichttag)
  v_SAFound                  boolean;
  v_SABeginn                 date;
  v_SAEnde                   date;
  v_SAStdProTag              number;
  v_schichtart               pzm_schichtarten%rowtype;

  v_FlexMaxStdProTag         number;
  v_FlexMaxStdProWo          number;

  v_DayCalcStart              date;
  v_DayCalcEnde               date;
  v_InvalidDayAnwStart        date;
  --v_DayAnwEnde              date;
  v_DayAnwStd                 number;
  v_DayArbStd                 number;
  v_DayFlexStd                number;
  v_DayUebStd                 number;
  v_DayAbwStd                 number;
  v_DaySAKurzname             pzm_zeiterfassung.ze_sa_kurzname%type;
  v_DayAaStatus               number;
  v_DayCalcAnwStart           date;
  v_DayCalcAnwEnde            date;
  v_DayPauseStd               number;
  v_DayPauseStempelStd        number;
  v_DayPauseBezStd            number;
  v_DayAbwStdDiff             number;
  v_DayArbStdGutsMin          number;
  v_DayReisePassivStd         number;
  v_abwes_art                 pzm_abwesenheitsarten%rowtype;          -- MWe Add P70460-15

  v_def_sa_kurzname            varchar2(10);
  v_ze_tagessatz               pzm_ze_tagessatz%rowtype;
  v_DayStdHalbUrlaub           number;  -- Gesamte Stunden des Tages nur wenn ein 1/2 Urlaubstag ist
  v_GesamtTagStdUrlaub         number;
  v_ZETag                      pzm_zeiterfassung%rowtype;
  v_kappung_schicht_ende       pzm_schicht_modelle.kappung_schicht_ende%type;
  v_kappung_te_ab_flx_std      pzm_personal.pers_kappung_te_ab_flx_std%type;

  v_pers_schichtmodell pzm_schicht_modelle%rowtype;

  v_schichtart_daten pzm_schichtarten%rowtype;
  cursor c_schichtart_daten is
    select t.*
      from pzm_schichtarten t
     where t.sa_kurzname = v_DaySAKurzname;

  v_wo_arb_std number;
  v_wo_flex_std number;
  v_wo_ueb_std number;
  v_wo_feiertag_std number;
  v_kenz_urlaub         boolean;
  v_SonderFeiertag varchar2(5);

  v_ges_arb_std_wo number;

  cursor c_arb_std_pro_woche is
    select nvl(sum(t.ts_day_arb_std), 0),
           nvl(sum(decode(t.ts_ueb_ok_datum, null, 0, decode(t.ts_ueb_storno_datum, null, t.ts_day_flex_std, 0))), 0),
           nvl(sum(decode(t.ts_ueb_ok_datum, null, 0, decode(t.ts_ueb_storno_datum, null, t.ts_day_ueb_std, 0))), 0),
           nvl(sum(decode(instr(nvl(check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, t.ts_datum), ' '), 'F'), 0, 0, t.ts_day_abw_std)), 0)
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = p_pers_nr
       and t.ts_datum between next_day(v_schicht_datum, 'So') - 7 -- Arbeitswoche beginnt in den meisten faellen am sonntag (1. Nachtschicht)
                          and v_schicht_datum - 1; -- die heutigen Daten haben wir ja hier

  cursor c_ze_tagessatz is
    select t.*
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = p_pers_nr
       and t.ts_datum = v_schicht_datum;

  -- MWe 20190807 Ticket: W20310-395
  CURSOR c_Personal IS
    select p.pers_nr, p.pers_pb_id, p.pers_abt_id, p.pers_kst_id, p.pers_kappung_schicht_ende, p.pers_kappung_te_ab_flx_std
      from pzm_personal p
    where (p.pers_austrittdatum is NULL or
           p.pers_austrittdatum >= trunc(p_datum))
      and (p.pers_eintrittsdatum is NULL or
           p.pers_eintrittsdatum <= trunc(p_datum))
      and  p.pers_nr = p_pers_nr;

begin
  if nvl(p_zaehler, 0) > 2
  then
    -- wir kommen in die 2. Recursion!!!!!!
    -- Es scheint eine Endlosschleife zu sein
    raise PROGRAM_ERROR;
  end if;

  /* ################# Personal Check ########################## */
  open c_Personal;
  fetch c_Personal into v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_kappung_schicht_ende, v_kappung_te_ab_flx_std;
  if c_Personal%notfound
  then
    p_result := -2;
    p_res_info := 'Die Person ('||p_pers_nr||') ist zu dem Zeitpunkt ('|| to_char(p_datum,'dd.mm.yyyy') ||') noch nicht angestellt.';
    return;
  end if;
  close c_Personal;
  /* ################# Personal Check ########################## */

  -- ggf. vorhandene Daten wiederverwenden, wenn vom bediener eingegeben
  v_schicht_datum := trunc(p_datum);
  open c_ze_tagessatz;
  fetch c_ze_tagessatz into v_ze_tagessatz;
  v_Found := c_ze_tagessatz%FOUND;
  close c_ze_tagessatz;

  if v_Found
  then
    if v_ze_tagessatz.ts_day_kst_id is not NULL
    then
      v_kst_id := v_ze_tagessatz.ts_day_kst_id;
    end if;
    if v_ze_tagessatz.ts_day_abt_id is not NULL
    then
      v_abt_id := v_ze_tagessatz.ts_day_abt_id;
    end if;
    if v_ze_tagessatz.ts_day_pb_id is not NULL
    then
      v_pb_id := v_ze_tagessatz.ts_day_pb_id;
    end if;
  end if;


  p_result := -1;
  p_res_info := 'Keine Stempelzeit gefunden, um den Tagessatz zu berechnen.';

  v_def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(p_pers_nr);

  -- automatische Datensaetze werden wieder (korrekt) neu angelegt
  if nvl(p_zaehler, 0) = 0
  then
    delete from pzm_zeiterfassung t
     where t.ze_schicht_tag = v_schicht_datum
       and t.ze_pers_nr = p_pers_nr
       and t.ze_typ = 'A'
       and t.ze_korr_pers_nr is null
       -- AG 20250109 - Nur wenn eine Personalnummer eingetragen ist, manuell eingetragen, dann nicht loeschen in diesem Zug.
       --and t.ze_korr_datum is null 
       and t.ze_ist_start is null
       and t.ze_ist_ende is null;
    commit;
  end if;

  pzm_p_schicht_tag.c_schicht_tag_validieren(
    in_pers_nr => p_pers_nr,
    io_schicht_datum => v_schicht_datum,
    io_found_not_closed => v_FoundNotClosed,
    io_found_invalid => v_FoundInvalid,
    out_day_sa_kurzname => v_DaySAKurzname,
    out_day_ist_start => v_InvalidDayAnwStart
  );

  -- ************************ Offene Stempelzeit (ohne Abstemeplung) ********************************
  if v_FoundNotClosed
  then
    update_tagessatz(p_pers_nr, v_schicht_datum, v_InvalidDayAnwStart, v_InvalidDayAnwStart,
                     null, null, v_DaySAKurzname, null, 0, 0, 0, 0, 0, 0, 0, 0);
    pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum, v_InvalidDayAnwStart,
                                                 v_InvalidDayAnwStart, v_DaySAKurzname,
                                                 v_kst_id);

    p_result := 0;
    p_res_info := 'Leeren Tagesatz angelegt';
    return;
  end if;

  -- ************************ Ungueltige bzw. ueberlappende Daten? ********************************
  if v_FoundInvalid
  then
    update_tagessatz(p_pers_nr, v_schicht_datum, null, null, null, null, v_DaySAKurzname, null,
                     0, 0, 0, 0, 0, 0, 0, 0);
    pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum, null, null, v_DaySAKurzname, v_kst_id);

    p_result := 1;
    p_res_info := 'Ungueltigen oder ueberlappenden Eintrag in den Stempelzeiten gefunden. Tagessatz konnte nicht berechnet werden.';
    return;
  end if;

  /* ################# Berechnung des Tagessatzes ########################## */
  if not pzm_p_base.get_schicht_modell(p_pers_nr, v_pers_schichtmodell)
  then
    v_pers_schichtmodell.flex_max_std_pro_woche := 0;
  end if;
  if v_kappung_te_ab_flx_std is NULL
  and v_pers_schichtmodell.kappung_te_ab_flx_std is not NULL
  then
    v_kappung_te_ab_flx_std := v_pers_schichtmodell.kappung_te_ab_flx_std;
  end if;

  v_DayArbStdGutsMin := 0;
  if v_ze_tagessatz.ts_abschluss is not null
  and v_ze_tagessatz.ts_ueb_ok_pers_nr is NULL
  then
    -- die Gutschriftzeiten sind von Bediener festgeschrieben worden
    v_DayArbStdGutsMin := nvl(v_ze_tagessatz.ts_day_arb_std_g_min, 0);
  end if;

  v_DayAnwStd := 0;
  v_DayAbwStd := 0;
  v_DayPauseStd := 0;
  v_DayPauseBezStd := 0;
  v_DayPauseStempelStd := 0;
  v_DayReisePassivStd := 0;
  --v_DayStdHalbUrlaub := 0;
  v_GesamtTagStdUrlaub := 0;

  v_DaySAKurzname := null;
  v_schichtart := null;
  v_Found := false;

  -- DTs/DKr 20200204, W20310-230
  open c_ZETag_All;
  loop
    -- Eintraege aus der Zeiterfassung holen
    fetch c_ZETag_All into v_ZETag;
    exit when c_ZETag_All%notfound;
    v_kst_id_ze := nvl(nvl(v_kst_id_ze, v_ZETag.Ze_Kst_Id), v_kst_id);
    if (v_ZETag.Ze_Status = STATUS_ABWESEND and v_ZETag.ze_aa_status = STATUS_URLAUB_HALB) then
      v_DayStdHalbUrlaub := v_ZETag.ze_std;
    end if;

    if not v_Found
    then
      v_Found := true;
      v_kst_id := v_kst_id_ze;
      update pzm_ze_tagessatz t
         set t.ts_day_kst_id = v_kst_id
        where t.ts_pers_nr = v_ze_tagessatz.ts_pers_nr
          and t.ts_datum = v_ze_tagessatz.ts_datum;

      -- Hotfix 2026-02-04 -wkr-: in der Zeiterfassung soll die Kostenstelle NICHT aktualisiert werden!
      -- NULL-Werte kommen hier nicht mehr vor, daher muessen nicht alle ZE-Saetze aktualisiert werden.
      -- Die bereits beim INSERT erfassten Kostenstellen mussen erhalten bleiben.
      -- update pzm_zeiterfassung t
      --    set t.ze_kst_id = v_kst_id
      --   where t.ze_pers_nr = v_ze_tagessatz.ts_pers_nr
      --     and t.ze_schicht_tag = v_ze_tagessatz.ts_datum;
    end if;
  end loop;
  close c_ZETag_All;
  v_Found := false;

  v_kenz_urlaub := false;
  open c_ZETag;
  loop
    -- Eintraege aus der Zeiterfassung holen
    fetch c_ZETag into v_ID, v_Start, v_Ende, v_Status, v_aa_status, v_CalcStart, v_CalcEnde,
                       v_SAKurzname, v_Std, v_ZETyp, v_zeWorkLocation;
    exit when c_ZETag%notfound;

    -- default-Werte setzen
    if v_Std is null
    then
      v_Std := 0;
    end if;

    if v_DaySAKurzname is null
    then
      v_DaySAKurzname := v_SAKurzname;
      if not pzm_p_base.get_schichtart_by_uix(v_DaySAKurzname, v_schichtart)
      then
        v_schichtart := null;
      end if;
    end if;

    if pzm_p_base.get_abwesenheitsart(v_aa_status, v_abwes_art) is null           -- MWe Add P70460-15
    then                                                                          -- MWe Add P70460-15
       v_aa_status := null;                                                       -- MWe Add P70460-15
    else
      if v_abwes_art.kennz_urlaub = c.C_TRUE
      then
        v_kenz_urlaub := true;
        v_GesamtTagStdUrlaub := v_GesamtTagStdUrlaub + v_Std;
      end if;
      if v_abwes_art.lz_id is not NULL
      then
        if  pzm_p_base.get_lohnart(v_abwes_art.lz_id, v_lohnart)
        and v_lohnart.lz_operator = 'ARBSTD' -- Durch den lz_operator "ARBSTD" wird eine Abwesenheit als Arbeitszeit deklariert.
        then
          v_DayAnwStd := v_DayAnwStd + v_Std; -- Anpassung, da ansonsten bspw. Arztbesuchzeit die Arbeitszeit ueberschreibt. (ABa W24120-465)
          v_Std := 0;
          -- -AG- Bei einer Abwesenheit die Arbeitszeit ist, darf keine Pause abgezogen werden
          /*
          v_PauseStd := get_pause_time_day(v_DaySAKurzname, v_CalcStart, v_CalcEnde,
              v_DayAnwStd, v_DayPauseStd, v_pb_id, v_DayPauseBezStd);
          --v_PauseStd := get_pause_time(v_DaySAKurzname, v_CalcStart, v_CalcEnde, v_pb_id);
          if v_PauseStd > 0
          then
            v_DayAnwStd := v_DayAnwStd + v_PauseStd;
          end if;
          */
        end if;
      end if;
    end if;                                                                       -- MWe Add P70460-15

    if v_Status = STATUS_DIENSTGANG
    and v_zeWorkLocation in (52, 53) -- Reise assiv oder Default
    then
      v_DayReisePassivStd := v_DayReisePassivStd + v_Std;
    end if;
    if not v_Found
    then -- 1. Runde ...
      -- beim ersten Eintrag ... (not v_Found -> vorher noch nichts gefunden)
      v_DayCalcAnwStart := null;
      v_DayCalcAnwEnde := null;

      v_DayCalcStart := v_CalcStart;
      v_DayCalcEnde := v_CalcEnde;

      if v_Status = STATUS_ABWESEND
      then
        if v_aa_status is not NULL
        then -- Abweseheit begruendet?
          v_DayAaStatus := v_aa_status;
        end if;
        v_DayAbwStd := v_Std;
      elsif v_status = STATUS_FEIERTAG
      then
        v_DayAaStatus := v_aa_status;
        --v_DayAbwStd := v_Std;
      elsif v_status = STATUS_ANWESEND
            or v_status = STATUS_DIENSTGANG
            or v_status = STATUS_PAUSE
      then
        v_DayAnwStd := v_Std;
        v_DayCalcAnwStart := v_CalcStart;
        v_DayCalcAnwEnde := v_CalcEnde;

        -- anwesenheitsdauer basierte pausen berechnen
        if v_status = STATUS_PAUSE
        then
          v_DayPauseStempelStd := v_DayPauseStempelStd + v_Std; -- gestempelte pause
        else
          v_PauseStd := get_pause_time(v_DaySAKurzname, v_CalcStart, v_CalcEnde, v_pb_id);
          if v_PauseStd > 0
          then
            v_DayPauseStempelStd := v_DayPauseStempelStd + v_PauseStd; -- gestempelte pause
          end if;
        end if;
      end if;
    else
      -- bei jedem weiteren Eintrag
      -- Das Tagesende nach hinten korrigieren
      v_DayCalcEnde := v_CalcEnde;

      if v_Status = STATUS_ABWESEND
      then
        if v_aa_status is not null
        then -- Abweseheit begruendet
          v_DayAaStatus := v_aa_status;
        end if;
        v_DayAbwStd := v_DayAbwStd + v_Std;
      elsif v_status = STATUS_FEIERTAG
      then
        -- bei Feiertag ist es nicht relevant, ob die Abwesenheit begruendet ist
        if v_aa_status is not NULL
        then -- Abweseheit begruendet?
          v_DayAaStatus := v_aa_Status;
        end if;
        --v_DayAbwStd := v_DayAbwStd + v_Std;
      elsif v_status = STATUS_ANWESEND
            or v_status = STATUS_DIENSTGANG
            or v_status = STATUS_PAUSE
      then
        v_DayAnwStd := v_DayAnwStd + v_Std;
        if v_DayCalcAnwStart is NULL
        then -- falls die BERECHNETE Tagesanwesenheit noch nicht begonnen hat, so beginnt sie spaetestens jetzt
          v_DayCalcAnwStart := v_CalcStart;
        end if;

        if v_CalcEnde is not NULL
        then
          -- falls die BERECHNETE Tagesanwesenheit noch nicht beendet ist,
          -- erstmal vorab auf die aktuelle BERECHNETE Stempelzeit setzen
          v_DayCalcAnwEnde := v_CalcEnde;
        end if;

        -- anwesenheitsdauer basierte pausen berechnen
        if v_status = STATUS_PAUSE
        then
          v_DayPauseStempelStd := v_DayPauseStempelStd + v_Std; -- gestempelte pause
        else
          v_PauseStd := get_pause_time(v_DaySAKurzname, v_CalcStart, v_CalcEnde, v_pb_id);
          if v_PauseStd > 0
          then
            v_DayPauseStempelStd := v_DayPauseStempelStd + v_PauseStd; -- gestempelte pause
          end if;
        end if;
      end if;
    end if;

    v_Found := true;
  end loop;
  close c_ZETag;

  v_DayPauseStd := v_DayPauseStempelStd;

  if v_Found
  then
    -- Bisher alle Daten in Ordnung
    -- Schicht fuer den ganzen Tag ermitteln und keinen offenen Eintrag fuer diesen Tag
    v_SAFound := get_schicht_daten(p_pers_nr, v_DayCalcStart, v_schicht_datum,
                                   v_DaySAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) = 1;

    if not pzm_p_base.get_schichtart_by_uix(v_DaySAKurzname, v_schichtart)
    then
      v_SAFound := false;
    end if;

    if v_SAFound
    then
      v_DayUebStd := 0;
      v_DayFlexStd := 0;

      -- auf ganze Minuten runden (zum Rechnen kein Rundung auf 3 Stellen)
      v_DayAnwStd := round(v_DayAnwStd * 60) / 60;
      v_DayPauseStd := round(v_DayPauseStd * 60) / 60;

      -- Pausenzeiten unter Beruecksichtigung der gestempelten Pausen berechnen
      v_PauseStd := get_pause_time_day(v_DaySAKurzname, v_DayCalcAnwStart, v_DayCalcAnwEnde,
          v_DayAnwStd, v_DayPauseStd, v_pb_id, v_DayPauseBezStd);
      if nvl(v_DayPauseStd, 0) < nvl(v_PauseStd, 0)
      then
        v_DayPauseStd := v_PauseStd;
      end if;

      if v_ze_tagessatz.ts_abschluss is not null
      and v_ze_tagessatz.ts_ueb_ok_pers_nr is NULL
      then
        -- der Bediener hat die Zeiten manuell festgelegt
        v_DayUebStd := v_ze_tagessatz.ts_day_ueb_std;
        v_DayFlexStd := v_ze_tagessatz.ts_day_flex_std;
        v_DayPauseStd := v_ze_tagessatz.ts_day_pause_std;
      end if;

      if v_DayAnwStd <= 0
      then
        -- wenn keine Anwesenheit, dann auch keine Pause
        v_DayPauseStd := 0;
      end if;

      v_DayArbStd := v_DayAnwStd - v_DayPauseStd;
      if v_kenz_urlaub           -- An dem Tag wurde Urlaub gefunden
      and v_DayArbStd > 0        -- Und gearbeitet
      then
        -- Aenderung M.Haberstock, W24120-554 18.05.2026
        -- Einheitliche Berechnung unabhaengig von ganzen oder halben Urlaubstagen!
        -- geleistete Arbeitsstunde werden dem Stundenaufbau-Konto gutgeschrieben; Die Arbeitsstunden im selben Mass reduziert 
        v_dayflexstd := v_dayarbstd + v_gesamttagstdurlaub - v_sastdprotag;
        if v_dayflexstd < 0 then
            v_dayflexstd := 0;
        end if;
        v_dayarbstd := v_dayarbstd - v_dayflexstd;
      end if;

      open c_schichtart_daten;
      fetch c_schichtart_daten into v_schichtart_daten;
      close c_schichtart_daten;

      open c_abwesenheitsmeldungen for  -- Wiedereingliederung - Zeiten werden erfasst, duerfen aber nicht an DATEV uebergeben werde.
      select a.*
        from pzm_abwesenheitsmeldungen t,
             pzm_abwesenheitsarten a
       where pers_nr = p_pers_nr
         and t.aa_id = a.aa_id
         and a.aa_kurzname = 'WE-N-KRANK'
         and v_schicht_datum between t.beginn and t.ende;

      fetch c_abwesenheitsmeldungen into v_abwesenheitsart;
      v_Found_wiedereing := c_abwesenheitsmeldungen%found;
      close c_abwesenheitsmeldungen;

      if v_Found_wiedereing -- Wiedereingliederung
      then
        v_DayArbStd := 0;
        v_DayAbwStd := v_SAStdProTag;
        v_DayAaStatus := v_abwesenheitsart.aa_id;
        update pzm_ze_loa_ausw t
           set t.aa_id = NULL
         where t.zeaw_pers_nr = p_pers_nr
           and t.zeaw_datum = v_schicht_datum;
        delete pzm_ze_loa_ausw t
         where t.zeaw_pers_nr = p_pers_nr
           and t.zeaw_datum = v_schicht_datum;
        update pzm_zeiterfassung t
           set t.ze_aa_status = v_DayAaStatus,
               t.ze_bemerkung = v_abwesenheitsart.aa_kurzname
         where t.ze_pers_nr = p_pers_nr
           and t.ze_schicht_tag = v_schicht_datum;
        if v_abwesenheitsart.lz_id is not NULL -- Fuer die Wiedereingliederung gibt es eine Lohnart
        then                                   -- dann eintragen
          insert into pzm_ze_loa_ausw
            (zeaw_pers_nr, 
             zeaw_datum, 
             zeaw_lz_lohnart, 
             zeaw_lz_loa_std, 
             aa_id, 
             zeaw_lz_id, 
             zeaw_pb_id, 
             zeaw_kst_id)
          values
            (p_pers_nr, 
             v_schicht_datum, 
             (select loa.lz_lohnart from pzm_lohnarten loa where loa.lz_id = v_abwesenheitsart.lz_id), 
             v_DayAbwStd, 
             v_DayAaStatus, 
             v_abwesenheitsart.lz_id, 
             v_pb_id, 
             v_kst_id);
        end if;           
      else
        if v_schichtart.calc_basis = 'GLEITZ'
        then
          v_DayAbwStdDiff := v_SAStdProTag - (v_DayArbStd + v_DayAbwStd);
          if v_DayAbwStdDiff > 0 and (v_DayArbStd > 0 or v_DayAbwStd > 0)
          then
            -- Abweseneheitsdifferenz bei Gleitzeit hinten dran schreiben
            if not pzm_p_schicht_tag.c_schicht_tag_fehlzeit_luecken_pruefen(p_pers_nr,
                                              v_schicht_datum, v_DaySAKurzname,
                                              v_SABeginn, v_DayCalcEnde + v_DayAbwStdDiff / 24,
                                              v_DayCalcStart, v_DayCalcEnde, v_DayCalcEnde,
                                              v_kst_id, v_abt_id, v_pb_id, v_DayAbwStd, v_DayArbStd, 
                                              v_DayPauseStd, p_zaehler, v_SAStdProTag)
            then
              if nvl(p_zaehler, 0) <= 1
              then
                update_pers_ze_tag(p_pers_nr, v_schicht_datum, p_result, p_res_info, NVL(p_zaehler, 0) + 1);
                return;
              end if;
            end if;
          end if;
      --  elsif v_DaySAKurzname != v_def_sa_kurzname and v_DayArbStd > 0 and v_DayAbwStd = 0                                     -- MWe Backup
      --        and (v_pers_schichtmodell.d_arb_std_pro_tag is null or v_DayArbStd < v_pers_schichtmodell.d_arb_std_pro_tag)     -- MWe Backup
      -- Wir haben eine normale Schichtart gefunden != Default und Stunden > 0 
        elsif (   (v_DaySAKurzname != v_def_sa_kurzname and v_DayArbStd > 0 and v_DayAbwStd = 0 )                                -- MWe Add P70460-15
               or (v_DaySAKurzname != v_def_sa_kurzname 
                   and v_DayArbStd + v_DayAbwStd < nvl(v_schichtart_daten.sa_std_pro_tag, v_pers_schichtmodell.d_arb_std_pro_tag))
              )
              and (nvl(v_schichtart_daten.sa_std_pro_tag, 1) != 0)
              and (v_pers_schichtmodell.d_arb_std_pro_tag is null or v_DayArbStd < v_pers_schichtmodell.d_arb_std_pro_tag)       -- MWe Add P70460-15
        then
          if nvl(v_schichtart_daten.sa_std_pro_tag, v_pers_schichtmodell.d_arb_std_pro_tag) is not null
          then
            -- wenn eine Durchschnittsarbeitszeit definiert ist wird das Schichtende korrigiert
            -- debug
            v_SAEnde := v_DayCalcAnwStart + (nvl(v_schichtart_daten.sa_std_pro_tag, v_pers_schichtmodell.d_arb_std_pro_tag) + v_DayPauseStd) / 24;
            -- Mit Durchschnittsarbeitszeiten wird wie bei der Gleitzeit berechnet
            if v_DayCalcAnwStart > v_SABeginn
            then
              -- spaeter angefangen, Ende um die Differenz des spaeter anfangens nach hinten verschieben
              v_SABeginn := v_DayCalcAnwStart;
            end if;
          end if;

          if not pzm_p_schicht_tag.c_schicht_tag_fehlzeit_luecken_pruefen(p_pers_nr,
                                            v_schicht_datum, v_DaySAKurzname,
                                            v_SABeginn, v_SAEnde, v_DayCalcAnwStart, v_DayCalcAnwEnde, v_DayCalcEnde,
                                            v_kst_id, v_abt_id, v_pb_id, v_DayAbwStd, v_DayArbStd, v_DayPauseStd, p_zaehler, v_SAStdProTag)
          then
            if nvl(p_zaehler, 0) <= 1
            then
              update_pers_ze_tag(p_pers_nr, v_schicht_datum, p_result, p_res_info, NVL(p_zaehler, 0) + 1);
              return;
            end if;
          end if;
        end if;
      end if;

      if (v_DayArbStd = 0)
         and (v_DayAbwStd > v_SAStdProTag)
      then
        v_DayAbwStd := v_SAStdProTag;
      end if;

      if v_DayArbStd > v_SAStdProTag
      then -- Wenn Ueberstunden geleistet wurden !!!
        v_FlexMaxStdProWo := nvl(v_pers_schichtmodell.flex_max_std_pro_woche, 0);

        v_FlexMaxStdProTag := 0;
        open c_schichtart_daten;
        fetch c_schichtart_daten into v_schichtart_daten;
        if c_schichtart_daten%found
        then
          v_FlexMaxStdProTag := v_schichtart_daten.flex_max_std_pro_tag;
          if v_FlexMaxStdProTag is null
          then
            v_FlexMaxStdProTag := (24 - v_SAStdProTag); -- alles als Flexistunden berechnen
          end if;
        end if;
        close c_schichtart_daten;
        
        -- Kappung ermitteln
        if v_kappung_schicht_ende = 'F' and nvl(v_pers_schichtmodell.kappung_schicht_ende, 'F') = 'T' 
        then
          v_kappung_schicht_ende := 'T';
        end if;

        -- Ueberstunden-Schichten werden nicht gekappt
        if v_schichtart_daten.sa_standard = 'T' 
        or v_ze_tagessatz.ts_ueb_ok_pers_nr is not NULL
        then
          v_kappung_schicht_ende := 'F';
        end if;
        
        if v_kappung_schicht_ende = 'T'
        and v_DayArbStd > v_SAStdProTag
        and v_DayArbStd > v_kappung_te_ab_flx_std
        then
          v_DayArbStd := v_kappung_te_ab_flx_std;
        end if;

        if v_FlexMaxStdProTag = 0
        then
          -- normale Ueberstundenrechnung ohne flexible Stunden
          v_DayUebStd := v_DayArbStd - v_SAStdProTag;
        else
          -- zuerst flexible Stunden ausrechnen
          if v_DayArbStd > v_FlexMaxStdProTag
          then
            v_DayFlexStd := v_FlexMaxStdProTag - v_SAStdProTag;
            v_DayUebStd := v_DayArbStd - v_FlexMaxStdProTag;
          else
            -- alles ueber der Schichtarbeitszeit sind flexible stunden
            v_DayFlexStd := v_DayArbStd - v_SAStdProTag;
            if check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, v_schicht_datum) is not NULL
            then
              -- -AG- Fehler in der Berechnung von flex-Zeit wenn der Schichttag ein Feiertag ist, dann immer alle Arbeitsstunden als Überstunden
              if 1=2 -- Wenn der Schichtag feiertag ist, dann sind alle gearbeitetetn Stunden FLEX (Bedingung erstmal nie wahr)
              and trunc(v_DayCalcEnde) > v_schicht_datum
              and isi_utils.Iso_WeekDay(v_schicht_datum + 1) not in (6,7)
              and check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, v_schicht_datum + 1) is NULL
              then
                v_DayFlexStd := ((v_DayCalcEnde - (v_schicht_datum + 1)) * 24) - v_DayPauseStd;
                v_SAStdProTag := ((v_DayCalcEnde - v_DayCalcStart) * 24) - v_DayPauseStd - v_DayFlexStd;
                --v_DayFlexStd := v_DayFlexStd + v_DayArbStd - ((v_DayCalcEnde - (v_schicht_datum + 1)) * 24);
                --v_SAStdProTag := v_SAStdProTag - v_DayFlexStd; 
              else
                v_DayFlexStd := v_DayArbStd;
                v_SAStdProTag := 0;
              end if;
            end if;
          end if;

          if v_DayFlexStd > 0
             and v_FlexMaxStdProWo > 0
             and (v_DaySAKurzname = v_def_sa_kurzname
               or nvl(v_schichtart_daten.sa_std_pro_tag, 1) = 0)
          then -- Wochenstunden pruefen
            -- Laut Euscher werden Wochenueberstunden nur an reinen Ueberstundentagen
            -- (ohne regulaere Schicht) berechnet
            open c_arb_std_pro_woche;
            fetch c_arb_std_pro_woche into v_wo_arb_std, v_wo_flex_std, v_wo_ueb_std, v_wo_feiertag_std;
            if c_arb_std_pro_woche%found
            then
              v_ges_arb_std_wo := v_wo_arb_std + v_wo_flex_std + v_wo_ueb_std + v_wo_feiertag_std + v_SAStdProTag;
              if v_ges_arb_std_wo >= v_FlexMaxStdProWo
              then
                -- alle Flexstunden als Ueberstunden, da die Maximale flexible Wochenstundenzahl erreicht wurde
                v_DayUebStd := v_DayUebStd + v_DayFlexStd;
                v_DayFlexStd := 0;
              elsif (v_ges_arb_std_wo + v_DayFlexStd) >= v_FlexMaxStdProWo
              then
                v_std := (v_ges_arb_std_wo + v_DayFlexStd) - v_FlexMaxStdProWo; -- Differenz der zu viel angerechneten Flex-Stunden
                if v_DayFlexStd > v_std
                then
                  -- differenz auf die Ueberstunden verschieben
                  v_DayUebStd := v_DayUebStd + v_std;
                  v_DayFlexStd := v_DayFlexStd - v_std;
                else
                  -- Minusstunden vermeiden
                  -- alle Flexstunden als Ueberstunden, da die Maximale flexible Wochenstundenzahl erreicht wurde
                  v_DayUebStd := v_DayUebStd + v_DayFlexStd;
                  v_DayFlexStd := 0;
                end if;
              end if;
            end if;
            close c_arb_std_pro_woche;
          end if;
        end if;

        v_DayArbStd := v_SAStdProTag;
        if v_DayAaStatus is null
           and v_DayUebStd > 0
        then
           v_DayAbwStd := 0;
        end if;
      end if;

      if ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_schicht_datum, v_SonderFeiertag) = 1 
      and ( v_SonderFeiertag != 'H'
         or ( v_kenz_urlaub = true
          and v_SonderFeiertag = 'H')
          )
      and v_DayFlexStd = 0
      then
        v_DayFlexStd := v_DayArbStd;
        v_DayArbStd := 0;
      end if;

      -- Rundungsfehler korrigieren (auf ganze Minuten runden)
      v_DayAbwStd := round(round(v_DayAbwStd * 60) / 60, 3);
      v_DayArbStd := round(round(v_DayArbStd * 60) / 60, 3);
      v_DayUebStd := round(round(v_DayUebStd * 60) / 60, 3);
      v_DayFlexStd := round(round(v_DayFlexStd * 60) / 60, 3);
      v_DayAnwStd := round(round(v_DayAnwStd * 60) / 60, 3);
      v_DayPauseStd := round(round(v_DayPauseStd * 60) / 60, 3);
      v_DayPauseBezStd := round(round(v_DayPauseBezStd * 60) / 60, 3);

      if v_kenz_urlaub = false
      then
        if v_kappung_te_ab_flx_std > 0
        and v_kappung_te_ab_flx_std < v_DayFlexStd  + v_DayArbStd - v_DayReisePassivStd
        then
          v_DayFlexStd := v_kappung_te_ab_flx_std - v_DayArbStd + v_DayReisePassivStd;
        end if;
      end if;

      -- alles ok ... Daten in die Auswertungstabelle speichern/uebertragen
      update_tagessatz(p_pers_nr, v_schicht_datum, v_DayCalcAnwStart, v_DayCalcAnwEnde,
                       v_DayCalcStart, v_DayCalcEnde, v_DaySAKurzname,
                       v_DayAaStatus, v_DayAbwStd, v_DayArbStd, v_DayUebStd, v_DayFlexStd,
                       v_DayAnwStd, v_DayPauseStd, v_DayArbStdGutsMin, v_DayPauseBezStd);

      if (   v_DayAaStatus is not NULL 
          or v_DayAnwStd > 0)
      and not v_Found_wiedereing -- Nicht Wiedereingliederung
      then
        pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum,
                                                     v_DayCalcAnwStart, v_DayCalcAnwEnde,
                                                     v_DaySAKurzname, v_kst_id);
      end if;
      commit;

      p_result := 0;
      p_res_info := 'Tagessatz erfolgreich berechnet.';
    end if;
  else
    if pzm_p_schicht_tag.c_schicht_tag_fehltag_pruefen(p_pers_nr, v_schicht_datum)
    then
      -- neue Abwesenheits-Datensaetze wurden angelegt, Tagessatz neu berechnen
      update_pers_ze_tag(p_pers_nr, v_schicht_datum, p_result, p_res_info, nvl(p_zaehler, 0) + 1);
    end if;
  end if;

  commit;

end update_pers_ze_tag;
/



-- sqlcl_snapshot {"hash":"3bd950937ba084e981a8d224088fb6435eefbe7f","type":"PROCEDURE","name":"UPDATE_PERS_ZE_TAG","schemaName":"DIRKSPZM32","sxml":""}