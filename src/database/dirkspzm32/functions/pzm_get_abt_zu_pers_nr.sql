create or replace function dirkspzm32.pzm_get_abt_zu_pers_nr (
    in_pers_nr in number
) return varchar2 is

    result               varchar2(4096);
    v_abteilung          pzm_abteilungen%rowtype;
    v_produktionsbereich pzm_produktionsbereiche%rowtype;
    v_personal           pzm_personal%rowtype;
    v_abt_leitung        pzm_abt_leitung%rowtype;
    cursor c_personal is
    select
        *
    from
        pzm_personal p
    where
        p.pers_nr = in_pers_nr;

    cursor c_abteilung is
    select
        *
    from
        pzm_abteilungen a
    where
        a.abt_id = v_personal.pers_abt_id;

    cursor c_produktionsbereich is
    select
        *
    from
        pzm_produktionsbereiche pb
    where
        pb.pb_id = nvl(v_personal.pers_pb_id, v_abteilung.abt_pb_id);

    cursor c_abt_leitung is
    select
        *
    from
        pzm_abt_leitung al
    where
        al.abt_l_pers_nr = in_pers_nr;

begin
    open c_personal;
    fetch c_personal into v_personal;
    close c_personal;
    open c_abteilung;
    fetch c_abteilung into v_abteilung;
    close c_abteilung;
    open c_produktionsbereich;
    fetch c_produktionsbereich into v_produktionsbereich;
    close c_produktionsbereich;
    open c_abt_leitung;
    fetch c_abt_leitung into v_abt_leitung;
    close c_abt_leitung;
    result := v_abteilung.abt_name;

  -- Eigene Abteilung ist die Zuständige Personalabteilung
  -- Oder über die Hirachie und Leitungsfunktion 
    select
        ';'
        || stradd_distinct(res.abt_id)
        || ';'
    into result
    from
        (
            select
                a.abt_id
            from
                pzm_abteilungen a
            where
                    a.abt_pb_id = v_produktionsbereich.pb_id
                and nvl(a.abt_personal_abt_id, v_produktionsbereich.pb_personal_abt_id) = v_abteilung.abt_id
            union
            select
                a.abt_id
            from
                pzm_abteilungen a
            start with
                a.abt_id = v_abt_leitung.abt_l_abt_id
            connect by
                prior a.abt_id = a.abt_parent_abt_id
        ) res;

    return ( result );
end pzm_get_abt_zu_pers_nr;
/


-- sqlcl_snapshot {"hash":"6d72e33824627f88da7c898ec197a9bf01227260","type":"FUNCTION","name":"PZM_GET_ABT_ZU_PERS_NR","schemaName":"DIRKSPZM32","sxml":""}