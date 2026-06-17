
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_TAGESSATZ_BUI" 
  before insert or update on DIRKSPZM32.pzm_ze_tagessatz
  for each row
declare
  -- local variables here

  v_UebStd      number;
  v_KorrStd     number;
  v_FlexStd     number;
  v_SummeLOAStd number;

  v_Datum       date;
  v_PersNr      number;

  v_NewUebOkDatum date;
  v_OldUebOkDatum date;

  v_NewUebStornoDatum date;
  v_OldUebStornoDatum date;

  v_NewAbschlussPers number;

  v_korr_std_loa pzm_lohnarten.lz_lohnart%type;
  v_ueb_std_loa pzm_lohnarten.lz_lohnart%type;
  v_flex_std_loa pzm_lohnarten.lz_lohnart%type;

  v_ChangeLoa boolean;
begin
  if inserting
  then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    if :new.created_login_id is NULL
    then
      :new.created_login_id := current_isi_user_login_id();
    end if;
  end if;
  

  if updating
  then
    :new.last_change_date := sysdate;
    if :new.last_change_login_id is NULL
    then
      :new.last_change_login_id := current_isi_user_login_id();
    end if;
  end if;

  -- v_ueb_std_loa := pzm_p_base.get_allg_parameter_mandant(:new.ts_pers_nr, 'UEB_STD_ZUGANG_LOA');
  v_ueb_std_loa := get_pers_zk_ueb_loa(:new.ts_pers_nr);
  -- v_flex_std_loa := pzm_p_base.get_allg_parameter_mandant(:new.ts_pers_nr, 'FLEX_STD_ZUGANG_LOA');
  v_flex_std_loa := get_pers_zk_zug_loa(:new.ts_pers_nr);
  -- v_korr_std_loa := pzm_p_base.get_allg_parameter_mandant(:new.ts_pers_nr, 'KORR_STD_ZUGANG_LOA');
  v_korr_std_loa := get_pers_zk_korr_loa(:new.ts_pers_nr);

  v_UebStd := null;
  v_FlexStd := null;
  v_KorrStd := null;

  v_ChangeLoa := false;

  v_Datum := :new.ts_datum;
  v_PersNr := :new.ts_pers_nr;

  v_NewUebOkDatum := :new.ts_ueb_ok_datum;
  v_OldUebOkDatum := :old.ts_ueb_ok_datum;

  v_NewUebStornoDatum := :new.ts_ueb_storno_datum;
  v_OldUebStornoDatum := :old.ts_ueb_storno_datum;

  v_NewAbschlussPers := :new.ts_abschluss;

  if (v_NewUebOkDatum is not null)
     and (v_NewUebStornoDatum is null)
     and (v_OldUebOkDatum is null
          or v_OldUebStornoDatum is not null)
  then
    -- Überstunden wurden genehmigt
    v_UebStd := nvl(:new.ts_day_ueb_std, 0);
    v_FlexStd := nvl(:new.ts_day_flex_std, 0);
    v_KorrStd := 0;
    if v_NewAbschlussPers is not null
    then
      v_KorrStd := nvl(:new.ts_day_korr_std, 0);
    end if;
    v_ChangeLoa := true;
  elsif v_NewUebStornoDatum is not null
        and v_NewUebOkDatum is not null
        and v_OldUebStornoDatum is null
  then
    -- Überstunden wurden storniert
    v_UebStd := 0;
    v_FlexStd := 0;
    v_KorrStd := 0;
    if v_NewAbschlussPers is not null
    then
      v_KorrStd := nvl(:new.ts_day_korr_std, 0);
    end if;
    v_ChangeLoa := true;
  elsif v_NewAbschlussPers is not null
  then
    -- für Überstunden und Korrektur-/Bonusstunden wurden neue Werte gesetzt
    v_UebStd := 0;
    v_FlexStd := 0;
    if v_OldUebOkDatum is not null
       and v_OldUebStornoDatum is null
    then
      v_UebStd := nvl(:new.ts_day_ueb_std, 0);
      v_FlexStd := nvl(:new.ts_day_flex_std, 0);
    end if;
    v_KorrStd := nvl(:new.ts_day_korr_std, 0);
    v_ChangeLoa := true;
  elsif v_NewUebOkDatum is null
        and v_OldUebOkDatum is not null
  then
    -- Die Überstundengenehmigung wurde (durch Korrektur der Stunden) zurückgesetzt
    v_UebStd := 0;
    v_FlexStd := 0;
    v_KorrStd := 0;
    if v_NewAbschlussPers is not null
    then
      v_KorrStd := nvl(:new.ts_day_korr_std, 0);
    end if;
    v_ChangeLoa := true;
  end if;

  if v_ChangeLoa
  then
    if v_ueb_std_loa = v_flex_std_loa
       and v_flex_std_loa = v_korr_std_loa
    then -- alle LOA gleich
      v_SummeLOAStd := v_UebStd + v_FlexStd + v_KorrStd;
      pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_ueb_std_loa, v_SummeLOAStd, null, true, NULL, :new.ts_day_kst_id);
    elsif v_ueb_std_loa = v_flex_std_loa
    then
      v_SummeLOAStd := v_UebStd + v_FlexStd;
      pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_ueb_std_loa, v_SummeLOAStd, null, true, NULL, :new.ts_day_kst_id);
      if v_korr_std_loa is not null
      then
        pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_korr_std_loa, v_KorrStd, null, true, NULL, :new.ts_day_kst_id);
      end if;
    elsif v_flex_std_loa = v_korr_std_loa
    then
      v_SummeLOAStd := v_FlexStd + v_KorrStd;
      pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_flex_std_loa, v_SummeLOAStd, null, true, NULL, :new.ts_day_kst_id);
      if v_ueb_std_loa is not null
      then
        pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_ueb_std_loa, v_UebStd, null, true, NULL, :new.ts_day_kst_id);
      end if;
    elsif v_ueb_std_loa = v_korr_std_loa
    then
      v_SummeLOAStd := v_UebStd + v_KorrStd;
      pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_ueb_std_loa, v_SummeLOAStd, null, true, NULL, :new.ts_day_kst_id);
      if v_flex_std_loa is not null
      then
        pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_flex_std_loa, v_FlexStd, null, true, NULL, :new.ts_day_kst_id);
      end if;
    else -- alle LOA ungleich
      if v_ueb_std_loa is not null
      then
        pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_ueb_std_loa, v_UebStd, null, true, NULL, :new.ts_day_kst_id);
      end if;
      if v_flex_std_loa is not null
      then
        pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_flex_std_loa, v_FlexStd, null, true, NULL, :new.ts_day_kst_id);
      end if;
      if v_korr_std_loa is not null
      then
        pzm_lohnauswertung.set_loa_std(v_PersNr, v_Datum, v_korr_std_loa, v_KorrStd, null, true, NULL, :new.ts_day_kst_id);
      end if;
    end if;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_TAGESSATZ_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"34efc054cf624cab5d60fe0e8ebc0b62ab69ec47","type":"TRIGGER","name":"TR_TAGESSATZ_BUI","schemaName":"DIRKSPZM32","sxml":""}