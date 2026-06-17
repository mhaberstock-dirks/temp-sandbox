create or replace function dirkspzm32.get_pers_loa_is_gueltig_n (
    in_pers_nr     in pzm_personal.pers_nr%type,
    in_lz_id       in pzm_lohnarten.lz_id%type,
    in_sa_kurzname in pzm_schichtarten.sa_kurzname%type
) return number is
/*
 * Prüft ob eine Lohnart (lz_id) für Person, Schichtart und Kostenstelle gültig ist.
 * Gibt 1 (gültig) oder 0 (ungültig) zurück — verwendbar direkt in SQL-WHERE-Klauseln.
 *
 * Entspricht get_pers_loa_is_gueltig, jedoch mit NUMBER statt BOOLEAN als Rückgabetyp.
 * Die Allow-/Blocklist-Logik ist in check_gueltig_liste zentralisiert.
 */

    v_tarif_name pzm_tarifmodelle.tarif_name%type;
    v_kst_id     pzm_personal.pers_kst_id%type;
    v_regeln     dirkspzm32.pzm_gueltig_regel_ct;
begin
    select
        tarif_name
    into v_tarif_name
    from
        pzm_personal
    where
        pers_nr = in_pers_nr;

    v_kst_id := get_pers_kst_id(in_pers_nr);

    -- 1. Tarifmodell
    select
        dirkspzm32.pzm_gueltig_regel_t(tarif_name, lz_gueltig)
    bulk collect
    into v_regeln
    from
        pzm_lz_tarifmodelle
    where
        lz_id = in_lz_id;

    if dirkspzm32.check_gueltig_liste(v_tarif_name, v_regeln) = 0 then
        return 0;
    end if;
    if in_sa_kurzname is not null then

        -- 2. Schichtart
        select
            dirkspzm32.pzm_gueltig_regel_t(lzsa_sa_kurzname, lzsa_gueltig)
        bulk collect
        into v_regeln
        from
            pzm_lz_sa
        where
            lzsa_lz_id = in_lz_id;

        if dirkspzm32.check_gueltig_liste(in_sa_kurzname, v_regeln) = 0 then
            return 0;
        end if;

        -- 3. Kostenstelle
        select
            dirkspzm32.pzm_gueltig_regel_t(
                to_char(lzkst_abt_kst),
                lzkst_gueltig
            )
        bulk collect
        into v_regeln
        from
            pzm_lz_kst
        where
            lzkst_lz_id = in_lz_id;

        if dirkspzm32.check_gueltig_liste(
            to_char(v_kst_id),
            v_regeln
        ) = 0 then
            return 0;
        end if;

    end if;

    return 1;
end get_pers_loa_is_gueltig_n;
/


-- sqlcl_snapshot {"hash":"c6694a294937f73839592025be7c2465a71dc55f","type":"FUNCTION","name":"GET_PERS_LOA_IS_GUELTIG_N","schemaName":"DIRKSPZM32","sxml":""}