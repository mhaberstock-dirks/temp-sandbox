
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZEITERFASSUNG_BUID" 
  before insert or update or delete on DIRKSPZM32.pzm_zeiterfassung
  for each row
declare
  v_abwesenheitsarten pzm_abwesenheitsarten%rowtype;
  v_lohnart           pzm_lohnarten%rowtype;
begin
  if inserting
  then
    if :new.ze_id is null then -- ZE_ID generieren, wenn nicht bereits gesetzt (fallback)
      select seq_ze_id.nextval into :new.ze_id from dual;
    end if;

    if :new.created_date is NULL then -- Erstellungsdatum setzen (wird eigentlich bei INSERT als DEFAULT bereits gesetzt)
      :new.created_date := sysdate;
    end if;

    if :new.created_login_id is NULL then -- Versuchen den ISI_USER aus 
      :new.created_login_id := current_isi_user_login_id();
    end if;
  end if;

  if updating
  then
    -- Behandlung einer (noch) nicht gesetzten WORK_LOCATION
    -- fuer Abwaertskompatibilitaet
    if :new.ze_work_location is NULL
    or (:new.ze_status != :old.ze_status
        and (:old.ze_status = pzm_p_zeiterfassung.STATUS_DIENSTGANG
             or :new.ze_status = pzm_p_zeiterfassung.STATUS_DIENSTGANG))
    then
      :new.ze_work_location := pzm_p_zeiterfassung.get_default_work_location(:new.ze_status);
    end if;
  end if;

  if updating or deleting
  then
    if :old.ze_calc_ist_start is not null
       and :old.ze_calc_ist_ende is not null
    then -- wenn die ALTEN (Stempel-)Zeiten bewertet waren ...
      -- wenn der Status 'ABWESEND' war, und eine Abwesenheitsart gesetzt war
      if :old.ze_status in (pzm_p_zeiterfassung.STATUS_ABWESEND, pzm_p_zeiterfassung.STATUS_FEIERTAG)
         and :old.ze_aa_status is not null
      then
        if pzm_p_base.get_abwesenheitsart(:old.ze_aa_status, v_abwesenheitsarten)
        then
          if v_abwesenheitsarten.lz_id is not null
          and pzm_p_base.get_lohnart(v_abwesenheitsarten.lz_id, v_lohnart)
          and nvl(v_lohnart.lz_operator, 'xx') != 'ARBSTD' -- Sunden werden bei 'ARBSTD' in der Lohnabrechnung (erst) am Monatsende berechnet
          then
            -- Lohnart wieder entfernen, da Abwesenheit geaendert oder entfernt wurde
            pzm_lohnauswertung.set_lz_id_loa_std(:old.ze_pers_nr,
              trunc(:old.ze_schicht_tag),
              v_abwesenheitsarten.lz_id,
              (:old.ze_std * -1), -- (alte) LOA Stunden negativ fuer Abzug
              :old.ze_aa_status,
              false,
              :old.ze_kst_id);
          end if;
        end if;
      end if;
    end if;
  end if;

  if inserting or updating
  then
    if :new.ze_calc_ist_start is not null
       and :new.ze_calc_ist_ende is not null
    then -- wenn die NEUEN (Stempel-)Zeiten bewertet sind ...
      if :new.ze_status in (pzm_p_zeiterfassung.STATUS_ABWESEND, pzm_p_zeiterfassung.STATUS_FEIERTAG)
         and :new.ze_aa_status is not null
      then -- wenn neuer Status 'ABWESEND' ist, und eine Abwesenheitsart gesetzt ist
        if pzm_p_base.get_abwesenheitsart(:new.ze_aa_status, v_abwesenheitsarten)
        then
          if v_abwesenheitsarten.lz_id is not null
          and pzm_p_base.get_lohnart(v_abwesenheitsarten.lz_id, v_lohnart)
          and nvl(v_lohnart.lz_operator, 'xx') != 'ARBSTD' -- Sunden werden in der Lohnabrechnung am Monatsende berechnet
          then
            -- Lohnart hinzufuegen
            pzm_lohnauswertung.set_lz_id_loa_std(:new.ze_pers_nr,
              trunc(:new.ze_schicht_tag),
              v_abwesenheitsarten.lz_id,
              :new.ze_std,
              :new.ze_aa_status,
              false,
              :new.ze_kst_id);
          end if;
        end if;
      end if;
    end if;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZEITERFASSUNG_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"3ee269269e9c3a879085b0db4d021ef4db60af31","type":"TRIGGER","name":"TR_PZM_ZEITERFASSUNG_BUID","schemaName":"DIRKSPZM32","sxml":""}