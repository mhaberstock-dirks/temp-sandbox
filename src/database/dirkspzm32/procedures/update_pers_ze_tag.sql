create or replace procedure dirkspzm32.update_pers_ze_tag (
    p_pers_nr  in number,
    p_datum    in date,
    p_result   out number,
    p_res_info out varchar2,
    p_zaehler  number default 0
) is
/*
    ---- HISTORIE ---
    12.06.2018 -MWe-  P70460-15 halbe Urlaubstage
    07.08.2019 -MWe-  W20310-395 Lohnart von nicht aktiven Mitarbeitern nicht berechnen
    05.05.2026 -MHa-  W24120-554 Berechnung FlexiStd bei Arbeitszeit während Urlaub

*/

    type t_commoncursorref is ref cursor;

  -- Konstanten
    status_anwesend         constant number := 2;
    status_abwesend         constant number := 0;
    status_pause            constant number := 4;
    status_dienstgang       constant number := 5;
    status_feiertag         constant number := 6;
    status_urlaub_halb      constant number := 41;
    v_schicht_datum         date;
    cursor c_zetag is
    select
        ze_id,
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
    from
        pzm_zeiterfassung
    where
            ze_pers_nr = p_pers_nr
        and trunc(ze_schicht_tag) = trunc(v_schicht_datum)
    order by
        ze_calc_ist_start,
        ze_id; -- chronologisch sortieren
    cursor c_zetag_all is
    select
        *
    from
        pzm_zeiterfassung
    where
            ze_pers_nr = p_pers_nr
        and trunc(ze_schicht_tag) = trunc(v_schicht_datum)
    order by
        ze_calc_ist_start,
        ze_id; -- chronologisch sortieren
    c_abwesenheitsmeldungen t_commoncursorref;
    v_abwesenheitsart       pzm_abwesenheitsarten%rowtype;
    v_lohnart               pzm_lohnarten%rowtype;
    v_id                    number;
    v_start                 date;
    v_ende                  date;
    v_status                number;
    v_aa_status             number;
    v_calcstart             date;
    v_calcende              date;
    v_sakurzname            pzm_zeiterfassung.ze_sa_kurzname%type;
    v_std                   number;
    v_zetyp                 pzm_zeiterfassung.ze_typ%type;
    v_zeworklocation        pzm_zeiterfassung.ze_work_location%type;
    v_pausestd              number;
    v_pers_nr               pzm_personal.pers_nr%type;
    v_pb_id                 number;
    v_abt_id                number;
    v_kst_id                number;
    v_kst_id_ze             number;
    v_found                 boolean;
    v_found_wiedereing      boolean;
    v_foundnotclosed        boolean;
    v_foundinvalid          boolean;

  -- Schichtdaten (bereits umgerechnet auf den Schichttag)
    v_safound               boolean;
    v_sabeginn              date;
    v_saende                date;
    v_sastdprotag           number;
    v_schichtart            pzm_schichtarten%rowtype;
    v_flexmaxstdprotag      number;
    v_flexmaxstdprowo       number;
    v_daycalcstart          date;
    v_daycalcende           date;
    v_invaliddayanwstart    date;
  --v_DayAnwEnde              date;
    v_dayanwstd             number;
    v_dayarbstd             number;
    v_dayflexstd            number;
    v_dayuebstd             number;
    v_dayabwstd             number;
    v_daysakurzname         pzm_zeiterfassung.ze_sa_kurzname%type;
    v_dayaastatus           number;
    v_daycalcanwstart       date;
    v_daycalcanwende        date;
    v_daypausestd           number;
    v_daypausestempelstd    number;
    v_daypausebezstd        number;
    v_dayabwstddiff         number;
    v_dayarbstdgutsmin      number;
    v_dayreisepassivstd     number;
    v_abwes_art             pzm_abwesenheitsarten%rowtype;          -- MWe Add P70460-15

    v_def_sa_kurzname       varchar2(10);
    v_ze_tagessatz          pzm_ze_tagessatz%rowtype;
    v_daystdhalburlaub      number;  -- Gesamte Stunden des Tages nur wenn ein 1/2 Urlaubstag ist
    v_gesamttagstdurlaub    number;
    v_zetag                 pzm_zeiterfassung%rowtype;
    v_kappung_schicht_ende  pzm_schicht_modelle.kappung_schicht_ende%type;
    v_kappung_te_ab_flx_std pzm_personal.pers_kappung_te_ab_flx_std%type;
    v_pers_schichtmodell    pzm_schicht_modelle%rowtype;
    v_schichtart_daten      pzm_schichtarten%rowtype;
    cursor c_schichtart_daten is
    select
        t.*
    from
        pzm_schichtarten t
    where
        t.sa_kurzname = v_daysakurzname;

    v_wo_arb_std            number;
    v_wo_flex_std           number;
    v_wo_ueb_std            number;
    v_wo_feiertag_std       number;
    v_kenz_urlaub           boolean;
    v_sonderfeiertag        varchar2(5);
    v_ges_arb_std_wo        number;
    cursor c_arb_std_pro_woche is
    select
        nvl(
            sum(t.ts_day_arb_std),
            0
        ),
        nvl(
            sum(decode(t.ts_ueb_ok_datum,
                       null,
                       0,
                       decode(t.ts_ueb_storno_datum, null, t.ts_day_flex_std, 0))),
            0
        ),
        nvl(
            sum(decode(t.ts_ueb_ok_datum,
                       null,
                       0,
                       decode(t.ts_ueb_storno_datum, null, t.ts_day_ueb_std, 0))),
            0
        ),
        nvl(
            sum(decode(
                instr(
                    nvl(
                        check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, t.ts_datum),
                        ' '
                    ),
                    'F'
                ),
                0,
                0,
                t.ts_day_abw_std
            )),
            0
        )
    from
        pzm_ze_tagessatz t
    where
            t.ts_pers_nr = p_pers_nr
        and t.ts_datum between next_day(v_schicht_datum, 'So') - 7 -- Arbeitswoche beginnt in den meisten faellen am sonntag (1. Nachtschicht)
         and v_schicht_datum - 1; -- die heutigen Daten haben wir ja hier
    cursor c_ze_tagessatz is
    select
        t.*
    from
        pzm_ze_tagessatz t
    where
            t.ts_pers_nr = p_pers_nr
        and t.ts_datum = v_schicht_datum;

  -- MWe 20190807 Ticket: W20310-395
    cursor c_personal is
    select
        p.pers_nr,
        p.pers_pb_id,
        p.pers_abt_id,
        p.pers_kst_id,
        p.pers_kappung_schicht_ende,
        p.pers_kappung_te_ab_flx_std
    from
        pzm_personal p
    where
        ( p.pers_austrittdatum is null
          or p.pers_austrittdatum >= trunc(p_datum) )
        and ( p.pers_eintrittsdatum is null
              or p.pers_eintrittsdatum <= trunc(p_datum) )
        and p.pers_nr = p_pers_nr;

