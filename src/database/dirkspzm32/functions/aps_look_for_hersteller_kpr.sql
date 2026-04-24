create or replace function dirkspzm32.aps_look_for_hersteller_kpr (
    in_auftrag_nr      in s_rcv_kunden_auftr_pos.auftrag%type,
    in_aps_pos         in aps_order_auftr_pos.pos_nr%type,
    in_aps_plan_status in aps_order_auftr_pos.aps_plan_status%type
) return varchar2 is

    v_auftrag               s_rcv_kunden_auftr_pos.auftrag%type;
    v_soll_mg               s_rcv_kunden_auftr_pos.soll_menge%type;
    v_artikel_id            isi_artikel.artikel_id%type;
    v_artikel_p6            isi_artikel.artikel%type;
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
        ap.artikel_id,
        sum(ap.soll_menge)
    from
        aps_order_auftr_pos ap
    where
            ap.auftrag_nr = in_auftrag_nr
        and ap.aps_plan_status = in_aps_plan_status
        and ( ( ap.pos_nr <= 4
                and in_aps_pos <= 4 )
              or v_artikel_p6 is not null
              or ( in_aps_pos = ap.pos_nr
                   and in_aps_pos = 5 ) )
    group by
        ap.auftrag_nr,
        ap.artikel_id;

    cursor c_get_kpr_herstelle_liste is
    select
        ah.herstellerkuerzel hersteller_kuerzel_liste
    from
        isi_artikel_hersteller ah
    where
        ah.artikel_id = v_artikel_id;

begin
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
    open c_get_auftrag;
    fetch c_get_auftrag into
        v_auftrag,
        v_artikel_id,
        v_soll_mg;
    v_found := c_get_auftrag%found;
    loop
        v_hersteller_liste_last := v_hersteller_liste_akt;
        exit when not v_found;
        v_hersteller_liste_akt := null;
        open c_get_kpr_herstelle_liste;
        fetch c_get_kpr_herstelle_liste into v_hersteller; -- Liste aller möglichen Hersteller für das KPR
        loop
            exit when c_get_kpr_herstelle_liste%notfound;
            v_hersteller := v_hersteller || ';';
            if nvl(v_hersteller_liste_all, 'x') not like '%'
                                                         || v_hersteller
                                                         || '%' then
                if v_hersteller_liste_all is null then
                    v_hersteller_liste_all := v_hersteller;
                else
                    v_hersteller_liste_all := v_hersteller_liste_all || v_hersteller;
                end if;
            end if;

            if nvl(v_hersteller_liste_last, v_hersteller) like '%'
                                                               || v_hersteller
                                                               || '%'
               and nvl(v_hersteller_liste_akt, 'x') not like '%'
                                                             || v_hersteller
                                                             || '%' then
                if v_hersteller_liste_akt is null then
                    v_hersteller_liste_akt := v_hersteller;
                else
                    v_hersteller_liste_akt := v_hersteller_liste_akt || v_hersteller;
                end if;
            end if;

            fetch c_get_kpr_herstelle_liste into v_hersteller;
        end loop;

        close c_get_kpr_herstelle_liste;
        fetch c_get_auftrag into
            v_auftrag,
            v_artikel_id,
            v_soll_mg;
        v_found := c_get_auftrag%found;
    end loop;

    close c_get_auftrag;
    return ( v_hersteller_liste_last );
end;
/


-- sqlcl_snapshot {"hash":"106c00ab5b208267f5eabbe342a6f0d9a171eaa8","type":"FUNCTION","name":"APS_LOOK_FOR_HERSTELLER_KPR","schemaName":"DIRKSPZM32","sxml":""}