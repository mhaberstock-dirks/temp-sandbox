create or replace 
package body PZM_SCHICHT_PLANUNG is
  -----------------------------------------------------------------------------------------------
  -- Package Body: PZM_SCHICHT_PLANUNG
  --
  -- DESIGN-PRINZIPIEN:
  --   - Kleine, fokussierte Funktionen mit klarer Verantwortung
  --   - Keine direkten DB-Schreibzugriffe (nur Lesen von Stammdaten)
  --   - Ausfuehrliches Logging fuer Nachvollziehbarkeit
  -----------------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------------
  -- Private Konstanten
  -----------------------------------------------------------------------------------------------
  --c_1_minute        constant number := 1 / (24 * 60);
  --c_default_raster  constant number := 15;  -- Default: 15 Minuten

  -----------------------------------------------------------------------------------------------
  -- Private Hilfsfunktionen
  -----------------------------------------------------------------------------------------------


  -----------------------------------------------------------------------------------------------
  -- Oeffentliche Funktionen: Hilfsfunktionen
  -----------------------------------------------------------------------------------------------

  /**
   * Laedt die Bewertungskonfiguration fuer eine Person und Schichtart
   */

  function pruefe_schicht_plan_eintrag(
    in_pers_nr           in pzm_personal.pers_nr%type,
    in_vq_id             in pzm_vorgangsqualifikation.vq_id%type,
    in_schicht_tag       in date,
    in_start             in date,
    in_ende              in date
  ) return varchar2 is
  
    c_module_name constant varchar2(50) := current_unit_name();

    v_found                 boolean;
    v_result                varchar2(30);

    v_personal              pzm_personal%rowtype;
    v_abwesenheitsmeldungen pzm_abwesenheitsmeldungen%rowtype;
    v_abwesenheits_antr     pzm_abwesenheits_antr%rowtype;
    v_abwesenheitsarten     pzm_abwesenheitsarten%rowtype;
    v_qual                  pzm_vorgangsqualifikation%rowtype;
    
    v_SAFound               boolean;
    v_SABeginn              date;
    v_SAEnde                date;
    v_SAStdProTag           number;
    v_plan_einsatz_wert     number;
    v_DaySAKurzname         pzm_zeiterfassung.ze_sa_kurzname%type;
    v_schicht_tag           pzm_zeiterfassung.ze_schicht_tag%type;
    v_region_code           varchar2(50);

    CURSOR c_check_qual is
      select p_qn.q_ablauf_datum, p_qn.vq_id
        from pzm_vorgangsqualifikation_pers p_q,
             pzm_vorgangsqualifikation_nachweis p_qn
       where p_q.pers_nr = in_pers_nr
         and p_q.pers_vq_id = in_vq_id
         and p_qn.pers_nr(+) = p_q.pers_nr
         and p_qn.vq_id(+) = p_q.pers_vq_id
       order by p_qn.q_ablauf_datum desc;
    v_check_qual               c_check_qual%rowtype; 
    
    CURSOR c_qual is
      select *
        from pzm_vorgangsqualifikation qual
       where qual.vq_id = in_vq_id;  
    
    CURSOR c_pers_abw is
      select *
        from pzm_abwesenheitsmeldungen abw
       where abw.pers_nr = in_pers_nr
         and abw.beginn <= in_start
         and abw.ende >= in_ende;

    CURSOR c_pers_abw_antr is
      select *
        from pzm_abwesenheits_antr a_antr
       where a_antr.au_pers_nr = in_pers_nr
         and a_antr.au_beginn <= in_start
         and a_antr.au_ende >= in_ende;

    CURSOR c_pers_perplant is
      select sum((t.w_plan_bis_zeit - t.w_plan_von_zeit)*24) einsatz_wert_std
        from pzm_vorgangsqual_w_plan_valide t
       where t.w_plan_pers_nr = in_pers_nr
         and ((t.w_plan_von_zeit <= in_start and t.w_plan_bis_zeit >= in_ende)
           or (t.w_plan_von_zeit <= in_start and t.w_plan_bis_zeit > in_start)
           or (t.w_plan_von_zeit > in_start and t.w_plan_von_zeit < in_ende))
         and t.w_plan_v_check_nr = 1;
         
  begin
    v_result := NULL;  
    v_schicht_tag := in_schicht_tag;
  
    if in_pers_nr is NULL
    then
      v_result := 'NO_PRES_NR_IN_PLAN';
      return v_result;
    end if;
    
    if not pzm_p_base.get_personal(in_pers_nr, v_personal) 
    then
      pzm_p_lc.assert(in_condition => in_pers_nr is not null,
        in_code => pzm_p_lc.cerr_pzm_ze_daten_invalid, in_message => pzm_p_lc.O_T_PZM_ERROR_ZE_INVALID_NO_PERS_NR);
    end if;
    if v_personal.pers_austrittdatum < in_schicht_tag
    then
      return 'AUSGESCHIEDEN';
    end if;
    
    OPEN c_qual;
    FETCH c_qual into v_qual;
    CLOSE c_qual;

    OPEN c_check_qual;
    FETCH c_check_qual into v_check_qual;
    v_found := c_check_qual%found;
    CLOSE c_check_qual;
    
    if not v_found
    then
      /*
      pzm_p_log.log_data(
      p_level       => pzm_p_log.LEVEL_INFO,
      p_message     => 'Schichtplanung PersNr: ' || in_pers_nr || ', hat die Qualfikation ' || nvl(v_qual.vq_bezeichnung, 'QQ_ID Fehlt ' || to_char(in_vq_id)) || ' nicht.',
      p_category    => pzm_p_log.CAT_SCHICHTPLAN,
      p_module      => c_module_name,
      p_pers_nr     => in_pers_nr,
      p_schicht_tag => in_schicht_tag,
      p_quelle      => QUELLE_APP
      );
      v_result := 'QUAL_ID_ERR_' || in_vq_id;
      */
      v_result := 'QUAL_ID_ERR';
      if v_qual.vq_zertifikat = c.C_TRUE
      then
        v_result := 'QUAL_ID_FATAL_ERR';
      end if;
    else
      if nvl(v_check_qual.q_ablauf_datum, in_ende) < in_ende
      then
        /*
        pzm_p_log.log_data(
        p_level       => pzm_p_log.LEVEL_INFO,
        p_message     => 'Schichtplanung PersNr: ' || in_pers_nr || ', die Qualfikation ' || nvl(v_qual.vq_bezeichnung, 'QQ_ID Fehlt ' || to_char(in_vq_id)) || ' ist am ' || to_char(v_check_qual.q_ablauf_datum, 'dd.mm.yyyy') || ' abgelaufen.',
        p_category    => pzm_p_log.CAT_SCHICHTPLAN,
        p_module      => c_module_name,
        p_pers_nr     => in_pers_nr,
        p_schicht_tag => in_schicht_tag,
        p_quelle      => QUELLE_APP
        );
        v_result := 'QUAL_ABGELAUFEN_' || to_char(v_check_qual.q_ablauf_datum, 'dd.mm.yyyy');
        */
        v_result := 'QUAL_ABGELAUFEN';
      else
        if v_qual.vq_zertifikat = c.C_TRUE
        and v_check_qual.vq_id is NULL
        then
          /*
          pzm_p_log.log_data(
          p_level       => pzm_p_log.LEVEL_INFO,
          p_message     => 'Schichtplanung PersNr: ' || in_pers_nr || ', hat die Qualfikation ' || nvl(v_qual.vq_bezeichnung, 'QQ_ID Fehlt ' || ' nicht.',
          p_category    => pzm_p_log.CAT_SCHICHTPLAN,
          p_module      => c_module_name,
          p_pers_nr     => in_pers_nr,
          p_schicht_tag => in_schicht_tag,
          p_quelle      => QUELLE_APP
          );
          */
          v_result := 'ZERT_FEHLT';
        end if;
      end if;
    end if;
    
    OPEN c_pers_abw;
    FETCH c_pers_abw into v_abwesenheitsmeldungen;
    v_found := c_pers_abw%found;
    CLOSE c_pers_abw;
    if v_found
    then
      if not pzm_p_base.get_abwesenheitsart(v_abwesenheitsmeldungen.aa_id, v_abwesenheitsarten)
      then 
        v_abwesenheitsarten.aa_kurzname := 'AA_ID = ' || to_char(v_abwesenheitsmeldungen.aa_id);
      end if;
      /*
      pzm_p_log.log_data(
      p_level       => pzm_p_log.LEVEL_INFO,
      p_message     => 'Schichtplanung PersNr: ' || in_pers_nr || ', ist abwesend wegen ' || v_abwesenheitsarten.aa_kurzname,
      p_category    => pzm_p_log.CAT_SCHICHTPLAN,
      p_module      => c_module_name,
      p_pers_nr     => in_pers_nr,
      p_schicht_tag => in_schicht_tag,
      p_quelle      => QUELLE_APP
      );*/
      if v_abwesenheitsarten.kennz_urlaub = c.C_TRUE
      then
        v_abwesenheitsarten.aa_kurzname := '_U';
      elsif v_abwesenheitsarten.aa_kurzname like 'K%'
        and v_abwesenheitsarten.aa_kurzname != 'KUG'
      then
        v_abwesenheitsarten.aa_kurzname := '_K';
      else
        v_abwesenheitsarten.aa_kurzname := NULL;
      end if;
      v_result := 'ABW' || v_abwesenheitsarten.aa_kurzname;
    end if;
    
    if v_result is NULL
    then
      OPEN c_pers_abw_antr;
      FETCH c_pers_abw_antr into v_abwesenheits_antr;
      v_found := c_pers_abw_antr%found;
      CLOSE c_pers_abw_antr;
      if v_found
      then
        if not pzm_p_base.get_abwesenheitsart(v_abwesenheits_antr.au_status, v_abwesenheitsarten)
        then 
          v_abwesenheitsarten.aa_kurzname := 'AA_ID = ' || to_char(v_abwesenheits_antr.au_abwes_art);
        end if;
        /*
        pzm_p_log.log_data(
        p_level       => pzm_p_log.LEVEL_INFO,
        p_message     => 'Schichtplanung PersNr: ' || in_pers_nr || ', ist abwesend wegen ' || v_abwesenheitsarten.aa_kurzname,
        p_category    => pzm_p_log.CAT_SCHICHTPLAN,
        p_module      => c_module_name,
        p_pers_nr     => in_pers_nr,
        p_schicht_tag => in_schicht_tag,
        p_quelle      => QUELLE_APP
        );
        */
        if v_abwesenheitsarten.kennz_urlaub = c.C_TRUE
        then
          v_abwesenheitsarten.aa_kurzname := '_U';
        elsif v_abwesenheitsarten.aa_kurzname like 'K%'
          and v_abwesenheitsarten.aa_kurzname != 'KUG'
        then
          v_abwesenheitsarten.aa_kurzname := '_K';
        else
          v_abwesenheitsarten.aa_kurzname := NULL;
        end if;
        v_result := 'ABW' || v_abwesenheitsarten.aa_kurzname;
      end if;
    end if;
    
    if v_result is NULL
    then
      v_SAFound := get_schicht_daten(in_pers_nr, in_start, v_schicht_tag,
                                     v_DaySAKurzname, v_SABeginn, v_SAEnde, v_SAStdProTag) = 1;
      if not v_SAFound
      then
        v_result := 'NO_SHIFT';
      else
        v_region_code := null;
        select max(t.pers_region_code) into v_region_code
          from PZM_V_PERS_FEIERTAGE t
         where t.pers_nr = in_pers_nr
           and t.f_datum = in_schicht_tag;
        if v_region_code is not NULL
        then
          v_result := 'FEIERTAG';
        end if;
      end if;
    end if;
    OPEN c_pers_perplant;
    FETCH c_pers_perplant into v_plan_einsatz_wert;
    CLOSE c_pers_perplant;
    if v_plan_einsatz_wert > (v_SAEnde - v_SABeginn) * 24 + 1 -- + 1 ist für Pausen und ggf kleine Mehrarbeit zu tollerieren
    then
      if v_plan_einsatz_wert > (v_SAEnde - v_SABeginn) * 24 + 2 -- + 2 ist für Pausen und ggf kleine Mehrarbeit zu tollerieren noch OK
      then
        v_result := 'ZH_ZEIT_KITISCH';
      else
        v_result := 'ZH_VERPLANT';
      end if;
    end if;
    
    return (nvl(v_result, 'IO'));
  end;
  
  procedure gen_schichtplan_aus_bedarf(
    in_ResponsibleId     in pzm_abt_leitung.abt_l_pers_nr%type,
    in_vq_abt_id         in pzm_vorgangsqualifikation.vq_abt_id%type,
    in_w_plan_start      in pzm_vorgangsqual_w_plan.w_plan_start%type,
    in_w_plan_schicht    in pzm_vorgangsqual_w_plan.w_plan_schicht%type
  ) is
    v_plan_einsatz_nr    integer;
    v_plan_einsatz_wert  number;
  
    CURSOR c_w_plan_liste is
      select d_list.datum,
             vqb.abt_l_pers_nr,
             vqb.vq_id,
             vqb.vq_abt_id,
             vqb.abt_name,
             isi_utils.Iso_WeekDay(d_list.datum) wochentag,
             vqb.schicht_nr,
             vqb.schicht_von,
             vqb.schicht_bis,
             case when isi_utils.Iso_WeekDay(d_list.datum) = 1
                  then
                       vqb.pers_bedarf_mo
                  when isi_utils.Iso_WeekDay(d_list.datum) = 2
                  then
                       vqb.pers_bedarf_di
                  when isi_utils.Iso_WeekDay(d_list.datum) = 3
                  then
                       vqb.pers_bedarf_mi
                  when isi_utils.Iso_WeekDay(d_list.datum) = 4
                  then
                       vqb.pers_bedarf_do
                  when isi_utils.Iso_WeekDay(d_list.datum) = 5
                  then
                       vqb.pers_bedarf_fr
                  when isi_utils.Iso_WeekDay(d_list.datum) = 6
                  then
                       vqb.pers_bedarf_sa
                  else
                       vqb.pers_bedarf_so
                  end pers_bedarf
       from (select in_w_plan_start + level - 1 as datum
               from dual
               connect by level <= 7
           ) d_list,
           pzm_v_vorgangsqual_pers_bedarf_liste vqb,
           pzm_abteilungen abt
      where vqb.abt_l_pers_nr = in_ResponsibleId
        and vqb.schicht_nr = nvl(in_w_plan_schicht, vqb.schicht_nr)
        and vqb.abt_name = nvl(abt.abt_name, vqb.abt_name)
        and abt.abt_id(+) = in_vq_abt_id
      group by d_list.datum,
             vqb.abt_l_pers_nr,
             vqb.vq_id,
             vqb.vq_abt_id,
             vqb.abt_name,
             d_list.datum,
             vqb.schicht_nr,
             vqb.schicht_von,
             vqb.schicht_bis,
             vqb.pers_bedarf_mo,
             vqb.pers_bedarf_di,
             vqb.pers_bedarf_mi,
             vqb.pers_bedarf_do,
             vqb.pers_bedarf_fr,
             vqb.pers_bedarf_sa,
             vqb.pers_bedarf_so,
             vqb.pers_nr_vorschl;
    v_w_plan_liste           c_w_plan_liste%rowtype;
  
  begin
    OPEN c_w_plan_liste;
    FETCH c_w_plan_liste into v_w_plan_liste;
    LOOP
      EXIT when c_w_plan_liste%NOTFOUND;
      
      v_plan_einsatz_nr := 0;
      loop
        EXIT when v_plan_einsatz_nr >= v_w_plan_liste.pers_bedarf;
        if v_w_plan_liste.pers_bedarf - v_plan_einsatz_nr > 1
        then
          v_plan_einsatz_wert := 1;
        else
          v_plan_einsatz_wert := v_w_plan_liste.pers_bedarf - v_plan_einsatz_nr;
        end if;
      
        v_plan_einsatz_nr := v_plan_einsatz_nr + 1;
        insert into pzm_vorgangsqual_w_plan
        values
          (NULL,                            -- Plan_ID wird im Trigger gesetzt
           in_w_plan_start, 
           v_w_plan_liste.vq_id,            -- v_w_plan_vq_id, 
           v_w_plan_liste.datum,            -- v_w_plan_datum, 
           v_w_plan_liste.schicht_nr,       -- v_w_plan_schicht, 
           fraction_of_day(v_w_plan_liste.schicht_von) + v_w_plan_liste.datum, -- v_w_plan_von_zeit, 
           fraction_of_day(v_w_plan_liste.schicht_bis) + v_w_plan_liste.datum, -- v_w_plan_bis_zeit, 
           v_plan_einsatz_nr,               -- v_w_plan_einsatz_nr, 
           NULL,                            -- v_w_plan_pers_nr, 
           v_plan_einsatz_wert,             -- v_w_plan_einsatz_wert, 
           sysdate,                              -- v_created_date, 
           nvl(current_isi_user_login_id(), -1), -- v_created_login_id, 
           NULL,                                 -- v_last_change_date, 
           NULL                                  -- v_last_change_login_id
           );
      end LOOP;
      FETCH c_w_plan_liste into v_w_plan_liste;
    end LOOP;
    CLOSE c_w_plan_liste;
    commit;
  end;

end;
/



-- sqlcl_snapshot {"hash":"3a9fc544078819d859c5d9898152495c43194ae3","type":"PACKAGE_BODY","name":"PZM_SCHICHT_PLANUNG","schemaName":"DIRKSPZM32","sxml":""}