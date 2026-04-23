create or replace package body dirkspzm32.lvs_lager_opt is

  -- Private type declarations
  --type <TypeName> is <Datatype>;

  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations

  -------------------------------------------------------------------------
    function lvs_lort_format (
        in_lo_a in varchar2
    ) return varchar2 is
    -------------------------------------------------------------------------
    -- [02;01;] && [03;01] = [01;]
        v_error exception;
        v_lo varchar2(255);
    begin
    -- Falls nicht schon geschehen erst mal vormatieren!!!
        v_lo := lvs_prod.str_mb_format(in_lo_a, c.lort_trenner, c.lort_format, c.lort_laenge);

        return ( v_lo );
    end lvs_lort_format;
  -------------------------------------------------------------------------

  -------------------------------------------------------------------------
    function lvs_lort_log_und (
        in_lo_a  in varchar2,
        in_lo_b  in varchar2,
        out_lo_e out varchar2
    ) return varchar2 is
    -------------------------------------------------------------------------
    -- [02;01;] && [03;01] = [01;]
        v_error exception;
    --v_err_nr     number;
    --v_err_text   varchar2(255);
        v_lo   varchar2(255);
        v_lo_a varchar2(255);
        v_lo_b varchar2(255);
    begin
    -- Falls nicht schon geschehen erst mal vormatieren!!!

        v_lo_a := lvs_prod.str_mb_format(in_lo_a, c.lort_trenner, c.lort_format, c.lort_laenge);

        v_lo_b := lvs_prod.str_mb_format(in_lo_b, c.lort_trenner, c.lort_format, c.lort_laenge);

        v_lo := lvs_prod.str_mb_log_und(v_lo_a, v_lo_b, c.lort_laenge);
        out_lo_e := v_lo;
        return ( v_lo );
    end lvs_lort_log_und;
  -------------------------------------------------------------------------
    function lvs_lort_count (
        in_lo in varchar2
    ) return number is
    -------------------------------------------------------------------------
    -- in_lo 02;03;01 = 3

        v_count number;
    begin
        v_count := lvs_prod.str_mb_count(in_lo, c.lort_laenge);
        return ( v_count );
    end lvs_lort_count;

  -------------------------------------------------------------------------
    function lvs_lort_ix (
        in_str_a    in varchar2,
        in_position in number
    ) return lvs_lgr.lgr_ort%type is
    -------------------------------------------------------------------------
    -- 01;03;02; laenge = 3 Position = 2 --> Return(03;)
        v_lo varchar2(255);
    begin
        v_lo := lvs_prod.str_mb_ix(in_str_a, c.lort_laenge, in_position);
    -- das letzte simikplon wird abgeschnitten
        v_lo := substr(v_lo,
                       1,
                       length(v_lo) - 1);
        return ( to_number ( v_lo ) );
    end;

  -------------------------------------------------------------------------
    procedure lvs_kanal_kontrolle (
        in_lte in lvs_lte%rowtype,
        in_lgr in lvs_lgr%rowtype
    )
  -------------------------------------------------------------------------
     as

        v_sum_akt_te                 number;
        v_sum_dispo_te               number;
        v_lgr_einl_te_verfueg_gruppe lvs_lgr.lgr_einl_te_verfueg_gruppe%type;
        v_res                        lvs_lgr.res_string%type;
        v_res_art                    lvs_lgr.res_artikel_id%type;
        v_lgr                        lvs_lgr%rowtype;
        v_lte_typen                  varchar2(80);
        v_tiefe_platz_von            lvs_lgr.lgr_dim_t%type;
        v_tiefe_platz_bis            lvs_lgr.lgr_dim_t%type;
        v_max_dim_fifo               lvs_lgr.lgr_dim_fifo_nr%type;
        v_anz_i_max                  number;
        v_anz_i                      number;
        v_anz_i_geteilt              number;
        v_anz_i_first                number;
        v_anz_i_delta                number;
        v_anz_plaetze_gruppe         number;
        v_lte_cfg                    lvs_lte_cfg%rowtype;
        v_lam                        lvs_lam%rowtype;
        v_lte                        lvs_lte%rowtype;
        v_basis_lte_name             lvs_lte_cfg.basis_lte_name%type;
        cursor c_lagergruppe_leer is
        select
            sum(lgr_akt_te),
            sum(lgr_dispo_einl_te)
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
            and ( ( lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lgr.lgr_dim_e = in_lgr.lgr_dim_e )
                  or ( lgr.lgr_typ != c.seg1
                       and lgr.lgr_typ != c.seg_duedo1 ) )
        group by
            lgr.lgr_platz_gruppe;

        cursor c_lagergruppe is
        select
            sum(lgr_einl_te_verfueg),
            max(lgr.lgr_dim_fifo_nr)
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
        group by
            lgr.lgr_platz_gruppe;

        cursor c_lagergruppe_leer_seg is
        select
            sum(lgr_akt_te),
            sum(lgr_dispo_einl_te)
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
        group by
            lgr.lgr_platz_gruppe;

        cursor c_lagergruppe_letzter is
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
            and ( ( lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lgr.lgr_dim_e = in_lgr.lgr_dim_e )
                  or ( lgr.lgr_typ != c.seg1
                       and lgr.lgr_typ != c.seg_duedo1 ) )
            and ( lgr.lgr_akt_te > 0
                  or lgr.lgr_dispo_einl_te > 0 )
            and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
            and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
        order by
            lgr.lgr_dim_platz desc;

        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.firma_nr = v_lte.firma_nr
            and t.lte_name = v_lte.lte_name;

        cursor c_lgr_gruppe is
        select
            count(t.lgr_platz)
        from
            lvs_lgr t
        where
                t.sid = in_lgr.sid
            and t.firma_nr = in_lgr.firma_nr
            and t.lgr_ort = in_lgr.lgr_ort
            and t.lgr_typ = c.kanal1
            and t.lgr_dim_g = in_lgr.lgr_dim_g
            and t.lgr_dim_r = in_lgr.lgr_dim_r
            and t.lgr_dim_p = in_lgr.lgr_dim_p
            and t.lgr_dim_e = in_lgr.lgr_dim_e
        group by
            t.gruppe
        order by
            t.gruppe;

    begin
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

        v_tiefe_platz_von := null;
        v_tiefe_platz_bis := null;
        if in_lgr.res_res_string_statisch = c.c_true then
            v_res := in_lgr.res_string;
        else
            v_res := null;
        end if;

        if in_lgr.res_art_statisch = c.c_true then
            v_res_art := in_lgr.res_artikel_id;
        else
            v_res_art := null;
        end if;

    -- Erst malaus der Übergabe nehmen
        v_lgr := in_lgr;
        if ( in_lgr.lgr_typ = c.seg_duedo1 ) then
            if mod(in_lgr.lgr_dim_t, 2) = 1 then
                v_tiefe_platz_von := in_lgr.lgr_dim_t;
                v_tiefe_platz_bis := in_lgr.lgr_dim_t + 1;
            else
                v_tiefe_platz_von := in_lgr.lgr_dim_t - 1;
                v_tiefe_platz_bis := in_lgr.lgr_dim_t;
            end if;
        end if;

        open c_lte_cfg;
        fetch c_lte_cfg into v_lte_cfg;
        close c_lte_cfg;
        v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
        if instr(
            nvl(in_lgr.lte_namen_cfg, v_basis_lte_name),
            v_basis_lte_name
        ) = 0 then
            v_basis_lte_name := v_lte.lte_name;
        end if;

        open c_lagergruppe;
        fetch c_lagergruppe into
            v_lgr_einl_te_verfueg_gruppe,
            v_max_dim_fifo;
        close c_lagergruppe;
        open c_lagergruppe_leer;
        fetch c_lagergruppe_leer into
            v_sum_akt_te,
            v_sum_dispo_te;
        close c_lagergruppe_leer;
    -- In der Gruppe (Kanal) ist noch ein Platz besetzt, oder ein Blocklager ist nicht leer
        if ( v_sum_akt_te != 0 )
        or ( v_sum_dispo_te != 0 ) then
      -- Der Aktuelle Platz ist jedoch jetzt leer und nicht disponiert
            if
                in_lgr.lgr_akt_te = 0
                and in_lgr.lgr_dispo_einl_te = 0
            then
        -- dann den letzten besetzten als referenz für der res_string nehmen
                open c_lagergruppe_letzter;
                fetch c_lagergruppe_letzter into v_lgr; -- Holen des letzten gefüllten Eintrags
                if c_lagergruppe_letzter%notfound then
                    v_lgr := in_lgr;
                end if;
                if in_lgr.res_res_string_statisch = c.c_false then
                    v_res := v_lgr.res_string;
                end if;

                close c_lagergruppe_letzter;
            else
                if in_lgr.res_res_string_statisch = c.c_false then
                    v_res := in_lte.res_string;
          -- -AG- Lager ist Vorbereitungslager für die Verladung
                    if in_lgr.lgr_res_strat = 'O' then
                        v_res := nvl(
                            to_char(in_lte.transport_gruppe),
                            in_lte.res_string
                        );
                    end if;

                end if;
            end if;
        end if;

    -- -AG- 16.04.2012 Neuer Lagertyp STAP_FLAE1 Fläche im Lager zum Stapeln von Platten
        if
            ( in_lgr.lgr_typ <> c.sat1 )
            and ( in_lgr.lgr_typ <> c.kanal1 )
            and ( in_lgr.lgr_typ <> c.kanal_bkl1 )
            and ( in_lgr.lgr_typ <> c.durchl1 )
            and ( in_lgr.lgr_typ <> c.reg_fach1 )
            and ( in_lgr.lgr_typ <> c.sat_epl1 )
            and ( in_lgr.lgr_typ <> c.sat_epl2 )
            and ( in_lgr.lgr_typ <> c.seg1 )
            and ( in_lgr.lgr_typ <> c.seg_duedo1 )
            and ( in_lgr.lgr_typ <> c.pp_epl1 )
            and ( in_lgr.lgr_typ <> c.stap_flae1 )
            and ( in_lgr.lgr_typ <> c.stap_flae2 )
        then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Ist nun wieder leer alles rücksetzen oder auf STATISCHE Werte
                if in_lgr.res_art_statisch = c.c_false then
                    update lvs_lgr
                    set
                        res_string = null,
                        res_res_string_statisch = c.c_false,
                        res_artikel_id = null,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

                end if;
            else
                update lvs_lgr
                set
                    res_string = v_res,
                    res_res_string_statisch = c.c_false,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr;

            end if;

            return; -- hier ist nichts mehr zu tun
        end if;

        if ( in_lgr.lgr_typ = c.sat1 )
        or ( in_lgr.lgr_typ = c.kanal1 ) then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Der Kanal ist nun wieder leer alles rücksetzen
                update lvs_lgr
                set
                    lte_namen = lte_namen_cfg,
                    res_string = v_res,
                    res_artikel_id = v_res_art,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                    lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

            else
                v_anz_i_delta := 0;
                if ( in_lgr.lgr_typ = c.kanal1 ) then
                    open c_lgr_gruppe;
                    fetch c_lgr_gruppe into v_anz_plaetze_gruppe;
                    close c_lgr_gruppe;
                    v_anz_i_geteilt := round((v_anz_plaetze_gruppe / 2 * 8 / 10) - 0.5, 0) * 2;

                    v_anz_i_max := round((v_anz_plaetze_gruppe * 8 / 10) - 0.5, 0);

                    v_anz_i_first := round((v_anz_plaetze_gruppe / 2) - 0.5, 0) - round((v_anz_i_geteilt / 2) - 0.5, 0);

                    if v_max_dim_fifo > v_anz_i_max then
                        v_anz_i_delta := v_anz_i_first;
                    end if;
                end if;
        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
                if v_basis_lte_name = c.euro
                or v_basis_lte_name = c.eurok
                or v_basis_lte_name = c.eurokh1
                or v_basis_lte_name = c.chepeuro then
                    if c.ltetypenmischen = 1 then
                        v_lte_typen := '';
                        if in_lgr.lte_namen_cfg like ( '%'
                                                       || c.euro
                                                       || c.te_trenner || '%' ) then
                            v_lte_typen := c.euro || c.te_trenner;
                        end if;

                        if in_lgr.lte_namen_cfg like ( '%'
                                                       || c.eurok
                                                       || c.te_trenner || '%' ) then
                            v_lte_typen := v_lte_typen
                                           || c.eurok
                                           || c.te_trenner;
                        end if;

                        if in_lgr.lte_namen_cfg like ( '%'
                                                       || c.eurokh1
                                                       || c.te_trenner || '%' ) then
                            v_lte_typen := v_lte_typen
                                           || c.eurokh1
                                           || c.te_trenner;
                        end if;

                        if in_lgr.lte_namen_cfg like ( '%'
                                                       || c.chepeuro
                                                       || c.te_trenner || '%' ) then
                            v_lte_typen := v_lte_typen
                                           || c.chepeuro
                                           || c.te_trenner;
                        end if;

                    else
                        v_lte_typen := v_basis_lte_name || c.te_trenner;
                    end if;

                    update lvs_lgr
                    set
                        lte_namen = v_lte_typen,
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr;

                end if;

                if v_basis_lte_name = c.indu
                or v_basis_lte_name = c.chepindu then
                    if c.ltetypenmischen = 1 then
                        v_lte_typen := '';
                        if in_lgr.lte_namen_cfg like ( '%'
                                                       || c.indu
                                                       || c.te_trenner || '%' ) then
                            v_lte_typen := c.indu || c.te_trenner;
                        end if;

                        if in_lgr.lte_namen_cfg like ( '%'
                                                       || c.chepindu
                                                       || c.te_trenner || '%' ) then
                            v_lte_typen := v_lte_typen
                                           || c.chepindu
                                           || c.te_trenner;
                        end if;

                    else
                        v_lte_typen := v_basis_lte_name || c.te_trenner;
                    end if;

                    update lvs_lgr
                    set
                        lte_namen = v_lte_typen,
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr
                        and lgr_dim_fifo_nr <= lvs_lgr.hrl_lag_max_pal_i + v_anz_i_delta;

                    update lvs_lgr
                    set
                        lte_namen = 'Keine',
                        res_string = null,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and ( lgr_dim_fifo_nr <= v_anz_i_delta
                              or lgr_dim_fifo_nr > lvs_lgr.hrl_lag_max_pal_i + v_anz_i_delta );

                end if;

                if
                    v_basis_lte_name != c.euro
                    and v_basis_lte_name != c.eurok
                    and v_basis_lte_name != c.eurokh1
                    and v_basis_lte_name != c.chepeuro
                    and v_basis_lte_name != c.indu
                    and v_basis_lte_name != c.chepindu
                then
                    v_lte_typen := v_basis_lte_name || c.te_trenner;
                    update lvs_lgr
                    set
                        lte_namen = v_lte_typen,
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and ( lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr
                              or lvs_lgr.lgr_dim_fifo_nr > (
                            select
                                max(x.lgr_dim_fifo_nr)
                            from
                                lvs_lgr x
                            where
                                    x.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                                and x.lgr_akt_te > 0
                        ) );

                end if;

                update lvs_lgr
                set
                    lte_namen = 'Keine',
                    res_string = null,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and ( lvs_lgr.lgr_dim_fifo_nr < (
                        select
                            max(x.lgr_dim_fifo_nr)
                        from
                            lvs_lgr x
                        where
                                x.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                            and ( x.lgr_akt_te > 0
                                                /* Falsch, heir werden Lücken gezogen, wenn 
                                                   Paletten ausgelagert werden und beites weitere 
                                                   zu diesem Kanal disponiert sind
                                                or x.lgr_dispo_einl_te > 0 */ )
                    )
               --or
               --lvs_lgr.lgr_dim_fifo_Nr < in_lgr.lgr_dim_fifo_nr
                     )
                    and lvs_lgr.lgr_akt_te = 0
                    and lvs_lgr.lgr_dispo_einl_te = 0;

            end if; -- v_Sum_akt_te
      -- ENDE c_sat_1
        elsif ( in_lgr.lgr_typ = c.seg1 ) then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Der Kanal ist nun wieder leer alles rücksetzen
                update lvs_lgr
                set
                    res_string = v_res,
                    res_artikel_id = v_res_art,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr
                    and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e;

                open c_lagergruppe_leer_seg;
                fetch c_lagergruppe_leer_seg into
                    v_sum_akt_te,
                    v_sum_dispo_te;
                close c_lagergruppe_leer_seg;
                if
                    ( v_sum_akt_te = 0 )
                    and ( v_sum_dispo_te = 0 )
                then
                    update lvs_lgr
                    set
                        lte_namen = lte_namen_cfg,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

                end if;

            else
        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
                v_lte_typen := v_basis_lte_name || c.te_trenner;
                update lvs_lgr
                set
                    lte_namen = v_lte_typen,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lte_namen_cfg like ( '%'
                                             || v_basis_lte_name
                                             || c.te_trenner || '%' );

                update lvs_lgr
                set
                    lte_namen = 'Keine',
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lte_namen not like ( '%'
                                             || v_basis_lte_name
                                             || c.te_trenner || '%' );

                update lvs_lgr
                set
                    lte_namen = 'Keine',
                    res_string = null,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e
                    and ( lvs_lgr.lgr_dim_fifo_nr < (
                        select
                            max(x.lgr_dim_fifo_nr)
                        from
                            lvs_lgr x
                        where
                                x.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                            and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
                            and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
                            and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
                            and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e
                            and ( x.lgr_akt_te > 0
                                                /* Falsch, heir werden Lücken gezogen, wenn 
                                                   Paletten ausgelagert werden und beites weitere 
                                                   zu diesem Kanal disponiert sind
                                                or x.lgr_dispo_einl_te > 0 */ )
                    )
                          or lvs_lgr.lgr_dim_fifo_nr < in_lgr.lgr_dim_fifo_nr )
                    and lvs_lgr.lgr_akt_te = 0
                    and lvs_lgr.lgr_dispo_einl_te = 0;

                update lvs_lgr
                set
                    res_string = nvl(v_res, res_string),
                    res_artikel_id = nvl(v_res_art, res_artikel_id)
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr
                    and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e;

            end if; -- v_Sum_akt_te
        elsif ( in_lgr.lgr_typ = c.seg_duedo1 ) then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Der Kanal ist nun wieder leer alles rücksetzen
        -- Hier werden Einträge für eien Paltz korrekt Zurückgesetzt
                update lvs_lgr
                set
                    res_string = v_res,
                    res_artikel_id = v_res_art,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr
                    and lvs_lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lvs_lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lvs_lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lvs_lgr.lgr_dim_e = in_lgr.lgr_dim_e;

                update lvs_lgr lgr
                set
                    lte_namen = lte_namen_cfg,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lgr.lgr_dim_e = in_lgr.lgr_dim_e
                    and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
                    and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
                    and mod(lgr.lgr_dim_t, 2) = 1;

                update lvs_lgr lgr
                set
                    lte_namen = 'Keine',
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lgr.lgr_dim_e = in_lgr.lgr_dim_e
                    and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
                    and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
                    and mod(lgr.lgr_dim_t, 2) = 0;

                open c_lagergruppe_leer_seg;
                fetch c_lagergruppe_leer_seg into
                    v_sum_akt_te,
                    v_sum_dispo_te;
                close c_lagergruppe_leer_seg;
        -- Ist das ganze Segment leer, dann das ganze Segment abschließen
                if
                    ( v_sum_akt_te = 0 )
                    and ( v_sum_dispo_te = 0 )
                then
                    update lvs_lgr
                    set
                        lte_namen = lte_namen_cfg,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and mod(lvs_lgr.lgr_dim_t, 2) = 1;

                    update lvs_lgr
                    set
                        lte_namen = 'Keine',
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and mod(lvs_lgr.lgr_dim_t, 2) = 0;

                end if;
        -- Ende -- Hier werden Einträge für eien Paltz und Segment korrekt Zurückgesetzt
            else

        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
        -- Erst mal die Einträge für den Platz setzen !!
                v_lte_typen := v_basis_lte_name || c.te_trenner;
                update lvs_lgr lgr
                set
                    lte_namen = v_lte_typen,
                    res_string = nvl(v_res, res_string),
                    res_artikel_id = nvl(v_res_art, res_artikel_id),
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr.lgr_dim_g = in_lgr.lgr_dim_g
                    and lgr.lgr_dim_r = in_lgr.lgr_dim_r
                    and lgr.lgr_dim_p = in_lgr.lgr_dim_p
                    and lgr.lgr_dim_e = in_lgr.lgr_dim_e
                    and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
                    and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t);

                if v_lte_typen = c.duedo || c.te_trenner then
                    v_lte_typen := v_lte_typen
                                   || c.euro
                                   || c.te_trenner;
                else
                    update lvs_lgr lgr
                    set
                        lte_namen = 'Keine',
                        res_string = nvl(v_res, res_string),
                        res_artikel_id = nvl(v_res_art, res_artikel_id),
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and lgr.lgr_dim_g = in_lgr.lgr_dim_g
                        and lgr.lgr_dim_r = in_lgr.lgr_dim_r
                        and lgr.lgr_dim_p = in_lgr.lgr_dim_p
                        and lgr.lgr_dim_e = in_lgr.lgr_dim_e
                        and lgr.lgr_dim_t >= nvl(v_tiefe_platz_von, lgr.lgr_dim_t)
                        and lgr.lgr_dim_t <= nvl(v_tiefe_platz_bis, lgr.lgr_dim_t)
                        and mod(lgr.lgr_dim_t, 2) = 0;

                    if v_lte_typen = c.euro || c.te_trenner then
                        v_lte_typen := v_lte_typen
                                       || c.duedo
                                       || c.te_trenner;
                    end if;

                end if;

                update lvs_lgr
                set
                    lte_namen = 'Keine',
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lte_namen_cfg not like ( '%'
                                                 || v_basis_lte_name || '%' )
                    and mod(lgr_dim_t, 2) = 1;

                update lvs_lgr
                set
                    lte_namen = v_lte_typen,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lte_namen != c.duedo || c.te_trenner
                    and lte_namen_cfg like ( '%'
                                             || v_basis_lte_name || '%' )
                    and mod(lgr_dim_t, 2) = 1;

                update lvs_lgr
                set
                    lte_namen = 'Keine',
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lte_namen != c.duedo || c.te_trenner
                    and lte_namen_cfg not like ( '%'
                                                 || v_basis_lte_name
                                                 || c.te_trenner || '%' )
                    and mod(lgr_dim_t, 2) = 0;

            end if; -- v_Sum_akt_te
        elsif ( in_lgr.lgr_typ = c.sat_epl1 )
        or ( in_lgr.lgr_typ = c.sat_epl2 ) then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Der Kanal ist nun wieder leer alles rücksetzen
                if in_lgr.res_res_string_statisch = c.c_false
                or in_lgr.res_art_statisch = c.c_false then
                    update lvs_lgr
                    set
                        lte_namen = lte_namen_cfg,
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

                end if;

            else
        -- Die erste TE ist im Kanal, oder dahin unterwegs also alles auf Euro oder Indu umschalten
        -- die nicht benutzbaren auf LTE_NAME=''
                if v_basis_lte_name = c.euro then
                    update lvs_lgr
                    set
                        lte_namen = c.euro || c.te_trenner,
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

                end if;

                if v_basis_lte_name = c.indu then
                    update lvs_lgr
                    set
                        lte_namen = c.indu || c.te_trenner,
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and lgr_dim_fifo_nr <= lvs_lgr.hrl_lag_max_pal_i;

                    update lvs_lgr
                    set
                        lte_namen = 'Keine',
                        res_string = null
                    where
                            lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                        and lgr_dim_fifo_nr > lvs_lgr.hrl_lag_max_pal_i;

                end if;

            end if; -- v_Sum_akt_te
      -- ENDE c_sat_EPL1 c.SAT_EPL2
        elsif ( in_lgr.lgr_typ in ( c.kanal1, c.kanal_bkl1, c.reg_fach1, c.stap_flae1, c.stap_flae2 ) ) then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Der Kanal ist nun wieder leer alles rücksetzen
                if in_lgr.res_res_string_statisch = c.c_false
                or in_lgr.res_art_statisch = c.c_false then
                    update lvs_lgr
                    set
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

                end if;

            else
        -- Die naechste TE ist im Kanal, oder dahin unterwegs also Reservierung setzen
                update lvs_lgr
                set
                    res_string = v_res,
                    res_artikel_id = v_res_art,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr;

            end if; -- v_Sum_akt_te
        elsif ( in_lgr.lgr_typ in ( c.durchl1 ) ) then
            if
                ( v_sum_akt_te = 0 )
                and ( v_sum_dispo_te = 0 )
            then
        -- Der Kanal ist nun wieder leer alles rücksetzen
                if in_lgr.res_res_string_statisch = c.c_false
                or in_lgr.res_art_statisch = c.c_false then
                    update lvs_lgr
                    set
                        res_string = v_res,
                        res_artikel_id = v_res_art,
                        lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                    where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe;

                end if;

            else
        -- Die naechste TE ist im Kanal, oder dahin unterwegs also Reservierung setzen
                update lvs_lgr
                set
                    res_string = v_res,
                    res_artikel_id = v_res_art,
                    lgr_einl_te_verfueg_gruppe = v_lgr_einl_te_verfueg_gruppe
                where
                        lvs_lgr.lgr_platz_gruppe = in_lgr.lgr_platz_gruppe
                    and lgr_dim_fifo_nr >= in_lgr.lgr_dim_fifo_nr;

            end if; -- v_Sum_akt_te
        end if; -- c_sat_1
    end lvs_kanal_kontrolle;

  --******************************************************************************
  --------------------------------------------------------------------------------
  -- function loescht alle Transporte einer Verladung
  --
  -- mit COMMIT
  --------------------------------------------------------------------------------
  --******************************************************************************
    procedure c_kompress (
        in_sid              in isi_sid.sid%type,
        in_firma_nr         in isi_firma.firma_nr%type,
        in_lgr_ort          in lvs_lgr_ort.lgr_ort%type,
        in_lgr_platz_grp    in varchar2,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_login_id         in isi_user.login_id%type
    ) is
    -------------------------------------------------------------------------------------------------------
    -- Standard Fehler Felder für Exception
    -------------------------------------------------------------------------------------------------------
        v_error exception;
        v_err_nr               number;
        v_err_text             varchar2(4096);

    -- -AG- Fehler: Der Lagerplatz darf immer nur in der gleichen Lagerplatz_GRP sein
        v_platz_gruppe         lvs_lgr.lgr_platz_gruppe%type;
        v_lgr_ort              lvs_lgr.lgr_ort%type;
        v_lgr_ort_grp          lvs_lgr.lgr_gruppe_id%type;
        v_lgr_platz            lvs_lgr.lgr_platz%type;
        v_lte_id               lvs_lte.lte_id%type;
        v_wtyp                 lvs_lte.waren_typ%type;
        v_anz_lhm              number;
        v_res_string           lvs_lte.res_string%type;
        v_res_artikel_id       lvs_lte.res_artikel_id%type;
        v_min_art_id           isi_artikel.artikel_id%type;
        v_max_art_id           isi_artikel.artikel_id%type;
        v_res_mhd              lvs_lte.res_mhd%type;
        v_min_mhd              lvs_lam.lam_mhd%type;
        v_max_mhd              lvs_lam.lam_mhd%type;
        v_min_prod_dat         lvs_lam.prod_datum%type;
        v_lte_name             lvs_lte.lte_name%type;
        v_lgr_regal            lvs_lgr.lgr_dim_r%type;
        v_lgr_hoehe            lvs_lgr.lgr_vol_hoehe%type;
        v_grp_lgr_platz_gruppe lvs_lgr.lgr_platz_gruppe%type;
        v_grp_frei_platz_te    number;
        v_grp_res_string       lvs_lte.res_string%type;
        v_tr_id                number;
        v_ret                  number;
        v_pos_s                number;
        v_ziel_platz           lvs_lgr.lgr_platz%type;
        v_transport_gruppe     isi_transport.transport_gruppe%type;
        v_found                boolean;                                  -- Daten gefunden

        cursor c_lgr_platz_lte_bestand is
        select
            min(lgr.lgr_platz_gruppe)  platz_gruppe,
            lte.lgr_platz,
            lte.lte_id,
            min(lte.waren_typ)         wtyp,
            max(lte.lte_akt_lhm)       anz_lhm,
            lte.res_string,
            lte.res_artikel_id,
            min(lam.artikel_id)        min_art_id,
            min(lam.artikel_id)        max_art_id,
            lte.res_mhd,
            min(lam.lam_mhd)           min_mhd,
            max(lam.lam_mhd)           max_mhd,
            trunc(min(lam.prod_datum)) min_prod_dat,
            nvl(lte_cfg.basis_lte_name,
                min(lte.lte_name))     basis_lte_name,
            lgr.lgr_ort,
            lgr.lgr_gruppe_id,
            lgr.lgr_dim_r,
            max(lgr.lgr_vol_hoehe)
        from
            lvs_lgr     lgr,
            lvs_lte     lte,
            lvs_lte_cfg lte_cfg,
            lvs_lam     lam
        where
            ( in_lgr_platz_grp like ( lgr.lgr_platz_gruppe || ';%' )
              or in_lgr_platz_grp like ( '%;'
                                         || lgr.lgr_platz_gruppe || ';%' ) )
            and lgr.lgr_platz = lte.lgr_platz
            and lte.lte_id = lam.lte_id
            and lte_cfg.sid = lte.sid
            and lte_cfg.firma_nr = lte.firma_nr
            and lte_cfg.lte_name = lte.lte_name
            and lte.lgr_ort = in_lgr_ort
        group by
            lte.lgr_platz,
            lte.lte_id,
            lgr.lgr_dim_fifo_nr,
            lte.res_string,
            lte.res_artikel_id,
            lte.res_mhd,
            lgr.lgr_ort,
            lgr.lgr_gruppe_id,
            basis_lte_name,
            lgr.lgr_dim_r
        order by
            platz_gruppe,
            lgr.lgr_dim_fifo_nr desc;

      -- AG Anpassung für kanal-lager (SAT-Lager mit dynamischer Tiefe Erster Platz ist dann nicht = LGR-PLATZ-GRP)
        cursor c_lgr_platz_grp is
        select
            lgr_platz_gruppe,
            sum(max_te) - sum(akt_te) frei_platz_te,
            decode(
                min(res_string),
                max(res_string),
                min(res_string),
                decode(
                    min(substr(res_string, 1, v_pos_s)),
                    max(substr(res_string, 1, v_pos_s)),
                    min(substr(res_string, 1, v_pos_s)),
                    'Mischkanal'
                )
            )                         res_string
        from
            (
                select
                    sum(lgr.lgr_akt_te)                                               akt_te,
                    sum(lgr.lgr_max_te)                                               max_te,
                       --sum(lgr.lgr_einl_te_verfueg),
                    decode(sum(lgr.lgr_max_te) - sum(lgr.lgr_akt_te),
                           0,
                           'V',
                           decode(sum(lgr.lgr_max_te) - sum(lgr.lgr_einl_te_verfueg),
                                  0,
                                  'L',
                                  'A'))                                               kanal,
                    sum(lgr.lgr_max_te) - sum(lgr.lgr_akt_te + lgr.lgr_dispo_einl_te) voll_0,
                    sum(lgr.lgr_max_te) - sum(lgr.lgr_einl_te_verfueg)                leer_0,
                    lgr.lgr_platz_gruppe,
                    sum(lgr.lgr_dispo_ausl_te)                                        lgr_dispo_ausl_te,
                    sum(lgr.lgr_dispo_einl_te)                                        lgr_dispo_einl_te,
                    decode(
                        min(lgr.res_string),
                        max(lgr.res_string),
                        min(lgr.res_string),
                        'Mischkanal'
                    )                                                                 res_string,
                    sum(decode(
                        nvl(lte.order_vorgang_id, 0),
                        0,
                        0,
                        1
                    ))                                                                vorg_id,
                    min(lgr.lte_namen)                                                lte_namen,
                    lgr.uml_erlaubt,
                    lgr.lgr_dim_r,
                    min(lgr.lgr_vol_hoehe)                                            lgr_vol_hoehe
                from
                    lvs_lgr     lgr,
                    lvs_lte     lte,
                    lvs_lgr     lte_lgr,
                    lvs_lte_cfg lte_cfg
                where
                        lgr.sid = in_sid
                    and lgr.firma_nr = in_firma_nr
                    and lgr.gesperrt = c.lgr_gesperrt_f
                    and lgr.akt_inventur_id is null
                    and lgr.lgr_ort = in_lgr_ort
                    and lgr.lgr_verwendung = c.lgr_typ_lager
                    and nvl(lgr.lte_namen,
                            nvl(lgr.lte_namen_cfg, 'alle')) is not null
                    and lte.lte_name = lte_cfg.lte_name (+)
                    and ( nvl(lgr.lte_namen, lte.lte_name || ';') like ( '%'
                                                                         || lte.lte_name || '%' )
                          or nvl(lgr.lte_namen, lte_cfg.basis_lte_name || ';') like ( '%'
                                                                                      || lte_cfg.basis_lte_name || '%' ) )
                    and lte.sid = in_sid
                    and lte.firma_nr = in_firma_nr
                    and lgr.lgr_platz_gruppe = lte.lgr_platz_gruppe
                    and lgr.lgr_ort = v_lgr_ort
                    and lgr.lgr_gruppe_id = v_lgr_ort_grp
                    and lte_lgr.lgr_platz = lte.lgr_platz
                    and lte_lgr.lgr_dim_fifo_nr = 1
                group by
                    lgr.lgr_platz_gruppe,
                    lgr.lgr_dim_r,
                    lgr.uml_erlaubt
                having
                    sum(lgr.lgr_einl_te_verfueg) > 0
            )
        where
                kanal = 'A'
            and vorg_id = 0
            and in_lgr_platz_grp not like ( '%'
                                            || lgr_platz_gruppe || ';%' )
            and lte_namen like ( '%'
                                 || v_lte_name || ';%' )
            and lgr_vol_hoehe >= v_lgr_hoehe
            and ( lgr_dim_r = v_lgr_regal
                  or uml_erlaubt = 'T' )
        group by
            kanal,
            lgr_platz_gruppe,
            lgr_vol_hoehe
        having
            sum(lgr_dispo_ausl_te) = 0
        order by
            decode(res_string,
                   v_res_string,
                   0,
                   decode(
                substr(res_string, 1, v_pos_s),
                substr(v_res_string, 1, v_pos_s),
                1,
                decode(res_string, 'Mischkanal', 2, 3)
            )),
            lgr_vol_hoehe - v_lgr_hoehe,
            frei_platz_te;

        cursor c_lgr_platz is
        select
            lgr.lgr_platz
        from
            lvs_lgr lgr
        where
                sid = in_sid
            and firma_nr = in_firma_nr
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.lgr_platz_gruppe = v_grp_lgr_platz_gruppe
        order by
            lgr.lgr_dim_fifo_nr asc;

    begin
        v_err_nr := null;
        v_err_text := null;
        v_pos_s := instr(v_res_string, ';', 1, 1);
        open c_lgr_platz_lte_bestand;
        fetch c_lgr_platz_lte_bestand into
            v_platz_gruppe,
            v_lgr_platz,
            v_lte_id,
            v_wtyp,
            v_anz_lhm,
            v_res_string,
            v_res_artikel_id,
            v_min_art_id,
            v_max_art_id,
            v_res_mhd,
            v_min_mhd,
            v_max_mhd,
            v_min_prod_dat,
            v_lte_name,
            v_lgr_ort,
            v_lgr_ort_grp,
            v_lgr_regal,
            v_lgr_hoehe;

        loop
            exit when c_lgr_platz_lte_bestand%notfound;
            v_pos_s := instr(v_res_string, ';', 1, 1);
            if nvl(v_pos_s, 0) = 0 then
                v_pos_s := nvl(
                    length(v_res_string),
                    100
                );
            end if;

            open c_lgr_platz_grp;
            fetch c_lgr_platz_grp into
                v_grp_lgr_platz_gruppe,
                v_grp_frei_platz_te,
                v_grp_res_string;
            v_found := c_lgr_platz_grp%found;
            close c_lgr_platz_grp;
            if not v_found then
                v_err_nr := 10;
                v_err_text := lc.ec(lc.o_txt_opti_frei_plaetze_n_ausr);
                close c_lgr_platz_lte_bestand;
                raise v_error;
            else
                open c_lgr_platz;
                fetch c_lgr_platz into v_ziel_platz;
                v_found := c_lgr_platz%found;
                close c_lgr_platz;
                if not v_found then
                    v_err_nr := 20;
                    v_err_text := lc.ec_p1(lc.o_tp1_z_platz_in_grp_n_lesbar, v_grp_lgr_platz_gruppe);
                    close c_lgr_platz_lte_bestand;
                    raise v_error;
                else
                    v_transport_gruppe := 0;
                    v_ret := lvs_transport.lvs_transp_lte(in_sid,                         -- in_sid                  IN isi_sid.sid%TYPE,
                     in_firma_nr,                    -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
                     in_modul_erzeuger,              -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,
                     in_modul_bearbeiter,            -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,
                     c.c_false,                      -- in_frei_fahren          IN varchar2,
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
                                                           c.c_false,                      -- in_lieferschein
                                                           null,                           -- Lieferschein Nummer
                                                           null,                           -- Lieferscheinposition -Nummer
                                                          null,                           -- Vorgang_id (Tour)
                                                           null,                           -- in_fahrzeuge_IDs Hier muss im Vorfeld geprüft sein, ob die Fahrzeuge OK sind
                                                           null, v_transport_gruppe, v_tr_id);

                    if v_ret <> 0 then
                        v_err_nr := 30;
                        v_err_text := c.decode_function_fehler(v_ret);
                        close c_lgr_platz_lte_bestand;
                        raise v_error;
                    end if;

                end if;

            end if;

            fetch c_lgr_platz_lte_bestand into
                v_platz_gruppe,
                v_lgr_platz,
                v_lte_id,
                v_wtyp,
                v_anz_lhm,
                v_res_string,
                v_res_artikel_id,
                v_min_art_id,
                v_max_art_id,
                v_res_mhd,
                v_min_mhd,
                v_max_mhd,
                v_min_prod_dat,
                v_lte_name,
                v_lgr_ort,
                v_lgr_ort_grp,
                v_lgr_regal,
                v_lgr_hoehe;

        end loop;

        close c_lgr_platz_lte_bestand;
        commit;
    exception
    -- Im Fehlerfall is der Fehler bereits gesetzt, als lam_id wird 0 zurückgegeben.
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            if c_lgr_platz_lte_bestand%isopen then
                close c_lgr_platz_lte_bestand;
            end if;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if c_lgr_platz_lte_bestand%isopen then
                close c_lgr_platz_lte_bestand;
            end if;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end c_kompress;

  ---------------------------------------------------------------------------------------------------------------
    procedure lvs_c_lager_reset is

        v_lgr        lvs_lgr%rowtype;
        v_lte        lvs_lte%rowtype;
        v_anz_lte    number;
        v_anz_kg     number;
        v_res_string varchar2(100);
        v_lgr_platz  lvs_lgr.lgr_platz%type;

