create or replace 
package body DIRKSPZM32.PZM_UTILS is

  v_build_number constant number := 1;
  /*
   *  Build history
   *  date       | version    | info
   *  ---------------------------------------------------------------------------------
   *  16.12.2009 | 3.4.11.1   | (-WK-) package created
   *  19.05.2026 |            | (MHab) added result-chached-function of Get_Pers_Kst_Id  
   */

  v_error exception;
  v_err_nr   number;
  v_err_text varchar2(255);

  /*
   * Function result cache for get_per_kst_id()
   */  
  type t_pers_kst_id_cache_entry is record (
      kst_id number
    , cached_at timestamp
  );
  type t_pers_kst_id_cache is table of t_pers_kst_id_cache_entry index by pls_integer;
  
  g_pers_kst_id_cache t_pers_kst_id_cache;
  gc_pers_kst_id_ttl constant interval day to second := interval '1' Minute;
   

  -------------------------------------------------------------------------------------------------------
  -- Standard Fehlerhandling für Exceptions
  -------------------------------------------------------------------------------------------------------
  procedure raise_isi_error(in_err_nr   in number,
                            in_err_text in varchar2) is
  begin
    v_err_nr   := in_err_nr;
    v_err_text := in_err_text;
    raise v_error;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Reset global error variables
  -------------------------------------------------------------------------------------------------------
  procedure reset_isi_error is
  begin
    v_err_nr := null;
    v_err_text := null;
  end;

  -------------------------------------------------------------------------------------------------------
  -- Versionsrückgabe zur Kontrolle der Packageabhängigkeit in ISIPlus
  -------------------------------------------------------------------------------------------------------
  function get_release return varchar2 is
  begin
    return(v_release_str);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_version return varchar2 is
  begin
    return(to_char(v_release_major) || '.' ||
           to_char(v_release_minor) || '.' ||
           to_char(v_revision) || '.' ||
           to_char(v_build_number) || ' / ' ||
           v_rev_date);
  end;

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  procedure get_version_ex(out_rel_major   out number,
                           out_rel_minor   out number,
                           out_revision    out number,
                           out_buid_number out number,
                           out_rev_date    out varchar2
                          ) is
  begin
    out_rel_major := v_release_major;
    out_rel_minor := v_release_minor;
    out_revision := v_revision;
    out_buid_number := v_build_number;
    out_rev_date := v_rev_date;
  end;

  /******************************************************************************************************
   * private functions
   ******************************************************************************************************/


  /******************************************************************************************************
   * public functions
   ******************************************************************************************************/

  -------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------
  function get_abwes_liste_fuer_tag(p_pers_nr in number,
                                    p_datum in date,
                                    p_spalte in number default 1,
                                    p_separator in varchar2 default CHR(13)) return varchar2 is
    cursor c_ZEAbwesenheiten is
      select decode(aa_kurzname, null, '---', aa_kurzname) kurzname,
             to_char(sum(ze_std), 'FM999990D000') std,
             ze_status
        from pzm_zeiterfassung,
             pzm_abwesenheitsarten
       where ze_pers_nr = p_pers_nr
         and ze_aa_status = aa_id(+)
         and ze_schicht_tag = trunc(p_datum)
       group by aa_kurzname, ze_status
       order by max(ze_calc_ist_start);

    v_kurzname pzm_abwesenheitsarten.aa_kurzname%type;
    v_stunden varchar2(20);
    v_status pzm_zeiterfassung.ze_status%type;
    Result varchar2(255);
  begin
    Result := null;
    open c_ZEAbwesenheiten;

    loop
      fetch c_ZEAbwesenheiten into v_kurzname, v_stunden, v_status;
      exit when c_ZEAbwesenheiten%notfound;

      if v_status in (0, 6)
      then
        if p_spalte = 1
        then
          v_kurzname := substr(v_kurzname, 1, 5);
          if Result is null then
            Result := v_kurzname;
          else
            Result := result || p_separator || v_kurzname;
          end if;
        elsif p_spalte = 2
        then
          if Result is NULL
          then
            Result := v_stunden;
          else
            Result := result || p_separator || v_stunden;
          end if;
        end if;
      else
        if Result is NULL
        then
          Result := '---';
        else
          Result := result || p_separator || '---';
        end if;
      end if;
    end loop;

    close c_ZEAbwesenheiten;
    return(Result);
  end;
  
  -------------------------------------------------------------------------------------------------------
  -- Die Funktion gibt eine semikolon Separierte Liste der Abteilung-IDs zurück, die die angefragte 
  -- PRES_NR sehen oder bearbeiten darf
  -------------------------------------------------------------------------------------------------------
  function PZM_GET_ABT_ZU_PERS_NR(in_pers_nr in number) 
    return varchar2 is
    Result                   varchar2(4096);
    v_abteilung              pzm_abteilungen%rowtype;
    v_produktionsbereich     pzm_produktionsbereiche%rowtype;
    v_personal               pzm_personal%rowtype;
    v_abt_leitung            pzm_abt_leitung%rowtype;
    
    CURSOR c_personal IS
      SELECT *
        FROM pzm_personal p
       WHERE p.pers_nr = in_pers_nr;

    CURSOR c_abteilung IS
      SELECT *
        FROM pzm_abteilungen a
       WHERE a.abt_id = v_personal.pers_abt_id;
       
    CURSOR c_produktionsbereich IS
      SELECT *
        FROM pzm_produktionsbereiche pb
       WHERE pb.pb_id = nvl(v_personal.pers_pb_id, v_abteilung.abt_pb_id);

    CURSOR c_abt_leitung IS
      SELECT *
        FROM pzm_abt_leitung al
       WHERE al.abt_l_pers_nr = in_pers_nr
         and al.abt_l_von_datum <= sysdate
         and al.abt_l_bis_datum >= sysdate;
       
  begin
    OPEN c_personal;
    FETCH c_personal INTO v_personal;
    CLOSE c_personal;

    OPEN c_abteilung;
    FETCH c_abteilung INTO v_abteilung;
    CLOSE c_abteilung;

    OPEN c_produktionsbereich;
    FETCH c_produktionsbereich INTO v_produktionsbereich;
    CLOSE c_produktionsbereich;

    OPEN c_abt_leitung;
    FETCH c_abt_leitung INTO v_abt_leitung;
    CLOSE c_abt_leitung;

    Result := v_abteilung.abt_name;

    -- Eigene Abteilung ist die Zuständige Personalabteilung
    -- Oder über die Hirachie und Leitungsfunktion 
    select ';' || stradd_distinct(res.abt_id) || ';' into result
    from
      ( 
        select a.abt_id
          from pzm_abteilungen a
         where a.abt_pb_id = v_produktionsbereich.pb_id
           and nvl(a.abt_personal_abt_id, v_produktionsbereich.pb_personal_abt_id) = v_abteilung.abt_id 
        Union
        select a.abt_id 
          from pzm_abteilungen a
          start with a.abt_id = v_abt_leitung.abt_l_abt_id
          connect by prior a.abt_id = a.abt_parent_abt_id
      ) res;
    
    return(Result);
  end PZM_GET_ABT_ZU_PERS_NR;
  
  -- Procedure  um die Werte für den Urlaubsanspruch etc zu bekommen
  -- Return varchr2 T=OK, F-Fehler
  procedure  PZM_GET_PERS_URLAUB_DATEN(in_pers_nr                in pzm_personal.pers_nr%type,
                                     in_jahr                   in number,
                                     out_jahresanspruch       out pzm_konten.saldo%type,
                                     out_genehmigt            out pzm_konten.saldo%type,
                                     out_genommen             out pzm_konten.saldo%type,
                                     out_rest                 out pzm_konten.saldo%type,
                                     out_beantragt            out pzm_konten.saldo%type,
                                     out_restvorjahr          out pzm_konten.saldo%type,
                                     out_pers_verfall_vorjahr out pzm_personal.pers_verfall_vorjahr%type,
                                     out_flexiBeantragt       out pzm_konten.saldo%type,
                                     out_flexiGenehmigt       out pzm_konten.saldo%type,
                                     out_vorgesetzter         out pzm_personal.pers_nr%type)
                                     is
                                     
      v_result                       varchar2(1);  
      v_found                        boolean;
    
      CURSOR c_get_pers_urlaub_daten is
        select pd.pers_nr,
               nvl(pd.pers_urlaub_anspr_wert, 0) Jahresanspruch,
               nvl(sum(u.au_utage), 0) Genehmigt,
               (select nvl(sum(case
                                 when to_char(sysdate, 'yyyy') = in_jahr then
                                  case
                                    when t.au_beginn between
                                         to_date('01.01.' || to_char(sysdate, 'YYYY'), 'dd.mm.yyyy') and
                                         sysdate and
                                         t.au_ende between
                                         to_date('01.01.' || to_char(sysdate, 'YYYY'), 'dd.mm.yyyy') and
                                         sysdate then
                                     nvl(sum(t.au_utage), 0)
                                    when t.au_beginn <
                                         to_date('01.01.' || to_char(sysdate, 'YYYY'), 'dd.mm.yyyy') and
                                         t.au_ende between
                                         to_date('01.01.' || to_char(sysdate, 'YYYY'), 'dd.mm.yyyy') and
                                         sysdate then
                                     get_anz_arbeitstage(pd.pers_nr,
                                                         to_date('01.01.' ||
                                                                 to_char(sysdate, 'YYYY'), 'dd.mm.yyyy'),
                                                         t.au_ende,
                                                         100)
                                    when t.au_beginn between
                                         to_date('01.01.' || to_char(sysdate, 'YYYY'), 'dd.mm.yyyy') and
                                         sysdate and t.au_ende > sysdate then
                                     get_anz_arbeitstage(pd.pers_nr,
                                                         t.au_beginn,
                                                         sysdate,
                                                         100)
                                  end
                                 when to_char(sysdate, 'yyyy') > in_jahr then
                                  case
                                    when t.au_beginn between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                                         to_date('31.12.' || in_jahr, 'dd.mm.yyyy') and
                                         t.au_ende between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                                         to_date('31.12.' || in_jahr, 'dd.mm.yyyy') then
                                     nvl(sum(t.au_utage), 0)
                                    when t.au_beginn < to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                                         t.au_ende between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                                         to_date('31.12.' || in_jahr, 'dd.mm.yyyy') then
                                     get_anz_arbeitstage(pd.pers_nr,
                                                         to_date('01.01.' || in_jahr, 'dd.mm.yyyy'),
                                                         t.au_ende,
                                                         100)
                                    when t.au_beginn between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                                         to_date('31.12.' || in_jahr, 'dd.mm.yyyy') and
                                         t.au_ende > to_date('31.12.' || in_jahr, 'dd.mm.yyyy') then
                                     get_anz_arbeitstage(pd.pers_nr,
                                                         t.au_beginn,
                                                         to_date('31.12.' || in_jahr, 'dd.mm.yyyy'),
                                                         100)
                                  end
                                 else
                                  0
                               end),
                           0)
                  from pzm_abwesenheits_antr t, pzm_abwesenheitsarten a
                 where pd.pers_nr = in_pers_nr
                   and pd.pers_nr = t.au_pers_nr
                   and (t.au_status = 1 or t.au_status = 4)
                   and t.au_abwes_art = a.aa_id
                   and a.kennz_urlaub = 'T'
                 group by t.au_beginn, t.au_ende) Genommen,
               case when uk.buch_einheit = 'DD' then
                 case when to_char(sysdate, 'yyyy') = in_jahr then
                    uk.saldo
                 else
                    nvl(pd.pers_urlaub_anspr_wert, 0) - nvl(sum(u.au_utage), 0)
                 end
               else
                 case when to_char(sysdate, 'yyyy') = in_jahr then
                  uk.saldo  / nvl(pzm_utils.pzm_get_sm_durch_std_tag(sm.sm_name), nvl(sm.d_arb_std_pro_tag, 8))  - nvl(sum(u.au_utage), 0)
                 else
                  nvl(pd.pers_urlaub_anspr_wert, 0) / nvl(pzm_utils.pzm_get_sm_durch_std_tag(sm.sm_name), nvl(sm.d_arb_std_pro_tag, 8)) - nvl(sum(u.au_utage), 0)
                 end
               end Rest,
               (select nvl(sum(t.au_utage), 0)
                  from pzm_abwesenheits_antr t, pzm_abwesenheitsarten a
                 where pd.pers_nr = t.au_pers_nr
                   and (t.au_status = 0 or t.au_status = 5)
                   and t.au_beginn between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                       to_date('31.12.' || in_jahr, 'dd.mm.yyyy')
                   and t.au_abwes_art = a.aa_id
                   and a.kennz_urlaub = 'T') Beantragt,
               case when uk.buch_einheit = 'DD' then
                         case when uk.saldo - pd.pers_urlaub_anspr_wert < 0
                              then 0
                              else uk.saldo - pd.pers_urlaub_anspr_wert 
                         end
                    else
                         case when uk.saldo / nvl(pzm_utils.pzm_get_sm_durch_std_tag(sm.sm_name), nvl(sm.d_arb_std_pro_tag, 8)) - pd.pers_urlaub_anspr_wert < 0
                              then 0
                              else uk.saldo  / nvl(pzm_utils.pzm_get_sm_durch_std_tag(sm.sm_name), nvl(sm.d_arb_std_pro_tag, 8)) - pd.pers_urlaub_anspr_wert   
                         end  
                   end RestVorjahr,
               pd.pers_verfall_vorjahr,
               (select nvl(sum(t.au_utage), 0)
                  from pzm_abwesenheits_antr t, pzm_abwesenheitsarten a
                 where pd.pers_nr = t.au_pers_nr
                   and (t.au_status = 0 or t.au_status = 5)
                   and t.au_beginn between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                       to_date('31.12.' || in_jahr, 'dd.mm.yyyy')
                   and t.au_abwes_art = a.aa_id
                   and a.aa_kurzname = 'FLX') FlexiBeantragt,
               (select nvl(sum(t.au_utage), 0)
                  from pzm_abwesenheits_antr t, pzm_abwesenheitsarten a
                 where pd.pers_nr = t.au_pers_nr
                   and t.au_status = 1
                   and t.au_beginn between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and
                       to_date('31.12.' || in_jahr, 'dd.mm.yyyy')
                   and t.au_abwes_art = a.aa_id
                   and a.aa_kurzname = 'FLX') FlexiGenehmigt,
               pd.pers_abt_id
          from pzm_personal            pd,
               pzm_abwesenheits_antr         u,
               pzm_konten              uk,
               pzm_abwesenheitsarten   a,
               pzm_abwesenheitsarten   ak,
               pzm_lohnarten           la,
               pzm_abteilungen         ab,
               pzm_abt_leitung         abl,
               pzm_schicht_modelle     sm
        where pd.pers_nr = in_pers_nr
           and ((pd.pers_nr = u.au_pers_nr(+) and
               (u.au_status(+) = 1 or u.au_status(+) = 4) and
               u.au_beginn(+) between to_date('01.01.' || in_jahr, 'dd.mm.yyyy') and to_date('31.12.' || in_jahr, 'dd.mm.yyyy') and 
               u.au_abwes_art(+) = a.aa_id and
               a.kennz_urlaub = 'T'))
           and pd.pers_urlaub_anspr_aa_id = ak.aa_id
           and ak.lz_id = la.lz_id
           and la.lz_konto_name_kurz = uk.name_kurz
           and uk.pers_nr = pd.pers_nr
           and uk.aktiv = 'T'
           and nvl(pd.pers_austrittdatum, trunc(sysdate)) >= trunc(sysdate)
           and pd.pers_eintrittsdatum <= trunc(sysdate)
           and sm.sm_name(+) = nvl(pd.pers_sm_name, ab.abt_standard_sm_name) 
           and pd.pers_nr = abl.abt_l_pers_nr(+)
           and pd.pers_abt_id = ab.abt_id
        group by pd.pers_nr,
                 pd.pers_urlaub_anspr_wert,
                 uk.saldo,
                 pd.pers_verfall_vorjahr,
                 pd.pers_kst_id,
                 abl.abt_l_pers_nr,
                 uk.buch_einheit,
                 nvl(pzm_utils.pzm_get_sm_durch_std_tag(sm.sm_name), nvl(sm.d_arb_std_pro_tag, 8)),
                 pd.pers_abt_id;
      v_get_pers_urlaub_daten         c_get_pers_urlaub_daten%rowtype;
                 
    begin
      OPEN c_get_pers_urlaub_daten;
      FETCH c_get_pers_urlaub_daten into v_get_pers_urlaub_daten;
      v_found := c_get_pers_urlaub_daten%found;
      CLOSE c_get_pers_urlaub_daten;
      if v_found
      then
        out_jahresanspruch       := v_get_pers_urlaub_daten.jahresanspruch;
        out_Genehmigt            := v_get_pers_urlaub_daten.genehmigt;
        out_Genommen             := v_get_pers_urlaub_daten.genommen;
        out_Rest                 := v_get_pers_urlaub_daten.rest;
        out_Beantragt            := v_get_pers_urlaub_daten.beantragt;
        out_RestVorjahr          := v_get_pers_urlaub_daten.restvorjahr;
        out_pers_verfall_vorjahr := v_get_pers_urlaub_daten.pers_verfall_vorjahr;
        out_FlexiBeantragt       := v_get_pers_urlaub_daten.flexibeantragt;
        out_FlexiGenehmigt       := v_get_pers_urlaub_daten.flexigenehmigt;
        v_result                 := PZM_GET_PERS_VORGESETZTER(v_get_pers_urlaub_daten.pers_abt_id, out_Vorgesetzter);
        v_result := 'T';
      end if;
    end;

  function PZM_GET_PERS_VORGESETZTER(in_abt_id                in  pzm_abt_leitung.abt_l_abt_id%type,
                                     out_Vorgesetzter         out pzm_personal.pers_nr%type)
                                     return varchar2 is
    v_found                          boolean;
    v_abt_id                         pzm_abt_leitung.abt_l_abt_id%type;
    v_abt_pers_nr                    pzm_abt_leitung.abt_l_pers_nr%type;
    
    CURSOR c_get_vorgesetzen is
      select abtl.abt_l_pers_nr, abt.abt_parent_abt_id
        from pzm_abteilungen abt,
             pzm_abt_leitung abtl
       where abt.abt_id = v_abt_id
         and abtl.abt_l_abt_id(+) = abt.abt_id
      order by decode(abtl.abt_l_funktion,
                      'G', 1,
                      'L', 2,
                      'V', 3,
                      4),
               abtl.abt_l_pers_nr;
       
    
  begin
    v_abt_id := in_abt_id;
    OPEN c_get_vorgesetzen;  
    LOOP
      FETCH c_get_vorgesetzen into v_abt_pers_nr, v_abt_id;
      v_found := c_get_vorgesetzen%FOUND;
      exit when not v_found or v_abt_pers_nr is not NULL;
      CLOSE c_get_vorgesetzen;
      OPEN c_get_vorgesetzen;
    end LOOP;
    CLOSE c_get_vorgesetzen;
    if v_found
    then
      out_Vorgesetzter := v_abt_pers_nr;
      return ('T');  
    else
      out_Vorgesetzter := NULL;
      return ('F');  
    end if;
  end;

  function pzm_get_sm_durch_std_tag(in_sm_name               in  pzm_schicht_perioden.sp_sm_name%type)
                                    return number is

    v_found                         boolean;
    
    
    v_pzm_schicht_perioden          pzm_schicht_perioden%ROWTYPE;
    v_pzm_schichtarten              pzm_schichtarten%rowtype;
    
    v_sa_kurzname                   pzm_schichtarten.sa_kurzname%type;
    v_sa_std_pro_tag                pzm_schichtarten.sa_std_pro_tag%type;
    v_sa_std                        number;
    v_sa_tage                       number;
    v_sa_std_durch_tag              number;
    
    CURSOR c_pzm_schicht_modell is
      select t.d_arb_std_pro_tag
        from pzm_schicht_modelle t
       where t.sm_name = in_sm_name;

    CURSOR c_pzm_schicht_perioden is
      select *
        from pzm_schicht_perioden sp
       where sp.sp_sm_name = in_sm_name;
       
    CURSOR c_pzm_schichtarten is
      select sa.sa_std_pro_tag
        from pzm_schichtarten sa
       where sa.sa_kurzname = v_sa_kurzname;
 
  begin
    v_sa_std  := 0;
    v_sa_tage := 0;
    v_sa_std_durch_tag := 0;
    OPEN c_pzm_schicht_perioden;
    LOOP
      FETCH c_pzm_schicht_perioden into v_pzm_schicht_perioden;
      exit when c_pzm_schicht_perioden%NOTFOUND;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_mo;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if nvl(v_sa_tage, 0) > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        end if;
      end if;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_di;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if nvl(v_sa_tage, 0) > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        end if;
      end if;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_mi;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if nvl(v_sa_tage, 0) > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        end if;
      end if;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_do;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if nvl(v_sa_tage, 0) > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        end if;
      end if;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_fr;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if nvl(v_sa_tage, 0) > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        end if;
      end if;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_sa;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if nvl(v_sa_tage, 0) > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        end if;
      end if;
      v_sa_kurzname := v_pzm_schicht_perioden.sp_sa_wot_so;
      if v_sa_kurzname is not NULL
      then
        OPEN c_pzm_schichtarten;
        FETCH c_pzm_schichtarten into v_sa_std_pro_tag;
        CLOSE c_pzm_schichtarten;
        v_sa_std  := v_sa_std + nvl(v_sa_std_pro_tag, 8);  -- Wenn fehlt dann werden 8 Stunden angenommen
        if v_sa_std_pro_tag = 0
        then
          v_sa_std_durch_tag := 0;                      -- Wenn Freischichten eingetragen, dann muss der D-Wert aus dem Schichtmodell verwendet werden
          EXIT;
        end if;
        if nvl(v_sa_std_pro_tag, 8) > 0
        then
          v_sa_tage := v_sa_tage + 1;
        end if;
        if v_sa_tage > 0
        then
          v_sa_std_durch_tag := v_sa_std / v_sa_tage;
        else
          v_sa_std_durch_tag := nvl(v_sa_std_pro_tag, 8);
        end if;
      end if;
    end LOOP;
    CLOSE c_pzm_schicht_perioden;
    if nvl(v_sa_std_durch_tag, 0) = 0
    then
      OPEN c_pzm_schicht_modell;
      fetch c_pzm_schicht_modell into v_sa_std_durch_tag;
      CLOSE c_pzm_schicht_modell;
      if nvl(v_sa_std_durch_tag, 0) = 0
      then
        v_sa_std_durch_tag := 8;
      end if;
    end if;
    return (v_sa_std_durch_tag);
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Tage sind zur Ermittlung der Anwesenheitstage
  ---------------------------------------------------------------------------------------------

  function get_pers_anw_tage (in_pers_nr       in pzm_personal.pers_nr%type,
                               in_kst_id        in pzm_personal.pers_kst_id%type,
                               in_datum_beg     in date,
                               in_datum_ende    in date
                              )
                            return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select count(t.ts_day_arb_std)
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and (t.ts_day_arb_std > 0 or t.ts_day_ueb_std > 0 or t.ts_day_flex_std > 0);

  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Tage sind zur Ermittlung der Soll-Arbeitstage
  ---------------------------------------------------------------------------------------------

  function get_pers_arb_tage (in_pers_nr       in pzm_personal.pers_nr%type,
                              in_kst_id        in pzm_personal.pers_kst_id%type,
                              in_datum_beg     in date,
                              in_datum_ende    in date
                             )
                            return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select count(t.ts_day_arb_std)
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and (t.ts_day_arb_std > 0
            or (t.ts_day_arb_std = 0
                and exists (select la.lz_konto_name_kurz
                              from pzm_abwesenheitsarten aa,
                                   pzm_lohnarten la
                            where aa.aa_id = t.ts_aa_id
                              and la.lz_id = aa.lz_id
                              and la.lz_konto_name_kurz in ('ZK', 'UK', 'UKS'))
            )
           );
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;
  
  ---------------------------------------------------------------------------------------------
  -- Diese Tage sind zur Ermittlung für den 13 Tage Std-Schnitt
  ---------------------------------------------------------------------------------------------

  function get_pers_arb_std_tage (in_pers_nr       in pzm_personal.pers_nr%type,
                                  in_kst_id        in pzm_personal.pers_kst_id%type,
                                  in_datum_beg     in date,
                                  in_datum_ende    in date
                                 )
                            return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select count(t.ts_day_arb_std)
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and (t.ts_day_arb_std > 0
            or (t.ts_day_arb_std = 0
                and exists (select la.lz_konto_name_kurz
                              from pzm_abwesenheitsarten aa,
                                   pzm_lohnarten la
                            where aa.aa_id = t.ts_aa_id
                              and la.lz_id = aa.lz_id
                              and la.lz_konto_name_kurz = 'ZK')
            )
           );
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind für die Ermittlung der gearbeiteten Stunden
  --     Wenn in_mit_U_K = true, dann ist das die Grundlage für die Ermittlung der Überstunden 
  --     auf Monatsbasis
  ---------------------------------------------------------------------------------------------

  function get_pers_arb_std (in_pers_nr       in pzm_personal.pers_nr%type,
                             in_kst_id        in pzm_personal.pers_kst_id%type,
                             in_datum_beg     in date,
                             in_datum_ende    in date,
                             in_mit_K         in boolean default false,  -- Incl. Krank Stunden
                             in_mit_U         in boolean default false   -- Incl. Urlaub Stunden
                         )
                            return number is
                            
  v_return                  number;
  v_U_stunden               number;
  v_K_stunden               number;
  
  CURSOR c_tagessatz is
    select sum(t.ts_day_arb_std + 
               case when t.ts_ueb_ok_datum is not NULL and t.ts_ueb_storno_datum is NULL
                    then t.ts_day_ueb_std + t.ts_day_flex_std 
                    else 0
                    end
               -
               case when l.lz_operator != 'ARBSTD' and l.lz_operator != 'U' and l.lz_operator != 'SU' and l.lz_operator != 'K' and l.lz_operator != 'KUGK' and l.lz_operator != 'F'  and l.lz_operator != 'UNB'-- Kein Urlaub oder Krank
                    then t.ts_day_abw_std
                    else 0
                    end
               )
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and t.ts_aa_id = a.aa_id(+)
       and a.lz_id = l.lz_id(+);

  CURSOR c_loa_U is
    select sum(t.zeaw_lz_loa_std)
      from PZM_ZE_LOA_AUSW t,
           pzm_lohnarten l
     where t.zeaw_pers_nr = in_pers_nr
       and (nvl(t.zeaw_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.zeaw_datum >= in_datum_beg
       and t.zeaw_datum <= in_datum_ende
       and t.zeaw_lz_id = l.lz_id
       and l.lz_operator in ('U', 'SU');           -- Urlaub

  CURSOR c_tagessatz_K is
    select sum(t.ts_day_abw_std)
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and pzm_utils.ist_feiertag_sqlresult(in_pers_nr => in_pers_nr,
                                            in_pb_id => t.ts_day_pb_id,
                                            in_abt_id => t.ts_day_abt_id,
                                            in_kst_id => t.ts_day_kst_id,
                                            in_datum => t.ts_datum) = 0
       and t.ts_aa_id = a.aa_id
       and a.kennz_urlaub != 'T'           -- Urlaub
       and a.lz_id = l.lz_id(+)
       and l.lz_operator in ('K', 'KUG');
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    if in_mit_U
    then
      OPEN c_loa_U;
      FETCH c_loa_U into v_U_stunden;
      CLOSE c_loa_U;
      v_return := nvl(v_return, 0) + nvl(v_U_stunden, 0);
    end if;
    if in_mit_K
    then
      OPEN c_tagessatz_K;
      FETCH c_tagessatz_K into v_K_stunden;
      CLOSE c_tagessatz_K;
      v_return := nvl(v_return, 0) + nvl(v_K_stunden, 0);
    end if;
    return v_return;
  end;
  
  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn wichtig (Z.B. Feiertage)
  ---------------------------------------------------------------------------------------------
  function get_pers_krank_std (in_pers_nr       in pzm_personal.pers_nr%type,
                               in_kst_id        in pzm_personal.pers_kst_id%type,
                               in_datum_beg     in date,
                               in_datum_ende    in date
                              )
                              return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select sum(t.ts_day_abw_std)
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and t.ts_aa_id = a.aa_id
       and a.lz_id = l.lz_id(+)
       and l.lz_operator in ('K');
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn wichtig (Z.B. Feiertage)
  ---------------------------------------------------------------------------------------------
  function get_pers_krank_tage(in_pers_nr       in pzm_personal.pers_nr%type,
                               in_kst_id        in pzm_personal.pers_kst_id%type,
                               in_datum_beg     in date,
                               in_datum_ende    in date
                              )
                              return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select count(t.ts_day_abw_std)
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and t.ts_aa_id = a.aa_id
       and a.lz_id = l.lz_id(+)
       and l.lz_operator in ('K');
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn wichtig (Z.B. Feiertage)
  ---------------------------------------------------------------------------------------------
  function get_pers_feiertags_std (in_pers_nr       in pzm_personal.pers_nr%type,
                                   in_kst_id        in pzm_personal.pers_kst_id%type,
                                   in_datum_beg     in date,
                                   in_datum_ende    in date
                                  )
                                  return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select sum(t.ts_day_arb_std + t.ts_day_ueb_std + t.ts_day_flex_std)
      from pzm_ze_tagessatz t
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and ist_feiertag_sqlresult(in_pers_nr, get_pers_pb_id(in_pers_nr), get_pers_abt_id(in_pers_nr), get_pers_kst_id(in_pers_nr), t.ts_datum) = 1
       and t.ts_aa_id is NULL;            -- Hier kann es sich nur um Feiertage handeln
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn Kurzarbeitergeld
  ---------------------------------------------------------------------------------------------
  function get_pers_kug_std (in_pers_nr       in pzm_personal.pers_nr%type,
                             in_kst_id        in pzm_personal.pers_kst_id%type,
                             in_datum_beg     in date,
                             in_datum_ende    in date
                            )
                              return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select sum(t.ts_day_abw_std)
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and t.ts_aa_id = a.aa_id
       and a.lz_id = l.lz_id(+)
       and l.lz_operator in ('KUG');
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die ermittlung der Stunden für Stundenlohn Kurzarbeit an Feiertagen
  ---------------------------------------------------------------------------------------------
  function get_pers_kugf_std (in_pers_nr       in pzm_personal.pers_nr%type,
                              in_kst_id        in pzm_personal.pers_kst_id%type,
                              in_datum_beg     in date,
                              in_datum_ende    in date
                             )
                              return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select sum(t.ts_day_abw_std)
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and t.ts_aa_id = a.aa_id
       and a.lz_id = l.lz_id(+)
       and l.lz_operator in ('KUGF');
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  ---------------------------------------------------------------------------------------------
  -- Diese Stunden sind fir die Ermittlung der Zeit-Konten Stundenabbuchung für  die 
  -- Stundenlohnermittlung wichtig
  ---------------------------------------------------------------------------------------------
  function get_pers_zk_std (in_pers_nr       in pzm_personal.pers_nr%type,
                            in_kst_id        in pzm_personal.pers_kst_id%type,
                            in_datum_beg     in date,
                            in_datum_ende    in date
                           )
                           return number is
                            
  v_return                  number;
  
  CURSOR c_tagessatz is
    select sum(t.ts_day_abw_std) - sum(t.ts_day_ueb_std + t.ts_day_flex_std)
      from pzm_ze_tagessatz t,
           pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where t.ts_pers_nr = in_pers_nr
       and (nvl(t.ts_day_kst_id, in_kst_id) = in_kst_id or in_kst_id is NULL)
       and t.ts_datum >= in_datum_beg
       and t.ts_datum <= in_datum_ende
       and t.ts_aa_id = a.aa_id(+)
       and a.lz_id = l.lz_id(+)
       and ((t.ts_day_abw_std > 0 and l.lz_konto_name_kurz = 'ZK')             -- Eine Abwesebheit in Höhe der Differenz zur Schicht wurde gebucht
         or (t.ts_day_ueb_std + t.ts_day_flex_std) > 0);
  
  begin
    OPEN c_tagessatz;
    FETCH c_tagessatz into v_return;
    CLOSE c_tagessatz;
    return v_return;
  end;

  function get_schicht_modell_name(in_pers_nr          in pzm_personal.pers_nr%type,
                              out_schicht_modell_name out pzm_personal.pers_sm_name%type
                             ) return boolean is
                             
  v_return                   boolean;
  v_schicht_modelle          pzm_schicht_modelle%rowtype;

  begin
    out_schicht_modell_name := NULL;
    v_return := pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modelle);
    
    if v_return
    then
      out_schicht_modell_name := v_schicht_modelle.sm_name;
    end if;
    
    return v_return;
  end;


  -- Dummy Routine zum generieren von simuliertem Personal
  -- Achtung nicht auf Produktiv Systemen nutzen!!!
  -- Achtung Buffersize in Test needs Size 300000
  procedure GENERATE_DUMMY_PZM_PERSONAL is
    v_maenner              SIM_V_DATA_HELPER%rowtype;
    v_frauen               SIM_V_DATA_HELPER%rowtype;
    v_nachnamen            SIM_V_DATA_HELPER%rowtype;
    v_max_pers_nr          PZM_PERSONAL.PERS_NR%type;
    
    CURSOR c_max_pers_nr is
      select max(pers_nr) from PZM_PERSONAL;
    CURSOR c_virt_nachnamen IS
      SELECT *
        FROM SIM_V_DATA_HELPER nn
       WHERE nn.data_type = 'MITARBEIER' and nn.data_field = 'NACHNAME';
    CURSOR c_virt_frauennamen IS
      SELECT *
        FROM SIM_V_DATA_HELPER nn
       WHERE nn.data_type = 'MITARBEIER' and nn.data_field = 'VORNAME_FRAU';
    CURSOR c_virt_maennernamen IS
      SELECT *
        FROM SIM_V_DATA_HELPER nn
       WHERE nn.data_type = 'MITARBEIER' and nn.data_field = 'VORNAME_MANN';
    
  begin
    -- Lese grösste Pers_Nr
    open c_max_pers_nr;
    fetch c_max_pers_nr into v_max_pers_nr;
    close c_max_pers_nr;
    open c_virt_nachnamen;
    loop
      fetch c_virt_nachnamen into v_nachnamen;
      exit when c_virt_nachnamen%notfound;
      open c_virt_frauennamen;
      loop
        v_max_pers_nr := v_max_pers_nr + 1;
        fetch c_virt_frauennamen into v_frauen;
        exit when c_virt_frauennamen%notfound;
        insert into PZM_Personal (pers_nr,       pers_anrede,  pers_nname,        pers_vname,         Pers_Land, Pers_Region_Code) 
                                values(v_max_pers_nr, 'Frau',       v_nachnamen.value, v_frauen.value, 'DE', 'DE-NW');
        dbms_output.put_line('insert' || ' ' || to_char(v_max_pers_nr) || ' ' || v_nachnamen.value ||' ' || v_frauen.value);

      end loop; -- frauennamen
      close c_virt_frauennamen;
    end loop; -- nachnahmen
    close c_virt_nachnamen;
    open c_virt_nachnamen;
    loop
      fetch c_virt_nachnamen into v_nachnamen;
      exit when c_virt_nachnamen%notfound;
      open c_virt_maennernamen;
      loop
        v_max_pers_nr := v_max_pers_nr + 1;
        fetch c_virt_maennernamen into v_maenner;
        exit when c_virt_maennernamen%notfound;
        insert into PZM_Personal (pers_nr,       pers_anrede,  pers_nname,        pers_vname,         Pers_Land, Pers_Region_Code) 
                                values(v_max_pers_nr, 'Herr',       v_nachnamen.value, v_maenner.value, 'DE', 'DE-NW');
        dbms_output.put_line('insert' || ' ' || to_char(v_max_pers_nr) || ' ' || v_nachnamen.value ||' ' || v_maenner.value);

      end loop; -- maennernamen
      close c_virt_maennernamen;
    end loop; -- nachnahmen
    close c_virt_nachnamen;
  end GENERATE_DUMMY_PZM_PERSONAL;

  -------------------------------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------------------------------
  function get_standard_schicht_by_pers_nr (in_pers_nr                in pzm_personal.pers_nr%type)
           return varchar2 is
    v_result varchar2(10);
    
    v_schichtmodell    pzm_schicht_modelle%rowtype;
    
    CURSOR c_Schichtarten IS
      SELECT sa.sa_kurzname
        FROM pzm_schichtarten sa
       where sa.sa_standard = 'T'
          or sa.sa_kurzname in ('ST', 'UEB-STD')
      order by decode(sa.calc_basis, v_Schichtmodell.Calc_Basis, 0, 1); -- Korrekte CALC-Basis zuerst.
  begin
    if not pzm_p_base.get_schicht_modell(in_pers_nr, v_Schichtmodell)
    then
      v_Schichtmodell.Calc_Basis := 'GLEITZ'; -- Nichts gefinden, dann gehen wir von Gleitzeit aus
    end if;

    OPEN c_Schichtarten;

    FETCH c_Schichtarten INTO v_result;
    if c_Schichtarten%NOTFOUND then
      v_result := NULL;                       -- Keine Standard-Schichtart gefunden
    end if;

    CLOSE c_Schichtarten;

    return(v_result);
  end;

  -------------------------------------------------------------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------------------------------------------------------
  
  function get_standard_schicht_by_calc_basis (in_calc_basis          in pzm_schichtarten.calc_basis%type) 
    return varchar2 is
    v_result varchar2(10);
    
    CURSOR c_Schichtarten IS
      SELECT sa.sa_kurzname
        FROM pzm_schichtarten sa
       where sa.sa_standard = 'j'
          or sa.sa_kurzname in ('ST', 'UEB-STD')
      order by decode(sa.calc_basis, in_calc_basis, 0, 1); -- Korrekte CALC-Basis zuerst.
  begin

    OPEN c_Schichtarten;
    FETCH c_Schichtarten INTO v_result;
    if c_Schichtarten%NOTFOUND then
      v_result := NULL;                       -- Keine Standard-Schichtart gefunden
    end if;

    CLOSE c_Schichtarten;

    return(v_result);
  end;
  
  function get_feiertag_aa_id  
           return number is
           
  v_aa_id                  pzm_abwesenheitsarten.aa_id%type;
  
  CURSOR c_aa_id is
    select a.aa_id
      from pzm_abwesenheitsarten a,
           pzm_lohnarten l
     where l.lz_operator = 'F'
       and a.lz_id = l.lz_id;
  begin
    OPEN c_aa_id;
    FETCH c_aa_id into v_aa_id;
    if c_aa_id%NOTFOUND
    then
      v_aa_id := NULL;
    end if;
    CLOSE c_aa_id;
    return v_aa_id;
  end;

  function get_feiertag_lz_id  
           return number is
           
  v_lz_id                  pzm_lohnarten.lz_id%type;
  
  CURSOR c_lz_id is
    select l.lz_id
      from pzm_lohnarten l
     where l.lz_operator = 'F';
  begin
    OPEN c_lz_id;
    FETCH c_lz_id into v_lz_id;
    if c_lz_id%NOTFOUND
    then
      v_lz_id := NULL;
    end if;
    CLOSE c_lz_id;
    return v_lz_id;
  end;
  function ist_feiertag_sqlresult(in_pers_nr          in pzm_personal.pers_nr%type,
                                  in_pb_id            in pzm_produktionsbereiche.pb_id%type,
                                  in_abt_id           in pzm_abteilungen.abt_id%type,
                                  in_kst_id           in pzm_personal.pers_kst_id%type,
                                  in_datum            in date) return integer is
  
    v_sonder_feiertag         varchar2(10);
  begin
    return (ist_feiertag(in_pers_nr, in_pb_id, in_abt_id, in_kst_id, in_datum, v_sonder_feiertag));  
  end; 

 ---------------------------------------------------------------------------------------------
  -- Diese Funktion dient zur änderung eine Personalnummer und änder alle Konten und andere 
  -- bewegungsdaten 
  ---------------------------------------------------------------------------------------------
  function chg_pers_nr (in_pers_nr       in pzm_personal.pers_nr%type,
                        in_to_pers_nr    in pzm_personal.pers_nr%type
                        )
                        return varchar2 is
    v_result  varchar2(1);

    v_personal               pzm_personal%rowtype;

    CURSOR c_personal is
      SELECT *
        FROM pzm_personal p
       WHERE p.pers_nr = in_pers_nr;
  begin
    v_result := 'F';

    OPEN c_personal;
    FETCH c_personal INTO v_personal;
    if c_personal%found
    then
      v_result := 'T';
    end if;
    CLOSE c_personal;
    
    -- Hier die Tabelle auf die neue Persnummer wechseln
    v_personal.pers_nr := in_to_pers_nr;
    insert into pzm_personal p
    values v_personal;
    
    begin
      update bde_pd_kopf t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update bde_pd_kopf_ma t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update bde_pd_pers_zeit_kst t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update bde_pd_prod t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update bde_pd_rueckverfolgung t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update isi_contact t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update isi_resource_zust_akt t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update isi_scan_log t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    begin
      update s_send_bew t
         set t.pers_nr = in_to_pers_nr
       where t.pers_nr = in_pers_nr;
    exception
      when others then NULL;
    end;
    delete isi_user t
     where t.pers_nr = in_to_pers_nr;
    delete pzm_konten t
     where t.pers_nr = in_to_pers_nr; 
    update isi_user t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_abt_leitung t
       set t.abt_l_pers_nr = in_to_pers_nr
     where t.abt_l_abt_id = in_pers_nr;
    update pzm_abwesenheits_antr t
       set t.au_pers_nr = in_to_pers_nr
     where t.au_pers_nr = in_pers_nr;
    update pzm_abwesenheits_antr t
       set t.au_pruef_pers_nr = in_to_pers_nr
     where t.au_pruef_pers_nr = in_pers_nr;
    update pzm_abwesenheits_antr t
       set t.au_vertreter = in_to_pers_nr
     where t.au_vertreter = in_pers_nr;
    update pzm_abwesenheitsmeldungen t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_abwesenheitsmeldungen t
       set t.erz_pers_nr = in_to_pers_nr
     where t.erz_pers_nr = in_pers_nr;
    update pzm_abwesenheitsmeldungen t
       set t.aend_pers_nr = in_to_pers_nr
     where t.aend_pers_nr = in_pers_nr;
    update pzm_abwes_plan t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_azubi_daten t
       set t.ad_pers_nr = in_to_pers_nr
     where t.ad_pers_nr = in_pers_nr;
    update pzm_abwes_plan t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_konten t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_konten_bh t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_pers_lohn_zulagen t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_azk_urlaub t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_bde_zeiten t
       set t.ze_bde_pers_nr = in_to_pers_nr
     where t.ze_bde_pers_nr = in_pers_nr;
    update pzm_zeiterfassung t
       set t.ze_pers_nr = in_to_pers_nr
     where t.ze_pers_nr = in_pers_nr;
    update pzm_konten t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_konten_bh t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_loa_ausw t
       set t.zeaw_pers_nr = in_to_pers_nr
     where t.zeaw_pers_nr = in_pers_nr;
    update pzm_ze_loa_exp_host t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_loa_statistik_exp_host t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_loa_13w_schnitt t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_pers_kst_monat_ab t
       set t.pers_nr = in_to_pers_nr
     where t.pers_nr = in_pers_nr;
    update pzm_ze_tagessatz t
       set t.ts_pers_nr = in_to_pers_nr
     where t.ts_pers_nr = in_pers_nr;
    delete pzm_personal t
     where t.pers_nr = in_pers_nr;
    commit;
    return(v_result);
  end;

  /* 
   * Result-Cached Version of GET_PERS_KST_ID()
   * If KST_ID for IN_PERS_NR has been queried 
   */ 
  
  function pb_GET_PERS_KST_ID(in_pers_nr in  pzm_personal.pers_nr%type
                          ) return number is    
    Result number;  
  begin
    if g_pers_kst_id_cache.exists (in_pers_nr) then
      if systimestamp - g_pers_kst_id_cache(in_pers_nr).cached_at < gc_pers_kst_id_ttl then
        Result := g_pers_kst_id_cache(in_pers_nr).kst_id;
      end if;
    end if;
    
    if Result is NULL then
      select nvl(nvl(p.pers_kst_id, a.abt_kst_id), pb.pb_kst_id) into Result
        from pzm_personal p,
             pzm_abteilungen a,
             pzm_produktionsbereiche pb
       where p.pers_nr = in_pers_nr
         and p.pers_abt_id = a.abt_id(+)
         and pb.pb_id = nvl(p.pers_pb_id, a.abt_pb_id);
         
      g_pers_kst_id_cache(in_pers_nr).kst_id := Result;
      g_pers_kst_id_cache(in_pers_nr).cached_at := systimestamp;
    end if;
    
    return(Result);
  exception
    when others then
      return(NULL);
  end pb_GET_PERS_KST_ID;  
 
  
end;
/



-- sqlcl_snapshot {"hash":"22a7d0ae90b948d65eba83bca10b2deef4230c78","type":"PACKAGE_BODY","name":"PZM_UTILS","schemaName":"DIRKSPZM32","sxml":""}