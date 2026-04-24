create or replace procedure dirkspzm32.aps_c_look_for_relation (
    in_auftrag_nr      in aps_order_materialrelation.auftrag_nr%type,
    in_pos_nr          in aps_order_materialrelation.pos_nr%type,
    in_upos_nr         in aps_order_materialrelation.upos_nr%type,
    in_artikel_id      in isi_artikel.artikel_id%type,
    in_aps_plan_status in aps_order_materialrelation.aps_plan_status%type,
    in_aps_plan_st_ret in aps_order_materialrelation.aps_plan_status%type
) is

    v_found                       boolean;
  --v_invalide                                     boolean;
    v_aps                         aps_order_auftr_pos%rowtype;
  --v_lam_lte_id       lvs_lam.lte_id%type;
  --v_aps_auftrag_nr                               aps_order_materialrelation.auftrag_nr%type;
    v_hersteller_liste_akt        aps_order_auftr_pos.hersteller_kuerzel_liste%type;
    v_hersteller_liste_plan       aps_order_auftr_pos.hersteller_kuerzel_liste%type;
  
  --v_hersteller_liste_lam                         aps_order_auftr_pos.hersteller_kuerzel_liste%type;
    v_aps_plan_status             aps_order_auftr_pos.aps_plan_status%type;
  --v_lam                                          lvs_lam%rowtype;

    i_pos                         integer;
    v_op_pos_nr                   aps_order_auftr_pos.pos_nr%type;
    v_hersteller_pos_1_4          varchar2(1024);
    v_hersteller_pos_5            varchar2(1024);
    v_artikel_p6                  isi_artikel.artikel%type;
    b_reifen_artikel_p_4_5_gleich boolean;
    v_reifen_artikel_p_4_5_gleich varchar2(1);
    cursor c_reifen_artikel_p_4_5_gleich is
    select
        a5.artikel_p6
    from
        aps_order_auftr_pos ap5,
        isi_artikel         a5,
        aps_order_auftr_pos ap4,
        isi_artikel         a4
    where
            ap5.auftrag_nr = in_auftrag_nr
        and ap5.aps_plan_status = v_aps_plan_status
        and ap5.pos_nr = 5
        and ap5.artikel_id = a5.artikel_id
        and ap4.auftrag_nr = ap5.auftrag_nr
        and ap4.aps_plan_status = ap5.aps_plan_status
        and ap4.pos_nr = 4
        and ap4.artikel_id = a4.artikel_id
        and a4.artikel_p6 = a5.artikel_p6;

    cursor c_get_aps_order_pos is
    select
        ap.*
    from
        aps_order_auftr_pos ap
    where
            ap.auftrag_nr = in_auftrag_nr
        and ap.aps_plan_status = v_aps_plan_status;

    cursor c_get_aps_order_pos_x is
    select
        max(op.hersteller_kuerzel_liste) hersteller_kuerzel_liste
    from
        aps_order_materialrelation mr,
        aps_order_auftr_pos        op,
        aps_plan_ergebnis          pe
    where
            mr.auftrag_nr = in_auftrag_nr
        and mr.pos_nr <= 4
        and mr.aps_plan_status = in_aps_plan_st_ret
        and mr.materialrelation_type = 2
        and op.auftrag_nr = mr.auftrag_nr
        and op.pos_nr = mr.pos_nr
        and op.upos_nr = mr.upos_nr
        and op.aps_plan_status = mr.aps_plan_status
        and mr.aps_plan_status = pe.aps_plan_status
        and mr.child_id = pe.aps_plan_auftrag_nr
        and pe.leitzahl is not null;

    cursor c_check_bestand is
    select
        lam.hersteller_kuerzel_liste,
        apmr.*
    from
        aps_order_materialrelation apmr,
        lvs_lam                    lam,
        lvs_lgr                    lgr,
        lvs_lte                    lte
    where
            apmr.auftrag_nr = v_aps.auftrag_nr
        and apmr.pos_nr = v_aps.pos_nr
        and apmr.upos_nr = v_aps.upos_nr
        and apmr.aps_plan_status = in_aps_plan_st_ret
        and apmr.materialrelation_type = 8
        and not exists (
            select
                *
            from
                aps_order_materialrelation apmrx
            where
                    apmrx.child_id = apmr.child_id
                and apmrx.materialrelation_type = apmr.materialrelation_type
                and apmrx.aps_plan_status = in_aps_plan_status
        )
        and ( ( nvl(lam.hersteller_kuerzel_liste, 'Keiner') = nvl(
                nvl(v_hersteller_liste_akt, lam.hersteller_kuerzel_liste),
                'Keiner'
            )
                and apmr.pos_nr <= 4 )
              or ( nvl(lam.hersteller_kuerzel_liste, 'Keiner') = nvl(
                nvl(v_hersteller_pos_5, lam.hersteller_kuerzel_liste),
                'Keiner'
            )
                   and apmr.pos_nr = 5 ) )
        and apmr.child_id = lam.lte_id
        and lam.labor_status in ( 'F', 'Q' )
        and lgr.lgr_platz = lam.lgr_platz
        and lgr.gesperrt = 'F'
        and lte.lte_id = lam.lte_id
        and lgr.lgr_ort in ( 500, 600, 610, 620 )
        and lte.lte_status != 'KF'
        and lte.lte_status != 'PF'
        and lte.lte_status != 'AT';

    cursor c_get_alternativ_lte is
    select --+rule
        lam.hersteller_kuerzel_liste,
        apmr.*
    from
        aps_order_auftr_pos        ap,
        aps_order_materialrelation apmr,
        lvs_lam                    lam,
        lvs_lgr                    lgr,
        lvs_lte                    lte
    where
            ap.artikel_id = v_aps.artikel_id
        and ap.aps_plan_status = in_aps_plan_st_ret
        and ap.auftrag_nr = apmr.auftrag_nr
        and ap.pos_nr = apmr.pos_nr
        and ap.upos_nr = apmr.upos_nr
        and apmr.aps_plan_status = ap.aps_plan_status
        and apmr.materialrelation_type = 8
        and not exists (
            select
                'x'
            from
                aps_order_auftr_pos        apx,
                aps_order_materialrelation apmrx
            where
                    apmrx.child_id = apmr.child_id
                and apmrx.aps_plan_status = in_aps_plan_status
                and apx.auftrag_nr = apmrx.auftrag_nr
                and apx.pos_nr = apmrx.pos_nr
                and apx.upos_nr = apmrx.upos_nr
                and apx.aps_plan_status = apmrx.aps_plan_status
                and apmrx.materialrelation_type = 8
        )
        and ( ( nvl(lam.hersteller_kuerzel_liste, 'Keiner') = nvl(
                nvl(v_hersteller_liste_akt, lam.hersteller_kuerzel_liste),
                'Keiner'
            )
                and apmr.pos_nr <= 4 )
              or ( nvl(lam.hersteller_kuerzel_liste, 'Keiner') = nvl(
                nvl(v_hersteller_pos_5, lam.hersteller_kuerzel_liste),
                'Keiner'
            )
                   and apmr.pos_nr = 5 ) )
        and apmr.child_id = lam.lte_id
        and lam.lgr_platz is not null
        and lam.labor_status in ( 'F', 'Q' )
        and lgr.lgr_platz (+) = lam.lgr_platz
        and lgr.gesperrt (+) = 'F'
        and lte.lte_id = lam.lte_id
        and lgr.lgr_ort in ( 500, 600, 610, 620 )
        and lte.lte_status != 'KF'
        and lte.lte_status != 'PF'
        and lte.lte_status != 'AT'
    order by
        ap.prioritaet desc,
        ap.planreihenfolge desc,
        ap.auftrag_nr desc,
        ap.pos_nr desc,
        ap.upos_nr desc;

    v_aps_mr                      c_get_alternativ_lte%rowtype;
    cursor c_get_fa_bestand is
    select
        lam.lte_id,
        lam.artikel_id,
        lam.leitzahl,
        lam.hersteller_kuerzel_liste,
        mr.auftrag_nr,
        mr.pos_nr,
        mr.upos_nr
    from
        aps_order_materialrelation mr,
        aps_plan_ergebnis          pe,
        bde_fa_auftrag             fa,
        lvs_lam                    lam,
        aps_order_materialrelation mrx
    where
            mr.auftrag_nr = in_auftrag_nr
       --and mr.pos_nr = in_pos_nr       -- Den ganzen Auftrag durcharbeiten
       --and mr.upos_nr = in_upos_nr
        and mr.aps_plan_status = in_aps_plan_st_ret
        and mr.materialrelation_type = 2
        and mr.aps_plan_status = pe.aps_plan_status
        and mr.child_id = pe.aps_plan_auftrag_nr
        and pe.leitzahl = fa.leitzahl
        and fa.kenz_letzt_ag = 1
        and fa.freig_status != 'F'
        and lam.leitzahl = fa.leitzahl
        and lam.fa_ag is null
        and not exists (
            select
                'x'
            from
                aps_order_materialrelation apmrx
            where
                    apmrx.child_id = lam.lte_id
                and apmrx.aps_plan_status = in_aps_plan_status
                and apmrx.materialrelation_type = 8
        )
        and lam.labor_status in ( 'Q', 'F' )
        and mrx.aps_plan_status = in_aps_plan_status
        and mrx.materialrelation_type = 0
        and mrx.auftrag_nr = mr.auftrag_nr
        and mrx.pos_nr = mr.pos_nr
        and mrx.upos_nr = mr.upos_nr
    order by
        mr.pos_nr,
        mr.upos_nr,
        lam.labor_status;

    v_fa_bestand                  c_get_fa_bestand%rowtype;
    cursor c_get_fa_tf is
    select
        op.auftrag_nr,
        op.pos_nr,
        op.upos_nr,
        op.artikel_id,
        op.prioritaet,
        op.soll_menge,
        fa.leitzahl,
        fa.abnr
    from
        aps_order_auftr_pos        op,
        aps_order_materialrelation mr,
        aps_plan_ergebnis          pe,
        bde_fa_auftrag             fa,
        aps_order_materialrelation mrx
    where
            op.auftrag_nr = in_auftrag_nr
       --and op.pos_nr = in_pos_nr -- Den ganzen Auftrag durcharbeiten
       --and op.upos_nr = in_upos_nr
        and op.aps_plan_status = in_aps_plan_st_ret
        and mr.auftrag_nr = in_auftrag_nr
        and mr.pos_nr = in_pos_nr
        and mr.upos_nr = in_upos_nr
        and mr.aps_plan_status = in_aps_plan_st_ret
        and mr.materialrelation_type = 2
        and mr.aps_plan_status = pe.aps_plan_status
        and mr.child_id = pe.aps_plan_auftrag_nr
        and pe.leitzahl = fa.leitzahl
        and fa.kenz_letzt_ag = 1
        and fa.freig_status = 'TF'
        and mrx.aps_plan_status = in_aps_plan_status
        and mrx.materialrelation_type = 0
        and mrx.auftrag_nr = op.auftrag_nr
        and mrx.pos_nr = op.pos_nr
        and mrx.upos_nr = op.upos_nr
    order by
        op.auftrag_nr,
        op.pos_nr,
        op.upos_nr;

    v_bde_fa_plan                 c_get_fa_tf%rowtype;
    cursor c_herst_art is
    select
        stradd_distinct(ah.herstellerkuerzel)
        || ';'                      herstellerkuerzel_liste,
        count(ah.herstellerkuerzel) anz
    from
        isi_artikel_hersteller ah
    where
        ah.artikel_id = in_artikel_id;

    v_herst_art                   c_herst_art%rowtype;