begin
    if nvl(p_zaehler, 0) > 2 then
    -- wir kommen in die 2. Recursion!!!!!!
    -- Es scheint eine Endlosschleife zu sein
        raise program_error;
    end if;

  /* ################# Personal Check ########################## */
    open c_personal;
    fetch c_personal into
        v_pers_nr,
        v_pb_id,
        v_abt_id,
        v_kst_id,
        v_kappung_schicht_ende,
        v_kappung_te_ab_flx_std;
    if c_personal%notfound then
        p_result := -2;
        p_res_info := 'Die Person ('
                      || p_pers_nr
                      || ') ist zu dem Zeitpunkt ('
                      || to_char(p_datum, 'dd.mm.yyyy')
                      || ') noch nicht angestellt.';

        return;
    end if;

    close c_personal;
  /* ################# Personal Check ########################## */

  -- ggf. vorhandene Daten wiederverwenden, wenn vom bediener eingegeben
    v_schicht_datum := trunc(p_datum);
    open c_ze_tagessatz;
    fetch c_ze_tagessatz into v_ze_tagessatz;
    v_found := c_ze_tagessatz%found;
    close c_ze_tagessatz;
    if v_found then
        if v_ze_tagessatz.ts_day_kst_id is not null then
            v_kst_id := v_ze_tagessatz.ts_day_kst_id;
        end if;
        if v_ze_tagessatz.ts_day_abt_id is not null then
            v_abt_id := v_ze_tagessatz.ts_day_abt_id;
        end if;
        if v_ze_tagessatz.ts_day_pb_id is not null then
            v_pb_id := v_ze_tagessatz.ts_day_pb_id;
        end if;
    end if;

    p_result := -1;
    p_res_info := 'Keine Stempelzeit gefunden, um den Tagessatz zu berechnen.';
    v_def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(p_pers_nr);

  -- automatische Datensaetze werden wieder (korrekt) neu angelegt
    if nvl(p_zaehler, 0) = 0 then
        delete from pzm_zeiterfassung t
        where
                t.ze_schicht_tag = v_schicht_datum
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
        in_pers_nr          => p_pers_nr,
        io_schicht_datum    => v_schicht_datum,
        io_found_not_closed => v_foundnotclosed,
        io_found_invalid    => v_foundinvalid,
        out_day_sa_kurzname => v_daysakurzname,
        out_day_ist_start   => v_invaliddayanwstart
    );

  -- ************************ Offene Stempelzeit (ohne Abstemeplung) ********************************
    if v_foundnotclosed then
        update_tagessatz(p_pers_nr, v_schicht_datum, v_invaliddayanwstart, v_invaliddayanwstart, null,
                         null, v_daysakurzname, null, 0, 0,
                         0, 0, 0, 0, 0,
                         0);

        pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum, v_invaliddayanwstart, v_invaliddayanwstart, v_daysakurzname
        ,
                                                     v_kst_id);
        p_result := 0;
        p_res_info := 'Leeren Tagesatz angelegt';
        return;
    end if;

  -- ************************ Ungueltige bzw. ueberlappende Daten? ********************************
    if v_foundinvalid then
        update_tagessatz(p_pers_nr, v_schicht_datum, null, null, null,
                         null, v_daysakurzname, null, 0, 0,
                         0, 0, 0, 0, 0,
                         0);

        pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum, null, null, v_daysakurzname,
                                                     v_kst_id);
        p_result := 1;
        p_res_info := 'Ungueltigen oder ueberlappenden Eintrag in den Stempelzeiten gefunden. Tagessatz konnte nicht berechnet werden.'
        ;
        return;
    end if;

  /* ################# Berechnung des Tagessatzes ########################## */
    if not pzm_p_base.get_schicht_modell(p_pers_nr, v_pers_schichtmodell) then
        v_pers_schichtmodell.flex_max_std_pro_woche := 0;
    end if;

    if
        v_kappung_te_ab_flx_std is null
        and v_pers_schichtmodell.kappung_te_ab_flx_std is not null
    then
        v_kappung_te_ab_flx_std := v_pers_schichtmodell.kappung_te_ab_flx_std;
    end if;

    v_dayarbstdgutsmin := 0;
    if
        v_ze_tagessatz.ts_abschluss is not null
        and v_ze_tagessatz.ts_ueb_ok_pers_nr is null
    then
    -- die Gutschriftzeiten sind von Bediener festgeschrieben worden
        v_dayarbstdgutsmin := nvl(v_ze_tagessatz.ts_day_arb_std_g_min, 0);
    end if;

    v_dayanwstd := 0;
    v_dayabwstd := 0;
    v_daypausestd := 0;
    v_daypausebezstd := 0;
    v_daypausestempelstd := 0;
    v_dayreisepassivstd := 0;
  --v_DayStdHalbUrlaub := 0;
    v_gesamttagstdurlaub := 0;
    v_daysakurzname := null;
    v_schichtart := null;
    v_found := false;

  -- DTs/DKr 20200204, W20310-230
    open c_zetag_all;
    loop
    -- Eintraege aus der Zeiterfassung holen
        fetch c_zetag_all into v_zetag;
        exit when c_zetag_all%notfound;
        v_kst_id_ze := nvl(
            nvl(v_kst_id_ze, v_zetag.ze_kst_id),
            v_kst_id
        );
        if (
            v_zetag.ze_status = status_abwesend
            and v_zetag.ze_aa_status = status_urlaub_halb
        ) then
            v_daystdhalburlaub := v_zetag.ze_std;
        end if;

        if not v_found then
            v_found := true;
            v_kst_id := v_kst_id_ze;
            update pzm_ze_tagessatz t
            set
                t.ts_day_kst_id = v_kst_id
            where
                    t.ts_pers_nr = v_ze_tagessatz.ts_pers_nr
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

    close c_zetag_all;
    v_found := false;
    v_kenz_urlaub := false;
    open c_zetag;
    loop
    -- Eintraege aus der Zeiterfassung holen
        fetch c_zetag into
            v_id,
            v_start,
            v_ende,
            v_status,
            v_aa_status,
            v_calcstart,
            v_calcende,
            v_sakurzname,
            v_std,
            v_zetyp,
            v_zeworklocation;

        exit when c_zetag%notfound;

    -- default-Werte setzen
        if v_std is null then
            v_std := 0;
        end if;
        if v_daysakurzname is null then
            v_daysakurzname := v_sakurzname;
            if not pzm_p_base.get_schichtart_by_uix(v_daysakurzname, v_schichtart) then
                v_schichtart := null;
            end if;

        end if;

        if pzm_p_base.get_abwesenheitsart(v_aa_status, v_abwes_art) is null           -- MWe Add P70460-15

         then                                                                          -- MWe Add P70460-15
            v_aa_status := null;                                                       -- MWe Add P70460-15
        else
            if v_abwes_art.kennz_urlaub = c.c_true then
                v_kenz_urlaub := true;
                v_gesamttagstdurlaub := v_gesamttagstdurlaub + v_std;
            end if;

            if v_abwes_art.lz_id is not null then
                if
                    pzm_p_base.get_lohnart(v_abwes_art.lz_id, v_lohnart)
                    and v_lohnart.lz_operator = 'ARBSTD' -- Durch den lz_operator "ARBSTD" wird eine Abwesenheit als Arbeitszeit deklariert.
                then
                    v_dayanwstd := v_dayanwstd + v_std; -- Anpassung, da ansonsten bspw. Arztbesuchzeit die Arbeitszeit ueberschreibt. (ABa W24120-465)
                    v_std := 0;
                    v_pausestd := get_pause_time_day(v_daysakurzname, v_calcstart, v_calcende, v_dayanwstd, v_daypausestd,
                                                     v_pb_id, v_daypausebezstd);
          --v_PauseStd := get_pause_time(v_DaySAKurzname, v_CalcStart, v_CalcEnde, v_pb_id);
                    if v_pausestd > 0 then
                        v_dayanwstd := v_dayanwstd + v_pausestd;
                    end if;
                end if;

            end if;

        end if;                                                                       -- MWe Add P70460-15

        if
            v_status = status_dienstgang
            and v_zeworklocation in ( 52, 53 ) -- Reise assiv oder Default
        then
            v_dayreisepassivstd := v_dayreisepassivstd + v_std;
        end if;

        if not v_found then -- 1. Runde ...
      -- beim ersten Eintrag ... (not v_Found -> vorher noch nichts gefunden)
            v_daycalcanwstart := null;
            v_daycalcanwende := null;
            v_daycalcstart := v_calcstart;
            v_daycalcende := v_calcende;
            if v_status = status_abwesend then
                if v_aa_status is not null then -- Abweseheit begruendet?
                    v_dayaastatus := v_aa_status;
                end if;
                v_dayabwstd := v_std;
            elsif v_status = status_feiertag then
                v_dayaastatus := v_aa_status;
        --v_DayAbwStd := v_Std;
            elsif v_status = status_anwesend
            or v_status = status_dienstgang
            or v_status = status_pause then
                v_dayanwstd := v_std;
                v_daycalcanwstart := v_calcstart;
                v_daycalcanwende := v_calcende;

        -- anwesenheitsdauer basierte pausen berechnen
                if v_status = status_pause then
                    v_daypausestempelstd := v_daypausestempelstd + v_std; -- gestempelte pause
                else
                    v_pausestd := get_pause_time(v_daysakurzname, v_calcstart, v_calcende, v_pb_id);
                    if v_pausestd > 0 then
                        v_daypausestempelstd := v_daypausestempelstd + v_pausestd; -- gestempelte pause
                    end if;
                end if;

            end if;

        else
      -- bei jedem weiteren Eintrag
      -- Das Tagesende nach hinten korrigieren
            v_daycalcende := v_calcende;
            if v_status = status_abwesend then
                if v_aa_status is not null then -- Abweseheit begruendet
                    v_dayaastatus := v_aa_status;
                end if;
                v_dayabwstd := v_dayabwstd + v_std;
            elsif v_status = status_feiertag then
        -- bei Feiertag ist es nicht relevant, ob die Abwesenheit begruendet ist
                if v_aa_status is not null then -- Abweseheit begruendet?
                    v_dayaastatus := v_aa_status;
                end if;
        --v_DayAbwStd := v_DayAbwStd + v_Std;
            elsif v_status = status_anwesend
            or v_status = status_dienstgang
            or v_status = status_pause then
                v_dayanwstd := v_dayanwstd + v_std;
                if v_daycalcanwstart is null then -- falls die BERECHNETE Tagesanwesenheit noch nicht begonnen hat, so beginnt sie spaetestens jetzt
                    v_daycalcanwstart := v_calcstart;
                end if;
                if v_calcende is not null then
          -- falls die BERECHNETE Tagesanwesenheit noch nicht beendet ist,
          -- erstmal vorab auf die aktuelle BERECHNETE Stempelzeit setzen
                    v_daycalcanwende := v_calcende;
                end if;

        -- anwesenheitsdauer basierte pausen berechnen
                if v_status = status_pause then
                    v_daypausestempelstd := v_daypausestempelstd + v_std; -- gestempelte pause
                else
                    v_pausestd := get_pause_time(v_daysakurzname, v_calcstart, v_calcende, v_pb_id);
                    if v_pausestd > 0 then
                        v_daypausestempelstd := v_daypausestempelstd + v_pausestd; -- gestempelte pause
                    end if;
                end if;

            end if;

        end if;

        v_found := true;
    end loop;

    close c_zetag;
    v_daypausestd := v_daypausestempelstd;
    if v_found then
    -- Bisher alle Daten in Ordnung
    -- Schicht fuer den ganzen Tag ermitteln und keinen offenen Eintrag fuer diesen Tag
        v_safound := get_schicht_daten(p_pers_nr, v_daycalcstart, v_schicht_datum, v_daysakurzname, v_sabeginn,
                                       v_saende, v_sastdprotag) = 1;

        if not pzm_p_base.get_schichtart_by_uix(v_daysakurzname, v_schichtart) then
            v_safound := false;
        end if;

        if v_safound then
            v_dayuebstd := 0;
            v_dayflexstd := 0;

      -- auf ganze Minuten runden (zum Rechnen kein Rundung auf 3 Stellen)
            v_dayanwstd := round(v_dayanwstd * 60) / 60;
            v_daypausestd := round(v_daypausestd * 60) / 60;

      -- Pausenzeiten unter Beruecksichtigung der gestempelten Pausen berechnen
            v_pausestd := get_pause_time_day(v_daysakurzname, v_daycalcanwstart, v_daycalcanwende, v_dayanwstd, v_daypausestd,
                                             v_pb_id, v_daypausebezstd);

            if nvl(v_daypausestd, 0) < nvl(v_pausestd, 0) then
                v_daypausestd := v_pausestd;
            end if;

            if
                v_ze_tagessatz.ts_abschluss is not null
                and v_ze_tagessatz.ts_ueb_ok_pers_nr is null
            then
        -- der Bediener hat die Zeiten manuell festgelegt
                v_dayuebstd := v_ze_tagessatz.ts_day_ueb_std;
                v_dayflexstd := v_ze_tagessatz.ts_day_flex_std;
                v_daypausestd := v_ze_tagessatz.ts_day_pause_std;
            end if;

            if v_dayanwstd <= 0 then
        -- wenn keine Anwesenheit, dann auch keine Pause
                v_daypausestd := 0;
            end if;
            v_dayarbstd := v_dayanwstd - v_daypausestd;
            if
                v_kenz_urlaub           -- An dem Tag wurde Urlaub gefunden
                and v_dayarbstd > 0        -- Und gearbeitet
            then
        
        -- Aenderung M.Haberstock, W24120-554 05.05.2026
        -- Einheitliche Berechnung unabhaengig von ganzen oder halben Urlaubstagen!
        -- geleistete Arbeitsstunde werden dem Stundenaufbau-Konto gutgeschrieben; Die Arbeitsstunden im selben Mass reduziert 
                v_dayflexstd := v_dayflexstd + v_dayarbstd + v_gesamttagstdurlaub - v_sastdprotag;
                v_dayarbstd := v_dayarbstd - v_dayflexstd;

        /* Anmerkung M.Haberstock:
         *  Eine Unterscheidung in ganze und halbe Arbeitstage ist nicht sinnvoll.
         *  Eine Sonderbehandlung für "halbe Feiertage" ist an dieser Stelle nicht sinnvoll und sollte
         *  - falls überhaupt nötig - in einem eigens für die Feiertagsbehandlung vorgesehenen Block 
         *  berechnet werden
         *--------------------------------------------------------------------------------------------- 
         * if v_GesamtTagStdUrlaub >= v_SAStdProTag -- Ganzer Urlaubstag da weniger als 50% gearbeitet
         * then
         *   v_DayFlexStd := v_DayFlexStd + v_DayArbStd; -- Dann Stunden ins Aufbaukonto
         *   
         *   -- Änderung M.Haberstock, W24120-554 21.04.2026 
         *   v_DayArbStd := 0;
         *   -- Änderung Ende
         * else
         *   if ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_schicht_datum, v_SonderFeiertag) != 1
         *   then
         *     v_SonderFeiertag := 'N';
         *   end if;
         *   
         *   if v_SonderFeiertag != 'H'
         *   then
         *     v_DayFlexStd := v_DayArbStd + v_DayPauseStd + v_GesamtTagStdUrlaub - v_SAStdProTag; -- Mehrstunden ins Aufbaukonto
         *     if v_DayFlexStd >= 0
         *     then
         *       v_DayArbStd := v_DayArbStd + v_DayPauseStd - v_DayFlexStd;                          -- Berechnung der Arbeitszeit mit Urlaub ohne Pause
         *     else
         *       v_DayFlexStd := 0;
         *     end if;
         *   end if;
         * end if;
         * --v_DayPauseStd := 0;                                                                   -- Pausezeit dann 0
         */
            end if;

            open c_schichtart_daten;
            fetch c_schichtart_daten into v_schichtart_daten;
            close c_schichtart_daten;
            open c_abwesenheitsmeldungen for  -- Wiedereingliederung - Zeiten werden erfasst, duerfen aber nicht an DATEV uebergeben werde.
             select
                                                                                  a.*
                                                                              from
                                                                                  pzm_abwesenheitsmeldungen t,
                                                                                  pzm_abwesenheitsarten     a
                                             where
                                                     pers_nr = p_pers_nr
                                                 and t.aa_id = a.aa_id
                                                 and a.aa_kurzname = 'WE-N-KRANK'
                                                 and v_schicht_datum between t.beginn and t.ende;

            fetch c_abwesenheitsmeldungen into v_abwesenheitsart;
            v_found_wiedereing := c_abwesenheitsmeldungen%found;
            close c_abwesenheitsmeldungen;
            if v_found_wiedereing -- Wiedereingliederung
             then
                v_dayarbstd := 0;
                v_dayabwstd := v_sastdprotag;
                v_dayaastatus := v_abwesenheitsart.aa_id;
                update pzm_ze_loa_ausw t
                set
                    t.aa_id = null
                where
                        t.zeaw_pers_nr = p_pers_nr
                    and t.zeaw_datum = v_schicht_datum;

                delete pzm_ze_loa_ausw t
                where
                        t.zeaw_pers_nr = p_pers_nr
                    and t.zeaw_datum = v_schicht_datum;

                update pzm_zeiterfassung t
                set
                    t.ze_aa_status = v_dayaastatus,
                    t.ze_bemerkung = v_abwesenheitsart.aa_kurzname
                where
                        t.ze_pers_nr = p_pers_nr
                    and t.ze_schicht_tag = v_schicht_datum;

                if v_abwesenheitsart.lz_id is not null -- Fuer die Wiedereingliederung gibt es eine Lohnart

                 then                                   -- dann eintragen
                    insert into pzm_ze_loa_ausw (
                        zeaw_pers_nr,
                        zeaw_datum,
                        zeaw_lz_lohnart,
                        zeaw_lz_loa_std,
                        aa_id,
                        zeaw_lz_id,
                        zeaw_pb_id,
                        zeaw_kst_id
                    ) values ( p_pers_nr,
                               v_schicht_datum,
                               (
                                   select
                                       loa.lz_lohnart
                                   from
                                       pzm_lohnarten loa
                                   where
                                       loa.lz_id = v_abwesenheitsart.lz_id
                               ),
                               v_dayabwstd,
                               v_dayaastatus,
                               v_abwesenheitsart.lz_id,
                               v_pb_id,
                               v_kst_id );

                end if;

            else
                if v_schichtart.calc_basis = 'GLEITZ' then
                    v_dayabwstddiff := v_sastdprotag - ( v_dayarbstd + v_dayabwstd );
                    if
                        v_dayabwstddiff > 0
                        and ( v_dayarbstd > 0
                        or v_dayabwstd > 0 )
                    then
            -- Abweseneheitsdifferenz bei Gleitzeit hinten dran schreiben
                        if not pzm_p_schicht_tag.c_schicht_tag_fehlzeit_luecken_pruefen(p_pers_nr, v_schicht_datum, v_daysakurzname, v_sabeginn
                        , v_daycalcende + v_dayabwstddiff / 24,
                                                                                        v_daycalcstart, v_daycalcende, v_daycalcende,
                                                                                        v_kst_id, v_abt_id,
                                                                                        v_pb_id, v_dayabwstd, v_dayarbstd, v_daypausestd
                                                                                        , p_zaehler,
                                                                                        v_sastdprotag) then
                            if nvl(p_zaehler, 0) <= 1 then
                                update_pers_ze_tag(p_pers_nr,
                                                   v_schicht_datum,
                                                   p_result,
                                                   p_res_info,
                                                   nvl(p_zaehler, 0) + 1);

                                return;
                            end if;

                        end if;

                    end if;
      --  elsif v_DaySAKurzname != v_def_sa_kurzname and v_DayArbStd > 0 and v_DayAbwStd = 0                                     -- MWe Backup
      --        and (v_pers_schichtmodell.d_arb_std_pro_tag is null or v_DayArbStd < v_pers_schichtmodell.d_arb_std_pro_tag)     -- MWe Backup
      -- Wir haben eine normale Schichtart gefunden != Default und Stunden > 0 
                elsif
                    ( (
                        v_daysakurzname != v_def_sa_kurzname
                        and v_dayarbstd > 0
                        and v_dayabwstd = 0
                    )                                -- MWe Add P70460-15
                    or (
                        v_daysakurzname != v_def_sa_kurzname
                        and v_dayarbstd + v_dayabwstd < nvl(v_schichtart_daten.sa_std_pro_tag, v_pers_schichtmodell.d_arb_std_pro_tag
                        )
                    ) )
                    and ( nvl(v_schichtart_daten.sa_std_pro_tag, 1) != 0 )
                    and ( v_pers_schichtmodell.d_arb_std_pro_tag is null
                          or v_dayarbstd < v_pers_schichtmodell.d_arb_std_pro_tag )       -- MWe Add P70460-15
                then
                    if nvl(v_schichtart_daten.sa_std_pro_tag, v_pers_schichtmodell.d_arb_std_pro_tag) is not null then
            -- wenn eine Durchschnittsarbeitszeit definiert ist wird das Schichtende korrigiert
            -- debug
                        v_saende := v_daycalcanwstart + ( nvl(v_schichtart_daten.sa_std_pro_tag, v_pers_schichtmodell.d_arb_std_pro_tag
                        ) + v_daypausestd ) / 24;
            -- Mit Durchschnittsarbeitszeiten wird wie bei der Gleitzeit berechnet
                        if v_daycalcanwstart > v_sabeginn then
              -- spaeter angefangen, Ende um die Differenz des spaeter anfangens nach hinten verschieben
                            v_sabeginn := v_daycalcanwstart;
                        end if;
                    end if;

                    if not pzm_p_schicht_tag.c_schicht_tag_fehlzeit_luecken_pruefen(p_pers_nr, v_schicht_datum, v_daysakurzname, v_sabeginn
                    , v_saende,
                                                                                    v_daycalcanwstart, v_daycalcanwende, v_daycalcende
                                                                                    , v_kst_id, v_abt_id,
                                                                                    v_pb_id, v_dayabwstd, v_dayarbstd, v_daypausestd,
                                                                                    p_zaehler,
                                                                                    v_sastdprotag) then
                        if nvl(p_zaehler, 0) <= 1 then
                            update_pers_ze_tag(p_pers_nr,
                                               v_schicht_datum,
                                               p_result,
                                               p_res_info,
                                               nvl(p_zaehler, 0) + 1);

                            return;
                        end if;

                    end if;

                end if;
            end if;

            if
                ( v_dayarbstd = 0 )
                and ( v_dayabwstd > v_sastdprotag )
            then
                v_dayabwstd := v_sastdprotag;
            end if;

            if v_dayarbstd > v_sastdprotag then -- Wenn Ueberstunden geleistet wurden !!!
                v_flexmaxstdprowo := nvl(v_pers_schichtmodell.flex_max_std_pro_woche, 0);
                v_flexmaxstdprotag := 0;
                open c_schichtart_daten;
                fetch c_schichtart_daten into v_schichtart_daten;
                if c_schichtart_daten%found then
                    v_flexmaxstdprotag := v_schichtart_daten.flex_max_std_pro_tag;
                    if v_flexmaxstdprotag is null then
                        v_flexmaxstdprotag := ( 24 - v_sastdprotag ); -- alles als Flexistunden berechnen
                    end if;
                end if;

                close c_schichtart_daten;
        
        -- Kappung ermitteln
                if
                    v_kappung_schicht_ende = 'F'
                    and nvl(v_pers_schichtmodell.kappung_schicht_ende, 'F') = 'T'
                then
                    v_kappung_schicht_ende := 'T';
                end if;

        -- Ueberstunden-Schichten werden nicht gekappt
                if v_schichtart_daten.sa_standard = 'T'
                or v_ze_tagessatz.ts_ueb_ok_pers_nr is not null then
                    v_kappung_schicht_ende := 'F';
                end if;

                if
                    v_kappung_schicht_ende = 'T'
                    and v_dayarbstd > v_sastdprotag
                    and v_dayarbstd > v_kappung_te_ab_flx_std
                then
                    v_dayarbstd := v_kappung_te_ab_flx_std;
                end if;

                if v_flexmaxstdprotag = 0 then
          -- normale Ueberstundenrechnung ohne flexible Stunden
                    v_dayuebstd := v_dayarbstd - v_sastdprotag;
                else
          -- zuerst flexible Stunden ausrechnen
                    if v_dayarbstd > v_flexmaxstdprotag then
                        v_dayflexstd := v_flexmaxstdprotag - v_sastdprotag;
                        v_dayuebstd := v_dayarbstd - v_flexmaxstdprotag;
                    else
            -- alles ueber der Schichtarbeitszeit sind flexible stunden
                        v_dayflexstd := v_dayarbstd - v_sastdprotag;
                        if check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, v_schicht_datum) is not null then
                            if
                                trunc(v_daycalcende) > v_schicht_datum
                                and isi_utils.iso_weekday(v_schicht_datum + 1) not in ( 6, 7 )
                                and check_feiertag(v_pb_id, v_abt_id, v_pers_nr, v_kst_id, v_schicht_datum + 1) is null
                            then
                                v_dayflexstd := ( ( v_daycalcende - ( v_schicht_datum + 1 ) ) * 24 ) - v_daypausestd;

                                v_sastdprotag := ( ( v_daycalcende - v_daycalcstart ) * 24 ) - v_daypausestd - v_dayflexstd;
                --v_DayFlexStd := v_DayFlexStd + v_DayArbStd - ((v_DayCalcEnde - (v_schicht_datum + 1)) * 24);
                --v_SAStdProTag := v_SAStdProTag - v_DayFlexStd; 
                            else
                                v_dayflexstd := v_dayarbstd;
                                v_sastdprotag := 0;
                            end if;

                        end if;

                    end if;

                    if
                        v_dayflexstd > 0
                        and v_flexmaxstdprowo > 0
                        and ( v_daysakurzname = v_def_sa_kurzname
                        or nvl(v_schichtart_daten.sa_std_pro_tag, 1) = 0 )
                    then -- Wochenstunden pruefen
            -- Laut Euscher werden Wochenueberstunden nur an reinen Ueberstundentagen
            -- (ohne regulaere Schicht) berechnet
                        open c_arb_std_pro_woche;
                        fetch c_arb_std_pro_woche into
                            v_wo_arb_std,
                            v_wo_flex_std,
                            v_wo_ueb_std,
                            v_wo_feiertag_std;
                        if c_arb_std_pro_woche%found then
                            v_ges_arb_std_wo := v_wo_arb_std + v_wo_flex_std + v_wo_ueb_std + v_wo_feiertag_std + v_sastdprotag;
                            if v_ges_arb_std_wo >= v_flexmaxstdprowo then
                -- alle Flexstunden als Ueberstunden, da die Maximale flexible Wochenstundenzahl erreicht wurde
                                v_dayuebstd := v_dayuebstd + v_dayflexstd;
                                v_dayflexstd := 0;
                            elsif ( v_ges_arb_std_wo + v_dayflexstd ) >= v_flexmaxstdprowo then
                                v_std := ( v_ges_arb_std_wo + v_dayflexstd ) - v_flexmaxstdprowo; -- Differenz der zu viel angerechneten Flex-Stunden
                                if v_dayflexstd > v_std then
                  -- differenz auf die Ueberstunden verschieben
                                    v_dayuebstd := v_dayuebstd + v_std;
                                    v_dayflexstd := v_dayflexstd - v_std;
                                else
                  -- Minusstunden vermeiden
                  -- alle Flexstunden als Ueberstunden, da die Maximale flexible Wochenstundenzahl erreicht wurde
                                    v_dayuebstd := v_dayuebstd + v_dayflexstd;
                                    v_dayflexstd := 0;
                                end if;

                            end if;

                        end if;

                        close c_arb_std_pro_woche;
                    end if;

                end if;

                v_dayarbstd := v_sastdprotag;
                if
                    v_dayaastatus is null
                    and v_dayuebstd > 0
                then
                    v_dayabwstd := 0;
                end if;
            end if;

            if
                ist_feiertag(v_pers_nr, v_pb_id, v_abt_id, v_kst_id, v_schicht_datum,
                             v_sonderfeiertag) = 1
                and ( v_sonderfeiertag != 'H'
                or (
                    v_kenz_urlaub = true
                    and v_sonderfeiertag = 'H'
                ) )
                and v_dayflexstd = 0
            then
                v_dayflexstd := v_dayarbstd;
                v_dayarbstd := 0;
            end if;

      -- Rundungsfehler korrigieren (auf ganze Minuten runden)
            v_dayabwstd := round(round(v_dayabwstd * 60) / 60,
                                 3);
            v_dayarbstd := round(round(v_dayarbstd * 60) / 60,
                                 3);
            v_dayuebstd := round(round(v_dayuebstd * 60) / 60,
                                 3);
            v_dayflexstd := round(round(v_dayflexstd * 60) / 60,
                                  3);
            v_dayanwstd := round(round(v_dayanwstd * 60) / 60,
                                 3);
            v_daypausestd := round(round(v_daypausestd * 60) / 60,
                                   3);
            v_daypausebezstd := round(round(v_daypausebezstd * 60) / 60,
                                      3);
            if v_kenz_urlaub = false then
                if
                    v_kappung_te_ab_flx_std > 0
                    and v_kappung_te_ab_flx_std < v_dayflexstd + v_dayarbstd - v_dayreisepassivstd
                then
                    v_dayflexstd := v_kappung_te_ab_flx_std - v_dayarbstd + v_dayreisepassivstd;
                end if;
            end if;

      -- alles ok ... Daten in die Auswertungstabelle speichern/uebertragen
            update_tagessatz(p_pers_nr, v_schicht_datum, v_daycalcanwstart, v_daycalcanwende, v_daycalcstart,
                             v_daycalcende, v_daysakurzname, v_dayaastatus, v_dayabwstd, v_dayarbstd,
                             v_dayuebstd, v_dayflexstd, v_dayanwstd, v_daypausestd, v_dayarbstdgutsmin,
                             v_daypausebezstd);

            if
                ( v_dayaastatus is not null
                  or v_dayanwstd > 0 )
                and not v_found_wiedereing -- Nicht Wiedereingliederung
            then
                pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum, v_daycalcanwstart, v_daycalcanwende, v_daysakurzname
                ,
                                                             v_kst_id);
            end if;

            commit;
            p_result := 0;
            p_res_info := 'Tagessatz erfolgreich berechnet.';
        end if;

    else
        if pzm_p_schicht_tag.c_schicht_tag_fehltag_pruefen(p_pers_nr, v_schicht_datum) then
      -- neue Abwesenheits-Datensaetze wurden angelegt, Tagessatz neu berechnen
            update_pers_ze_tag(p_pers_nr,
                               v_schicht_datum,
                               p_result,
                               p_res_info,
                               nvl(p_zaehler, 0) + 1);

        end if;
    end if;

    commit;
end update_pers_ze_tag;
/


-- sqlcl_snapshot {"hash":"09741ced775d45ada37c73f38f471a6332502694","type":"PROCEDURE","name":"UPDATE_PERS_ZE_TAG","schemaName":"DIRKSPZM32","sxml":""}