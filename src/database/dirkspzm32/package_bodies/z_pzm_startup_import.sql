create or replace package body dirkspzm32.z_pzm_startup_import is


  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  --v_error     EXCEPTION;                 --
  --v_err_nr    number;
  --v_err_text  varchar2(255);

    procedure pzm_urlaub_flex_start_import (
        in_del_kontobuchungen in varchar2,
        in_zk_start           in date
    ) is

        v_found                   boolean;
        v_schichtmodell_day_d_std number;
        v_zk_std                  number;
        v_zk_std_laenge           number;
        v_konto_type              pzm_konten.typ%type;
        v_konto_name_kurz         pzm_konten.name_kurz%type;
        v_konto_bh_id             pzm_konten_bh.konten_bh_id%type;
        v_konto                   pzm_konten%rowtype;
        v_pzm_u_f_imp             z_pzm_pers_urlaub_flexkonto%rowtype;
        v_schichtmodell           pzm_schicht_modelle%rowtype;
        cursor c_konto is
        select
            *
        from
            pzm_konten k
        where
                k.pers_nr = v_pzm_u_f_imp.pers_nr
            and k.name_kurz = v_konto_name_kurz
            and k.typ = v_konto_type;

        cursor c_pzm_u_f_imp is
        select
            *
        from
            z_pzm_pers_urlaub_flexkonto t;

    begin
        open c_pzm_u_f_imp;
        loop
            fetch c_pzm_u_f_imp into v_pzm_u_f_imp;
            exit when c_pzm_u_f_imp%notfound;
            if pzm_p_base.get_schicht_modell(v_pzm_u_f_imp.pers_nr, v_schichtmodell) then
                v_schichtmodell_day_d_std := pzm_utils.pzm_get_sm_durch_std_tag(v_schichtmodell.sm_name);
            end if;

            if nvl(v_schichtmodell_day_d_std, 0) = 0 then
                v_schichtmodell_day_d_std := 8;
            end if;
            if in_del_kontobuchungen = 'T' then
        -- Daten gefunden, alle Konten der Personalnummer initialisieren
                update pzm_konten_bh k_bh
                set
                    k_bh.zk_aa_id = null
                where
                        k_bh.pers_nr = v_pzm_u_f_imp.pers_nr
                    and k_bh.zk_aa_id is not null
                    and k_bh.zk_start <= in_zk_start;

                delete pzm_konten_bh k_bh
                where
                        k_bh.pers_nr = v_pzm_u_f_imp.pers_nr
                    and k_bh.zk_start <= in_zk_start;

                update pzm_konten k
                set
                    k.saldo = 0,
                    k.letzte_buchung = sysdate
                where
                    k.pers_nr = v_pzm_u_f_imp.pers_nr;

                commit;
            end if;  
      -- Urlaubsstunden eintragen
            v_konto_type := 'ZK';
            v_konto_name_kurz := 'UKS';
            begin
                open c_konto;
                fetch c_konto into v_konto;
                v_found := c_konto%found;
                close c_konto;
                if v_found then
                    pzm_kontoverwaltung.zugang_buchen(v_sid.sid,
                                                      v_firma,
                                                      v_konto.konto_nr,
                                                      v_konto.pers_nr,
                                                      nvl(
                                      get_pers_kst_id(v_konto.pers_nr),
                                      0
                                  ),
                                                      v_pzm_u_f_imp.zk_urlaub_tage * v_schichtmodell_day_d_std,
                                                      'Initial ' || to_char(sysdate, 'dd.mm.yyy hh24:mi:ss'),
                                                      'K',
                                                      nvl(
                                      get_pers_abt_id(v_konto.pers_nr),
                                      0
                                  ),
                                                      v_konto_bh_id);

                    update pzm_konten_bh t
                    set
                        t.zk_start = in_zk_start
                    where
                            t.sid = v_sid.sid
                        and t.firma_nr = v_firma
                        and t.konten_bh_id = v_konto_bh_id;

                end if;

        -- zeitkonto initial füllen
                v_konto_type := 'ZK';
                v_konto_name_kurz := 'ZK';
                open c_konto;
                fetch c_konto into v_konto;
                v_found := c_konto%found;
                close c_konto;
                if v_found then
                    v_zk_std_laenge := length(v_pzm_u_f_imp.zk_flex_std);
          --v_zk_std := to_number(substr(v_pzm_u_f_imp.zk_flex_std, v_zk_std_laenge - 3)) / 100;
          --v_zk_std := v_zk_std + to_number(substr(v_pzm_u_f_imp.zk_flex_std, 1, v_zk_std_laenge -3));
                    v_zk_std := to_number ( v_pzm_u_f_imp.zk_flex_std );
                    pzm_kontoverwaltung.zugang_buchen(v_sid.sid,
                                                      v_firma,
                                                      v_konto.konto_nr,
                                                      v_konto.pers_nr,
                                                      nvl(
                                      get_pers_kst_id(v_konto.pers_nr),
                                      0
                                  ),
                                                      v_zk_std,
                                                      'Initial ' || to_char(sysdate, 'dd.mm.yyy hh24:mi:ss'),
                                                      'K',
                                                      nvl(
                                      get_pers_abt_id(v_konto.pers_nr),
                                      0
                                  ),
                                                      v_konto_bh_id);

                    update pzm_konten_bh t
                    set
                        t.zk_start = in_zk_start
                    where
                            t.sid = v_sid.sid
                        and t.firma_nr = v_firma
                        and t.konten_bh_id = v_konto_bh_id;

                end if;

                commit;
            exception
                when others then
                    dbms_output.put_line('Fehler bei der Übernahme von pers_nr '
                                         || to_char(v_pzm_u_f_imp.pers_nr)
                                         || ' - ' || v_pzm_u_f_imp.pers_name);
            end;

        end loop;

        close c_pzm_u_f_imp;
    end;

    procedure pzm_stempelzeiten_import is

        v_stempel_zeiten z_pzm_pers_stempelzeiten%rowtype;
        v_pers_nr        pzm_personal.pers_nr%type;
        v_pers_nrn       varchar2(4096);
        v_personal       pzm_personal%rowtype;
        v_res_info       varchar2(255);
        v_result         number;
        v_start_date     date;
        v_ende_date      date;
        v_aa_id          number;
        v_tage           number;
        cursor c_z_stempel_pers_nr is
        select
            stradd_distinct(t.pers_nr) pers_nr
        from
            z_pzm_pers_stempelzeiten t;

        cursor c_z_stempel_zeiten_abw is
        select
            *
        from
            z_pzm_pers_stempelzeiten t
        where
            t.gt_ut is not null
            and t.gt_ut != '0'
        order by
            t.pers_nr,
            t.kommt;

        cursor c_z_stempel_zeiten is
        select
            *
        from
            z_pzm_pers_stempelzeiten t
        where
            nvl(t.gt_ut, '0') = '0'
        order by
            t.pers_nr,
            t.kommt;

    begin
        open c_z_stempel_pers_nr;
        fetch c_z_stempel_pers_nr into v_pers_nrn;
        close c_z_stempel_pers_nr;
        delete pzm_zeiterfassung t
        where
            ';'
            || v_pers_nrn
            || ';' like '%;'
                        || t.ze_pers_nr
                        || ';%';

        delete pzm_ze_tagessatz t
        where
            ';'
            || v_pers_nrn
            || ';' like '%;'
                        || t.ts_pers_nr
                        || ';%';

        update pzm_ze_loa_ausw t
        set
            t.aa_id = null
        where
            t.aa_id is not null
            and ';'
                || v_pers_nrn
                || ';' like '%;'
                            || t.zeaw_pers_nr
                            || ';%';

        delete pzm_ze_loa_ausw t
        where
            ';' || v_pers_nrn like '%;'
                                   || t.zeaw_pers_nr
                                   || ';%';

        delete pzm_abwesenheits_antr t
        where
                t.au_status = 0
            and ';'
                || v_pers_nrn
                || ';' like '%;'
                            || t.au_pers_nr
                            || ';%';

        update pzm_abwesenheits_antr t
        set
            t.au_status = 0
        where
            ';'
            || v_pers_nrn
            || ';' like '%;'
                        || t.au_pers_nr
                        || ';%';

        delete pzm_abwesenheits_antr t
        where
            ';'
            || v_pers_nrn
            || ';' like '%;'
                        || t.au_pers_nr
                        || ';%';

        delete pzm_abwesenheitsmeldungen t
        where
            ';'
            || v_pers_nrn
            || ';' like '%;'
                        || t.pers_nr
                        || ';%';

        commit;
        v_pers_nr := 0; -- INIT

        open c_z_stempel_zeiten_abw;
        loop
            fetch c_z_stempel_zeiten_abw into v_stempel_zeiten;
            exit when c_z_stempel_zeiten_abw%notfound;
            if pzm_p_base.get_personal(v_stempel_zeiten.pers_nr, v_personal) then
        /*
        if v_pers_nr != v_stempel_zeiten.pers_nr -- Neuer Pers_nr dann Urlaube löschen
        then
          update pzm_abwesenheits_antr t
             set t.au_status = 0
           where t.au_pers_nr = v_stempel_zeiten.pers_nr;
          delete pzm_abwesenheits_antr t
           where t.au_pers_nr = v_stempel_zeiten.pers_nr;
          delete pzm_abwesenheitsmeldungen t
           where t.pers_nr = v_stempel_zeiten.pers_nr;
          v_pers_nr := v_stempel_zeiten.pers_nr;
        end if;
        */
                v_aa_id := 0;
                if v_stempel_zeiten.gt_ut in ( 'UT', 'GT', 'UH', '310' ) then
                    v_aa_id := 39;
                elsif v_stempel_zeiten.gt_ut in ( 'FU', 'SUR' ) then
                    v_aa_id := 22;
                elsif v_stempel_zeiten.gt_ut in ( 'KKR' ) then
                    v_aa_id := 6;
                elsif v_stempel_zeiten.gt_ut in ( 'KPDL' ) then
                    v_aa_id := 63;
                elsif v_stempel_zeiten.gt_ut in ( '362' ) then
                    v_aa_id := 49;
                elsif v_stempel_zeiten.gt_ut in ( '361' ) then
                    v_aa_id := 24;
                elsif v_stempel_zeiten.gt_ut in ( '364' ) then
                    v_aa_id := 13;
                elsif v_stempel_zeiten.gt_ut in ( 'UU' ) then
                    v_aa_id := 23;
                elsif v_stempel_zeiten.gt_ut in ( 'KeAU' ) then
                    v_aa_id := 40;
                elsif v_stempel_zeiten.gt_ut in ( 'KB' ) then
                    v_aa_id := 35;
                elsif v_stempel_zeiten.gt_ut in ( 'KO', 'KL' ) then
                    v_aa_id := 5;
                elsif v_stempel_zeiten.gt_ut in ( 'KM', 'KL', 'KPDL' ) then
                    v_aa_id := 2;
                end if;

                v_tage := 1;
                if v_stempel_zeiten.gt_ut = 'UH' then
                    v_tage := 0.5;
                end if;
                if v_aa_id > 0 then
                    insert into pzm_abwesenheitsmeldungen (
                        pers_nr,
                        beginn,
                        ende,
                        aa_id,
                        sa_kurzname,
                        vorerkrankung,
                        anz_tage,
                        gesamt_anz_tage
                    ) values ( v_stempel_zeiten.pers_nr,
                               trunc(to_date(v_stempel_zeiten.kommt, 'dd.mm.yyyy hh24:mi')),
                               trunc(to_date(v_stempel_zeiten.kommt, 'dd.mm.yyyy hh24:mi')),
                               v_aa_id,
                               null,
                               null,
                               v_tage,
                               v_tage );

                    commit;
                end if;

            end if;

        end loop;

        close c_z_stempel_zeiten_abw;
        v_pers_nr := 0; -- INIT
        v_ende_date := null;
        open c_z_stempel_zeiten;
        loop
            fetch c_z_stempel_zeiten into v_stempel_zeiten;
            exit when c_z_stempel_zeiten%notfound;
            if pzm_p_base.get_personal(v_stempel_zeiten.pers_nr, v_personal) then
                if v_pers_nr != v_stempel_zeiten.pers_nr -- Neuer Pers_nr dann Urlaube löschen
                 then
          --delete pzm_zeiterfassung t
          -- where t.ze_pers_nr = v_stempel_zeiten.pers_nr;
          --delete pzm_ze_tagessatz t
          -- where t.ts_pers_nr = v_stempel_zeiten.pers_nr;
          --update pzm_ze_loa_ausw t
          --   set t.aa_id = NULL
          -- where t.zeaw_pers_nr = v_stempel_zeiten.pers_nr
          --   and t.aa_id is not NULL;
          --delete pzm_ze_loa_ausw t
          -- where t.zeaw_pers_nr = v_stempel_zeiten.pers_nr;

                    if v_ende_date is not null then
            -- Call the procedure
                        loop
              -- Call the procedure
                            update_pers_ze_tag(v_pers_nr, v_start_date,
                                               p_result   => v_result,
                                               p_res_info => v_res_info,
                                               p_zaehler  => 0);

                            commit;
                            v_start_date := v_start_date + 1;
                            exit when v_start_date > v_ende_date;
                        end loop;
                    end if;

                    v_start_date := trunc(to_date(v_stempel_zeiten.kommt, 'dd.mm.yyyy hh24:mi'));
                    v_ende_date := null;
                    v_pers_nr := v_stempel_zeiten.pers_nr;
                end if;
        -- jetzt die Stempelzeit buchen
                if to_date ( v_stempel_zeiten.geht,
                'dd.mm.yyyy hh24:mi' ) - to_date ( v_stempel_zeiten.kommt,
                'dd.mm.yyyy hh24:mi' ) > 0 then
                    update_personal_ze_status_date(
                        p_pers_nr         => v_stempel_zeiten.pers_nr,
                        p_status          => 2,
                        p_buch_datum_zeit => to_date(v_stempel_zeiten.kommt, 'dd.mm.yyyy hh24:mi'),
                        p_start_ende_flag => 1,
                        p_kst_id          => null,
                        p_aa_status       => null,
                        p_vorgaenger_link => null,
                        p_abt_id          => null,
                        p_result          => v_result,
                        p_res_info        => v_res_info
                    );

                    update_personal_ze_status_date(
                        p_pers_nr         => v_stempel_zeiten.pers_nr,
                        p_status          => 2,
                        p_buch_datum_zeit => to_date(v_stempel_zeiten.geht, 'dd.mm.yyyy hh24:mi'),
                        p_start_ende_flag => 2,
                        p_kst_id          => null,
                        p_aa_status       => null,
                        p_vorgaenger_link => null,
                        p_abt_id          => null,
                        p_result          => v_result,
                        p_res_info        => v_res_info
                    );
