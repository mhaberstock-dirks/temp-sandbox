create or replace function dirkspzm32.check_gueltig_liste (
    in_schluessel in varchar2,
    in_regeln     in dirkspzm32.pzm_gueltig_regel_ct
) return number is
/*
 * Generische Allow-/Blocklist-Prüfung.
 * Gibt 1 (gültig) oder 0 (ungültig) zurück:
 *
 *   Keine Einträge                             ¿ 1  (gilt für alle)
 *   Eintrag: schluessel = X, gueltig = 1       ¿ 1  (Allowlist-Treffer)
 *   Eintrag: schluessel = X, gueltig = 0       ¿ 0  (Blocklist-Treffer)
 *   Keine Übereinstimmung, gueltig=1 existiert ¿ 0  (Allowlist-Modus, nicht enthalten)
 *   Keine Übereinstimmung, nur gueltig=0       ¿ 1  (Blocklist-Modus, nicht gesperrt)
 */
    v_result number;
begin
    if in_regeln is null
       or in_regeln.count = 0 then
        return 1;
    end if;
    select
        case
            when exists (
                select
                    1
                from
                    table ( in_regeln ) r
                where
                        r.schluessel = in_schluessel
                    and r.gueltig = 1
            ) then
                1
            when exists (
                select
                    1
                from
                    table ( in_regeln ) r
                where
                        r.schluessel = in_schluessel
                    and r.gueltig = 0
            ) then
                0
            when exists (
                select
                    1
                from
                    table ( in_regeln ) r
                where
                    r.gueltig = 1
            ) then
                0
            else
                1
        end
    into v_result
    from
        dual;

    return v_result;
end check_gueltig_liste;
/


-- sqlcl_snapshot {"hash":"1e5606955f41f52288b8bd626d7224e94d277ddb","type":"FUNCTION","name":"CHECK_GUELTIG_LISTE","schemaName":"DIRKSPZM32","sxml":""}