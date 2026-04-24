create or replace package body dirkspzm32.pzm_tagessatz is

  -- ********************************************************************
    function get_version return varchar2 is
    begin
        return ( v_version_str );
    end get_version;

  -- ********************************************************************
    procedure ueberstd_genehmigen (
        p_pers_nr      in number,
        p_ts_datum     in date,
        p_korr_pers_nr in number
    ) is
        v_result  number;
        v_resinfo varchar2(255);
    begin
        update pzm_ze_tagessatz ts
        set
            ts.ts_ueb_ok_pers_nr = p_korr_pers_nr,
            ts.ts_ueb_ok_datum = sysdate,
            ts.ts_ueb_storno_datum = null,
            ts.ts_abschluss = p_korr_pers_nr
        where
                ts.ts_pers_nr = p_pers_nr
            and ts.ts_datum = p_ts_datum;

        commit;
        update_pers_ze_tag(p_pers_nr, p_ts_datum, v_result, v_resinfo);
    end;


  -- ********************************************************************
    procedure ueberstd_stornieren (
        p_pers_nr      in number,
        p_ts_datum     in date,
        p_korr_pers_nr in number
    ) is
        v_result  number;
        v_resinfo varchar2(255);
    begin
        update pzm_ze_tagessatz ts
        set
            ts.ts_ueb_storno_pers_nr = p_korr_pers_nr,
            ts.ts_ueb_storno_datum = sysdate,
            ts.ts_abschluss = null
        where
                ts.ts_pers_nr = p_pers_nr
            and ts.ts_datum = p_ts_datum;

        commit;
        update_pers_ze_tag(p_pers_nr, p_ts_datum, v_result, v_resinfo);
    end;


  -- ********************************************************************
    procedure abschliessen (
        p_pers_nr      in number,
        p_ts_datum     in date,
        p_ueb_std      in number,
        p_korr_std     in number,
        p_flex_std     in number,
        p_korr_pers_nr in number
    ) is
        v_result  number;
        v_resinfo varchar2(255);
    begin
        update pzm_ze_tagessatz ts
        set
            ts.ts_day_ueb_std = p_ueb_std,
            ts.ts_day_korr_std = p_korr_std,
            ts.ts_day_flex_std = p_flex_std,
            ts.ts_abschluss = p_korr_pers_nr
        where
                ts.ts_pers_nr = p_pers_nr
            and ts.ts_datum = p_ts_datum;

        if p_ueb_std = 0 then
            update pzm_ze_tagessatz ts
            set
                ts.ts_ueb_ok_pers_nr = null,
                ts.ts_ueb_ok_datum = null,
                ts.ts_ueb_storno_pers_nr = null,
                ts.ts_ueb_storno_datum = null
            where
                    ts.ts_pers_nr = p_pers_nr
                and ts.ts_datum = p_ts_datum;

        end if;

        commit;
        update_pers_ze_tag(p_pers_nr, p_ts_datum, v_result, v_resinfo);
    end;

  -- ********************************************************************
    function get_abwes_liste_fuer_tag (
        p_pers_nr   in number,
        p_datum     in date,
        p_spalte    in number default 1,
        p_separator in varchar2 default chr(13)
    ) return varchar2 is
    begin
    -- -WK- 20091216: nach pzm_utils umgezogen
        return ( pzm_utils.get_abwes_liste_fuer_tag(p_pers_nr, p_datum, p_spalte, p_separator) );
    end;

end pzm_tagessatz;
/


-- sqlcl_snapshot {"hash":"7ee75e6a2c518f0f4daba519d803cd80bcf1dadb","type":"PACKAGE_BODY","name":"PZM_TAGESSATZ","schemaName":"DIRKSPZM32","sxml":""}