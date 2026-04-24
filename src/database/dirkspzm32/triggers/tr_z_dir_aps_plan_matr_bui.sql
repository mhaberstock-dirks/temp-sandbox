create or replace editionable trigger dirkspzm32.tr_z_dir_aps_plan_matr_bui before
    insert or update on dirkspzm32.aps_plan_op_a_mat_relation
    for each row
declare
  -- local variables here
    v_artikel         isi_artikel%rowtype;
    v_aps_auftrag_mr  aps_order_materialrelation%rowtype;
    v_aps_auftrag_pos aps_order_auftr_pos%rowtype;
    v_aps_pe          aps_plan_ergebnis%rowtype;
    cursor c_aps_auftrag_pos is
    select
        *
    from
        aps_order_auftr_pos op
    where
            op.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
        and op.pos_nr = v_aps_auftrag_mr.pos_nr
        and op.upos_nr = v_aps_auftrag_mr.upos_nr
        and op.aps_plan_status in ( 'PS', 'PE' );

    cursor c_aps_auftrag_mr is
    select
        *
    from
        aps_order_materialrelation mr
    where
            mr.materialrelation_type = 2
        and mr.child_id = :new.aps_plan_auftrag_nr
        and mr.aps_plan_status in ( 'PS', 'PE' );

    cursor c_aps_pe is
    select
        *
    from
        aps_plan_ergebnis pe
    where
            pe.aps_plan_auftrag_nr = :new.aps_plan_auftrag_nr
        and pe.aps_plan_status in ( 'PS', 'PE' );

