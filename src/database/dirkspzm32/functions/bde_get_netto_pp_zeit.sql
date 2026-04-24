create or replace function dirkspzm32.bde_get_netto_pp_zeit
/*
  TODO: Kommentieren
  ---- HISTORY ---
  28.10.2013 -MM- Kommentare in JavaDoc-Style geändert
  @param in_res_fa_seit Beginn des Fertigungsauftrags
  @param in_res_fa_bis Fertigungsauftrag geplant bis
  @param in_res_id Ressourcen ID
  @return Schichtdauer
*/ (
    in_res_fa_seit in date,
    in_res_fa_bis  in date,
    in_res_id      in isi_resource.res_id%type
) return number is

    v_schicht_begin date;
    v_schicht_ende  date;
    v_schicht_dauer number;
    v_stoer_dauer   number;
    cursor c_schicht_zeiten is
    select
        (
            case
                when t.pd_kopf_beginn < in_res_fa_seit then
                    in_res_fa_seit
                else
                    t.pd_kopf_beginn
            end
        ) begin,
        (
            case
                when nvl(t.pd_kopf_ende, in_res_fa_bis) > in_res_fa_bis then
                    in_res_fa_bis
                else
                    nvl(t.pd_kopf_ende, in_res_fa_bis)
            end
        ) ende
    from
        bde_pd_kopf t
    where
            t.res_id = in_res_id
        and ( t.pd_kopf_ende > in_res_fa_seit
              or t.pd_kopf_ende is null )
        and ( ( t.pd_kopf_beginn >= in_res_fa_seit
                or t.pd_kopf_beginn <= in_res_fa_seit
                and nvl(t.pd_kopf_ende, in_res_fa_bis) >= in_res_fa_seit )
              and ( nvl(t.pd_kopf_ende, in_res_fa_bis) <= in_res_fa_bis
                    or t.pd_kopf_beginn <= in_res_fa_bis
                    and nvl(t.pd_kopf_ende, in_res_fa_bis) >= in_res_fa_bis ) )
        and nvl(t.pd_kopf_ende, in_res_fa_bis) > t.pd_kopf_beginn;

    cursor c_sum_sd_zeit is
    select
        sum((
            case
                when t.st_ende > v_schicht_ende then
                    v_schicht_ende
                else
                    t.st_ende
            end
        ) -(
            case
                when t.st_start < v_schicht_begin then
                    v_schicht_begin
                else
                    t.st_start
            end
        )) * 1440
    from
        isi_res_status t
    where
            t.res_id = in_res_id
        and t.res_st_id != 0
        and t.st_ende >= v_schicht_begin
        and ( ( t.st_start >= v_schicht_begin
                or t.st_start <= v_schicht_begin
                and t.st_ende >= v_schicht_begin )
              and ( t.st_ende <= v_schicht_ende
                    or t.st_start <= v_schicht_ende
                    and t.st_ende >= v_schicht_ende ) );

begin
    v_schicht_dauer := 0;
    open c_schicht_zeiten;
    fetch c_schicht_zeiten into
        v_schicht_begin,
        v_schicht_ende;
    loop
        exit when c_schicht_zeiten%notfound;
        v_schicht_dauer := v_schicht_dauer + ( ( v_schicht_ende - v_schicht_begin ) * 1440 ); -- Brutto in Min
        v_stoer_dauer := 0;
        open c_sum_sd_zeit;
        fetch c_sum_sd_zeit into v_stoer_dauer;
        v_schicht_dauer := v_schicht_dauer - nvl(v_stoer_dauer, 0);
        close c_sum_sd_zeit;
        fetch c_schicht_zeiten into
            v_schicht_begin,
            v_schicht_ende;
    end loop;

    close c_schicht_zeiten;
    return ( v_schicht_dauer / 60 );
end bde_get_netto_pp_zeit;
/


-- sqlcl_snapshot {"hash":"aec1b11831d6af8b0d2da5b97f143844123dd31c","type":"FUNCTION","name":"BDE_GET_NETTO_PP_ZEIT","schemaName":"DIRKSPZM32","sxml":""}