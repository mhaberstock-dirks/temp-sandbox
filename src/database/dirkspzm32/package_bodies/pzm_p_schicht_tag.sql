create or replace package body dirkspzm32.pzm_p_schicht_tag as
  /* Pr?fen, ob eine Kollision mit dem gegebenen Zeitraum existiert:
                     p_calc_ist_start                                            p_calc_ist_ende
                            v                                                          v
  -> T1 = ------------------x----------------------------------------------------------x-----------
                            |                                                          |
         ze_calc_ist_start  |                                                          |
                |         ze_calc_ist_ende                                             |
                v           |    v                                                     |
     T2 = ------x-----------|----x-----------------------------------------------------|-----------
     Kollision1             |----|                                                     |
                            |                                                          |
                            |                                                ze_calc_ist_start
                            |                                                       |  |ze_calc_ist_ende
                            |                                                       v  |       v
     T3 = ------------------|-------------------------------------------------------x--|-------x---
     Kollision2             |                                                       |--|
                            |                                                          |
                ze_calc_ist_start                                                    ze_calc_ist_ende
                       v    |                                                          |    v
     T4 = -------------x----|----------------------------------------------------------|----x------
     Kollision3        =====|----------------------------------------------------------|=====
                            |                                                          |
                         ze_calc_ist_start                               ze_calc_ist_ende
                            |   v                                               v      |
     T5 = ------------------|---x-----------------------------------------------x------|-----------
     Kollision4             |   |-----------------------------------------------|      |
                            |                                                          |

     Aufgabe:
      1. T2 ggf. k?rzen ...
      2. Wenn ENDE - START = 0 ergibt kann der Satz gel?scht werden, aber nur wenn es ein automatischer Eintrag
         ist, und eine undefinierte Abwesenheit als Status hat (ze_status = 0 AND ze_aa_status is NULL)
  */

  -- Konstanten
    const_ua_genehmigt constant number := 1;

  -- private (globale) Typen
    type t_commoncursorref is ref cursor;

  -----------------------------------------------------------------------------------------------
  -- Private Hilfsfunktionen
  -----------------------------------------------------------------------------------------------

    function check_resolve_ze_kollision (
        p_pers_nr        in pzm_zeiterfassung.ze_pers_nr%type,
        p_exclude_ze_id  in pzm_zeiterfassung.ze_id%type,
        p_schicht_tag    in pzm_zeiterfassung.ze_schicht_tag%type,
        p_calc_ist_start in pzm_zeiterfassung.ze_calc_ist_start%type,
        p_calc_ist_ende  in pzm_zeiterfassung.ze_calc_ist_ende%type,
        p_ze_status      in pzm_zeiterfassung.ze_status%type,
        p_ze_aa_status   in pzm_zeiterfassung.ze_aa_status%type,
        p_ze_typ         in pzm_zeiterfassung.ze_typ%type
    ) return pzm_zeiterfassung.ze_id%type is

        v_newkollisionstart      date;
        v_newkollisionende       date;
        v_kollisionsatz          pzm_zeiterfassung%rowtype;
        v_anwesenhsatz           pzm_zeiterfassung%rowtype;
        v_schichtmodell          pzm_schicht_modelle%rowtype;
        v_def_aa_id              number;
        v_schicht_tag            date;
        v_calc_ist_start         date;
        v_prev_anwesenheit_found boolean;
        v_kollision_ze_id        pzm_zeiterfassung.ze_id%type;
        cursor c_check_prev_anwesenheit is
        select
            t.*
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = p_pers_nr
            and t.ze_schicht_tag = v_schicht_tag
            and t.ze_status = pzm_p_zeiterfassung.status_anwesend
            and t.ze_calc_ist_start < v_calc_ist_start;

        cursor c_zekollision is
        select
            t.*
        from
            pzm_zeiterfassung t
        where
                ze_pers_nr = p_pers_nr
            and ze_id <> p_exclude_ze_id
            and ( ( ze_calc_ist_start is not null
                    and ze_calc_ist_ende is not null ) -- damit fallen offene Eintr?ge weg
                  and ( p_calc_ist_ende <> p_calc_ist_start
                        and ze_calc_ist_ende <> ze_calc_ist_start )
                  and ( ( ze_calc_ist_start <= p_calc_ist_start
                          and ze_calc_ist_ende > p_calc_ist_start ) -- Kollision1
                        or ( ze_calc_ist_start < p_calc_ist_ende
                             and ze_calc_ist_ende >= p_calc_ist_ende )   -- Kollision2
                        or ( ze_calc_ist_start <= p_calc_ist_start
                             and ze_calc_ist_ende >= p_calc_ist_ende ) -- Kollision3
                        or ( ze_calc_ist_start >= p_calc_ist_start
                             and ze_calc_ist_ende <= p_calc_ist_ende ) -- Kollision4
                              ) )
            and ( t.ze_schicht_tag = p_schicht_tag
                  or t.ze_aa_status is null )
        order by
            ze_calc_ist_start;

    begin
        if pzm_p_base.get_schicht_modell(p_pers_nr, v_schichtmodell) then
            if v_schichtmodell.standard_aa_id is not null then
        -- wenn das Schichtmodell eine Standard Abweseheit definiert,
        -- wird diese genommen
                v_def_aa_id := v_schichtmodell.standard_aa_id;
            end if;
        end if;

        v_kollision_ze_id := null;
        open c_zekollision;
        loop
            fetch c_zekollision into v_kollisionsatz;
            exit when c_zekollision%notfound;

      -- erstmal Kollision merken
            v_kollision_ze_id := v_kollisionsatz.ze_id;
            if
                p_ze_typ = pzm_p_zeiterfassung.typ_auto
                and ( p_ze_status = pzm_p_zeiterfassung.status_abwesend
                or p_ze_status = pzm_p_zeiterfassung.status_feiertag )   --DKr 20190704 W20310-373
                and ( p_ze_aa_status is null
                      or p_ze_aa_status = v_def_aa_id )
            then
                if /* Kollision 1 */
                    v_kollisionsatz.ze_calc_ist_start <= p_calc_ist_start
                    and v_kollisionsatz.ze_calc_ist_ende > p_calc_ist_start
                then
                    v_newkollisionstart := v_kollisionsatz.ze_calc_ist_ende;
                    v_newkollisionende := v_kollisionsatz.ze_calc_ist_ende + ( p_calc_ist_ende - p_calc_ist_start );  -- MWe 20170522 hinzugef?gt

                    if ( v_newkollisionende - v_newkollisionstart ) = 0 then
                        delete from pzm_zeiterfassung
                        where
                            ze_id = p_exclude_ze_id;

                        v_kollision_ze_id := -1;
                    else
                        update pzm_zeiterfassung
                        set
                            ze_calc_ist_start = v_newkollisionstart,
                            ze_calc_ist_ende = v_newkollisionende,  -- MWe 20170522 hinzugef?gt
                            ze_korr_pers_nr = null,
                            ze_korr_datum = null
                        where
                            ze_id = p_exclude_ze_id;

                        v_kollision_ze_id := -1;
                    end if;

                elsif /* Kollision 2 */ (
                    v_kollisionsatz.ze_calc_ist_start < p_calc_ist_ende
                    and v_kollisionsatz.ze_calc_ist_ende >= p_calc_ist_ende
                )
                or
              /* Kollision 4 */ (
                    v_kollisionsatz.ze_calc_ist_start >= p_calc_ist_start
                    and v_kollisionsatz.ze_calc_ist_ende <= p_calc_ist_ende
                ) then
          --
                    v_newkollisionstart := p_calc_ist_start;
                    v_newkollisionende := v_kollisionsatz.ze_calc_ist_start;
                    if ( v_newkollisionende - v_newkollisionstart ) = 0 then
                        delete from pzm_zeiterfassung
                        where
                            ze_id = p_exclude_ze_id;

                        v_kollision_ze_id := -1;
                    else
            -- Das Ende des Kollisionssatzes auf den Anfang des aktuellen Satzes setzen.
                        v_schicht_tag := p_schicht_tag;
                        v_calc_ist_start := p_calc_ist_start;
                        open c_check_prev_anwesenheit;
                        fetch c_check_prev_anwesenheit into v_anwesenhsatz;
                        v_prev_anwesenheit_found := c_check_prev_anwesenheit%found;
                        close c_check_prev_anwesenheit;
                        if
                            p_ze_status = pzm_p_zeiterfassung.status_abwesend
                            and v_prev_anwesenheit_found -- prev. presence
                            and v_kollisionsatz.ze_status = pzm_p_zeiterfassung.status_anwesend
                        then
                            update pzm_zeiterfassung t
                            set
                                t.ze_calc_ist_ende = v_newkollisionende,
                                t.ze_korr_pers_nr = null,
                                t.ze_korr_datum = null,
                                t.ze_status = pzm_p_zeiterfassung.status_pause,
                                t.ze_aa_status = null
                            where
                                ze_id = p_exclude_ze_id;

                        else
                            update pzm_zeiterfassung
                            set
                                ze_calc_ist_ende = v_newkollisionende,
                                ze_korr_pers_nr = null,
                                ze_korr_datum = null
                            where
                                ze_id = p_exclude_ze_id;

                        end if;

                        v_kollision_ze_id := -1;
                    end if;

                elsif /* Kollision 3 */
                    v_kollisionsatz.ze_calc_ist_start <= p_calc_ist_start
                    and v_kollisionsatz.ze_calc_ist_ende >= p_calc_ist_ende
                then
          --
                    delete from pzm_zeiterfassung
                    where
                        ze_id = p_exclude_ze_id;

                    v_kollision_ze_id := -1;
                end if;
            end if;

            if
                v_kollisionsatz.ze_typ = pzm_p_zeiterfassung.typ_auto
                and ( v_kollisionsatz.ze_status = pzm_p_zeiterfassung.status_abwesend
                or v_kollisionsatz.ze_status = pzm_p_zeiterfassung.status_feiertag )   --DKr 20190704 W20310-373
                and ( v_kollisionsatz.ze_aa_status is null
                      or v_kollisionsatz.ze_aa_status = v_def_aa_id )
            then
        /* Kollision 1 un 3 **************************************************/
                if
                    v_kollisionsatz.ze_calc_ist_start <= p_calc_ist_start
                    and ( v_kollisionsatz.ze_calc_ist_ende > p_calc_ist_start
                    or v_kollisionsatz.ze_calc_ist_ende >= p_calc_ist_ende )
                then
          -- 1. und 3. Kollision trifft zu
                    v_newkollisionende := p_calc_ist_start;
                    if ( v_newkollisionende - v_kollisionsatz.ze_calc_ist_start ) = 0 then
                        delete from pzm_zeiterfassung
                        where
                            ze_id = v_kollisionsatz.ze_id;

                        v_kollision_ze_id := -1;
                    else
            -- Das Ende des Kollisionssatzes auf den Anfang des aktuellen Satzes setzen.
                        v_schicht_tag := v_kollisionsatz.ze_schicht_tag;
                        v_calc_ist_start := v_kollisionsatz.ze_calc_ist_start;
                        open c_check_prev_anwesenheit;
                        fetch c_check_prev_anwesenheit into v_anwesenhsatz;
                        v_prev_anwesenheit_found := c_check_prev_anwesenheit%found;
                        close c_check_prev_anwesenheit;
                        if
                            v_kollisionsatz.ze_status = pzm_p_zeiterfassung.status_abwesend
                            and v_prev_anwesenheit_found -- prev. presence
                            and p_ze_status = pzm_p_zeiterfassung.status_anwesend
                        then
                            update pzm_zeiterfassung t
                            set
                                t.ze_calc_ist_ende = v_newkollisionende,
                                t.ze_korr_pers_nr = null,
                                t.ze_korr_datum = null,
                                t.ze_status = pzm_p_zeiterfassung.status_pause,
                                t.ze_aa_status = null
                            where
                                ze_id = v_kollisionsatz.ze_id;

                        else
                            update pzm_zeiterfassung t
                            set
                                t.ze_calc_ist_ende = v_newkollisionende,
                                t.ze_korr_pers_nr = null,
                                t.ze_korr_datum = null
                            where
                                ze_id = v_kollisionsatz.ze_id;

                        end if;

                        v_kollision_ze_id := -1;
                    end if;
        /* Kollision 2 *******************************************************/
                elsif
                    v_kollisionsatz.ze_calc_ist_start < p_calc_ist_ende
                    and v_kollisionsatz.ze_calc_ist_ende >= p_calc_ist_ende
                then
          -- 2. Kollision trifft zu
                    v_newkollisionstart := p_calc_ist_ende;
                    v_newkollisionende := v_newkollisionstart + v_schichtmodell.d_arb_std_pro_tag / 24;    -- MWe Add: 20180528 Ticket:P70074-31 Korrektur Schichtende
                    if ( v_kollisionsatz.ze_calc_ist_ende - v_newkollisionstart ) = 0 then
                        delete from pzm_zeiterfassung
                        where
                            ze_id = v_kollisionsatz.ze_id;

                        v_kollision_ze_id := -1;
                    else
            -- Den Anfang des Kollisionssatzes auf das Ende des aktuellen Satzes setzen.
                        update pzm_zeiterfassung
                        set
                            ze_calc_ist_start = v_newkollisionstart,
                            ze_calc_ist_ende = v_newkollisionende,                        -- MWe Add: 20180528 Ticket:P70074-31 Korrektur Schichtende
                            ze_korr_pers_nr = null,
                            ze_korr_datum = null
                        where
                            ze_id = v_kollisionsatz.ze_id;

                        v_kollision_ze_id := -1;
                    end if;
        /* Kollision 4 *******************************************************/
                elsif
                    v_kollisionsatz.ze_calc_ist_start < p_calc_ist_ende
                    and v_kollisionsatz.ze_calc_ist_ende >= p_calc_ist_ende
                then
          -- 4. Kollision trifft zu
                    delete from pzm_zeiterfassung
                    where
                        ze_id = v_kollisionsatz.ze_id;

                    v_kollision_ze_id := -1;
                end if;
            end if;

            exit when v_kollision_ze_id is not null;
        end loop;

        close c_zekollision;
        return v_kollision_ze_id;
    end;

    procedure get_country_and_region_code (
        in_pers_nr      in pzm_personal.pers_nr%type,
        in_kst_id       in pzm_personal.pers_kst_id%type,
        in_abt_id       in pzm_abteilungen.abt_id%type,
        in_pb_id        in pzm_produktionsbereiche.pb_id%type,
        out_country     out varchar2,
        out_region_code out varchar2
    ) is

        v_country            varchar2(40 char);
        v_region_code        varchar2(40 char);
        v_country_nested     varchar2(40 char);
        v_region_code_nested varchar2(40 char);
        v_kst_id             pzm_personal.pers_kst_id%type;
        v_abt_id             pzm_abteilungen.abt_id%type;
        v_pb_id              pzm_produktionsbereiche.pb_id%type;
    begin
        select
            p.pers_land,
            p.pers_region_code,
            p.pers_kst_id,
            p.pers_abt_id,
            p.pers_pb_id
        into
            v_country,
            v_region_code,
            v_kst_id,
            v_abt_id,
            v_pb_id
        from
            pzm_personal p
        where
            p.pers_nr = in_pers_nr;

        if v_country is null
           or v_region_code is null then
      -- Kostenstelle: 2. Rang
            v_kst_id := nvl(in_kst_id,
                            nvl(v_kst_id,
                                get_pers_kst_id(in_pers_nr)));
            select
                akst.land_kurz,
                akst.region_code
            into
                v_country_nested,
                v_region_code_nested
            from
                isi_kostenstellen kst
                left outer join isi_adressen      akst on akst.adress_id = kst.kst_adress_id
            where
                kst.kst_nr = v_kst_id;

            v_country := nvl(v_country, v_country_nested);
            v_region_code := nvl(v_region_code, v_region_code_nested);
        end if;

        if v_country is null
           or v_region_code is null then
      -- Abteilung: 3. Rang
            v_abt_id := nvl(in_abt_id,
                            nvl(v_abt_id,
                                get_pers_abt_id(in_pers_nr)));
            select
                aabt.land_kurz,
                aabt.region_code
            into
                v_country_nested,
                v_region_code_nested
            from
                pzm_abteilungen abt
                left outer join isi_adressen    aabt on aabt.adress_id = abt.abt_adress_id
            where
                abt.abt_id = v_abt_id;

            v_country := nvl(v_country, v_country_nested);
            v_region_code := nvl(v_region_code, v_region_code_nested);
        end if;

        if v_country is null
           or v_region_code is null then
      -- PZM Mandant/Produktionsbereich: 4. Rang
            v_pb_id := nvl(in_pb_id,
                           nvl(v_pb_id,
                               get_pers_pb_id(in_pers_nr)));
            select
                apb.land_kurz,
                apb.region_code
            into
                v_country_nested,
                v_region_code_nested
            from
                pzm_produktionsbereiche pb
                left outer join isi_adressen            apb on apb.adress_id = pb.pb_adress_id
            where
                pb.pb_id = v_pb_id;

            v_country := nvl(v_country, v_country_nested);
            v_region_code := nvl(v_region_code, v_region_code_nested);
        end if;

        if v_country is null
           or v_region_code is null then
      -- DB/Tenant: 5. Rang
            select
                t.land_kurz,
                t.region_code
            into
                v_country_nested,
                v_region_code_nested
            from
                isi_adressen t
            where
                    t.adr_art = 'E'
                and t.adr_nr = 1
                and t.adr_liefer = 0;

            v_country := nvl(v_country, v_country_nested);
            v_region_code := nvl(v_region_code, v_region_code_nested);
        end if;

        out_country := v_country;
        out_region_code := v_region_code;
    end;

  -----------------------------------------------------------------------------------------------
  -- ?ffentliche Funktionen: Hilfsfunktionen
  -----------------------------------------------------------------------------------------------

    function ist_feiertag_fuer_pers (
        in_datum   in date,
        in_pers_nr in pzm_personal.pers_nr%type,
        in_abt_id  in pzm_abteilungen.abt_id%type default null,
        in_pb_id   in pzm_produktionsbereiche.pb_id%type default null,
        in_kst_id  in pzm_personal.pers_kst_id%type default null
    ) return boolean is
        v_country     varchar2(40 char);
        v_region_code varchar2(40 char);
    begin
        get_country_and_region_code(in_pers_nr, in_kst_id, in_abt_id, in_pb_id, v_country,
                                    v_region_code);
        return ist_feiertag(in_datum, v_country, v_region_code);
    end;

    function ist_feiertag_fuer_pers_legacy_sf (
        in_datum               in date,
        in_pers_nr             in pzm_personal.pers_nr%type,
        out_sonder_feiertag_kz out varchar2
    ) return boolean is
        v_country     varchar2(40 char);
        v_region_code varchar2(40 char);
        v_feiertag    isi_feiertage%rowtype;
    begin
        get_country_and_region_code(in_pers_nr, null, null, null, v_country,
                                    v_region_code);
        v_feiertag := get_feiertag(in_datum, v_country, v_region_code);
        out_sonder_feiertag_kz := v_feiertag.f_sonder_feiertag;
        return v_feiertag.f_name is not null;
    end;

    function get_feiertag_fuer_pers (
        in_datum   in date,
        in_pers_nr in pzm_personal.pers_nr%type,
        in_abt_id  in pzm_abteilungen.abt_id%type default null,
        in_pb_id   in pzm_produktionsbereiche.pb_id%type default null,
        in_kst_id  in pzm_personal.pers_kst_id%type default null
    ) return isi_feiertage%rowtype is
        v_country     varchar2(40 char);
        v_region_code varchar2(40 char);
        v_feiertag    isi_feiertage%rowtype;
    begin
        get_country_and_region_code(in_pers_nr, in_kst_id, in_abt_id, in_pb_id, v_country,
                                    v_region_code);
        v_feiertag := get_feiertag(in_datum, v_country, v_region_code);
        return v_feiertag;
    end;

    function get_feiertag_kennz_fuer_pers (
        in_datum   in date,
        in_pers_nr in pzm_personal.pers_nr%type,
        in_abt_id  in pzm_abteilungen.abt_id%type default null,
        in_pb_id   in pzm_produktionsbereiche.pb_id%type default null,
        in_kst_id  in pzm_personal.pers_kst_id%type default null
    ) return varchar2 is
        v_country     varchar2(40 char);
        v_region_code varchar2(40 char);
        v_feiertag    isi_feiertage%rowtype;
    begin
        get_country_and_region_code(in_pers_nr, in_kst_id, in_abt_id, in_pb_id, v_country,
                                    v_region_code);
        v_feiertag := get_feiertag(in_datum, v_country, v_region_code);
        if ( v_feiertag.f_sonder_feiertag is null )
        or v_feiertag.f_sonder_feiertag = 'N' then
            return ''; -- leer als Kennz.
        else
            return v_feiertag.f_sonder_feiertag;
        end if;

    end;

    function ist_feiertag (
        in_datum       in date,
        in_country     in varchar2,
        in_region_code in varchar2 default null
    ) return boolean is
        v_feiertag isi_feiertage%rowtype;
    begin
        v_feiertag := get_feiertag(in_datum, in_country, in_region_code);
        return v_feiertag.f_name is not null;
    end;

    function get_feiertag (
        in_datum       in date,
        in_country     in varchar2,
        in_region_code in varchar2 default null
    ) return isi_feiertage%rowtype is

        v_feiertag isi_feiertage%rowtype;
        cursor c_feiertag is
        select
            f.*
        from
            isi_feiertage                               f,
            table ( strsplit(f.region_codes_csv, ';') ) rc
        where
                f.f_datum = trunc(in_datum)
            and f.f_country = in_country
            and nvl(in_region_code, rc.column_value) like rc.column_value || '%'
        order by
            f_datum
        fetch first 1 row only;

    begin
        open c_feiertag;
        fetch c_feiertag into v_feiertag;
        close c_feiertag;
        return v_feiertag;
    end;

  -----------------------------------------------------------------------------------------------
  -- Ermittelt wie viele Schichttage im Zeitraum sind ohne berücksichtigung von Urlaub, Krank oder Feiertagen.
  -----------------------------------------------------------------------------------------------
    function get_anz_schicht_tage (
        in_pers_nr           in pzm_personal.pers_nr%type,
        in_von_schicht_datum in pzm_zeiterfassung.ze_schicht_tag%type,
        in_bis_schicht_datum in pzm_zeiterfassung.ze_schicht_tag%type
    ) return integer is

        v_schicht_datum   pzm_zeiterfassung.ze_schicht_tag%type;
        v_personal        pzm_personal%rowtype;

    -- Schichtdaten (bereits umgerechnet auf den Schichttag)
        v_safound         boolean;
        v_daysakurzname   pzm_schichtarten.sa_kurzname%type;
        v_sabeginn        pzm_schichtarten.sa_beginn%type;
        v_saende          pzm_schichtarten.sa_ende%type;
        v_sastdprotag     number;
        v_saanztage       number;
        v_schichtart      pzm_schichtarten%rowtype;
        v_def_sa_kurzname pzm_schichtarten.sa_kurzname%type;
        v_found           boolean;
        cursor c_pers is
        select
            t.*
        from
            pzm_personal t
        where
            t.pers_nr = in_pers_nr;

    begin
        v_schicht_datum := in_von_schicht_datum; -- in lokale variable uebernehmen wegen io parameter

        open c_pers;
        fetch c_pers into v_personal;
        v_found := c_pers%found;
        close c_pers;
        if not v_found then
            return ( 0 );
        end if;

    -- 1. Fuer die Ermittlung muss der Mitarbeiter auch "aktiv" beschaeftigt sein.
        if v_schicht_datum > v_personal.pers_austrittdatum then
            return 0;
        end if;
        v_def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(in_pers_nr);
        v_saanztage := 0;
        loop
            exit when v_schicht_datum > v_personal.pers_austrittdatum 
            -- or v_schicht_datum >=  trunc(sysdate)
            or v_schicht_datum > in_bis_schicht_datum;
            if v_schicht_datum >= v_personal.pers_eintrittsdatum then
        -- 2. Anhand der Schichtmodelle pruefen, ob an diesem Tag gearbeitet werden sollte

                v_daysakurzname := null;
                v_safound := get_schicht_daten(in_pers_nr, v_schicht_datum, v_schicht_datum, v_daysakurzname, v_sabeginn,
                                               v_saende, v_sastdprotag) = 1;

                if
                    v_safound
                    and ( v_daysakurzname <> v_def_sa_kurzname ) -- Keine Überstundenschicht
                    and pzm_p_base.get_schichtart_by_uix(v_daysakurzname, v_schichtart)
                then
                    if v_schichtart.sa_std_pro_tag > 0 then
            -- **** An diesem Datum musste gearbeitet werden
                        v_saanztage := v_saanztage + 1;
                    end if;
                end if;

            end if;

            v_schicht_datum := v_schicht_datum + 1;
        end loop;

        return v_saanztage;
    end;

  -----------------------------------------------------------------------------------------------
  -- ?ffentliche API: Hauptfunktionen
  -----------------------------------------------------------------------------------------------

    procedure c_schicht_tag_validieren (
        in_pers_nr          in pzm_personal.pers_nr%type,
        io_schicht_datum    in out pzm_zeiterfassung.ze_schicht_tag%type,
        io_found_not_closed in out boolean,
        io_found_invalid    in out boolean,
        out_day_sa_kurzname out pzm_zeiterfassung.ze_sa_kurzname%type,
        out_day_ist_start   out pzm_zeiterfassung.ze_ist_start%type
    ) is

        cursor c_checkzetag is
        select
            t.*
        from
            pzm_zeiterfassung t
        where
                t.ze_pers_nr = in_pers_nr
            and t.ze_schicht_tag = io_schicht_datum
        order by
            t.ze_calc_ist_start,
            t.ze_id; -- chronologisch sortieren
        v_ze_id            pzm_zeiterfassung.ze_id%type;
        v_currzecheckrow   pzm_zeiterfassung%rowtype;
        v_prevzecheckrow   pzm_zeiterfassung%rowtype;
        v_prevzecheck      boolean;
        v_kollisionid      pzm_zeiterfassung.ze_id%type;
        v_curr_prev_luecke number; -- L?ckengr??e zwischen zwei Zeiteintr?gen (ist in der Regel 0)
        v_exit_loop        boolean;
        v_def_aa_id        pzm_abwesenheitsarten.aa_id%type;
        v_def_sa_kurzname  pzm_schichtarten.sa_kurzname%type;
        v_restart_check    boolean;

    -- Schichtdaten (bereits umgerechnet auf den Schichttag)
        v_safound          boolean;
        v_sabeginn         date;
        v_saende           date;
        v_sastdprotag      number;
        v_schichtmodell    pzm_schicht_modelle%rowtype;
    begin
        io_found_not_closed := false;
        io_found_invalid := false;
        v_def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(in_pers_nr);
        v_def_aa_id := null;
        if pzm_p_base.get_schicht_modell(in_pers_nr, v_schichtmodell) then
            if v_schichtmodell.standard_aa_id is not null then
        -- wenn das Schichtmodell eine Standard Abweseheit definiert,
        -- wird diese genommen
                v_def_aa_id := v_schichtmodell.standard_aa_id;
            end if;
        end if;

    /* s?mtliche G?ltigkeitspr?fungen */
        loop
            v_restart_check := false;
            open c_checkzetag;
            v_prevzecheckrow := null;
            v_prevzecheck := false;
            loop
                fetch c_checkzetag into v_currzecheckrow;
                exit when c_checkzetag%notfound;
                if
                    v_currzecheckrow.ze_status = pzm_p_zeiterfassung.status_anwesend
                    and v_currzecheckrow.ze_std < 0 -- negative Anwesenheit ist falsch!
                then
                    io_found_invalid := true;
                    exit; -- innere Schleife verlassen!!
                end if;

        -- Wenn keine Ende-Stempelung da ist, haben wir einen offenen Status
                io_found_not_closed :=
                    v_currzecheckrow.ze_ist_ende is null
                    and v_currzecheckrow.ze_ist_start is not null
                    and v_currzecheckrow.ze_calc_ist_ende is null;

                if io_found_not_closed then
                    if out_day_ist_start is null then
            -- erster Eintrag mit einer Spempelzeit
                        out_day_ist_start := v_currzecheckrow.ze_ist_start;
                    end if;
                    exit; -- innere Schleife verlassen!!
                end if;

        /* Kollisionspr?fung / Korrektur */
                v_kollisionid := check_resolve_ze_kollision(in_pers_nr, v_currzecheckrow.ze_id, v_currzecheckrow.ze_schicht_tag, v_currzecheckrow.ze_calc_ist_start
                , v_currzecheckrow.ze_calc_ist_ende,
                                                            v_currzecheckrow.ze_status, v_currzecheckrow.ze_aa_status, v_currzecheckrow.ze_typ
                                                            );

                if v_kollisionid is not null then
                    if v_kollisionid = -1 then
                        v_restart_check := true;
                    else
                        io_found_invalid := true;
                    end if;

                    exit; -- innere Schleife verlassen!!
                end if;

        /* L?ckenpr?fung */
                if v_prevzecheck then
                    v_curr_prev_luecke := ( v_currzecheckrow.ze_calc_ist_start - v_prevzecheckrow.ze_calc_ist_ende ) * 24; -- in Stunden

                    out_day_sa_kurzname := v_prevzecheckrow.ze_sa_kurzname;
                    v_safound := get_schicht_daten(in_pers_nr, v_prevzecheckrow.ze_calc_ist_start, io_schicht_datum, out_day_sa_kurzname
                    , v_sabeginn,
                                                   v_saende, v_sastdprotag) = 1;

                    if
                        v_safound
                        and ( v_curr_prev_luecke ) > 0
                        and v_curr_prev_luecke < v_sastdprotag
                        and out_day_sa_kurzname != v_def_sa_kurzname
                        and v_sastdprotag > 0
                    then
            -- L?cke vorhanden
                        if
                            v_prevzecheckrow.ze_typ = pzm_p_zeiterfassung.typ_auto
                            and v_prevzecheckrow.ze_status = pzm_p_zeiterfassung.status_abwesend
                            and ( v_prevzecheckrow.ze_aa_status is null
                                  or v_prevzecheckrow.ze_aa_status = v_def_aa_id )
                        then
              /* Wenn die M?glichkeit besteht, das Ende des vorherigen Satzes zu ver?ndern,
               * dann setzen wir das Ende auf den Anfang vom aktuellen Satz und schliessen somit die L?cke.
               */
                            update pzm_zeiterfassung
                            set
                                ze_calc_ist_ende = v_currzecheckrow.ze_calc_ist_start
                            where
                                ze_id = v_prevzecheckrow.ze_id;

                            v_restart_check := true;
                        elsif (
                            v_currzecheckrow.ze_typ = pzm_p_zeiterfassung.typ_auto
                            and v_currzecheckrow.ze_status = pzm_p_zeiterfassung.status_abwesend
                            and ( v_currzecheckrow.ze_aa_status is null
                                  or v_prevzecheckrow.ze_aa_status = v_def_aa_id )
                        )
                        or (
                            v_prevzecheckrow.ze_status = pzm_p_zeiterfassung.status_dienstgang
                            and v_currzecheckrow.ze_status = pzm_p_zeiterfassung.status_anwesend
                            and v_prevzecheckrow.ze_ist_ende = v_currzecheckrow.ze_ist_start
                        ) then
              /* Wenn die M?glichkeit besteht, Anfang Ende des aktuellen Satzes zu ver?ndern,
               * dann setzen wir den Anfang auf das Ende vom vorherigen Satz und schliessen somit die L?cke.
               */
                            update pzm_zeiterfassung
                            set
                                ze_calc_ist_start = v_prevzecheckrow.ze_calc_ist_ende
                            where
                                ze_id = v_currzecheckrow.ze_id;

                            v_restart_check := true;
                            if
                                v_currzecheckrow.ze_status = pzm_p_zeiterfassung.status_anwesend
                                and v_currzecheckrow.ze_ist_start = v_currzecheckrow.ze_ist_ende
                            then
                                update pzm_zeiterfassung
                                set
                                    ze_calc_ist_ende = ze_calc_ist_start
                                where
                                    ze_id = v_currzecheckrow.ze_id;

                            end if;

                        elsif
                            v_currzecheckrow.ze_status = pzm_p_zeiterfassung.status_anwesend
                            and v_prevzecheckrow.ze_status = pzm_p_zeiterfassung.status_anwesend
                        then
              /* zwischen 2 Anwesenheiten f?llen wir die L?cke mit einer Pause */
                            v_ze_id := pzm_p_zeiterfassung.c_automatische_pause_eintragen(
                                in_pers_nr     => in_pers_nr,
                                in_schicht_tag => io_schicht_datum,
                                in_sa_kurzname => v_prevzecheckrow.ze_sa_kurzname,
                                in_pause_start => v_prevzecheckrow.ze_calc_ist_ende,
                                in_pause_ende  => v_currzecheckrow.ze_calc_ist_start
                            );
                        else
              /* Wenn an den Eintr?gen nicht zu r?tteln ist, f?llen wir
               * die L?cke mit einer Abwesenheit
               */
                            v_ze_id := pzm_p_zeiterfassung.c_automatische_fehlzeit_eintragen(
                                in_pers_nr        => in_pers_nr,
                                in_schicht_tag    => io_schicht_datum,
                                in_aa_id          => v_def_aa_id,
                                in_sa_kurzname    => v_prevzecheckrow.ze_sa_kurzname,
                                in_fehlzeit_start => v_prevzecheckrow.ze_calc_ist_ende,
                                in_fehlzeit_ende  => v_currzecheckrow.ze_calc_ist_start
                            );
                        end if;
                    end if;

                end if;

                v_prevzecheckrow := v_currzecheckrow;
                v_prevzecheck := true;
            end loop;

            v_exit_loop := c_checkzetag%notfound
            or io_found_not_closed
            or io_found_invalid
            or not v_restart_check;
            close c_checkzetag;
            commit;
            exit when v_exit_loop;
        end loop;

    end;

    function c_schicht_tag_fehltag_pruefen (
        in_pers_nr       in pzm_personal.pers_nr%type,
        in_schicht_datum in pzm_zeiterfassung.ze_schicht_tag%type
    ) return boolean is

        v_schicht_datum         pzm_zeiterfassung.ze_schicht_tag%type;
        v_ze_id                 pzm_zeiterfassung.ze_id%type;
        v_personal              pzm_personal%rowtype;
        v_vertragsart           pzm_vertragsarten%rowtype;

    -- Schichtdaten (bereits umgerechnet auf den Schichttag)
        v_safound               boolean;
        v_daysakurzname         pzm_schichtarten.sa_kurzname%type;
        v_sabeginn              pzm_schichtarten.sa_beginn%type;
        v_saende                pzm_schichtarten.sa_ende%type;
        v_sastdprotag           number;
        v_schichtart            pzm_schichtarten%rowtype;
        v_abwes_art             pzm_abwesenheitsarten%rowtype;
        v_lohnarten             pzm_lohnarten%rowtype;
        v_feiertag              isi_feiertage%rowtype;
        v_km_sa_kurzname        pzm_schichtarten.sa_kurzname%type;
        v_km_sa_beginn          pzm_schichtarten.sa_beginn%type;
        v_km_sa_ende            pzm_schichtarten.sa_ende%type;
        v_km_sa_std_p_tag       pzm_schichtarten.sa_std_pro_tag%type;
        v_def_sa_kurzname       pzm_schichtarten.sa_kurzname%type;
        v_status                number;
        v_dayaastatus           number;
        v_halber_tag_urlaub     boolean;
        c_abwesenheits_antr     t_commoncursorref;
        v_abwesenheits_antr     pzm_abwesenheits_antr%rowtype;
        c_abwesenheitsmeldungen t_commoncursorref;
        v_abwesenheitsmeldungen pzm_abwesenheitsmeldungen%rowtype;
        v_schichtmodell         pzm_schicht_modelle%rowtype;
        v_found                 boolean;
        v_result                boolean;
        cursor c_loa_kugf is
        select
            *
        from
            pzm_lohnarten lz
        where
                lz.lz_operator = 'KUGF'               -- Kurzarbeit Feiertag
            and nvl(lz.lz_gueltig_ab, in_schicht_datum) >= in_schicht_datum
            and nvl(lz.lz_gueltig_bis,
                    last_day(in_schicht_datum)) <= last_day(in_schicht_datum);

        cursor c_abwesenheiten_lz_id is
        select
            *
        from
            pzm_abwesenheitsarten a
        where
            a.lz_id = v_lohnarten.lz_id;

        cursor c_abwesenheiten_anw is
        select
            *
        from
            pzm_abwesenheitsarten a
        where
            a.aa_kurzname = 'anw';

        cursor c_pers is
        select
            t.*
        from
            pzm_personal t
        where
            t.pers_nr = in_pers_nr;

        cursor c_vertragsart is
        select
            pv.*
        from
            pzm_vertragsarten pv
        where
            pv.va_id = v_personal.pers_vertragsart;

    begin
        v_result := false;
    -- kein Eintrag an diesem Tag vorhanden
    -- wir muessen pruefen, ob der Mitarbeiter evtl. im genehmigten Urlaub ist ...

        v_schicht_datum := in_schicht_datum; -- in lokale variable uebernehmen wegen io parameter
    -- 1. Tagessatz fuer diesen Tag loeschen -> wird neu berechnet und erzeugt
    -- TODO: -wkr- 2026-02-11, vielleicht lieber der vorhandenen TS aktualisieren
        delete pzm_ze_tagessatz t
        where
                t.ts_pers_nr = in_pers_nr
            and t.ts_datum = v_schicht_datum;

    -- 2. alle Lohnauswerungen fuer diesen Tag loeschen,
    -- da keine Stempelzeit vorhanden ist und Tagessatz ggf. inkorerkt ist
        delete pzm_ze_loa_ausw t
        where
                t.zeaw_pers_nr = in_pers_nr
            and t.zeaw_datum = v_schicht_datum;

        open c_pers;
        fetch c_pers into v_personal;
        v_found := c_pers%found;
        close c_pers;
        if not v_found then
            return ( false );
        end if;
        v_halber_tag_urlaub := false;

    -- Fuer die Fehlzeitermittlung muss der Mitarbeiter auch "aktiv" beschaeftigt sein.
        if v_schicht_datum > v_personal.pers_austrittdatum
        or v_schicht_datum < v_personal.pers_eintrittsdatum then
            return false;
        end if;

        v_def_sa_kurzname := pzm_utils.get_standard_schicht_by_pers_nr(in_pers_nr);

    -- 2.1 Default SchichtEnde
        v_daysakurzname := null;
        v_safound := get_schicht_daten(in_pers_nr, v_schicht_datum, v_schicht_datum, v_daysakurzname, v_sabeginn,
                                       v_saende, v_sastdprotag) = 1;

        if pzm_p_base.get_schichtart_by_uix(v_daysakurzname, v_schichtart) then
            if v_schichtart.calc_basis = 'GLEITZ' then
                v_sabeginn := trunc(v_sabeginn) + fraction_of_day(v_schichtart.sa_beginn);
                v_saende := v_sabeginn + v_schichtart.sa_std_pro_tag / 24;
            end if;
        end if;

        v_saende := v_sabeginn + v_schichtart.sa_std_pro_tag / 24;

    -- 3. Anhand der Schichtmodelle pruefen, ob an diesem Tag gearbeitet werden sollte
        open c_vertragsart;
        fetch c_vertragsart into v_vertragsart;
        if c_vertragsart%notfound then
            v_vertragsart := null;
        end if;
        close c_vertragsart;
        if v_schicht_datum < trunc(sysdate)
        or (
            v_vertragsart.va_bis_monat_ende_sim = 'T'
            and v_schicht_datum < ( last_day(trunc(sysdate) + 1) )
            and pzm_lohnauswertung.v_pzm_sim_on
        ) then
      -- nur Daten bis heute
      -- MWe 2018.05.16 Ticket:P70460-14
            if
                v_safound
                and ( v_daysakurzname <> v_def_sa_kurzname )
                and (
                    trunc(v_schicht_datum) < trunc(v_sabeginn)
                    and v_schichtart.sa_bewertung_beginn = 1
                ) --MWe
                and v_schichtart.sa_std_pro_tag > 0
            then                                                                                                   --MWe
                v_result := true;                                                                                    --MWe
            elsif
                v_safound
                and ( v_daysakurzname <> v_def_sa_kurzname )                                            --MWe
                and v_schichtart.sa_std_pro_tag > 0
            then
        -- **** An diesem Datum musste gearbeitet werden
                v_status := pzm_p_zeiterfassung.status_abwesend;
                v_dayaastatus := null;

        -- 4. Pruefen ob an diesem Datum ein Feiertag vorliegt
                v_feiertag := get_feiertag_fuer_pers(
                    in_datum   => in_schicht_datum,
                    in_pers_nr => v_personal.pers_nr
                );
                if v_feiertag.f_name is not null then
                    v_status := pzm_p_zeiterfassung.status_feiertag;
                end if;

        -- an Werktagen wird noch nach einem Urlaub oder abwesenheitsmeldung geschaut
        -- 5. Pruefen, ob eine abwesenheitsmeldung vorliegt
                open c_abwesenheitsmeldungen for select
                                                                                      t.*
                                                                                  from
                                                                                      pzm_abwesenheitsmeldungen t
                                                 where
                                                         pers_nr = in_pers_nr
                                                     and v_schicht_datum between t.beginn and t.ende;

                fetch c_abwesenheitsmeldungen into v_abwesenheitsmeldungen;
                v_found := c_abwesenheitsmeldungen%found;
                close c_abwesenheitsmeldungen;
                if not v_found then
                    open c_abwesenheits_antr for select
                                                                                  t.*
                                                                              from
                                                                                  pzm_abwesenheits_antr t
                                                 where
                                                         t.au_pers_nr = in_pers_nr
                                                     and t.au_status = const_ua_genehmigt
                                                     and in_schicht_datum between t.au_beginn and t.au_ende;

                    fetch c_abwesenheits_antr into v_abwesenheits_antr;
                    v_found := c_abwesenheits_antr%found;
                    close c_abwesenheits_antr;
                    if v_found then
                        v_abwesenheitsmeldungen.aa_id := v_abwesenheits_antr.au_abwes_art;
                        if pzm_p_base.get_abwesenheitsart(v_abwesenheits_antr.au_abwes_art, v_abwes_art) then
                            if
                                ( v_abwesenheits_antr.au_schicht_start = 0
                                or v_abwesenheits_antr.au_utage = 0.5 )
                                and v_abwes_art.kennz_urlaub = 'T'
                            then
                                v_halber_tag_urlaub := true;
                            end if;

                        end if;

                    end if;

                end if;

                if
                    v_feiertag.f_name is not null
                    and v_found
                then
                    v_found := false;
                    if pzm_p_base.get_abwesenheitsart(v_abwesenheitsmeldungen.aa_id, v_abwes_art) then
                        if
                            pzm_p_base.get_lohnart(v_abwes_art.lz_id, v_lohnarten)
                            and v_lohnarten.lz_operator in ( 'K', 'KUGK', 'UNB' )
                        then
                            v_found := true;
                        end if;

                    end if;

                end if;

                if v_found then
                    v_dayaastatus := v_abwesenheitsmeldungen.aa_id; -- Erszt mal die Abwesenheitsart uebernehmen
          -- trotz evtl. Feiertag hat die Abwesebheitsmeldung (abwesenheitsmeldung) vorrang
                    if
                        v_status = pzm_p_zeiterfassung.status_feiertag -- Nur bei Feiertag pruefen KUG
                        and pzm_p_base.get_abwesenheitsart(v_abwesenheitsmeldungen.aa_id, v_abwes_art) -- Lesen der Abwesenheit
                    then
                        if v_found then
                            v_dayaastatus := v_abwesenheitsmeldungen.aa_id; -- Erszt mal die Abwesenheitsart ?bernehmen
                        else
                            v_abwesenheitsmeldungen.aa_id := null;
                        end if;

                        v_status := pzm_p_zeiterfassung.status_abwesend;           -- Erst mal Abwesend als Status
                        if pzm_p_base.get_lohnart(v_abwes_art.lz_id, v_lohnarten)  -- Lesen der Lohnart
                         then
                            if v_lohnarten.lz_operator = 'KUGF'                      -- Die eingetragene Abwesenheit war Kurzarbeitergeld
                             then
                                v_status := pzm_p_zeiterfassung.status_feiertag;
                                open c_loa_kugf;
                                fetch c_loa_kugf into v_lohnarten;
                                v_found := c_loa_kugf%found;
                                close c_loa_kugf;
                                if v_found then
                                    open c_abwesenheiten_lz_id;
                                    fetch c_abwesenheiten_lz_id into v_abwes_art;
                                    v_found := c_abwesenheiten_lz_id%found;
                                    close c_abwesenheiten_lz_id;
                                    if v_found then
                                        v_dayaastatus := v_abwes_art.aa_id;
                                    end if;
                                end if;

                            end if;
                        end if;

                    else
                        v_status := pzm_p_zeiterfassung.status_abwesend;   -- Abwesend als Status, alles andere bleibt
                    end if;

                    if v_abwesenheitsmeldungen.sa_kurzname is not null then
                        v_km_sa_kurzname := v_abwesenheitsmeldungen.sa_kurzname;
            -- Schichtdaten der eingetragenen Schichtart benutzen
                        v_safound := get_schicht_daten(in_pers_nr, v_schicht_datum, v_schicht_datum, v_km_sa_kurzname, v_km_sa_beginn
                        ,
                                                       v_km_sa_ende, v_km_sa_std_p_tag) = 1;

                        if
                            v_safound
                            and ( v_km_sa_kurzname <> v_def_sa_kurzname )
                            and v_schichtart.sa_std_pro_tag > 0
                        then
                            v_daysakurzname := v_km_sa_kurzname;
                            v_sabeginn := v_km_sa_beginn;
                            v_saende := v_km_sa_ende;
                            v_sastdprotag := v_km_sa_std_p_tag;
                            if pzm_p_base.get_schichtart_by_uix(v_daysakurzname, v_schichtart) then
                                if v_schichtart.calc_basis = 'GLEITZ' then
                                    v_sabeginn := trunc(v_sabeginn) + fraction_of_day(v_schichtart.sa_beginn);
                                    v_saende := v_sabeginn + v_schichtart.sa_std_pro_tag / 24;
                                end if;
                            end if;

                        end if;

                    end if;

                    if v_personal.pers_kennz_zeiterf = 0 then
            -- bei Mitarbeitern ohne aktiver Zeiterfassung wird bei eingetragenen
            -- Abwesenheitsmeldungen oder genehmigten Urlaubsantraegen die Zeiterfassung
            -- kurzzeitig aktiviert
                        v_personal.pers_kennz_zeiterf := 1;
                    end if;
                elsif v_status <> pzm_p_zeiterfassung.status_feiertag then
          -- 6. wenn keine Abwesenheitsmeldung (Krankmeldung) vorliegt,
          -- pruefen ob ein genehmigter Urlaub fuer den ganzen Tag vorliegt
                    open c_abwesenheits_antr for select
                                                                                  t.*
                                                                              from
                                                                                  pzm_abwesenheits_antr t
                                                 where
                                                         t.au_pers_nr = in_pers_nr
                                                     and t.au_status = const_ua_genehmigt
                                                     and v_schicht_datum between t.au_beginn and t.au_ende;

                    fetch c_abwesenheits_antr into v_abwesenheits_antr;
                    if c_abwesenheits_antr%found then
                        v_status := pzm_p_zeiterfassung.status_abwesend;
                        v_dayaastatus := v_abwesenheits_antr.au_abwes_art;
                        if pzm_p_base.get_abwesenheitsart(v_abwesenheits_antr.au_abwes_art, v_abwes_art) then
                            if
                                v_abwes_art.kennz_urlaub = 'T'
                                and v_abwesenheits_antr.au_abwes_art != v_personal.pers_urlaub_anspr_aa_id
                            then
                -- bei Urlaubsabwesenheiten muessen wir die im Personalstamm eingestellte
                -- Abwesenheitsart benutzen, damit Buchung von richtigen Konto erfolgt
                                v_dayaastatus := v_personal.pers_urlaub_anspr_aa_id;
                            end if;

                            if
                                ( v_abwesenheits_antr.au_schicht_start = 0
                                or v_abwesenheits_antr.au_utage = 0.5 )
                                and v_abwes_art.kennz_urlaub = 'T'
                            then
                                v_halber_tag_urlaub := true;
                            end if;

                        end if;

                        if v_personal.pers_kennz_zeiterf = 0 then
              -- bei Mitarbeitern ohne aktiver Zeiterfassung wird bei eingetragenen
              -- abwesenheitsmeldungen oder genehmigten Urlaubsantraegen die Zeiterfassung
              -- kurzzeitig aktiviert
                            v_personal.pers_kennz_zeiterf := 1;
                        end if;
                    end if;

                    close c_abwesenheits_antr;
                end if;

                if nvl(v_personal.pers_kennz_zeiterf, 1) = 1 -- nur bei aktivierter Zeiterfassung

                 then
                    if pzm_p_base.get_schicht_modell(v_personal.pers_nr, v_schichtmodell) then
                        if nvl(v_schichtmodell.d_arb_std_pro_tag, 0) > 0 then
                            v_sastdprotag := v_schichtmodell.d_arb_std_pro_tag;
                            v_safound := get_schicht_daten(in_pers_nr, v_schicht_datum, v_schicht_datum, v_daysakurzname, v_sabeginn,
                                                           v_saende, v_sastdprotag) = 1;

                            if v_halber_tag_urlaub
                            or v_feiertag.f_sonder_feiertag = 'H' then -- halber feiertag
                                v_sastdprotag := v_sastdprotag / 2;
                            end if;

                            v_saende := v_sabeginn + v_sastdprotag / 24;
                        end if;

                        if
                            v_dayaastatus is null
                            and v_schichtmodell.standard_aa_id is not null
                            and v_status = pzm_p_zeiterfassung.status_abwesend
                        then
                            if (
                                v_vertragsart.va_bis_monat_ende_sim = 'T'
                                and v_schicht_datum >= trunc(sysdate)
                            ) then
                -- Simulation fuer die Zukunft (fiktive Zeiten fuer den vorzeitigen Monat),
                -- da wird die wahrscheinliche Anwesenheit bzw. Abwesenheit ueber
                -- das Schichtmodells ermittelt, damit die Zeiten in der Simulation korrekt berechnet werden
                                open c_abwesenheiten_anw;
                                fetch c_abwesenheiten_anw into v_abwes_art;
                                v_found := c_abwesenheiten_anw%found;
                                close c_abwesenheiten_anw;
                                if v_found then
                                    v_dayaastatus := v_abwes_art.aa_id;
                                else
                                    v_dayaastatus := null;
                                end if;

                                v_status := pzm_p_zeiterfassung.status_anwesend;
                                if v_sabeginn = trunc(v_sabeginn) then
                                    v_sabeginn := v_sabeginn + 6 / 24; -- Auf 6 uhr stellen, damit keine Nachtschicht gerechnet wird.
                                end if;

                                v_sastdprotag := v_schichtmodell.d_arb_std_pro_tag + get_pause_time(v_daysakurzname, v_sabeginn, v_saende
                                , v_personal.pers_pb_id);

                                v_saende := v_sabeginn + v_sastdprotag / 24;
                                v_ze_id := pzm_p_zeiterfassung.c_automatische_anwesenheit_eintragen(
                                    in_pers_nr           => in_pers_nr,
                                    in_schicht_tag       => v_schicht_datum,
                                    in_sa_kurzname       => v_daysakurzname,
                                    in_anwesenheit_start => v_sabeginn,
                                    in_anwesenheit_ende  => v_saende,
                                    in_aa_id             => v_dayaastatus
                                );

                            else
                -- wenn das Schichtmodell eine Standard Abweseheit definiert,
                -- wird diese genommen
                                v_dayaastatus := v_schichtmodell.standard_aa_id;
                            end if;

                        end if;

                    end if;

                    if v_status = pzm_p_zeiterfassung.status_abwesend then
                        v_ze_id := pzm_p_zeiterfassung.c_automatische_fehlzeit_eintragen(
                            in_pers_nr        => in_pers_nr,
                            in_schicht_tag    => v_schicht_datum,
                            in_aa_id          => v_dayaastatus,
                            in_sa_kurzname    => v_daysakurzname,
                            in_fehlzeit_start => v_sabeginn,
                            in_fehlzeit_ende  => v_saende
                        );

                        v_result := true;
                    elsif v_status = pzm_p_zeiterfassung.status_feiertag then
                        v_ze_id := pzm_p_zeiterfassung.c_automatischen_feiertag_eintragen(
                            in_pers_nr        => in_pers_nr,
                            in_schicht_tag    => v_schicht_datum,
                            in_sa_kurzname    => v_daysakurzname,
                            in_feiertag_start => v_sabeginn,
                            in_feiertag_ende  => v_saende
                        );

                        v_result := true;
                    end if;

                end if;

            end if;
        end if;

        return v_result;
    end;

    function c_schicht_tag_fehlzeit_luecken_pruefen (
        in_pers_nr            in pzm_personal.pers_nr%type,
        in_schicht_datum      in pzm_zeiterfassung.ze_schicht_tag%type,
        in_day_sa_kurzname    in pzm_zeiterfassung.ze_sa_kurzname%type,
        in_sa_beginn          in pzm_schichtarten.sa_beginn%type,
        in_sa_ende            in pzm_schichtarten.sa_ende%type,
        in_day_anw_calc_start in pzm_ze_tagessatz.ts_day_wert_start%type,
        in_day_anw_calc_ende  in pzm_ze_tagessatz.ts_day_wert_ende%type,
        in_day_calc_ende      in pzm_ze_tagessatz.ts_day_wert_ende%type,
        in_kst_id             in pzm_ze_tagessatz.ts_day_kst_id%type,
        in_abt_id             in pzm_ze_tagessatz.ts_day_abt_id%type,
        in_pb_id              in pzm_ze_tagessatz.ts_day_pb_id%type,
        in_geb_abw_std        in pzm_ze_tagessatz.ts_day_abw_std%type,
        in_arb_std            in pzm_ze_tagessatz.ts_day_arb_std%type,
        in_day_pause_std      in pzm_ze_tagessatz.ts_day_pause_std%type,
        in_zaehler            in number,
        in_std_pro_tag        in pzm_schichtarten.sa_std_pro_tag%type
    ) return boolean is

        v_zuspaetgekommen       boolean;
        v_zufruehgegangen       boolean;
        v_day_calc_start        pzm_ze_tagessatz.ts_day_wert_start%type;
        v_day_calc_ende         pzm_ze_tagessatz.ts_day_wert_ende%type;
        v_pause_std             number;
        v_ze_id                 pzm_zeiterfassung.ze_id%type;
        v_std                   pzm_zeiterfassung.ze_std%type;
        v_d_day_std             pzm_zeiterfassung.ze_std%type;
        v_schichtmodell         pzm_schicht_modelle%rowtype;
        v_dayaastatus           number;
        c_abwesenheits_antr     t_commoncursorref;
        v_abwesenheits_antr     pzm_abwesenheits_antr%rowtype;
        c_abwesenheitsmeldungen t_commoncursorref;
        v_abwesenheitsmeldungen pzm_abwesenheitsmeldungen%rowtype;
        v_abwesenheitsart       pzm_abwesenheitsarten%rowtype;
        v_found                 boolean;
        v_feiertag              isi_feiertage%rowtype;
        v_schichtart_daten      pzm_schichtarten%rowtype;
        v_geb_abw_std           pzm_ze_tagessatz.ts_day_abw_std%type;
        cursor c_schichtart_daten is
        select
            t.*
        from
            pzm_schichtarten t
        where
            t.sa_kurzname = in_day_sa_kurzname;

    begin
        v_zuspaetgekommen := false;
        v_zufruehgegangen := false;
        v_dayaastatus := null;
    -- AG 08.01.2025 Es muss mit den Schichtdaten fuer diesen Tag gerechnet werden
        v_d_day_std := nvl(in_std_pro_tag,
                           nvl(
                                   get_pers_schicht_d_std(in_pers_nr),
                                   8
                               ));
        if pzm_p_base.get_schicht_modell(in_pers_nr, v_schichtmodell) then
            if v_schichtmodell.standard_aa_id is not null then
        -- wenn das Schichtmodell eine Standard Abweseheit definiert,
        -- wird diese genommen
                v_dayaastatus := v_schichtmodell.standard_aa_id;
            end if;
        end if;

        v_feiertag := get_feiertag_fuer_pers(
            in_datum   => trunc(in_sa_beginn),
            in_pers_nr => in_pers_nr
        );

        v_geb_abw_std := in_geb_abw_std;
        if in_zaehler = 0 -- Krank und Urlaub nur im ersten Durchgang, sonst Standard-Abwesenheit
        or (
            in_zaehler = 1
            and v_feiertag.f_sonder_feiertag = 'H'
        )  -- Halber Feiertag
         then
      -- Eingetragene Abwesenheiten PRIO 1 
            open c_abwesenheitsmeldungen for select
                                                                                  t.*
                                                                              from
                                                                                  pzm_abwesenheitsmeldungen t
                                             where
                                                     pers_nr = in_pers_nr
                                                 and in_schicht_datum between t.beginn and t.ende;

            fetch c_abwesenheitsmeldungen into v_abwesenheitsmeldungen;
            v_found := c_abwesenheitsmeldungen%found;
            close c_abwesenheitsmeldungen;
            if v_found then
                v_dayaastatus := v_abwesenheitsmeldungen.aa_id;
                if pzm_p_base.get_abwesenheitsart(v_abwesenheitsmeldungen.aa_id, v_abwesenheitsart) then
                    if v_abwesenheitsart.kennz_urlaub = c.c_true then
                        if
                            v_d_day_std / 2 <= in_arb_std + in_day_pause_std -- Halber Tag Urlaub - dann keine Pause rechnen
                            and 1 = 2                                             -- TODO: hier muss ein Parameter eingefuehrt werden -> Elke Hermschroeder - Kein Automatusmus gewuescht
                        then
                            v_geb_abw_std := ( ( in_arb_std ) - v_d_day_std / 2 ) * -1 + in_geb_abw_std;
                        else
                            v_geb_abw_std := in_arb_std * -1 + in_geb_abw_std;
                        end if;

                    else
                        if v_abwesenheitsart.lz_id is null then
                            v_abwesenheitsart.lz_id := 0;
                        end if;
                    end if;

                end if;

            else -- Keine Eintrag in den Abwesenheitsmeldungen
        -- Pruefen Urlaub oder andere beantragte Abwesenheiten
                open c_abwesenheits_antr for select
                                                                              t.*
                                                                          from
                                                                              pzm_abwesenheits_antr t
                                             where
                                                     t.au_pers_nr = in_pers_nr
                                                 and t.au_status = const_ua_genehmigt
                                                 and in_schicht_datum between t.au_beginn and t.au_ende;

                fetch c_abwesenheits_antr into v_abwesenheits_antr;
                v_found := c_abwesenheits_antr%found;
                close c_abwesenheits_antr;
                if v_found then
                    v_dayaastatus := v_abwesenheits_antr.au_abwes_art;
                    if
                        pzm_p_base.get_abwesenheitsart(v_abwesenheits_antr.au_abwes_art, v_abwesenheitsart)
                        and v_abwesenheitsart.kennz_urlaub = c.c_true
                    then
                        if in_zaehler = 0 then
                            if v_abwesenheits_antr.au_schicht_start = 0 then
                                v_geb_abw_std := ( ( in_arb_std ) - v_d_day_std / 2 ) * -1 + in_geb_abw_std;
                            else
                                v_geb_abw_std := in_arb_std * -1 + in_geb_abw_std;
                            end if;

                        else
                            if
                                ( v_abwesenheits_antr.au_ende - v_abwesenheits_antr.au_beginn ) >= v_abwesenheits_antr.au_utage * 2
                                and v_feiertag.f_sonder_feiertag != 'H'
                            then
                                v_geb_abw_std := 0;
                            else
                                v_geb_abw_std := v_d_day_std / 2 - in_arb_std; -- AG Fix 20260216
                            end if;
                        end if;

                    end if;

                else
                    if v_feiertag.f_sonder_feiertag = 'H' then
                        v_geb_abw_std := v_d_day_std / 2; -- AG Fix 20260216 - Hier muss der halbe Feiertag gerechnt werden
                    end if;
                end if;

            end if;

        end if;

        if v_feiertag.f_name is null -- Bei Feiertagen ist der Tag immer komplett
           or v_abwesenheitsart.lz_id = 0
        or (
            v_feiertag.f_sonder_feiertag = 'H' -- halber Feiertag
            and in_zaehler = 1         -- im zweiten Durchlauf
        ) then
            open c_schichtart_daten;
            fetch c_schichtart_daten into v_schichtart_daten;
            close c_schichtart_daten;
            v_std := 0;
            if in_day_anw_calc_start > in_sa_beginn then -- wenn der berechnente Start-Wert spaeter als der Schichtbeginn ist
        -- Zu spaet gekommen ...
                v_zuspaetgekommen := true;
                v_std := round((in_day_anw_calc_start - in_sa_beginn) * 24, 3);
                v_geb_abw_std := v_geb_abw_std + v_std;

        -- -WK- 20090629: bei festen Schichtmodellen sind die Pausenzeiten an eine
        -- Uhrzeit gebunden, deshalb muss die Pausenzeit bei Abwesenheit in dieser
        -- Zeit abgezogen werden
                v_pause_std := get_pause_time(in_day_sa_kurzname,
                                              in_sa_beginn,
                                              in_day_anw_calc_start,
                                              get_pers_pb_id(in_pers_nr));
                if in_day_pause_std > nvl(v_pause_std, 0) then
                    v_pause_std := in_day_pause_std;
                end if;
                v_std := v_std - nvl(v_pause_std, 0);

        -- Die Zeit vom Beginn der Schicht bis zum tatsaechlichen Anfang wird mit Abwesenheit belegt
                v_ze_id := pzm_p_zeiterfassung.c_automatische_fehlzeit_eintragen(
                    in_pers_nr        => in_pers_nr,
                    in_schicht_tag    => in_schicht_datum,
                    in_aa_id          => v_dayaastatus,
                    in_sa_kurzname    => in_day_sa_kurzname,
                    in_fehlzeit_start => in_sa_beginn,
                    in_fehlzeit_ende  => in_day_anw_calc_start
                );

                pzm_p_zeiterfassung.c_ze_zuordnung_korrigieren(
                    in_ze_id                 => v_ze_id,
                    in_kst_id                => in_kst_id,
                    in_abt_id                => in_abt_id,
                    in_pb_id                 => in_pb_id,
                    in_schicht_tag_auswerten => false
                );

            end if;

            v_pause_std := get_pause_time(in_day_sa_kurzname,
                                          in_day_anw_calc_start,
                                          in_day_anw_calc_ende,
                                          get_pers_pb_id(in_pers_nr));
            if in_day_pause_std > nvl(v_pause_std, 0) then
                v_pause_std := in_day_pause_std;
            end if;
      
      -- 2026-03-17: WKr, ABa - 7,9996666667 auf 3 Stellen gerundet ergibt 8 => keine Fehlzeit!
      -- Deswegen Rundung hier zwingend erforderlich!
      -- (Bugfix: es wurden Fehlzeiten mit 0 Std. generiert)
            v_std := round(in_arb_std + v_std + v_geb_abw_std, 3); -- - v_pause_std;

            if v_std < v_schichtart_daten.sa_std_pro_tag -- In der Schicht werden immer - Stunden gemacht

             then -- wenn der berechnete Ende-Wert fueher als das Schichtende ist
        -- Zu frueh gegangen ...
                v_zufruehgegangen := true;
        -- -WK- 20090629: bei festen Schichtmodellen sind die Pausenzeiten an eine
        -- Uhrzeit gebunden, deshalb muss die Pausenzeit bei Abwesenheit in dieser
        -- Zeit abgezogen werden
                v_std := v_schichtart_daten.sa_std_pro_tag - v_std;
                v_day_calc_start := in_day_calc_ende;
                v_day_calc_ende := in_day_calc_ende + ( ( v_std ) / 24 );

        -- Die Zeit von dem tatsaechlichen Ende der Anwesenheit bis zum Ende der Schicht wird mit Abwesenheit belegt
                v_ze_id := pzm_p_zeiterfassung.c_automatische_fehlzeit_eintragen(
                    in_pers_nr        => in_pers_nr,
                    in_schicht_tag    => in_schicht_datum,
                    in_aa_id          => v_dayaastatus,
                    in_sa_kurzname    => in_day_sa_kurzname,
                    in_fehlzeit_start => v_day_calc_start,
                    in_fehlzeit_ende  => v_day_calc_ende
                );

                pzm_p_zeiterfassung.c_ze_zuordnung_korrigieren(
                    in_ze_id                 => v_ze_id,
                    in_kst_id                => in_kst_id,
                    in_abt_id                => in_abt_id,
                    in_pb_id                 => in_pb_id,
                    in_schicht_tag_auswerten => false
                );

            end if;

            return ( not ( v_zuspaetgekommen
            or v_zufruehgegangen ) );
        else
            if
                v_feiertag.f_sonder_feiertag = 'H' -- halber feiertag
                and in_zaehler = 0         -- Erster Durchlauf
                and in_arb_std > 0         -- und es wurde gearbeitet
            then
                return ( false );           -- Dann weiter im zweiten Durchgang
            end if;

            return ( true ); -- AG- 2026-02-16: Hier wird der gesamte Feiertag gebucht. 
        end if;

    end;

end;
/


-- sqlcl_snapshot {"hash":"0b2fb01956304e37b191ce8ba648e0fcde57359f","type":"PACKAGE_BODY","name":"PZM_P_SCHICHT_TAG","schemaName":"DIRKSPZM32","sxml":""}