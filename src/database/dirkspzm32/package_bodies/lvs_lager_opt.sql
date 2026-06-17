create or replace 
package body DIRKSPZM32.lvs_lager_opt is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations


  -------------------------------------------------------------------------
  Function LVS_LORT_FORMAT(in_lo_a in varchar2) return varchar2 is
    -------------------------------------------------------------------------
    -- [02;01;] && [03;01] = [01;]
    v_error EXCEPTION;
    v_lo varchar2(255);
  BEGIN
    -- Falls nicht schon geschehen erst mal vormatieren!!!
    v_lo := lvs_prod.STR_MB_FORMAT(in_lo_a,
                                   c.LORT_TRENNER,
                                   c.LORT_FORMAT,
                                   c.LORT_LAENGE);
    return(v_lo);
  END LVS_LORT_FORMAT;
  -------------------------------------------------------------------------

  -------------------------------------------------------------------------
  Function LVS_LORT_LOG_UND(in_lo_a  in varchar2,
                            in_lo_b  in varchar2,
                            out_lo_e out varchar2) return varchar2 is
    -------------------------------------------------------------------------
    -- [02;01;] && [03;01] = [01;]
    v_error EXCEPTION;
    --v_err_nr     number;
    --v_err_text   varchar2(255);
    v_lo   varchar2(255);
    v_lo_a varchar2(255);
    v_lo_b varchar2(255);
  BEGIN
    -- Falls nicht schon geschehen erst mal vormatieren!!!

    v_lo_a   := lvs_prod.STR_MB_FORMAT(in_lo_a,
                                       c.LORT_TRENNER,
                                       c.LORT_FORMAT,
                                       c.LORT_LAENGE);
    v_lo_b   := lvs_prod.STR_MB_FORMAT(in_lo_b,
                                       c.LORT_TRENNER,
                                       c.LORT_FORMAT,
                                       c.LORT_LAENGE);
    v_lo     := lvs_prod.STR_MB_LOG_UND(V_lo_a, v_lo_b, c.LORT_LAENGE);
    out_lo_e := v_lo;
    return(v_lo);
  END LVS_LORT_LOG_UND;
  -------------------------------------------------------------------------
  function LVS_LORT_COUNT(in_lo in varchar2) return number is
    -------------------------------------------------------------------------
    -- in_lo 02;03;01 = 3

    v_count number;
  BEGIN
    v_count := lvs_prod.STR_MB_COUNT(in_lo, c.LORT_LAENGE);
    return(v_count);
  END LVS_LORT_COUNT;

  -------------------------------------------------------------------------
  Function LVS_LORT_IX(in_str_a in varchar2, in_position in number)
    return lvs_lgr.lgr_ort%TYPE is
    -------------------------------------------------------------------------
    -- 01;03;02; laenge = 3 Position = 2 --> Return(03;)
    v_lo varchar2(255);
  BEGIN
    v_lo := lvs_prod.STR_MB_IX(in_str_a, c.LORT_LAENGE, in_position);
    -- das letzte simikplon wird abgeschnitten
    v_lo := substr(v_lo, 1, length(v_lo) - 1);
    return(to_number(v_lo));
  END;

  -------------------------------------------------------------------------
  Procedure LVS_KANAL_KONTROLLE(in_lte in lvs_lte%ROWTYPE,
                                in_lgr in lvs_lgr%ROWTYPE)
  -------------------------------------------------------------------------

   as
    v_sum_akt_te   number;
    v_sum_dispo_te number;
    v_lgr_einl_te_verfueg_gruppe       lvs_lgr.lgr_einl_te_verfueg_gruppe%type;

    v_res          lvs_lgr.res_string%TYPE;
    v_res_art      lvs_lgr.res_artikel_id%type;
    v_lgr          lvs_lgr%ROWTYPE;
    v_lte_typen    varchar2(80);
    v_tiefe_platz_von    lvs_lgr.lgr_dim_t%type;
    v_tiefe_platz_bis    lvs_lgr.lgr_dim_t%type;

    v_max_dim_fifo       lvs_lgr.lgr_dim_fifo_nr%type;
    v_anz_i_max          number;
    v_anz_i              number;
    v_anz_i_geteilt      number;
    v_anz_i_first        number;
    v_anz_i_delta        number;
    v_anz_plaetze_gruppe number;

    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_lam                lvs_lam%rowtype;
    v_lte                lvs_lte%rowtype;

    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    CURSOR c_LagerGruppe_Leer IS
      Select sum(LGR_AKT_TE), sum(LGR_dispo_einl_TE)
        from lvs_lgr lgr
       where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
         and   ((lgr.lgr_dim_g = in_lgr.lgr_dim_g
            and lgr.lgr_dim_r = in_lgr.lgr_dim_r
            and lgr.lgr_dim_p = in_lgr.lgr_dim_p
            and lgr.lgr_dim_e = in_lgr.lgr_dim_e)
          or  ( lgr.lgr_typ != c.SEG1
            and lgr.lgr_typ != c.SEG_DUEDO1))
       group by lgr.lgr_platz_gruppe;

    CURSOR c_LagerGruppe IS
      Select sum(lgr_einl_te_verfueg), max(lgr.lgr_dim_fifo_nr)
        from lvs_lgr lgr
       where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
       group by lgr.lgr_platz_gruppe;

    CURSOR c_LagerGruppe_Leer_seg IS
      Select sum(LGR_AKT_TE), sum(LGR_dispo_einl_TE)
        from lvs_lgr lgr
       where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
       group by lgr.lgr_platz_gruppe;

    CURSOR c_LagerGruppe_letzter IS
      Select *
        from lvs_lgr lgr
       where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
         and   ((lgr.lgr_dim_g = in_lgr.lgr_dim_g
            and lgr.lgr_dim_r = in_lgr.lgr_dim_r
            and lgr.lgr_dim_p = in_lgr.lgr_dim_p
            and lgr.lgr_dim_e = in_lgr.lgr_dim_e)
          or  ( lgr.lgr_typ != c.SEG1
            and lgr.lgr_typ != c.SEG_DUEDO1))
         and (lgr.lgr_akt_te > 0 or lgr.lgr_dispo_einl_te > 0)
         and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
         and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
       order by lgr.lgr_dim_platz desc;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;

    CURSOR c_lgr_gruppe is
      select count(t.lgr_platz)
        from lvs_lgr t
       where t.sid = in_lgr.sid
         and t.firma_nr = in_lgr.firma_nr
         and t.lgr_ort = in_lgr.lgr_ort
         and t.lgr_typ = c.KANAL1
         and t.lgr_dim_g = in_lgr.lgr_dim_g
         and t.lgr_dim_r = in_lgr.lgr_dim_r
         and t.lgr_dim_p = in_lgr.lgr_dim_p
         and t.lgr_dim_e = in_lgr.lgr_dim_e
       group by t.gruppe
       order by t.gruppe;
  BEGIN
    -- Für die kanalkontrolle wird beim Palletieren die Ziel LTE  benötigt
    if in_lte.lte_id like 'LTE_VL%'  -- Wenn Virtuelle LTE (Palletieren)
    then
      if lvs_p_base.get_lam_by_lte_id(in_lte.sid, in_lte.firma_nr, in_lte.lte_id, v_lam) -- Dann einzige LAM lesen
      then 
        if not lvs_p_base.get_lte(v_lam.res_ziel_lte_id, v_lte) -- Mit dieser wird dann die Ziel_LTE gelesen
        then
          v_lte := in_lte;
        end if;
      else
        return;
      end if;
    else
      v_lte := in_lte;
    end if;  
  
    v_tiefe_platz_von := NULL;
    v_tiefe_platz_bis := NULL;
    if in_lgr.res_res_string_statisch = c.C_TRUE then
      v_res := in_lgr.res_string;
    else
      v_res := NULL;
    end if;

    if in_lgr.res_art_statisch = C.C_TRUE then
      v_res_art := in_lgr.res_artikel_id;
    else
      v_res_art := NULL;
    end if;

    -- Erst malaus der Übergabe nehmen
    v_lgr := in_lgr;
    if (in_lgr.lgr_typ = c.SEG_DUEDO1)
    then
      if mod(in_lgr.lgr_dim_t, 2) = 1
      then
        v_tiefe_platz_von := in_lgr.lgr_dim_t;
        v_tiefe_platz_bis := in_lgr.lgr_dim_t + 1;
      else
        v_tiefe_platz_von := in_lgr.lgr_dim_t - 1;
        v_tiefe_platz_bis := in_lgr.lgr_dim_t;
      end if;
    end if;

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    if instr(nvl(in_lgr.lte_namen_cfg, v_basis_lte_name), v_basis_lte_name) = 0 
    then
      v_basis_lte_name := v_lte.lte_name;
    end if;
    OPEN c_Lagergruppe;
    FETCH c_Lagergruppe
      INTO v_lgr_einl_te_verfueg_gruppe, v_max_dim_fifo;
    CLOSE c_Lagergruppe;

    OPEN c_Lagergruppe_leer;
    FETCH c_Lagergruppe_leer
      INTO V_Sum_Akt_Te, V_Sum_Dispo_te;
    CLOSE c_Lagergruppe_leer;
    -- In der Gruppe (Kanal) ist noch ein Platz besetzt, oder ein Blocklager ist nicht leer
    if (v_sum_akt_te != 0) or (v_sum_dispo_te != 0) then
      -- Der Aktuelle Platz ist jedoch jetzt leer und nicht disponiert
      if in_lgr.lgr_akt_te = 0 and in_lgr.lgr_dispo_einl_te = 0 then
        -- dann den letzten besetzten als referenz für der res_string nehmen
        OPEN c_LagerGruppe_letzter;
        FETCH c_LagerGruppe_letzter
          into v_lgr; -- Holen des letzten gefüllten Eintrags
        if c_LagerGruppe_letzter%NOTFOUND then
          v_lgr := in_lgr;
        end if;
        if in_lgr.res_res_string_statisch = c.C_FALSE then
          v_res := v_lgr.res_string;
        end if;
        CLOSE c_LagerGruppe_letzter;
      else
        if in_lgr.res_res_string_statisch = c.C_FALSE
        then
          v_res := in_lte.res_string;
          -- -AG- Lager ist Vorbereitungslager für die Verladung
          if in_lgr.lgr_res_strat = 'O'
          then
            v_res := nvl(to_char(in_lte.transport_gruppe), in_lte.res_string);
          end if;
        end if;
      end if;
    end if;

    -- -AG- 16.04.2012 Neuer Lagertyp STAP_FLAE1 Fläche im Lager zum Stapeln von Platten
    if  (in_lgr.lgr_typ <> c.SAT1)
    and (in_lgr.lgr_typ <> c.KANAL1)
    and (in_lgr.lgr_typ <> c.KANAL_BKL1)
    and (in_lgr.lgr_typ <> c.DURCHL1)
    and (in_lgr.lgr_typ <> c.REG_FACH1)
    and (in_lgr.lgr_typ <> c.SAT_EPL1)
    and (in_lgr.lgr_typ <> c.SAT_EPL2)
    and (in_lgr.lgr_typ <> c.SEG1)
    and (in_lgr.lgr_typ <> c.SEG_DUEDO1)
    and (in_lgr.lgr_typ <> c.PP_EPL1)
    and (in_lgr.lgr_typ <> c.STAP_FLAE1)
    and (in_lgr.lgr_typ <> c.STAP_FLAE2)
    then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Ist nun wieder leer alles rücksetzen oder auf STATISCHE Werte
        if in_lgr.res_art_statisch = C.C_FALSE then
          Update lvs_lgr
             set res_string              = NULL,
                 res_res_string_statisch = c.C_FALSE,
                 res_artikel_id          = NULL,
                 lgr_einl_te_verfueg_gruppe
                                         = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;
        end if;
      else
        Update lvs_lgr
           set res_string = v_res,
               res_res_string_statisch = c.C_FALSE,
                 lgr_einl_te_verfueg_gruppe
                                       = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr;
      end if;
      return; -- hier ist nichts mehr zu tun
    end if;

    if (in_lgr.lgr_typ = c.SAT1)
    or (in_lgr.lgr_typ = c.KANAL1)
    then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        Update lvs_lgr
           set LTE_NAMEN      = LTE_NAMEN_CFG,
               res_string     = v_res,
               res_artikel_id = v_res_art,
               lgr_einl_te_verfueg_gruppe
                                       = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;
      else
        v_anz_i_delta := 0;
        if (in_lgr.lgr_typ = c.KANAL1)
        then
          OPEN c_lgr_gruppe;
          FETCH c_lgr_gruppe into v_anz_plaetze_gruppe;
          CLOSE c_lgr_gruppe;

          v_anz_i_geteilt := round((V_anz_plaetze_gruppe / 2 * 8 / 10) - 0.5, 0) * 2;
          v_anz_i_max := round((V_anz_plaetze_gruppe * 8 / 10) - 0.5, 0);
          v_anz_i_first := round((V_anz_plaetze_gruppe / 2) - 0.5, 0) - round((v_anz_i_geteilt / 2) - 0.5, 0);

          if v_max_dim_fifo > v_anz_i_max
          then
            v_anz_i_delta := v_anz_i_first;
          end if;
        end if;
        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
        if v_basis_lte_name = c.Euro
        or v_basis_lte_name = c.EuroK
        or v_basis_lte_name = c.EuroKH1
        or v_basis_lte_name = c.ChepEuro
        then
          if c.LteTypenMischen = 1
          then
            v_lte_typen := '';
            if in_lgr.lte_namen_cfg like ('%' || c.Euro || c.TE_TRENNER || '%')
            then
              v_lte_typen := c.Euro || c.TE_TRENNER;
            end if;
            if in_lgr.lte_namen_cfg like ('%' || c.EuroK || c.TE_TRENNER || '%')
            then
              v_lte_typen := v_lte_typen || c.EuroK || c.TE_TRENNER;
            end if;
            if in_lgr.lte_namen_cfg like ('%' || c.EuroKH1 || c.TE_TRENNER || '%')
            then
              v_lte_typen := v_lte_typen || c.EuroKH1 || c.TE_TRENNER;
            end if;
            if in_lgr.lte_namen_cfg like ('%' || c.ChepEuro || c.TE_TRENNER || '%')
            then
              v_lte_typen := v_lte_typen || c.ChepEuro || c.TE_TRENNER;
            end if;
          else
           v_lte_typen := v_basis_lte_name || c.TE_TRENNER;
          end if;
          Update lvs_lgr
             set LTE_NAMEN      = v_lte_typen,
                 res_string     = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr;
        end if;
        if v_basis_lte_name = c.Indu
        or v_basis_lte_name = c.ChepIndu
        then
          if c.LteTypenMischen = 1
          then
            v_lte_typen := '';
            if in_lgr.lte_namen_cfg like ('%' || c.Indu || c.TE_TRENNER || '%')
            then
              v_lte_typen := c.Indu || c.TE_TRENNER;
            end if;
            if in_lgr.lte_namen_cfg like  ('%' || c.ChepIndu || c.TE_TRENNER || '%')
            then
              v_lte_typen := v_lte_typen || c.ChepIndu || c.TE_TRENNER;
            end if;
          else
           v_lte_typen := v_basis_lte_name || c.TE_TRENNER;
          end if;
          Update lvs_lgr
             set LTE_NAMEN      = v_lte_typen,
                 res_string     = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr
             and lgr_dim_fifo_Nr <= lvs_lgr.hrl_lag_max_pal_I + v_anz_i_delta;
          Update lvs_lgr
             set LTE_NAMEN = 'Keine',
                 res_string = null,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and ( lgr_dim_fifo_Nr <= v_anz_i_delta
                 or lgr_dim_fifo_Nr > lvs_lgr.hrl_lag_max_pal_I + v_anz_i_delta);
        end if;
        if v_basis_lte_name != c.Euro
        and v_basis_lte_name != c.EuroK
        and v_basis_lte_name != c.EuroKH1
        and v_basis_lte_name != c.ChepEuro
        and v_basis_lte_name != c.Indu
        and v_basis_lte_name != c.ChepIndu
        then
          v_lte_typen := v_basis_lte_name || c.TE_TRENNER;
          Update lvs_lgr
             set LTE_NAMEN      = v_lte_typen,
                 res_string     = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and (lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr or
                  lvs_lgr.lgr_dim_fifo_nr > (select max(x.lgr_dim_fifo_nr)
                                               from lvs_lgr x
                                              where x.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                                                and x.lgr_akt_te > 0));
        end if;
        Update lvs_lgr
           set LTE_NAMEN = 'Keine',
               res_string = null,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and (lvs_lgr.lgr_dim_fifo_Nr < (select max(x.lgr_dim_fifo_Nr)
                                             from lvs_lgr x
                                            Where x.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                                              and (x.lgr_akt_te > 0
                                                /* Falsch, heir werden Lücken gezogen, wenn 
                                                   Paletten ausgelagert werden und beites weitere 
                                                   zu diesem Kanal disponiert sind
                                                or x.lgr_dispo_einl_te > 0 */ ))
               --or
               --lvs_lgr.lgr_dim_fifo_Nr < in_lgr.lgr_dim_fifo_nr
               )
           and lvs_lgr.lgr_akt_te = 0
           and lvs_lgr.lgr_dispo_einl_te = 0;
      end if; -- v_Sum_akt_te
      -- ENDE c_sat_1
    elsif (in_lgr.lgr_typ = c.SEG1) then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        Update lvs_lgr
           set res_string     = v_res,
               res_artikel_id = v_res_art,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr
           and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e;
        OPEN c_LagerGruppe_Leer_seg;
        FETCH c_Lagergruppe_leer_seg
          INTO V_Sum_Akt_Te, V_Sum_Dispo_te;
        CLOSE c_Lagergruppe_leer_seg;
        if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
          Update lvs_lgr
             set LTE_NAMEN      = LTE_NAMEN_CFG,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;
        end if;
      else
        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
        v_lte_typen := v_basis_lte_name || c.TE_TRENNER;
        Update lvs_lgr
           set LTE_NAMEN      = v_lte_typen,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lte_namen_cfg like ('%' || v_basis_lte_name || c.TE_TRENNER || '%');
        Update lvs_lgr
           set LTE_NAMEN      = 'Keine',
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lte_namen not like ('%' || v_basis_lte_name || c.TE_TRENNER || '%');

        Update lvs_lgr
           set LTE_NAMEN = 'Keine',
               res_string = null,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e
           and (lvs_lgr.lgr_dim_fifo_Nr < (select max(x.lgr_dim_fifo_Nr)
                                             from lvs_lgr x
                                            Where x.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                                              and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
                                              and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
                                              and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
                                              and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e
                                              and (x.lgr_akt_te > 0
                                                /* Falsch, heir werden Lücken gezogen, wenn 
                                                   Paletten ausgelagert werden und beites weitere 
                                                   zu diesem Kanal disponiert sind
                                                or x.lgr_dispo_einl_te > 0 */ ))
               or
               lvs_lgr.lgr_dim_fifo_Nr < in_lgr.lgr_dim_fifo_nr
               )
           and lvs_lgr.lgr_akt_te = 0
           and lvs_lgr.lgr_dispo_einl_te = 0;

        Update lvs_lgr
           set res_string     = nvl(v_res, res_string),
               res_artikel_id = nvl(v_res_art, res_artikel_id)
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr
           and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e;

      end if; -- v_Sum_akt_te
    elsif (in_lgr.lgr_typ = c.SEG_DUEDO1)
    then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        -- Hier werden Einträge für eien Paltz korrekt Zurückgesetzt
        Update lvs_lgr
           set res_string     = v_res,
               res_artikel_id = v_res_art,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr
           and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e;

        Update lvs_lgr lgr
           set LTE_NAMEN      = LTE_NAMEN_CFG,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lgr.lgr_dim_e = in_lgr.lgr_dim_e
           and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
           and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
           and mod(lgr.lgr_dim_t, 2) = 1;
        Update lvs_lgr lgr
           set LTE_NAMEN      = 'Keine',
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lgr.lgr_dim_e = in_lgr.lgr_dim_e
           and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
           and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
           and mod(lgr.lgr_dim_t, 2) = 0;

        OPEN c_LagerGruppe_Leer_seg;
        FETCH c_Lagergruppe_leer_seg
          INTO V_Sum_Akt_Te, V_Sum_Dispo_te;
        CLOSE c_Lagergruppe_leer_seg;
        -- Ist das ganze Segment leer, dann das ganze Segment abschließen
        if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
          Update lvs_lgr
             set LTE_NAMEN      = LTE_NAMEN_CFG,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and mod(lvs_lgr.lgr_dim_t, 2) = 1;
          Update lvs_lgr
             set LTE_NAMEN      = 'Keine',
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and mod(lvs_lgr.lgr_dim_t, 2) =  0;
        end if;
        -- Ende -- Hier werden Einträge für eien Paltz und Segment korrekt Zurückgesetzt
      else

        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
        -- Erst mal die Einträge für den Platz setzen !!
        v_lte_typen := v_basis_lte_name || c.TE_TRENNER;
        Update lvs_lgr lgr
           set LTE_NAMEN      = v_lte_typen,
               res_string     = nvl(v_res, res_string),
               res_artikel_id = nvl(v_res_art, res_artikel_id),
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr.lgr_dim_g = in_lgr.lgr_dim_g
           and lgr.lgr_dim_r = in_lgr.lgr_dim_r
           and lgr.lgr_dim_p = in_lgr.lgr_dim_p
           and lgr.lgr_dim_e = in_lgr.lgr_dim_e
           and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
           and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t);
        if v_lte_typen = c.DueDo || c.TE_TRENNER
        then
          v_lte_typen := v_lte_typen || c.Euro || c.TE_TRENNER;
        else
          Update lvs_lgr lgr
             set LTE_NAMEN      = 'Keine',
                 res_string     = nvl(v_res, res_string),
                 res_artikel_id = nvl(v_res_art, res_artikel_id),
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           where lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and lgr.lgr_dim_g = in_lgr.lgr_dim_g
             and lgr.lgr_dim_r = in_lgr.lgr_dim_r
             and lgr.lgr_dim_p = in_lgr.lgr_dim_p
             and lgr.lgr_dim_e = in_lgr.lgr_dim_e
             and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
             and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
             and mod(lgr.lgr_dim_t, 2) = 0;
          if v_lte_typen = c.Euro || c.TE_TRENNER
          then
            v_lte_typen := v_lte_typen || c.DueDo || c.TE_TRENNER;
          end if;
        end if;

        Update lvs_lgr
           set LTE_NAMEN      = 'Keine',
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lte_namen_cfg not like ('%' || v_basis_lte_name || '%')
           and mod(lgr_dim_t, 2) = 1;

        Update lvs_lgr
           set LTE_NAMEN      = v_lte_typen,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lte_namen      != c.DueDo || c.TE_TRENNER
           and lte_namen_cfg like ('%' || v_basis_lte_name || '%')
           and mod(lgr_dim_t, 2) = 1;

        Update lvs_lgr
           set LTE_NAMEN      = 'Keine',
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lte_namen      != c.DueDo || c.TE_TRENNER
           and lte_namen_cfg not like ('%' || v_basis_lte_name || c.TE_TRENNER || '%')
           and mod(lgr_dim_t, 2) = 0;

      end if; -- v_Sum_akt_te
    elsif (in_lgr.lgr_typ = c.SAT_EPL1)
       or (in_lgr.lgr_typ = c.SAT_EPL2)
    then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        if in_lgr.res_res_string_statisch = c.C_FALSE or
           in_lgr.res_art_statisch = C.C_FALSE then
          Update lvs_lgr
             set LTE_NAMEN      = LTE_NAMEN_CFG,
                 res_string     = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;
        end if;
      else
        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
        if v_basis_lte_name = c.Euro then
          Update lvs_lgr
             set LTE_NAMEN      = c.Euro || c.TE_TRENNER,
                 res_string     = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

        end if;
        if v_basis_lte_name = c.Indu then
          Update lvs_lgr
             set LTE_NAMEN      = c.Indu || c.TE_TRENNER,
                 res_string     = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and lgr_dim_fifo_Nr <= lvs_lgr.hrl_lag_max_pal_I;
          Update lvs_lgr
             set LTE_NAMEN = 'Keine', res_string = null
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
             and lgr_dim_fifo_Nr > lvs_lgr.hrl_lag_max_pal_I;
        end if;
      end if; -- v_Sum_akt_te
      -- ENDE c_sat_EPL1 c.SAT_EPL2
    elsif (in_lgr.lgr_typ in (c.KANAL1, c.KANAL_BKL1, c.REG_FACH1, c.STAP_FLAE1, c.STAP_FLAE2)) then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        if in_lgr.res_res_string_statisch = c.C_FALSE or
           in_lgr.res_art_statisch = C.C_FALSE then
          Update lvs_lgr
             set res_string = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;
        end if;
      else
        -- Die naechste TE ist im Kanal, oder dahin unterwegs also Reservierung setzen
        Update lvs_lgr
           set res_string = v_res,
               res_artikel_id = v_res_art,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr;
      end if; -- v_Sum_akt_te
    elsif (in_lgr.lgr_typ in (c.DURCHL1)) then
      if (v_sum_akt_te = 0) and (v_sum_dispo_te = 0) then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        if in_lgr.res_res_string_statisch = c.C_FALSE or
           in_lgr.res_art_statisch = C.C_FALSE then
          Update lvs_lgr
             set res_string = v_res,
                 res_artikel_id = v_res_art,
                 lgr_einl_te_verfueg_gruppe
                                = v_lgr_einl_te_verfueg_gruppe
           Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;
        end if;
      else
        -- Die naechste TE ist im Kanal, oder dahin unterwegs also Reservierung setzen
        Update lvs_lgr
           set res_string = v_res,
               res_artikel_id = v_res_art,
               lgr_einl_te_verfueg_gruppe
                              = v_lgr_einl_te_verfueg_gruppe
         Where lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
           and lgr_dim_fifo_Nr >= in_lgr.lgr_dim_fifo_nr;
      end if; -- v_Sum_akt_te
    end if; -- c_sat_1
  END LVS_KANAL_KONTROLLE;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Verladung
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
  procedure c_kompress(in_sid                in     isi_sid.sid%type,
                       in_firma_nr           in     isi_firma.firma_nr%type,
                       in_lgr_ort            in     lvs_lgr_ort.lgr_ort%type,
                       in_lgr_platz_grp      in     varchar2,
                       in_modul_erzeuger     in     isi_transport.modul_erzeuger%type,
                       in_modul_bearbeiter   in     isi_transport.modul_bearbeiter%type,
                       in_login_id           in     isi_user.login_id%type
                    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
    v_error     EXCEPTION;
    v_err_nr    number;
    v_err_text  varchar2(4096);

    -- -AG- Fehler: Der Lagerplatz darf immer nur in der gleichen Lagerplatz_GRP sein
    v_platz_gruppe      lvs_lgr.lgr_platz_gruppe%type;
    v_lgr_ort           lvs_lgr.lgr_ort%type;
    v_lgr_ort_grp       lvs_lgr.lgr_gruppe_id%type;

    v_lgr_platz         lvs_lgr.lgr_platz%type;
    v_lte_id            lvs_lte.lte_id%type;
    v_wtyp              lvs_lte.waren_typ%type;
    v_anz_lhm           number;
    v_res_string        lvs_lte.res_string%type;
    v_res_artikel_id    lvs_lte.res_artikel_id%type;
    v_min_art_id        isi_artikel.artikel_id%type;
    v_max_art_id        isi_artikel.artikel_id%type;
    v_res_mhd           lvs_lte.res_mhd%type;
    v_min_mhd           lvs_lam.lam_mhd%type;
    v_max_mhd           lvs_lam.lam_mhd%type;
    v_min_prod_dat      lvs_lam.prod_datum%type;
    v_lte_name          lvs_lte.lte_name%type;
    v_lgr_regal         lvs_lgr.lgr_dim_r%type;
    v_lgr_hoehe         lvs_lgr.lgr_vol_hoehe%type;

    v_grp_lgr_platz_gruppe  lvs_lgr.lgr_platz_gruppe%type;
    v_grp_frei_platz_Te     number;
    v_grp_res_string        lvs_lte.res_string%type;
    v_tr_id                 number;
    v_ret                   number;
    v_pos_s                 number;

    v_ziel_platz            lvs_lgr.lgr_platz%type;
    v_transport_gruppe       isi_transport.transport_gruppe%type;

    v_found     boolean;                                  -- Daten gefunden

    CURSOR c_lgr_platz_lte_bestand is
      select min(lgr.lgr_platz_gruppe) platz_gruppe,
             lte.lgr_platz,
             lte.lte_id,
             min(lte.waren_typ) wtyp,
             max(lte.lte_akt_lhm) anz_lhm,
             lte.res_string,
             lte.res_artikel_id,
             min(lam.artikel_id) min_art_id,
             min(lam.artikel_id) max_art_id,
             lte.res_mhd,
             min(lam.lam_mhd) min_mhd,
             max(lam.lam_mhd) max_mhd,
             trunc(min(lam.prod_datum)) min_prod_dat,
             nvl(lte_cfg.basis_lte_name, min(lte.lte_name)) basis_lte_name,
             lgr.lgr_ort,
             lgr.lgr_gruppe_id,
             lgr.lgr_dim_r,
             max(lgr.lgr_vol_hoehe)
       from lvs_lgr lgr,
            lvs_lte lte,
            lvs_lte_cfg lte_cfg,
            lvs_lam lam
       where (in_lgr_platz_grp like (lgr.lgr_platz_gruppe || ';%')
           or in_lgr_platz_grp like ('%;' || lgr.lgr_platz_gruppe || ';%'))
         and lgr.lgr_platz = lte.lgr_platz
         and lte.lte_id = lam.lte_id
         and lte_cfg.sid = lte.sid
         and lte_cfg.firma_nr = lte.firma_nr
         and lte_cfg.lte_name = lte.lte_name
         and lte.lgr_ort = in_lgr_ort
       group by lte.lgr_platz,
                lte.lte_id,
                lgr.lgr_dim_fifo_nr,
                lte.res_string,
                lte.res_artikel_id,
                lte.res_mhd,
                lgr.lgr_ort,
                lgr.lgr_gruppe_id,
                basis_lte_name,
                lgr.lgr_dim_r
       order by platz_gruppe,
                lgr.lgr_dim_fifo_nr desc;

      -- AG Anpassung für kanal-lager (SAT-Lager mit dynamischer Tiefe Erster Platz ist dann nicht = LGR-PLATZ-GRP)
      CURSOR c_lgr_platz_grp is
        Select lgr_platz_gruppe,
               sum(max_te) - sum(akt_te) frei_platz_Te,
               decode(min(res_string), max(res_string), min(res_string), 
                      decode(min(substr(res_string, 1, v_pos_s)), max(substr(res_string, 1, v_pos_s)), min(substr(res_string, 1, v_pos_s)), 'Mischkanal')) res_string
          from (select sum (lgr.lgr_akt_te) akt_te,
                       sum(lgr.lgr_max_te) max_te,
                       --sum(lgr.lgr_einl_te_verfueg),
                       decode (sum (lgr.lgr_max_te)- sum(lgr.lgr_akt_te), 0, 'V',
                           decode (sum (lgr.lgr_max_te)- sum(lgr.lgr_einl_te_verfueg), 0, 'L', 'A')) Kanal,
                       sum (lgr.lgr_max_te)- sum(lgr.lgr_akt_te + lgr.lgr_dispo_einl_te)  voll_0,
                       sum (lgr.lgr_max_te)- sum(lgr.lgr_einl_te_verfueg) leer_0,
                       lgr.lgr_platz_gruppe,
                       sum(lgr.lgr_dispo_ausl_te) lgr_dispo_ausl_te,
                       sum(lgr.lgr_dispo_einl_te) lgr_dispo_einl_te,
                       decode(min(lgr.res_string), max(lgr.res_string), min(lgr.res_string), 'Mischkanal') res_string,
                       sum(decode(nvl(lte.order_vorgang_id, 0), 0, 0, 1)) vorg_id,
                       min(lgr.lte_namen) lte_namen,
                       lgr.uml_erlaubt,
                       lgr.lgr_dim_r,
                       min(lgr.lgr_vol_hoehe) lgr_vol_hoehe
                  from lvs_lgr lgr, 
                       lvs_lte lte,
                       lvs_lgr lte_lgr,
                       lvs_lte_cfg lte_cfg
        	        where lgr.SID            = in_sid
        	          and lgr.FIRMA_NR       = in_firma_nr
                    and lgr.gesperrt   = c.lgr_gesperrt_f
                    and lgr.akt_inventur_id is NULL
                    and lgr.LGR_ORT    = in_lgr_ort
                    and lgr.lgr_verwendung = c.LGR_TYP_Lager
                    and nvl(lgr.lte_namen, nvl(lgr.lte_namen_cfg, 'alle'))  is not NULL
                    and lte.lte_name = lte_cfg.lte_name(+)
                    and (nvl(lgr.lte_namen, lte.lte_name || ';') like ('%' || lte.lte_name || '%')
                      or nvl(lgr.lte_namen, lte_cfg.basis_lte_name || ';') like ('%' || lte_cfg.basis_lte_name || '%')
                        )
                    and lte.sid      = in_sid
                    and lte.firma_nr= in_firma_nr
                    and lgr.lgr_platz_gruppe = lte.lgr_platz_gruppe
                    and lgr.lgr_ort = v_lgr_ort
                    and lgr.lgr_gruppe_id = v_lgr_ort_grp
                    and lte_lgr.lgr_platz = lte.lgr_platz
                    and lte_lgr.lgr_dim_fifo_nr = 1
                  group by lgr.lgr_platz_gruppe,
                           lgr.lgr_dim_r,
                           lgr.uml_erlaubt
                  having sum(lgr.lgr_einl_te_verfueg) > 0)
          where kanal = 'A'
            and vorg_id = 0
            and in_lgr_platz_grp not like ('%' || lgr_platz_gruppe || ';%')
            and lte_namen like ('%' || v_lte_name || ';%')
            and lgr_vol_hoehe >= v_lgr_hoehe
            and (lgr_dim_r = v_lgr_regal
               or uml_erlaubt = 'T')

         group by kanal,
                  lgr_platz_gruppe,
                  lgr_vol_hoehe
        having sum(lgr_dispo_ausl_te)=0
        Order By decode(res_string, v_res_string, 0,
                   decode(substr(res_string, 1, v_pos_s), substr(v_res_string, 1, v_pos_s), 1,
                     decode(res_string, 'Mischkanal', 2, 3))),
                 lgr_vol_hoehe - v_lgr_hoehe,
                 frei_platz_Te;

	CURSOR c_lgr_platz is
    select lgr.lgr_platz
      from lvs_lgr lgr
     where SID                     = in_sid
       and FIRMA_NR                = in_firma_nr
       and lgr.lgr_einl_te_verfueg > 0
       and lgr.lgr_platz_gruppe = v_grp_lgr_platz_gruppe
	   order by lgr.lgr_dim_fifo_nr ASC;


  begin
    v_err_nr := NULL;
    v_err_text := NULL;
    v_pos_s := INSTR(v_res_string, ';', 1, 1);
    
    OPEN c_lgr_platz_lte_bestand;
    FETCH c_lgr_platz_lte_bestand into v_platz_gruppe,  v_lgr_platz, v_lte_id,
                                       v_wtyp, v_anz_lhm, v_res_string,
                                       v_res_artikel_id, v_min_art_id,  v_max_art_id,
                                       v_res_mhd, v_min_mhd, v_max_mhd,
                                       v_min_prod_dat, v_lte_name,
                                       v_lgr_ort, v_lgr_ort_grp,
                                       v_lgr_regal, v_lgr_hoehe;
    LOOP
      EXIT when c_lgr_platz_lte_bestand%NOTFOUND;
      v_pos_s := INSTR(v_res_string, ';', 1, 1);
      if nvl(v_pos_s, 0) = 0
      then
        v_pos_s := nvl(length(v_res_string), 100);
      end if;
      OPEN c_lgr_platz_grp;
      FETCH c_lgr_platz_grp into v_grp_lgr_platz_gruppe, v_grp_frei_platz_Te, v_grp_res_string;
      v_found := c_lgr_platz_grp%FOUND;
      CLOSE c_lgr_platz_grp;
      if not v_found
      then
    		v_err_nr := 10;
    		v_err_text := LC.ec(LC.O_TXT_OPTI_FREI_PLAETZE_N_AUSR);
        CLOSE c_lgr_platz_lte_bestand;
    		RAISE v_error;
      else
        OPEN c_lgr_platz;
        FETCH c_lgr_platz into v_ziel_platz;
        v_found := c_lgr_platz%FOUND;
        CLOSE c_lgr_platz;
        if not v_found
        then
      		v_err_nr := 20;
      		v_err_text := LC.ec_p1(LC.O_TP1_Z_PLATZ_IN_GRP_N_LESBAR, v_grp_lgr_platz_gruppe);
          CLOSE c_lgr_platz_lte_bestand;
      		RAISE v_error;
        else
          v_transport_gruppe := 0;
          v_ret := lvs_transport.lvs_transp_lte (in_sid,                         -- in_sid                  IN isi_sid.sid%TYPE,
                                              	 in_firma_nr,                    -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
                                              	 in_modul_erzeuger,              -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,
                                              	 in_modul_bearbeiter,            -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,
                                              	 c.C_FALSE,                      -- in_frei_fahren          IN varchar2,
                                                 'U',                            -- in_trans_typ            in varchar2,
                                              	 in_login_id,                    -- in_user_id              IN isi_user.login_id%TYPE,
                                              	 0,                              -- in_auftrag_id           IN isi_transport.auf_id%TYPE,
                                              	 0,                              -- in_auftrag_id_extern    IN isi_transport.auf_id_extern%TYPE,
                                              	 0,                              -- in_prio                 IN isi_transport.prio%TYPE,
                                              	 0,                              -- in_progr_nr             IN isi_transport.progr_nr%TYPE,
                                              	 0,                              -- in_quelle_leer_progr_nr IN isi_transport.quelle_leer_progr_nr%TYPE,
                                              	 0,                              -- in_ziel_voll_progr_nr   IN isi_transport.ziel_voll_progr_nr%TYPE,
                                              	 v_lgr_platz,                    -- in_lgr_quell_lgr_platz  IN lvs_lte.lgr_platz%TYPE,
                                              	 v_ziel_platz,                   -- in_lgr_ziel_lgr_platz   IN lvs_lte.lgr_platz%TYPE,
                                              	 v_lte_id,                       -- in_lte_id               IN lvs_lte.lte_id%TYPE,
                                              	 0,                              -- in_kunde_nr             IN lvs_lam.kunden_nr%TYPE
                                              	 c.C_FALSE,                      -- in_lieferschein
                                              	 NULL,                           -- Lieferschein Nummer
                                              	 NULL,                           -- Lieferscheinposition -Nummer
                                              	 NULL,                           -- Vorgang_id (Tour)
                                                 NULL,                           -- in_fahrzeuge_IDs Hier muss im Vorfeld geprüft sein, ob die Fahrzeuge OK sind
                                                 NULL,
                                                 v_transport_gruppe,
                                                 v_tr_id);
          if v_ret <> 0
          then
        		v_err_nr := 30;
        		v_err_text := c.DECODE_FUNCTION_FEHLER(v_ret);
            CLOSE c_lgr_platz_lte_bestand;
        		RAISE v_error;
          end if;
        end if;
      end if;
      FETCH c_lgr_platz_lte_bestand into v_platz_gruppe,  v_lgr_platz, v_lte_id,
                                         v_wtyp, v_anz_lhm, v_res_string,
                                         v_res_artikel_id, v_min_art_id,  v_max_art_id,
                                         v_res_mhd, v_min_mhd, v_max_mhd,
                                         v_min_prod_dat, v_lte_name,
                                         v_lgr_ort, v_lgr_ort_grp,
                                         v_lgr_regal, v_lgr_hoehe;
    end LOOP;
    CLOSE c_lgr_platz_lte_bestand;
    commit;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
     when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      if c_lgr_platz_lte_bestand%ISOPEN
      then
        CLOSE c_lgr_platz_lte_bestand;
      end if;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
      if c_lgr_platz_lte_bestand%ISOPEN
      then
        CLOSE c_lgr_platz_lte_bestand;
      end if;
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;    
  end c_kompress;

  ---------------------------------------------------------------------------------------------------------------
  procedure LVS_C_LAGER_RESET is
    v_lgr lvs_lgr%rowtype;
    v_lte lvs_lte%rowtype;

    v_anz_lte       number;
    v_anz_kg        number;
    v_res_string    varchar2(100);
    v_lgr_platz     lvs_lgr.lgr_platz%type;

--    CURSOR c_lte is
--      select * from lvs_lte;

    CURSOR c_lgr is
      select *
        from lvs_lgr t
       where t.lgr_platz = v_lgr_platz
        for update of lgr_akt_te,
                      lgr_akt_kg,
                      lgr_frei_hoehe,
                      lgr_dispo_einl_frei_hoehe,
                      lgr_dispo_einl_te,
                      lgr_dispo_ausl_te,
                      lgr_order_res_te,
                      lgr_dispo_einl_kg,
                      lgr_dispo_ausl_kg,
                      lgr_einl_te_verfueg,
                      res_string;
    CURSOR c_lte_lgr is
      select *
        from lvs_lte lte
       where lte.lgr_platz = v_lgr_platz;

    CURSOR c_lte_lgr_grp is
      select lte.lgr_platz,
             nvl(count(lte_id), 0),
             sum(nvl(lte.lte_akt_kg, 0)),
             decode(min(lte.res_string),
                    max(lte.res_string),
                    min(lte.res_string),
                    NULL)
        from lvs_lte lte
       where lte.lgr_platz is not NULL
       group by lte.lgr_platz;

  CURSOR c_lgr_lte_size is
    select max(nvl(lte.lte_vol_breite, lgr.lgr_vol_breite)),
           max(nvl(lte.lte_vol_tiefe,  lgr.lgr_vol_tiefe))
      from lvs_lgr lgr,
           lvs_lte lte
     where lgr.lgr_platz = v_lgr.lgr_platz
       and lgr.lgr_platz = lte.lgr_platz(+);

  begin
    delete from isi_transport;

    update lvs_lte lte
       set lte.ziel_lgr_ort           = null,
           lte.ziel_lgr_platz         = null,
           lte.ziel_lgr_ort_n_freif   = null,
           lte.ziel_lgr_platz_n_freif = null,
           lte.order_auf_id           = NULL,
           lte.order_vorgang_id       = NULL,
           lte.lte_status             = decode(lte.lgr_platz,
                                               NULL,
                                               decode(lte.lte_status,
                                                      'PF',
                                                      'PF',
                                                      'KF'),
                                               decode((select lgr.Lgr_Verwendung
                                                        from lvs_lgr lgr
                                                       where lgr.sid =
                                                             lte.sid
                                                         and lgr.lgr_platz =
                                                             lte.lgr_platz),
                                                      C.Lgr_Typ_We, C.Lte_Bf_Stat,
                                                      C.Lgr_Typ_LagerP, C.Lte_BS_Stat,
                                                      C.Lgr_Typ_Wa, C.Lte_af_Stat,
                                                      c.LGR_TYP_EP, c.LTE_ET_STAT,
                                                             C.Lte_lf_Stat));

    update isi_order_kopf kopf
       set kopf.freigegeben_datum = NULL,
           kopf.status = 'N'
     where kopf.status != 'N'
       and kopf.status not in ('E', 'Z', 'XF'); -- Alle engültig Abgeschlossen

    update isi_order_pos pos
       set pos.freigegeben_datum = NULL,
           pos.status = 'N',
           pos.ware_disponiert = C.C_FALSE
     where pos.status != 'N'
       and pos.status not in ('E', 'Z', 'XF'); -- Alle engültig Abgeschlossen


    update lvs_lgr lgr
       set lgr.lgr_akt_te                    = 0,
           lgr.lgr_akt_kg                    = 0,
           lgr.lgr_dispo_einl_frei_hoehe     = 0,
           lgr.lgr_dispo_einl_te             = 0,
           lgr.lgr_dispo_ausl_te             = 0,
           lgr.lgr_order_res_te              = 0,
           lgr.lgr_dispo_einl_kg             = 0,
           lgr.lgr_dispo_ausl_kg             = 0,
           lgr.lgr_einl_te_verfueg           = lgr.lgr_max_te,
           lgr.res_string                    = decode (lgr.res_res_string_statisch, c.C_TRUE, lgr.res_string, NULL),
           lgr.lte_namen                     = case when lgr.lgr_typ = c.SEG_DUEDO1
                                                     and mod(lgr.lgr_dim_t, 2) = 0
                                                    then 'Keine'
                                                    else lgr.lte_namen_cfg
                                                    end;


    OPEN c_lte_lgr_grp;
    v_anz_lte := 0;
    v_anz_kg := 0;
    v_res_string := NULL;
    FETCH c_lte_lgr_grp into v_lgr_platz, v_anz_lte, v_anz_kg, v_res_string;

    while (c_lte_lgr_grp%FOUND)
    LOOP
      OPEN c_lgr;
      FETCH c_lgr
        into v_lgr;

      if c_lgr%FOUND
      then

        v_lte := NULL;
        OPEN c_lte_lgr;
        FETCH c_lte_lgr
          into v_lte;
        CLOSE c_lte_lgr;

        v_lgr.lgr_akt_te                  := nvl(v_anz_lte, 0);
        v_lgr.lgr_akt_kg                  := nvl(v_anz_kg, 0);
        v_lgr.lgr_dispo_einl_frei_hoehe   := 0;
        v_lgr.lgr_dispo_einl_te           := 0;
        v_lgr.lgr_dispo_ausl_te           := 0;
        v_lgr.lgr_order_res_te            := 0;
        v_lgr.lgr_dispo_einl_kg           := 0;
        v_lgr.lgr_dispo_ausl_kg           := 0;
        v_lgr.lgr_einl_te_verfueg         := nvl(v_lgr.lgr_max_te, 0) -
                                             nvl(v_lgr.lgr_akt_te, 0);
        if v_lgr.lgr_typ = c.STAP_FLAE1
        then
          OPEN c_lgr_lte_size;
          FETCH c_lgr_lte_size into v_lgr.lgr_vol_breite, v_lgr.lgr_vol_tiefe;
          CLOSE c_lgr_lte_size;
          v_lgr.lgr_vol_breite := (nvl(v_lgr.lgr_vol_breite, 0) + 499) / isi_allg.c_get_firma_cfg_param (v_lgr.sid,                        -- in_sid                   in isi_firma_cfg.sid%type,
                                                                                                         v_lgr.firma_nr,                   -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                                                                                         'CFG',                            -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                                                                         'RASTER_MM',                      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                                                                         'c.STAP_FLAE1',                   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                                                         'LVS',                            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                                                         'CFG',                            -- in_typ                   in isi_firma_cfg.typ%type,
                                                                                                         500,                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                                                         'INTEGER');                       -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
          v_lgr.lgr_vol_tiefe  := (nvl(v_lgr.lgr_vol_tiefe,  0) + 499) / isi_allg.c_get_firma_cfg_param (v_lgr.sid,                        -- in_sid                   in isi_firma_cfg.sid%type,
                                                                                                         v_lgr.firma_nr,                   -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                                                                                                         'CFG',                            -- in_kategorie             in isi_firma_cfg.kategorie%type,
                                                                                                         'RASTER_MM',                      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                                                                                                         'c.STAP_FLAE1',                   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                                                         'LVS',                            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                                                         'CFG',                            -- in_typ                   in isi_firma_cfg.typ%type,
                                                                                                         500,                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                                                         'INTEGER');                       -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type 
        end if;

        update lvs_lgr lgr
           set lgr.lgr_akt_te                  = nvl(v_anz_lte, 0),
               lgr.lgr_akt_kg                  = nvl(v_anz_kg, 0),
               lgr.lgr_frei_hoehe              = decode (lgr.lgr_typ,
                                                         c.REG_FACH1,
                                                         lgr.lgr_vol_hoehe -
                                                         (select sum(t.lte_vol_hoehe)
                                                            from lvs_lte t
                                                           where t.lgr_platz = lgr.lgr_platz),
                                                         c.STAP_FLAE1,
                                                         lgr.lgr_vol_hoehe -
                                                         (select sum(t.lte_vol_hoehe)
                                                            from lvs_lte t
                                                           where t.lgr_platz = lgr.lgr_platz),
                                                         c.STAP_FLAE2,
                                                         lgr.lgr_vol_hoehe -
                                                         (select sum(t.lte_vol_hoehe)
                                                            from lvs_lte t
                                                           where t.lgr_platz = lgr.lgr_platz),
                                                         lgr.lgr_vol_hoehe),
               lgr.lgr_frei_breite             = v_lgr.lgr_vol_breite,
               lgr.lgr_frei_tiefe              = v_lgr.lgr_vol_tiefe,
               lgr.lgr_dispo_einl_frei_hoehe   = 0,
               lgr.lgr_dispo_einl_te           = 0,
               lgr.lgr_dispo_ausl_te           = 0,
               lgr.lgr_order_res_te            = 0,
               lgr.lgr_dispo_einl_kg           = 0,
               lgr.lgr_dispo_ausl_kg           = 0,
               lgr.lgr_einl_te_verfueg         = v_lgr.lgr_einl_te_verfueg
         where current of c_lgr;
      else
        dbms_output.put_line('Fehler: Lagerplatz ' || nvl(v_lgr_platz, 'NULL') || ' fehlt.' );
      end if;
      CLOSE c_lgr;
      lvs_kanal_kontrolle(v_lte, v_lgr);

      v_anz_lte := 0;
      v_anz_kg := 0;
      v_res_string := NULL;
      FETCH c_lte_lgr_grp into v_lgr_platz, v_anz_lte, v_anz_kg, v_res_string;
    end LOOP;
    CLOSE c_lte_lgr_grp;

    update lvs_lam lam
       set lam.lgr_platz        = (select lgr_platz
                                     from lvs_lte
                                    where lte_id = lam.lte_id),
           lam.order_pos_auf_id = NULL;
    COMMIT;
  end LVS_C_LAGER_RESET;

  /*-------------------------------------------------------------------------
  -- Procedure ermittelt, ob es für eine Einlagerung einen optimaleren Platz
  -- gibt, ob damit eine andere Palette synchronisiert ist. Falls ein Platz
  -- gefunden wurde, wird dieser bereits in der Transport eingetragen, und
  -- alle Disponierungen korrigiert.
  --    in_lte_id        LTE die optimiert werden soll
  --    in_transport_id     transportauftrag der LTE die optimiert werden soll.
  --    in_synch_trans_id   Transportauftrag mit dem synchronisiert werden soll.
  -- Rückgabe in den out-Parametern
  --    out_lgr_platz     NULL -> Keine Optimerung sonst der neue Lagerplatz
  --    out_lte_id        NULL -> Keine LTE synchronisiert, sonst mit dieser
  --    out_prio           0 -> Nur dieser Transport ist optimiert
  --                      -1 -> Transport ist synchronisiert jedoch sollte
  --                            der Transport mit der out_lte_id zuerst fahren
  --                       1 -> Transport ist synchronisiert mit lte_id. Diesen
  --                            Transport zuerst fahren.
  -------------------------------------------------------------------------*/
  procedure lvs_c_transp_suche_einl_opti(in_lte_id         in lvs_lte.lte_id%TYPE,
                                         in_transport_id   in isi_transport.transp_id%type,
                                         in_synch_trans_id in isi_transport.transp_id%type,
                                         in_fahrzeuge_IDs  in varchar2,
                                         out_lgr_platz    out lvs_lgr.lgr_platz%TYPE,
                                         out_lte_id       out lvs_lte.lte_id%type,
                                         out_prio         out number) is
    -------------------------------------------------------------------------
    v_error              EXCEPTION;
    v_err_nr             number;
    v_err_text           varchar2(4096);
    -------------------------------------------------------------------------
    v_lte                     lvs_lte%rowtype;
    v_lte_ziel_platz          lvs_lte.ziel_lgr_platz%type;
    v_found                   boolean;
    v_lgr                     lvs_lgr%rowtype;
    v_transport               isi_transport%rowtype;
    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;


    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lte_id = in_lte_id;

    CURSOR c_lte_ausl is
      select *
        from lvs_lte lte
       where lte.lgr_platz = v_lgr.lgr_platz_gruppe_gegenueber
         and lte.lte_status = c.LTE_AD_STAT;

    CURSOR c_lte_ausl_gruppe is
      select lte.*
        from lvs_lte lte,
             lvs_lgr lgr
       where lgr.gruppe = v_lgr.gruppe
         and lgr.lgr_dispo_ausl_te > 0
         and lte.lgr_platz = lgr.lgr_platz
         and lte.lte_status = c.LTE_AD_STAT;

    CURSOR c_transport is
      select *
        from isi_transport t
       where t.sid = v_lte.sid
         and t.transp_id = in_synch_trans_id;

    CURSOR c_lgr is
      select *
        from lvs_lgr l
       where l.lgr_platz = v_lte_ziel_platz;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;

  begin
    out_lgr_platz := NULL;
    out_lte_id    := NULL;
    out_prio      := NULL;

    v_transport := NULL;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    OPEN c_transport;
    FETCH c_transport into v_transport;
    CLOSE c_transport;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
   		RAISE v_error;
    else
      OPEN c_lte_cfg;
      FETCH c_lte_cfg into v_lte_cfg;
      CLOSE c_lte_cfg;

      v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);

      v_lte_ziel_platz := v_lte.ziel_lgr_platz;
      lvs_c_suche_opti_einl_platz (v_lte,             -- in_lte          in lvs_lte%ROWTYPE,
                                   v_basis_lte_name,  -- in_basis_lte_name in lvs_lte_cfg.basis_lte_name
                                   v_lte_cfg.flaechen_stellplatz_erf,
                                   in_transport_id,   -- in_transport_id in isi_transport.transp_id%type,
                                   v_transport,       -- in_sych_trans_id in isi_transport.transp_id%type,
                                   in_fahrzeuge_IDs,  -- ID's der möglichen Fahrzeuge
                                   NULL,              -- in_lgr_orte      in varchar2,
                                   v_lgr);            -- out_lgr_platz   out lvs_lgr%ROWTYPE

      out_lgr_platz := v_lgr.lgr_platz;

      if out_lgr_platz is not NULL
      then
        out_prio := 0;
        out_lgr_platz := v_lgr.lgr_platz;
      else
        v_lgr := NULL;
        OPEN c_lgr;
        FETCH c_lgr into v_lgr;
        CLOSE c_lgr;
      end if;

      if v_lgr.lgr_typ = c.SAT_EPL1
      or v_lgr.lgr_typ = c.SAT_EPL2
      then
        OPEN c_lte_ausl;
        FETCH c_lte_ausl into v_lte;
        v_found := c_lte_ausl%FOUND;
        CLOSE c_lte_ausl;
        if v_found
        then
          out_lte_id := v_lte.lte_id;
          out_prio := 1;
        else
          OPEN c_lte_ausl_gruppe;
          FETCH c_lte_ausl_gruppe into v_lte;
          v_found := c_lte_ausl_gruppe%FOUND;
          CLOSE c_lte_ausl_gruppe;
          if v_found
          then
            out_lte_id := v_lte.lte_id;
            out_prio := 1;
          end if;
        end if;
        if v_found
        and out_lgr_platz is NULL
        then
          out_lgr_platz := v_lte_ziel_platz;
        end if;
        if out_lte_id = v_transport.lte_id
        then
          update isi_transport tr
             set tr.prio = (select t.prio  + 1
                              from isi_transport t
                             where t.sid = v_lte.sid
                               and t.transp_id = in_synch_trans_id)
           where tr.transp_id =  in_transport_id
             and tr.sid = v_lte.sid
             and tr.firma_nr = v_lte.firma_nr;
        end if;
      end if;
    end if;

    commit;
  exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
     when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;    
  end lvs_c_transp_suche_einl_opti;


  /*-------------------------------------------------------------------------
  -- Procedure ermittelt, ob es für eine Einlagerung einen optimaleren Platz
  -- gibt, wenn die Transport_ID NULL ist. Falls die TransportID NULL ist,
  -- wird wenn moeglich ein neuer Transport mit Lagerplatzsuche etc. erzeugt.
  -- Rückgabe in den out-Parametern
  --    out_lgr_platz     NULL -> Keine Optimerung sonst der neue Lagerplatz
  --    out_transport_id  NULL -> Kein Transport angelegt oder in_transport_id
  --    out_res_id             -> res_id vom RGB fuer Transport
  -------------------------------------------------------------------------*/
  procedure lvs_c_transp_suche_einl_2s_opt(in_transport_id         in isi_transport.transp_id%type,
                                           in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                           in_lgr_orte             in varchar2,
                                           in_fahrzeuge_IDs        in varchar2,
                                           in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                           in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                           in_user_ID              in isi_user.login_id%TYPE,
                                           in_prio                 in isi_transport.Prio%TYPE,
                                           in_progr_nr             in isi_transport.progr_nr%TYPE,
                                           in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                           in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                           in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                           in_aktuelle_position    in lvs_lam.lam_text%type,
                                           out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                           out_transport_id        out number,
                                           out_res_id              out isi_resource.res_id%type) is
    -------------------------------------------------------------------------
    v_error              EXCEPTION;
    v_err_nr             number;
    v_err_text           varchar2(4096);
    -------------------------------------------------------------------------
    v_lte                     lvs_lte%rowtype;
    --v_lte_ziel_platz          lvs_lte.ziel_lgr_platz%type;
    v_found                   boolean;
    v_lgr                     lvs_lgr%rowtype;
    v_transport               isi_transport%rowtype;
    v_transport_sync          isi_transport%rowtype;
    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    CURSOR c_lte is
      select *
        from lvs_lte lte
       where lte.lte_id = in_lte_id;

    --CURSOR c_lgr is
    --  select *
    --    from lvs_lgr l
    --   where l.lgr_platz = v_lte_ziel_platz;

    CURSOR c_transport is
      select *
        from isi_transport t
       where t.sid = v_lte.sid
         and t.transp_id = in_transport_id;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = v_lte.sid
         and t.firma_nr = v_lte.firma_nr
         and t.lte_name = v_lte.lte_name;

  begin
    out_lgr_platz := NULL;
    v_transport_sync := NULL;

    OPEN c_lte;
    FETCH c_lte into v_lte;
    v_found := c_lte%FOUND;
    CLOSE c_lte;

    if not v_found
    then
      v_err_nr   := 10;
      v_err_text := LC.ec_p1(LC.O_TP1_LTE_ID_FEHLT, in_lte_id);
      raise v_error;
    else
      --v_lte_ziel_platz := v_lte.ziel_lgr_platz;
      if in_transport_id is not NULL
      then
        OPEN c_lte_cfg;
        FETCH c_lte_cfg into v_lte_cfg;
        CLOSE c_lte_cfg;

        v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);

        lvs_c_suche_opti_einl_platz (v_lte,             -- in_lte          in lvs_lte%ROWTYPE,
                                     v_basis_lte_name,  -- in_basis_lte_name in lvs_lte_cfg.basis_lte_name
                                     v_lte_cfg.flaechen_stellplatz_erf,
                                     in_transport_id,   -- in_transport_id in isi_transport.transp_id%type,
                                     v_transport_sync,  -- in_sych_trans_id in isi_transport.transp_id%type,
                                     in_fahrzeuge_IDs,  -- ID's der möglichen Fahrzeuge
                                     in_lgr_orte,       -- in_lgr_orte      in varchar2,
                                     v_lgr);            -- out_lgr_platz   out lvs_lgr%ROWTYPE
        out_lgr_platz := v_lgr.lgr_platz;
        out_transport_id := in_transport_id;
        if out_lgr_platz is NULL
        then
          lvs_platz.v_fahrz_res_id := NULL;
        end if;

        OPEN c_transport;
        FETCH c_transport into v_transport;
        v_found := c_transport%FOUND;
        CLOSE c_transport;
        if not v_found
        then
          v_err_nr   := 20;
          v_err_text := LC.ec_p1(LC.O_TP1_TRANSP_ID_NF, in_lte_id);
          raise v_error;
        end if;
        out_res_id := nvl(lvs_platz.v_fahrz_res_id, v_transport.res_id);
      else
        lvs_platz.lvs_c_transp_suche_einl_p_rid(in_lte_id,                       -- in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                                                in_lgr_orte,                     -- in_lgr_orte             in varchar2,
                                                in_fahrzeuge_IDs,                -- in_fahrzeuge_IDs        in varchar2,
                                                in_modul_erzeuger,               -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                                                in_modul_bearbeiter,             -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                                in_user_ID,                      -- in_user_ID              in isi_user.login_id%TYPE,
                                                in_prio,                         -- in_prio                 in isi_transport.Prio%TYPE,
                                                in_progr_nr,                     -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                                in_quelle_Leer_progr_nr,         -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                                in_ziel_voll_Progr_nr,           -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
                                                in_lgr_platz_quelle,             -- in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
                                                in_aktuelle_position,            -- in_aktuelle_position    in lvs_lam.lam_text%type,
                                                out_lgr_platz,                   -- out_lgr_platz           out lvs_lgr.lgr_platz%TYPE,
                                                out_transport_id,                -- out_transport_id        out number,
                                                out_res_id);                     -- out_res_id              out isi_resource.res_id%type
      end if;

    end if;

    commit;
  exception
     when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;    
  end lvs_c_transp_suche_einl_2s_opt;

  -------------------------------------------------------------------------
  procedure LVS_C_SUCHE_OPTI_EINL_PLATZ(in_lte            in lvs_lte%ROWTYPE,
                                        in_basis_lte_name in lvs_lte_cfg.basis_lte_name%type,
                                        in_flaechen_stellplatz_erf  in   lvs_lte_cfg.flaechen_stellplatz_erf%type,
                                        in_transport_id   in isi_transport.transp_id%type,
                                        in_synch_trans    in isi_transport%rowtype,
                                        in_fahrzeuge_IDs  in varchar2,
                                        in_lgr_orte       in varchar2,
                                        out_lgr_platz     out lvs_lgr%ROWTYPE) is
    -------------------------------------------------------------------------
    -- bei einem auto platz ist kein platz der gruppe belegt oder für einlagerung
    -- reserviert !!!
    v_error EXCEPTION;
    v_err_nr             number;
    v_err_text           varchar2(4096);
    v_lgr_text           varchar2(255);
    v_found              boolean;
    v_found_lgr          boolean;
    v_weiter_lgr         boolean;
    v_lgr_ort            lvs_lgr.lgr_ort%TYPE;
    v_lgr_orte           varchar2(255);
    v_lgr_ort_count      number;
    v_ort                lvs_lgr_ort%ROWTYPE;
    v_transport          isi_transport%rowtype;

    v_lgr                lvs_lgr%ROWTYPE;
    v_lte_lgr            lvs_lgr%ROWTYPE;
    v_lgr_platz          lvs_lgr.lgr_platz%type;
    v_ausl_dispo_faktor  number;
    v_ausl_dispo_bestand number;
    v_faktor_akt         number;
    v_abstand_faktor     number;
    v_abstand_faktor_akt number;
    v_fuellgrad_seg      number;
    v_dat_lgr_regal_ebene_faktor  number;
    v_dat                date;

    v_lgr_platz_akt         lvs_lgr.lgr_platz%type;
    v_lgr_dim_platz_ref     lvs_lgr.lgr_dim_platz%type;
    v_lgr_dim_ort_ref       lvs_lgr.lgr_ort%type;
    v_ausl_dispo_faktor_akt number;
    v_ref_lgr_gruppe_id     lvs_lgr.lgr_gruppe_id%type;
    v_ref_lgr_dim_g         lvs_lgr.lgr_dim_g%type;
    v_ref_lgr_dim_r         lvs_lgr.lgr_dim_r%type;
    v_ref_lgr_dim_p         lvs_lgr.lgr_dim_p%type;
    v_ref_lgr_dim_e         lvs_lgr.lgr_dim_e%type;
    v_ref_lgr_dim_t         lvs_lgr.lgr_dim_t%type;
    v_ref_lgr_max_kg        lvs_lgr.lgr_max_kg%type; 
    v_ref_lgr_akt_kg        lvs_lgr.lgr_akt_kg%type; 
    v_ref_lgr_frei_hoehe    lvs_lgr.lgr_frei_hoehe%type; 
    v_ref_lgr_frei_breite   lvs_lgr.lgr_frei_breite%type; 
    v_ref_lgr_frei_tiefe    lvs_lgr.lgr_frei_tiefe%type;
    
    v_ausl_dispo_lte_grp    number;
    v_ausl_res_lte_grp      number;

    v_lgr_platz_grp      lvs_lgr.lgr_platz_gruppe%type;
    v_lgr_dim_fifo       lvs_lgr.lgr_dim_fifo_nr%type;
    v_lgr_raster_x       number;
    v_lgr_raster_y       number;

    CURSOR c_lvs_lgr_grp_fahrzeug is
      select decode (min(f.res_id), max(f.res_id), min(f.res_id), NULL) Res_Id
        from lvs_lgr_grp_fahrzeug f
       where f.lgr_gruppe_id = v_lgr.lgr_gruppe_id
         and f.lgr_ort = v_Lgr.Lgr_Ort;

    -- Letzter Lagerplatz fuer diesen Artikel in diesem Lagerort
    CURSOR c_ref_lgr_platz is
      select lgr.lgr_dim_platz, 
             lgr.lgr_ort, 
             lgr.lgr_gruppe_id, 
             lgr.lgr_dim_g, 
             lgr.lgr_dim_r, 
             lgr.lgr_dim_p, 
             lgr.lgr_dim_e, 
             lgr.lgr_dim_t,
             lgr.lgr_max_kg, 
             lgr.lgr_akt_kg, 
             lgr.lgr_frei_hoehe, 
             lgr.lgr_frei_breite, 
             lgr.lgr_frei_tiefe
        from lvs_lte lte,
             lvs_lgr lgr
       where lte.sid = in_lte.sid
         and lte.firma_nr = in_lte.firma_nr
         and lte.ziel_lgr_platz = in_lte.ziel_lgr_platz
         and lte.ziel_lgr_platz = lgr.lgr_platz;

    CURSOR c_ref_lgr_platz_bh is
      select lgr.lgr_dim_platz, lgr.lgr_ort, lgr.lgr_gruppe_id, lgr.lgr_dim_g, lgr.lgr_dim_r, lgr.lgr_dim_p, lgr.lgr_dim_e, lgr.lgr_dim_t
        from lvs_lam_bh bh,
             lvs_lgr lgr
       where bh.sid = in_lte.sid
         and bh.firma_nr = in_lte.firma_nr
         and to_char(bh.artikel_id) = in_lte.res_artikel_id
         and lgr.lgr_platz = bh.lgr_platz
         and (lgr.lgr_verwendung = c.LGR_TYP_Lager
           or lgr.lgr_verwendung = c.LGR_TYP_LagerP)
         and lgr.lgr_ort = v_ort.lgr_ort
       order by bh.buch_datum desc;

    CURSOR c_lgr_in_grp is -- Lesen des Lagerplatz
      select /*+ first_rows(1) */
             *
        from lvs_lgr lgr
       where lgr.lgr_platz_gruppe = v_lgr_platz_grp
         and lgr.lgr_dim_fifo_nr = v_lgr_dim_fifo
         and lgr.lgr_dim_g = v_lgr.lgr_dim_g
         and lgr.lgr_dim_r = v_lgr.lgr_dim_r
         and lgr.lgr_dim_e = v_lgr.lgr_dim_e
         and lgr.lgr_dim_p = v_lgr.lgr_dim_p
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.sid = in_lte.sid;

    -- fuer Kanaele und Sat-Lager
    CURSOR c_lgr_kanal is
      select /*+ first_rows(25) */
             min(lgr.lgr_dim_fifo_nr),
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          min(lgr.lgr_platz),
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          min(lgr.lgr_gruppe_id),
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          min(lgr.lgr_dim_t),
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          min(lgr.lgr_dim_platz), 
                                          max(lgr.lgr_max_kg), 
                                          min(lgr.lgr_akt_kg), 
                                          max(lgr.lgr_frei_hoehe), 
                                          max(lgr.lgr_frei_breite), 
                                          max(lgr.lgr_frei_tiefe)
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_regal_ebene_faktor() as regal_ebene_faktor,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor,
             lgr.lgr_platz_gruppe,
             lgr.lgr_dim_g,
             lgr.lgr_dim_r,
             lgr.lgr_dim_p,
             lgr.lgr_dim_e
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       group by lgr.lgr_platz_gruppe,
                lgr.res_string,
                lgr.res_artikel_id,
                lgr.abc,
                lgr.lgr_res_strat,
                lgr.lgr_dim_g,
                lgr.lgr_dim_r,
                lgr.lgr_dim_p,
                lgr.lgr_dim_e
       order by ausl_dispo_faktor  ASC,
                regal_ebene_faktor asc,
                abstand_faktor     asc;

    -- fuer Kanal - Block - Lager
    CURSOR c_lgr_kanal_block is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_l_buchung() as einl_dispo_l_dat,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor   asc,
                einl_dispo_l_dat    desc,
                abstand_faktor      asc,
                lgr.lgr_dim_fifo_nr asc;

    -- fuer Staplel-Flaechen Lager
    CURSOR c_lgr_stap_flae1 is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_l_buchung() as einl_dispo_l_dat,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_frei_hoehe <= in_lte.lte_vol_hoehe 
         and lgr.lgr_frei_breite <= in_lte.lte_vol_breite + v_lgr_raster_x
         and lgr.lgr_frei_tiefe <= in_lte.lte_vol_tiefe + v_lgr_raster_y
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor   asc,
                einl_dispo_l_dat    desc,
                abstand_faktor      asc,
                lgr.lgr_dim_fifo_nr asc;

    -- fuer Staplel-Flaechen Lager Fix Min Max
    CURSOR c_lgr_stap_flae2 is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_l_buchung() as einl_dispo_l_dat,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_vol_breite >= in_lte.lte_vol_breite
         and lgr.lgr_vol_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_frei_hoehe <= in_lte.lte_vol_hoehe
         and lgr.lgr_min_lte_hoehe <= in_lte.lte_vol_hoehe
         and lgr.lgr_min_lte_breite <= in_lte.lte_vol_breite
         and lgr.lgr_min_lte_tiefe <= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor   asc,
                einl_dispo_l_dat    desc,
                abstand_faktor      asc,
                lgr.lgr_dim_fifo_nr asc;

    -- fuer Kanal - Durchlauflager
    CURSOR c_lgr_durchl is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_l_buchung() as einl_dispo_l_dat,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor   asc,
                einl_dispo_l_dat    desc,
                abstand_faktor      asc,
                lgr.lgr_dim_fifo_nr desc;

    -- fuer Einzelplatz - Lager
    CURSOR c_lgr_epl is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_regal_ebene_faktor() as regal_ebene_faktor,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor asc,
                regal_ebene_faktor asc,
                abstand_faktor asc,
                lgr.lgr_dim_t;
    -- fuer Sateliten Einzelplatz - Lager
    CURSOR c_lgr_sat_epl is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             lvs_lager_opt.lvs_platz_regal_ebene_faktor() as regal_ebene_faktor,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor,
             lgr.lgr_einl_te_verfueg_gruppe as fuellgrad_seg,
             lvs_lager_opt.lvs_platz_faktor_belegung_akt() as faktor_belegung_akt
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor asc,
                abstand_faktor asc,
                regal_ebene_faktor asc,
                lgr.lgr_dim_t,
                fuellgrad_seg asc;

    -- fuer sonstige z.B. Blocklager
    CURSOR c_lgr_block is
      select /*+ first_rows(25) */
             lgr.lgr_platz,
             -- Ermitteln eines idealen Lagerplatz
             lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                          v_ort.firma_nr,
                                          v_ort.lgr_typ,
                                          decode(lgr.lgr_res_strat,
                                                 'O', nvl(to_char(in_lte.transport_gruppe), in_lte.res_string),
                                                  in_lte.res_string),
                                          in_lte.res_artikel_id,
                                          in_lte.abc,
                                          in_lte.waren_typ,
                                          lgr.lgr_platz_gruppe,
                                          lgr.res_artikel_id,
                                          lgr.res_string,
                                          lgr.abc,
                                          v_lgr_dim_platz_ref,
                                          v_lgr_dim_ort_ref,
                                          in_lte.lte_akt_kg,
                                          in_lte.lte_vol_hoehe,
                                          in_lte.lte_vol_tiefe,
                                          in_lte.lte_vol_breite,
                                          lgr.lgr_platz,
                                          c.C_TRUE,
                                          in_synch_trans.lgr_platz_quelle,
                                          in_fahrzeuge_IDs,
                                          lgr.lgr_gruppe_id,
                                          v_ref_lgr_gruppe_id,
                                          lgr.lgr_dim_g,
                                          lgr.lgr_dim_r,
                                          lgr.lgr_dim_p,
                                          lgr.lgr_dim_e,
                                          lgr.lgr_dim_t,
                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                          lgr.lgr_dim_platz, 
                                          lgr.lgr_max_kg, 
                                          lgr.lgr_akt_kg, 
                                          lgr.lgr_frei_hoehe, 
                                          lgr.lgr_frei_breite, 
                                          lgr.lgr_frei_tiefe
                                          ) as ausl_dispo_faktor,
             -- Ermitteln eines idealen Lagerplatz
             lvs_lager_opt.lvs_platz_bestand_ausl_faktor() as ausl_dispo_bestand,
             lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from lvs_lgr lgr
       where lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.lgr_ort = v_lgr_ort
         and lgr.lgr_einl_te_verfueg > 0
         and lgr.gesperrt = c.LGR_GESPERRT_F
         and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
         and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
         and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
         and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
         and lgr.lgr_verwendung = c.LGR_TYP_Lager
         and instr(nvl(lgr.lte_namen, in_basis_lte_name), in_basis_lte_name) > 0
       order by ausl_dispo_faktor   asc,
                ausl_dispo_bestand  desc,
                abstand_faktor      asc,
                lgr.lgr_dim_fifo_nr ASC;

    CURSOR c_ort is -- Lesen des Lagerort
      select *
        from lvs_lgr_ort ort
       where ort.sid = in_lte.sid
         and ort.firma_nr = in_lte.firma_nr
         and ort.lgr_ort = v_lgr_ort;

    CURSOR c_lgr is -- Lesen des Lagerplatz
      select *
        from lvs_lgr lgr
       where lgr.lgr_platz = v_lgr_platz_akt
         and lgr.firma_nr = in_lte.firma_nr
         and lgr.sid = in_lte.sid;

    CURSOR c_lgr_grp is -- Lesen des Lagerplatz
      select /*+ first_rows(1) */
             sum(lgr.lgr_dispo_ausl_te),
             sum(decode(lte.order_vorgang_id, NULL, 0, 1))
        from lvs_lgr lgr,
             lvs_lte lte
       where lgr.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
         and lgr.lgr_dim_g = v_lgr.lgr_dim_g
         and lgr.lgr_dim_r = v_lgr.lgr_dim_r
         and lgr.lgr_dim_e = v_lgr.lgr_dim_e
         and lgr.lgr_dim_p = v_lgr.lgr_dim_p
         and lgr.lgr_platz = lte.lgr_platz
       group by lgr.lgr_platz_gruppe,
                lgr.res_string,
                lgr.res_artikel_id,
                lgr.abc,
                lgr.lgr_dim_g,
                lgr.lgr_dim_r,
                lgr.lgr_dim_p,
                lgr.lgr_dim_e;

     CURSOR c_transport is -- Lesen des Trasports
      select *
        from isi_transport t
       where t.transp_id = in_transport_id
         and t.firma_nr = in_lte.firma_nr
         and t.sid = in_lte.sid;

 begin
    v_err_nr            := NULL;
    v_err_text          := NULL;
    out_lgr_platz       := NULL;
    v_found_lgr         := FALSE;
    v_weiter_lgr        := FALSE;
    v_lgr_dim_platz_ref := NULL;
    v_lgr_dim_ort_ref   := NULL;
    out_lgr_platz       := NULL;
    v_lte_lgr           := NULL;
    v_lgr               := NULL;

    v_lgr_dim_ort_ref   := NULL;
    v_lgr_dim_platz_ref := NULL;
    v_faktor_akt        := 1;
    v_lgr_raster_x      := 0;
    v_lgr_raster_y      := 0;

    lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab_empty;
    --lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab := lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab_empty;

    v_lgr_platz_akt := in_lte.ziel_lgr_platz;
    OPEN c_lgr;
    FETCH c_lgr
      into v_lte_lgr;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;

    v_transport := NULL;
    OPEN c_transport;
    FETCH c_transport into v_transport;
    CLOSE c_transport;

    if in_lgr_orte is not NULL
    then
      v_lgr_orte      := LVS_LORT_FORMAT(in_LGR_ORTE);
      v_lgr_ort_count := LVS_LORT_COUNT(v_lgr_orte);
    else
      v_lgr_orte      := LVS_LORT_FORMAT(to_char(v_lte_lgr.lgr_ort) || ';');
      v_lgr_ort_count := LVS_LORT_COUNT(v_lgr_orte);
    end if;

    OPEN c_ref_lgr_platz;
    FETCH c_ref_lgr_platz
      into v_lgr_dim_platz_ref, v_lgr_dim_ort_ref, v_ref_lgr_gruppe_id, 
           v_ref_lgr_dim_g, v_ref_lgr_dim_r, v_ref_lgr_dim_p, v_ref_lgr_dim_e, v_ref_lgr_dim_t,
           v_ref_lgr_max_kg, v_ref_lgr_akt_kg, v_ref_lgr_frei_hoehe, v_ref_lgr_frei_breite, 
           v_ref_lgr_frei_tiefe;
    CLOSE c_ref_lgr_platz;

