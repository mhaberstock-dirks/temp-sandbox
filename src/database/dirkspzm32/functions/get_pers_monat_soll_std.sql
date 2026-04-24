create or replace function dirkspzm32.get_pers_monat_soll_std (
    in_pers_nr in pzm_personal.pers_nr%type,
    in_kst_id  in pzm_ze_tagessatz.ts_day_kst_id%type,
    in_datum   in date
) return number is

    v_start_datum date;
    v_ende_datum  date;
    v_unb_std     number;
    cursor c_soll_std is
    select
        sum(t.ts_day_abw_std + t.ts_day_arb_std) soll
    from
        pzm_ze_tagessatz t
    where
            t.ts_pers_nr = in_pers_nr
        and t.ts_datum >= v_start_datum
        and t.ts_datum <= v_ende_datum
        and t.ts_day_kst_id = nvl(in_kst_id, t.ts_day_kst_id)
        and ( isi_utils.iso_weekday(t.ts_datum) not in ( 7 )
              or isi_utils.iso_weekday(t.ts_day_ist_ende) = 1 ); -- keinen Sontag außer Nachtschicht in den Montag
    cursor c_unb_std is
    select
        sum(t.ts_day_abw_std) unb
    from
        pzm_ze_tagessatz      t,
        pzm_abwesenheitsarten aa,
        pzm_lohnarten         loa
    where
            t.ts_pers_nr = in_pers_nr
        and t.ts_datum >= v_start_datum
        and t.ts_datum <= v_ende_datum
        and t.ts_day_kst_id = nvl(in_kst_id, t.ts_day_kst_id)
        and aa.aa_id = t.ts_aa_id
        and aa.lz_id = loa.lz_id
        and loa.lz_operator = 'UNB'
        and ( isi_utils.iso_weekday(t.ts_datum) not in ( 7 )
              or isi_utils.iso_weekday(t.ts_day_ist_ende) = 1 );

    result        number;
begin
    v_start_datum := trunc(in_datum, 'MONTH');
    v_ende_datum := add_months(v_start_datum, 1) - 1;
    result := 0;
    open c_soll_std;
    fetch c_soll_std into result;
    close c_soll_std;
    open c_unb_std;
    fetch c_unb_std into v_unb_std;
    close c_unb_std;
    result := result - nvl(v_unb_std, 0);
    return result;
exception
    when others then
        return ( null );
end get_pers_monat_soll_std;
/


-- sqlcl_snapshot {"hash":"1d6ce61ff5fb681bf7fee7b49f15762b2a44bdb3","type":"FUNCTION","name":"GET_PERS_MONAT_SOLL_STD","schemaName":"DIRKSPZM32","sxml":""}