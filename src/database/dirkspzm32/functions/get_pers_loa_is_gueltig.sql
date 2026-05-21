create or replace function dirkspzm32.get_pers_loa_is_gueltig (
    in_pers_nr     in pzm_personal.pers_nr%type,
    in_lz_id       in pzm_lohnarten.lz_id%type,
    in_sa_kurzname in pzm_schichtarten.sa_kurzname%type
) return number is
/*
 * Prüft ob eine Lohnart (lz_id) für Person, Schichtart und Kostenstelle gültig ist.
 *
 * Gültigkeitsprinzip für jede Dimension (Tarif / Schichtart / Kostenstelle):
 *   Keine Einträge in Zuordnungstabelle ¿ Lohnart gilt für alle
 *   Einträge mit GUELTIG=1 vorhanden   ¿ Allowlist: nur explizit erlaubte gelten
 *   Nur Einträge mit GUELTIG=0         ¿ Blocklist: alle außer den gesperrten gelten
 */

    v_gueltig       boolean := true;
    v_gueltig_ret   number;
    -- Rückfallwert: true = Blocklist-Modus (Standard gültig), false = Allowlist-Modus (Standard ungültig)
    v_gueltig_basis boolean;
    v_tarif_name    pzm_tarifmodelle.tarif_name%type;
    v_kst_id        pzm_personal.pers_kst_id%type;
    v_row_count     pls_integer;
begin
    select
        tarif_name
    into v_tarif_name
    from
        pzm_personal
    where
        pers_nr = in_pers_nr;

    v_kst_id := get_pers_kst_id(in_pers_nr);

    -- 1. Tarifmodell-Prüfung
    v_row_count := 0;
    for rec in (
        select
            *
        from
            pzm_lz_tarifmodelle
        where
            lz_id = in_lz_id
    ) loop
        v_row_count := v_row_count + 1;
        if v_row_count = 1 then
            v_gueltig := false;  -- Einträge vorhanden ¿ nicht mehr generell gültig
        end if;
        if rec.lz_gueltig = 1 then
            v_gueltig := false;  -- Allowlist-Eintrag gefunden ¿ ungültig bis passender Tarif gefunden
        end if;
        if rec.tarif_name = v_tarif_name then
            v_gueltig := ( rec.lz_gueltig = 1 );
            exit;
        end if;

    end loop;

    -- 2. Schichtart-Prüfung (nur wenn Lohnart bisher gültig und Schichtart angegeben)
    if
        v_gueltig
        and in_sa_kurzname is not null
    then
        v_row_count := 0;
        v_gueltig_basis := true;
        for rec in (
            select
                *
            from
                pzm_lz_sa
            where
                lzsa_lz_id = in_lz_id
        ) loop
            v_row_count := v_row_count + 1;
            if v_row_count = 1 then
                v_gueltig := false;
            end if;
            if rec.lzsa_gueltig = 1 then
                -- Allowlist-Eintrag ¿ Standard-Gültigkeit wechselt auf false
                v_gueltig_basis := false;
                v_gueltig := false;
            end if;

            if rec.lzsa_sa_kurzname = in_sa_kurzname then
                v_gueltig := ( rec.lzsa_gueltig = 1 );
                exit;
            end if;

            -- Blocklist-Eintrag für andere Schicht ¿ Standard-Gültigkeit wiederherstellen
            if
                rec.lzsa_sa_kurzname != in_sa_kurzname
                and rec.lzsa_gueltig = 0
            then
                v_gueltig := v_gueltig_basis;
            end if;

        end loop;

        -- 3. Kostenstellen-Prüfung
        if v_gueltig then
            v_row_count := 0;
            v_gueltig_basis := true;
            for rec in (
                select
                    *
                from
                    pzm_lz_kst
                where
                    lzkst_lz_id = in_lz_id
            ) loop
                v_row_count := v_row_count + 1;
                if v_row_count = 1 then
                    v_gueltig := false;
                end if;
                if rec.lzkst_gueltig = 1 then
                    v_gueltig_basis := false;
                    v_gueltig := false;
                end if;

                if rec.lzkst_abt_kst = v_kst_id then
                    v_gueltig := ( rec.lzkst_gueltig = 1 );
                    exit;
                end if;

                -- Blocklist-Eintrag für andere Kostenstelle ¿ Standard-Gültigkeit wiederherstellen
                if
                    rec.lzkst_abt_kst != v_kst_id
                    and rec.lzkst_gueltig = 0
                then
                    v_gueltig := v_gueltig_basis;
                end if;

            end loop;

        end if;

    end if;

    v_gueltig_ret :=
        case
            when v_gueltig then
                1
            else
                0
        end;
    return v_gueltig_ret;
end get_pers_loa_is_gueltig;
/


-- sqlcl_snapshot {"hash":"660ce269da9b77391876e5631ac3642731f195fb","type":"FUNCTION","name":"GET_PERS_LOA_IS_GUELTIG","schemaName":"DIRKSPZM32","sxml":""}