--    if v_lgr_dim_platz_ref is NULL
--    then
--      OPEN c_ref_lgr_platz_bh;
--      FETCH c_ref_lgr_platz_bh
--        into v_lgr_dim_platz_ref, v_lgr_dim_ort_ref, v_ref_lgr_gruppe_id;
--      CLOSE c_ref_lgr_platz_bh;
--    end if;

    v_abstand_faktor := 0;

    v_lgr_ort := v_transport.lgr_ort_ziel;
    OPEN c_ort;
    FETCH c_ort
      into v_ort;
    v_found := c_ort%FOUND;
    CLOSE c_ort;
    lvs_platz.v_ort := v_ort;

    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                           in_basis_lte_name,
                                                           in_flaechen_stellplatz_erf,
                                                           v_lte_lgr,
                                                           'E',
                                                           in_fahrzeuge_IDs);


    -- Kein Fahrzeug bereit un diese Palette an den anfänglichen Lagewrplatz zu transportieren
    if  v_lte_lgr.lgr_platz is NULL
    or v_lte_lgr.lgr_verwendung != c.LGR_TYP_Lager
    or v_lte_lgr.gesperrt != c.LGR_GESPERRT_F
    or v_lte_lgr.lgr_verwendung = c.LGR_TYP_EP
    or (in_fahrzeuge_IDs is not NULL
    and in_fahrzeuge_IDs not like '%;' || to_char(v_transport.res_id) || ';%')    -- aktuelles Fahrzeug im Transport ist gesperrt
    or (v_lgr_text is not NULL)
    then -- dann wird der ursprüngliche Platz so sclecht wie ein falscher Platz gemacht damit sind alle mögliche besser
      v_ausl_dispo_faktor := 99000000000000000000000000; -- -AG- 27.01.2011 Nur einen großen Wert, damit der Platz kein guter ist (Jeder andere ist besser)
    else
      v_ausl_dispo_faktor := lvs_platz.lvs_platz_bewerten(v_lte_lgr.sid,
                                                          v_lte_lgr.firma_nr,
                                                          v_lte_lgr.lgr_typ,
                                                          v_lte_lgr.res_string,
                                                          in_lte.res_artikel_id,
                                                          in_lte.abc,
                                                          in_lte.waren_typ,
                                                          v_lte_lgr.lgr_platz_gruppe,
                                                          v_lte_lgr.res_artikel_id,
                                                          v_lte_lgr.res_string,
                                                          v_lte_lgr.abc,
                                                          v_lgr_dim_platz_ref,
                                                          v_lgr_dim_ort_ref,
                                                          in_lte.lte_akt_kg,
                                                          in_lte.lte_vol_hoehe,
                                                          in_lte.lte_vol_tiefe,
                                                          in_lte.lte_vol_breite,
                                                          v_lte_lgr.lgr_platz,
                                                          c.C_TRUE,
                                                          in_synch_trans.lgr_platz_quelle,
                                                          in_fahrzeuge_IDs,
                                                          v_lte_lgr.lgr_gruppe_id,
                                                          v_ref_lgr_gruppe_id,
                                                          v_ref_lgr_dim_g,
                                                          v_ref_lgr_dim_r,
                                                          v_ref_lgr_dim_p,
                                                          v_ref_lgr_dim_e,
                                                          v_ref_lgr_dim_t,
                                                          v_ort.lgr_dim_r_g_u_gegenueber,
                                                          v_lgr_dim_platz_ref,
                                                          v_ref_lgr_max_kg, 
                                                          v_ref_lgr_akt_kg, 
                                                          v_ref_lgr_frei_hoehe, 
                                                          v_ref_lgr_frei_breite, 
                                                          v_ref_lgr_frei_tiefe
                                                          );
      if v_ausl_dispo_faktor is NULL       -- Aktueller Platz ist nicht gesperrt und erreichbar konnte aber nicht bewertet werden
      then                                 -- Dann letzten gefundenen Platz nehmen
        out_lgr_platz := NULL;
        v_ausl_dispo_faktor := v_ort.strat_platz_res_string; -- Keinen besseren Platz gefunden
      end if;
    end if;

    if v_ausl_dispo_faktor <= v_ort.strat_platz_leer -- Keinen besseren Platz geben
    and v_ort.lgr_typ <> C.SAT_EPL1                  -- Hier kann durch den Platz gegenüber noch eine Verbessewrung kommen
    and v_ort.lgr_typ <> C.SAT_EPL2
    then
      return;
    end if;


    for v_lo_nr in 1 .. v_lgr_ort_count
    LOOP
      lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab_empty;

      v_lgr_ort := LVS_LORT_IX(v_lgr_orte, v_lo_nr);

      OPEN c_ort;
      FETCH c_ort
        into v_ort;
      v_found := c_ort%FOUND;
      CLOSE c_ort;
      lvs_platz.v_ort := v_ort;
      v_lgr_raster_x := v_ort.lgr_ort_raster_x;
      v_lgr_raster_y := v_ort.lgr_ort_raster_y;
      if v_found then
        if v_ort.lgr_typ = C.SAT1
        or v_ort.lgr_typ = C.KANAL1
        -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
        or v_ort.lgr_typ = C.SEG1
        or v_ort.lgr_typ = C.SEG_DUEDO1
        -- Segmente
        then
          -- Kanal oder SAT-Lager
          OPEN c_lgr_kanal;
          LOOP
            FETCH c_lgr_kanal
              INTO v_lgr_dim_fifo, v_ausl_dispo_faktor_akt, lvs_platz.v_dat_lgr_regal_ebene_faktor,
                   v_abstand_faktor_akt, v_lgr_platz_grp,
                    v_lgr.lgr_dim_g, v_lgr.lgr_dim_r, v_lgr.lgr_dim_p, v_lgr.lgr_dim_e;
            v_found := c_lgr_kanal%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr_in_grp;
                FETCH c_lgr_in_grp
                  into v_lgr;
                v_found := c_lgr_in_grp%FOUND;
                CLOSE c_lgr_in_grp;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_platz_akt := v_lgr.lgr_platz;
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 10;
              END;
            end if;
            EXIT when c_lgr_kanal%NOTFOUND or(v_found_lgr and
                                              not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_kanal;
        elsif v_ort.lgr_typ = C.KANAL_BKL1
           or v_ort.lgr_typ = c.REG_FACH1
          -- Kanal-Blocklager oder Regalfach
          THEN
          OPEN c_lgr_kanal_block;
          LOOP
            FETCH c_lgr_kanal_block
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_dat, v_abstand_faktor_akt;
            v_found := c_lgr_kanal_block%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 20;
              END;
            end if;
            EXIT when c_lgr_kanal_block%NOTFOUND or(v_found_lgr and
                                                    not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_kanal_block;
        elsif v_ort.lgr_typ = c.STAP_FLAE1 then
          -- Flaeche für Stapel
          OPEN c_lgr_stap_flae1;
          LOOP
            FETCH c_lgr_stap_flae1
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_dat, v_abstand_faktor_akt;
            v_found := c_lgr_stap_flae1%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 20;
              END;
            end if;
            EXIT when c_lgr_stap_flae1%NOTFOUND or(v_found_lgr and
                                                    not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_stap_flae1;
        elsif v_ort.lgr_typ = c.STAP_FLAE2 then
          -- Flaeche für Stapel
          OPEN c_lgr_stap_flae2;
          LOOP
            FETCH c_lgr_stap_flae2
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_dat, v_abstand_faktor_akt;
            v_found := c_lgr_stap_flae2%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 20;
              END;
            end if;
            EXIT when c_lgr_stap_flae2%NOTFOUND or(v_found_lgr and
                                                    not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_stap_flae2;
        elsif v_ort.lgr_typ = C.DURCHL1 then
          -- Kanal-Blocklager oder Regalfach
          OPEN c_lgr_durchl;
          LOOP
            FETCH c_lgr_durchl
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_dat, v_abstand_faktor_akt;
            v_found := c_lgr_durchl%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 20;
              END;
            end if;
            EXIT when c_lgr_durchl%NOTFOUND or(v_found_lgr and
                                                    not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_durchl;
        elsif v_ort.lgr_typ = C.EPL1
           or v_ort.lgr_typ = C.PP_EPL1 then
          -- Einzelplatz
          OPEN c_lgr_epl;
          LOOP
            FETCH c_lgr_epl
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_abstand_faktor_akt, lvs_platz.v_dat_lgr_regal_ebene_faktor;
            v_found := c_lgr_epl%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 30;
              END;
            end if;
            EXIT when c_lgr_epl%NOTFOUND or(v_found_lgr and
                                            not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_epl;
        elsif v_ort.lgr_typ = C.SAT_EPL1
           or v_ort.lgr_typ = C.SAT_EPL2
          -- Satelit Einzelplatz
           -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
           -- or v_ort.lgr_typ = C.SEG1
           -- or v_ort.lgr_typ = C.SEG_DUEDO1
          -- Segmente
        then
          OPEN c_lgr_sat_epl;
          LOOP
            FETCH c_lgr_sat_epl
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_dat_lgr_regal_ebene_faktor, v_abstand_faktor_akt, v_fuellgrad_seg, v_faktor_akt;
            v_found := c_lgr_sat_epl%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_ort.lgr_typ = c.SEG1
                or v_ort.lgr_typ = c.SEG_DUEDO1
                then
                  OPEN c_lgr_grp;
                  FETCH c_lgr_grp into v_ausl_dispo_lte_grp, v_ausl_res_lte_grp;
                  CLOSE c_lgr_grp;
                  if v_ausl_dispo_lte_grp > 0
                  or v_ausl_res_lte_grp > 0
                  then
                    v_found := FALSE;
                    v_err_text := LC.ec_p2(LC.O_TP1_LGR_F_LTE_N_GRUND_AUSL, in_lte.lte_id, v_lgr.lgr_platz);
                  end if;
                end if;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 30;
              END;
            end if;
            EXIT when c_lgr_sat_epl%NOTFOUND or(v_found_lgr and
                                            not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_sat_epl;
        else
          -- z.B. Blocklager
          OPEN c_lgr_block;
          LOOP
            FETCH c_lgr_block
              INTO v_lgr_platz_akt, v_ausl_dispo_faktor_akt, v_ausl_dispo_bestand, v_abstand_faktor_akt;
            v_found := c_lgr_block%FOUND;
            if v_found then
              BEGIN
                OPEN c_lgr;
                FETCH c_lgr
                  into v_lgr;
                v_found := c_lgr%FOUND;
                CLOSE c_lgr;
                v_weiter_lgr := FALSE;
                if v_found then
                  v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_R30(in_lte,
                                                                         in_basis_lte_name,
                                                                         in_flaechen_stellplatz_erf,
                                                                         v_lgr,
                                                                         'E',
                                                                         in_fahrzeuge_IDs);
                  -- Ist den dieses ein besserer Platz
                  if v_ausl_dispo_faktor is null
                  or (v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0))
                  or ( v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                   and v_abstand_faktor > v_abstand_faktor_akt)
                  then
                    v_weiter_lgr := TRUE;
                    if v_lgr_text is NULL then
                      v_ausl_dispo_faktor     := v_ausl_dispo_faktor_akt;
                      v_lgr_platz             := v_lgr_platz_akt;
                      v_abstand_faktor        := v_abstand_faktor_akt;
                      v_weiter_lgr            := FALSE;
                      v_found_lgr             := TRUE;
                    end if;
                  else  -- Gefunden jedoch schlechter
                    v_found_lgr             := TRUE;
                  end if;
                end if;
              EXCEPTION
                WHEN OTHERS THEN
                  v_err_nr := 40;
              END;
            end if;
            EXIT when c_lgr_block%NOTFOUND or(v_found_lgr and
                                              not v_weiter_lgr);
          end LOOP;
          CLOSE c_lgr_block;
        end if;
      end if;
    end LOOP;



    if v_found_lgr
    and v_lgr_platz is not NULL
    then

      v_lgr_platz_akt := v_lgr_platz;
      OPEN c_lgr;
      FETCH c_lgr
        into v_lgr;
      CLOSE c_lgr;
      out_lgr_platz := v_lgr;

      if  v_lte_lgr.lgr_platz is not NULL
      then
        lvs_platz.lvs_platz_einl_disp_ruecks(in_lte,        -- in_lte in lvs_lte%ROWTYPE,
                                             v_lte_lgr);    -- in_lgr in lvs_lgr%ROWTYPE
      end if;

      lvs_platz.v_fahrz_res_id := NULL;
      OPEN c_lvs_lgr_grp_fahrzeug;
      FETCH c_lvs_lgr_grp_fahrzeug into lvs_platz.v_fahrz_res_id;

      CLOSE c_lvs_lgr_grp_fahrzeug;

      update lvs_lte lte
         set lte.ziel_lgr_platz = v_lgr_platz
       where lte.lte_id = in_lte.lte_id
         and lte.sid = in_lte.sid
         and lte.firma_nr = in_lte.firma_nr;
      update isi_transport tr
         set tr.lgr_platz_ziel = v_lgr_platz,
             tr.res_id = lvs_platz.v_fahrz_res_id
       where tr.transp_id =  in_transport_id
         and tr.sid = in_lte.sid
         and tr.firma_nr = in_lte.firma_nr;
      -- Update dieser LTE auf neuen Platz
      lvs_platz.lvs_platz_einl_disp_setzen(in_lte,        -- in_lte in lvs_lte%ROWTYPE,
                                           v_lgr);        -- in_lgr in lvs_lgr%ROWTYPE
    end if;
    commit;
  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;    
  end LVS_C_SUCHE_OPTI_EINL_PLATZ;

  function lte_platz_einl_pruef_err_text(in_lte_id             in lvs_lte.lte_id%type,
                                          in_lgr_platz         in lvs_lgr.lgr_platz%type,
                                          in_fahrzeuge_IDs     in varchar2)
                                          return varchar2 is
  v_lte                                   lvs_lte%rowtype;
  v_lgr                                   lvs_lgr%rowtype;

  v_lte_cfg            lvs_lte_cfg%rowtype;
  v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

  CURSOR c_lte_cfg is
    select t.*
      from lvs_lte_cfg t
     where t.sid = v_lte.sid
       and t.firma_nr = v_lte.firma_nr
       and t.lte_name = v_lte.lte_name;

  CURSOR c_lte is
    select *
      from lvs_lte lte
     where lte.lte_id = in_lte_id;

  CURSOR c_lgr is
    select *
      from lvs_lgr lgr
     where lgr.lgr_platz = in_lgr_platz;

  begin
    OPEN c_lte;
    FETCH c_lte into v_lte;
    CLOSE c_lte;

    OPEN c_lgr;
    FETCH c_lgr into v_lgr;
    CLOSE c_lgr;

    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
    return(lvs_platz.lvs_platz_einl_pruef_err_t_R30(v_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, v_lgr, 'E', in_fahrzeuge_IDs));
  end;

  -------------------------------------------------------------------------
  function LVS_PLATZ_REGAL_EBENE_FAKTOR return number is

  begin
    return(lvs_platz.v_dat_lgr_regal_ebene_faktor);
  end LVS_PLATZ_REGAL_EBENE_FAKTOR;

  -------------------------------------------------------------------------
  function LVS_LGR_ABSTAND_FAKTOR return number is

  begin
    return(lvs_platz.v_lgr_abstand_faktor);
  end LVS_LGR_ABSTAND_FAKTOR;
  -------------------------------------------------------------------------
  function LVS_PLATZ_BESTAND_AUSL_FAKTOR return number is

  begin
    return(lvs_platz.v_dat_lgr_bestand_ausl_faktor);
  end LVS_PLATZ_BESTAND_AUSL_FAKTOR;

  -------------------------------------------------------------------------
  function LVS_PLATZ_L_BUCHUNG return date is

  begin
    return(lvs_platz.v_dat_lgr_l_buchung);
  end LVS_PLATZ_L_BUCHUNG;

  -------------------------------------------------------------------------
  function LVS_PLATZ_FAKTOR_BELEGUNG_AKT return number is

  begin
    return(lvs_platz.v_faktor_belegung_akt);
  end LVS_PLATZ_FAKTOR_BELEGUNG_AKT;

  --------------------------------------------------------------------------------
  -- procedure LVS_LTE_FREIFAHREN
  -- lvs_suche_um_platz aufrufen
  -- Dispo in Ziel buchen
  -- Transportauftrag generieren und gleichzeitig prüfen, ob für diese LTE schon
  -- ein Auftrag aktiviert ist, dann gegebenenfalls  denn vorherigen
  --------------------------------------------------------------------------------
  procedure lvs_lte_freifahren(in_lte              in lvs_lte%rowtype,
                               in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
                               in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
                               in_prio             in isi_transport.prio%type,
                               in_fahrzeuge_ids  in varchar2) is

    v_err_nr   PLS_INTEGER;
    v_err_text           varchar2(4096);
    v_error EXCEPTION;
    v_transp_lte         NUMBER;
    v_quelle_lvs_lgr_rec lvs_lgr%ROWTYPE;
    v_ziel_lvs_lgr_rec   lvs_lgr%ROWTYPE;
    v_lgr_platz          lvs_lgr.lgr_platz%type;
    v_found              boolean;
    v_transport_gruppe       isi_transport.transport_gruppe%type;
    v_transport_id           isi_transport.transp_id%type;

    v_lte_cfg            lvs_lte_cfg%rowtype;
    v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;

    CURSOR c_lte_cfg is
      select t.*
        from lvs_lte_cfg t
       where t.sid = in_lte.sid
         and t.firma_nr = in_lte.firma_nr
         and t.lte_name = in_lte.lte_name;

    CURSOR c_lgr is
      select lgr.*
        from lvs_lgr lgr
       where lgr.lgr_platz = in_lte.lgr_platz
         and lgr.sid = in_lte.sid
         and lgr.firma_nr = in_lte.firma_nr;

  begin
    v_err_nr   := NULL;
    v_err_text := NULL;

    -- get source lvs_lgr record
    v_lgr_platz := in_lte.ziel_lgr_platz;

    OPEN c_lgr;
    FETCH c_lgr
      into v_quelle_lvs_lgr_rec;
    v_found := c_lgr%FOUND;
    CLOSE c_lgr;
    if not v_found then
      v_err_nr   := c.FMID_Lager_Platz_fehlt;
      v_err_text := LC.ec_p1(LC.O_TP1_LAGERPLATZ_FEHLT, NVL(in_lte.lgr_platz, 'NULL'));
      RAISE v_error;
    end if;

    -- We search neu place for our "LTE"
    OPEN c_lte_cfg;
    FETCH c_lte_cfg into v_lte_cfg;
    CLOSE c_lte_cfg;

    v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, in_lte.lte_name);
    lvs_platz.lvs_suche_um_platz(in_lte,
                                 v_basis_lte_name,
                                 v_lte_cfg.flaechen_stellplatz_erf,
                                 v_quelle_lvs_lgr_rec,
                                 in_fahrzeuge_IDs,
                                 v_ziel_lvs_lgr_rec);

    -- We generate new auftrag
    v_transport_gruppe := 0;
    v_transp_lte := lvs_transport.lvs_transp_lte(in_lte.sid, -- in_sid                  IN isi_sid.sid%TYPE,
                                                 in_lte.firma_nr, -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
                                                 in_modul_erzeuger, -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,
                                                 in_modul_bearbeiter, -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,
                                                 c.C_TRUE, -- in_frei_fahren          IN varchar2,
                                                 'U', --in_trans_typ            in varchar2,
                                                 0, -- in_user_id              IN isi_user.login_id%TYPE,
                                                 0, -- in_auftrag_id           IN isi_transport.auf_id%TYPE,
                                                 0, -- in_auftrag_id_extern    IN isi_transport.auf_id_extern%TYPE,
                                                 in_prio, -- in_prio                 IN isi_transport.prio%TYPE,
                                                 0, -- in_progr_nr             IN isi_transport.progr_nr%TYPE,
                                                 0, -- in_quelle_leer_progr_nr IN isi_transport.quelle_leer_progr_nr%TYPE,
                                                 0, -- in_ziel_voll_progr_nr   IN isi_transport.ziel_voll_progr_nr%TYPE,
                                                 v_quelle_lvs_lgr_rec.lgr_platz, -- in_lgr_quell_lgr_platz  IN lvs_lte.lgr_platz%TYPE,
                                                 v_ziel_lvs_lgr_rec.lgr_platz, -- in_lgr_ziel_lgr_platz   IN lvs_lte.lgr_platz%TYPE,
                                                 in_lte.lte_id, -- in_lte_id               IN lvs_lte.lte_id%TYPE,
                                                 0, -- in_kunde_nr             IN lvs_lam.kunden_nr%TYPE
                                                 c.C_FALSE, -- in_lieferschein
                                                 NULL, -- Lieferschein Nummer
                                                 NULL, -- Lieferscheinposition -Nummer
                                                 NULL, -- Vorgang_id (Tour)
                                                 in_fahrzeuge_IDs,
                                                 NULL,
                                                 v_transport_gruppe,
                                                 v_transport_id);

  exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
    when v_error then  -- Update 2011 show Exception Source Line
      rollback;
      v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
      RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      raise;
    when others then
      rollback;
      if v_err_nr is not NULL then
        v_err_text := v_err_text  || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
        RAISE_APPLICATION_ERROR(-20000 - v_err_nr, v_err_text, true);
      else
        v_err_text := DBMS_UTILITY.format_error_backtrace;
        if v_err_text not like 'ORA-%ORA-%'
        then
          v_err_text := LC.ec(LC.O_TXT_DB_ERROR) || CHR(13) || CHR(10) || DBMS_UTILITY.format_error_backtrace; 
          RAISE_APPLICATION_ERROR(-20000, v_err_text, true);
        end if;
        raise;
      end if;    
  end lvs_lte_freifahren;

begin
  -- Initialization
  NULL;
end lvs_lager_opt;
/



-- sqlcl_snapshot {"hash":"b661472d098ecaf69dda6498266fb4518570a4e9","type":"PACKAGE_BODY","name":"LVS_LAGER_OPT","schemaName":"DIRKSPZM32","sxml":""}