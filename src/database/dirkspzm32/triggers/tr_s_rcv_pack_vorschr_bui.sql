create or replace editionable trigger dirkspzm32.tr_s_rcv_pack_vorschr_bui before
    insert or update on dirkspzm32.s_rcv_pack_vorschr
    for each row
declare
    v_found        boolean;
    v_pack_vorschr isi_pack_vorschr%rowtype;
    cursor c_pack_vorschr is
    select
        *
    from
        isi_pack_vorschr t
    where
            t.sid = :new.sid
        and t.firma_nr = :new.firma_nr
        and t.artikel_id = (
            select
                a.artikel_id
            from
                isi_artikel a
            where
                    a.sid = :new.sid
                and a.artikel = :new.artikel
        )
        and t.kunden_nr = :new.kunden_nr;

begin
    open c_pack_vorschr;
    fetch c_pack_vorschr into v_pack_vorschr;
    v_found := c_pack_vorschr%found;
    close c_pack_vorschr;
    if not v_found then
        insert into isi_pack_vorschr values ( :new.sid,
                                              :new.firma_nr,
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.artikel
                                              ),
                                              :new.kunden_nr,
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.lhm_art_1
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.lhm_art_2
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.lhm_art_3
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.lhm_art_4
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.lhm_art_5
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.top_art
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.pal_art
                                              ),
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.sep_art
                                              ),
                                              :new.sep_anz,
                                              (
                                                  select
                                                      a.artikel_id
                                                  from
                                                      isi_artikel a
                                                  where
                                                          a.sid = :new.sid
                                                      and a.artikel = :new.box_art
                                              ),
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
        update isi_pack_vorschr
        set
            lhm_art_1 = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.lhm_art_1
            ),
            lhm_art_2 = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.lhm_art_2
            ),
            lhm_art_3 = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.lhm_art_3
            ),
            lhm_art_4 = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.lhm_art_4
            ),
            lhm_art_5 = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.lhm_art_5
            ),
            top_art = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.top_art
            ),
            pal_art = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.pal_art
            ),
            sep_art = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.sep_art
            ),
            sep_anz = :new.sep_anz,
            box_art = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.box_art
            ),
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
            and artikel_id = (
                select
                    a.artikel_id
                from
                    isi_artikel a
                where
                        a.sid = :new.sid
                    and a.artikel = :new.artikel
            )
            and kunden_nr = :new.kunden_nr;

    end if;

end;
/

alter trigger dirkspzm32.tr_s_rcv_pack_vorschr_bui enable;


-- sqlcl_snapshot {"hash":"51923a585565603b4a361f849646e0ccb32e2d5e","type":"TRIGGER","name":"TR_S_RCV_PACK_VORSCHR_BUI","schemaName":"DIRKSPZM32","sxml":""}