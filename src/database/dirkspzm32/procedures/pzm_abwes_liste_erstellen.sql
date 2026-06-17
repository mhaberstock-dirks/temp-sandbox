create or replace 
procedure DIRKSPZM32.PZM_ABWES_LISTE_ERSTELLEN(in_start_date in date,
                                                                in_end_date in date,
                                                                in_pers_nr in pzm_abwes_plan.pers_nr%type
                                                                ) is
  v_start_date date;
  v_end_date date;
  v_current_date date;
  v_last_date date;

  v_pers_nr number;
  v_pb_id number;
  v_abt_id number;
  v_kst_id number;
  v_anw_std number;
  v_tag_faktor number; -- Faktor 0.5 oder 1.0 (nur für Anträge/Meldungen)
                       
  v_aa_id number;
  v_last_aa_id number;
  v_aa_kurzname pzm_abwes_plan.aa_kurzname%type;
  v_aa_farbe number;
  v_feiertag pzm_abwes_plan.kennz_feiertag%type;
  v_wochentag pzm_abwes_plan.wochentag_kurz%type;
  v_wochentag_id integer;
  
  v_found_end_date date; -- Speichert das Enddatum eines gefundenen Antrags/Meldung, um die Schleife ggf. zu verlängern.

  v_SAKurzname     pzm_schichtarten.sa_kurzname%type; -- varchar2(10);
  v_SABeginn       pzm_schichtarten.sa_beginn%type; --  date;
  v_SAEnde         pzm_schichtarten.sa_ende%type; -- date;
  v_SAStdProTag    number;
  v_schicht_vorh   boolean;

  cursor c_pers is
    select t.pers_nr,
           t.pers_abt_id,
           t.pers_pb_id,
           t.pers_kst_id
      from pzm_personal t
     where t.pers_nr = in_pers_nr or in_pers_nr is null;

  cursor c_ze is
    select nvl(t.ts_day_anw_std, 0),
           t.ts_aa_id,
           aa.aa_kurzname,
           aa.aa_farbe
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten aa
     where t.ts_pers_nr = v_pers_nr
       and trunc(t.ts_datum) = v_current_date -- Fix: Sicherstellen dass Uhrzeiten ignoriert werden
       --and (nvl(t.ts_day_anw_std, 0) = 0 and aa.aa_kurzname = 'FLX-Abbau' or aa.aa_kurzname != 'FLX-Abbau')
       and aa.aa_id(+) = t.ts_aa_id;

  cursor c_am is
    select t.aa_id,
           aa.aa_kurzname,
           aa.aa_farbe,
           trunc(t.ende), -- Enddatum selektieren, um Prüfung auf Zeitraumverlängerung zu ermöglichen
           1.0 -- Standard-Faktor für Meldungen          
      from pzm_abwesenheitsmeldungen t,
           pzm_abwesenheitsarten aa
     where t.pers_nr = v_pers_nr
       and trunc(t.beginn) <= v_current_date
       and trunc(t.ende) >= v_current_date
       and aa.aa_id = t.aa_id;

  cursor c_ua is
    select t.au_abwes_art,
           aa.aa_kurzname,
           aa.aa_farbe,
           trunc(t.au_ende), -- Enddatum selektieren, um Prüfung auf Zeitraumverlängerung zu ermöglichen
           nvl(t.au_utage, 1.0) -- Faktor 0.5 oder 1.0 aus dem Antrag                                    
      from pzm_abwesenheits_antr t,
           pzm_abwesenheitsarten aa
     where t.au_pers_nr = v_pers_nr
       and trunc(t.au_beginn) <= v_current_date
       and trunc(t.au_ende) >= v_current_date
       and t.au_status = 1 -- geprüft und genehmigt
       and aa.aa_id = t.au_abwes_art;

  v_found boolean;
  v_ze_handled boolean;
