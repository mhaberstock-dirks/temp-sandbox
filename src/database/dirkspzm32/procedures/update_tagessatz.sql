create or replace procedure dirkspzm32.update_tagessatz (
    p_pers_nr           in number,
    p_datum             in date,
    p_day_begin         in date,
    p_day_end           in date,
    p_day_calc_begin    in date,
    p_day_calc_end      in date,
    p_sa_kurzname       in varchar2,
    p_aa_id             in number,
    p_day_abw_std       in number,
    p_day_arb_std       in number,
    p_day_ueb_std       in number,
    p_day_flex_std      in number,
    p_day_anw_std       in number,
    p_day_pause_std     in number,
    p_day_arb_std_g_min in number,
    p_day_pause_bez_std in number
) is

    cursor c_tagessatz is
    select
        t.*
    from
        pzm_ze_tagessatz t
    where
            t.ts_pers_nr = p_pers_nr
        and t.ts_datum = trunc(p_datum)
    for update of t.ts_day_ist_start,
                  t.ts_day_ist_ende,
                  t.ts_day_wert_start,
                  t.ts_day_wert_ende,
                  t.ts_aa_id,
                  t.ts_day_kst_id,
                  t.ts_day_abt_id,
                  t.ts_abwesenheit,
                  t.ts_sa_kurzname,
                  t.ts_day_arb_std,
                  t.ts_day_ueb_std,
                  t.ts_day_abw_std,
                  t.ts_day_flex_std,
                  t.ts_ueb_ok_datum;

    v_pb_id                    number;
    v_abt_id                   number;
    v_kst_id                   number;
    v_isi_pzm_ze_tagessatz     pzm_ze_tagessatz%rowtype;
    v_auto_ueb_std_genehmigung boolean;
