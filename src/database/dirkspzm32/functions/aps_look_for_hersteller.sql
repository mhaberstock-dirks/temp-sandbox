create or replace function dirkspzm32.aps_look_for_hersteller (
    in_auftrag_nr      in s_rcv_kunden_auftr_pos.auftrag%type,
    in_aps_pos         in aps_order_auftr_pos.pos_nr%type,
    in_aps_plan_status in aps_order_auftr_pos.aps_plan_status%type
) return varchar2 is

    v_auftrag               s_rcv_kunden_auftr_pos.auftrag%type;
    v_soll_mg               s_rcv_kunden_auftr_pos.soll_menge%type;
    v_lam_menge             lvs_lam.menge%type;
    v_artikel_id            isi_artikel.artikel_id%type;
    v_artikel_p6            isi_artikel.artikel%type;
    v_artikel_reifen        isi_artikel.artikel%type;
    v_hersteller            aps_order_auftr_pos.hersteller_kuerzel_liste%type;
    v_hersteller_liste_last aps_order_auftr_pos.hersteller_kuerzel_liste%type;
    v_hersteller_liste_akt  aps_order_auftr_pos.hersteller_kuerzel_liste%type;
    v_hersteller_liste_all  aps_order_auftr_pos.hersteller_kuerzel_liste%type;
    v_found                 boolean;
    cursor c_get_auftrag_p5 is
    select
        ap5.auftrag_nr,
        a5.artikel_id,
        a5.artikel_p6
    from
        aps_order_auftr_pos ap5,
        isi_artikel         a5,
        aps_order_auftr_pos ap4,
        isi_artikel         a4
    where
            ap5.auftrag_nr = in_auftrag_nr
        and ap5.artikel_id = a5.artikel_id
        and ap5.aps_plan_status = in_aps_plan_status
        and ap5.pos_nr = 5
        and ap4.auftrag_nr = in_auftrag_nr
        and ap4.artikel_id = a4.artikel_id
        and ap4.aps_plan_status = in_aps_plan_status
        and ap4.pos_nr = 4
        and a4.artikel_p6 = a5.artikel_p6;

    cursor c_get_auftrag is
    select
        ap.auftrag_nr,
        a.artikel_id,
        sum(ap.soll_menge),
        a.artikel_p6
    from
        aps_order_auftr_pos ap,
        isi_artikel         a
    where
            ap.auftrag_nr = in_auftrag_nr
        and ap.artikel_id = a.artikel_id
        and ap.aps_plan_status = in_aps_plan_status
        and ( ap.pos_nr <= decode(in_aps_pos, 4, 4, 0)
              or v_artikel_p6 is not null
              or ( in_aps_pos = ap.pos_nr
                   and in_aps_pos = 5 ) )
    group by
        ap.auftrag_nr,
        a.artikel_id,
        a.artikel_p6;

    cursor c_get_herstelle_liste is
    select
        xx.hersteller_kuerzel_liste,
        xx.menge
    from
        (
            select
                lam.hersteller_kuerzel_liste,
                lam.artikel_id,
                sum(lam.menge)   menge,
                min(lam.lam_mhd) lam_mhd
            from
                lvs_lam lam,
                lvs_lgr lgr,
                lvs_lte lte
            where
                    1 = 1
                and exists (
                    select
                        ap.auftrag_nr
                    from
                        aps_order_auftr_pos ap
                    where
                            ap.auftrag_nr = v_auftrag
                        and ap.aps_plan_status = in_aps_plan_status
                )
                and lam.artikel_id = v_artikel_id
                and lam.order_pos_auf_id is null
                and lam.lgr_platz = lgr.lgr_platz
                and lam.labor_status in ( 'F', 'Q' )
                and lam.lgr_platz = lgr.lgr_platz
                and lam.fa_ag is null
                and lgr.lgr_typ != 'DURCHL1'                        -- Durchlauflager mit begrenzten Zugriff
                and lgr.gesperrt = 'F'
                and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
                and lgr.lgr_ort in ( 500, 600, 610, 620 )
                and lam.lte_id = lte.lte_id
                and lte.lte_status != 'AG'
                and lte.lte_status != 'KF'
                and lte.lte_status != 'PF'
                and lte.lte_status != 'AF'
                and lte.lte_status != 'BF'
                and lte.lte_status != 'UF'
            group by
                lam.hersteller_kuerzel_liste,
                lam.artikel_id
        ) xx
    where
        xx.menge >= nvl((
            select
                sum(op.soll_menge)
            from
                aps_order_auftr_pos op
            where
                    op.aps_plan_status = in_aps_plan_status
                and op.artikel_id = v_artikel_id
                and op.hersteller_kuerzel_liste = xx.hersteller_kuerzel_liste
        ),
                        0) + v_soll_mg
    order by
        xx.lam_mhd;

    cursor c_get_herstelle_reifen is
    select
        xx.hersteller_kuerzel_liste,
        xx.menge
    from
        (
            select
                lam.hersteller_kuerzel_liste,
                lam.artikel_id,
                sum(lam.menge)   menge,
                min(lam.lam_mhd) lam_mhd
            from
                lvs_lam     lam,
                lvs_lgr     lgr,
                lvs_lte     lte,
                isi_artikel a
            where
                    1 = 1
                and exists (
                    select
                        ap.auftrag_nr
                    from
                        aps_order_auftr_pos ap
                    where
                            ap.auftrag_nr = v_auftrag
                        and ap.aps_plan_status = in_aps_plan_status
                )
                and a.artikel = v_artikel_reifen
                and lam.artikel_id = a.artikel_id
                and lam.order_pos_auf_id is null
                and lam.lgr_platz = lgr.lgr_platz
                and lam.labor_status in ( 'F' )
                and lam.lgr_platz = lgr.lgr_platz
                and lam.fa_ag is null
                and lgr.lgr_typ != 'DURCHL1'                        -- Durchlauflager mit begrenzten Zugriff
                and lgr.gesperrt = 'F'
                and lgr.akt_inventur_id is null                      -- Nur Ware auf Lagerplätzen reservieren, die nicht in Inventur sind
                and lgr.lgr_ort not in ( 500, 600, 610, 620 )
                and lam.lte_id = lte.lte_id
                and lte.lte_status != 'AG'
                and lte.lte_status != 'KF'
                and lte.lte_status != 'PF'
                and lte.lte_status != 'AF'
                and lte.lte_status != 'BF'
                and lte.lte_status != 'UF'
            group by
                lam.hersteller_kuerzel_liste,
                lam.artikel_id
        ) xx
    where
        xx.menge >= v_soll_mg
    order by
        xx.lam_mhd;

