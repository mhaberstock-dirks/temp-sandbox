create or replace editionable trigger dirkspzm32.tr_tagessatz_bui before
    insert or update on dirkspzm32.pzm_ze_tagessatz
    for each row
declare
  -- local variables here

    v_uebstd            number;
    v_korrstd           number;
    v_flexstd           number;
    v_summeloastd       number;
    v_datum             date;
    v_persnr            number;
    v_newuebokdatum     date;
    v_olduebokdatum     date;
    v_newuebstornodatum date;
    v_olduebstornodatum date;
    v_newabschlusspers  number;
    v_korr_std_loa      pzm_lohnarten.lz_lohnart%type;
    v_ueb_std_loa       pzm_lohnarten.lz_lohnart%type;
    v_flex_std_loa      pzm_lohnarten.lz_lohnart%type;
    v_changeloa         boolean;
begin
    if inserting then
        if :new.created_date is null then
            :new.created_date := sysdate;
        end if;

        if :new.created_login_id is null then
            :new.created_login_id := current_isi_user_login_id();
        end if;

    end if;

    if updating then
        :new.last_change_date := sysdate;
        if :new.last_change_login_id is null then
            :new.last_change_login_id := current_isi_user_login_id();
        end if;

    end if;

  -- v_ueb_std_loa := pzm_p_base.get_allg_parameter_mandant(:new.ts_pers_nr, 'UEB_STD_ZUGANG_LOA');
    v_ueb_std_loa := get_pers_zk_ueb_loa(:new.ts_pers_nr);
  -- v_flex_std_loa := pzm_p_base.get_allg_parameter_mandant(:new.ts_pers_nr, 'FLEX_STD_ZUGANG_LOA');
    v_flex_std_loa := get_pers_zk_zug_loa(:new.ts_pers_nr);
  -- v_korr_std_loa := pzm_p_base.get_allg_parameter_mandant(:new.ts_pers_nr, 'KORR_STD_ZUGANG_LOA');
    v_korr_std_loa := get_pers_zk_korr_loa(:new.ts_pers_nr);
    v_uebstd := null;
    v_flexstd := null;
    v_korrstd := null;
    v_changeloa := false;
    v_datum := :new.ts_datum;
    v_persnr := :new.ts_pers_nr;
    v_newuebokdatum := :new.ts_ueb_ok_datum;
    v_olduebokdatum := :old.ts_ueb_ok_datum;
    v_newuebstornodatum := :new.ts_ueb_storno_datum;
    v_olduebstornodatum := :old.ts_ueb_storno_datum;
    v_newabschlusspers := :new.ts_abschluss;
    if
        ( v_newuebokdatum is not null )
        and ( v_newuebstornodatum is null )
        and ( v_olduebokdatum is null
              or v_olduebstornodatum is not null )
    then
    -- Überstunden wurden genehmigt
        v_uebstd := nvl(:new.ts_day_ueb_std,
                        0);
        v_flexstd := nvl(:new.ts_day_flex_std,
                         0);
        v_korrstd := 0;
        if v_newabschlusspers is not null then
            v_korrstd := nvl(:new.ts_day_korr_std,
                             0);
        end if;

        v_changeloa := true;
    elsif
        v_newuebstornodatum is not null
        and v_newuebokdatum is not null
        and v_olduebstornodatum is null
    then
    -- Überstunden wurden storniert
        v_uebstd := 0;
        v_flexstd := 0;
        v_korrstd := 0;
        if v_newabschlusspers is not null then
            v_korrstd := nvl(:new.ts_day_korr_std,
                             0);
        end if;

        v_changeloa := true;
    elsif v_newabschlusspers is not null then
    -- für Überstunden und Korrektur-/Bonusstunden wurden neue Werte gesetzt
        v_uebstd := 0;
        v_flexstd := 0;
        if
            v_olduebokdatum is not null
            and v_olduebstornodatum is null
        then
            v_uebstd := nvl(:new.ts_day_ueb_std,
                            0);
            v_flexstd := nvl(:new.ts_day_flex_std,
                             0);
        end if;

        v_korrstd := nvl(:new.ts_day_korr_std,
                         0);
        v_changeloa := true;
    elsif
        v_newuebokdatum is null
        and v_olduebokdatum is not null
    then
    -- Die Überstundengenehmigung wurde (durch Korrektur der Stunden) zurückgesetzt
        v_uebstd := 0;
        v_flexstd := 0;
        v_korrstd := 0;
        if v_newabschlusspers is not null then
            v_korrstd := nvl(:new.ts_day_korr_std,
                             0);
        end if;

        v_changeloa := true;
    end if;

    if v_changeloa then
        if
            v_ueb_std_loa = v_flex_std_loa
            and v_flex_std_loa = v_korr_std_loa
        then -- alle LOA gleich
            v_summeloastd := v_uebstd + v_flexstd + v_korrstd;
            pzm_lohnauswertung.set_loa_std(v_persnr,
                                           v_datum,
                                           v_ueb_std_loa,
                                           v_summeloastd,
                                           null,
                                           true,
                                           null,
                                           :new.ts_day_kst_id);

        elsif v_ueb_std_loa = v_flex_std_loa then
            v_summeloastd := v_uebstd + v_flexstd;
            pzm_lohnauswertung.set_loa_std(v_persnr,
                                           v_datum,
                                           v_ueb_std_loa,
                                           v_summeloastd,
                                           null,
                                           true,
                                           null,
                                           :new.ts_day_kst_id);

            if v_korr_std_loa is not null then
                pzm_lohnauswertung.set_loa_std(v_persnr,
                                               v_datum,
                                               v_korr_std_loa,
                                               v_korrstd,
                                               null,
                                               true,
                                               null,
                                               :new.ts_day_kst_id);
            end if;

        elsif v_flex_std_loa = v_korr_std_loa then
            v_summeloastd := v_flexstd + v_korrstd;
            pzm_lohnauswertung.set_loa_std(v_persnr,
                                           v_datum,
                                           v_flex_std_loa,
                                           v_summeloastd,
                                           null,
                                           true,
                                           null,
                                           :new.ts_day_kst_id);

            if v_ueb_std_loa is not null then
                pzm_lohnauswertung.set_loa_std(v_persnr,
                                               v_datum,
                                               v_ueb_std_loa,
                                               v_uebstd,
                                               null,
                                               true,
                                               null,
                                               :new.ts_day_kst_id);
            end if;

        elsif v_ueb_std_loa = v_korr_std_loa then
            v_summeloastd := v_uebstd + v_korrstd;
            pzm_lohnauswertung.set_loa_std(v_persnr,
                                           v_datum,
                                           v_ueb_std_loa,
                                           v_summeloastd,
                                           null,
                                           true,
                                           null,
                                           :new.ts_day_kst_id);

            if v_flex_std_loa is not null then
                pzm_lohnauswertung.set_loa_std(v_persnr,
                                               v_datum,
                                               v_flex_std_loa,
                                               v_flexstd,
                                               null,
                                               true,
                                               null,
                                               :new.ts_day_kst_id);
            end if;

        else -- alle LOA ungleich
            if v_ueb_std_loa is not null then
                pzm_lohnauswertung.set_loa_std(v_persnr,
                                               v_datum,
                                               v_ueb_std_loa,
                                               v_uebstd,
                                               null,
                                               true,
                                               null,
                                               :new.ts_day_kst_id);
            end if;

            if v_flex_std_loa is not null then
                pzm_lohnauswertung.set_loa_std(v_persnr,
                                               v_datum,
                                               v_flex_std_loa,
                                               v_flexstd,
                                               null,
                                               true,
                                               null,
                                               :new.ts_day_kst_id);

            end if;

            if v_korr_std_loa is not null then
                pzm_lohnauswertung.set_loa_std(v_persnr,
                                               v_datum,
                                               v_korr_std_loa,
                                               v_korrstd,
                                               null,
                                               true,
                                               null,
                                               :new.ts_day_kst_id);
            end if;

        end if;
    end if;

end;
/

alter trigger dirkspzm32.tr_tagessatz_bui enable;


-- sqlcl_snapshot {"hash":"19d6bf0ec7517a57071f50c1cfdcc7c187c3a138","type":"TRIGGER","name":"TR_TAGESSATZ_BUI","schemaName":"DIRKSPZM32","sxml":""}