/*
        else
          update_pers_ze_tag(v_stempel_zeiten.pers_nr,
                             trunc(to_date(v_stempel_zeiten.kommt, 'dd.mm.yyyy hh24:mi')),
                             p_result => v_result,
                             p_res_info => v_res_info,
                             p_zaehler => 0);
*/
                end if;

                v_ende_date := trunc(to_date(v_stempel_zeiten.kommt, 'dd.mm.yyyy hh24:mi'));
                commit;
            end if;

        end loop;

        close c_z_stempel_zeiten;
        if v_ende_date is not null then
      --delete pzm_zeiterfassung t
      -- where t.ze_pers_nr = v_stempel_zeiten.pers_nr;
      --delete pzm_ze_tagessatz t
      -- where t.ts_pers_nr = v_stempel_zeiten.pers_nr;
      --update pzm_ze_loa_ausw t
      --   set t.aa_id = NULL
      -- where t.zeaw_pers_nr = v_stempel_zeiten.pers_nr
      --   and t.aa_id is not NULL;
      --delete pzm_ze_loa_ausw t
      -- where t.zeaw_pers_nr = v_stempel_zeiten.pers_nr;
      -- Call the procedure
            loop
        -- Call the procedure
                update_pers_ze_tag(v_pers_nr, v_start_date,
                                   p_result   => v_result,
                                   p_res_info => v_res_info,
                                   p_zaehler  => 0);

                commit;
                v_start_date := v_start_date + 1;
                exit when v_start_date > v_ende_date;
            end loop;
        end if;

    end;

    procedure pzm_update_pers_nr is
        v_found       boolean;
        v_pzm_pers_nr z_pzm_pers_nr_alt_neu%rowtype;
        cursor c_pzm_pers_nr is
        select
            t.*
        from
            z_pzm_pers_nr_alt_neu t;

    begin
        isi_disable;
        open c_pzm_pers_nr;
        loop
            fetch c_pzm_pers_nr into v_pzm_pers_nr;
            exit when c_pzm_pers_nr%notfound;
            update pzm_personal t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update bde_pd_kopf t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update bde_pd_kopf_ma t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update bde_pd_pers_zeit_kst t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update bde_pd_prod t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update bde_pd_rueckverfolgung t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update isi_contact t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update isi_resource_zust_akt t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update isi_scan_log t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update isi_user t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_abt_leitung t
            set
                t.abt_l_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.abt_l_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_abwesenheits_antr t
            set
                t.au_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.au_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_abwesenheits_antr t
            set
                t.au_pruef_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.au_pruef_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_abwesenheitsmeldungen t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_abwes_plan t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_azubi_daten t
            set
                t.ad_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.ad_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_konten t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_konten_bh t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_pers_lohn_zulagen t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_bde_zeiten t
            set
                t.ze_bde_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.ze_bde_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_zeiterfassung t
            set
                t.ze_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.ze_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_zeiterfassung t
            set
                t.ze_korr_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.ze_korr_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_loa_13w_schnitt t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_loa_ausw t
            set
                t.zeaw_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.zeaw_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_loa_ausw t
            set
                t.zeaw_korr_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.zeaw_korr_pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_loa_exp_host t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_pers_kst_monat_ab t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

            update pzm_ze_tagessatz t
            set
                t.ts_pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.ts_pers_nr = v_pzm_pers_nr.pers_nr;

            update z_pzm_pers_nr_transponder t
            set
                t.pers_nr = v_pzm_pers_nr.pers_nr_neu
            where
                t.pers_nr = v_pzm_pers_nr.pers_nr;

        end loop;

        close c_pzm_pers_nr;
        isi_enable;
    end;

    procedure pzm_update_pers_nr_transponder is
        v_found                    boolean;
        v_pzm_pers_nr_transpponder z_pzm_pers_nr_transponder%rowtype;
        cursor c_pzm_pers_nr_transponder is
        select
            t.*
        from
            z_pzm_pers_nr_transponder t;

    begin
        open c_pzm_pers_nr_transponder;
        loop
            fetch c_pzm_pers_nr_transponder into v_pzm_pers_nr_transpponder;
            exit when c_pzm_pers_nr_transponder%notfound;
            update isi_user t
            set
                t.transponder = lpad(v_pzm_pers_nr_transpponder.pers_transponder, 6, '00')
            where
                t.pers_nr = v_pzm_pers_nr_transpponder.pers_nr;

        end loop;

        close c_pzm_pers_nr_transponder;
    end;

begin
    open c_sid;
    fetch c_sid into v_sid;
    v_sid_found := c_sid%found;
    close c_sid;
    v_firma := 1;
    if not v_sid_found then
        v_sid.sid := '01';
    end if;
end z_pzm_startup_import;
/


-- sqlcl_snapshot {"hash":"85ca6698489ce55c5739bc8b2409de6152f0fa15","type":"PACKAGE_BODY","name":"Z_PZM_STARTUP_IMPORT","schemaName":"DIRKSPZM32","sxml":""}