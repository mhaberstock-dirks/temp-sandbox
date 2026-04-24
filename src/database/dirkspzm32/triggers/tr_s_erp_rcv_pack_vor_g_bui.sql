create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_pack_vor_g_bui before
    insert or update on dirkspzm32.s_erp_rcv_pack_vorschr_gew
    for each row
declare
    v_found                boolean;
    v_rcv_pack_vorschr_gew s_rcv_pack_vorschr_gew%rowtype;
    cursor c_rcv_pack_vorschr_gew is
    select
        *
    from
        s_rcv_pack_vorschr_gew t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.artikel = :new.artikel
        and t.kunden_nr = :new.kunden_nr;

begin
    if :new.sid is null then
        :new.sid := '01';
    end if;

    open c_rcv_pack_vorschr_gew;
    fetch c_rcv_pack_vorschr_gew into v_rcv_pack_vorschr_gew;
    v_found := c_rcv_pack_vorschr_gew%found;
    close c_rcv_pack_vorschr_gew;
    :new.created_date := sysdate;
    :new.created_login_id := -1;
    if not v_found then
        insert into s_rcv_pack_vorschr_gew values ( :new.sid,
                                                    :new.firma_nr,
                                                    :new.artikel,
                                                    :new.kunden_nr,
                                                    :new.gew_nr,
                                                    :new.lhm_art_1,
                                                    :new.lhm_gew_nom,
                                                    :new.lhm_gew_max,
                                                    :new.lhm_gew_min,
                                                    :new.lhm_gew_abw_pal,
                                                    :new.created_date,
                                                    :new.created_login_id,
                                                    :new.last_change_date,
                                                    :new.last_change_login_id );

    else
        update s_rcv_pack_vorschr_gew
        set
            gew_nr = :new.gew_nr,
            lhm_artikel = :new.lhm_art_1,
            lhm_gew_nom = :new.lhm_gew_nom,
            lhm_gew_max = :new.lhm_gew_max,
            lhm_gew_min = :new.lhm_gew_min,
            lhm_gew_abw_pal = :new.lhm_gew_abw_pal,
            created_date = :new.created_date,
            created_login_id = :new.created_login_id,
            last_change_date = :new.last_change_date,
            last_change_login_id = :new.last_change_login_id
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and artikel = :new.artikel
            and kunden_nr = :new.kunden_nr;

    end if;

end;
/

alter trigger dirkspzm32.tr_s_erp_rcv_pack_vor_g_bui enable;


-- sqlcl_snapshot {"hash":"149a1d41fa8907c4f47d3b980fb296ec77c7a099","type":"TRIGGER","name":"TR_S_ERP_RCV_PACK_VOR_G_BUI","schemaName":"DIRKSPZM32","sxml":""}