create or replace package body dirkspzm32.pzm_p_zeit_bewertung is
  -----------------------------------------------------------------------------------------------
  -- Package Body: pzm_p_zeit_bewertung
  --
  -- DESIGN-PRINZIPIEN:
  --   - Kleine, fokussierte Funktionen mit klarer Verantwortung
  --   - Keine direkten DB-Schreibzugriffe (nur Lesen von Stammdaten)
  --   - Ausfuehrliches Logging fuer Nachvollziehbarkeit
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Private Konstanten
  -----------------------------------------------------------------------------------------------
    c_1_minute       constant number := 1 / ( 24 * 60 );
    c_default_raster constant number := 15;  -- Default: 15 Minuten

  -----------------------------------------------------------------------------------------------
  -- Private Hilfsfunktionen
  -----------------------------------------------------------------------------------------------

  /**
   * Extrahiert den Tagesbruchteil einer Zeit (0.0 bis <1.0)
   */
    function time_of_day (
        in_timestamp in date
    ) return number is
    begin
        return in_timestamp - trunc(in_timestamp);
    end;

  /**
   * Prueft ob ein Status zu den "Abwesenheits-aehnlichen" gehoert
   * (Abwesend, Dienstgang, Pause)
   */
    function is_abwesenheit_status (
        in_status in number
    ) return boolean is
    begin
        return in_status not in ( pzm_p_zeiterfassung.status_anwesend, pzm_p_zeiterfassung.status_service );
    end;

  /**
   * Berechnet die Anzahl der Rastereinheiten zwischen zwei Zeiten
   */
    function calc_raster_count (
        in_delta_minuten  in number,
        in_raster_minuten in number
    ) return number is
    begin
        if in_raster_minuten = 0
        or in_raster_minuten is null then
            return in_delta_minuten;
        end if;
        return in_delta_minuten / in_raster_minuten;
    end;

  -----------------------------------------------------------------------------------------------
  -- ?ffentliche Funktionen: Hilfsfunktionen
  -----------------------------------------------------------------------------------------------

  /**
   * Laedt die Bewertungskonfiguration fuer eine Person und Schichtart
   */
    function load_bewertung_config (
        in_pers_nr     in number,
        in_schicht_tag in date,
        in_schichtart  in pzm_schichtarten%rowtype
    ) return t_bewertung_config is

        v_config         t_bewertung_config;
        v_schicht_modell pzm_schicht_modelle%rowtype;
        v_personal       pzm_personal%rowtype;
        v_ze_tagessatz   pzm_ze_tagessatz%rowtype;
        v_kappung        varchar2(1 char);
        cursor c_ze_tagessatz is
        select
            t.*
        from
            pzm_ze_tagessatz t
        where
                t.ts_pers_nr = in_pers_nr
            and t.ts_datum = in_schicht_tag;

    begin
    -- Defaults
        v_config.raster_minuten := c_default_raster;
        v_config.gleitz_runden := true;
        v_config.beginn_gutschr_min := 0;
        v_config.ende_gutschr_min := 0;
        v_config.kappung_schicht_ende := false;
        v_config.calc_basis := nvl(in_schichtart.calc_basis, calc_basis_festschicht);
        v_config.sa_ende_nachlauf_min := nvl(in_schichtart.sa_ende_nachlauf_min, 0);
        v_config.sa_bewertung_beginn := nvl(in_schichtart.sa_bewertung_beginn, 0);

    -- Raster aus allgemeinen Parametern
        v_config.raster_minuten := nvl(to_number(pzm_p_base.get_allg_parameter_mandant(in_pers_nr, 'SCHICHT_FESTZ_RASTER_MIN')),
                                       c_default_raster);

    -- Gleitzeit-Runden aus allgemeinen Parametern
        v_config.gleitz_runden := upper(nvl(
            pzm_p_base.get_allg_parameter_mandant(in_pers_nr, 'SCHICHT_GLEITZ_RUNDEN'),
            'T'
        )) = 'T';

    -- Schichtmodell laden
        if pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modell) then
      -- Raster aus Schichtmodell ueberschreibt allgemeine Parameter
            if v_schicht_modell.rastermin is not null then
                v_config.raster_minuten := v_schicht_modell.rastermin;
        -- Bei Raster <= 1 Minute: Gleitzeit-Rundung deaktivieren
                if v_schicht_modell.rastermin <= 1 then
                    v_config.gleitz_runden := false;
                end if;
            end if;

      -- Gutschriften aus Schichtmodell
            v_config.beginn_gutschr_min := nvl(v_schicht_modell.beginn_gutschr_min, 0);
            v_config.ende_gutschr_min := nvl(v_schicht_modell.ende_gutschr_min, 0);
        end if;

    -- Raster darf nicht 0 sein
        if v_config.raster_minuten = 0 then
            v_config.raster_minuten := 1;
        end if;

    -- Kappung ermitteln
        v_kappung := 'F';
        if pzm_p_base.get_personal(in_pers_nr, v_personal) then
            v_kappung := nvl(v_personal.pers_kappung_schicht_ende, 'F');
        end if;

        if
            v_kappung = 'F'
            and nvl(v_schicht_modell.kappung_schicht_ende, 'F') = 'T'
        then
            v_kappung := 'T';
        end if;

    -- Ueberstunden-Schichten werden nicht gekappt
        if in_schichtart.sa_standard = 'T' then
            v_kappung := 'F';
        end if;

    -- Tagessatz pruefen (Ueberstunden-Freigabe hebt Kappung auf)
        if in_schicht_tag is not null then
            open c_ze_tagessatz;
            fetch c_ze_tagessatz into v_ze_tagessatz;
            if
                c_ze_tagessatz%found
                and v_ze_tagessatz.ts_ueb_ok_pers_nr is not null
                and v_kappung = 'T'
            then
                v_kappung := 'F';
            end if;

            close c_ze_tagessatz;
        end if;

        v_config.kappung_schicht_ende := ( v_kappung = 'T' );
        return v_config;
    end;

  -----------------------------------------------------------------------------------------------
  -- Private Kernfunktionen: Bewertung nach Schichttyp
  -----------------------------------------------------------------------------------------------

  /**
   * Bewertung fuer Gleitzeit
   * 
   * Bei Gleitzeit ist die gestempelte Zeit grundsaetzlich auch die berechnete Zeit,
   * aber mit optionaler Rundung auf das konfigurierte Raster.
   */
    procedure bewerte_gleitzeit (
        in_config            in t_bewertung_config,
        in_schicht           in t_schicht_zeiten,
        in_rec_start         in date,
        in_rec_end           in date,
        in_ze_status         in number,
        in_is_erster_eintrag in boolean,
        io_calc_start        in out date,
        io_calc_end          in out date
    ) is

        v_rec_start      date := in_rec_start;
        v_rec_end        date := in_rec_end;
        v_minuten_offset number;
        v_raster_count   number;
        v_gerundete_min  number;
        v_raster_min     number := in_config.raster_minuten;
    begin
    -- Gutschriften anwenden (nur bei Anwesend)
        if in_ze_status = pzm_p_zeiterfassung.status_anwesend then
            if
                in_is_erster_eintrag
                and in_config.beginn_gutschr_min > 0
            then
                v_rec_start := v_rec_start - ( in_config.beginn_gutschr_min / 60 / 24 );
            end if;

            if in_config.ende_gutschr_min > 0 then
                v_rec_end := v_rec_end + ( in_config.ende_gutschr_min / 60 / 24 );
            end if;

        end if;

    -- Bei Gleitzeit: Gestempelte Zeit = Berechnete Zeit (als Basis)
        io_calc_start := v_rec_start;
        io_calc_end := v_rec_end;

    -- Rahmenzeit-Ueberwachung: Schichtdaten nach Gutschriften neu laden
    -- (v_SABeginn ist hier immer = v_RecStartTime, ausser wenn Rahmenzeit ueberschritten)
        if io_calc_start < in_schicht.sa_beginn then
            io_calc_start := in_schicht.sa_beginn;
        end if;

    -- Gleitzeit-Rundung (nur wenn aktiviert und Raster >= 1 Minute)
        if not in_config.gleitz_runden
        or v_raster_min < 1 then
            return;
        end if;

    -- Startzeit-Rundung
        if v_rec_start is not null then
            v_minuten_offset := round((v_rec_start - trunc(v_rec_start, 'HH24')) * 24 * 60,
                                      3);

            v_raster_count := v_minuten_offset / v_raster_min;

      -- Rundungslogik: Bei Kommen wird fuer Anwesend aufgerundet (zu Ungunsten MA)
            if v_raster_count > trunc(v_raster_count) then
                if is_abwesenheit_status(in_ze_status) then
          -- Bei Abwesenheit abrunden (zu Gunsten MA)
                    v_raster_count := trunc(v_raster_count);
                else
          -- Bei Anwesend aufrunden (zu Ungunsten MA)
                    v_raster_count := trunc(v_raster_count) + 1;
                end if;
            end if;

            v_gerundete_min := v_raster_count * v_raster_min;

      -- Ueberlauf behandeln
            if v_gerundete_min >= 60 then
                io_calc_start := trunc(v_rec_start, 'HH24') + 1 / 24;
            else
                io_calc_start := trunc(v_rec_start, 'HH24') + ( v_gerundete_min / 60 / 24 );
            end if;

        end if;

    -- Endzeit-Rundung
        if v_rec_end is not null then
            v_minuten_offset := round((v_rec_end - trunc(v_rec_end, 'HH24')) * 24 * 60,
                                      3);

            v_raster_count := v_minuten_offset / v_raster_min;

      -- Rundungslogik: Bei Gehen wird fuer Anwesend abgerundet (zu Ungunsten MA)
            if v_raster_count > trunc(v_raster_count) then
                if is_abwesenheit_status(in_ze_status) then
          -- Bei Abwesenheit/Dienstgang aufrunden (zu Gunsten MA)
                    v_raster_count := trunc(v_raster_count) + 1;
                else
          -- Bei Anwesend abrunden (zu Ungunsten MA)
                    v_raster_count := trunc(v_raster_count);
                end if;
            end if;

            v_gerundete_min := v_raster_count * v_raster_min;

      -- Ueberlauf behandeln
            if v_gerundete_min >= 60 then
                io_calc_end := trunc(v_rec_end, 'HH24') + 1 / 24;
            else
                io_calc_end := trunc(v_rec_end, 'HH24') + ( v_gerundete_min / 60 / 24 );
            end if;

        end if;

        pzm_p_log.debug('Gleitzeit bewertet: '
                        || 'Rec='
                        || to_char(in_rec_start, 'HH24:MI')
                        || '-'
                        || to_char(in_rec_end, 'HH24:MI')
                        || ' -> Calc='
                        || to_char(io_calc_start, 'HH24:MI')
                        || '-'
                        || to_char(io_calc_end, 'HH24:MI')
                        || ' (Raster='
                        || v_raster_min
                        || 'min, Runden='
                        ||
            case
                when in_config.gleitz_runden then
                    'T'
                else
                    'F'
            end
                        || ')',
                        pzm_p_log.cat_zeiterfassung,
                        'bewerte_gleitzeit');

    end;

  /**
   * Bewertung fuer Kommen bei Festschicht
   */
    procedure bewerte_kommen_festschicht (
        in_config            in t_bewertung_config,
        in_schicht           in t_schicht_zeiten,
        in_rec_start         in date,
        in_rec_end           in date,
        in_ze_status         in number,
        in_is_erster_eintrag in boolean,
        io_calc_start        in out date
    ) is

        v_rec_start      date := in_rec_start;
        v_soll_ist_delta number;
        v_anz_raster     number;
        v_beginn_delta   number := 0;
        v_raster_min     number := in_config.raster_minuten * c_1_minute;
    begin
    -- Bewertete Startzeit initial auf Schichtbeginn setzen
        io_calc_start := in_schicht.sa_beginn;

    -- Nur wenn die Zeiten keine 00:00 Uhrzeit haben
        if
            in_rec_start <= trunc(in_rec_start)
            and in_rec_end <= trunc(in_rec_end)
        then
            return;
        end if;

    -- Gutschrift anwenden (nur fuer ersten Anwesend-Eintrag)
        if
            in_is_erster_eintrag
            and in_ze_status = pzm_p_zeiterfassung.status_anwesend
            and in_config.beginn_gutschr_min > 0
        then
            v_rec_start := v_rec_start - ( in_config.beginn_gutschr_min / 60 / 24 );
        end if;

    -- Pruefen ob zu spaet gekommen
        if io_calc_start >= v_rec_start then
            return; -- Puenktlich oder frueher
        end if;

    -- Zu spaet: Berechne Verspaetung
        v_soll_ist_delta := round((v_rec_start - in_schicht.sa_beginn) * 24 * 60, 3);

        v_anz_raster := v_soll_ist_delta / round(v_raster_min * 24 * 60, 3);

    -- Rundung: Bei Bruchzahlen
        if v_anz_raster > trunc(v_anz_raster) then
            if is_abwesenheit_status(in_ze_status) then
                v_anz_raster := trunc(v_anz_raster); -- Abrunden (zu Gunsten MA)
            else
                v_anz_raster := trunc(v_anz_raster) + 1; -- Aufrunden (zu Ungunsten MA)
            end if;
        end if;

        v_beginn_delta := v_anz_raster * v_raster_min;
        io_calc_start := in_schicht.sa_beginn + v_beginn_delta;
        pzm_p_log.debug('Festschicht Kommen bewertet: '
                        || 'Rec='
                        || to_char(v_rec_start, 'HH24:MI')
                        || ', Schicht='
                        || to_char(in_schicht.sa_beginn, 'HH24:MI')
                        || ' -> Calc='
                        || to_char(io_calc_start, 'HH24:MI')
                        || ' (Delta='
                        || round(v_beginn_delta * 24 * 60)
                        || 'min)',
                        pzm_p_log.cat_zeiterfassung,
                        'bewerte_kommen_festschicht');

    end;

  /**
   * Bewertung fuer Gehen bei Festschicht
   */
    procedure bewerte_gehen_festschicht (
        in_config     in t_bewertung_config,
        in_schicht    in t_schicht_zeiten,
        in_rec_start  in date,
        in_rec_end    in date,
        in_ze_status  in number,
        io_calc_start in date,
        io_calc_end   in out date
    ) is

        v_rec_end        date := in_rec_end;
        v_sa_ende2       date := in_schicht.sa_ende_effektiv;
        v_soll_ist_delta number;
        v_anz_raster     number;
        v_ende_delta     number := 0;
        v_raster_min     number := in_config.raster_minuten * c_1_minute;
    begin
    -- Spezialfall: 0 Minuten gestempelt
        if
            in_rec_start = in_rec_end
            and io_calc_end is null
        then
            io_calc_end := io_calc_start;
            return;
        end if;

    -- Bewertete Endzeit initial auf Schichtende setzen
        io_calc_end := v_sa_ende2;

    -- Nur wenn die Zeiten keine 00:00 Uhrzeit haben
        if
            in_rec_start <= trunc(in_rec_start)
            and in_rec_end <= trunc(in_rec_end)
        then
            return;
        end if;

    -- Gutschrift anwenden (nur bei Anwesend)
        if
            in_ze_status = pzm_p_zeiterfassung.status_anwesend
            and in_config.ende_gutschr_min > 0
        then
            v_rec_end := v_rec_end + ( in_config.ende_gutschr_min / 60 / 24 );
        end if;

    -- Fall 1: Frueher gegangen (oder Dienstgang)
        if io_calc_end > v_rec_end
        or in_ze_status = pzm_p_zeiterfassung.status_dienstgang then
            v_soll_ist_delta := round((io_calc_end - v_rec_end) * 24 * 60, 3);
            v_anz_raster := v_soll_ist_delta / round(v_raster_min * 24 * 60, 3);
            if v_anz_raster <> trunc(v_anz_raster) then
                if is_abwesenheit_status(in_ze_status) then
                    if v_anz_raster < 0
                    or in_ze_status = pzm_p_zeiterfassung.status_dienstgang then
                        v_anz_raster := trunc(v_anz_raster); -- Bei negativen Werten / Dienstgang
                    else
                        v_anz_raster := trunc(v_anz_raster) - 1; -- Abrunden
                    end if;

                else
                    v_anz_raster := trunc(v_anz_raster) + 1; -- Aufrunden
                end if;
            end if;

            v_ende_delta := v_anz_raster * v_raster_min;
            io_calc_end := v_sa_ende2 - v_ende_delta;

    -- Fall 2: Ueberstunden (spaeter gegangen)
        elsif ( io_calc_end + v_raster_min ) <= v_rec_end then
            v_soll_ist_delta := round((v_rec_end - io_calc_end) * 24 * 60, 3);
            v_anz_raster := trunc(v_soll_ist_delta / round(v_raster_min * 24 * 60, 3)); -- Grundsaetzlich abrunden
            v_ende_delta := v_anz_raster * v_raster_min;
            io_calc_end := v_sa_ende2 + v_ende_delta;

      -- Nachlaufzeit-Puffer (Feierabendzeit)
            if in_config.sa_ende_nachlauf_min > 0 then
                if io_calc_end < v_sa_ende2 + ( in_config.sa_ende_nachlauf_min / 60 / 24 ) then
                    io_calc_end := v_sa_ende2;
                end if;
            end if;

      -- Bei Abwesenheit keine Ueberstunden
            if in_ze_status = pzm_p_zeiterfassung.status_abwesend then
                io_calc_end := in_schicht.sa_ende;
            end if;
        end if;

        pzm_p_log.debug('Festschicht Gehen bewertet: '
                        || 'Rec='
                        || to_char(v_rec_end, 'HH24:MI')
                        || ', Schicht='
                        || to_char(v_sa_ende2, 'HH24:MI')
                        || ' -> Calc='
                        || to_char(io_calc_end, 'HH24:MI')
                        || ' (Delta='
                        || round(v_ende_delta * 24 * 60)
                        || 'min)',
                        pzm_p_log.cat_zeiterfassung,
                        'bewerte_gehen_festschicht');

    end;

  /**
   * Kappung am Schichtende anwenden
   */
    procedure apply_kappung (
        in_config    in t_bewertung_config,
        in_schicht   in t_schicht_zeiten,
        in_ist_ende  in date,
        in_ze_status in number,
        io_calc_end  in out date
    ) is
    begin
        if not in_config.kappung_schicht_ende then
            return;
        end if;
        if
            io_calc_end > in_schicht.sa_ende_effektiv
            and in_ist_ende > in_schicht.sa_ende_effektiv
            and in_ze_status = pzm_p_zeiterfassung.status_anwesend
        then
            pzm_p_log.debug('Kappung angewendet: '
                            || to_char(io_calc_end, 'HH24:MI')
                            || ' -> '
                            || to_char(in_schicht.sa_ende_effektiv, 'HH24:MI'),
                            pzm_p_log.cat_zeiterfassung,
                            'apply_kappung');

            io_calc_end := in_schicht.sa_ende_effektiv;
        end if;

    end;

  /**
   * Finale Validierung und Korrektur
   */
    procedure finalize_result (
        io_calc_start in out date,
        io_calc_end   in out date
    ) is
    begin
    -- Ende vor Start: Fehlerkorrektur
        if io_calc_end < io_calc_start then
            io_calc_end := io_calc_start;
        end if;

    -- Ende mehr als 24h nach Start: Fehlerkorrektur
        if io_calc_end > io_calc_start + 1 then
            io_calc_end := io_calc_start;
        end if;
    end;

  -----------------------------------------------------------------------------------------------
  -- OEffentliche API: Hauptfunktion
  -----------------------------------------------------------------------------------------------

    function bewerte_ist_zeiten (
        in_pers_nr           in number,
        in_ist_start         in date,
        in_ist_ende          in date,
        in_ze_status         in number,
        in_calc_ist_start    in date default null,
        in_calc_ist_ende     in date default null,
        in_schicht_tag       in date default null,
        in_sa_kurzname       in varchar2 default null,
        in_is_erster_eintrag in boolean default false
    ) return t_bewertung_result is

        v_result         t_bewertung_result;
        v_config         t_bewertung_config;
        v_schicht        t_schicht_zeiten;
        v_schichtart     pzm_schichtarten%rowtype;
        v_schicht_modell pzm_schicht_modelle%rowtype;
        v_rec_start      date := in_ist_start;
        v_rec_end        date := in_ist_ende;
        v_calc_start     date := in_calc_ist_start;
        v_calc_end       date := in_calc_ist_ende;
        v_schicht_tag    date := in_schicht_tag;
        v_sa_kurzname    pzm_schichtarten.sa_kurzname%type := in_sa_kurzname;
        v_sa_found       boolean;
    begin
    -- Schichtmodell laden (erforderlich f?r Bewertung)
        if not pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modell) then
            pzm_p_log.warning('Kein Schichtmodell fuer PersNr='
                              || in_pers_nr
                              || ' - keine Bewertung moeglich', pzm_p_log.cat_zeiterfassung, 'bewerte_ist_zeiten');
      -- Minimales Ergebnis zurueckgeben
            v_result.calc_ist_start := in_calc_ist_start;
            v_result.calc_ist_ende := in_calc_ist_ende;
            v_result.schicht_tag := in_schicht_tag;
            v_result.sa_kurzname := in_sa_kurzname;
            return v_result;
        end if;

    -- Ohne Startzeiten keine Bewertung
        if
            v_rec_start is null
            and v_calc_start is null
        then
            v_result.calc_ist_start := null;
            v_result.calc_ist_ende := null;
            return v_result;
        end if;

    -- Fallback: Wenn keine gestempelte Zeit, dann berechnete Zeit verwenden
        if
            v_rec_start is null
            and v_calc_start is not null
        then
            v_rec_start := v_calc_start;
        end if;
        if
            v_rec_end is null
            and v_calc_end is not null
        then
            v_rec_end := v_calc_end;
        end if;

    -- Schichtdaten ermitteln
        v_sa_found := get_schicht_daten(in_pers_nr, v_rec_start, v_schicht_tag, v_sa_kurzname, v_schicht.sa_beginn,
                                        v_schicht.sa_ende, v_schicht.sa_std_pro_tag) = 1;

        v_schicht.schicht_tag := v_schicht_tag;
        v_schicht.sa_kurzname := v_sa_kurzname;

    -- Bei offenem Ende: Nur Schichtdaten zurueckgeben
        if
            v_rec_start is not null
            and v_rec_end is null
        then
            v_result.schicht_tag := v_schicht_tag;
            v_result.sa_kurzname := v_sa_kurzname;
            return v_result;
        end if;

    -- Ohne Schichtdaten keine weitere Bewertung
        if not v_sa_found then
            pzm_p_log.error('Keine Schichtdaten fuer PersNr='
                            || in_pers_nr
                            || ', Zeiten='
                            || to_char(v_rec_start, 'YYYY-MM-DD HH24:MI')
                            || ' - '
                            || to_char(v_rec_end, 'YYYY-MM-DD HH24:MI'),
                            pzm_p_log.cat_zeiterfassung,
                            'bewerte_ist_zeiten');

            v_result.calc_ist_start := v_calc_start;
            v_result.calc_ist_ende := v_calc_end;
            return v_result;
        end if;

    -- Schichtart laden
        if not pzm_p_base.get_schichtart_by_uix(v_sa_kurzname, v_schichtart) then
            pzm_p_log.error('Keine Schichtart fuer SA_Kurzname=' || v_sa_kurzname, pzm_p_log.cat_zeiterfassung, 'bewerte_ist_zeiten')
            ;
            v_result.calc_ist_start := v_calc_start;
            v_result.calc_ist_ende := v_calc_end;
            v_result.schicht_tag := v_schicht_tag;
            v_result.sa_kurzname := v_sa_kurzname;
            return v_result;
        end if;

    -- Effektives Schichtende berechnen (fuer Nachtschichten)
        v_schicht.sa_ende_effektiv := trunc(v_schicht.sa_ende) + time_of_day(v_schichtart.sa_ende);

        if v_schicht.sa_ende_effektiv < v_schicht.sa_beginn then
            v_schicht.sa_ende_effektiv := v_schicht.sa_ende_effektiv + 1;
        end if;

    -- Konfiguration laden
        v_config := load_bewertung_config(in_pers_nr, v_schicht_tag, v_schichtart);

    -- Ganztag-Eintrag erkennen (calc_start und calc_end sind beide Mitternacht)
        if
            trunc(v_calc_start) = v_calc_start
            and trunc(v_calc_end) = v_calc_end
        then
            v_calc_start := v_schicht.sa_beginn;
            v_calc_end := v_schicht.sa_ende;
        end if;

    -- Bewertung je nach Schichttyp
        if v_config.calc_basis = calc_basis_gleitzeit then
      -- GLEITZEIT-Bewertung
            if v_calc_start is null
               or v_calc_end is null
            or (
                v_calc_end = v_schicht.sa_ende_effektiv
                and not v_config.kappung_schicht_ende
            ) then
                bewerte_gleitzeit(
                    in_config            => v_config,
                    in_schicht           => v_schicht,
                    in_rec_start         => v_rec_start,
                    in_rec_end           => v_rec_end,
                    in_ze_status         => in_ze_status,
                    in_is_erster_eintrag => in_is_erster_eintrag,
                    io_calc_start        => v_calc_start,
                    io_calc_end          => v_calc_end
                );

            end if;
        else
      -- FESTSCHICHT-Bewertung
            if v_calc_start is null then
                bewerte_kommen_festschicht(
                    in_config            => v_config,
                    in_schicht           => v_schicht,
                    in_rec_start         => v_rec_start,
                    in_rec_end           => v_rec_end,
                    in_ze_status         => in_ze_status,
                    in_is_erster_eintrag => in_is_erster_eintrag,
                    io_calc_start        => v_calc_start
                );
            end if;

            if v_calc_end is null
               or (
                v_calc_end = v_schicht.sa_ende_effektiv
                and not v_config.kappung_schicht_ende
                and v_rec_end != v_rec_start
            ) then
                bewerte_gehen_festschicht(
                    in_config     => v_config,
                    in_schicht    => v_schicht,
                    in_rec_start  => v_rec_start,
                    in_rec_end    => v_rec_end,
                    in_ze_status  => in_ze_status,
                    io_calc_start => v_calc_start,
                    io_calc_end   => v_calc_end
                );

            end if;

        end if;

    -- Kappung anwenden
        apply_kappung(v_config, v_schicht, in_ist_ende, in_ze_status, v_calc_end);

    -- Finale Validierung
        finalize_result(v_calc_start, v_calc_end);

    -- Ergebnis zusammenstellen
        v_result.calc_ist_start := v_calc_start;
        v_result.calc_ist_ende := v_calc_end;
        v_result.schicht_tag := v_schicht_tag;
        v_result.sa_kurzname := v_sa_kurzname;
        if
            v_calc_start is not null
            and v_calc_end is not null
        then
            v_result.ze_std := round((v_calc_end - v_calc_start) * 24, 3);
        end if;

        return v_result;
    end;

end;
/


-- sqlcl_snapshot {"hash":"a65faeaa28461d0451a2aa8aea28894ff9b4a619","type":"PACKAGE_BODY","name":"PZM_P_ZEIT_BEWERTUNG","schemaName":"DIRKSPZM32","sxml":""}