create or replace editionable trigger dirkspzm32.tr_isi_komm_order_biud before
    insert or update or delete on dirkspzm32.isi_komm_order
    for each row
declare
  -- local variables here
    v_lte                      lvs_lte%rowtype;
    v_found                    boolean;
    v_order_pos                isi_order_pos%rowtype;
    v_ziel_packschema_kopf_id  lvs_packschema_kopf.packschema_kopf_id%type;
    v_ziel_packschema_lte_name lvs_packschema_kopf.lte_name%type;
    v_anz_lagen                lvs_packschema_kopf.anz_lagen%type;
    v_lhm_pro_lage             number;
    v_lhm_hoehe_lage           number;
    v_mengeneinheit            isi_artikel.mengeneinheit%type;
    v_ziel_lte_name            lvs_lte_cfg.lte_name%type;
    v_lte_cfg                  lvs_lte_cfg%rowtype;
    cursor c_packschema is
    select
        pk.packschema_kopf_id,
        pk.anz_lagen,
        (
            select
                count(pp.packschema_pos_nr)
            from
                lvs_packschema_pos pp
            where
                pp.packschema_kopf_id = pk.packschema_kopf_id
        )                     lhm_pro_lage,
        nvl((
            select
                max(lhm.lhm_vol_hoehe)
            from
                lvs_lhm lhm
            where
                lhm.lte_id = :new.lte_id
        ),
            a.lhm_hoehe_lage) lhm_hoehe_lage,
        a.mengeneinheit,
        pk.lte_name
    from
        lvs_lte             lte,
        lvs_packschema_kopf pk,
        isi_artikel         a
    where
            :new.lte_id = lte.lte_id
        and :new.artikel_id = a.artikel_id
        and v_order_pos.ziel_packschema_kopf_id = pk.packschema_kopf_id (+);

    cursor c_packschema_q_z is
    select
        qz.ziel_packschema_kopf_id,
        pk.anz_lagen,
        (
            select
                count(pp.packschema_pos_nr)
            from
                lvs_packschema_pos pp
            where
                pp.packschema_kopf_id = pk.packschema_kopf_id
        )                     lhm_pro_lage,
        nvl((
            select
                max(lhm.lhm_vol_hoehe)
            from
                lvs_lhm lhm
            where
                lhm.lte_id = :new.lte_id
        ),
            a.lhm_hoehe_lage) lhm_hoehe_lage,
        a.mengeneinheit,
        pk.lte_name
    from
        lvs_lte             lte,
        lvs_packschema_q_z  qz,
        lvs_packschema_kopf pk,
        isi_artikel         a
    where
            :new.lte_id = lte.lte_id
        and :new.artikel_id = a.artikel_id
        and ( pk.lte_name = v_ziel_lte_name
              or v_ziel_lte_name is null )
        and lte.packschema_kopf_id = qz.quell_packschema_kopf_id (+)
        and qz.ziel_packschema_kopf_id = pk.packschema_kopf_id (+);

    cursor c_packschema_z is
    select
        pk.packschema_kopf_id,
        pk.anz_lagen,
        (
            select
                count(pp.packschema_pos_nr)
            from
                lvs_packschema_pos pp
            where
                pp.packschema_kopf_id = pk.packschema_kopf_id
        )                     lhm_pro_lage,
        nvl((
            select
                max(lhm.lhm_vol_hoehe)
            from
                lvs_lhm lhm
            where
                lhm.lte_id = :new.lte_id
        ),
            a.lhm_hoehe_lage) lhm_hoehe_lage,
        a.mengeneinheit,
        pk.lte_name
    from
        lvs_lte             lte,
        lvs_packschema_kopf pk,
        lvs_packschema_kopf pkq,
        isi_artikel         a
    where
            :new.lte_id = lte.lte_id
        and :new.artikel_id = a.artikel_id
        and ( ( pk.lte_name = v_ziel_lte_name )
              or ( v_ziel_lte_name is null
                   and lte.packschema_kopf_id = pk.packschema_kopf_id ) )
        and lte.packschema_kopf_id = pkq.packschema_kopf_id (+)
        and pk.lhm_name = pkq.lhm_name;

