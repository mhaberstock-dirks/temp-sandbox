create or replace procedure dirkspzm32.isi_visu_default_generate (
    in_lgr_ort in lvs_lgr_ort.lgr_ort%type default null,
    out_info   out varchar2
) is
  -- MWe 20181018
  -- Diese Procedure generiert ent weder für den gewählten Lagerort die Lagervisualisierung
  -- oder wenn null dann einfach für alle

    v_visu_elm isi_visu_elem%rowtype;
    v_visu_gru isi_visu_elem%rowtype;
    v_visu_pla isi_visu_elem%rowtype;

-- Cursor über die Lagerorte
    cursor c_lgr_ort is
    select
        to_char(ort.lgr_ort),
        '01',
        1,
        'LGR_ORT',
        null,
        null,
        concat('V_',
               to_char(ort.lgr_ort)),
        case mod(rownum, 5)
            when 1 then
                1100
            when 2 then
                2200
            when 3 then
                3300
            when 4 then
                4400
            when 0 then
                5500
        end,
        ( trunc((rownum - 1) / 5, 0) + 1 ) * - 1100,
        1000,
        1000,
        'F',
        null,
        'LVS',
        1,
        null,
        'F'
    from
        (
            select
                to_char(ort.lgr_ort) lgr_ort
            from
                lvs_lgr_ort ort,
                lvs_lgr     lgr
            where
                to_char(ort.lgr_ort) not in (
                    select
                        v.name
                    from
                        isi_visu_elem v
                    where
                        v.gruppe = 'LGR_ORT'
                )
                and ort.lgr_ort = lgr.lgr_ort
                and ort.lgr_ort = 600
            group by
                ort.lgr_ort
            order by
                ort.lgr_ort
        ) ort;

  -- CURSOR Lagergruppen
    cursor c_lgr_gru is
    select
        to_char(ort.lgr_ort),
        '01',
        1,
        'LGR_GRUPPE',
        null,
        null,
        concat('V_',
               to_char(ort.lgr_ort)),
        case mod(rownum, 9)
            when 0 then
                1100 * 9
            else
                mod(rownum, 9) * 1100
        end,
        ( trunc((rownum - 1) / 9, 0) + 1 ) * - 1100,
        1000,
        1000,
        'F',
        null,
        'LVS',
        1,
        null,
        'F'
    from
        (
            select
                to_char(lgr.lgr_platz) lgr_ort
            from
                lvs_lgr_ort ort,
                lvs_lgr     lgr
            where
                lgr.lgr_platz not in (
                    select
                        v.name
                    from
                        isi_visu_elem v
                    where
                        v.gruppe = 'LGR_GRUPPE'
                )
                and ort.lgr_ort = lgr.lgr_ort
                and ort.lgr_ort = v_visu_elm.name
            group by
                lgr.lgr_platz
            order by
                lgr.lgr_platz
        ) ort;

  -- Curosr Lagerplätze
    cursor c_lgr_pla is
    select
        to_char(ort.lgr_ort),
        '01',
        1,
        'LGR',
        null,
        null,
        concat('V_',
               to_char(ort.lgr_ort)),
        ( trunc((rownum - 1) / 6, 0) + 1 ) * 1100,
        case mod(rownum, 3)
            when 1 then
                3300
            when 2 then
                2200
            when 0 then
                1100
        end,
        1000,
        1000,
        'F',
        null,
        'LVS',
        1,
        null,
        'F'
    from
        (
            select
                to_char(lgr.lgr_platz_gruppe) lgr_ort
            from
                lvs_lgr_ort ort,
                lvs_lgr     lgr
            where
                lgr.lgr_platz_gruppe not in (
                    select
                        v.name
                    from
                        isi_visu_elem v
                    where
                        v.gruppe = 'LGR'
                )
                and ort.lgr_ort = lgr.lgr_ort
                and lgr.lgr_platz_gruppe = v_visu_gru.name
            group by
                lgr.lgr_platz_gruppe
            order by
                lgr.lgr_platz_gruppe
        ) ort;

begin

  -- Löschen der Orte bevor Sie neu angelegt werden
    delete from isi_visu_elem t
    where
        t.gruppe = 'LGR_ORT';

    delete from isi_visu_elem t
    where
        t.gruppe = 'LGR_GRUPPE';

    delete from isi_visu_elem t
    where
        t.gruppe = 'LGR';

    open c_lgr_ort;
    loop
        fetch c_lgr_ort into v_visu_elm;
        exit when c_lgr_ort%notfound;
        insert into isi_visu_elem values ( v_visu_elm.name,
                                           v_visu_elm.sid,
                                           v_visu_elm.firma_nr,
                                           v_visu_elm.gruppe,
                                           v_visu_elm.bereich,
                                           v_visu_elm.typ,
                                           v_visu_elm.visu_element,
                                           v_visu_elm.pos_x,
                                           v_visu_elm.pos_y,
                                           v_visu_elm.element_breite,
                                           v_visu_elm.element_hoehe,
                                           v_visu_elm.animiert,
                                           v_visu_elm.resourcen_id,
                                           v_visu_elm.modul,
                                           v_visu_elm.layer,
                                           v_visu_elm.params,
                                           v_visu_elm.designlock );

        open c_lgr_gru;
        loop
            fetch c_lgr_gru into v_visu_gru;
            exit when c_lgr_gru%notfound;
            insert into isi_visu_elem values ( v_visu_gru.name,
                                               v_visu_gru.sid,
                                               v_visu_gru.firma_nr,
                                               v_visu_gru.gruppe,
                                               v_visu_gru.bereich,
                                               v_visu_gru.typ,
                                               v_visu_gru.visu_element,
                                               v_visu_gru.pos_x,
                                               v_visu_gru.pos_y,
                                               v_visu_gru.element_breite,
                                               v_visu_gru.element_hoehe,
                                               v_visu_gru.animiert,
                                               v_visu_gru.resourcen_id,
                                               v_visu_gru.modul,
                                               v_visu_gru.layer,
                                               v_visu_gru.params,
                                               v_visu_gru.designlock );

            open c_lgr_pla;
            loop
                fetch c_lgr_pla into v_visu_pla;
                exit when c_lgr_pla%notfound;
                insert into isi_visu_elem values ( v_visu_pla.name,
                                                   v_visu_pla.sid,
                                                   v_visu_pla.firma_nr,
                                                   v_visu_pla.gruppe,
                                                   v_visu_pla.bereich,
                                                   v_visu_pla.typ,
                                                   v_visu_pla.visu_element,
                                                   v_visu_pla.pos_x,
                                                   v_visu_pla.pos_y,
                                                   v_visu_pla.element_breite,
                                                   v_visu_pla.element_hoehe,
                                                   v_visu_pla.animiert,
                                                   v_visu_pla.resourcen_id,
                                                   v_visu_pla.modul,
                                                   v_visu_pla.layer,
                                                   v_visu_pla.params,
                                                   v_visu_pla.designlock );

            end loop;

            close c_lgr_pla;
        end loop;

        close c_lgr_gru;
    end loop;

    close c_lgr_ort;
    commit;
end isi_visu_default_generate;
/


-- sqlcl_snapshot {"hash":"6aa63de80ae90ae3d59b80131ea12839df0922d9","type":"PROCEDURE","name":"ISI_VISU_DEFAULT_GENERATE","schemaName":"DIRKSPZM32","sxml":""}