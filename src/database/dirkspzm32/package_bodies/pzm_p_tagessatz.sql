create or replace
package body DIRKSPZM32.PZM_P_TAGESSATZ as
  -----------------------------------------------------------------------------------------------
  -- Package Body: pzm_p_tagessatz
  -- Refactoring von UPDATE_PERS_ZE_TAG
  -- Autor: M.Haberstock, W24120-635 / 2026-07
  -----------------------------------------------------------------------------------------------

  -- ZE-Status-Konstanten
  c_status_anwesend    constant number := 2;
  c_status_abwesend    constant number := 0;
  c_status_pause       constant number := 4;
  c_status_dienstgang  constant number := 5;
  c_status_feiertag    constant number := 6;
  c_status_urlaub_halb constant number := 41;

  -- Maximale Anzahl Neuberechnungs-Durchlaeufe (ersetzt Rekursion)
  c_max_durchlaeufe constant number := 3;

  -----------------------------------------------------------------------------------------------
  -- Interne Record-Typen
  -----------------------------------------------------------------------------------------------

  -- Unveraenderlicher Tageskontext: Personal- und Schichtdaten
  type t_kontext is record (
    pers_nr                pzm_personal.pers_nr%type,
    schicht_datum          date,
    pb_id                  number,
    abt_id                 number,
    kst_id                 number,
    kst_id_ze              number,           -- aus erster ZE-Zeile ermittelt
    kappung_schicht_ende   pzm_schicht_modelle.kappung_schicht_ende%type,
    kappung_te_ab_flx_std  pzm_personal.pers_kappung_te_ab_flx_std%type,
    def_sa_kurzname        varchar2(10),     -- Standard-Schichtart laut pzm_utils
    schicht_modell         pzm_schicht_modelle%rowtype,
    ze_tagessatz           pzm_ze_tagessatz%rowtype,
    day_arb_std_guts_min   number            -- vom Bediener festgeschrieben
  );

  -- Ergebnisse der ZE-Akkumulation und nachgelagerten Berechnungen
  type t_saldi is record (
    -- aus ZE-Loop akkumuliert
    day_anw_std            number,
    day_abw_std            number,
    day_pause_stempel_std  number,
    day_pause_std          number,
    day_pause_bez_std      number,
    day_reise_passiv_std   number,
    day_calc_start         date,
    day_calc_ende          date,
    day_calc_anw_start     date,
    day_calc_anw_ende      date,
    day_sa_kurzname        pzm_zeiterfassung.ze_sa_kurzname%type,
    day_aa_status          number,
    schichtart             pzm_schichtarten%rowtype,
    kenz_urlaub            boolean,
    gesamt_tag_std_urlaub  number,
    -- aus Schichtermittlung
    sa_found               boolean,
    sa_beginn              date,
    sa_ende                date,
    sa_std_pro_tag         number,
    -- berechnete Saldi
    day_arb_std            number,
    day_ueb_std            number,
    day_flex_std           number,
    -- Wiedereingliederung
    found_wiedereing       boolean,
    wiedereing_aa_art      pzm_abwesenheitsarten%rowtype
  );

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 1: Kontext laden
  -- Laedt Personaldaten, Tagessatz, Schichtmodell und Kappungswerte.
  -- Gibt false zurueck wenn Person zum Datum nicht angestellt ist.
  -----------------------------------------------------------------------------------------------
  function p_kontext_laden(
    p_pers_nr in  number,
    p_datum   in  date,
    p_ctx     out t_kontext,
    p_result  out number,
    p_info    out varchar2
  ) return boolean is
    v_found boolean;
  begin
    p_ctx.pers_nr       := p_pers_nr;
    p_ctx.schicht_datum := trunc(p_datum);

    -- Personalcheck
    select p.pers_nr, p.pers_pb_id, p.pers_abt_id, p.pers_kst_id,
           p.pers_kappung_schicht_ende, p.pers_kappung_te_ab_flx_std
      into p_ctx.pers_nr, p_ctx.pb_id, p_ctx.abt_id, p_ctx.kst_id,
           p_ctx.kappung_schicht_ende, p_ctx.kappung_te_ab_flx_std
      from pzm_personal p
     where (p.pers_austrittdatum   is null or p.pers_austrittdatum   >= trunc(p_datum))
       and (p.pers_eintrittsdatum  is null or p.pers_eintrittsdatum  <= trunc(p_datum))
       and p.pers_nr = p_pers_nr;

    -- Vorhandenen Tagessatz laden (KST/ABT/PB ueberschreiben ggf. Personaldaten)
    begin
      select t.*
        into p_ctx.ze_tagessatz
        from pzm_ze_tagessatz t
       where t.ts_pers_nr = p_pers_nr
         and t.ts_datum   = p_ctx.schicht_datum;

      if p_ctx.ze_tagessatz.ts_day_kst_id is not null then p_ctx.kst_id  := p_ctx.ze_tagessatz.ts_day_kst_id; end if;
      if p_ctx.ze_tagessatz.ts_day_abt_id is not null then p_ctx.abt_id  := p_ctx.ze_tagessatz.ts_day_abt_id; end if;
      if p_ctx.ze_tagessatz.ts_day_pb_id  is not null then p_ctx.pb_id   := p_ctx.ze_tagessatz.ts_day_pb_id;  end if;
    exception
      when no_data_found then null;
    end;

    -- Schichtmodell laden
    if not pzm_p_base.get_schicht_modell(p_pers_nr, p_ctx.schicht_modell) then
      p_ctx.schicht_modell.flex_max_std_pro_woche := 0;
    end if;

    -- Kappung: Personalwert hat Vorrang, Fallback auf Schichtmodell
    if p_ctx.kappung_te_ab_flx_std is null
       and p_ctx.schicht_modell.kappung_te_ab_flx_std is not null
    then
      p_ctx.kappung_te_ab_flx_std := p_ctx.schicht_modell.kappung_te_ab_flx_std;
    end if;

    -- Vom Bediener festgeschriebene Gutschriftzeit
    p_ctx.day_arb_std_guts_min := 0;
    if p_ctx.ze_tagessatz.ts_abschluss   is not null
       and p_ctx.ze_tagessatz.ts_ueb_ok_pers_nr is null
    then
      p_ctx.day_arb_std_guts_min := nvl(p_ctx.ze_tagessatz.ts_day_arb_std_g_min, 0);
    end if;

    p_ctx.def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(p_pers_nr);

    return true;
  exception
    when no_data_found then
      p_result := -2;
      p_info   := 'Die Person (' || p_pers_nr || ') ist zu dem Zeitpunkt ('
                  || to_char(p_datum, 'dd.mm.yyyy') || ') noch nicht angestellt.';
      return false;
  end p_kontext_laden;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 2: ZE-Eintraege akkumulieren (zusammengefasster Ersatz fuer c_ZETag_All + c_ZETag)
  -----------------------------------------------------------------------------------------------
  procedure p_ze_eintraege_akkumulieren(
    p_ctx in out t_kontext,
    p_sal in out t_saldi
  ) is
    v_abwes_art  pzm_abwesenheitsarten%rowtype;
    v_lohnart    pzm_lohnarten%rowtype;
    v_pause_std  number;
    v_first      boolean := true;

    cursor c_ze is
      select *
        from pzm_zeiterfassung
       where ze_pers_nr    = p_ctx.pers_nr
         and trunc(ze_schicht_tag) = trunc(p_ctx.schicht_datum)
       order by ze_calc_ist_start, ze_id;

    v_ze pzm_zeiterfassung%rowtype;
    v_aa_status number;
    v_std       number;
  begin
    -- Saldi nullen
    p_sal.day_anw_std           := 0;
    p_sal.day_abw_std           := 0;
    p_sal.day_pause_stempel_std := 0;
    p_sal.day_pause_bez_std     := 0;
    p_sal.day_reise_passiv_std  := 0;
    p_sal.gesamt_tag_std_urlaub := 0;
    p_sal.kenz_urlaub           := false;
    p_sal.day_sa_kurzname       := null;
    p_sal.schichtart            := null;
    p_sal.day_aa_status         := null;
    p_sal.day_calc_anw_start    := null;
    p_sal.day_calc_anw_ende     := null;
    p_sal.sa_found              := false;
    p_sal.found_wiedereing      := false;

    open c_ze;
    loop
      fetch c_ze into v_ze;
      exit when c_ze%notfound;

      v_std       := nvl(v_ze.ze_std, 0);
      v_aa_status := v_ze.ze_aa_status;

      -- KST aus erster ZE-Zeile
      p_ctx.kst_id_ze := nvl(nvl(p_ctx.kst_id_ze, v_ze.ze_kst_id), p_ctx.kst_id);

      -- Schichtart beim ersten Eintrag merken
      if p_sal.day_sa_kurzname is null and v_ze.ze_sa_kurzname is not null then
        p_sal.day_sa_kurzname := v_ze.ze_sa_kurzname;
        if not pzm_p_base.get_schichtart_by_uix(p_sal.day_sa_kurzname, p_sal.schichtart) then
          p_sal.schichtart := null;
        end if;
      end if;

      -- Halburtlaub-Gesamtstunden merken
      if v_ze.ze_status = c_status_abwesend and v_aa_status = c_status_urlaub_halb then
        p_sal.gesamt_tag_std_urlaub := nvl(p_sal.gesamt_tag_std_urlaub, 0) + v_std;
      end if;

      -- Abwesenheitsart pruefen
      if pzm_p_base.get_abwesenheitsart(v_aa_status, v_abwes_art) is null then
        v_aa_status := null;
      else
        if v_abwes_art.kennz_urlaub = c.C_TRUE then
          p_sal.kenz_urlaub           := true;
          p_sal.gesamt_tag_std_urlaub := p_sal.gesamt_tag_std_urlaub + v_std;
        end if;
        -- Abwesenheit die als Arbeitszeit zaehlt (z.B. Arztbesuch)
        if v_abwes_art.lz_id is not null then
          if pzm_p_base.get_lohnart(v_abwes_art.lz_id, v_lohnart)
             and v_lohnart.lz_operator = 'ARBSTD'
          then
            p_sal.day_anw_std        := p_sal.day_anw_std + v_std;
            p_sal.day_calc_anw_start := nvl(p_sal.day_calc_anw_start, v_ze.ze_calc_ist_start);
            p_sal.day_calc_anw_ende  := nvl(p_sal.day_calc_anw_ende,  v_ze.ze_calc_ist_ende);
            v_std := 0;
          end if;
        end if;
      end if;

      -- Reise-Passivzeit
      if v_ze.ze_status = c_status_dienstgang
         and v_ze.ze_work_location in (52, 53)
      then
        p_sal.day_reise_passiv_std := p_sal.day_reise_passiv_std + v_std;
      end if;

      -- Tages-Start/-Ende
      if v_first then
        p_sal.day_calc_start := v_ze.ze_calc_ist_start;
        p_sal.day_calc_ende  := v_ze.ze_calc_ist_ende;
        p_ctx.kst_id         := p_ctx.kst_id_ze;
        -- KST in Tagessatz aktualisieren
        update pzm_ze_tagessatz t
           set t.ts_day_kst_id = p_ctx.kst_id
         where t.ts_pers_nr = p_ctx.ze_tagessatz.ts_pers_nr
           and t.ts_datum   = p_ctx.ze_tagessatz.ts_datum;
        v_first := false;
      else
        p_sal.day_calc_ende := v_ze.ze_calc_ist_ende;
      end if;

      -- Status-basierte Akkumulation
      if v_ze.ze_status = c_status_abwesend then
        if v_aa_status is not null then
          p_sal.day_aa_status := v_aa_status;
        end if;
        p_sal.day_abw_std := p_sal.day_abw_std + v_std;

      elsif v_ze.ze_status = c_status_feiertag then
        if v_aa_status is not null then
          p_sal.day_aa_status := v_aa_status;
        end if;

      elsif v_ze.ze_status in (c_status_anwesend, c_status_dienstgang, c_status_pause) then
        p_sal.day_anw_std := p_sal.day_anw_std + v_std;

        if p_sal.day_calc_anw_start is null then
          p_sal.day_calc_anw_start := v_ze.ze_calc_ist_start;
        end if;
        if v_ze.ze_calc_ist_ende is not null then
          p_sal.day_calc_anw_ende := v_ze.ze_calc_ist_ende;
        end if;

        if v_ze.ze_status = c_status_pause then
          p_sal.day_pause_stempel_std := p_sal.day_pause_stempel_std + v_std;
        else
          v_pause_std := get_pause_time(p_sal.day_sa_kurzname,
                                        v_ze.ze_calc_ist_start,
                                        v_ze.ze_calc_ist_ende,
                                        p_ctx.pb_id);
          if v_pause_std > 0 then
            p_sal.day_pause_stempel_std := p_sal.day_pause_stempel_std + v_pause_std;
          end if;
        end if;
      end if;

    end loop;
    close c_ze;

    p_sal.day_pause_std := p_sal.day_pause_stempel_std;
  end p_ze_eintraege_akkumulieren;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 3: Pausen finalisieren (Stempel-Pause vs. Schicht-Pause)
  -----------------------------------------------------------------------------------------------
  procedure p_pausen_finalisieren(
    p_ctx in     t_kontext,
    p_sal in out t_saldi
  ) is
    v_pause_std number;
  begin
    -- Schichtmodell-basierte Mindestpause ermitteln
    v_pause_std := get_pause_time_day(p_sal.day_sa_kurzname,
                                      p_sal.day_calc_anw_start,
                                      p_sal.day_calc_anw_ende,
                                      p_sal.day_anw_std,
                                      p_sal.day_pause_std,
                                      p_ctx.pb_id,
                                      p_sal.day_pause_bez_std);
    if nvl(p_sal.day_pause_std, 0) < nvl(v_pause_std, 0) then
      p_sal.day_pause_std := v_pause_std;
    end if;

    -- Manuell festgelegte Zeiten haben Vorrang
    if p_ctx.ze_tagessatz.ts_abschluss    is not null
       and p_ctx.ze_tagessatz.ts_ueb_ok_pers_nr is null
    then
      p_sal.day_ueb_std   := p_ctx.ze_tagessatz.ts_day_ueb_std;
      p_sal.day_flex_std  := p_ctx.ze_tagessatz.ts_day_flex_std;
      p_sal.day_pause_std := p_ctx.ze_tagessatz.ts_day_pause_std;
    end if;

    if p_sal.day_anw_std <= 0 then
      p_sal.day_pause_std := 0;
    end if;
  end p_pausen_finalisieren;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 4: Urlaubskorrektur (Flex/Arbstd bei Urlaub + Arbeit)
  -----------------------------------------------------------------------------------------------
  procedure p_urlaub_korrigieren(p_sal in out t_saldi) is
  begin
    if not p_sal.kenz_urlaub then return; end if;
    if p_sal.day_arb_std <= 0 then return; end if;

    -- Geleistete Mehrstunden ueber den Urlaubsanteil dem Flex-Konto gutschreiben.
    -- Formel: flex = (anw - pause) + urlaub_std - soll_std
    --              = day_arb_std + gesamt_tag_std_urlaub - sa_std_pro_tag
    p_sal.day_flex_std := p_sal.day_arb_std
                          + p_sal.gesamt_tag_std_urlaub
                          - p_sal.sa_std_pro_tag;

    if p_sal.day_flex_std >= 0 then
      -- Positiver Flex: Arbstd um Flex reduzieren (Mehrarbeit ins Aufbaukonto)
      p_sal.day_arb_std := p_sal.day_arb_std - p_sal.day_flex_std;
    else
      -- Negativer Flex: Mitarbeiter hat weniger gearbeitet als Urlaubsanteil.
      -- Flex bleibt 0; Lucke wird von Fehlzeit-Pruefung als Abwesenheit erfasst.
      p_sal.day_flex_std := 0;
    end if;
  end p_urlaub_korrigieren;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 5: Wiedereingliederung pruefen (WE-N-KRANK)
  -----------------------------------------------------------------------------------------------
  procedure p_wiedereingliederung_pruefen(
    p_ctx in out t_kontext,
    p_sal in out t_saldi
  ) is
    v_abwes_art pzm_abwesenheitsarten%rowtype;
  begin
    begin
      select a.*
        into v_abwes_art
        from pzm_abwesenheitsmeldungen t,
             pzm_abwesenheitsarten a
       where t.pers_nr    = p_ctx.pers_nr
         and t.aa_id      = a.aa_id
         and a.aa_kurzname = 'WE-N-KRANK'
         and p_ctx.schicht_datum between t.beginn and t.ende
         and rownum = 1;

      p_sal.found_wiedereing     := true;
      p_sal.wiedereing_aa_art    := v_abwes_art;
    exception
      when no_data_found then
        p_sal.found_wiedereing := false;
    end;

    if not p_sal.found_wiedereing then return; end if;

    p_sal.day_arb_std   := 0;
    p_sal.day_abw_std   := p_sal.sa_std_pro_tag;
    p_sal.day_aa_status := v_abwes_art.aa_id;

    -- Lohnart-Auswertung loeschen und neu anlegen
    update pzm_ze_loa_ausw t
       set t.aa_id = null
     where t.zeaw_pers_nr = p_ctx.pers_nr
       and t.zeaw_datum   = p_ctx.schicht_datum;
    delete pzm_ze_loa_ausw t
     where t.zeaw_pers_nr = p_ctx.pers_nr
       and t.zeaw_datum   = p_ctx.schicht_datum;
    update pzm_zeiterfassung t
       set t.ze_aa_status  = p_sal.day_aa_status,
           t.ze_bemerkung  = v_abwes_art.aa_kurzname
     where t.ze_pers_nr    = p_ctx.pers_nr
       and t.ze_schicht_tag = p_ctx.schicht_datum;

    if v_abwes_art.lz_id is not null then
      insert into pzm_ze_loa_ausw
        (zeaw_pers_nr, zeaw_datum, zeaw_lz_lohnart, zeaw_lz_loa_std,
         aa_id, zeaw_lz_id, zeaw_pb_id, zeaw_kst_id)
      values
        (p_ctx.pers_nr,
         p_ctx.schicht_datum,
         (select loa.lz_lohnart from pzm_lohnarten loa where loa.lz_id = v_abwes_art.lz_id),
         p_sal.day_abw_std,
         p_sal.day_aa_status,
         v_abwes_art.lz_id,
         p_ctx.pb_id,
         p_ctx.kst_id);
    end if;
  end p_wiedereingliederung_pruefen;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 6: Fehlzeit-Luecken schliessen
  -- Gibt true zurueck wenn neue ZE-Saetze erzeugt wurden (Neuberechnung erforderlich).
  -----------------------------------------------------------------------------------------------
  function p_fehlzeit_luecken_schliessen(
    p_ctx     in out t_kontext,
    p_sal     in out t_saldi,
    p_zaehler in     number
  ) return boolean is
    v_schichtart_daten pzm_schichtarten%rowtype;
    v_sa_ende_korr     date;
    v_abw_std_diff     number;
    v_found_schicht    boolean;
  begin
    -- Schichtart-Details fuer Lückenprüfung laden
    begin
      select t.*
        into v_schichtart_daten
        from pzm_schichtarten t
       where t.sa_kurzname = p_sal.day_sa_kurzname;
      v_found_schicht := true;
    exception
      when no_data_found then v_found_schicht := false;
    end;

    if p_sal.schichtart.calc_basis = 'GLEITZ' then
      -- Gleitzeit: Abwesenheitsdifferenz am Tagesende anfuegen
      v_abw_std_diff := p_sal.sa_std_pro_tag - (p_sal.day_arb_std + p_sal.day_abw_std);
      if v_abw_std_diff > 0
         and (p_sal.day_arb_std > 0 or p_sal.day_abw_std > 0)
      then
        return not pzm_p_schicht_tag.c_schicht_tag_fehlzeit_luecken_pruefen(
          p_ctx.pers_nr,
          p_ctx.schicht_datum,
          p_sal.day_sa_kurzname,
          p_sal.sa_beginn,
          p_sal.day_calc_ende + v_abw_std_diff / 24,
          p_sal.day_calc_start,
          p_sal.day_calc_ende,
          p_sal.day_calc_ende,
          p_ctx.kst_id,
          p_ctx.abt_id,
          p_ctx.pb_id,
          p_sal.day_abw_std,
          p_sal.day_arb_std,
          p_sal.day_pause_std,
          p_zaehler,
          p_sal.sa_std_pro_tag
        );
      end if;

    elsif (   (p_sal.day_sa_kurzname != p_ctx.def_sa_kurzname
               and p_sal.day_arb_std > 0
               and p_sal.day_abw_std = 0)
           or (p_sal.day_sa_kurzname != p_ctx.def_sa_kurzname
               and p_sal.day_arb_std + p_sal.day_abw_std
                   < nvl(v_schichtart_daten.sa_std_pro_tag,
                         p_ctx.schicht_modell.d_arb_std_pro_tag))
          )
          and nvl(v_schichtart_daten.sa_std_pro_tag, 1) != 0
          and (p_ctx.schicht_modell.d_arb_std_pro_tag is null
               or p_sal.day_arb_std < p_ctx.schicht_modell.d_arb_std_pro_tag)
    then
      -- Festschicht mit Lücke
      if nvl(v_schichtart_daten.sa_std_pro_tag,
             p_ctx.schicht_modell.d_arb_std_pro_tag) is not null
      then
        v_sa_ende_korr := p_sal.day_calc_anw_start
                          + (nvl(v_schichtart_daten.sa_std_pro_tag,
                                 p_ctx.schicht_modell.d_arb_std_pro_tag)
                             + p_sal.day_pause_std) / 24;
        if p_sal.day_calc_anw_start > p_sal.sa_beginn then
          p_sal.sa_beginn := p_sal.day_calc_anw_start;
        end if;
      else
        v_sa_ende_korr := p_sal.sa_ende;
      end if;

      return not pzm_p_schicht_tag.c_schicht_tag_fehlzeit_luecken_pruefen(
        p_ctx.pers_nr,
        p_ctx.schicht_datum,
        p_sal.day_sa_kurzname,
        p_sal.sa_beginn,
        v_sa_ende_korr,
        p_sal.day_calc_anw_start,
        p_sal.day_calc_anw_ende,
        p_sal.day_calc_ende,
        p_ctx.kst_id,
        p_ctx.abt_id,
        p_ctx.pb_id,
        p_sal.day_abw_std,
        p_sal.day_arb_std,
        p_sal.day_pause_std,
        p_zaehler,
        p_sal.sa_std_pro_tag
      );
    end if;

    return false; -- keine Lücke
  end p_fehlzeit_luecken_schliessen;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 7: Ueberstunden und Flex berechnen
  -----------------------------------------------------------------------------------------------
  procedure p_ueberstunden_berechnen(
    p_ctx in out t_kontext,
    p_sal in out t_saldi
  ) is
    v_schichtart_daten  pzm_schichtarten%rowtype;
    v_flex_max_std_tag  number;
    v_flex_max_std_wo   number;
    v_wo_arb_std        number;
    v_wo_flex_std       number;
    v_wo_ueb_std        number;
    v_wo_feiertag_std   number;
    v_ges_arb_std_wo    number;
    v_diff_flex         number;
  begin
    -- Abwesenheits-Cap: Abwstd nicht groesser als Sollstunden wenn nicht gearbeitet
    if p_sal.day_arb_std = 0 and p_sal.day_abw_std > p_sal.sa_std_pro_tag then
      p_sal.day_abw_std := p_sal.sa_std_pro_tag;
    end if;

    if p_sal.day_arb_std <= p_sal.sa_std_pro_tag then return; end if;

    -- Schichtart-Flex-Max
    begin
      select t.*
        into v_schichtart_daten
        from pzm_schichtarten t
       where t.sa_kurzname = p_sal.day_sa_kurzname;
      v_flex_max_std_tag := v_schichtart_daten.flex_max_std_pro_tag;
    exception
      when no_data_found then v_flex_max_std_tag := null;
    end;
    if v_flex_max_std_tag is null then
      v_flex_max_std_tag := 24 - p_sal.sa_std_pro_tag;
    end if;

    v_flex_max_std_wo := nvl(p_ctx.schicht_modell.flex_max_std_pro_woche, 0);

    -- Kappung Schichtende ermitteln
    if p_ctx.kappung_schicht_ende = 'F'
       and nvl(p_ctx.schicht_modell.kappung_schicht_ende, 'F') = 'T'
    then
      p_ctx.kappung_schicht_ende := 'T';
    end if;
    -- Ueberstunden-Schichten und manuell freigegebene werden nicht gekappt
    if nvl(v_schichtart_daten.sa_standard, 'F') = 'T'
       or p_ctx.ze_tagessatz.ts_ueb_ok_pers_nr is not null
    then
      p_ctx.kappung_schicht_ende := 'F';
    end if;

    if p_ctx.kappung_schicht_ende = 'T'
       and p_sal.day_arb_std > p_sal.sa_std_pro_tag
       and p_sal.day_arb_std > p_ctx.kappung_te_ab_flx_std
    then
      p_sal.day_arb_std := p_ctx.kappung_te_ab_flx_std;
    end if;

    if v_flex_max_std_tag = 0 then
      -- Keine Flexstunden: alles Ueberstunden
      p_sal.day_ueb_std := p_sal.day_arb_std - p_sal.sa_std_pro_tag;
    else
      if p_sal.day_arb_std > v_flex_max_std_tag then
        p_sal.day_flex_std := v_flex_max_std_tag - p_sal.sa_std_pro_tag;
        p_sal.day_ueb_std  := p_sal.day_arb_std  - v_flex_max_std_tag;
      else
        p_sal.day_flex_std := p_sal.day_arb_std - p_sal.sa_std_pro_tag;
        -- Feiertags-Sonderregel: alle Arbeitsstunden sind Flex
        if check_feiertag(p_ctx.pb_id, p_ctx.abt_id, p_ctx.pers_nr,
                          p_ctx.kst_id, p_ctx.schicht_datum) is not null
        then
          p_sal.day_flex_std  := p_sal.day_arb_std;
          p_sal.sa_std_pro_tag := 0;
        end if;
      end if;

      -- Wochenmaximum pruefen (nur bei Standard-/Ueberstundenschichten)
      if p_sal.day_flex_std > 0
         and v_flex_max_std_wo > 0
         and (p_sal.day_sa_kurzname = p_ctx.def_sa_kurzname
              or nvl(v_schichtart_daten.sa_std_pro_tag, 1) = 0)
      then
        select nvl(sum(t.ts_day_arb_std), 0),
               nvl(sum(decode(t.ts_ueb_ok_datum, null, 0,
                    decode(t.ts_ueb_storno_datum, null, t.ts_day_flex_std, 0))), 0),
               nvl(sum(decode(t.ts_ueb_ok_datum, null, 0,
                    decode(t.ts_ueb_storno_datum, null, t.ts_day_ueb_std, 0))), 0),
               nvl(sum(decode(instr(nvl(check_feiertag(p_ctx.pb_id, p_ctx.abt_id,
                                        p_ctx.pers_nr, p_ctx.kst_id, t.ts_datum), ' '),
                              'F'), 0, 0, t.ts_day_abw_std)), 0)
          into v_wo_arb_std, v_wo_flex_std, v_wo_ueb_std, v_wo_feiertag_std
          from pzm_ze_tagessatz t
         where t.ts_pers_nr = p_ctx.pers_nr
           and t.ts_datum between next_day(p_ctx.schicht_datum, 'So') - 7
                               and p_ctx.schicht_datum - 1;

        v_ges_arb_std_wo := v_wo_arb_std + v_wo_flex_std + v_wo_ueb_std
                            + v_wo_feiertag_std + p_sal.sa_std_pro_tag;

        if v_ges_arb_std_wo >= v_flex_max_std_wo then
          p_sal.day_ueb_std  := p_sal.day_ueb_std  + p_sal.day_flex_std;
          p_sal.day_flex_std := 0;
        elsif (v_ges_arb_std_wo + p_sal.day_flex_std) >= v_flex_max_std_wo then
          v_diff_flex := (v_ges_arb_std_wo + p_sal.day_flex_std) - v_flex_max_std_wo;
          if p_sal.day_flex_std > v_diff_flex then
            p_sal.day_ueb_std  := p_sal.day_ueb_std  + v_diff_flex;
            p_sal.day_flex_std := p_sal.day_flex_std - v_diff_flex;
          else
            p_sal.day_ueb_std  := p_sal.day_ueb_std  + p_sal.day_flex_std;
            p_sal.day_flex_std := 0;
          end if;
        end if;
      end if;
    end if;

    p_sal.day_arb_std := p_sal.sa_std_pro_tag;
    if p_sal.day_aa_status is null and p_sal.day_ueb_std > 0 then
      p_sal.day_abw_std := 0;
    end if;
  end p_ueberstunden_berechnen;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 8: Feiertagskorrektur (Arbstd -> Flex an Feiertagen)
  -----------------------------------------------------------------------------------------------
  procedure p_feiertag_korrigieren(
    p_ctx in     t_kontext,
    p_sal in out t_saldi
  ) is
    v_sonder_feiertag varchar2(5);
  begin
    if ist_feiertag(p_ctx.pers_nr, p_ctx.pb_id, p_ctx.abt_id, p_ctx.kst_id,
                    p_ctx.schicht_datum, v_sonder_feiertag) != 1
    then return; end if;

    -- Halbfeiertag nur beruecksichtigen wenn gleichzeitig Urlaub (aktuelle Logik, zur Diskussion)
    if v_sonder_feiertag = 'H' and not p_sal.kenz_urlaub then return; end if;

    -- Nur wenn kein Flex bereits berechnet (z.B. durch Urlaubskorrektur)
    if p_sal.day_flex_std != 0 then return; end if;

    p_sal.day_flex_std := p_sal.day_arb_std;
    p_sal.day_arb_std  := 0;
  end p_feiertag_korrigieren;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 9: Flex-Kappung anwenden
  -----------------------------------------------------------------------------------------------
  procedure p_flex_kappung_anwenden(
    p_ctx in     t_kontext,
    p_sal in out t_saldi
  ) is
  begin
    if p_sal.kenz_urlaub then return; end if;
    if nvl(p_ctx.kappung_te_ab_flx_std, 0) <= 0 then return; end if;

    if p_ctx.kappung_te_ab_flx_std
       < p_sal.day_flex_std + p_sal.day_arb_std - p_sal.day_reise_passiv_std
    then
      p_sal.day_flex_std := p_ctx.kappung_te_ab_flx_std
                            - p_sal.day_arb_std
                            + p_sal.day_reise_passiv_std;
    end if;
  end p_flex_kappung_anwenden;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 10: Rundung aller Saldi auf ganze Minuten
  -----------------------------------------------------------------------------------------------
  procedure p_saldi_runden(p_sal in out t_saldi) is
    function r(v in number) return number is begin return round(round(v * 60) / 60, 3); end;
  begin
    p_sal.day_abw_std      := r(p_sal.day_abw_std);
    p_sal.day_arb_std      := r(p_sal.day_arb_std);
    p_sal.day_ueb_std      := r(p_sal.day_ueb_std);
    p_sal.day_flex_std     := r(p_sal.day_flex_std);
    p_sal.day_anw_std      := r(p_sal.day_anw_std);
    p_sal.day_pause_std    := r(p_sal.day_pause_std);
    p_sal.day_pause_bez_std := r(p_sal.day_pause_bez_std);
  end p_saldi_runden;

  -----------------------------------------------------------------------------------------------
  -- Private Prozedur 11: Ergebnis speichern
  -----------------------------------------------------------------------------------------------
  procedure p_ergebnis_speichern(
    p_ctx in t_kontext,
    p_sal in t_saldi
  ) is
  begin
    update_tagessatz(
      p_ctx.pers_nr,
      p_ctx.schicht_datum,
      p_sal.day_calc_anw_start,
      p_sal.day_calc_anw_ende,
      p_sal.day_calc_start,
      p_sal.day_calc_ende,
      p_sal.day_sa_kurzname,
      p_sal.day_aa_status,
      p_sal.day_abw_std,
      p_sal.day_arb_std,
      p_sal.day_ueb_std,
      p_sal.day_flex_std,
      p_sal.day_anw_std,
      p_sal.day_pause_std,
      p_ctx.day_arb_std_guts_min,
      p_sal.day_pause_bez_std
    );

    if (p_sal.day_aa_status is not null or p_sal.day_anw_std > 0)
       and not p_sal.found_wiedereing
    then
      pzm_lohnauswertung.c_berechne_schichtzulagen(
        p_ctx.pers_nr,
        p_ctx.schicht_datum,
        p_sal.day_calc_anw_start,
        p_sal.day_calc_anw_ende,
        p_sal.day_sa_kurzname,
        p_ctx.kst_id
      );
    end if;

    commit;
  end p_ergebnis_speichern;

  -----------------------------------------------------------------------------------------------
  -- Oeffentliche Prozedur: c_berechnen
  -----------------------------------------------------------------------------------------------
  procedure c_berechnen(
    p_pers_nr  in  number,
    p_datum    in  date,
    p_result   out number,
    p_res_info out varchar2
  ) is
    v_ctx           t_kontext;
    v_sal           t_saldi;
    v_durchlauf     number := 0;
    v_neuberechnung boolean;
    v_schicht_datum date;

    v_found_not_closed boolean;
    v_found_invalid    boolean;
    v_invalid_anw_start date;
  begin
    p_result   := -1;
    p_res_info := 'Keine Stempelzeit gefunden, um den Tagessatz zu berechnen.';

    -- 1. Kontext laden (Personal- und Schichtdaten)
    if not p_kontext_laden(p_pers_nr, p_datum, v_ctx, p_result, p_res_info) then
      return;
    end if;
    v_schicht_datum := v_ctx.schicht_datum;

    -- 2. Automatische ZE-Eintraege loeschen (werden ggf. neu erzeugt)
    delete from pzm_zeiterfassung t
     where t.ze_schicht_tag = v_schicht_datum
       and t.ze_pers_nr     = p_pers_nr
       and t.ze_typ         = 'A'
       and t.ze_korr_pers_nr is null
       and t.ze_ist_start   is null
       and t.ze_ist_ende    is null;
    commit;

    -- 3. ZE-Eintraege validieren
    pzm_p_schicht_tag.c_schicht_tag_validieren(
      in_pers_nr          => p_pers_nr,
      io_schicht_datum    => v_schicht_datum,
      io_found_not_closed => v_found_not_closed,
      io_found_invalid    => v_found_invalid,
      out_day_sa_kurzname => v_sal.day_sa_kurzname,
      out_day_ist_start   => v_invalid_anw_start
    );

    -- Offene Stempelzeit
    if v_found_not_closed then
      update_tagessatz(p_pers_nr, v_schicht_datum,
                       v_invalid_anw_start, v_invalid_anw_start,
                       null, null, v_sal.day_sa_kurzname, null,
                       0, 0, 0, 0, 0, 0, 0, 0);
      pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum,
                                                   v_invalid_anw_start, v_invalid_anw_start,
                                                   v_sal.day_sa_kurzname, v_ctx.kst_id);
      p_result   := 0;
      p_res_info := 'Leeren Tagesatz angelegt';
      return;
    end if;

    -- Ungueltige / ueberlappende Daten
    if v_found_invalid then
      update_tagessatz(p_pers_nr, v_schicht_datum,
                       null, null, null, null, v_sal.day_sa_kurzname, null,
                       0, 0, 0, 0, 0, 0, 0, 0);
      pzm_lohnauswertung.c_berechne_schichtzulagen(p_pers_nr, v_schicht_datum,
                                                   null, null,
                                                   v_sal.day_sa_kurzname, v_ctx.kst_id);
      p_result   := 1;
      p_res_info := 'Ungueltigen oder ueberlappenden Eintrag in den Stempelzeiten gefunden.'
                    || ' Tagessatz konnte nicht berechnet werden.';
      return;
    end if;

    -- 4. Haupt-Berechnungsschleife (ersetzt Rekursion)
    loop
      v_durchlauf     := v_durchlauf + 1;
      v_neuberechnung := false;

      if v_durchlauf > c_max_durchlaeufe then
        raise PROGRAM_ERROR; -- Schutz gegen Endlosschleife
      end if;

      -- ZE-Eintraege akkumulieren
      p_ze_eintraege_akkumulieren(v_ctx, v_sal);

      if v_sal.day_calc_start is null then
        -- Kein einziger ZE-Eintrag gefunden -> Fehltag pruefen
        if pzm_p_schicht_tag.c_schicht_tag_fehltag_pruefen(p_pers_nr, v_schicht_datum) then
          -- Neue 'A'-Saetze angelegt, erneut akkumulieren
          continue;
        end if;
        -- Wirklich kein Tag vorhanden
        exit;
      end if;

      -- Schichtdaten ermitteln
      v_sal.sa_found := get_schicht_daten(
        p_pers_nr,
        v_sal.day_calc_start,
        v_schicht_datum,
        v_sal.day_sa_kurzname,
        v_sal.sa_beginn,
        v_sal.sa_ende,
        v_sal.sa_std_pro_tag
      ) = 1;

      if not v_sal.sa_found then exit; end if;

      if not pzm_p_base.get_schichtart_by_uix(v_sal.day_sa_kurzname, v_sal.schichtart) then
        v_sal.sa_found := false;
        exit;
      end if;

      -- Berechnung
      v_sal.day_anw_std  := round(v_sal.day_anw_std  * 60) / 60;
      v_sal.day_pause_std := round(v_sal.day_pause_std * 60) / 60;

      p_pausen_finalisieren(v_ctx, v_sal);

      v_sal.day_arb_std  := v_sal.day_anw_std - v_sal.day_pause_std;
      v_sal.day_ueb_std  := 0;
      v_sal.day_flex_std := 0;

      p_urlaub_korrigieren(v_sal);
      p_wiedereingliederung_pruefen(v_ctx, v_sal);

      if not v_sal.found_wiedereing then
        -- Fehlzeit-Luecken schliessen (ggf. neue 'A'-Saetze -> Neuberechnung)
        v_neuberechnung := p_fehlzeit_luecken_schliessen(v_ctx, v_sal, v_durchlauf);
        if v_neuberechnung and v_durchlauf <= 1 then
          continue; -- erneuter Durchlauf
        end if;
      end if;

      p_ueberstunden_berechnen(v_ctx, v_sal);
      p_feiertag_korrigieren(v_ctx, v_sal);
      p_saldi_runden(v_sal);
      p_flex_kappung_anwenden(v_ctx, v_sal);
      p_ergebnis_speichern(v_ctx, v_sal);

      p_result   := 0;
      p_res_info := 'Tagessatz erfolgreich berechnet.';
      exit;
    end loop;

    commit;
  end c_berechnen;

end PZM_P_TAGESSATZ;
/



-- sqlcl_snapshot {"hash":"","type":"PACKAGE_BODY","name":"PZM_P_TAGESSATZ","schemaName":"DIRKSPZM32","sxml":""}
