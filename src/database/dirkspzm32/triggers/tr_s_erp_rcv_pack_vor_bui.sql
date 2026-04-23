create or replace editionable trigger dirkspzm32.tr_s_erp_rcv_pack_vor_bui before
    insert or update on dirkspzm32.s_erp_rcv_pack_vorschr
    for each row
declare
    v_found            boolean;
    v_rcv_pack_vorschr s_rcv_pack_vorschr%rowtype;
    cursor c_rcv_pack_vorschr is
    select
        *
    from
        s_rcv_pack_vorschr t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.artikel = :new.artikel
        and t.kunden_nr = :new.kunden_nr;

begin
    open c_rcv_pack_vorschr;
    fetch c_rcv_pack_vorschr into v_rcv_pack_vorschr;
    v_found := c_rcv_pack_vorschr%found;
    close c_rcv_pack_vorschr;
    if :new.last_change_login_id is null then
        :new.last_change_login_id := -1;
    end if;

    if :new.sid is null then
        :new.sid := '01';
    end if;

    :new.created_date := sysdate;
    :new.created_login_id := -1;
    :new.kunden_nr := nvl(:new.kunden_nr,
                          '0');
    if not v_found then
        insert into s_rcv_pack_vorschr values ( :new.sid,
                                                :new.firma_nr,
                                                :new.artikel,
                                                :new.kunden_nr,
                                                :new.lhm_art_1,
                                                :new.lhm_art_2,
                                                :new.lhm_art_3,
                                                :new.lhm_art_4,
                                                :new.lhm_art_5,
                                                :new.top_art,
                                                :new.pal_art,
                                                :new.sep_art,
                                                :new.sep_anz,
                                                :new.box_art,
                                                :new.box_anz,
                                                :new.folie,
                                                :new.um_band,
                                                :new.ausg_ende,
                                                :new.komm_art,
                                                :new.waage_hin,
                                                :new.pack_schema,
                                                :new.lhm_eti_1,
                                                :new.lhm_eti_2,
                                                :new.lhm_eti_3,
                                                :new.lhm_eti_4,
                                                :new.lhm_eti_5,
                                                :new.lhm_eti_6,
                                                :new.lte_eti_1,
                                                :new.lte_eti_2,
                                                :new.lte_eti_3,
                                                :new.lte_eti_4,
                                                :new.lte_eti_5,
                                                :new.lte_eti_6,
                                                :new.created_date,
                                                :new.created_login_id,
                                                :new.last_change_date,
                                                :new.last_change_login_id );

    else
        update s_rcv_pack_vorschr
        set
            lhm_art_1 = :new.lhm_art_1,
            lhm_art_2 = :new.lhm_art_2,
            lhm_art_3 = :new.lhm_art_3,
            lhm_art_4 = :new.lhm_art_4,
            lhm_art_5 = :new.lhm_art_5,
            top_art = :new.top_art,
            pal_art = :new.pal_art,
            sep_art = :new.sep_art,
            sep_anz = :new.sep_anz,
            box_art = :new.box_art,
            box_anz = :new.box_anz,
            folie = :new.folie,
            um_band = :new.um_band,
            ausg_ende = :new.ausg_ende,
            komm_art = :new.komm_art,
            waage_hin = :new.waage_hin,
            pack_schema = :new.pack_schema,
            lhm_eti_1 = :new.lhm_eti_1,
            lhm_eti_2 = :new.lhm_eti_2,
            lhm_eti_3 = :new.lhm_eti_3,
            lhm_eti_4 = :new.lhm_eti_4,
            lhm_eti_5 = :new.lhm_eti_5,
            lhm_eti_6 = :new.lhm_eti_6,
            lte_eti_1 = :new.lte_eti_1,
            lte_eti_2 = :new.lte_eti_2,
            lte_eti_3 = :new.lte_eti_3,
            lte_eti_4 = :new.lte_eti_4,
            lte_eti_5 = :new.lte_eti_5,
            lte_eti_6 = :new.lte_eti_6,
            last_change_date = sysdate,
            last_change_login_id = :new.last_change_login_id
        where
                sid = :new.sid
            and firma_nr = :new.firma_nr
            and artikel = :new.artikel
            and kunden_nr = :new.kunden_nr;

    end if;

    update s_rcv_artikel t
    set
        t.packschema_kopf_id = :new.pack_schema
    where
        t.artikel = :new.artikel;

end;
/

alter trigger dirkspzm32.tr_s_erp_rcv_pack_vor_bui enable;


-- sqlcl_snapshot {"hash":"b007bf922499518832218d5a52807c11758464ad","type":"TRIGGER","name":"TR_S_ERP_RCV_PACK_VOR_BUI","schemaName":"DIRKSPZM32","sxml":""}