--    CURSOR c_lte is
--      select * from lvs_lte;

        cursor c_lgr is
        select
            *
        from
            lvs_lgr t
        where
            t.lgr_platz = v_lgr_platz
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

        cursor c_lte_lgr is
        select
            *
        from
            lvs_lte lte
        where
            lte.lgr_platz = v_lgr_platz;

        cursor c_lte_lgr_grp is
        select
            lte.lgr_platz,
            nvl(
                count(lte_id),
                0
            ),
            sum(nvl(lte.lte_akt_kg, 0)),
            decode(
                min(lte.res_string),
                max(lte.res_string),
                min(lte.res_string),
                null
            )
        from
            lvs_lte lte
        where
            lte.lgr_platz is not null
        group by
            lte.lgr_platz;

        cursor c_lgr_lte_size is
        select
            max(nvl(lte.lte_vol_breite, lgr.lgr_vol_breite)),
            max(nvl(lte.lte_vol_tiefe, lgr.lgr_vol_tiefe))
        from
            lvs_lgr lgr,
            lvs_lte lte
        where
                lgr.lgr_platz = v_lgr.lgr_platz
            and lgr.lgr_platz = lte.lgr_platz (+);

    begin
        delete from isi_transport;

        update lvs_lte lte
        set
            lte.ziel_lgr_ort = null,
            lte.ziel_lgr_platz = null,
            lte.ziel_lgr_ort_n_freif = null,
            lte.ziel_lgr_platz_n_freif = null,
            lte.order_auf_id = null,
            lte.order_vorgang_id = null,
            lte.lte_status = decode(lte.lgr_platz,
                                    null,
                                    decode(lte.lte_status, 'PF', 'PF', 'KF'),
                                    decode((
                                             select
                                                 lgr.lgr_verwendung
                                             from
                                                 lvs_lgr lgr
                                             where
                                                     lgr.sid = lte.sid
                                                 and lgr.lgr_platz = lte.lgr_platz
                                         ), c.lgr_typ_we, c.lte_bf_stat, c.lgr_typ_lagerp, c.lte_bs_stat,
                                           c.lgr_typ_wa, c.lte_af_stat, c.lgr_typ_ep, c.lte_et_stat, c.lte_lf_stat));

        update isi_order_kopf kopf
        set
            kopf.freigegeben_datum = null,
            kopf.status = 'N'
        where
                kopf.status != 'N'
            and kopf.status not in ( 'E', 'Z', 'XF' ); -- Alle engültig Abgeschlossen
        update isi_order_pos pos
        set
            pos.freigegeben_datum = null,
            pos.status = 'N',
            pos.ware_disponiert = c.c_false
        where
                pos.status != 'N'
            and pos.status not in ( 'E', 'Z', 'XF' ); -- Alle engültig Abgeschlossen
        update lvs_lgr lgr
        set
            lgr.lgr_akt_te = 0,
            lgr.lgr_akt_kg = 0,
            lgr.lgr_dispo_einl_frei_hoehe = 0,
            lgr.lgr_dispo_einl_te = 0,
            lgr.lgr_dispo_ausl_te = 0,
            lgr.lgr_order_res_te = 0,
            lgr.lgr_dispo_einl_kg = 0,
            lgr.lgr_dispo_ausl_kg = 0,
            lgr.lgr_einl_te_verfueg = lgr.lgr_max_te,
            lgr.res_string = decode(lgr.res_res_string_statisch, c.c_true, lgr.res_string, null),
            lgr.lte_namen =
                case
                    when lgr.lgr_typ = c.seg_duedo1
                         and mod(lgr.lgr_dim_t, 2) = 0 then
                        'Keine'
                    else
                        lgr.lte_namen_cfg
                end;

        open c_lte_lgr_grp;
        v_anz_lte := 0;
        v_anz_kg := 0;
        v_res_string := null;
        fetch c_lte_lgr_grp into
            v_lgr_platz,
            v_anz_lte,
            v_anz_kg,
            v_res_string;
        while ( c_lte_lgr_grp%found ) loop
            open c_lgr;
            fetch c_lgr into v_lgr;
            if c_lgr%found then
                v_lte := null;
                open c_lte_lgr;
                fetch c_lte_lgr into v_lte;
                close c_lte_lgr;
                v_lgr.lgr_akt_te := nvl(v_anz_lte, 0);
                v_lgr.lgr_akt_kg := nvl(v_anz_kg, 0);
                v_lgr.lgr_dispo_einl_frei_hoehe := 0;
                v_lgr.lgr_dispo_einl_te := 0;
                v_lgr.lgr_dispo_ausl_te := 0;
                v_lgr.lgr_order_res_te := 0;
                v_lgr.lgr_dispo_einl_kg := 0;
                v_lgr.lgr_dispo_ausl_kg := 0;
                v_lgr.lgr_einl_te_verfueg := nvl(v_lgr.lgr_max_te, 0) - nvl(v_lgr.lgr_akt_te, 0);

                if v_lgr.lgr_typ = c.stap_flae1 then
                    open c_lgr_lte_size;
                    fetch c_lgr_lte_size into
                        v_lgr.lgr_vol_breite,
                        v_lgr.lgr_vol_tiefe;
                    close c_lgr_lte_size;
                    v_lgr.lgr_vol_breite := ( nvl(v_lgr.lgr_vol_breite, 0) + 499 ) / isi_allg.c_get_firma_cfg_param(v_lgr.sid,                        -- in_sid                   in isi_firma_cfg.sid%type,
                     v_lgr.firma_nr,                   -- in_firma_nr              in isi_firma_cfg.firma_nr%type,
                     'CFG',                            -- in_kategorie             in isi_firma_cfg.kategorie%type,
                     'RASTER_MM',                      -- in_kategorie_ix          in isi_firma_cfg.kategorie_ix%type,
                     'c.STAP_FLAE1',                   -- in_parameter_name        in isi_firma_cfg.parameter_name%type,
                                                                                                                    'LVS',                            -- in_modul_name            in isi_firma_cfg.modul_name%type,
                                                                                                                     'CFG',                            -- in_typ                   in isi_firma_cfg.typ%type,
                                                                                                                     500,                              -- in_default_param_wert    in isi_firma_cfg.parameter_wert%type,
                                                                                                                     'INTEGER');                       -- in_default_param_typ     in isi_firma_cfg.parameter_typ%type
                    v_lgr.lgr_vol_tiefe := ( nvl(v_lgr.lgr_vol_tiefe, 0) + 499 ) / isi_allg.c_get_firma_cfg_param(v_lgr.sid,                        -- in_sid                   in isi_firma_cfg.sid%type,
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
                set
                    lgr.lgr_akt_te = nvl(v_anz_lte, 0),
                    lgr.lgr_akt_kg = nvl(v_anz_kg, 0),
                    lgr.lgr_frei_hoehe = decode(lgr.lgr_typ,
                                                c.reg_fach1,
                                                lgr.lgr_vol_hoehe -(
                                                                 select
                                                                     sum(t.lte_vol_hoehe)
                                                                 from
                                                                     lvs_lte t
                                                                 where
                                                                     t.lgr_platz = lgr.lgr_platz
                                                             ),
                                                c.stap_flae1,
                                                lgr.lgr_vol_hoehe -(
                                                                 select
                                                                     sum(t.lte_vol_hoehe)
                                                                 from
                                                                     lvs_lte t
                                                                 where
                                                                     t.lgr_platz = lgr.lgr_platz
                                                             ),
                                                c.stap_flae2,
                                                lgr.lgr_vol_hoehe -(
                                                                 select
                                                                     sum(t.lte_vol_hoehe)
                                                                 from
                                                                     lvs_lte t
                                                                 where
                                                                     t.lgr_platz = lgr.lgr_platz
                                                             ),
                                                lgr.lgr_vol_hoehe),
                    lgr.lgr_frei_breite = v_lgr.lgr_vol_breite,
                    lgr.lgr_frei_tiefe = v_lgr.lgr_vol_tiefe,
                    lgr.lgr_dispo_einl_frei_hoehe = 0,
                    lgr.lgr_dispo_einl_te = 0,
                    lgr.lgr_dispo_ausl_te = 0,
                    lgr.lgr_order_res_te = 0,
                    lgr.lgr_dispo_einl_kg = 0,
                    lgr.lgr_dispo_ausl_kg = 0,
                    lgr.lgr_einl_te_verfueg = v_lgr.lgr_einl_te_verfueg
                where
                    current of c_lgr;

            else
                dbms_output.put_line('Fehler: Lagerplatz '
                                     || nvl(v_lgr_platz, 'NULL') || ' fehlt.');
            end if;

            close c_lgr;
            lvs_kanal_kontrolle(v_lte, v_lgr);
            v_anz_lte := 0;
            v_anz_kg := 0;
            v_res_string := null;
            fetch c_lte_lgr_grp into
                v_lgr_platz,
                v_anz_lte,
                v_anz_kg,
                v_res_string;
        end loop;

        close c_lte_lgr_grp;
        update lvs_lam lam
        set
            lam.lgr_platz = (
                select
                    lgr_platz
                from
                    lvs_lte
                where
                    lte_id = lam.lte_id
            ),
            lam.order_pos_auf_id = null;

        commit;
    end lvs_c_lager_reset;

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
    procedure lvs_c_transp_suche_einl_opti (
        in_lte_id         in lvs_lte.lte_id%type,
        in_transport_id   in isi_transport.transp_id%type,
        in_synch_trans_id in isi_transport.transp_id%type,
        in_fahrzeuge_ids  in varchar2,
        out_lgr_platz     out lvs_lgr.lgr_platz%type,
        out_lte_id        out lvs_lte.lte_id%type,
        out_prio          out number
    ) is
    -------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(4096);
    -------------------------------------------------------------------------
        v_lte            lvs_lte%rowtype;
        v_lte_ziel_platz lvs_lte.ziel_lgr_platz%type;
        v_found          boolean;
        v_lgr            lvs_lgr%rowtype;
        v_transport      isi_transport%rowtype;
        v_lte_cfg        lvs_lte_cfg%rowtype;
        v_basis_lte_name lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

        cursor c_lte_ausl is
        select
            *
        from
            lvs_lte lte
        where
                lte.lgr_platz = v_lgr.lgr_platz_gruppe_gegenueber
            and lte.lte_status = c.lte_ad_stat;

        cursor c_lte_ausl_gruppe is
        select
            lte.*
        from
            lvs_lte lte,
            lvs_lgr lgr
        where
                lgr.gruppe = v_lgr.gruppe
            and lgr.lgr_dispo_ausl_te > 0
            and lte.lgr_platz = lgr.lgr_platz
            and lte.lte_status = c.lte_ad_stat;

        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.sid = v_lte.sid
            and t.transp_id = in_synch_trans_id;

        cursor c_lgr is
        select
            *
        from
            lvs_lgr l
        where
            l.lgr_platz = v_lte_ziel_platz;

        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.firma_nr = v_lte.firma_nr
            and t.lte_name = v_lte.lte_name;

    begin
        out_lgr_platz := null;
        out_lte_id := null;
        out_prio := null;
        v_transport := null;
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        open c_transport;
        fetch c_transport into v_transport;
        close c_transport;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
            raise v_error;
        else
            open c_lte_cfg;
            fetch c_lte_cfg into v_lte_cfg;
            close c_lte_cfg;
            v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
            v_lte_ziel_platz := v_lte.ziel_lgr_platz;
            lvs_c_suche_opti_einl_platz(v_lte,             -- in_lte          in lvs_lte%ROWTYPE,
             v_basis_lte_name,  -- in_basis_lte_name in lvs_lte_cfg.basis_lte_name
             v_lte_cfg.flaechen_stellplatz_erf, in_transport_id,   -- in_transport_id in isi_transport.transp_id%type,
             v_transport,       -- in_sych_trans_id in isi_transport.transp_id%type,
                                        in_fahrzeuge_ids,  -- ID's der möglichen Fahrzeuge
                                         null,              -- in_lgr_orte      in varchar2,
                                         v_lgr);            -- out_lgr_platz   out lvs_lgr%ROWTYPE
            out_lgr_platz := v_lgr.lgr_platz;
            if out_lgr_platz is not null then
                out_prio := 0;
                out_lgr_platz := v_lgr.lgr_platz;
            else
                v_lgr := null;
                open c_lgr;
                fetch c_lgr into v_lgr;
                close c_lgr;
            end if;

            if v_lgr.lgr_typ = c.sat_epl1
            or v_lgr.lgr_typ = c.sat_epl2 then
                open c_lte_ausl;
                fetch c_lte_ausl into v_lte;
                v_found := c_lte_ausl%found;
                close c_lte_ausl;
                if v_found then
                    out_lte_id := v_lte.lte_id;
                    out_prio := 1;
                else
                    open c_lte_ausl_gruppe;
                    fetch c_lte_ausl_gruppe into v_lte;
                    v_found := c_lte_ausl_gruppe%found;
                    close c_lte_ausl_gruppe;
                    if v_found then
                        out_lte_id := v_lte.lte_id;
                        out_prio := 1;
                    end if;
                end if;

                if
                    v_found
                    and out_lgr_platz is null
                then
                    out_lgr_platz := v_lte_ziel_platz;
                end if;
                if out_lte_id = v_transport.lte_id then
                    update isi_transport tr
                    set
                        tr.prio = (
                            select
                                t.prio + 1
                            from
                                isi_transport t
                            where
                                    t.sid = v_lte.sid
                                and t.transp_id = in_synch_trans_id
                        )
                    where
                            tr.transp_id = in_transport_id
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
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
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
    procedure lvs_c_transp_suche_einl_2s_opt (
        in_transport_id         in isi_transport.transp_id%type,
        in_lte_id               in lvs_lte.lte_id%type,
        in_lgr_orte             in varchar2,
        in_fahrzeuge_ids        in varchar2,
        in_modul_erzeuger       in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter     in isi_transport.modul_bearbeiter%type,
        in_user_id              in isi_user.login_id%type,
        in_prio                 in isi_transport.prio%type,
        in_progr_nr             in isi_transport.progr_nr%type,
        in_quelle_leer_progr_nr in isi_transport.quelle_leer_progr_nr%type,
        in_ziel_voll_progr_nr   in isi_transport.ziel_voll_progr_nr%type,
        in_lgr_platz_quelle     in lvs_lgr.lgr_platz%type,
        in_aktuelle_position    in lvs_lam.lam_text%type,
        out_lgr_platz           out lvs_lgr.lgr_platz%type,
        out_transport_id        out number,
        out_res_id              out isi_resource.res_id%type
    ) is
    -------------------------------------------------------------------------
        v_error exception;
        v_err_nr         number;
        v_err_text       varchar2(4096);
    -------------------------------------------------------------------------
        v_lte            lvs_lte%rowtype;
    --v_lte_ziel_platz          lvs_lte.ziel_lgr_platz%type;
        v_found          boolean;
        v_lgr            lvs_lgr%rowtype;
        v_transport      isi_transport%rowtype;
        v_transport_sync isi_transport%rowtype;
        v_lte_cfg        lvs_lte_cfg%rowtype;
        v_basis_lte_name lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

    --CURSOR c_lgr is
    --  select *
    --    from lvs_lgr l
    --   where l.lgr_platz = v_lte_ziel_platz;
        cursor c_transport is
        select
            *
        from
            isi_transport t
        where
                t.sid = v_lte.sid
            and t.transp_id = in_transport_id;

        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.firma_nr = v_lte.firma_nr
            and t.lte_name = v_lte.lte_name;

    begin
        out_lgr_platz := null;
        v_transport_sync := null;
        open c_lte;
        fetch c_lte into v_lte;
        v_found := c_lte%found;
        close c_lte;
        if not v_found then
            v_err_nr := 10;
            v_err_text := lc.ec_p1(lc.o_tp1_lte_id_fehlt, in_lte_id);
            raise v_error;
        else
      --v_lte_ziel_platz := v_lte.ziel_lgr_platz;
            if in_transport_id is not null then
                open c_lte_cfg;
                fetch c_lte_cfg into v_lte_cfg;
                close c_lte_cfg;
                v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
                lvs_c_suche_opti_einl_platz(v_lte,             -- in_lte          in lvs_lte%ROWTYPE,
                 v_basis_lte_name,  -- in_basis_lte_name in lvs_lte_cfg.basis_lte_name
                 v_lte_cfg.flaechen_stellplatz_erf, in_transport_id,   -- in_transport_id in isi_transport.transp_id%type,
                 v_transport_sync,  -- in_sych_trans_id in isi_transport.transp_id%type,
                                            in_fahrzeuge_ids,  -- ID's der möglichen Fahrzeuge
                                             in_lgr_orte,       -- in_lgr_orte      in varchar2,
                                             v_lgr);            -- out_lgr_platz   out lvs_lgr%ROWTYPE
                out_lgr_platz := v_lgr.lgr_platz;
                out_transport_id := in_transport_id;
                if out_lgr_platz is null then
                    lvs_platz.v_fahrz_res_id := null;
                end if;
                open c_transport;
                fetch c_transport into v_transport;
                v_found := c_transport%found;
                close c_transport;
                if not v_found then
                    v_err_nr := 20;
                    v_err_text := lc.ec_p1(lc.o_tp1_transp_id_nf, in_lte_id);
                    raise v_error;
                end if;

                out_res_id := nvl(lvs_platz.v_fahrz_res_id, v_transport.res_id);
            else
                lvs_platz.lvs_c_transp_suche_einl_p_rid(in_lte_id,                       -- in_lte_id               in LVS_LTE.LTE_ID%TYPE,
                 in_lgr_orte,                     -- in_lgr_orte             in varchar2,
                 in_fahrzeuge_ids,                -- in_fahrzeuge_IDs        in varchar2,
                 in_modul_erzeuger,               -- in_modul_erzeuger       in isi_transport.Modul_Erzeuger%TYPE,
                 in_modul_bearbeiter,             -- in_modul_bearbeiter     in isi_transport.Modul_Bearbeiter%TYPE,
                                                        in_user_id,                      -- in_user_ID              in isi_user.login_id%TYPE,
                                                         in_prio,                         -- in_prio                 in isi_transport.Prio%TYPE,
                                                         in_progr_nr,                     -- in_progr_nr             in isi_transport.progr_nr%TYPE,
                                                         in_quelle_leer_progr_nr,         -- in_quelle_Leer_progr_nr in isi_transport.quelle_leer_progr_nr%TYPE,
                                                         in_ziel_voll_progr_nr,           -- in_ziel_voll_Progr_nr   in isi_transport.ziel_voll_progr_nr%TYPE,
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
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end lvs_c_transp_suche_einl_2s_opt;

  -------------------------------------------------------------------------
    procedure lvs_c_suche_opti_einl_platz (
        in_lte                     in lvs_lte%rowtype,
        in_basis_lte_name          in lvs_lte_cfg.basis_lte_name%type,
        in_flaechen_stellplatz_erf in lvs_lte_cfg.flaechen_stellplatz_erf%type,
        in_transport_id            in isi_transport.transp_id%type,
        in_synch_trans             in isi_transport%rowtype,
        in_fahrzeuge_ids           in varchar2,
        in_lgr_orte                in varchar2,
        out_lgr_platz              out lvs_lgr%rowtype
    ) is
    -------------------------------------------------------------------------
    -- bei einem auto platz ist kein platz der gruppe belegt oder für einlagerung
    -- reserviert !!!
        v_error exception;
        v_err_nr                     number;
        v_err_text                   varchar2(4096);
        v_lgr_text                   varchar2(255);
        v_found                      boolean;
        v_found_lgr                  boolean;
        v_weiter_lgr                 boolean;
        v_lgr_ort                    lvs_lgr.lgr_ort%type;
        v_lgr_orte                   varchar2(255);
        v_lgr_ort_count              number;
        v_ort                        lvs_lgr_ort%rowtype;
        v_transport                  isi_transport%rowtype;
        v_lgr                        lvs_lgr%rowtype;
        v_lte_lgr                    lvs_lgr%rowtype;
        v_lgr_platz                  lvs_lgr.lgr_platz%type;
        v_ausl_dispo_faktor          number;
        v_ausl_dispo_bestand         number;
        v_faktor_akt                 number;
        v_abstand_faktor             number;
        v_abstand_faktor_akt         number;
        v_fuellgrad_seg              number;
        v_dat_lgr_regal_ebene_faktor number;
        v_dat                        date;
        v_lgr_platz_akt              lvs_lgr.lgr_platz%type;
        v_lgr_dim_platz_ref          lvs_lgr.lgr_dim_platz%type;
        v_lgr_dim_ort_ref            lvs_lgr.lgr_ort%type;
        v_ausl_dispo_faktor_akt      number;
        v_ref_lgr_gruppe_id          lvs_lgr.lgr_gruppe_id%type;
        v_ref_lgr_dim_g              lvs_lgr.lgr_dim_g%type;
        v_ref_lgr_dim_r              lvs_lgr.lgr_dim_r%type;
        v_ref_lgr_dim_p              lvs_lgr.lgr_dim_p%type;
        v_ref_lgr_dim_e              lvs_lgr.lgr_dim_e%type;
        v_ref_lgr_dim_t              lvs_lgr.lgr_dim_t%type;
        v_ref_lgr_max_kg             lvs_lgr.lgr_max_kg%type;
        v_ref_lgr_akt_kg             lvs_lgr.lgr_akt_kg%type;
        v_ref_lgr_frei_hoehe         lvs_lgr.lgr_frei_hoehe%type;
        v_ref_lgr_frei_breite        lvs_lgr.lgr_frei_breite%type;
        v_ref_lgr_frei_tiefe         lvs_lgr.lgr_frei_tiefe%type;
        v_ausl_dispo_lte_grp         number;
        v_ausl_res_lte_grp           number;
        v_lgr_platz_grp              lvs_lgr.lgr_platz_gruppe%type;
        v_lgr_dim_fifo               lvs_lgr.lgr_dim_fifo_nr%type;
        v_lgr_raster_x               number;
        v_lgr_raster_y               number;
        cursor c_lvs_lgr_grp_fahrzeug is
        select
            decode(
                min(f.res_id),
                max(f.res_id),
                min(f.res_id),
                null
            ) res_id
        from
            lvs_lgr_grp_fahrzeug f
        where
                f.lgr_gruppe_id = v_lgr.lgr_gruppe_id
            and f.lgr_ort = v_lgr.lgr_ort;

    -- Letzter Lagerplatz fuer diesen Artikel in diesem Lagerort
        cursor c_ref_lgr_platz is
        select
            lgr.lgr_dim_platz,
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
        from
            lvs_lte lte,
            lvs_lgr lgr
        where
                lte.sid = in_lte.sid
            and lte.firma_nr = in_lte.firma_nr
            and lte.ziel_lgr_platz = in_lte.ziel_lgr_platz
            and lte.ziel_lgr_platz = lgr.lgr_platz;

        cursor c_ref_lgr_platz_bh is
        select
            lgr.lgr_dim_platz,
            lgr.lgr_ort,
            lgr.lgr_gruppe_id,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e,
            lgr.lgr_dim_t
        from
            lvs_lam_bh bh,
            lvs_lgr    lgr
        where
                bh.sid = in_lte.sid
            and bh.firma_nr = in_lte.firma_nr
            and to_char(bh.artikel_id) = in_lte.res_artikel_id
            and lgr.lgr_platz = bh.lgr_platz
            and ( lgr.lgr_verwendung = c.lgr_typ_lager
                  or lgr.lgr_verwendung = c.lgr_typ_lagerp )
            and lgr.lgr_ort = v_ort.lgr_ort
        order by
            bh.buch_datum desc;

        cursor c_lgr_in_grp is -- Lesen des Lagerplatz
        select /*+ first_rows(1) */
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz_gruppe = v_lgr_platz_grp
            and lgr.lgr_dim_fifo_nr = v_lgr_dim_fifo
            and lgr.lgr_dim_g = v_lgr.lgr_dim_g
            and lgr.lgr_dim_r = v_lgr.lgr_dim_r
            and lgr.lgr_dim_e = v_lgr.lgr_dim_e
            and lgr.lgr_dim_p = v_lgr.lgr_dim_p
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.sid = in_lte.sid;

    -- fuer Kanaele und Sat-Lager
        cursor c_lgr_kanal is
        select /*+ first_rows(25) */
            min(lgr.lgr_dim_fifo_nr),
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         max(lgr.lgr_frei_tiefe))           as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor() as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()       as abstand_faktor,
            lgr.lgr_platz_gruppe,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        group by
            lgr.lgr_platz_gruppe,
            lgr.res_string,
            lgr.res_artikel_id,
            lgr.abc,
            lgr.lgr_res_strat,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e
        order by
            ausl_dispo_faktor asc,
            regal_ebene_faktor asc,
            abstand_faktor asc;

    -- fuer Kanal - Block - Lager
        cursor c_lgr_kanal_block is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)          as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer Staplel-Flaechen Lager
        cursor c_lgr_stap_flae1 is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)          as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_frei_hoehe <= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite <= in_lte.lte_vol_breite + v_lgr_raster_x
            and lgr.lgr_frei_tiefe <= in_lte.lte_vol_tiefe + v_lgr_raster_y
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer Staplel-Flaechen Lager Fix Min Max
        cursor c_lgr_stap_flae2 is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)          as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_vol_breite >= in_lte.lte_vol_breite
            and lgr.lgr_vol_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_frei_hoehe <= in_lte.lte_vol_hoehe
            and lgr.lgr_min_lte_hoehe <= in_lte.lte_vol_hoehe
            and lgr.lgr_min_lte_breite <= in_lte.lte_vol_breite
            and lgr.lgr_min_lte_tiefe <= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr asc;

    -- fuer Kanal - Durchlauflager
        cursor c_lgr_durchl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)          as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_l_buchung()    as einl_dispo_l_dat,
            lvs_lager_opt.lvs_lgr_abstand_faktor() as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            einl_dispo_l_dat desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr desc;

    -- fuer Einzelplatz - Lager
        cursor c_lgr_epl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)                as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor() as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()       as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            regal_ebene_faktor asc,
            abstand_faktor asc,
            lgr.lgr_dim_t;
    -- fuer Sateliten Einzelplatz - Lager
        cursor c_lgr_sat_epl is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)                 as ausl_dispo_faktor,
            lvs_lager_opt.lvs_platz_regal_ebene_faktor()  as regal_ebene_faktor,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor,
            lgr.lgr_einl_te_verfueg_gruppe                as fuellgrad_seg,
            lvs_lager_opt.lvs_platz_faktor_belegung_akt() as faktor_belegung_akt
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            abstand_faktor asc,
            regal_ebene_faktor asc,
            lgr.lgr_dim_t,
            fuellgrad_seg asc;

    -- fuer sonstige z.B. Blocklager
        cursor c_lgr_block is
        select /*+ first_rows(25) */
            lgr.lgr_platz,
             -- Ermitteln eines idealen Lagerplatz
            lvs_platz.lvs_platz_bewerten(v_ort.sid,
                                         v_ort.firma_nr,
                                         v_ort.lgr_typ,
                                         decode(lgr.lgr_res_strat,
                                                'O',
                                                nvl(
                                   to_char(in_lte.transport_gruppe),
                                   in_lte.res_string
                               ),
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
                                         c.c_true,
                                         in_synch_trans.lgr_platz_quelle,
                                         in_fahrzeuge_ids,
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
                                         lgr.lgr_frei_tiefe)                 as ausl_dispo_faktor,
             -- Ermitteln eines idealen Lagerplatz
            lvs_lager_opt.lvs_platz_bestand_ausl_faktor() as ausl_dispo_bestand,
            lvs_lager_opt.lvs_lgr_abstand_faktor()        as abstand_faktor
        from
            lvs_lgr lgr
        where
                lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.lgr_ort = v_lgr_ort
            and lgr.lgr_einl_te_verfueg > 0
            and lgr.gesperrt = c.lgr_gesperrt_f
            and nvl(lgr.lgr_max_kg, in_lte.lte_akt_kg) - nvl(lgr.lgr_akt_kg, 0) - nvl(lgr.lgr_dispo_einl_kg, 0) >= in_lte.lte_akt_kg
            and lgr.lgr_frei_hoehe >= in_lte.lte_vol_hoehe
            and lgr.lgr_frei_breite >= in_lte.lte_vol_breite
            and lgr.lgr_frei_tiefe >= in_lte.lte_vol_tiefe
            and lgr.lgr_verwendung = c.lgr_typ_lager
            and instr(
                nvl(lgr.lte_namen, in_basis_lte_name),
                in_basis_lte_name
            ) > 0
        order by
            ausl_dispo_faktor asc,
            ausl_dispo_bestand desc,
            abstand_faktor asc,
            lgr.lgr_dim_fifo_nr asc;

        cursor c_ort is -- Lesen des Lagerort
        select
            *
        from
            lvs_lgr_ort ort
        where
                ort.sid = in_lte.sid
            and ort.firma_nr = in_lte.firma_nr
            and ort.lgr_ort = v_lgr_ort;

        cursor c_lgr is -- Lesen des Lagerplatz
        select
            *
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = v_lgr_platz_akt
            and lgr.firma_nr = in_lte.firma_nr
            and lgr.sid = in_lte.sid;

        cursor c_lgr_grp is -- Lesen des Lagerplatz
        select /*+ first_rows(1) */
            sum(lgr.lgr_dispo_ausl_te),
            sum(decode(lte.order_vorgang_id, null, 0, 1))
        from
            lvs_lgr lgr,
            lvs_lte lte
        where
                lgr.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
            and lgr.lgr_dim_g = v_lgr.lgr_dim_g
            and lgr.lgr_dim_r = v_lgr.lgr_dim_r
            and lgr.lgr_dim_e = v_lgr.lgr_dim_e
            and lgr.lgr_dim_p = v_lgr.lgr_dim_p
            and lgr.lgr_platz = lte.lgr_platz
        group by
            lgr.lgr_platz_gruppe,
            lgr.res_string,
            lgr.res_artikel_id,
            lgr.abc,
            lgr.lgr_dim_g,
            lgr.lgr_dim_r,
            lgr.lgr_dim_p,
            lgr.lgr_dim_e;

        cursor c_transport is -- Lesen des Trasports
        select
            *
        from
            isi_transport t
        where
                t.transp_id = in_transport_id
            and t.firma_nr = in_lte.firma_nr
            and t.sid = in_lte.sid;

    begin
        v_err_nr := null;
        v_err_text := null;
        out_lgr_platz := null;
        v_found_lgr := false;
        v_weiter_lgr := false;
        v_lgr_dim_platz_ref := null;
        v_lgr_dim_ort_ref := null;
        out_lgr_platz := null;
        v_lte_lgr := null;
        v_lgr := null;
        v_lgr_dim_ort_ref := null;
        v_lgr_dim_platz_ref := null;
        v_faktor_akt := 1;
        v_lgr_raster_x := 0;
        v_lgr_raster_y := 0;
        lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab_empty;
    --lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab := lvs_p_lgr_grp_fahrzeuge.v_fahrzeuge_tab_empty;

        v_lgr_platz_akt := in_lte.ziel_lgr_platz;
        open c_lgr;
        fetch c_lgr into v_lte_lgr;
        v_found := c_lgr%found;
        close c_lgr;
        v_transport := null;
        open c_transport;
        fetch c_transport into v_transport;
        close c_transport;
        if in_lgr_orte is not null then
            v_lgr_orte := lvs_lort_format(in_lgr_orte);
            v_lgr_ort_count := lvs_lort_count(v_lgr_orte);
        else
            v_lgr_orte := lvs_lort_format(to_char(v_lte_lgr.lgr_ort) || ';');
            v_lgr_ort_count := lvs_lort_count(v_lgr_orte);
        end if;

        open c_ref_lgr_platz;
        fetch c_ref_lgr_platz into
            v_lgr_dim_platz_ref,
            v_lgr_dim_ort_ref,
            v_ref_lgr_gruppe_id,
            v_ref_lgr_dim_g,
            v_ref_lgr_dim_r,
            v_ref_lgr_dim_p,
            v_ref_lgr_dim_e,
            v_ref_lgr_dim_t,
            v_ref_lgr_max_kg,
            v_ref_lgr_akt_kg,
            v_ref_lgr_frei_hoehe,
            v_ref_lgr_frei_breite,
            v_ref_lgr_frei_tiefe;

        close c_ref_lgr_platz;

--    if v_lgr_dim_platz_ref is NULL
--    then
--      OPEN c_ref_lgr_platz_bh;
--      FETCH c_ref_lgr_platz_bh
--        into v_lgr_dim_platz_ref, v_lgr_dim_ort_ref, v_ref_lgr_gruppe_id;
--      CLOSE c_ref_lgr_platz_bh;
--    end if;
        v_abstand_faktor := 0;
        v_lgr_ort := v_transport.lgr_ort_ziel;
        open c_ort;
        fetch c_ort into v_ort;
        v_found := c_ort%found;
        close c_ort;
        lvs_platz.v_ort := v_ort;
        v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf, v_lte_lgr, 'E',
                                                               in_fahrzeuge_ids);

    -- Kein Fahrzeug bereit un diese Palette an den anfänglichen Lagewrplatz zu transportieren
        if v_lte_lgr.lgr_platz is null
           or v_lte_lgr.lgr_verwendung != c.lgr_typ_lager
        or v_lte_lgr.gesperrt != c.lgr_gesperrt_f
        or v_lte_lgr.lgr_verwendung = c.lgr_typ_ep
        or (
            in_fahrzeuge_ids is not null
            and in_fahrzeuge_ids not like '%;'
                                          || to_char(v_transport.res_id)
                                          || ';%'
        )    -- aktuelles Fahrzeug im Transport ist gesperrt
        or ( v_lgr_text is not null ) then -- dann wird der ursprüngliche Platz so sclecht wie ein falscher Platz gemacht damit sind alle mögliche besser
            v_ausl_dispo_faktor := 99000000000000000000000000; -- -AG- 27.01.2011 Nur einen großen Wert, damit der Platz kein guter ist (Jeder andere ist besser)
        else
            v_ausl_dispo_faktor := lvs_platz.lvs_platz_bewerten(v_lte_lgr.sid, v_lte_lgr.firma_nr, v_lte_lgr.lgr_typ, v_lte_lgr.res_string
            , in_lte.res_artikel_id,
                                                                in_lte.abc, in_lte.waren_typ, v_lte_lgr.lgr_platz_gruppe, v_lte_lgr.res_artikel_id
                                                                , v_lte_lgr.res_string,
                                                                v_lte_lgr.abc, v_lgr_dim_platz_ref, v_lgr_dim_ort_ref, in_lte.lte_akt_kg
                                                                , in_lte.lte_vol_hoehe,
                                                                in_lte.lte_vol_tiefe, in_lte.lte_vol_breite, v_lte_lgr.lgr_platz, c.c_true
                                                                , in_synch_trans.lgr_platz_quelle,
                                                                in_fahrzeuge_ids, v_lte_lgr.lgr_gruppe_id, v_ref_lgr_gruppe_id, v_ref_lgr_dim_g
                                                                , v_ref_lgr_dim_r,
                                                                v_ref_lgr_dim_p, v_ref_lgr_dim_e, v_ref_lgr_dim_t, v_ort.lgr_dim_r_g_u_gegenueber
                                                                , v_lgr_dim_platz_ref,
                                                                v_ref_lgr_max_kg, v_ref_lgr_akt_kg, v_ref_lgr_frei_hoehe, v_ref_lgr_frei_breite
                                                                , v_ref_lgr_frei_tiefe);

            if v_ausl_dispo_faktor is null       -- Aktueller Platz ist nicht gesperrt und erreichbar konnte aber nicht bewertet werden

             then                                 -- Dann letzten gefundenen Platz nehmen
                out_lgr_platz := null;
                v_ausl_dispo_faktor := v_ort.strat_platz_res_string; -- Keinen besseren Platz gefunden
            end if;

        end if;

        if
            v_ausl_dispo_faktor <= v_ort.strat_platz_leer -- Keinen besseren Platz geben
            and v_ort.lgr_typ <> c.sat_epl1                  -- Hier kann durch den Platz gegenüber noch eine Verbessewrung kommen
            and v_ort.lgr_typ <> c.sat_epl2
        then
            return;
        end if;

        for v_lo_nr in 1..v_lgr_ort_count loop
            lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab := lvs_p_lgr_grp_fahrzeuge.v_fuellgrad_tab_empty;
            v_lgr_ort := lvs_lort_ix(v_lgr_orte, v_lo_nr);
            open c_ort;
            fetch c_ort into v_ort;
            v_found := c_ort%found;
            close c_ort;
            lvs_platz.v_ort := v_ort;
            v_lgr_raster_x := v_ort.lgr_ort_raster_x;
            v_lgr_raster_y := v_ort.lgr_ort_raster_y;
            if v_found then
                if v_ort.lgr_typ = c.sat1
                or v_ort.lgr_typ = c.kanal1
        -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
                or v_ort.lgr_typ = c.seg1
                or v_ort.lgr_typ = c.seg_duedo1
        -- Segmente
                 then
          -- Kanal oder SAT-Lager
                    open c_lgr_kanal;
                    loop
                        fetch c_lgr_kanal into
                            v_lgr_dim_fifo,
                            v_ausl_dispo_faktor_akt,
                            lvs_platz.v_dat_lgr_regal_ebene_faktor,
                            v_abstand_faktor_akt,
                            v_lgr_platz_grp,
                            v_lgr.lgr_dim_g,
                            v_lgr.lgr_dim_r,
                            v_lgr.lgr_dim_p,
                            v_lgr.lgr_dim_e;

                        v_found := c_lgr_kanal%found;
                        if v_found then
                            begin
                                open c_lgr_in_grp;
                                fetch c_lgr_in_grp into v_lgr;
                                v_found := c_lgr_in_grp%found;
                                close c_lgr_in_grp;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_platz_akt := v_lgr.lgr_platz;
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 10;
                            end;
                        end if;

                        exit when c_lgr_kanal%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_kanal;
                elsif v_ort.lgr_typ = c.kanal_bkl1
                or v_ort.lgr_typ = c.reg_fach1
          -- Kanal-Blocklager oder Regalfach
                 then
                    open c_lgr_kanal_block;
                    loop
                        fetch c_lgr_kanal_block into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_dat,
                            v_abstand_faktor_akt;
                        v_found := c_lgr_kanal_block%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 20;
                            end;
                        end if;

                        exit when c_lgr_kanal_block%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_kanal_block;
                elsif v_ort.lgr_typ = c.stap_flae1 then
          -- Flaeche für Stapel
                    open c_lgr_stap_flae1;
                    loop
                        fetch c_lgr_stap_flae1 into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_dat,
                            v_abstand_faktor_akt;
                        v_found := c_lgr_stap_flae1%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 20;
                            end;
                        end if;

                        exit when c_lgr_stap_flae1%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_stap_flae1;
                elsif v_ort.lgr_typ = c.stap_flae2 then
          -- Flaeche für Stapel
                    open c_lgr_stap_flae2;
                    loop
                        fetch c_lgr_stap_flae2 into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_dat,
                            v_abstand_faktor_akt;
                        v_found := c_lgr_stap_flae2%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 20;
                            end;
                        end if;

                        exit when c_lgr_stap_flae2%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_stap_flae2;
                elsif v_ort.lgr_typ = c.durchl1 then
          -- Kanal-Blocklager oder Regalfach
                    open c_lgr_durchl;
                    loop
                        fetch c_lgr_durchl into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_dat,
                            v_abstand_faktor_akt;
                        v_found := c_lgr_durchl%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 20;
                            end;
                        end if;

                        exit when c_lgr_durchl%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_durchl;
                elsif v_ort.lgr_typ = c.epl1
                or v_ort.lgr_typ = c.pp_epl1 then
          -- Einzelplatz
                    open c_lgr_epl;
                    loop
                        fetch c_lgr_epl into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_abstand_faktor_akt,
                            lvs_platz.v_dat_lgr_regal_ebene_faktor;
                        v_found := c_lgr_epl%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 30;
                            end;
                        end if;

                        exit when c_lgr_epl%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_epl;
                elsif v_ort.lgr_typ = c.sat_epl1
                or v_ort.lgr_typ = c.sat_epl2
          -- Satelit Einzelplatz
           -- Fix Segment doppeltief muss arbeiten wie ein SAT oder Kanallager in der Suche
           -- or v_ort.lgr_typ = C.SEG1
           -- or v_ort.lgr_typ = C.SEG_DUEDO1
          -- Segmente
                 then
                    open c_lgr_sat_epl;
                    loop
                        fetch c_lgr_sat_epl into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_dat_lgr_regal_ebene_faktor,
                            v_abstand_faktor_akt,
                            v_fuellgrad_seg,
                            v_faktor_akt;
                        v_found := c_lgr_sat_epl%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_ort.lgr_typ = c.seg1
                                or v_ort.lgr_typ = c.seg_duedo1 then
                                    open c_lgr_grp;
                                    fetch c_lgr_grp into
                                        v_ausl_dispo_lte_grp,
                                        v_ausl_res_lte_grp;
                                    close c_lgr_grp;
                                    if v_ausl_dispo_lte_grp > 0
                                    or v_ausl_res_lte_grp > 0 then
                                        v_found := false;
                                        v_err_text := lc.ec_p2(lc.o_tp1_lgr_f_lte_n_grund_ausl, in_lte.lte_id, v_lgr.lgr_platz);

                                    end if;

                                end if;

                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 30;
                            end;
                        end if;

                        exit when c_lgr_sat_epl%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_sat_epl;
                else
          -- z.B. Blocklager
                    open c_lgr_block;
                    loop
                        fetch c_lgr_block into
                            v_lgr_platz_akt,
                            v_ausl_dispo_faktor_akt,
                            v_ausl_dispo_bestand,
                            v_abstand_faktor_akt;
                        v_found := c_lgr_block%found;
                        if v_found then
                            begin
                                open c_lgr;
                                fetch c_lgr into v_lgr;
                                v_found := c_lgr%found;
                                close c_lgr;
                                v_weiter_lgr := false;
                                if v_found then
                                    v_lgr_text := lvs_platz.lvs_platz_einl_pruef_err_t_r30(in_lte, in_basis_lte_name, in_flaechen_stellplatz_erf
                                    , v_lgr, 'E',
                                                                                           in_fahrzeuge_ids);
                  -- Ist den dieses ein besserer Platz
                                    if v_ausl_dispo_faktor is null
                                       or ( v_ausl_dispo_faktor > nvl(v_ausl_dispo_faktor_akt, 0) )
                                    or (
                                        v_ausl_dispo_faktor = v_ausl_dispo_faktor_akt
                                        and v_abstand_faktor > v_abstand_faktor_akt
                                    ) then
                                        v_weiter_lgr := true;
                                        if v_lgr_text is null then
                                            v_ausl_dispo_faktor := v_ausl_dispo_faktor_akt;
                                            v_lgr_platz := v_lgr_platz_akt;
                                            v_abstand_faktor := v_abstand_faktor_akt;
                                            v_weiter_lgr := false;
                                            v_found_lgr := true;
                                        end if;

                                    else  -- Gefunden jedoch schlechter
                                        v_found_lgr := true;
                                    end if;

                                end if;

                            exception
                                when others then
                                    v_err_nr := 40;
                            end;
                        end if;

                        exit when c_lgr_block%notfound
                        or (
                            v_found_lgr
                            and not v_weiter_lgr
                        );
                    end loop;

                    close c_lgr_block;
                end if;
            end if;

        end loop;

        if
            v_found_lgr
            and v_lgr_platz is not null
        then
            v_lgr_platz_akt := v_lgr_platz;
            open c_lgr;
            fetch c_lgr into v_lgr;
            close c_lgr;
            out_lgr_platz := v_lgr;
            if v_lte_lgr.lgr_platz is not null then
                lvs_platz.lvs_platz_einl_disp_ruecks(in_lte,        -- in_lte in lvs_lte%ROWTYPE,
                 v_lte_lgr);    -- in_lgr in lvs_lgr%ROWTYPE
            end if;

            lvs_platz.v_fahrz_res_id := null;
            open c_lvs_lgr_grp_fahrzeug;
            fetch c_lvs_lgr_grp_fahrzeug into lvs_platz.v_fahrz_res_id;
            close c_lvs_lgr_grp_fahrzeug;
            update lvs_lte lte
            set
                lte.ziel_lgr_platz = v_lgr_platz
            where
                    lte.lte_id = in_lte.lte_id
                and lte.sid = in_lte.sid
                and lte.firma_nr = in_lte.firma_nr;

            update isi_transport tr
            set
                tr.lgr_platz_ziel = v_lgr_platz,
                tr.res_id = lvs_platz.v_fahrz_res_id
            where
                    tr.transp_id = in_transport_id
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
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end lvs_c_suche_opti_einl_platz;

    function lte_platz_einl_pruef_err_text (
        in_lte_id        in lvs_lte.lte_id%type,
        in_lgr_platz     in lvs_lgr.lgr_platz%type,
        in_fahrzeuge_ids in varchar2
    ) return varchar2 is

        v_lte            lvs_lte%rowtype;
        v_lgr            lvs_lgr%rowtype;
        v_lte_cfg        lvs_lte_cfg%rowtype;
        v_basis_lte_name lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = v_lte.sid
            and t.firma_nr = v_lte.firma_nr
            and t.lte_name = v_lte.lte_name;

        cursor c_lte is
        select
            *
        from
            lvs_lte lte
        where
            lte.lte_id = in_lte_id;

        cursor c_lgr is
        select
            *
        from
            lvs_lgr lgr
        where
            lgr.lgr_platz = in_lgr_platz;

    begin
        open c_lte;
        fetch c_lte into v_lte;
        close c_lte;
        open c_lgr;
        fetch c_lgr into v_lgr;
        close c_lgr;
        open c_lte_cfg;
        fetch c_lte_cfg into v_lte_cfg;
        close c_lte_cfg;
        v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, v_lte.lte_name);
        return ( lvs_platz.lvs_platz_einl_pruef_err_t_r30(v_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, v_lgr, 'E',
                                                          in_fahrzeuge_ids) );

    end;

  -------------------------------------------------------------------------
    function lvs_platz_regal_ebene_faktor return number is
    begin
        return ( lvs_platz.v_dat_lgr_regal_ebene_faktor );
    end lvs_platz_regal_ebene_faktor;

  -------------------------------------------------------------------------
    function lvs_lgr_abstand_faktor return number is
    begin
        return ( lvs_platz.v_lgr_abstand_faktor );
    end lvs_lgr_abstand_faktor;
  -------------------------------------------------------------------------
    function lvs_platz_bestand_ausl_faktor return number is
    begin
        return ( lvs_platz.v_dat_lgr_bestand_ausl_faktor );
    end lvs_platz_bestand_ausl_faktor;

  -------------------------------------------------------------------------
    function lvs_platz_l_buchung return date is
    begin
        return ( lvs_platz.v_dat_lgr_l_buchung );
    end lvs_platz_l_buchung;

  -------------------------------------------------------------------------
    function lvs_platz_faktor_belegung_akt return number is
    begin
        return ( lvs_platz.v_faktor_belegung_akt );
    end lvs_platz_faktor_belegung_akt;

  --------------------------------------------------------------------------------
  -- procedure LVS_LTE_FREIFAHREN
  -- lvs_suche_um_platz aufrufen
  -- Dispo in Ziel buchen
  -- Transportauftrag generieren und gleichzeitig prüfen, ob für diese LTE schon
  -- ein Auftrag aktiviert ist, dann gegebenenfalls  denn vorherigen
  --------------------------------------------------------------------------------
    procedure lvs_lte_freifahren (
        in_lte              in lvs_lte%rowtype,
        in_modul_erzeuger   in isi_transport.modul_erzeuger%type,
        in_modul_bearbeiter in isi_transport.modul_bearbeiter%type,
        in_prio             in isi_transport.prio%type,
        in_fahrzeuge_ids    in varchar2
    ) is

        v_err_nr             pls_integer;
        v_err_text           varchar2(4096);
        v_error exception;
        v_transp_lte         number;
        v_quelle_lvs_lgr_rec lvs_lgr%rowtype;
        v_ziel_lvs_lgr_rec   lvs_lgr%rowtype;
        v_lgr_platz          lvs_lgr.lgr_platz%type;
        v_found              boolean;
        v_transport_gruppe   isi_transport.transport_gruppe%type;
        v_transport_id       isi_transport.transp_id%type;
        v_lte_cfg            lvs_lte_cfg%rowtype;
        v_basis_lte_name     lvs_lte_cfg.basis_lte_name%type;
        cursor c_lte_cfg is
        select
            t.*
        from
            lvs_lte_cfg t
        where
                t.sid = in_lte.sid
            and t.firma_nr = in_lte.firma_nr
            and t.lte_name = in_lte.lte_name;

        cursor c_lgr is
        select
            lgr.*
        from
            lvs_lgr lgr
        where
                lgr.lgr_platz = in_lte.lgr_platz
            and lgr.sid = in_lte.sid
            and lgr.firma_nr = in_lte.firma_nr;

    begin
        v_err_nr := null;
        v_err_text := null;

    -- get source lvs_lgr record
        v_lgr_platz := in_lte.ziel_lgr_platz;
        open c_lgr;
        fetch c_lgr into v_quelle_lvs_lgr_rec;
        v_found := c_lgr%found;
        close c_lgr;
        if not v_found then
            v_err_nr := c.fmid_lager_platz_fehlt;
            v_err_text := lc.ec_p1(lc.o_tp1_lagerplatz_fehlt,
                                   nvl(in_lte.lgr_platz, 'NULL'));

            raise v_error;
        end if;

    -- We search neu place for our "LTE"
        open c_lte_cfg;
        fetch c_lte_cfg into v_lte_cfg;
        close c_lte_cfg;
        v_basis_lte_name := nvl(v_lte_cfg.basis_lte_name, in_lte.lte_name);
        lvs_platz.lvs_suche_um_platz(in_lte, v_basis_lte_name, v_lte_cfg.flaechen_stellplatz_erf, v_quelle_lvs_lgr_rec, in_fahrzeuge_ids
        ,
                                     v_ziel_lvs_lgr_rec);

    -- We generate new auftrag
        v_transport_gruppe := 0;
        v_transp_lte := lvs_transport.lvs_transp_lte(in_lte.sid, -- in_sid                  IN isi_sid.sid%TYPE,
         in_lte.firma_nr, -- in_firma_nr             IN isi_firma.firma_nr%TYPE,
         in_modul_erzeuger, -- in_modul_erzeuger       IN isi_transport.modul_erzeuger%TYPE,
         in_modul_bearbeiter, -- in_modul_bearbeiter     IN isi_transport.modul_bearbeiter%TYPE,
         c.c_true, -- in_frei_fahren          IN varchar2,
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
                                                      c.c_false, -- in_lieferschein
                                                      null, -- Lieferschein Nummer
                                                      null, -- Lieferscheinposition -Nummer
                                                     null, -- Vorgang_id (Tour)
                                                      in_fahrzeuge_ids, null, v_transport_gruppe, v_transport_id);

    exception
    -- Im Fehlerfall is der Fehlertext bereits gesetzt.
        when v_error then  -- Update 2011 show Exception Source Line
            rollback;
            v_err_text := v_err_text
                          || chr(13)
                          || chr(10)
                          || dbms_utility.format_error_backtrace;

            raise_application_error(-20000 - v_err_nr, v_err_text, true);
            raise;
        when others then
            rollback;
            if v_err_nr is not null then
                v_err_text := v_err_text
                              || chr(13)
                              || chr(10)
                              || dbms_utility.format_error_backtrace;

                raise_application_error(-20000 - v_err_nr, v_err_text, true);
            else
                v_err_text := dbms_utility.format_error_backtrace;
                if v_err_text not like 'ORA-%ORA-%' then
                    v_err_text := lc.ec(lc.o_txt_db_error)
                                  || chr(13)
                                  || chr(10)
                                  || dbms_utility.format_error_backtrace;

                    raise_application_error(-20000, v_err_text, true);
                end if;

                raise;
            end if;

    end lvs_lte_freifahren;

begin
  -- Initialization
    null;
end lvs_lager_opt;
/


-- sqlcl_snapshot {"hash":"6258f1c62c3a6821c056f14f8ed1c5f10b0906d1","type":"PACKAGE_BODY","name":"LVS_LAGER_OPT","schemaName":"DIRKSPZM32","sxml":""}