/*
  CURSOR c_get_bestand is
    select lam.*
      from lvs_lam lam,
           lvs_lte lte,
           lvs_lgr lgr
     where lam.artikel_id = v_aps.artikel_id
       and lam.fa_ag is NULL
       and not exists (select * 
                         from aps_order_auftr_pos apx,
                              aps_order_materialrelation apmrx
                        where apmrx.child_id = lam.lte_id
                          and apx.auftrag_nr = apmrx.auftrag_nr
                         and apx.pos_nr = apmrx.pos_nr
                          and apx.upos_nr = apmrx.upos_nr
                          and apx.aps_plan_status = in_aps_plan_status
                          and apx.aps_plan_status = apmrx.aps_plan_status
                          and apmrx.materialrelation_type = 8)
       and lam.lte_id = lte.lte_id
       and lam.order_pos_auf_id is NULL
       and nvl(lam.hersteller_kuerzel_liste, 'Keiner') = nvl(v_hersteller_liste_akt, 'Keiner')
       and lam.lgr_platz = lgr.lgr_platz
       and lgr.lgr_typ != 'DURCHL1'                        -- Durchlauflager mit begrenzten Zugriff
       and lgr.gesperrt = 'F'
       and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
       and lgr.lgr_ort in (600, 610, 620)
       and lam.labor_status in ('F', 'Q')
       and lte.lte_status != 'AG'
       and lte.lte_status != 'KF'
       and lte.lte_status != 'PF'
       and lte.lte_status != 'AF'
       and lte.lte_status != 'BF'
       and lte.lte_status != 'UF'
    order by lam.lam_mhd;  
*/
begin
    if nvl(in_aps_plan_status, 'X') != 'PS' then
        return;
    end if;
    v_hersteller_pos_1_4 := null;
    v_hersteller_pos_5 := null;
    v_artikel_p6 := null;
    v_aps_plan_status := in_aps_plan_status;
    open c_reifen_artikel_p_4_5_gleich;
    fetch c_reifen_artikel_p_4_5_gleich into v_artikel_p6;
    close c_reifen_artikel_p_4_5_gleich;
    if v_artikel_p6 is not null then
        b_reifen_artikel_p_4_5_gleich := true;
        v_reifen_artikel_p_4_5_gleich := 'T';
    else
        v_aps_plan_status := in_aps_plan_st_ret;
        open c_reifen_artikel_p_4_5_gleich;
        fetch c_reifen_artikel_p_4_5_gleich into v_artikel_p6;
        close c_reifen_artikel_p_4_5_gleich;
        if v_artikel_p6 is not null then
            b_reifen_artikel_p_4_5_gleich := true;
            v_reifen_artikel_p_4_5_gleich := 'T';
        else
            b_reifen_artikel_p_4_5_gleich := false;
            v_reifen_artikel_p_4_5_gleich := 'F';
        end if;

    end if;

    i_pos := 0;
    loop
        open c_get_fa_bestand;
        fetch c_get_fa_bestand into v_fa_bestand;
        v_found := c_get_fa_bestand%found;
        close c_get_fa_bestand;
        if
            v_fa_bestand.pos_nr <= 4
            and v_hersteller_pos_1_4 is null
        then
            v_hersteller_pos_1_4 := substr(v_fa_bestand.hersteller_kuerzel_liste, 1, 2);
        end if;

        if
            v_fa_bestand.pos_nr = 5
            and v_hersteller_pos_5 is null
        then
            v_hersteller_pos_5 := substr(v_fa_bestand.hersteller_kuerzel_liste, 1, 2);
        end if;

        exit when not v_found
        or i_pos > 5;
        i_pos := i_pos + 1;
        update aps_order_materialrelation apmr
        set
            apmr.materialrelation_type = 8,
            apmr.child_id = v_fa_bestand.lte_id,
            apmr.child_artikel_id = v_fa_bestand.artikel_id,
            apmr.materialrelation_info = 'Valide Lagerbestand aus aktueller Produktion Fertigungsauftrag: '
                                         || v_fa_bestand.leitzahl
                                         || ' LTE_ID: '
                                         || v_fa_bestand.lte_id
                                         || ' übernommen',
            apmr.materialrelation_valide = 'T'
        where
                apmr.aps_plan_status = in_aps_plan_status
            and apmr.auftrag_nr = v_fa_bestand.auftrag_nr
            and apmr.pos_nr = v_fa_bestand.pos_nr
            and apmr.upos_nr = v_fa_bestand.upos_nr;

        update aps_order_auftr_pos ap
        set
            ap.hersteller_kuerzel_liste = substr(v_fa_bestand.hersteller_kuerzel_liste, 1, 2)
        where
                ap.aps_plan_status = in_aps_plan_status
            and ap.auftrag_nr = v_fa_bestand.auftrag_nr
            and ( ap.pos_nr = v_fa_bestand.pos_nr
                  or v_reifen_artikel_p_4_5_gleich = 'T' );
    --update Z_DIR_AUSL_ROBER ar
    --   set ar.hersteller = substr(v_fa_bestand.hersteller_kuerzel_liste, 1, 2)
    -- where ar.auftrag = v_aps.auftrag_nr
    --   and (ar.pos = v_fa_bestand.pos_nr or (ar.pos <= 4 and v_aps_mr.pos_nr <= 4) or (v_reifen_artikel_p_4_5_gleich = 'T'));
        commit;
    end loop;
  
  /* TF wird hier noch nicht verarbeitet - Erst im R4 wenn nicht durch Lagerbestand zu decken
  LOOP
    OPEN c_get_fa_tf;
    FETCH c_get_fa_tf into v_bde_fa_plan;
    v_found := c_get_fa_tf%FOUND;
    CLOSE c_get_fa_tf;

    EXIT when not v_found or i_pos > 5;
    i_pos := i_pos + 1;
    z_dir_c_gen_plan_auftrag(v_bde_fa_plan.artikel_id,
                             v_bde_fa_plan.prioritaet,
                             v_bde_fa_plan.soll_menge,
                             v_bde_fa_plan.auftrag_nr,
                             v_bde_fa_plan.pos_nr,
                             v_bde_fa_plan.upos_nr);
      
    update aps_plan_ergebnis pe
       set pe.leitzahl = v_bde_fa_plan.leitzahl,
           pe.abnr = v_bde_fa_plan.abnr
     where pe.aps_plan_status = in_aps_plan_status
       and pe.aps_plan_auftrag_nr = (select xmr.child_id
                                       from aps_order_materialrelation xmr
                                      where xmr.aps_plan_status = in_aps_plan_status
                                        and xmr.auftrag_nr = v_bde_fa_plan.auftrag_nr
                                        and xmr.pos_nr = v_bde_fa_plan.pos_nr
                                        and xmr.upos_nr = v_bde_fa_plan.upos_nr);
    
    commit;
  end LOOP;
  */
  
  -- Herstelle ggf. bereits durch die Fertigung festgelegt
    v_hersteller_liste_akt := nvl(v_hersteller_pos_1_4, v_hersteller_pos_5);
    if b_reifen_artikel_p_4_5_gleich then
        v_hersteller_pos_5 := v_hersteller_liste_akt;
        v_hersteller_pos_1_4 := v_hersteller_liste_akt;
    end if;
    i_pos := 0;
    if in_pos_nr = 5 -- Auftrag hat Reserverad
     then
        if v_hersteller_pos_5 is null -- Hersteller bereits gefunden in FA?
         then -- Nein dan suchen
            v_herst_art.anz := 0;
            v_herst_art.herstellerkuerzel_liste := null;
            open c_herst_art;
            fetch c_herst_art into v_herst_art;
            close c_herst_art;
            if v_herst_art.anz = 1 -- Eindeutiger hersteller für diesen Artikel
             then
                v_hersteller_liste_akt := v_herst_art.herstellerkuerzel_liste;
            else
                v_hersteller_liste_akt := aps_look_for_hersteller(in_auftrag_nr, in_pos_nr, in_aps_plan_status);
            end if;

            v_hersteller_pos_5 := v_hersteller_liste_akt; -- das ist der Hersteller der POS 5 und für alle wenn Reifen POS4 und 5 gleicher Artikel
        else
            v_hersteller_liste_akt := v_hersteller_pos_5; -- Aus FA gefundenen Hersteller setzen
        end if;

        v_hersteller_liste_akt := substr(v_hersteller_liste_akt, 1, 2);
        if v_hersteller_liste_akt is not null -- Wenn Hersteller gefunden dann im APS und Rober speichern (Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel)
         then
            update aps_order_auftr_pos ap
            set
                ap.hersteller_kuerzel_liste = substr(v_hersteller_liste_akt, 1, 2)
            where
                    ap.aps_plan_status = in_aps_plan_status
                and ap.auftrag_nr = in_auftrag_nr
                and ( ap.pos_nr = in_pos_nr
                      or v_reifen_artikel_p_4_5_gleich = 'T' );   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel
      --update Z_DIR_AUSL_ROBER ar
      --   set ar.hersteller = substr(v_hersteller_liste_akt, 1, 2)
      -- where ar.auftrag = in_auftrag_nr
      --   and (ar.pos = in_pos_nr or v_reifen_artikel_p_4_5_gleich = 'T');   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel
            commit;
        end if;

    end if;

    open c_get_aps_order_pos_x;
    fetch c_get_aps_order_pos_x into v_hersteller_liste_plan;
    v_found := c_get_aps_order_pos_x%found;
    if
        v_found -- Aus Auftrag kann eine relation übernommen werden
        and v_hersteller_liste_plan is not null
    then
        update aps_order_auftr_pos ap
        set
            ap.hersteller_kuerzel_liste = substr(v_hersteller_liste_plan, 1, 2)
        where
                ap.aps_plan_status = in_aps_plan_status
            and ap.auftrag_nr = in_auftrag_nr
            and ( ap.pos_nr <= 4
                  or v_reifen_artikel_p_4_5_gleich = 'T' );   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel
    --update Z_DIR_AUSL_ROBER ar
    --   set ar.hersteller = v_hersteller_liste_plan
    -- where ar.auftrag = in_auftrag_nr
    --   and (ar.pos <= 4 or v_reifen_artikel_p_4_5_gleich = 'T');   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel
        v_hersteller_pos_1_4 := v_hersteller_liste_plan;
        v_hersteller_liste_akt := v_hersteller_pos_1_4;
        if b_reifen_artikel_p_4_5_gleich -- Nur wenn Reifen POS4 und 5 ungleicher Artikel
         then
            v_hersteller_pos_5 := v_hersteller_liste_plan;
        end if;
        commit;
    end if;

    close c_get_aps_order_pos_x;
    if not b_reifen_artikel_p_4_5_gleich -- Nur wenn Reifen POS4 und 5 ungleicher Artikel
     then
        if v_hersteller_pos_1_4 is null    -- Aus den FAs noch nicht gesetzt
         then
            v_hersteller_liste_akt := aps_look_for_hersteller(in_auftrag_nr, 4, in_aps_plan_status);
            v_hersteller_pos_1_4 := v_hersteller_liste_akt;
        else
            v_hersteller_liste_akt := v_hersteller_pos_1_4;
        end if;

        v_hersteller_liste_akt := substr(v_hersteller_liste_akt, 1, 2);
        v_aps_plan_status := in_aps_plan_st_ret;
    else
        v_hersteller_pos_1_4 := v_hersteller_liste_akt;
        v_hersteller_pos_5 := v_hersteller_liste_akt; -- das ist der Hersteller der POS 5 und für alle wenn Reifen POS4 und 5 gleicher Artikel
    end if;

    if v_hersteller_liste_akt is not null then
        update aps_order_auftr_pos ap
        set
            ap.hersteller_kuerzel_liste = substr(v_hersteller_liste_akt, 1, 2)
        where
                ap.aps_plan_status = in_aps_plan_status
            and ap.auftrag_nr = in_auftrag_nr
            and ( ap.pos_nr <= 4
                  or v_reifen_artikel_p_4_5_gleich = 'T' );   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel
    --update Z_DIR_AUSL_ROBER ar
    --   set ar.hersteller = substr(v_hersteller_liste_akt, 1, 2)
    -- where ar.auftrag = in_auftrag_nr
    --   and (ar.pos <= 4 or v_reifen_artikel_p_4_5_gleich = 'T');   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel
        commit;
    else
        commit;
        return;
    /*
    update aps_order_materialrelation apmr
       set apmr.materialrelation_info = 'Keine Bestand',
           apmr.child_artikel_id = (select xop.artikel_id
                                      from aps_order_auftr_pos xop
                                     where xop.auftrag_nr = apmr.auftrag_nr
                                       and xop.pos_nr = apmr.pos_nr
                                       and xop.upos_nr = apmr.upos_nr
                                       and xop.aps_plan_status = apmr.aps_plan_status),
           apmr.child_id = -1,
           apmr.materialrelation_type = 1
     where apmr.auftrag_nr = in_auftrag_nr
       and apmr.aps_plan_status = in_aps_plan_status;
    update aps_order_auftr_pos op
       set op.hersteller_kuerzel_liste = NULL
     where op.auftrag_nr = in_auftrag_nr
       and op.pos_nr <= 4
       and op.aps_plan_status = in_aps_plan_status;
    update Z_DIR_AUSL_ROBER t
       set t.hersteller = null
     where t.auftrag = in_auftrag_nr
       and t.pos <= 4;
    commit;
    */
    end if;

    open c_get_aps_order_pos;  -- Lesen ganzen Auftrag
    fetch c_get_aps_order_pos into v_aps;
    v_found := c_get_aps_order_pos%found;
    if not v_found -- Auftrag neu, hier kann keine relation übernommen werden
     then
        close c_get_aps_order_pos;
    /*
    v_aps_plan_status := in_aps_plan_status;
    OPEN c_get_aps_order_pos;
    FETCH c_get_aps_order_pos into v_aps;
    v_found := c_get_aps_order_pos%found;
    LOOP
      EXIT when not v_found;
      OPEN c_get_bestand;
      fetch c_get_bestand into v_lam;
      update aps_order_materialrelation apmr
         set apmr.child_id = v_lam.lte_id,
             apmr.child_artikel_id = v_lam.artikel_id,
             apmr.materialrelation_info = 'Vormerken der LTE_ID ' || v_aps_mr.child_id ||  ' für den Auftrag',
             apmr.materialrelation_type = 8,
             apmr.materialrelation_valide = 'T'
       where apmr.aps_plan_status = in_aps_plan_status
         and apmr.auftrag_nr = v_aps_mr.auftrag_nr
         and apmr.pos_nr = v_aps_mr.pos_nr
         and apmr.upos_nr = v_aps_mr.upos_nr
         and apmr.aps_plan_status = in_aps_plan_status;
      CLOSE c_get_bestand;
      FETCH c_get_aps_order_pos into v_aps;
      v_found := c_get_aps_order_pos%found;
    end LOOP;
    CLOSE c_get_aps_order_pos;*/
        commit;
        return;
    end if;
    loop
        exit when not v_found;
        open c_check_bestand;
        fetch c_check_bestand into v_aps_mr;
        v_found := c_check_bestand%found;
        close c_check_bestand;
        if v_found then
            update aps_order_materialrelation apmr
            set
                apmr.materialrelation_type = v_aps_mr.materialrelation_type,
                apmr.child_id = v_aps_mr.child_id,
                apmr.child_artikel_id = nvl(v_aps_mr.child_artikel_id, v_aps.artikel_id),
                apmr.materialrelation_info = 'Valide aus der Vorplanung mit Lagerbestand aus '
                                             || v_aps_mr.child_id
                                             || ' übernommen P4_5 Gleich '
                                             || v_reifen_artikel_p_4_5_gleich
                                             || ' - '
                                             || v_artikel_p6
                                             || ' Hersteller=<'
                                             || v_hersteller_liste_akt
                                             || '> Hersteller LAM='
                                             || v_aps_mr.hersteller_kuerzel_liste,
                apmr.materialrelation_valide = 'T'
            where
                    apmr.aps_plan_status = in_aps_plan_status
                and apmr.auftrag_nr = v_aps_mr.auftrag_nr
                and apmr.pos_nr = v_aps_mr.pos_nr
                and apmr.upos_nr = v_aps_mr.upos_nr
                and apmr.aps_plan_status = in_aps_plan_status;

            update aps_order_auftr_pos ap
            set
                ap.hersteller_kuerzel_liste = v_aps_mr.hersteller_kuerzel_liste
            where
                    ap.aps_plan_status = in_aps_plan_status
                and ap.auftrag_nr = v_aps_mr.auftrag_nr
                and ( ap.pos_nr = v_aps_mr.pos_nr
                      or ( ap.pos_nr <= 4
                           and v_aps_mr.pos_nr <= 4 )
                      or ( v_reifen_artikel_p_4_5_gleich = 'T' ) );
      --update Z_DIR_AUSL_ROBER ar
      --   set ar.hersteller = v_aps_mr.hersteller_kuerzel_liste
      -- where ar.auftrag = v_aps.auftrag_nr
      --   and (ar.pos = v_aps.pos_nr or (ar.pos <= 4 and v_aps_mr.pos_nr <= 4) or (v_reifen_artikel_p_4_5_gleich = 'T'));
            commit;
        else
            open c_get_alternativ_lte;
            fetch c_get_alternativ_lte into v_aps_mr;
            v_found := c_get_alternativ_lte%found;
            close c_get_alternativ_lte;
            if
                v_found
                and v_aps_mr.hersteller_kuerzel_liste = v_hersteller_liste_akt
            then
                update aps_order_materialrelation apmr
                set
                    apmr.materialrelation_type = v_aps_mr.materialrelation_type,
                    apmr.child_id = v_aps_mr.child_id,
                    apmr.child_artikel_id = nvl(v_aps_mr.child_artikel_id, v_aps.artikel_id),
                    apmr.materialrelation_info = 'Valide alternative aus der Vorplanung mit Lagerbestand aus '
                                                 || v_aps_mr.child_id
                                                 || ' übernommen. P4_5 Gleich '
                                                 || v_reifen_artikel_p_4_5_gleich
                                                 || ' - '
                                                 || v_artikel_p6
                                                 || ' Hersteller=<'
                                                 || v_hersteller_liste_akt
                                                 || '> Hersteller LAM='
                                                 || v_aps_mr.hersteller_kuerzel_liste,
                    apmr.materialrelation_valide = 'T'
                where
                        apmr.auftrag_nr = v_aps.auftrag_nr
                    and apmr.pos_nr = v_aps.pos_nr
                    and apmr.upos_nr = v_aps.upos_nr
                    and apmr.aps_plan_status = in_aps_plan_status;

                update aps_order_auftr_pos ap
                set
                    ap.hersteller_kuerzel_liste = v_aps_mr.hersteller_kuerzel_liste
                where
                        ap.aps_plan_status = in_aps_plan_status
                    and ap.auftrag_nr = v_aps.auftrag_nr
                    and ( ap.pos_nr = v_aps.pos_nr
                          or ( ap.pos_nr <= 4
                               and v_aps.pos_nr <= 4 )
                          or ( v_reifen_artikel_p_4_5_gleich = 'T' ) );   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel);
        --update Z_DIR_AUSL_ROBER ar
        --   set ar.hersteller = v_aps_mr.hersteller_kuerzel_liste
        -- where ar.auftrag = v_aps.auftrag_nr
        --   and (ar.pos = v_aps.pos_nr or (ar.pos <= 4 and v_aps.pos_nr <= 4) or (v_reifen_artikel_p_4_5_gleich = 'T'));   -- Pos 5 oder alle wenn Reifen POS4 und 5 gleicher Artikel);
                commit;
            else
                update aps_order_materialrelation apmr
                set
                    apmr.child_artikel_id = v_aps.artikel_id,
                    apmr.materialrelation_info = 'Kein Bestand',
                    apmr.child_id = - 1,
                    apmr.materialrelation_type = 0,
                    apmr.materialrelation_valide = 'F'
                where
                        apmr.auftrag_nr = v_aps.auftrag_nr
                    and apmr.pos_nr = v_aps.pos_nr
                    and apmr.upos_nr = v_aps.upos_nr
                    and apmr.aps_plan_status = in_aps_plan_status;

                commit;
            end if;

        end if;

        fetch c_get_aps_order_pos into v_aps;
        v_found := c_get_aps_order_pos%found;
    end loop;

    close c_get_aps_order_pos;
end;
/


-- sqlcl_snapshot {"hash":"e4f4cc085e52c72ce63557b505902ab7839628c8","type":"PROCEDURE","name":"APS_C_LOOK_FOR_RELATION","schemaName":"DIRKSPZM32","sxml":""}