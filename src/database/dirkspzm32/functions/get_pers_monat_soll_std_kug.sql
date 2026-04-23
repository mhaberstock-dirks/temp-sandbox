create or replace function dirkspzm32.get_pers_monat_soll_std_kug (
    in_pers_nr in pzm_personal.pers_nr%type,
    in_kst_id  in pzm_ze_tagessatz.ts_day_kst_id%type,
    in_datum   in date
) return number is

    v_start_datum date;
    v_ende_datum  date;
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
        and ( t.ts_day_arb_std > 0
              or (
            select
                a.lz_id
            from
                pzm_abwesenheitsarten a
            where
                a.aa_id = t.ts_aa_id
        ) is not null
              or (
            select
                a.aa_kurzname
            from
                pzm_abwesenheitsarten a
            where
                a.aa_id = t.ts_aa_id
        ) in ( 'KUG', 'KUGK', 'V-ARB-Zeit' ) )
        and ( isi_utils.iso_weekday(t.ts_datum) not in ( 7 )
              or isi_utils.iso_weekday(t.ts_day_ist_ende) = 1 ); -- keinen Sontag außer Nachtschicht in den Montag
    result        number;
begin
    v_start_datum := trunc(in_datum, 'MONTH');
    v_ende_datum := add_months(v_start_datum, 1) - 1;
    result := 0;
    open c_soll_std;
    fetch c_soll_std into result;
    close c_soll_std;
    return result;
exception
    when others then
        return ( null );
end get_pers_monat_soll_std_kug;
/


-- sqlcl_snapshot {"hash":"532bbd4514bd600e6dbb80a0b4566b3342bf3efd","type":"FUNCTION","name":"GET_PERS_MONAT_SOLL_STD_KUG","schemaName":"DIRKSPZM32","sxml":""}