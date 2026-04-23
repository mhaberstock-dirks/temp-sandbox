create or replace function dirkspzm32.get_sum_loa_std (
    p_pers_nr in number,
    p_datum   in date,
    p_lohnart in varchar2
) return number is

    result number;
    cursor c_sumloastd is
    select
        zeaw_lz_loa_std
    from
        pzm_ze_loa_ausw
    where
            zeaw_pers_nr = p_pers_nr
        and zeaw_datum = trunc(p_datum)
        and zeaw_lz_lohnart = p_lohnart;

begin
    open c_sumloastd;
    fetch c_sumloastd into result;
    if c_sumloastd%notfound then
        result := null;
    end if;
    close c_sumloastd;
    return ( round(result, 2) );
end get_sum_loa_std;
/


-- sqlcl_snapshot {"hash":"6a15a3617a9df74ae50df25b789360dfb0e23564","type":"FUNCTION","name":"GET_SUM_LOA_STD","schemaName":"DIRKSPZM32","sxml":""}