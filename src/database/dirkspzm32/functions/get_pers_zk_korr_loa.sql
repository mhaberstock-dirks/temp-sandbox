create or replace function dirkspzm32.get_pers_zk_korr_loa (
    in_pers_nr in pzm_personal.pers_nr%type
) return varchar2 is

    result           pzm_lohnarten.lz_lohnart%type;
    v_schicht_modell pzm_schicht_modelle%rowtype;
    v_lohnart        pzm_lohnarten%rowtype;
    cursor c_loa is
    select
        t.*
    from
        pzm_lohnarten t
    where
        t.lz_id = (
            select
                lz.lz_id
            from
                pzm_abwesenheitsarten a,
                pzm_lohnarten         l,
                pzm_lohnarten         lz
            where
                    a.aa_id = v_schicht_modell.standard_aa_id
                and l.lz_id = a.lz_id
                and lz.lz_link_loa_id = l.lz_id
        );

begin
    if not pzm_p_base.get_schicht_modell(in_pers_nr, v_schicht_modell) then
        result := null;
    else
        open c_loa;
        fetch c_loa into v_lohnart;
        close c_loa;
        result := nvl(v_lohnart.lz_lohnart,
                      pzm_p_base.get_allg_parameter_mandant(in_pers_nr, 'KORR_STD_ZUGANG_LOA'));

    end if;

    return result;
exception
    when others then
        return ( null );
end get_pers_zk_korr_loa;
/


-- sqlcl_snapshot {"hash":"7fab354858ba8128644c733d0fcbaa15e21976b4","type":"FUNCTION","name":"GET_PERS_ZK_KORR_LOA","schemaName":"DIRKSPZM32","sxml":""}