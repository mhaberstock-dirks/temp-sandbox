create or replace editionable trigger dirkspzm32.tr_lvs_lam_bu before
    update on dirkspzm32.lvs_lam
    for each row
declare
    v_lgr      lvs_lgr%rowtype;
    v_lgr_next lvs_lgr%rowtype;
    v_lte      lvs_lte%rowtype;
    v_found    boolean;
    cursor c_lgr is
    select
        t.*
    from
        lvs_lgr t
    where
        t.lgr_platz = :new.lgr_platz;

    cursor c_lgr_next is
    select
        t.*
    from
        lvs_lgr t
    where
            t.lgr_platz_gruppe = v_lgr.lgr_platz_gruppe
        and t.lgr_dim_fifo_nr > v_lgr.lgr_dim_fifo_nr
        and t.lgr_dim_g = v_lgr.lgr_dim_g
        and t.lgr_dim_r = v_lgr.lgr_dim_r
        and t.lgr_dim_p = v_lgr.lgr_dim_p
        and t.lgr_dim_e = v_lgr.lgr_dim_e
    order by
        t.lgr_dim_fifo_nr;

    cursor c_lte is
    select
        t.*
    from
        lvs_lte t
    where
        t.lte_id = :old.lte_id;

begin
    if :old.labor_status != :new.labor_status then
        open c_lte;
        fetch c_lte into v_lte;
        close c_lte;
        v_lte.res_string := replace(v_lte.res_string,
                                    ';'
                                    || :old.labor_status
                                    || ';',
                                    ';'
                                    || :new.labor_status
                                    || ';');

        if
            :new.lte_id is null
            and :new.menge = 0
        then
            :new.order_pos_auf_id := null;
        end if;

    -- war Reserviert und jetzt nicht mehr
        if
            :old.order_pos_auf_id is not null
            and :new.order_pos_auf_id is null
        then
      -- Dann auch die RES_Menge etc löschen
            :new.res_menge := null;
            :new.res_ziel_lte_id := null;
            :new.res_login_id := null;
        end if;

        update lvs_lte t
        set
            t.res_string = v_lte.res_string
        where
            t.lte_id = :old.lte_id;

        open c_lgr;
        fetch c_lgr into v_lgr;
        close c_lgr;
        open c_lgr_next;
        fetch c_lgr_next into v_lgr_next;
        v_found := c_lgr_next%found;
        close c_lgr_next;
        if
            v_lgr_next.lgr_max_te = v_lgr_next.lgr_einl_te_verfueg
            and v_found
        then
            lvs_lager_opt.lvs_kanal_kontrolle(v_lte, v_lgr);
        else
            update lvs_lgr t
            set
                t.res_string = v_lte.res_string
            where
                t.lgr_platz = v_lte.lgr_platz;

        end if;

    end if;
end tr_lvs_lam_bu;
/

alter trigger dirkspzm32.tr_lvs_lam_bu enable;


-- sqlcl_snapshot {"hash":"23fa8910b12f64ecccd53dff8718fdb5a51e6121","type":"TRIGGER","name":"TR_LVS_LAM_BU","schemaName":"DIRKSPZM32","sxml":""}