begin

  open c_pers;
  loop
    v_start_date := trunc(in_start_date); -- Fix: Eingehende Daten truncen
    v_end_date := trunc(in_end_date);
    if v_start_date is NULL
    then
      v_start_date := add_months(trunc(sysdate), -2);
    end if;
    if v_end_date is NULL
    then
      v_end_date := add_months(trunc(sysdate), 12);
    end if;
    fetch c_pers into v_pers_nr, v_pb_id, v_abt_id, v_kst_id;
    exit when c_pers%notfound;
    
    -- Initialisieren der Vergleichsvariablen
    v_last_aa_id := null;
    v_last_date := NULL;
    select nvl(min(t.abwes_liste_von), v_start_date) into v_start_date
      from pzm_abwes_liste t 
     where t.pers_nr = v_pers_nr
       and trunc(t.abwes_liste_von) <= v_start_date
       and trunc(t.abwes_liste_bis) >= v_start_date;

    v_start_date := trunc(v_start_date);
    v_end_date := trunc(v_end_date);

    delete pzm_abwes_liste t
      where t.pers_nr = v_pers_nr
        and ((t.abwes_liste_von between v_start_date and v_end_date) 
           --or t.quelle != 'ZE'
           );

    v_current_date := v_start_date;
        
    while v_current_date <= v_end_date
    loop
      -- Fix: Variablen zu Beginn jedes Tages zurücksetzen um "Mitnahme" von Werten des Vortags zu verhindern
      v_aa_kurzname := null;
      v_aa_id := null;
      v_anw_std := 0;
      v_tag_faktor := 0;
      v_ze_handled := false; -- Reset für jeden Tag
            
      v_aa_farbe := null;
      v_found_end_date := null; -- NEU: Reset für den neuen Tag

      v_wochentag := to_char(v_current_date, 'Dy');
      v_wochentag_id := isi_utils.Iso_WeekDay(v_current_date);
      
      v_feiertag := 'F';
      if check_feiertag(v_pb_id,
                        v_abt_id,
                        v_pers_nr,
                        v_kst_id,
                        v_current_date) in ('F', 'SF')
      then
        v_feiertag := 'T';
      end if;

      v_SAKurzname := null;
      v_schicht_vorh := get_schicht_daten(v_pers_nr, v_current_date, v_current_date, v_SAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) = 1;

                                  
      open c_ze; -- Zeiterfassung
      fetch c_ze into v_anw_std, v_aa_id, v_aa_kurzname, v_aa_farbe;
      v_found := c_ze%found;
      close c_ze;
      if v_aa_kurzname like 'K%' and v_aa_kurzname != 'KUG'
      then  -- Krank immer durchgehen Zählen
        v_schicht_vorh := true;
        v_feiertag := 'F';
      elsif v_aa_kurzname = 'V-ARB-Zeit'
      then
        v_schicht_vorh := False;
      end if;

      if v_found
      then
        -- Fix: Erlaubt Krankheit ('K%') auch wenn Arbeitsstunden vorhanden sind (v_anw_std > 0)
        if v_feiertag = 'F' and v_schicht_vorh and (v_anw_std = 0 or v_aa_kurzname like 'K%')
        then
          v_ze_handled := true; 
          if v_aa_id is not NULL
          then
            if v_last_aa_id = v_aa_id
            then
              update pzm_abwes_liste t
                 set t.abwes_liste_bis = v_current_date,
                     t.abwes_anz_tage = t.abwes_anz_tage + 1
               where t.pers_nr = v_pers_nr
                 and t.abwes_liste_von = v_last_date;
            else
              delete pzm_abwes_liste t
                 where t.pers_nr = v_pers_nr
                   and t.abwes_liste_von = v_current_date;
              v_last_date := v_current_date;
              v_last_aa_id := v_aa_id;

              insert into pzm_abwes_liste
                (pers_nr, 
                 abwes_liste_von, 
                 abwes_liste_bis, 
                 abwes_anz_tage, 
                 kennz_feiertag, 
                 monat, 
                 aa_id, 
                 aa_kurzname, 
                 aa_farbe, 
                 quelle)
              values
                (v_pers_nr,
                 v_current_date,
                 v_current_date,
                 1,
                 v_feiertag,
                 trunc(v_current_date, 'Month'),
                 v_aa_id,
                 v_aa_kurzname,
                 v_aa_farbe,
                 'ZE');
            end if;
            commit;
          else
            v_last_aa_id := NULL;
          end if;
        elsif v_anw_std > 0 or v_wochentag_id < 6
        then
          v_last_aa_id := NULL;
        end if;
      end if;

      if not v_ze_handled -- Wenn ZE keine Abwesenheit erzeugt hat (z.B. weil gearbeitet wurde), prüfe Anträge/Meldungen
      then
        if v_feiertag = 'F' and v_wochentag_id < 6 and v_current_date <= trunc(sysdate) or v_current_date = trunc(sysdate)
        then
          if v_aa_kurzname not like 'K%'
          or v_aa_kurzname = 'KUG'
          then
            v_last_aa_id := NULL;
          end if;
        end if;

        open c_am; -- Abwesenheitsmeldung
        fetch c_am into v_aa_id, v_aa_kurzname, v_aa_farbe, v_found_end_date, v_tag_faktor; -- Enddatum & Faktor abrufen
        v_found := c_am%found;
        close c_am;

        if v_found
        then
          -- Wenn der gefundene Eintrag über das geplante Ende hinausgeht, muss der Verarbeitungszeitraum verlängert werden, damit der Eintrag nicht abgeschnitten wird.
          if v_found_end_date > v_end_date then
              v_end_date := v_found_end_date;
          end if;

          if v_feiertag = 'F' and v_schicht_vorh
          then
            if v_last_aa_id = v_aa_id
            then
              update pzm_abwes_liste t
                  set t.abwes_liste_bis = v_current_date,
                      t.abwes_anz_tage = t.abwes_anz_tage + v_tag_faktor -- Faktor aus c_am
                where t.pers_nr = v_pers_nr
                  and t.abwes_liste_von = v_last_date;
            else
              delete pzm_abwes_liste t
                  where t.pers_nr = v_pers_nr
                    and t.abwes_liste_von = v_current_date;
              v_last_date := v_current_date;
              v_last_aa_id := v_aa_id;

              insert into pzm_abwes_liste
                (pers_nr, 
                  abwes_liste_von, 
                  abwes_liste_bis, 
                  abwes_anz_tage, 
                  kennz_feiertag, 
                  monat, 
                  aa_id, 
                  aa_kurzname, 
                  aa_farbe, 
                  quelle)
              values
                (v_pers_nr,
                  v_current_date,
                  v_current_date,
                  v_tag_faktor, -- Faktor aus c_am
                  v_feiertag,
                  trunc(v_current_date, 'Month'),
                  v_aa_id,
                  v_aa_kurzname,
                  v_aa_farbe,
                  'ABWM');
            end if;
            commit;
          end if;
        else
          open c_ua; -- Urlaubsantrag
          fetch c_ua into v_aa_id, v_aa_kurzname, v_aa_farbe, v_found_end_date, v_tag_faktor; -- Enddatum & Faktor abrufen
          v_found := c_ua%found;
          close c_ua;

          if v_found
          then
            -- Wenn der gefundene Eintrag über das geplante Ende hinausgeht, muss der Verarbeitungszeitraum verlängert werden, damit der Eintrag nicht abgeschnitten wird.
            if v_found_end_date > v_end_date then
                v_end_date := v_found_end_date;
            end if;

            if v_feiertag = 'F' and v_schicht_vorh
            then
              if v_last_aa_id = v_aa_id
              then
                update pzm_abwes_liste t
                    set t.abwes_liste_bis = v_current_date,
                        t.abwes_anz_tage = t.abwes_anz_tage + v_tag_faktor -- Faktor aus c_ua
                  where t.pers_nr = v_pers_nr
                    and t.abwes_liste_von = v_last_date;
              else
                delete pzm_abwes_liste t
                  where t.pers_nr = v_pers_nr
                    and t.abwes_liste_von = v_current_date;
                v_last_date := v_current_date;
                v_last_aa_id := v_aa_id;

                insert into pzm_abwes_liste
                  (pers_nr, 
                    abwes_liste_von, 
                    abwes_liste_bis, 
                    abwes_anz_tage, 
                    kennz_feiertag, 
                    monat, 
                    aa_id, 
                    aa_kurzname, 
                    aa_farbe, 
                    quelle)
                  values
                    (v_pers_nr,
                     v_current_date,
                     v_current_date,
                     v_tag_faktor, -- Faktor aus c_ua
                     v_feiertag,
                     trunc(v_current_date, 'Month'),
                     v_aa_id,
                     v_aa_kurzname,
                     v_aa_farbe,
                     'ABWM');
              end if;
            end if;
            commit;
          else
            v_last_aa_id := NULL;
          end if;
        end if;
      end if;
      v_current_date := v_current_date + 1;
    end loop;

  end loop;
  close c_pers;
  commit;
end;
/



-- sqlcl_snapshot {"hash":"ae000c039cd7b36e0b7163bdc4f611b4c13f2515","type":"PROCEDURE","name":"PZM_ABWES_LISTE_ERSTELLEN","schemaName":"DIRKSPZM32","sxml":""}