begin
    if
        updating
        and :new.aps_plan_status = 'PE'
        and :old.aps_plan_status = 'PS'
    then
        open c_aps_pe;
        fetch c_aps_pe into v_aps_pe;
        close c_aps_pe;
        if
            isi_p_base.get_isi_artikel(:new.sid,
                                       nvl(:new.child_artikel_id,
                                           v_aps_pe.artikel_id),
                                       v_artikel)
            and ( v_artikel.waren_gruppe in ( 'FE', 'RE' )
                  or v_aps_pe.leitzahl is not null )
        then
            open c_aps_auftrag_mr;
            fetch c_aps_auftrag_mr into v_aps_auftrag_mr;
            close c_aps_auftrag_mr;
            if v_aps_pe.leitzahl is null then
                if nvl(v_aps_pe.abnr, '00000000') = 00000000 then
                    open c_aps_auftrag_pos;
                    fetch c_aps_auftrag_pos into v_aps_auftrag_pos;
                    close c_aps_auftrag_pos;
                    if v_aps_auftrag_pos.order_info in ( 'K100', 'R100' )
                       or (
                        v_aps_pe.abnr is null
                        and v_aps_auftrag_pos.order_info not in ( 'M100' )
                    )
                    or (
                        v_aps_auftrag_pos.order_info in ( 'L100' )
                        and v_aps_auftrag_pos.prioritaet = 4
                    ) then
                        update aps_order_materialrelation mr
                        set
                            mr.materialrelation_info = 'Keine Planung (Batch) für Planauftrag '
                                                       || :new.aps_plan_auftrag_nr
                                                       || ' nicht gedeckt. Kundenauftrag '
                                                       || v_aps_auftrag_mr.auftrag_nr
                                                       || '/'
                                                       || v_aps_auftrag_mr.pos_nr
                                                       || '-'
                                                       || v_aps_auftrag_mr.upos_nr
                                                       || ' Status '
                                                       || nvl(v_aps_auftrag_pos.order_info, 'Fehlt'),
                            mr.materialrelation_valide = 'I'
                        where
                                mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                            and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                            and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                            and mr.materialrelation_type = 2
                            and ( nvl(mr.materialrelation_valide, 'T') = 'T'
                                  or nvl(mr.materialrelation_valide, 'I') = 'I'
                                  or mr.materialrelation_info is null
                                  or mr.materialrelation_info = 'Planauftrag ohne Prüfung der Komponenten' );

                        update aps_order_materialrelation mr
                        set
                            mr.materialrelation_info = 'Keine Planung (Batch) für Planauftrag PRIO 4' || mr.materialrelation_info,
                            mr.materialrelation_valide = 'I'
                        where
                                mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                            and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                            and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                            and mr.materialrelation_type = 2
                            and mr.materialrelation_valide = 'F'
                            and v_aps_auftrag_pos.order_info in ( 'L100' )
                            and v_aps_auftrag_pos.prioritaet = 4;

                        update aps_plan_ergebnis pe
                        set
                            pe.status = 1,
                            pe.fehler_text = 'Keine Planung (Batch) für Planauftrag '
                                             || :new.aps_plan_auftrag_nr
                                             || ' nicht gedeckt. Kundenauftrag '
                                             || v_aps_auftrag_mr.auftrag_nr
                                             || '/'
                                             || v_aps_auftrag_mr.pos_nr
                                             || '-'
                                             || v_aps_auftrag_mr.upos_nr
                                             || ' Status '
                                             || nvl(v_aps_auftrag_pos.order_info, 'Fehlt'),
                            pe.fehler_code = 99,
                            pe.transfer_status = 'N'
                        where
                                pe.aps_plan_auftrag_nr = :new.aps_plan_auftrag_nr
                            and pe.aps_plan_status in ( 'PS', 'PE' );

                    else
                        if :new.child_id = '-1'
                        or :new.materialrelation_valide = 'I' then
                            :new.materialrelation_info := 'Invalide Planung Rohstoff Lagerbestand Artikel '
                                                          || v_artikel.waren_gruppe
                                                          || ' '
                                                          || v_artikel.artikel
                                                          || ' ist nicht gedeckt. Kundenauftrag '
                                                          || v_aps_auftrag_mr.auftrag_nr
                                                          || '/'
                                                          || v_aps_auftrag_mr.pos_nr
                                                          || '-'
                                                          || v_aps_auftrag_mr.upos_nr
                                                          || ' Status '
                                                          || nvl(v_aps_auftrag_pos.order_info, 'Fehlt');

                            :new.materialrelation_valide := 'F';
                            update aps_order_materialrelation mr
                            set
                                mr.materialrelation_info = 'Invalide Planung Rohstoff Lagerbestand Artikel '
                                                           || v_artikel.waren_gruppe
                                                           || ' '
                                                           || v_artikel.artikel
                                                           || ' ist nicht gedeckt. Kundenauftrag '
                                                           || v_aps_auftrag_mr.auftrag_nr
                                                           || '/'
                                                           || v_aps_auftrag_mr.pos_nr
                                                           || '-'
                                                           || v_aps_auftrag_mr.upos_nr
                                                           || ' Status '
                                                           || nvl(v_aps_auftrag_pos.order_info, 'Fehlt'),
                                mr.materialrelation_valide = 'F'
                            where
                                    mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                                and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                                and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                                and mr.materialrelation_type = 2
                                and ( nvl(mr.materialrelation_valide, 'T') = 'T'
                                      or nvl(mr.materialrelation_valide, 'I') = 'I'
                                      or mr.materialrelation_info is null
                                      or mr.materialrelation_info = 'Planauftrag ohne Prüfung der Komponenten' );

                            update aps_plan_ergebnis pe
                            set
                                pe.status = 1,
                                pe.fehler_text = 'Invalide Planung Rohstoff Lagerbestand Artikel '
                                                 || v_artikel.waren_gruppe
                                                 || ' '
                                                 || v_artikel.artikel
                                                 || ' ist nicht gedeckt. Kundenauftrag '
                                                 || v_aps_auftrag_mr.auftrag_nr
                                                 || '/'
                                                 || v_aps_auftrag_mr.pos_nr
                                                 || '-'
                                                 || v_aps_auftrag_mr.upos_nr
                                                 || ' Status '
                                                 || nvl(v_aps_auftrag_pos.order_info, 'Fehlt'),
                                pe.fehler_code = 90,
                                pe.transfer_status = 'N'
                            where
                                    pe.aps_plan_auftrag_nr = :new.aps_plan_auftrag_nr
                                and pe.aps_plan_status in ( 'PS', 'PE' );

                        else
                            :new.materialrelation_info := 'Valide Planung Rohstoff Lagerbestand Artikel '
                                                          || v_artikel.waren_gruppe
                                                          || ' '
                                                          || v_artikel.artikel
                                                          || ' mit '
                                                          || :new.child_id
                                                          || ' gedeckt';

                            :new.materialrelation_valide := 'T';
                            if
                                nvl(:new.child_lte_id,
                                    '-1') = '-1'
                                and :new.materialrelation_type = 8
                            then
                                :new.child_lte_id := :new.child_id;
                            end if;

                            update aps_order_materialrelation mr
                            set
                                mr.materialrelation_info = 'Valide Planung Position ist mit dem Planauftrag '
                                                           || :new.aps_plan_auftrag_nr
                                                           || ' gedeckt',
                                mr.materialrelation_valide = 'T'
                            where
                                    mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                                and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                                and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                                and mr.materialrelation_type = 2
                                and nvl(mr.materialrelation_valide, 'T') = 'T';

                        end if;
                    end if;

                else
                    if :new.child_id != '-1' then
                        :new.materialrelation_info := 'Valide Planung Rohstoff Lagerbestand Artikel '
                                                      || v_artikel.waren_gruppe
                                                      || ' '
                                                      || v_artikel.artikel
                                                      || ' mit '
                                                      || :new.child_id
                                                      || ' gedeckt';

                        :new.materialrelation_valide := 'T';
                        update aps_order_materialrelation mr
                        set
                            mr.materialrelation_info = 'Valide Planung Position ist mit dem Planauftrag '
                                                       || :new.aps_plan_auftrag_nr
                                                       || ' gedeckt',
                            mr.materialrelation_valide = 'T'
                        where
                                mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                            and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                            and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                            and mr.materialrelation_type = 2
                            and nvl(mr.materialrelation_valide, 'T') = 'T';

                        update aps_plan_ergebnis pe
                        set
                            pe.status = 1,
                            pe.fehler_text = 'Valide Planung Planauftrag: '
                                             || :new.aps_plan_auftrag_nr
                                             || ' Rohstoffe: Lagerbestand ist gedeckt',
                            pe.fehler_code = 0
                        where
                                pe.aps_plan_auftrag_nr = :new.aps_plan_auftrag_nr
                            and pe.aps_plan_status in ( 'PS', 'PE' );

                    else
                        :new.materialrelation_info := 'Invalide Planung Rohstoff Lagerbestand Artikel '
                                                      || v_artikel.waren_gruppe
                                                      || ' '
                                                      || v_artikel.artikel
                                                      || ' ist nicht gedeckt';

                        :new.materialrelation_valide := 'F';
                        update aps_order_materialrelation mr
                        set
                            mr.materialrelation_info = 'Invalide Planung Planauftrag: '
                                                       || :new.aps_plan_auftrag_nr
                                                       || ' Fehler Rohstoff: Lagerbestand Artikel '
                                                       || v_artikel.waren_gruppe
                                                       || ' '
                                                       || v_artikel.artikel
                                                       || ' ist nicht gedeckt',
                            mr.materialrelation_valide = 'F'
                        where
                                mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                            and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                            and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                            and mr.materialrelation_type = 2
                            and nvl(mr.materialrelation_valide, 'T') = 'T';

                        update aps_plan_ergebnis pe
                        set
                            pe.status = 1,
                            pe.fehler_text = 'Invalide Planung Planauftrag: '
                                             || ' Fehler Rohstoff: Lagerbestand Artikel '
                                             || v_artikel.waren_gruppe
                                             || ' '
                                             || v_artikel.artikel
                                             || ' ist nicht gedeckt',
                            pe.fehler_code = 98
                        where
                                pe.aps_plan_auftrag_nr = :new.aps_plan_auftrag_nr
                            and pe.aps_plan_status in ( 'PS', 'PE' );

                    end if;
                end if;
            else
                :new.materialrelation_info := 'Valide Planung Rohstoff Lagerbestand Artikel '
                                              || v_artikel.waren_gruppe
                                              || ' '
                                              || v_artikel.artikel
                                              || ' durch FA '
                                              || v_aps_pe.leitzahl
                                              || ' reserviert und damit gedeckt';

                :new.materialrelation_valide := 'T';
                :new.materialrelation_type := 8;
                :new.child_id := 'FA_RES';
                :new.child_lte_id := 'FA_RES';
                update aps_order_materialrelation mr
                set
                    mr.materialrelation_info = 'Valide Planung Position ist mit dem Fertigungsauftrag '
                                               || v_aps_pe.leitzahl
                                               || ' gedeckt',
                    mr.materialrelation_valide = 'T'
                where
                        mr.auftrag_nr = v_aps_auftrag_mr.auftrag_nr
                    and mr.pos_nr = v_aps_auftrag_mr.pos_nr
                    and mr.upos_nr = v_aps_auftrag_mr.upos_nr
                    and mr.materialrelation_type = 2;

                update aps_plan_ergebnis pe
                set
                    pe.status = 8
                where
                        pe.aps_plan_auftrag_nr = :new.aps_plan_auftrag_nr
                    and pe.aps_plan_status in ( 'PS', 'PE' );

            end if;

        end if;

    end if;
end tr_z_dir_aps_plan_matr_bui;
/

alter trigger dirkspzm32.tr_z_dir_aps_plan_matr_bui enable;


-- sqlcl_snapshot {"hash":"5615b3aa7971035fd940b094cf72139de0268cae","type":"TRIGGER","name":"TR_Z_DIR_APS_PLAN_MATR_BUI","schemaName":"DIRKSPZM32","sxml":""}