begin
    v_auto_ueb_std_genehmigung := nvl(
        pzm_p_base.get_allg_parameter_mandant(p_pers_nr, 'AUTO_UEBERSTD_GENEHMIGUNG'),
        'F'
    ) != 'F';

    open c_tagessatz;
    fetch c_tagessatz into v_isi_pzm_ze_tagessatz;
    if c_tagessatz%found then
        v_kst_id := nvl(v_isi_pzm_ze_tagessatz.ts_day_kst_id,
                        get_pers_kst_id(p_pers_nr));
        v_abt_id := nvl(v_isi_pzm_ze_tagessatz.ts_day_abt_id,
                        get_pers_abt_id(p_pers_nr));
        v_pb_id := nvl(v_isi_pzm_ze_tagessatz.ts_day_pb_id,
                       get_pers_pb_id(p_pers_nr));
        if v_isi_pzm_ze_tagessatz.ts_abschluss is null then
            if
                v_auto_ueb_std_genehmigung
                and v_isi_pzm_ze_tagessatz.ts_ueb_ok_datum is not null
                and v_isi_pzm_ze_tagessatz.ts_ueb_ok_pers_nr is null
            then
        -- dies ist eine automatische genehmigung, die kann auch automatisch korrigiert werden.
        -- f?r die korrekte Buchung muss die alte genehmigung erst storniert werden.
                update pzm_ze_tagessatz t
                set
                    t.ts_ueb_ok_datum = null
                where
                    current of c_tagessatz;

            end if;

            update pzm_ze_tagessatz t
            set
                t.ts_day_ist_start = p_day_begin,
                t.ts_day_ist_ende = p_day_end,
                t.ts_day_wert_start = p_day_calc_begin,
                t.ts_day_wert_ende = p_day_calc_end,
                t.ts_aa_id = p_aa_id,
                t.ts_day_kst_id = v_kst_id,
                t.ts_day_abt_id = v_abt_id,
                t.ts_abwesenheit = decode(p_day_abw_std, 0, 0, 1),
                t.ts_sa_kurzname = p_sa_kurzname,
                t.ts_day_arb_std = p_day_arb_std,
                t.ts_day_ueb_std = p_day_ueb_std,
                t.ts_day_abw_std = p_day_abw_std,
                t.ts_day_flex_std = p_day_flex_std,
                t.ts_day_anw_std = p_day_anw_std,
                t.ts_day_pause_std = p_day_pause_std,
                t.ts_day_arb_std_g_min = p_day_arb_std_g_min,
                t.ts_day_pause_bez_std = p_day_pause_bez_std
            where
                current of c_tagessatz;

            if
                v_auto_ueb_std_genehmigung
                and ( p_day_ueb_std > 0
                or p_day_flex_std > 0 )
            then
        -- ?berstunden automatisch genehmigen
                update pzm_ze_tagessatz t
                set
                    t.ts_ueb_ok_datum = sysdate
                where
                    current of c_tagessatz;

            end if;

        else
            update pzm_ze_tagessatz t
            set
                t.ts_day_ist_start = p_day_begin,
                t.ts_day_ist_ende = p_day_end,
                t.ts_day_wert_start = p_day_calc_begin,
                t.ts_day_wert_ende = p_day_calc_end,
                t.ts_aa_id = p_aa_id,
                t.ts_day_kst_id = v_kst_id,
                t.ts_day_abt_id = v_abt_id,
                t.ts_abwesenheit = decode(p_day_abw_std, 0, 0, 1),
                t.ts_sa_kurzname = p_sa_kurzname,
                t.ts_day_arb_std = p_day_arb_std,
                t.ts_day_ueb_std = p_day_ueb_std,
                t.ts_day_abw_std = p_day_abw_std,
                t.ts_day_flex_std = p_day_flex_std,
                t.ts_day_anw_std = p_day_anw_std,
                t.ts_day_pause_std = p_day_pause_std,
                t.ts_day_arb_std_g_min = p_day_arb_std_g_min,
                t.ts_day_pause_bez_std = p_day_pause_bez_std
            where
                current of c_tagessatz;

        end if;

    else
        v_pb_id := get_pers_pb_id(p_pers_nr);
        v_abt_id := get_pers_abt_id(p_pers_nr);
        v_kst_id := get_pers_kst_id(p_pers_nr);
        insert into pzm_ze_tagessatz values ( p_pers_nr,
                                              p_datum,
                                              p_day_begin,
                                              p_day_end,
                                              p_day_calc_begin,
                                              p_day_calc_end,
                                              p_sa_kurzname,
                                              p_aa_id,
                                              v_kst_id,
                                              decode(p_day_abw_std, 0, 0, 1),
                                              p_day_abw_std,
                                              p_day_arb_std,
                                              p_day_ueb_std,
                                              null, -- ts_day_korr_std
                                              null, -- ts_ueb_ok_pers_nr
                                              null, -- ts_ueb_ok_datum
                                              null, -- ts_ueb_storno_pers_nr
                                              null, -- ts_ueb_storno_datum
                                              null, -- ts_abschluss (pers_nr)
                                              null, -- ts_verbucht_datum
                                              p_day_flex_std,
                                              p_day_anw_std,
                                              p_day_pause_std,
                                              p_day_arb_std_g_min,
                                              p_day_pause_bez_std,
                                              v_abt_id,
                                              v_pb_id,
                                              sysdate,
                                              current_isi_user_login_id(),
                                              null,
                                              null );

        if
            v_auto_ueb_std_genehmigung
            and ( p_day_ueb_std > 0
            or p_day_flex_std > 0 )
        then
            update pzm_ze_tagessatz t
            set
                t.ts_ueb_ok_datum = sysdate
            where
                    t.ts_pers_nr = p_pers_nr
                and t.ts_datum = trunc(p_datum);

        end if;

    end if;

  -- Hotfix 2026-02-04 -wkr-: in der Zeiterfassung soll die Kostenstelle NICHT aktualisiert werden!
  -- NULL-Werte kommen hier nicht mehr vor, daher muessen nicht alle ZE-Saetze aktualisiert werden.
  -- Die bereits beim INSERT erfassten Kostenstellen mussen erhalten bleiben.

  -- update pzm_zeiterfassung t
  --    set t.ze_kst_id = v_kst_id,
  --        t.ze_abt_id = v_abt_id,
  --        t.ze_pb_id = v_pb_id
  --  where t.ze_pers_nr = p_pers_nr
  --    and t.ze_schicht_tag = trunc(p_datum);

    close c_tagessatz;
end update_tagessatz;
/


-- sqlcl_snapshot {"hash":"e281899ed453935403153fb2dafe96c3cbaf24a0","type":"PROCEDURE","name":"UPDATE_TAGESSATZ","schemaName":"DIRKSPZM32","sxml":""}