begin
  -- -AG- 24.03.2023 Die Funktion wurde um Kommentare und eine funktionale Erweiterung (lagerbestand Reserverad) erweitert
    if in_aps_pos = 5 then
        open c_get_auftrag_p5;
        fetch c_get_auftrag_p5 into
            v_auftrag,
            v_artikel_id,
            v_artikel_p6;
        close c_get_auftrag_p5;
    end if;
  -- Test statements here
    v_hersteller_liste_akt := null;
    v_hersteller_liste_last := null;
    v_hersteller_liste_all := null;
  
  -- Hersteller für alle Positionen finden (Über verfügbaren Lagerbestand)
    open c_get_auftrag;
    fetch c_get_auftrag into
        v_auftrag,
        v_artikel_id,
        v_soll_mg,
        v_artikel_reifen;
    v_found := c_get_auftrag%found;
    loop
        v_hersteller_liste_last := v_hersteller_liste_akt;
        exit when not v_found;
        v_hersteller_liste_akt := null;
    -- Herstellerliste bilden
        open c_get_herstelle_liste;
    -- Lesen der Aufträge mit möglichen Lagerbestand und deren Hersteller
        fetch c_get_herstelle_liste into
            v_hersteller,
            v_lam_menge;
        loop
            exit when c_get_herstelle_liste%notfound; -- Keine Auftragspositionen mehr zu prüfen
      -- Die aktuelle komplette Herstellerliste ist leer oder der gefundene Hersteller ist noch nicht eingetragen
      -- Hier wird gemerkt, dass es für mindestens eine Position einen Lagerbestand gibt 
      -- Für nachprüfung im zweiten schritt wenn kein gemeinsamer Hersteller gefunden wird
            if nvl(v_hersteller_liste_all, 'x') not like '%'
                                                         || v_hersteller
                                                         || '%' then
                if v_hersteller_liste_all is null -- Well leer
                 then
                    v_hersteller_liste_all := v_hersteller; -- Dann eintragen
                else
                    v_hersteller_liste_all := v_hersteller_liste_all || v_hersteller; -- Sonst mit dem gefundenen Hersteller in der Komplettliste ergänzen 
                end if;

            end if;
      -- Hier wird geprüft und gesucht, ob es Lagerbestand für alle Positionen gibt (Mit gleichem Hersteller)
      -- v_hersteller_liste_last ist in der ersten zu prüfenden Position immer leer. Dadurch werden alle möglichen Hersteller eingetragen
            if
                nvl(v_hersteller_liste_last, v_hersteller) like '%'
                                                                || v_hersteller
                                                                || '%' -- Oder der Gefundene Hersteller ist in der Liste und gültig
                and nvl(v_hersteller_liste_akt, 'x') not like '%'
                                                              || v_hersteller
                                                              || '%' -- Und der hersteller ist aktuell noch nicht eingetragen
                and v_lam_menge >= v_soll_mg -- lagerbestand muss dann auch in ausreichender menge vorhanden sein
            then
                if v_hersteller_liste_akt is null -- Erste Eintag
                 then
                    v_hersteller_liste_akt := v_hersteller; -- dann eintragen
                else
                    v_hersteller_liste_akt := v_hersteller_liste_akt || v_hersteller; -- sonst ergänzen
                end if;
            end if;

            fetch c_get_herstelle_liste into
                v_hersteller,
                v_lam_menge; -- Nachlesen weiterer Hersteller für die Position
        end loop;

        close c_get_herstelle_liste;
        fetch c_get_auftrag into
            v_auftrag,
            v_artikel_id,
            v_soll_mg,
            v_artikel_reifen; -- Nächste Position lesen
        v_found := c_get_auftrag%found;
    end loop;

    close c_get_auftrag;
    if
        v_hersteller_liste_last is null -- Noch kein Hersteller für alle Positiionen gefunden
        and v_hersteller_liste_all is not null -- Aber es gibt Lagerbestand von einem Hersteller füm mindestens eine Position
        and in_aps_pos != 5 -- Wir haben kein Reserverad 
    then
    -- Mögliche Hersteller für Positionen finden (Über verfügbaren Lagerbestand)
        open c_get_auftrag;
        fetch c_get_auftrag into
            v_auftrag,
            v_artikel_id,
            v_soll_mg,
            v_artikel_reifen;
        v_found := c_get_auftrag%found;
        loop
            exit when not v_found; -- Keine Positionen mehr zu finden
            v_hersteller_liste_last := null; -- Noch kein hersteller gefunden
            open c_get_herstelle_reifen;     -- Suchen im Rohstoff Reifen nach möglichen Herstelle
            fetch c_get_herstelle_reifen into
                v_hersteller,
                v_lam_menge;
            loop
                exit when c_get_herstelle_reifen%notfound; -- Keinen oder keinen weiteren hersteller gefunden
                if nvl(v_hersteller_liste_all, 'x') like '%'
                                                         || v_hersteller
                                                         || '%' -- Hersteller gehört zu den gefundenen Herstellern (Herstellerkomplettliste)
                                                          then
                    v_hersteller_liste_last := v_hersteller; -- Diesen Hersteller einfach nehmen als Vorschlag
                    exit;
                end if;

                fetch c_get_herstelle_reifen into
                    v_hersteller,
                    v_lam_menge; -- weiter suchen im Rohstoff
            end loop;

            close c_get_herstelle_reifen; -- Position fertig, CURSOR schliessen
            exit when v_hersteller_liste_last is not null; -- Mit diesem Hersteller in die Planung gehen

            fetch c_get_auftrag into
                v_auftrag,
                v_artikel_id,
                v_soll_mg,
                v_artikel_reifen; -- Noch keine Hersteller als Vorschlag gefunden
            v_found := c_get_auftrag%found; -- dann weiter suchen mit der nächsten position
        end loop;

        close c_get_auftrag;
    end if;

  -- -AG- 24.03.2023 Dieser part ist neu (IF bis Endif)
    if
        v_hersteller_liste_last is null
        and v_hersteller_liste_all is not null
        and in_aps_pos = 5 -- Mit Reserverad
        and v_artikel_p6 is not null -- Reserverad hat den gleichen Reifen
    then
    -- Mögliche Hersteller für Positionen finden (Über verfügbaren Lagerbestand)
        open c_get_auftrag;
        fetch c_get_auftrag into
            v_auftrag,
            v_artikel_id,
            v_soll_mg,
            v_artikel_reifen; -- Nur noch für diese Position versuchen
        v_hersteller_liste_last := null; -- Noch kein hersteller gefunden
        open c_get_herstelle_reifen;     -- Suchen im Rohstoff Reifen nach möglichen Herstelle
        fetch c_get_herstelle_reifen into
            v_hersteller,
            v_lam_menge;
        loop
            exit when c_get_herstelle_reifen%notfound; -- Keinen oder keinen weiteren hersteller gefunden
            if nvl(v_hersteller_liste_all, 'x') like '%'
                                                     || v_hersteller
                                                     || '%' -- Hersteller gehört zu den gefundenen Herstellern (Herstellerkomplettliste)
                                                      then
                v_hersteller_liste_last := v_hersteller; -- Diesen Hersteller einfach nehmen als Vorschlag
                exit;
            end if;

            fetch c_get_herstelle_reifen into
                v_hersteller,
                v_lam_menge; -- weiter suchen im Rohstoff
        end loop;

        close c_get_herstelle_reifen; -- Position fertig, CURSOR schliessen
        close c_get_auftrag;
    end if;
  -- -AG- 24.03.2023 Dieser part ist neu (IF bis Endif)  

    return ( v_hersteller_liste_last );
end;
/


-- sqlcl_snapshot {"hash":"3878b52582fe40e6c92155b481cb5cbc852933d0","type":"FUNCTION","name":"APS_LOOK_FOR_HERSTELLER","schemaName":"DIRKSPZM32","sxml":""}