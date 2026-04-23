create or replace function dirkspzm32.get_anz_arbeitstage (
    p_pers_nr        in integer,
    p_start_datum    in date,
    p_ende_datum     in date,
    p_einflussfaktor in integer
) return number is
    result number(15, 1);
begin
    result := get_anz_arbeitstage_r32(
        p_pers_nr     => p_pers_nr,
        p_start_datum => p_start_datum,
        p_ende_datum  => p_ende_datum
    );

    return ( result );
end;
/


-- sqlcl_snapshot {"hash":"723975487d6d5e195a9ee21090ec4bd0226df3ac","type":"FUNCTION","name":"GET_ANZ_ARBEITSTAGE","schemaName":"DIRKSPZM32","sxml":""}