begin
    if inserting then
        if :new.komm_id is null then
            select
                seq_komm_id.nextval
            into :new.komm_id
            from
                dual;

        end if;

        if :new.ts is null then
            :new.ts := sysdate;
        end if;

    end if;

    if updating then
        if nvl(:new.bearb_login_id,
               -1) != nvl(:old.bearb_login_id,
                          -1) then
            :new.bearb_start_datum := sysdate;
        end if;

    end if;

    v_ziel_lte_name := null;
    if
        ( inserting
        or updating )
        and :new.komm_typ in ( 'KE',  --Kommissionierung-Entnahme;
         'KRE', --=Kommissionierung Rest-Entnahme;
         'KP',  --=Kommissionierung-Picken;
         'UP',  --=Umpacken;
         'UPA'  --=Artikelreines Umpacken;
         )
    then
        if
            :new.lte_id is not null
            and isi_p_order_base.get_order_pos(:new.sid,
                                               :new.auf_id,
                                               v_order_pos)
        then
            if lvs_p_base.get_lte(:new.lte_id,
                                  v_lte) then
                if lvs_p_base.get_lte_cfg(:new.sid,
                                          v_order_pos.ziel_lte_name,
                                          v_lte_cfg) then
                    v_ziel_lte_name := v_lte_cfg.lte_name;
                end if;

                if :new.packschema_traeger_id is null then
                    :new.packschema_traeger_id := v_lte.packschema_kopf_id;
                end if;

                v_ziel_packschema_kopf_id := null;
                v_anz_lagen := null;
                v_lhm_pro_lage := null;
                v_lhm_hoehe_lage := null;
                :new.lhm_menge := v_order_pos.ziel_lhm_menge;
                if v_order_pos.ziel_packschema_kopf_id is null then
                    open c_packschema_q_z;
                    fetch c_packschema_q_z into
                        v_ziel_packschema_kopf_id,
                        v_anz_lagen,
                        v_lhm_pro_lage,
                        v_lhm_hoehe_lage,
                        v_mengeneinheit,
                        v_ziel_packschema_lte_name;
                    v_found := c_packschema_q_z%found;
                    close c_packschema_q_z;
                    if v_found then
                        if :new.packschema_kopf_id is null then
                            :new.packschema_kopf_id := v_ziel_packschema_kopf_id;
                        end if;

                        if nvl(:new.lte_lhm_lagen,
                               0) = 0 then
                            :new.lte_lhm_lagen := v_anz_lagen;
                        end if;

                        if nvl(:new.lte_lhm_pro_lage,
                               0) = 0 then
                            if :new.packschema_kopf_id is not null then
                                :new.lte_lhm_pro_lage := v_lhm_pro_lage;
                            else
                                :new.lte_lhm_pro_lage := null;
                            end if;
                        end if;

                        if nvl(:new.lhm_hoehe_lage,
                               0) = 0 then
                            :new.lhm_hoehe_lage := v_lhm_hoehe_lage;
                        end if;

                        if :new.mengeneinheit is null then
                            :new.mengeneinheit := v_mengeneinheit;
                        end if;

                    else
                        open c_packschema_z;
                        fetch c_packschema_z into
                            v_ziel_packschema_kopf_id,
                            v_anz_lagen,
                            v_lhm_pro_lage,
                            v_lhm_hoehe_lage,
                            v_mengeneinheit,
                            v_ziel_packschema_lte_name;
                        v_found := c_packschema_z%found;
                        close c_packschema_z;
                        if v_found then
                            if :new.packschema_kopf_id is null then
                                :new.packschema_kopf_id := v_ziel_packschema_kopf_id;
                            end if;

                            if nvl(:new.lte_lhm_lagen,
                                   0) = 0 then
                                :new.lte_lhm_lagen := v_anz_lagen;
                            end if;

                            if nvl(:new.lte_lhm_pro_lage,
                                   0) = 0 then
                                if :new.packschema_kopf_id is not null then
                                    :new.lte_lhm_pro_lage := v_lhm_pro_lage;
                                else
                                    :new.lte_lhm_pro_lage := null;
                                end if;
                            end if;

                            if nvl(:new.lhm_hoehe_lage,
                                   0) = 0 then
                                :new.lhm_hoehe_lage := v_lhm_hoehe_lage;
                            end if;

                            if :new.mengeneinheit is null then
                                :new.mengeneinheit := v_mengeneinheit;
                            end if;

                        end if;

                    end if;

                else
                    :new.packschema_kopf_id := v_order_pos.ziel_packschema_kopf_id;
                    open c_packschema;
                    fetch c_packschema into
                        v_ziel_packschema_kopf_id,
                        v_anz_lagen,
                        v_lhm_pro_lage,
                        v_lhm_hoehe_lage,
                        v_mengeneinheit,
                        v_ziel_packschema_lte_name;
                    v_found := c_packschema%found;
                    close c_packschema;
                    if v_found then
                        if nvl(:new.lte_lhm_lagen,
                               0) = 0 then
                            :new.lte_lhm_lagen := v_anz_lagen;
                        end if;

                        if nvl(:new.lte_lhm_pro_lage,
                               0) = 0 then
                            if :new.packschema_kopf_id is not null then
                                :new.lte_lhm_pro_lage := v_lhm_pro_lage;
                            else
                                :new.lte_lhm_pro_lage := null;
                            end if;

                        end if;

                        if nvl(:new.lhm_hoehe_lage,
                               0) = 0 then
                            :new.lhm_hoehe_lage := v_lhm_hoehe_lage;
                        end if;

                        if :new.mengeneinheit is null then
                            :new.mengeneinheit := v_mengeneinheit;
                        end if;

                    end if;

                end if;

            end if;

            if
                v_order_pos.ziel_lte_name is null
                and v_ziel_packschema_lte_name is not null
                and :new.modul_erzeuger = c.lgr_modul_mfr
            then
                update isi_order_pos p
                set
                    p.ziel_lte_name = v_ziel_packschema_lte_name
                where
                    p.auf_id = v_order_pos.auf_id;

            end if;

        end if;
    end if;

end tr_isi_komm_order_biud;
/

alter trigger dirkspzm32.tr_isi_komm_order_biud enable;


-- sqlcl_snapshot {"hash":"a03cff62e0cfb868983446b40817c602cdd14fb4","type":"TRIGGER","name":"TR_ISI_KOMM_ORDER_BIUD","schemaName":"DIRKSPZM32","sxml":""}