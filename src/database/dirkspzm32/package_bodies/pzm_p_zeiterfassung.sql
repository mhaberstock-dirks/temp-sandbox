create or replace package body dirkspzm32.pzm_p_zeiterfassung is
  -----------------------------------------------------------------------------------------------
  -- Package Body: pzm_p_zeiterfassung
  --
  -- DESIGN-PRINZIPIEN:
  --   - Alle Berechnungen (Schichttag, calc_ist_start/ende, ze_std) werden deterministisch
  --     VOR dem INSERT/UPDATE ausgefuehrt
  --   - Private Hilfsfunktionen sind nur innerhalb des Packages sichtbar
  --   - Oeffentliche API beschraenkt sich auf konkrete Use-Case Handler
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Private Konstanten
  -----------------------------------------------------------------------------------------------
    c_max_std_offen_default constant number := 11;  -- 11 Stunden (Default Ruhezeit)

  -- Default Timezone f?r Legacy-Aufrufe ohne explizite Timezone-Angabe
  -- TODO: Nach vollst?ndiger Client-Migration kann diese Konstante entfernt werden
    c_default_timezone      constant varchar2(50 char) := 'Europe/Berlin';

  -----------------------------------------------------------------------------------------------
  -- PRIVATE HILFSFUNKTIONEN: Stammdaten und Konfiguration
  -----------------------------------------------------------------------------------------------

  /**
   * Liefert die maximal erlaubte Offenzeit (in Stunden) fuer
   * offene Zeiterfassungs-Eintraege des angegebenen Mitarbeiters.
   * Wird fuer die Schichtfindung und 'auto close' verwendet
   */
    function get_max_std_offen (
        in_pers_nr in number
    ) return number is
        v_schicht_modell pzm_schicht_modelle%rowtype;
    begin
    -- Haelfte der vorgeschriebenen Ruhezeit als Karenz oben drauf
        if pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modell) then
            return nvl(v_schicht_modell.kappung_te_ab_flx_std, c_max_std_offen_default) + 6;
        else
            return c_max_std_offen_default + 6;
        end if;
    end;

  /**
   * Liefert den Zeiterfassungs-Status basierend auf der angegebenen Aktion.
   */
    function get_ze_status_from_aktion (
        in_aktion in varchar2
    ) return number is
    begin
        return
            case upper(in_aktion)
                when aktion_kommen     then
                    status_anwesend
                when aktion_gehen      then
                    status_anwesend
                when aktion_pause      then
                    status_pause
                when aktion_dienstgang then
                    status_dienstgang
                when aktion_service    then
                    status_service
                else
                    status_anwesend
            end;
    end;

  /**
   * Prueft ob die uebergebene Aktion eine Start-Aktion ist (Kommen, Pausenbeginn, Dienstgangbeginn, ...).
   */
    function is_start_aktion (
        in_aktion in varchar2
    ) return boolean is
    begin
        return upper(in_aktion) not in ( aktion_gehen );
    end;

  /**
   * Liefert den Zeiterfassungs-Typ basierend auf der angegebenen Quelle.
   */
    function get_ze_typ_from_quelle (
        in_quelle in varchar2
    ) return varchar2 is
    begin
        if in_quelle = quelle_terminal then
            return typ_terminal;
        elsif in_quelle = quelle_live then
            return typ_live;
        elsif in_quelle = quelle_app then
            return typ_offline;
        else
            return typ_manuell;
        end if;
    end;

  -----------------------------------------------------------------------------------------------
  -- PRIVATE HILFSFUNKTIONEN: Kontext-Laden
  -----------------------------------------------------------------------------------------------

  /**
   * Liefert die RFID (bzw. Transponder-Code) des Mitarbeiters basierend auf der Personalnummer.
   * Legacy-Note: derzeit wird f?r die Zuordnung von Transponder-Nummern auf Mitarbeiter
   * die Tabelle ISI_USER verwendet.
   * In Zukunft k?nnte dies ?ber eine separate Zuordnungstabelle erfolgen,
   * um die Abh?ngigkeit von ISI_USER zu entfernen.
   */
    function get_rfid (
        in_pers_nr in isi_user.pers_nr%type
    ) return varchar2 is

        v_transponder isi_user.transponder%type;
        cursor c_rfid_user is
        select
            u.transponder
        from
            isi_user u
        where
            u.pers_nr = in_pers_nr;

    begin
    -- use cursor here to avoid 'ORA-01403: no data found' error
        open c_rfid_user;
        fetch c_rfid_user into v_transponder;
        close c_rfid_user;
        return nvl(v_transponder, 'PNR_' || in_pers_nr);  -- Fallback: PNR_ + Personalnummer, um zumindest eine eindeutige Kennung zu haben
    end;

  /**
   * Laedt die Mitarbeiter-Daten (Kostenstelle, Abteilung, Projektbereich, Arbeitsort)
   * in den uebergebenen Buchungskontext.
   * Es wird davon ausgegangen, dass der PersNr bereits gesetzt ist.
   */
    procedure load_mitarbeiter_daten (
        io_ze_context in out t_buchung_context
    ) is
    begin
        if io_ze_context.kst_id is null then
            io_ze_context.kst_id := get_pers_kst_id(io_ze_context.pers_nr);
            if io_ze_context.kst_id is null then
                raise_application_error(-20010,
                                        'Keine Kostenstelle fuer Pers. Nr. '
                                        || to_char(io_ze_context.pers_nr)
                                        || ' vorhanden!');

            end if;

        end if;

        if io_ze_context.abt_id is null then
            io_ze_context.abt_id := get_pers_abt_id(io_ze_context.pers_nr);
        end if;

        if io_ze_context.pb_id is null then
            io_ze_context.pb_id := get_pers_pb_id(io_ze_context.pers_nr);
        end if;

        if io_ze_context.work_location is null then
            io_ze_context.work_location := get_default_work_location(io_ze_context.ze_status);
        end if;

    end;

  /*  Kontextbasierte Schichttag-Ermittlung ? Beispiele
      ==================================================

      HINTERGRUND
      -----------
      Der Schichttag eines Zeiterfassungseintrags entspricht nicht zwingend dem
      Kalendertag des Zeitstempels. Buchungen die nach Mitternacht stattfinden,
      aber noch zur vorangegangenen Schicht geh?ren, m?ssen dem Schichttag des
      Vortages zugeordnet werden. Die Schichtmodell-Berechnung allein kann das
      nicht leisten, da sie keinen Zustand kennt. load_schicht_daten l?st das
      durch einen vorgelagerten Blick in bereits vorhandene Eintr?ge derselben
      Person (Kontextsuche).

      BEISPIEL 1 ? Normalfall (Tagschicht, kein Mitternacht-?bergang)
      ---------------------------------------------------------------
      Mitarbeiter: Tagschicht 06:00?14:30

        06:12 Kommen  ? kein Voreintrag vorhanden
                      ? Schichtmodell-Berechnung: Schichttag = 10.03.2026
        14:18 Gehen   ? Voreintrag gefunden: ze_ist_start=06:12, Schichttag=10.03.2026
                      ? Schichttag aus Kontext ?bernommen: 10.03.2026  ?

      Hier ?ndert sich nichts. Der Kontextsuche-Pfad liefert dasselbe 
      Ergebnis wie die Schichtmodell-Berechnung.

      BEISPIEL 2 ? Gehen nach Mitternacht (ohne dedizierte Nachtschicht)
      ------------------------------------------------------------------
      Mitarbeiter: Sp?tschicht 14:00?22:30, stempelt sich versp?tet aus.

        13:55 Kommen  ? kein Voreintrag vorhanden
                      ? Schichtmodell-Berechnung: Schichttag = 10.03.2026
        00:18 Gehen   ? Voreintrag gefunden: ze_ist_start=13:55 am 10.03.2026
                        (liegt innerhalb [00:18 - max_std_offen, 00:18))
                      ? Schichttag aus Kontext ?bernommen: 10.03.2026  ?
                      ? find_offener_eintrag_id(pers_nr, 10.03.2026) findet
                        den offenen Kommen-Eintrag ? Buchung erfolgreich

      Ohne Kontextsuche: get_schicht_tag_fuer_zeit liefert 11.03.2026.
      find_offener_eintrag_id(pers_nr, 11.03.2026) ? NULL ? Fehler
      "Gehen ohne Kommen".

      BEISPIEL 3 ? Dedizierte Nachtschicht (Schichttag = Beginn-Datum)
      -----------------------------------------------------------------
      Mitarbeiter: Nachtschicht 22:00?06:00, Schichttag = Tag des Schichtbeginns.

        21:58 Kommen  ? kein Voreintrag vorhanden
                      ? Schichtmodell-Berechnung: Schichttag = 10.03.2026
        02:34 Gehen   ? Voreintrag gefunden: ze_ist_start=21:58 am 10.03.2026
                      ? Schichttag aus Kontext ?bernommen: 10.03.2026  ?

      Identisches Verhalten wie Beispiel 2. Die Kontextsuche funktioniert
      unabh?ngig davon, ob das Schichtmodell Nachtschichten kennt oder nicht.

      BEISPIEL 4 ? Pause als Gehen/Kommen nach Mitternacht
      -----------------------------------------------------
      Mitarbeiter stempelt keine Pausen, sondern Gehen + Kommen.
      Schicht 22:00?06:00.

        21:58 Kommen  ? Schichttag = 10.03.2026  (Schichtmodell)
        00:15 Gehen   ? Voreintrag: ze_ist_start=21:58, Schichttag=10.03.2026
                      ? Schichttag aus Kontext: 10.03.2026  ?
                      ? Eintrag geschlossen: ze_ist_start=21:58, ze_ist_ende=00:15
        00:47 Kommen  ? Voreintrag: ze_ist_start=00:15 (Gehen), Schichttag=10.03.2026
                      ? Schichttag aus Kontext: 10.03.2026  ?
                      ? Neuer offener Eintrag mit Schichttag=10.03.2026 erstellt
        05:52 Gehen   ? Voreintrag: ze_ist_start=00:47, Schichttag=10.03.2026
                      ? Schichttag aus Kontext: 10.03.2026  ?

      Ohne Kontextsuche: Das zweite Kommen (00:47) w?rde Schichttag=11.03.2026
      erhalten. Das abschlie?ende Gehen (05:52) findet dann keinen offenen
      Eintrag am 11.03.2026 ? Fehler "Gehen ohne Kommen".

      Wichtig: Die Kontextsuche zieht auch bereits geschlossene Eintr?ge heran
      (ze_ist_start < p_zeitstempel, ohne Pr?fung auf ze_ist_ende). Das ist
      gewollt ? entscheidend ist nur ob der Startzeitpunkt zeitlich plausibel
      zur aktuellen Buchung passt.

      BEISPIEL 5 ? Erster Eintrag einer neuen Schicht (kein Voreintrag)
      -----------------------------------------------------------------
      Mitarbeiter: Fr?hschicht 06:00?14:30, erste Buchung des Tages.

        05:58 Kommen  ? Kontextsuche: kein Eintrag innerhalb der letzten
                        max_std_offen Stunden vorhanden
                      ? Fallback: Schichtmodell-Berechnung
                      ? Schichttag = 10.03.2026  ?

      Der Fallback-Pfad bleibt vollst?ndig erhalten. Das Kommen als erste
      Buchung einer Schicht funktioniert wie bisher.

      BEISPIEL 6 ? Schichttag bereits extern gesetzt (manuelle Korrektur)
      -------------------------------------------------------------------
      Bei c_manuelle_korrektur wird io_ze_context.schicht_tag vor dem Aufruf
      von load_schicht_daten bereits gesetzt.

        io_ze_context.schicht_tag = 10.03.2026  (extern vorgegeben)

        ? load_schicht_daten: schicht_tag is not null ? Kontextsuche wird
          ?bersprungen, kein get_schicht_tag_fuer_zeit
        ? Nur sa_kurzname + sm_name werden ggf. aus vorhandenen Eintr?gen
          des gesetzten Schichttages nachgeladen

      Das Verhalten bei extern gesetztem Schichttag ist unver?ndert.

      GRENZFALL ? Zwei aufeinanderfolgende Schichten ohne L?cke
      ---------------------------------------------------------
      Mitarbeiter arbeitet Doppelschicht: Sp?t 14:00?22:30 direkt gefolgt
      von Nacht 22:30?06:00 (anderer Schichttag, z.B. bei Schichttausch).

        13:58 Kommen  ? Schichttag = 10.03.2026
        22:28 Gehen   ? Voreintrag (13:58): Schichttag=10.03.2026  ?
        22:31 Kommen  ? Voreintrag (13:58 oder 22:28): Schichttag=10.03.2026

        ? Das neue Kommen (22:31) erbt Schichttag=10.03.2026, obwohl es
          eigentlich eine neue Schicht des selben Tages ist. Das ist korrekt,
          da die zweite Schicht am selben Kalendertag beginnt und der
          Schichttag sich nicht ?ndert.

      W?rde die zweite Schicht auf 23:00 beginnen und dem Folgetag zugeordnet
      sein, muss das ?ber eine ausreichend gro?e L?cke zwischen den Eintr?gen
      sichergestellt werden ? oder der Schichttag wird beim Kommen manuell
      gesetzt (c_manuelle_korrektur). Die Kontextsuche kann inhaltlich keine
      Schichtzugeh?rigkeit erzwingen, die das Schichtmodell nicht hergibt.

      PARAMETER: max_std_offen
      ------------------------
      Das Zeitfenster der Kontextsuche ist identisch mit der Grenze, ab der
      auto_close_eintrag einen offenen Eintrag als fehlerhaft behandelt. Damit
      gilt: Eintr?ge die noch nicht auto-geclosed w?ren, k?nnen noch zur
      laufenden Schicht geh?ren ? und genau diese werden in der Kontextsuche
      ber?cksichtigt. Es handelt sich um keine zus?tzliche magische Konstante.
   */

  /**
   * Laedt Schichtdaten in den Buchungskontext.
   * Ermittelt den Schichttag kontextbasiert: Zuerst wird geprueft ob eine zeitlich
   * passende existierende Zeiterfassung vorliegt (Mitternacht-Ueberschreitung bei
   * Nachtschichten oder Pause-als-Gehen/Kommen). Erst als Fallback erfolgt die
   * reine Schichtmodell-Berechnung via get_schicht_tag_fuer_zeit.
   * Es wird davon ausgegangen, dass 'pers_nr' bereits gesetzt ist.
   */
    procedure load_schicht_daten (
        io_ze_context in out t_buchung_context
    ) is

        v_schicht_modell pzm_schicht_modelle%rowtype;
        v_max_std_diff   number;

    -- Sucht den letzten zeitlich passenden Eintrag innerhalb des max. offenen Zeitfensters.
    -- Liefert Schichttag + Schichtart des gefundenen Eintrags fuer die Kontextuebertragung.
        cursor c_kontext_zeiterfassung (
            p_zeitstempel in date
        ) is
        select
            t.ze_schicht_tag,
            t.ze_sa_kurzname,
            t.ze_sm_name
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = io_ze_context.pers_nr
            and t.ze_ist_start >= p_zeitstempel - ( v_max_std_diff / 24 )
            and t.ze_ist_start < p_zeitstempel
            and t.ze_sa_kurzname is not null
        order by
            t.ze_ist_start desc
        fetch first 1 row only;

    -- Laedt Schichtart + Schichtmodell eines bereits bekannten Schichttages
    -- (fuer den Fall, dass der Schichttag bereits korrekt gesetzt ist).
        cursor c_schicht_info is
        select
            t.ze_schicht_tag,
            t.ze_sa_kurzname,
            t.ze_sm_name
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = io_ze_context.pers_nr
            and t.ze_schicht_tag = io_ze_context.schicht_tag
            and t.ze_sa_kurzname is not null
        order by
            t.ze_calc_ist_start desc nulls last
        fetch first 1 row only;

        v_kontext_ze     c_kontext_zeiterfassung%rowtype;
        v_schicht_info   c_schicht_info%rowtype;
        v_schicht_tag    date;
        v_sa_found       boolean;
        v_sa_kurzname    pzm_schichtarten.sa_kurzname%type;
        v_sa_beginn      pzm_schichtarten.sa_beginn%type;
        v_sa_ende        pzm_schichtarten.sa_ende%type;
        v_sa_std_pro_tag pzm_schichtarten.sa_std_pro_tag%type;
    begin
        if io_ze_context.schicht_tag is null then
            v_max_std_diff := get_max_std_offen(io_ze_context.pers_nr);

      -- Schichttag noch nicht bekannt: 1. Versuch, kontextbasierte Ermittlung
            open c_kontext_zeiterfassung(io_ze_context.zeitstempel);
            fetch c_kontext_zeiterfassung into v_kontext_ze;
            if c_kontext_zeiterfassung%found then
        -- Schichttag + Schichtart aus dem zeitlich passenden Voreintrag uebernehmen.
        -- Deckt ab: Gehen nach Mitternacht, Pause-als-G/K nach Mitternacht.
                io_ze_context.schicht_tag := v_kontext_ze.ze_schicht_tag;
                io_ze_context.sa_kurzname := v_kontext_ze.ze_sa_kurzname;
                io_ze_context.sm_name := v_kontext_ze.ze_sm_name;
                pzm_p_log.debug('Schichttag aus Kontext uebernommen: '
                                || to_char(io_ze_context.schicht_tag, 'DD.MM.YYYY')
                                || ', SA='
                                || io_ze_context.sa_kurzname
                                || ' (Buchungszeit: '
                                || to_char(io_ze_context.zeitstempel, 'DD.MM.YYYY HH24:MI')
                                || ', PersNr: '
                                || io_ze_context.pers_nr
                                || ')',
                                pzm_p_log.cat_zeiterfassung,
                                'load_schicht_daten');

            else
        -- Kein passender Voreintrag: 2. Versuch, Fallback auf Schichtmodell-Berechnung
                if pzm_p_base.get_schicht_modell(io_ze_context.pers_nr, v_schicht_modell) then
                    v_sa_found := get_schicht_daten(io_ze_context.pers_nr, io_ze_context.zeitstempel, v_schicht_tag, v_sa_kurzname, v_sa_beginn
                    ,
                                                    v_sa_ende, v_sa_std_pro_tag) = 1;

                    if v_sa_found then
                        io_ze_context.schicht_tag := v_schicht_tag;
                        io_ze_context.sa_kurzname := v_sa_kurzname;
                        io_ze_context.sm_name := v_schicht_modell.sm_name;
                    else
                        pzm_p_log.error('Es konnte keine Schicht gefunden werden! '
                                        || 'Zeit='
                                        || to_char(io_ze_context.zeitstempel, 'DD.MM.YYYY HH24:MI')
                                        || ', PersNr='
                                        || io_ze_context.pers_nr
                                        || ', Schichtmodell: '
                                        || v_schicht_modell.sm_name,
                                        pzm_p_log.cat_zeiterfassung,
                                        'load_schicht_daten');

                        io_ze_context.schicht_tag := trunc(io_ze_context.zeitstempel);
                        io_ze_context.sm_name := v_schicht_modell.sm_name;
                    end if;

                else
                    io_ze_context.schicht_tag := trunc(io_ze_context.zeitstempel);
                end if;

                pzm_p_log.debug('Schichttag per Schichtmodell ermittelt: '
                                || to_char(io_ze_context.schicht_tag, 'DD.MM.YYYY')
                                || ' (Buchungszeit: '
                                || to_char(io_ze_context.zeitstempel, 'DD.MM.YYYY HH24:MI')
                                || ', PersNr: '
                                || io_ze_context.pers_nr
                                || ')',
                                pzm_p_log.cat_zeiterfassung,
                                'load_schicht_daten');

            end if;

            close c_kontext_zeiterfassung;
        end if;

    -- Schichtart + SM nachladen, falls noch nicht aus Kontext befuellt
        if io_ze_context.sa_kurzname is null
           or io_ze_context.sm_name is null then
            open c_schicht_info;
            fetch c_schicht_info into v_schicht_info;
            if c_schicht_info%found then
                io_ze_context.sa_kurzname := nvl(io_ze_context.sa_kurzname, v_schicht_info.ze_sa_kurzname);
                io_ze_context.sm_name := nvl(io_ze_context.sm_name, v_schicht_info.ze_sm_name);
            end if;

            close c_schicht_info;
        end if;

    -- SM-Name als letzten Fallback aus Schichtmodell-Stammdaten
        if io_ze_context.sm_name is null then
            if pzm_p_base.get_schicht_modell(io_ze_context.pers_nr, v_schicht_modell) then
                io_ze_context.sm_name := v_schicht_modell.sm_name;
            end if;
        end if;

    end;

    function get_ze (
        in_ze_id  in pzm_zeiterfassung.ze_id%type,
        in_module in varchar2
    ) return pzm_zeiterfassung%rowtype is
        v_ze pzm_zeiterfassung%rowtype;
        cursor c_ze is
        select
            *
        from
            pzm_zeiterfassung
        where
            ze_id = in_ze_id;

    begin
        open c_ze;
        fetch c_ze into v_ze;
        if c_ze%notfound then
            close c_ze;
            pzm_p_log.warning('ZE Eintrag nicht gefunden: ' || in_ze_id, pzm_p_log.cat_zeiterfassung, in_module);
            pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_buchung, pzm_p_lc.o_tp1_pzm_error_ze_eintrag_404, in_ze_id);
        end if;

        close c_ze;
        return v_ze;
    end;

  -----------------------------------------------------------------------------------------------
  -- PRIVATE HILFSFUNKTIONEN: Validierung
  -----------------------------------------------------------------------------------------------

  /** 
   * Validiert den uebergebenen Buchungskontext.
   * Bei Fehlern wird eine Exception geworfen.
   */
    procedure validate_ze_buchung (
        in_ze_context in t_buchung_context
    ) is
    begin
        if in_ze_context.pers_nr is null then
            pzm_p_lc.raise_app_error(pzm_p_lc.pzm_error_ze_daten_invalid, pzm_p_lc.o_t_pzm_error_ze_invalid_no_pers_nr);
        end if;

        if in_ze_context.zeitstempel is null then
            pzm_p_lc.raise_app_error(pzm_p_lc.pzm_error_ze_daten_invalid, pzm_p_lc.o_t_pzm_error_ze_invalid_no_timestamp);
        end if;

        if in_ze_context.aktion is null then
            pzm_p_lc.raise_app_error(pzm_p_lc.pzm_error_ze_daten_invalid, pzm_p_lc.o_t_pzm_error_ze_invalid_no_aktion);
        end if;

    -- TODO: -wkr- Zukunftszeitstempel mit Beruecksichtigung der Zeitzone pruefen?
    -- if in_ze_context.zeitstempel > sysdate + 1/24 then
    --   pzm_p_lc.raise_app_error(pzm_p_lc.PZM_ERROR_ZE_DATEN_INVALID,
    --     pzm_p_lc.O_T_PZM_ERROR_ZE_INVALID_TIMESTAMP_IN_FUTURE);
    -- end if;
    end;

  -----------------------------------------------------------------------------------------------
  -- PRIVATE KERNFUNKTION: Deterministische Zeit-Berechnung
  -----------------------------------------------------------------------------------------------

  /**
   * Prueft ob bereits ein (Anwesend-)Eintrag mit gestempelter
   * Start-Zeit fuer den Schichttag des Buchungskontext existiert.
   */
    function is_erster_anwesend_eintrag (
        in_ze_context in t_buchung_context
    ) return boolean is
        v_count number;
    begin
        select
            count(*)
        into v_count
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = in_ze_context.pers_nr
            and t.ze_schicht_tag = in_ze_context.schicht_tag
            and t.ze_ist_start is not null
            and t.ze_status = status_anwesend;

        return v_count = 0;
    end;

  -----------------------------------------------------------------------------------------------
  -- Diese Prozedur delegiert an das Package pzm_p_zeit_bewertung.
  -- Die komplette Bewertungslogik (Festschicht, Gleitzeit, Rundung, Kappung) ist
  -- dort gekapselt und kann unabh?ngig getestet werden.
  -----------------------------------------------------------------------------------------------
    procedure ze_ist_zeiten_bewerten (
        io_ze_context in out t_buchung_context,
        in_ist_start  in date,
        in_ist_ende   in date
    ) is
        v_result    pzm_p_zeit_bewertung.t_bewertung_result;
        v_is_erster boolean;
    begin
    -- Pr?fen ob dies der erste Anwesend-Eintrag des Schichttags ist
        v_is_erster := is_erster_anwesend_eintrag(io_ze_context);

    -- Bewertung an das spezialisierte Package delegieren
        v_result := pzm_p_zeit_bewertung.bewerte_ist_zeiten(
            in_pers_nr           => io_ze_context.pers_nr,
            in_ist_start         => in_ist_start,
            in_ist_ende          => in_ist_ende,
            in_ze_status         => io_ze_context.ze_status,
            in_calc_ist_start    => io_ze_context.calc_ist_start,
            in_calc_ist_ende     => io_ze_context.calc_ist_ende,
            in_schicht_tag       => io_ze_context.schicht_tag,
            in_sa_kurzname       => io_ze_context.sa_kurzname,
            in_is_erster_eintrag => v_is_erster
        );

    -- Ergebnisse in den Kontext ?bernehmen
        io_ze_context.calc_ist_start := v_result.calc_ist_start;
        io_ze_context.calc_ist_ende := v_result.calc_ist_ende;
        io_ze_context.ze_std := v_result.ze_std;

    -- Schichtdaten nur ?bernehmen wenn ermittelt
        if v_result.schicht_tag is not null then
            io_ze_context.schicht_tag := v_result.schicht_tag;
        end if;

        if v_result.sa_kurzname is not null then
            io_ze_context.sa_kurzname := v_result.sa_kurzname;
        end if;

    end;

  -----------------------------------------------------------------------------------------------
  -- PRIVATE KERNOPERATIONEN: ZE Eintrag erstellen/schliessen (aufraeumen)
  -----------------------------------------------------------------------------------------------

    procedure clear_auto_ze_eintraege (
        in_ze_context in t_buchung_context
    ) is
    begin
        delete from pzm_zeiterfassung t
        where
                t.ze_schicht_tag = in_ze_context.schicht_tag
            and t.ze_pers_nr = in_ze_context.pers_nr
            and t.ze_typ = typ_auto
            and t.ze_korr_pers_nr is null
            and t.ze_ist_start is null
            and t.ze_ist_ende is null;

    end;

  /**
   * Erstellt einen neuen Zeiterfassungs-Eintrag mit den angegebenen Ist-Zeiten.
   */
    function create_ze_eintrag (
        in_ze_context in t_buchung_context,
        in_ist_start  in date,
        in_ist_ende   in date
    ) return pzm_zeiterfassung.ze_id%type is
        v_ze_id   pzm_zeiterfassung.ze_id%type;
        v_context t_buchung_context := in_ze_context;
    begin
        if
            in_ist_start is null
            and in_ist_ende is not null
        then
            pzm_p_lc.raise_app_error(pzm_p_lc.pzm_error_ze_daten_invalid, pzm_p_lc.o_t_pzm_error_ze_invalid_no_start_time);
        end if;

        ze_ist_zeiten_bewerten(v_context, in_ist_start, in_ist_ende);
        insert into pzm_zeiterfassung (
            ze_id,
            ze_pers_nr,
            ze_ist_start,
            ze_ist_ende,
            ze_status,
            ze_kst_id,
            ze_abt_id,
            ze_typ,
            ze_schicht_tag,
            ze_sa_kurzname,
            ze_sm_name,
            ze_calc_ist_start,
            ze_calc_ist_ende,
            ze_std,
            ze_pb_id,
            ze_work_location,
            created_date,
            created_login_id,
            last_change_date,
            last_change_login_id
        ) values ( seq_ze_id.nextval,
                   v_context.pers_nr,
                   in_ist_start,
                   in_ist_ende,
                   v_context.ze_status,
                   v_context.kst_id,
                   v_context.abt_id,
                   v_context.ze_typ,
                   v_context.schicht_tag,
                   v_context.sa_kurzname,
                   v_context.sm_name,
                   v_context.calc_ist_start,
                   v_context.calc_ist_ende,
                   v_context.ze_std,
                   v_context.pb_id,
                   v_context.work_location,
                   sysdate,
                   current_isi_user_login_id(),
                   null,
                   null ) returning ze_id into v_ze_id;

        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'Eintrag erstellt: ZE_ID='
                         || v_ze_id
                         || ', Start-Zeit='
                         || to_char(in_ist_start, 'DD.MM.YYYY HH24:MI')
                         || ', Ende-Zeit='
                         || to_char(in_ist_ende, 'DD.MM.YYYY HH24:MI')
                         || ', PersNr='
                         || v_context.pers_nr
                         || ', SchichtTag='
                         || to_char(v_context.schicht_tag, 'DD.MM.YYYY'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'create_eintrag',
            p_pers_nr     => v_context.pers_nr,
            p_schicht_tag => v_context.schicht_tag,
            p_ze_id       => v_ze_id
        );

        return v_ze_id;
    end;

  /**
   * Schlie?t einen bestehenden Zeiterfassungs-Eintrag mit der angegebenen Ende-Zeit.
   */
    procedure close_ze_eintrag (
        in_ze_id    in number,
        in_ist_ende in date
    ) is
        v_ze      pzm_zeiterfassung%rowtype;
        v_context t_buchung_context;
    begin
        v_ze := get_ze(in_ze_id, 'close_eintrag');
        if v_ze.ze_ist_ende is not null then
            pzm_p_log.warning('Eintrag bereits geschlossen: '
                              || in_ze_id
                              || ', Zeit='
                              || to_char(in_ist_ende, 'DD.MM.YYYY HH24:MI')
                              || ', PersNr='
                              || v_ze.ze_pers_nr
                              || ', SchichtTag='
                              || to_char(v_ze.ze_schicht_tag, 'DD.MM.YYYY'),
                              pzm_p_log.cat_zeiterfassung,
                              'close_eintrag');

            return;
        end if;

        v_context.pers_nr := v_ze.ze_pers_nr;
        v_context.ze_status := v_ze.ze_status;
        v_context.schicht_tag := v_ze.ze_schicht_tag;
        v_context.sa_kurzname := v_ze.ze_sa_kurzname;
        v_context.sm_name := v_ze.ze_sm_name;
        ze_ist_zeiten_bewerten(v_context, v_ze.ze_ist_start, in_ist_ende);
        if v_context.calc_ist_ende is null
           or v_context.calc_ist_start is null then
      -- TODO: -wkr- Aus meiner Sicht sollte hier ein Fehler geworfen werden, da die Bewertung fehlschl?gt.
            pzm_p_log.warning('Bewertung (calc_ist_...) ist fehlgeschlagen! Erfasste Zeit wird trotzdem gespeichert. ZE_ID: '
                              || in_ze_id
                              || ', Zeit='
                              || to_char(in_ist_ende, 'DD.MM.YYYY HH24:MI')
                              || ', PersNr='
                              || v_ze.ze_pers_nr
                              || ', SchichtTag='
                              || to_char(v_ze.ze_schicht_tag, 'DD.MM.YYYY'),
                              pzm_p_log.cat_zeiterfassung,
                              'close_eintrag');
        end if;

        update pzm_zeiterfassung t
        set
            t.ze_ist_ende = in_ist_ende,
            t.ze_calc_ist_start = v_context.calc_ist_start,
            t.ze_calc_ist_ende = v_context.calc_ist_ende,
            t.ze_std = v_context.ze_std,
            t.ze_sa_kurzname = nvl(v_context.sa_kurzname, t.ze_sa_kurzname),
            t.ze_schicht_tag = nvl(v_context.schicht_tag, t.ze_schicht_tag),
            t.last_change_date = sysdate,
            t.last_change_login_id = current_isi_user_login_id()
        where
            t.ze_id = in_ze_id;

        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'Eintrag geschlossen: ZE_ID='
                         || in_ze_id
                         || ', Zeit='
                         || to_char(in_ist_ende, 'DD.MM.YYYY HH24:MI')
                         || ', PersNr='
                         || v_context.pers_nr
                         || ', SchichtTag='
                         || to_char(v_context.schicht_tag, 'DD.MM.YYYY'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'close_eintrag',
            p_pers_nr     => v_context.pers_nr,
            p_schicht_tag => v_context.schicht_tag,
            p_ze_id       => in_ze_id
        );

    end;

  /**
   * Schlie?t einen bestehenden Zeiterfassungs-Eintrag automatisch,
   * indem die Ende-Zeit auf die Start-Zeit gesetzt wird.
   */
    procedure auto_close_eintrag (
        in_ze_id in number
    ) is
        v_ze pzm_zeiterfassung%rowtype;
    begin
        v_ze := get_ze(in_ze_id, 'auto_close_eintrag');
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_warning,
            p_message     => 'Auto-Close: Start='
                         || to_char(v_ze.ze_ist_start, 'YYYY-MM-DD HH24:MI')
                         || ', Alter='
                         || round((sysdate - v_ze.ze_ist_start) * 24, 1)
                         || 'h (Eintrag war zu lange offen)',
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'auto_close_eintrag',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => in_ze_id,
            p_schicht_tag => v_ze.ze_schicht_tag
        );

        update pzm_zeiterfassung t
        set
            t.ze_ist_ende = t.ze_ist_start,
            t.ze_calc_ist_ende = t.ze_calc_ist_start,
            t.ze_std = 0,
            t.ze_typ = typ_system,
            t.last_change_date = sysdate,
            t.last_change_login_id = current_isi_user_login_id()
        where
            t.ze_id = in_ze_id;

    end;

  /** 
   * F?hrt die Tagesauswertung/-berechnung f?r den angegebenen Schichttag durch.
   * Es wird keine Exception geworfen! Bei Fehlern wird ins Log geschrieben.
   */
    procedure c_schicht_tag_auswerten (
        in_pers_nr     in number,
        in_schicht_tag in date
    ) is
        v_tagesausw_result   number;
        v_tagesausw_res_info varchar2(255 char);
    begin
    -- bisherige Implementierung: enthaelt ein implizites 'commit'
        update_pers_ze_tag(in_pers_nr, in_schicht_tag, v_tagesausw_result, v_tagesausw_res_info);
        if v_tagesausw_result <> 0 then
            pzm_p_log.log_data(
                p_level       => pzm_p_log.level_error,
                p_message     => 'Tagesauswertung Schichttag '
                             || to_char(in_schicht_tag, 'YYYY-MM-DD')
                             || ' fuer PersNr='
                             || in_pers_nr
                             || ', Ergebnis='
                             || v_tagesausw_result
                             || ', Info='
                             || v_tagesausw_res_info,
                p_category    => pzm_p_log.cat_zeiterfassung,
                p_module      => 'c_schicht_tag_auswerten',
                p_pers_nr     => in_pers_nr,
                p_schicht_tag => in_schicht_tag
            );

        end if;

    -- Abwesenheitsplanung fuer den Schichttag vorbereiten bzw. auf grund der letzten  aktualisieren
        pzm_abwes_plan_vorbereiten(in_schicht_tag, in_schicht_tag, in_pers_nr);
    exception
        when others then
            pzm_p_log.log_exception(
                p_category    => pzm_p_log.cat_zeiterfassung,
                p_module      => 'c_schicht_tag_auswerten',
                p_context     => 'Tagesauswertung Schichttag '
                             || to_char(in_schicht_tag, 'YYYY-MM-DD')
                             || ' fuer PersNr='
                             || in_pers_nr,
                p_pers_nr     => in_pers_nr,
                p_schicht_tag => in_schicht_tag
            );
    end;

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API: Abfrage-Funktionen
  -----------------------------------------------------------------------------------------------

  /**
   * Liefert die Personalnummer des Mitarbeiters basierend auf der ?bergebenen RFID (Transponder-Code).
   * Gibt eine Exception zur?ck, wenn kein Mitarbeiter mit der angegebenen RFID gefunden wird.
   */
    function get_pers_nr_by_rfid (
        in_rfid in varchar2
    ) return pzm_personal.pers_nr%type is

        v_pers_nr isi_user.pers_nr%type;
        cursor c_rfid_pers_nr is
        select
            u.pers_nr
        from
            isi_user u
        where
            u.transponder = in_rfid;

    begin
        open c_rfid_pers_nr;
        fetch c_rfid_pers_nr into v_pers_nr;
        close c_rfid_pers_nr;
        if ( v_pers_nr is null ) then
            pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_rfid_pers_nr_404, pzm_p_lc.o_tp1_pzm_error_rfid_pers_nr_404, in_rfid);
        end if;

        return v_pers_nr;
    end;

  /**
   * Liefert den Default-Arbeitsort basierend auf dem Zeiterfassungs-Status.
   */
    function get_default_work_location (
        in_ze_status in number
    ) return number is
    begin
        if in_ze_status = status_dienstgang then
      -- Reise Passiv ohne Ueberstundenprozente (Default fuer Dienstreise wenn nicht angegeben)
            return work_location_reise_passiv;
        else
      -- "Betrieb" OnSite (Default fuer Anwesend in der Firma)
            return work_location_betrieb;
        end if;
    end;

  /** OBSOLETE (vermutlich), da der Auruf von 'get_schicht_daten' direkt
   *  bei der Schichtermittlung benoetigt wird.
   * Ermittelt den Schichttag fuer den angegebenen Zeitstempel
   * unter Beruecksichtigung des Schichtmodells des Mitarbeiters.
   */
    function get_schicht_tag_fuer_zeit (
        in_pers_nr     in number,
        in_zeitstempel in date
    ) return date is

        v_schicht_modell pzm_schicht_modelle%rowtype;
        v_sa_found       boolean;
        v_sa_kurzname    pzm_schichtarten.sa_kurzname%type;
        v_sa_beginn      pzm_schichtarten.sa_beginn%type;
        v_sa_ende        pzm_schichtarten.sa_ende%type;
        v_sa_std_pro_tag pzm_schichtarten.sa_std_pro_tag%type;
        v_schicht_tag    date;
    begin
        v_schicht_tag := trunc(in_zeitstempel);
        if pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modell) then
            v_sa_found := get_schicht_daten(in_pers_nr, in_zeitstempel, v_schicht_tag, v_sa_kurzname, v_sa_beginn,
                                            v_sa_ende, v_sa_std_pro_tag) = 1;

            if not v_sa_found then
                pzm_p_log.error('Es konnte keine Schicht gefunden werden! '
                                || 'Zeit='
                                || to_char(in_zeitstempel, 'DD.MM.YYYY HH24:MI')
                                || ', PersNr='
                                || in_pers_nr,
                                pzm_p_log.cat_zeiterfassung,
                                'get_schicht_tag_fuer_zeit');

            end if;

        else
            v_schicht_tag := trunc(in_zeitstempel);
        end if;

        return v_schicht_tag;
    end;

  /**
   * Sucht nach einem offenen Zeiterfassungs-Eintrag (Kommen ohne Gehen)
   * fuer den angegebenen Mitarbeiter und Schichttag.
   * Liefert die ZE_ID des Eintrags oder NULL wenn kein offener Eintrag existiert.
   */
    function find_offener_eintrag_id (
        in_pers_nr     in number,
        in_schicht_tag in date
    ) return pzm_zeiterfassung.ze_id%type is

        v_ze_id pzm_zeiterfassung.ze_id%type;
        cursor c_offen is
        select
            t.ze_id
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = in_pers_nr
            and t.ze_schicht_tag <= in_schicht_tag
            and t.ze_calc_ist_ende is null
            and t.ze_ist_start is not null
            and t.ze_ist_ende is null
        order by
            t.ze_ist_start desc
        fetch first 1 row only;

    begin
        open c_offen;
        fetch c_offen into v_ze_id;
        close c_offen;
        return v_ze_id;
    end;

  -----------------------------------------------------------------------------------------------
  -- OEFFENTLICHE API: Handler (Dokumentation siehe Package-Spezifikation)
  -----------------------------------------------------------------------------------------------

    procedure c_stempelzeit_eintragen (
        in_quelle             in varchar2,
        in_terminal_id        in varchar2,
        in_rfid               in varchar2,
        in_aktion             in varchar2,
        in_zeitstempel        in date,
        in_timezone_name      in varchar2,  -- IANA Timezone Name
        in_ze_transfer_status in varchar2 default 'N'
    ) is

        v_pers_nr     pzm_zeiterfassung_eintraege.pers_nr%type;
        v_resource    isi_resource%rowtype;
        v_geraet_info pzm_zeiterfassung_eintraege.ze_geraet_info%type;
        cursor c_rfid_pers_nr is
        select
            u.pers_nr
        from
            isi_user u
        where
            u.transponder = in_rfid;

        cursor c_resource_info is
        select
            r.*
        from
            isi_resource r
        where
            r.res_name = in_terminal_id;

    begin
        if in_rfid like 'PNR_%' then
            v_pers_nr := substr(in_rfid, 5);
        else
            open c_rfid_pers_nr;
            fetch c_rfid_pers_nr into v_pers_nr;
            close c_rfid_pers_nr;
        end if;

        if v_pers_nr is null then
            pzm_p_log.warning('Zur RFID/Transponder '
                              || in_rfid
                              || ' konnte keine PERS_NR ermittelt werden!'
                              || ' Terminal: '
                              || in_terminal_id
                              || ', Aktion='
                              || in_aktion
                              || ', Zeit='
                              || to_char(in_zeitstempel, 'YYYY-MM-DD HH24:MI')
                              || ', Timezone='
                              || in_timezone_name,
                              pzm_p_log.cat_zeiterfassung,
                              'c_stempelzeit_eintragen');

        end if;

        open c_resource_info;
        fetch c_resource_info into v_resource;
        if c_resource_info%found then
            v_geraet_info := v_resource.text;
            if v_resource.pos_info is not null then
                v_geraet_info := v_geraet_info
                                 || ', '
                                 || v_resource.pos_info;
            end if;

        else
            pzm_p_log.warning('Zum Terminal '
                              || in_terminal_id
                              || ' konnte keine Resourcen-Info ermittelt werden!', pzm_p_log.cat_zeiterfassung, 'c_stempelzeit_eintragen'
                              );
        end if;

        close c_resource_info;
        insert into pzm_zeiterfassung_eintraege (
            quelle,
            ze_geraet,
            ze_rfid,
            ze_aktion,
            ze_datum,
            ze_timezone_name,
            ze_transfer_status,
            created_date,
            created_login_id,
            pers_nr,
            ze_geraet_info
        ) values ( in_quelle,
                   in_terminal_id,
                   in_rfid,
                   in_aktion,
                   in_zeitstempel,
                   nvl(in_timezone_name, c_default_timezone),
                   in_ze_transfer_status,
                   sysdate,
                   current_isi_user_login_id(),
                   v_pers_nr,
                   v_geraet_info );

        commit;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung,
                                    'c_stempelzeit_eintragen',
                                    'Aktion='
                                    || in_aktion
                                    || ', Zeit='
                                    || to_char(in_zeitstempel, 'YYYY-MM-DD HH24:MI')
                                    || ', Timezone='
                                    || in_timezone_name);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_stempelzeit_eintragen');
    end;

  /**
   * Markiert den Stempelzeit-Eintrag als erfolgreich ?bertragen.
   */
    procedure stempelzeit_eintrag_erlfolgreich (
        in_context in t_buchung_context
    ) is
    begin
        if in_context.rfid is null
           or in_context.terminal_id is null then
            return;
        end if;
        update pzm_zeiterfassung_eintraege zee
        set
            zee.ze_transfer_status = 'UE',
            zee.last_change_date = sysdate,
            zee.last_change_login_id = current_isi_user_login_id()
        where
                zee.ze_transfer_status = 'L'
            and zee.ze_rfid = in_context.rfid
            and zee.ze_aktion = in_context.aktion
            and zee.ze_datum = in_context.zeitstempel
            and zee.ze_geraet = in_context.terminal_id;

    end;

  /**
   * Markiert den Stempelzeit-Eintrag als fehlerhaft mit der angegebenen Fehlermeldung.
   */
    procedure c_stempelzeit_eintrag_fehler (
        in_context    in t_buchung_context,
        in_error_text in varchar2
    ) is
    begin
        if in_context.rfid is null
           or in_context.terminal_id is null then
            return;
        end if;
        update pzm_zeiterfassung_eintraege zee
        set
            zee.ze_transfer_status = 'ERR',
            zee.ze_ret_msg = substr(in_error_text, 1, 255),
            zee.last_change_date = sysdate,
            zee.last_change_login_id = current_isi_user_login_id()
        where
                zee.ze_transfer_status = 'L'
            and zee.ze_rfid = in_context.rfid
            and zee.ze_aktion = in_context.aktion
            and zee.ze_datum = in_context.zeitstempel
            and zee.ze_geraet = in_context.terminal_id;

        commit;
    end;

    function c_live_stempeln (
        in_pers_nr       in number,
        in_aktion        in varchar2,
        in_timezone_name in varchar2,  -- IANA Timezone Name
        in_kst_id        in number default null,
        in_abt_id        in number default null,
        in_work_location in number default null,
        in_frontend_name in varchar2 default null
    ) return pzm_zeiterfassung.ze_id%type is

        v_context       t_buchung_context;
        v_now           date := trunc(cast(systimestamp at time zone nvl(in_timezone_name, c_default_timezone) as date),
                            'MI');
        v_offener_ze_id pzm_zeiterfassung.ze_id%type;
        v_max_std_offen number;
        v_ze            pzm_zeiterfassung%rowtype;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'Live-Stempeln gestartet: Aktion='
                         || in_aktion
                         || ', Zeit='
                         || to_char(v_now, 'DD.MM.YYYY HH24:MI')
                         || ', Timezone='
                         || nvl(in_timezone_name, c_default_timezone)
                         || ', KST='
                         || in_kst_id
                         || ', ABT='
                         || in_abt_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_live_stempeln',
            p_pers_nr     => in_pers_nr,
            p_ze_rfid     => null, -- TODO: RFID-Unterstuetzung (ggf. aus ISI_USER lesen)
            p_terminal_id => in_frontend_name,
            p_aktion      => in_aktion,
            p_quelle      => quelle_live
        );

        v_context.pers_nr := in_pers_nr;
        v_context.quelle := quelle_live;
        v_context.terminal_id := nvl(in_frontend_name, 'LIVE');
        v_context.rfid := get_rfid(in_pers_nr);
        v_context.ze_typ := typ_live;
        v_context.zeitstempel := v_now;
        v_context.timezone_name := nvl(in_timezone_name, c_default_timezone);
        v_context.aktion := upper(in_aktion);
        v_context.work_location := in_work_location;
        v_context.ze_status := get_ze_status_from_aktion(in_aktion);
        v_context.kst_id := in_kst_id;
        v_context.abt_id := in_abt_id;
        if ( v_context.rfid is not null ) then
            c_stempelzeit_eintragen(v_context.quelle, v_context.terminal_id, v_context.rfid, v_context.aktion, v_context.zeitstempel,
                                    v_context.timezone_name, 'L'); -- wir nehmen hier den Status 'L'(ive) damit kein Batch-Prozess versucht diesen Datensatz nochmal zu ?bertragen
        end if;

        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        validate_ze_buchung(v_context);
        if is_start_aktion(v_context.aktion) then
      -- KOMMEN
            v_offener_ze_id := find_offener_eintrag_id(v_context.pers_nr, v_context.schicht_tag);
            if v_offener_ze_id is not null then
                v_ze := get_ze(v_offener_ze_id, 'c_live_stempeln');
                v_max_std_offen := get_max_std_offen(v_context.pers_nr);
                if ( v_context.zeitstempel - v_ze.ze_ist_start ) > ( v_max_std_offen / 24 ) then
                    auto_close_eintrag(v_offener_ze_id);
                elsif v_ze.ze_status = v_context.ze_status then
                    pzm_p_log.log_data(
                        p_level       => pzm_p_log.level_warning,
                        p_message     => 'Doppeltes Kommen abgelehnt: Schichttag='
                                     || to_char(v_context.schicht_tag, 'YYYY-MM-DD')
                                     || ', existierender ZE_ID='
                                     || v_offener_ze_id,
                        p_category    => pzm_p_log.cat_zeiterfassung,
                        p_module      => 'c_live_stempeln',
                        p_pers_nr     => v_context.pers_nr,
                        p_ze_id       => v_offener_ze_id,
                        p_ze_rfid     => v_context.rfid,
                        p_schicht_tag => v_context.schicht_tag,
                        p_terminal_id => v_context.terminal_id,
                        p_aktion      => in_aktion,
                        p_quelle      => quelle_live
                    );

                    pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_ze_bereits_offen, pzm_p_lc.o_tp1_pzm_error_ze_bereits_offen, v_offener_ze_id
                    );
                else
                    close_ze_eintrag(v_offener_ze_id, v_context.zeitstempel);
                end if;

            end if;

            clear_auto_ze_eintraege(v_context);
            v_offener_ze_id := create_ze_eintrag(v_context, v_context.zeitstempel, null);
            stempelzeit_eintrag_erlfolgreich(v_context);
            commit;
        else
      -- GEHEN
            v_offener_ze_id := find_offener_eintrag_id(v_context.pers_nr, v_context.schicht_tag);
            if v_offener_ze_id is null then
        -- KRITISCH: Gehen ohne Kommen - KEINEN ungueltigen Eintrag erstellen!
                pzm_p_log.log_data(
                    p_level       => pzm_p_log.level_error,
                    p_message     => 'GEHEN OHNE KOMMEN ABGELEHNT: Schichttag='
                                 || to_char(v_context.schicht_tag, 'YYYY-MM-DD')
                                 || ', Buchungszeit='
                                 || to_char(v_context.zeitstempel, 'YYYY-MM-DD HH24:MI')
                                 || ', Timezone='
                                 || in_timezone_name
                                 || ', PersNr='
                                 || v_context.pers_nr
                                 || ' (Kein INSERT mit ze_ist_start=NULL!)',
                    p_category    => pzm_p_log.cat_zeiterfassung,
                    p_module      => 'c_live_stempeln',
                    p_pers_nr     => v_context.pers_nr,
                    p_ze_rfid     => null,
                    p_schicht_tag => v_context.schicht_tag,
                    p_terminal_id => v_context.terminal_id,
                    p_aktion      => in_aktion,
                    p_quelle      => quelle_live
                );

                pzm_p_lc.raise_app_error_p2(pzm_p_lc.pzm_error_ze_keine_offene_vorh,
                                            pzm_p_lc.o_tp2_pzm_error_ze_gehen_ohne_kommen,
                                            to_char(v_context.schicht_tag, 'YYYY-MM-DD'),
                                            'P:' || v_context.pers_nr);

            end if;

            close_ze_eintrag(v_offener_ze_id, v_context.zeitstempel);
            v_ze := get_ze(v_offener_ze_id, 'c_live_stempeln');
            if v_ze.ze_status in ( status_pause, status_dienstgang ) then
        -- wenn beim LIVE Stempeln Pause/Dienstgang geschlossen wird,
        -- wird automatisch ein neuer Eintrag mit ANWESEND erstellt
        -- TODO: das sollte evtl. nur f?r Pause so gehandhabt werden
                v_context.ze_status := status_anwesend;
                v_offener_ze_id := create_ze_eintrag(v_context, v_context.zeitstempel, null);
            end if;

            stempelzeit_eintrag_erlfolgreich(v_context);
            commit;
            c_schicht_tag_auswerten(v_context.pers_nr, v_context.schicht_tag);
            if v_ze.ze_status = status_anwesend then
        -- TODO: spaeter generischer Exitpunkt (Event?) fuer BDE-Integration
        -- ACHTUNG! hier wird implizit ein 'commit' durchgef?hrt!
                pzm_bde_schicht_abmelden(v_ze.ze_pers_nr);
            end if;
        end if;

        pzm_p_log.log_data(
            p_level    => pzm_p_log.level_info,
            p_message  => 'Live-Stempeln erfolgreich abgeschlossen: Aktion='
                         || v_context.aktion
                         || ', Zeit='
                         || to_char(v_context.zeitstempel, 'YYYY-MM-DD HH24:MI')
                         || ', Timezone='
                         || nvl(in_timezone_name, c_default_timezone),
            p_category => pzm_p_log.cat_zeiterfassung,
            p_module   => 'c_live_stempeln',
            p_pers_nr  => v_context.pers_nr,
            p_aktion   => v_context.aktion,
            p_ze_id    => v_offener_ze_id,
            p_quelle   => quelle_live
        );

        return v_offener_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung,
                                    'c_live_stempeln',
                                    'Aktion='
                                    || in_aktion
                                    || ', Zeit='
                                    || to_char(v_now, 'YYYY-MM-DD HH24:MI')
                                    || ', Timezone='
                                    || in_timezone_name,
                                    in_pers_nr);

            c_stempelzeit_eintrag_fehler(v_context, sqlerrm);
            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_live_stempeln');
    end;

    function c_stempelzeit_ze_sync (
        in_quelle        in varchar2,
        in_pers_nr       in number,
        in_aktion        in varchar2,
        in_zeitstempel   in date,
        in_timezone_name in varchar2,  -- IANA Timezone Name
        in_kst_id        in number default null,
        in_abt_id        in number default null,
        in_terminal_id   in varchar2 default null,
        in_rfid          in varchar2 default null,
        in_work_location in number default null
    ) return pzm_zeiterfassung.ze_id%type is

        v_context       t_buchung_context;
        v_buchung_zeit  date := trunc(in_zeitstempel, 'MI');
        v_offener_ze_id pzm_zeiterfassung.ze_id%type;
        v_max_std_offen number;
        v_ze            pzm_zeiterfassung%rowtype;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'Terminal-Sync gestartet: Aktion='
                         || in_aktion
                         || ', Zeit='
                         || to_char(in_zeitstempel, 'DD.MM.YYYY HH24:MI')
                         || ', KST='
                         || in_kst_id
                         || ', ABT='
                         || in_abt_id,
            p_category    => pzm_p_log.cat_terminal,
            p_module      => 'c_stempelzeit_ze_sync',
            p_pers_nr     => in_pers_nr,
            p_ze_rfid     => in_rfid,
            p_terminal_id => in_terminal_id,
            p_aktion      => in_aktion,
            p_quelle      => in_quelle
        );

        v_context.pers_nr := in_pers_nr;
        v_context.quelle := in_quelle;
        v_context.terminal_id := in_terminal_id;
        v_context.rfid := in_rfid;
        v_context.ze_typ := get_ze_typ_from_quelle(in_quelle);
        v_context.zeitstempel := v_buchung_zeit;
        v_context.timezone_name := nvl(in_timezone_name, c_default_timezone);
        v_context.aktion := upper(in_aktion);
        v_context.work_location := in_work_location;
        v_context.ze_status := get_ze_status_from_aktion(in_aktion);
        v_context.kst_id := in_kst_id;
        v_context.abt_id := in_abt_id;
        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        validate_ze_buchung(v_context);
        if is_start_aktion(v_context.aktion) then
            v_offener_ze_id := find_offener_eintrag_id(v_context.pers_nr, v_context.schicht_tag);
            if v_offener_ze_id is not null then
                v_ze := get_ze(v_offener_ze_id, 'c_stempelzeit_ze_sync');
                v_max_std_offen := get_max_std_offen(v_context.pers_nr);
                if ( v_context.zeitstempel - v_ze.ze_ist_start ) > ( v_max_std_offen / 24 ) then
                    auto_close_eintrag(v_offener_ze_id);
                elsif v_ze.ze_status = v_context.ze_status then
                    pzm_p_log.log_data(
                        p_level       => pzm_p_log.level_warning,
                        p_message     => 'Doppeltes Kommen abgelehnt (ignoriert): Schichttag='
                                     || to_char(v_context.schicht_tag, 'YYYY-MM-DD')
                                     || ', existierender ZE_ID='
                                     || v_offener_ze_id,
                        p_category    => pzm_p_log.cat_terminal,
                        p_module      => 'c_stempelzeit_ze_sync',
                        p_pers_nr     => v_context.pers_nr,
                        p_ze_id       => v_offener_ze_id,
                        p_ze_rfid     => in_rfid,
                        p_schicht_tag => v_context.schicht_tag,
                        p_terminal_id => in_terminal_id,
                        p_aktion      => in_aktion,
                        p_quelle      => in_quelle
                    );

                    pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_ze_bereits_offen, pzm_p_lc.o_tp1_pzm_error_ze_bereits_offen, v_offener_ze_id
                    );
                else
                    close_ze_eintrag(v_offener_ze_id, v_buchung_zeit);
                end if;

            end if;

            clear_auto_ze_eintraege(v_context);
            v_offener_ze_id := create_ze_eintrag(v_context, v_buchung_zeit, null);
      -- kein Tagessatz berechnen beim KOMMEN, PAUSE, DIENSTGANG
            commit;
        else
            v_offener_ze_id := find_offener_eintrag_id(v_context.pers_nr, v_context.schicht_tag);
            if v_offener_ze_id is null then
        -- KRITISCH: Gehen ohne Kommen - KEINEN ungueltigen Eintrag erstellen!
                pzm_p_log.log_data(
                    p_level       => pzm_p_log.level_error,
                    p_message     => 'GEHEN OHNE KOMMEN ABGELEHNT: Schichttag='
                                 || to_char(v_context.schicht_tag, 'YYYY-MM-DD')
                                 || ', Buchungszeit='
                                 || to_char(v_buchung_zeit, 'YYYY-MM-DD HH24:MI')
                                 || ' (Kein INSERT mit ze_ist_start=NULL!)',
                    p_category    => pzm_p_log.cat_terminal,
                    p_module      => 'c_stempelzeit_ze_sync',
                    p_pers_nr     => v_context.pers_nr,
                    p_ze_rfid     => in_rfid,
                    p_schicht_tag => v_context.schicht_tag,
                    p_terminal_id => in_terminal_id,
                    p_aktion      => in_aktion,
                    p_quelle      => in_quelle
                );

                pzm_p_lc.raise_app_error_p2(pzm_p_lc.pzm_error_ze_gehen_ohne_kommen,
                                            pzm_p_lc.o_tp2_pzm_error_ze_gehen_ohne_kommen,
                                            to_char(v_context.schicht_tag, 'YYYY-MM-DD'),
                                            nvl(in_terminal_id, 'unbekannt'));

            end if;

            close_ze_eintrag(v_offener_ze_id, v_buchung_zeit);
            commit;
            c_schicht_tag_auswerten(v_context.pers_nr, v_context.schicht_tag);
        end if;

        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Terminal-Sync abgeschlossen: Aktion='
                         || v_context.aktion
                         || ', Zeit='
                         || to_char(v_buchung_zeit, 'YYYY-MM-DD HH24:MI'),
            p_category    => pzm_p_log.cat_terminal,
            p_module      => 'c_stempelzeit_ze_sync',
            p_pers_nr     => v_context.pers_nr,
            p_ze_rfid     => v_context.rfid,
            p_terminal_id => v_context.terminal_id,
            p_aktion      => v_context.aktion,
            p_quelle      => v_context.quelle
        );

        return v_offener_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_terminal,
                                    'c_stempelzeit_ze_sync',
                                    'Aktion='
                                    || in_aktion
                                    || ', Zeit='
                                    || to_char(in_zeitstempel, 'YYYY-MM-DD HH24:MI')
                                    || ', Timezone='
                                    || in_timezone_name
                                    || ', Terminal='
                                    || nvl(in_terminal_id, 'unbekannt'),
                                    in_pers_nr);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_stempelzeit_ze_sync');
    end;

    function c_ze_zeiten_anlegen (
        in_korr_pers_nr          in number,
        in_pers_nr               in number,
        in_ze_status             in number,
        in_schicht_tag           in date,
        in_sa_kurzname           in varchar2,
        in_start_zeit            in date,
        in_start_timezone_name   in varchar2,  -- IANA Timezone Name
        in_ende_zeit             in date,
        in_ende_timezone_name    in varchar2 default null,  -- IANA Timezone Name, bei NULL gleiche TZ wie start
        in_work_location         in number default null,
        in_schicht_tag_auswerten in boolean default true
    ) return pzm_zeiterfassung.ze_id%type is
        v_context t_buchung_context;
        v_ze_id   pzm_zeiterfassung.ze_id%type;
    begin
        if in_ze_status = status_abwesend then
            pzm_p_lc.raise_app_error(pzm_p_lc.pzm_error_buchung, 'Invalid operation! Abwesenheiten koennen hier nicht angelegt werden.'
            );
        end if;

        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'ZE Anlegen (manuell): '
                         || 'Neuer Eintrag, Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_zeiten_anlegen',
            p_pers_nr     => in_pers_nr,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_manuell
        );

        v_context.pers_nr := in_pers_nr;
        v_context.ze_status := in_ze_status;
        v_context.quelle := quelle_manuell;
        v_context.ze_typ := typ_manuell;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := in_sa_kurzname;
        v_context.work_location := in_work_location;
        v_context.calc_ist_start := in_start_zeit;
        v_context.calc_ist_ende := in_ende_zeit;
        v_context.timezone_name := in_start_timezone_name;
    -- TODO: in_ende_timezone_name

        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        ze_ist_zeiten_bewerten(v_context, null, null);
        v_ze_id := create_ze_eintrag(v_context, null, null);
        update pzm_zeiterfassung t
        set
            t.ze_korr_pers_nr = in_korr_pers_nr,
            t.ze_korr_datum = sysdate
        where
            t.ze_id = v_ze_id;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'ZE Anlegen (manuell) abgeschlossen: ZE_ID=' || v_ze_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_zeiten_anlegen',
            p_pers_nr     => in_pers_nr,
            p_ze_id       => v_ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_manuell
        );

        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(in_pers_nr, in_schicht_tag);
        end if;
        return v_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_ze_zeiten_anlegen', null, in_pers_nr, v_ze_id,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_ze_zeiten_anlegen');
    end;

    procedure c_ze_zeiten_korrigieren (
        in_korr_pers_nr          in number,
        in_ze_id                 in number,
        in_ze_status             in number,
        in_schicht_tag           in date,
        in_sa_kurzname           in varchar2,
        in_start_zeit            in date,
        in_start_timezone_name   in varchar2,  -- IANA Timezone Name
        in_ende_zeit             in date,
        in_ende_timezone_name    in varchar2 default null,  -- IANA Timezone Name, bei NULL gleiche TZ wie start
        in_schicht_tag_auswerten in boolean default true
    ) is
        v_ze      pzm_zeiterfassung%rowtype;
        v_context t_buchung_context;
    begin
        if in_ze_status = status_abwesend then
            pzm_p_lc.raise_app_error(pzm_p_lc.pzm_error_buchung, 'Invalid operation! Abwesenheiten koennen hier nicht korrigiert werden.'
            );
        end if;

        v_ze := get_ze(in_ze_id, 'c_ze_zeiten_korrigieren');
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'ZE Korrektur (manuell): ZE_ID='
                         || in_ze_id
                         || ', Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_zeiten_korrigieren',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_manuell
        );

        v_context.pers_nr := v_ze.ze_pers_nr;
        v_context.ze_status := in_ze_status;
        v_context.quelle := quelle_manuell;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := in_sa_kurzname;
        v_context.calc_ist_start := in_start_zeit;
        v_context.calc_ist_ende := in_ende_zeit;
        v_context.timezone_name := in_start_timezone_name;
    -- TODO: in_ende_timezone_name

        ze_ist_zeiten_bewerten(v_context, null, null);
        update pzm_zeiterfassung t
        set
            t.ze_status = v_context.ze_status,
            t.ze_aa_status = null, -- keine Abwesenheit!
            t.ze_sa_kurzname = v_context.sa_kurzname,
            t.ze_schicht_tag = v_context.schicht_tag,
            t.ze_calc_ist_start = v_context.calc_ist_start,
            t.ze_calc_ist_ende = v_context.calc_ist_ende,
            t.ze_std = v_context.ze_std,
            t.ze_korr_pers_nr = in_korr_pers_nr,
            t.ze_korr_datum = sysdate,
            t.last_change_date = sysdate,
            t.last_change_login_id = current_isi_user_login_id()
        where
            t.ze_id = v_ze.ze_id;

        if sql%rowcount = 0 then
            pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_buchung, pzm_p_lc.o_tp1_pzm_error_ze_eintrag_404, v_ze.ze_id);
        end if;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Manuell korrigiert: Start='
                         || to_char(v_context.calc_ist_start, 'YYYY-MM-DD HH24:MI')
                         || ', Ende='
                         || to_char(v_context.calc_ist_ende, 'YYYY-MM-DD HH24:MI')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_zeiten_korrigieren',
            p_pers_nr     => v_context.pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => v_context.schicht_tag,
            p_quelle      => v_context.quelle
        );

        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(v_ze.ze_pers_nr, in_schicht_tag);
        end if;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_ze_zeiten_korrigieren', null, null, in_ze_id,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_ze_zeiten_korrigieren');
    end;

    procedure c_ze_zuordnung_korrigieren (
        in_ze_id                 in number,
        in_kst_id                in number,
        in_abt_id                in number,
        in_pb_id                 in number,
        in_schicht_tag_auswerten in boolean default false
    ) is
        v_ze pzm_zeiterfassung%rowtype;
    begin
        v_ze := get_ze(in_ze_id, 'c_ze_zuordnung_korrigieren');
        pzm_p_log.log_data(
            p_level    => pzm_p_log.level_debug,
            p_message  => 'Korrektur der org. Zuordnung: ZE_ID='
                         || in_ze_id
                         || ', Pers-Nr.='
                         || v_ze.ze_pers_nr
                         || ', Schichttag='
                         || to_char(v_ze.ze_schicht_tag, 'YYYY-MM-DD')
                         || ', KST='
                         || in_kst_id
                         || ', ABT='
                         || in_abt_id
                         || ', PB_ID='
                         || in_pb_id,
            p_category => pzm_p_log.cat_zeiterfassung,
            p_module   => 'c_ze_zuordnung_korrigieren',
            p_pers_nr  => v_ze.ze_pers_nr,
            p_ze_id    => v_ze.ze_id,
            p_quelle   => quelle_manuell
        );

        update pzm_zeiterfassung t
        set
            t.ze_kst_id = in_kst_id,
            t.ze_abt_id = in_abt_id,
            t.ze_pb_id = in_pb_id,
            t.last_change_date = sysdate,
            t.last_change_login_id = current_isi_user_login_id()
        where
            t.ze_id = v_ze.ze_id;

        if sql%rowcount = 0 then
            pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_buchung, pzm_p_lc.o_tp1_pzm_error_ze_eintrag_404, v_ze.ze_id);
        end if;

        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Manuell korrigiert: ZE_ID='
                         || in_ze_id
                         || ', Pers-Nr.='
                         || v_ze.ze_pers_nr
                         || ', Schichttag='
                         || to_char(v_ze.ze_schicht_tag, 'YYYY-MM-DD')
                         || ', KST='
                         || in_kst_id
                         || ', ABT='
                         || in_abt_id
                         || ', PB_ID='
                         || in_pb_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_zuordnung_korrigieren',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => v_ze.ze_schicht_tag,
            p_quelle      => quelle_manuell
        );

        commit;
        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(v_ze.ze_pers_nr, v_ze.ze_schicht_tag);
        end if;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_ze_zuordnung_korrigieren', null, null, in_ze_id);
            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_ze_zuordnung_korrigieren');
    end;

    procedure c_ze_schicht_korrigieren (
        in_ze_id                 in number,
        in_schicht_tag_neu       in date default null,
        in_sa_kurzname_neu       in varchar2 default null,
        in_schicht_tag_auswerten in boolean default true
    ) is
        v_ze      pzm_zeiterfassung%rowtype;
        v_context t_buchung_context;
    begin
        v_ze := get_ze(in_ze_id, 'c_ze_zuordnung_korrigieren');
        pzm_p_log.log_data(
            p_level    => pzm_p_log.level_debug,
            p_message  => 'Korrektur der Schichtdaten: ZE_ID='
                         || in_ze_id
                         || ', Pers-Nr.='
                         || v_ze.ze_pers_nr
                         || ', Schichttag='
                         || to_char(v_ze.ze_schicht_tag, 'YYYY-MM-DD')
                         || ', neuer Schichttag='
                         || nvl(
                to_char(in_schicht_tag_neu, 'YYYY-MM-DD'),
                '(unveraendert)'
            )
                         || ', neue Schichtart='
                         || nvl(in_sa_kurzname_neu, '(unveraendert)'),
            p_category => pzm_p_log.cat_zeiterfassung,
            p_module   => 'c_ze_schicht_korrigieren',
            p_pers_nr  => v_ze.ze_pers_nr,
            p_ze_id    => v_ze.ze_id,
            p_quelle   => quelle_manuell
        );

        v_context.pers_nr := v_ze.ze_pers_nr;
        v_context.ze_status := v_ze.ze_status;
        v_context.quelle := quelle_manuell;
        v_context.schicht_tag := nvl(in_schicht_tag_neu, v_ze.ze_schicht_tag);
        v_context.sa_kurzname := nvl(in_sa_kurzname_neu, v_ze.ze_sa_kurzname);
        v_context.calc_ist_start := v_ze.ze_calc_ist_start;
        v_context.calc_ist_ende := v_ze.ze_calc_ist_ende;
        v_context.ze_std := v_ze.ze_std;
    -- TODO: v_context.timezone_name := null;
    -- TODO: in_ende_timezone_name

    -- Neuberechnung erzwingen
        v_context.calc_ist_start := null;
        v_context.calc_ist_ende := null;
        v_context.ze_std := null;
        ze_ist_zeiten_bewerten(v_context,
                               nvl(v_ze.ze_ist_start, v_ze.ze_calc_ist_start),
                               nvl(v_ze.ze_ist_ende, v_ze.ze_calc_ist_ende));

        update pzm_zeiterfassung t
        set
            t.ze_schicht_tag = nvl(in_schicht_tag_neu, t.ze_schicht_tag),
            t.ze_sa_kurzname = nvl(in_sa_kurzname_neu, t.ze_sa_kurzname),
            t.ze_calc_ist_start = v_context.calc_ist_start,
            t.ze_calc_ist_ende = v_context.calc_ist_ende,
            t.ze_std = v_context.ze_std,
            t.ze_korr_pers_nr = null,
            t.ze_korr_datum = null,
            t.last_change_date = sysdate,
            t.last_change_login_id = current_isi_user_login_id()
        where
            t.ze_id = v_ze.ze_id;

        if sql%rowcount = 0 then
            pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_buchung, pzm_p_lc.o_tp1_pzm_error_ze_eintrag_404, v_ze.ze_id);
        end if;

        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_warning,
            p_message     => 'Schichtdaten manuell korrigiert: ZE_ID='
                         || in_ze_id
                         || ', Pers-Nr.='
                         || v_ze.ze_pers_nr
                         || ', Schichttag='
                         || to_char(v_ze.ze_schicht_tag, 'YYYY-MM-DD')
                         || ', neuer Schichttag='
                         || nvl(
                to_char(in_schicht_tag_neu, 'YYYY-MM-DD'),
                '(unveraendert)'
            )
                         || ', neue Schichtart='
                         || nvl(in_sa_kurzname_neu, '(unveraendert)'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_schicht_korrigieren',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => v_ze.ze_schicht_tag,
            p_quelle      => quelle_manuell
        );

        commit;
        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(v_ze.ze_pers_nr, v_ze.ze_schicht_tag);
            if in_schicht_tag_neu is not null then
                c_schicht_tag_auswerten(v_ze.ze_pers_nr, in_schicht_tag_neu);
            end if;
        end if;

    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_ze_schicht_korrigieren', null, null, in_ze_id);
            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_ze_schicht_korrigieren');
    end;

    procedure c_ze_schicht_korrigieren_alle (
        in_pers_nr               in number,
        in_schicht_tag           in date,
        in_schicht_tag_neu       in date default null,
        in_sa_kurzname_neu       in varchar2 default null,
        in_schicht_tag_auswerten in boolean default true
    ) is

        v_ze_id pzm_zeiterfassung.ze_id%type;
        cursor c_ze_schicht_tag is
        select
            t.ze_id
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = in_pers_nr
            and t.ze_schicht_tag = in_schicht_tag;

    begin
        open c_ze_schicht_tag;
        loop
            fetch c_ze_schicht_tag into v_ze_id;
            exit when c_ze_schicht_tag%notfound;

      -- Jeden ZE-Eintrag einzeln korrigieren,
      -- aber Schicht-Tag Auswertung erst am Ende f?r alle zusammen
            c_ze_schicht_korrigieren(
                in_ze_id                 => v_ze_id,
                in_schicht_tag_neu       => in_schicht_tag_neu,
                in_sa_kurzname_neu       => in_sa_kurzname_neu,
                in_schicht_tag_auswerten => false
            );

        end loop;

        close c_ze_schicht_tag;
        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(in_pers_nr, in_schicht_tag);
            if in_schicht_tag_neu is not null then
                c_schicht_tag_auswerten(in_pers_nr, in_schicht_tag_neu);
            end if;
        end if;

    exception
        when others then
            if c_ze_schicht_tag%isopen then
                close c_ze_schicht_tag;
            end if;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_ze_schicht_korrigieren_alle', null, in_pers_nr, null,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_ze_schicht_korrigieren_alle');
    end;

    procedure c_ze_loeschen (
        in_korr_pers_nr          in number,
        in_ze_id                 in number,
        in_schicht_tag_auswerten in boolean default true
    ) is
        v_ze pzm_zeiterfassung%rowtype;
    begin
        v_ze := get_ze(in_ze_id, 'c_ze_loeschen');
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'ZE Loeschen (manuell): ZE_ID='
                         || v_ze.ze_id
                         || ', Schichttag='
                         || to_char(v_ze.ze_schicht_tag, 'YYYY-MM-DD')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_loeschen',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => v_ze.ze_schicht_tag,
            p_quelle      => quelle_manuell
        );

        delete from pzm_zeiterfassung ze
        where
            ze.ze_id = in_ze_id;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_warning,
            p_message     => 'Manuell geloescht: ZE_ID='
                         || v_ze.ze_id
                         || ', Pers-Nr.='
                         || v_ze.ze_pers_nr
                         || ', Schichttag='
                         || to_char(v_ze.ze_schicht_tag, 'YYYY-MM-DD')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_ze_zeiten_korrigieren',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => v_ze.ze_schicht_tag,
            p_quelle      => quelle_manuell
        );

        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(v_ze.ze_pers_nr, v_ze.ze_schicht_tag);
        end if;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_ze_loeschen', null, null, in_ze_id);
            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_ze_loeschen');
    end;

    function c_abwesenheit_anlegen (
        in_korr_pers_nr          in number,
        in_pers_nr               in number,
        in_ze_aa_id              in number,
        in_schicht_tag           in date,
        in_sa_kurzname           in varchar2,
        in_start_zeit            in date,
        in_ende_zeit             in date,
        in_schicht_tag_auswerten in boolean default true
    ) return pzm_zeiterfassung.ze_id%type is
        v_context t_buchung_context;
        v_ze_id   pzm_zeiterfassung.ze_id%type;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'ZE Anlegen einer Abwesenheit (manuell): '
                         || 'Neuer Eintrag, Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_abwesenheit_anlegen',
            p_pers_nr     => in_pers_nr,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_manuell
        );

        v_context.pers_nr := in_pers_nr;
        v_context.ze_status := status_abwesend;
        v_context.quelle := quelle_manuell;
        v_context.ze_typ := typ_manuell;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := in_sa_kurzname;
        v_context.calc_ist_start := in_start_zeit;
        v_context.calc_ist_ende := in_ende_zeit;
        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        ze_ist_zeiten_bewerten(v_context, null, null);
        v_ze_id := create_ze_eintrag(v_context, null, null);
        update pzm_zeiterfassung t
        set
            t.ze_aa_status = in_ze_aa_id,
            t.ze_korr_pers_nr = in_korr_pers_nr,
            t.ze_korr_datum = sysdate
        where
            t.ze_id = v_ze_id;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'ZE Anlegen einer Abwesenheit (manuell) abgeschlossen: ZE_ID=' || v_ze_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_abwesenheit_anlegen',
            p_pers_nr     => in_pers_nr,
            p_ze_id       => v_ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_manuell
        );

        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(in_pers_nr, in_schicht_tag);
        end if;
        return v_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_abwesenheit_anlegen', null, in_pers_nr, v_ze_id,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_abwesenheit_anlegen');
    end;

    procedure c_abwesenheit_korrigieren (
        in_korr_pers_nr          in number,
        in_ze_id                 in number,
        in_ze_aa_id              in number,
        in_schicht_tag           in date,
        in_sa_kurzname           in varchar2,
        in_start_zeit            in date,
        in_ende_zeit             in date,
        in_schicht_tag_auswerten in boolean default true
    ) is
        v_ze      pzm_zeiterfassung%rowtype;
        v_context t_buchung_context;
    begin
        v_ze := get_ze(in_ze_id, 'c_abwesenheit_korrigieren');
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_debug,
            p_message     => 'ZE Korrektur einer Abwesenheit (manuell): ZE_ID='
                         || in_ze_id
                         || ', Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_abwesenheit_korrigieren',
            p_pers_nr     => v_ze.ze_pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_manuell
        );

        v_context.pers_nr := v_ze.ze_pers_nr;
        v_context.ze_status := status_abwesend;
        v_context.quelle := quelle_manuell;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := in_sa_kurzname;
        v_context.calc_ist_start := in_start_zeit;
        v_context.calc_ist_ende := in_ende_zeit;
        ze_ist_zeiten_bewerten(v_context, null, null);
        update pzm_zeiterfassung t
        set
            t.ze_status = status_abwesend,
            t.ze_aa_status = in_ze_aa_id,
            t.ze_sa_kurzname = nvl(v_context.sa_kurzname, t.ze_sa_kurzname),
            t.ze_schicht_tag = v_context.schicht_tag,
            t.ze_calc_ist_start = v_context.calc_ist_start,
            t.ze_calc_ist_ende = v_context.calc_ist_ende,
            t.ze_std = v_context.ze_std,
            t.ze_korr_pers_nr = in_korr_pers_nr,
            t.ze_korr_datum = sysdate,
            t.last_change_date = sysdate,
            t.last_change_login_id = current_isi_user_login_id()
        where
            t.ze_id = v_ze.ze_id;

        if sql%rowcount = 0 then
            pzm_p_lc.raise_app_error_p1(pzm_p_lc.pzm_error_buchung, pzm_p_lc.o_tp1_pzm_error_ze_eintrag_404, v_ze.ze_id);
        end if;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Manuell korrigiert: Start='
                         || to_char(v_context.calc_ist_start, 'YYYY-MM-DD HH24:MI')
                         || ', Ende='
                         || to_char(v_context.calc_ist_ende, 'YYYY-MM-DD HH24:MI')
                         || ', durch PersNr='
                         || in_korr_pers_nr,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_abwesenheit_korrigieren',
            p_pers_nr     => v_context.pers_nr,
            p_ze_id       => v_ze.ze_id,
            p_schicht_tag => v_context.schicht_tag,
            p_quelle      => v_context.quelle
        );

        if in_schicht_tag_auswerten then
            c_schicht_tag_auswerten(v_ze.ze_pers_nr, in_schicht_tag);
        end if;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_abwesenheit_korrigieren', null, null, in_ze_id,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_abwesenheit_korrigieren');
    end;

    function c_automatische_fehlzeit_eintragen (
        in_pers_nr        in number,
        in_schicht_tag    in date,
        in_aa_id          in number,
        in_sa_kurzname    in varchar2 default null,
        in_fehlzeit_start in date default null,
        in_fehlzeit_ende  in date default null
    ) return pzm_zeiterfassung.ze_id%type is

        v_context        t_buchung_context;
        v_ze_id          pzm_zeiterfassung.ze_id%type;
        v_schicht_tag    date := in_schicht_tag;
        v_sa_kurzname    pzm_zeiterfassung.ze_sa_kurzname%type := in_sa_kurzname;
        v_fehlzeit_start date := in_fehlzeit_start;
        v_fehlzeit_ende  date := in_fehlzeit_ende;
        v_sa_beginn      date;
        v_sa_ende        date;
        v_sa_std_pro_tag number;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatische Fehlzeit: Neuer Eintrag'
                         || ', Pers.-Nr.='
                         || in_pers_nr
                         || ', Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatische_fehlzeit_eintragen',
            p_pers_nr     => in_pers_nr,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_system
        );  

    -- Schichtzeiten ermitteln wenn Start/Ende nicht angegeben
        if v_fehlzeit_start is null
           or v_fehlzeit_ende is null then
            if get_schicht_daten(in_pers_nr, in_schicht_tag, v_schicht_tag, v_sa_kurzname, v_sa_beginn,
                                 v_sa_ende, v_sa_std_pro_tag) = 1 then
                if v_fehlzeit_start is null then
                    v_fehlzeit_start := v_sa_beginn;
                end if;
                if v_fehlzeit_ende is null then
                    v_fehlzeit_ende := v_sa_ende;
                end if;
            else
        -- Fallback auf Standard-Arbeitszeiten
                v_fehlzeit_start := nvl(v_fehlzeit_start, in_schicht_tag + 8 / 24);
                v_fehlzeit_ende := nvl(v_fehlzeit_ende, in_schicht_tag + 16 / 24);
            end if;

        end if;

        v_context.pers_nr := in_pers_nr;
        v_context.ze_status := status_abwesend;
        v_context.quelle := quelle_system;
        v_context.ze_typ := typ_auto;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := v_sa_kurzname;
        v_context.calc_ist_start := v_fehlzeit_start;
        v_context.calc_ist_ende := v_fehlzeit_ende;
        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        v_ze_id := create_ze_eintrag(v_context, null, null);
        if in_aa_id is not null then
            update pzm_zeiterfassung t
            set
                t.ze_aa_status = in_aa_id
            where
                t.ze_id = v_ze_id;

        end if;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatische Fehlzeit eingetragen: ZE_ID=' || v_ze_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatische_fehlzeit_eintragen',
            p_pers_nr     => v_context.pers_nr,
            p_ze_id       => v_ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => v_context.quelle
        );

        return v_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_automatische_fehlzeit_eintragen', null, in_pers_nr, null,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_automatische_fehlzeit_eintragen');
    end;

    function c_automatische_pause_eintragen (
        in_pers_nr     in number,
        in_schicht_tag in date,
        in_sa_kurzname in varchar2,
        in_pause_start in date,
        in_pause_ende  in date
    ) return pzm_zeiterfassung.ze_id%type is
        v_context t_buchung_context;
        v_ze_id   pzm_zeiterfassung.ze_id%type;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatische Pause: Neuer Eintrag'
                         || ', Pers.-Nr.='
                         || in_pers_nr
                         || ', Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatische_pause_eintragen',
            p_pers_nr     => in_pers_nr,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_system
        );

        v_context.pers_nr := in_pers_nr;
        v_context.ze_status := status_pause;
        v_context.quelle := quelle_system;
        v_context.ze_typ := typ_auto;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := in_sa_kurzname;
        v_context.calc_ist_start := in_pause_start;
        v_context.calc_ist_ende := in_pause_ende;
        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        v_ze_id := create_ze_eintrag(v_context, null, null);
        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatische Pause eingetragen: ZE_ID=' || v_ze_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatische_pause_eintragen',
            p_pers_nr     => v_context.pers_nr,
            p_ze_id       => v_ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => v_context.quelle
        );

        return v_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_automatische_pause_eintragen', null, in_pers_nr, null,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_automatische_pause_eintragen');
    end;

    function c_automatischen_feiertag_eintragen (
        in_pers_nr        in number,
        in_schicht_tag    in date,
        in_sa_kurzname    in varchar2 default null, -- ggf. automatisch ermittelt
        in_feiertag_start in date default null, -- relevant bei halben Feiertagen, ansonsten automatisch ermittelt
        in_feiertag_ende  in date default null  -- relevant bei halben Feiertagen, ansonsten automatisch ermittelt
    ) return pzm_zeiterfassung.ze_id%type is

        v_context        t_buchung_context;
        v_ze_id          pzm_zeiterfassung.ze_id%type;
        v_schicht_tag    date := in_schicht_tag;
        v_sa_kurzname    pzm_zeiterfassung.ze_sa_kurzname%type := in_sa_kurzname;
        v_aa_id          pzm_zeiterfassung.ze_aa_status%type;
        v_feiertag_start date := in_feiertag_start;
        v_feiertag_ende  date := in_feiertag_ende;
        v_sa_beginn      date;
        v_sa_ende        date;
        v_sa_std_pro_tag number;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatischer Feiertag: Neuer Eintrag'
                         || ', Pers.-Nr.='
                         || in_pers_nr
                         || ', Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatischen_feiertag_eintragen',
            p_pers_nr     => in_pers_nr,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_system
        );  

    -- Schichtzeiten ermitteln wenn Start/Ende nicht angegeben
        if v_feiertag_start is null
           or v_feiertag_ende is null then
            if get_schicht_daten(in_pers_nr, in_schicht_tag, v_schicht_tag, v_sa_kurzname, v_sa_beginn,
                                 v_sa_ende, v_sa_std_pro_tag) = 1 then
                if v_feiertag_start is null then
                    v_feiertag_start := v_sa_beginn;
                end if;
                if v_feiertag_ende is null then
                    v_feiertag_ende := v_sa_ende;
                end if;
            else
        -- Fallback auf Standard-Arbeitszeiten
                v_feiertag_start := nvl(v_feiertag_start, in_schicht_tag + 8 / 24);
                v_feiertag_ende := nvl(v_feiertag_ende, in_schicht_tag + 16 / 24);
            end if;

        end if;

        v_context.pers_nr := in_pers_nr;
        v_context.ze_status := status_feiertag;
        v_context.quelle := quelle_system;
        v_context.ze_typ := typ_auto;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := v_sa_kurzname;
        v_context.calc_ist_start := v_feiertag_start;
        v_context.calc_ist_ende := v_feiertag_ende;
        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        v_ze_id := create_ze_eintrag(v_context, null, null);
        v_aa_id := pzm_utils.get_feiertag_aa_id();
        if v_aa_id is not null then
            update pzm_zeiterfassung t
            set
                t.ze_aa_status = v_aa_id
            where
                t.ze_id = v_ze_id;

        end if;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatischen Feiertag eingetragen: ZE_ID=' || v_ze_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatischen_feiertag_eintragen',
            p_pers_nr     => v_context.pers_nr,
            p_ze_id       => v_ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => v_context.quelle
        );

        return v_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_automatischen_feiertag_eintragen', null, in_pers_nr, null,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_automatischen_feiertag_eintragen');
    end;

    function c_automatische_anwesenheit_eintragen (
        in_pers_nr           in number,
        in_schicht_tag       in date,
        in_sa_kurzname       in varchar2,
        in_anwesenheit_start in date,
        in_anwesenheit_ende  in date,
        in_aa_id             in number default null -- optional, wenn vorhanden
    ) return pzm_zeiterfassung.ze_id%type is
        v_context t_buchung_context;
        v_ze_id   pzm_zeiterfassung.ze_id%type;
    begin
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatische Anwesenheit: Neuer Eintrag'
                         || ', Pers.-Nr.='
                         || in_pers_nr
                         || ', Schichttag='
                         || to_char(in_schicht_tag, 'YYYY-MM-DD'),
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatische_anwesenheit_eintragen',
            p_pers_nr     => in_pers_nr,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => quelle_system
        );

        v_context.pers_nr := in_pers_nr;
        v_context.ze_status := status_anwesend;
        v_context.quelle := quelle_system;
        v_context.ze_typ := typ_system;
        v_context.schicht_tag := in_schicht_tag;
        v_context.sa_kurzname := in_sa_kurzname;
        v_context.calc_ist_start := in_anwesenheit_start;
        v_context.calc_ist_ende := in_anwesenheit_ende;
        load_mitarbeiter_daten(v_context);
        load_schicht_daten(v_context);
        v_ze_id := create_ze_eintrag(v_context, null, null);
        if in_aa_id is not null then
            update pzm_zeiterfassung t
            set
                t.ze_aa_status = in_aa_id
            where
                t.ze_id = v_ze_id;

        end if;

        commit;
        pzm_p_log.log_data(
            p_level       => pzm_p_log.level_info,
            p_message     => 'Automatische Anwesenheit eingetragen: ZE_ID=' || v_ze_id,
            p_category    => pzm_p_log.cat_zeiterfassung,
            p_module      => 'c_automatische_anwesenheit_eintragen',
            p_pers_nr     => v_context.pers_nr,
            p_ze_id       => v_ze_id,
            p_schicht_tag => in_schicht_tag,
            p_quelle      => v_context.quelle
        );

        return v_ze_id;
    exception
        when others then
            rollback;
            pzm_p_log.log_exception(pzm_p_log.cat_zeiterfassung, 'c_automatische_anwesenheit_eintragen', null, in_pers_nr, null,
                                    in_schicht_tag);

            pzm_p_lc.catch_and_rethrow('pzm_p_zeiterfassung.c_automatische_anwesenheit_eintragen');
    end;

end;
/


-- sqlcl_snapshot {"hash":"5617dd0b2645a7a51769d4e29c0403042ef87177","type":"PACKAGE_BODY","name":"PZM_P_ZEITERFASSUNG","schemaName":"DIRKSPZM32","sxml":""}