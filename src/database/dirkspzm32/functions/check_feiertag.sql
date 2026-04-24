create or replace function dirkspzm32.check_feiertag (
    in_pb_id   in pzm_produktionsbereiche.pb_id%type,
    in_abt_id  in pzm_abteilungen.abt_id%type,
    in_pers_nr in pzm_personal.pers_nr%type,
    in_kst_id  in pzm_personal.pers_kst_id%type,
    in_datum   in date
) return varchar2 is
    result           varchar2(10);
    v_sonderfeiertag varchar2(5);
begin
    result := '';
    if ist_feiertag(in_pers_nr, in_pb_id, in_abt_id, in_kst_id, in_datum,
                    v_sonderfeiertag) = 1 then
        result := 'F';
        if
            ( v_sonderfeiertag is not null )
            and ( v_sonderfeiertag <> '' )
        then
            result := 'SF';
        end if;

    end if;

    return ( result );
end check_feiertag;
/


-- sqlcl_snapshot {"hash":"0f9266a2720bc13af62334b3cdf8712686aae36b","type":"FUNCTION","name":"CHECK_FEIERTAG","schemaName":"DIRKSPZM32","sxml":""}