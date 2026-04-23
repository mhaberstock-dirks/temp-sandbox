create or replace procedure dirkspzm32.c_pps_opt_grp_insert is

    v_found              boolean;
    v_auftr_pos          s_rcv_kunden_auftr_pos%rowtype;
    v_opt_grp_lam_sel1   pps_ruestmatrix_opt_grp%rowtype;
    v_opt_grp_lam_sel3   pps_ruestmatrix_opt_grp%rowtype;
    v_opt_grp_von        pps_ruestmatrix_opt_grp.opt_grp%type;
    v_opt_grp_nach       pps_ruestmatrix_opt_grp.opt_grp%type;
    v_ruestmatrixelement pps_ruestmatrixelement%rowtype;
    v_ruestmatrix        pps_ruestmatrix%rowtype;
    cursor c_auftr_pos is
    select
        s.*
    from
        s_rcv_kunden_auftr_pos s
    where
        s.lam_sel1 is not null
        or s.lam_sel3 is not null;

    cursor c_opt_grp_lam_sel1 is
    select
        *
    from
        pps_ruestmatrix_opt_grp p
    where
        p.opt_grp = v_auftr_pos.lam_sel1;

    cursor c_opt_grp_lam_sel3 is
    select
        *
    from
        pps_ruestmatrix_opt_grp p
    where
        p.opt_grp = v_auftr_pos.lam_sel3;

    cursor c_opt_grp_von is
    select distinct
        ( p.opt_grp )
    from
        pps_ruestmatrix_opt_grp p
    where
        p.opt_name = 'Rezepte';

    cursor c_opt_grp_nach is
    select distinct
        ( p.opt_grp )
    from
        pps_ruestmatrix_opt_grp p
    where
        p.opt_name = 'Rezepte';

    cursor c_ruestmatrixelement is
    select
        *
    from
        pps_ruestmatrixelement p
    where
            p.rm_name = 'Rezepte'
        and p.von_opt_grp = v_opt_grp_von
        and p.nach_opt_grp = v_opt_grp_nach;

    cursor c_ruestmatrix is
    select
        *
    from
        pps_ruestmatrix p
    where
        p.rm_name = 'Rezepte';

begin
    delete pps_ruestmatrix t
    where
        t.rm_name = 'Rezepte';

    open c_ruestmatrix;
    fetch c_ruestmatrix into v_ruestmatrix;
    v_found := c_ruestmatrix%found;
    close c_ruestmatrix;
    if not v_found then
        insert into pps_ruestmatrix values ( '01',
                                             1,
                                             'Rezepte',
                                             sysdate,
                                             - 1,
                                             null,
                                             null,
                                             null,
                                             null );

    end if;

    delete pps_ruestmatrix_opt_grp t
    where
        t.opt_name = 'Rezepte';

    open c_auftr_pos;
    loop
        fetch c_auftr_pos into v_auftr_pos;
        exit when c_auftr_pos%notfound;
        open c_opt_grp_lam_sel1;
        fetch c_opt_grp_lam_sel1 into v_opt_grp_lam_sel1;
        v_found := c_opt_grp_lam_sel1%found;
        close c_opt_grp_lam_sel1;
        if
            not v_found
            and v_auftr_pos.lam_sel1 is not null
        then
            insert into pps_ruestmatrix_opt_grp values ( '01',
                                                         1,
                                                         v_auftr_pos.lam_sel1,
                                                         'Rezepte',
                                                         sysdate,
                                                         - 1,
                                                         null,
                                                         null,
                                                         null,
                                                         0 );

        end if;

        open c_opt_grp_lam_sel3;
        fetch c_opt_grp_lam_sel3 into v_opt_grp_lam_sel3;
        v_found := c_opt_grp_lam_sel3%found;
        close c_opt_grp_lam_sel3;
        if
            not v_found
            and v_auftr_pos.lam_sel3 is not null
        then
            insert into pps_ruestmatrix_opt_grp values ( '01',
                                                         1,
                                                         v_auftr_pos.lam_sel3,
                                                         'Rezepte',
                                                         sysdate,
                                                         - 1,
                                                         null,
                                                         null,
                                                         null,
                                                         0 );

        end if;

        commit;
    end loop;

    close c_auftr_pos;
    delete pps_ruestmatrixelement t
    where
        t.rm_name = 'Rezepte';

    open c_opt_grp_von;
    loop
        fetch c_opt_grp_von into v_opt_grp_von;
        exit when c_opt_grp_von%notfound;
        open c_opt_grp_nach;
        loop
            fetch c_opt_grp_nach into v_opt_grp_nach;
            exit when c_opt_grp_nach%notfound;
            if v_opt_grp_von != v_opt_grp_nach then
                open c_ruestmatrixelement;
                fetch c_ruestmatrixelement into v_ruestmatrixelement;
                v_found := c_ruestmatrixelement%found;
                close c_ruestmatrixelement;
                if not v_found then
                    insert into pps_ruestmatrixelement values ( '01',
                                                                1,
                                                                'Rezepte',
                                                                sysdate,
                                                                - 1,
                                                                null,
                                                                null,
                                                                v_opt_grp_von,
                                                                v_opt_grp_nach,
                                                                40 * 60,          -- Zeit in Sekunden (40 Minuten)
                                                                0 );

                end if;

            end if;

        end loop;

        close c_opt_grp_nach;
    end loop;

    close c_opt_grp_von;
    commit;
end c_pps_opt_grp_insert;
/


-- sqlcl_snapshot {"hash":"8d314ac8b1284887fc31f071dbcbb592567e3278","type":"PROCEDURE","name":"C_PPS_OPT_GRP_INSERT","schemaName":"DIRKSPZM32","sxml":""}