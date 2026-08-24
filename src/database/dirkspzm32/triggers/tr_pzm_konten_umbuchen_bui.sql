
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_UMBUCHEN_BUI" 
  before insert or update on DIRKSPZM32.PZM_KONTEN_UMBUCHEN
  for each row

declare  
  v_k_typ_anz     integer;  
  v_q_typ_ok      boolean;
  v_z_typ_ok      boolean;
begin

  if inserting
  then
    pzm_p_log.log_data(
      p_level       => pzm_p_log.LEVEL_INFO,
      p_message     => 'Automatische Umbuchung: Neuer Eintrag' ||
                       ', SID=' || :new.sid
                        || ', Firma=' || :new.firma_nr
                        || ', Name=' || :new.Name
                        || ', TYP_STATUS=' || :new.typ_status,
      p_category    => pzm_p_log.CAT_SYSTEM,
      p_module      => 'TR_PZM_KONTEN_UMBUCHEN_BUI',
      p_pers_nr     => NULL,
      p_schicht_tag => NULL,
      p_quelle      => pzm_p_zeiterfassung.QUELLE_SYSTEM
    );  
    if :new.created_date is NULL then -- Erstellungsdatum setzen (wird eigentlich bei INSERT als DEFAULT bereits gesetzt)
      :new.created_date := sysdate;
    end if;

    if :new.created_login_id is NULL then -- Versuchen den ISI_USER aus 
      :new.created_login_id := current_isi_user_login_id();
    end if;
  end if;

  if updating
  then
    pzm_p_log.log_data(
      p_level       => pzm_p_log.LEVEL_INFO,
      p_message     => 'Automatische Umbuchung: Ändern Eintrag' ||
                       ', SID=' || :new.sid
                        || ', Firma=' || :new.firma_nr
                        || ', Name=' || :new.Name
                        || ', TYP_STATUS=' || :new.typ_status,
      p_category    => pzm_p_log.CAT_SYSTEM,
      p_module      => 'TR_PZM_KONTEN_UMBUCHEN_BUI',
      p_pers_nr     => NULL,
      p_schicht_tag => NULL,
      p_quelle      => pzm_p_zeiterfassung.QUELLE_SYSTEM
    );  
    :new.last_change_date := sysdate;
    :new.last_change_login_id := current_isi_user_login_id();
  end if;
  
  select count(k.name_kurz) into v_k_typ_anz from pzm_konten_cfg k where k.name_kurz = :new.von_konto_name_kurz;
  if nvl(v_k_typ_anz, 0) > 0
  then
    v_q_typ_ok := true;
  else
    v_q_typ_ok := false;
  end if;
  select count(k.name_kurz) into v_k_typ_anz from pzm_konten_cfg k where k.name_kurz = :new.nach_konto_name_kurz;
  if nvl(v_k_typ_anz, 0) > 0
  then
    v_z_typ_ok := true;
  else
    v_z_typ_ok := false;
  end if;
  
  
  -- Prüfen Kontotyp Quelle
  if v_q_typ_ok = false
  then
    pzm_p_log.error('Für den Konto-Typ Quelle ' || :new.von_konto_name_kurz || ' ist keine Konfiguration vorhanden',
                    pzm_p_log.CAT_SYSTEM, 
                    'TR_PZM_KONTEN_UMBUCHEN_BUI',
                    -20010);
    pzm_p_lc.raise_app_error(-20010, 'Für den Konto-Typ Quelle ' || :new.von_konto_name_kurz || ' ist keine Konfiguration vorhanden');
  -- Prüfen Kontotyp Ziel
  elsif v_z_typ_ok = false
  then
    pzm_p_log.error('Für den Konto-Typ Ziel ' || :new.nach_konto_name_kurz || ' ist keine Konfiguration vorhanden',
                    pzm_p_log.CAT_SYSTEM, 
                    'TR_PZM_KONTEN_UMBUCHEN_BUI',
                    -20010);
    pzm_p_lc.raise_app_error(-20010, 'Für den Konto-Typ Ziel ' || :new.nach_konto_name_kurz || ' ist keine Konfiguration vorhanden');
  -- Prüfen der Kombination von Tagesstunden
  elsif      :new.buch_wert > 0
  and (   :new.buch_wot_mo_wert is not NULL
       or :new.buch_wot_di_wert is not NULL
       or :new.buch_wot_mi_wert is not NULL
       or :new.buch_wot_do_wert is not NULL
       or :new.buch_wot_fr_wert is not NULL
       or :new.buch_wot_sa_wert is not NULL
       or :new.buch_wot_so_wert is not NULL)
  then
    pzm_p_log.error('Kombination von Tagesstunden und generelle Stunden nicht zulässig.',
                    pzm_p_log.CAT_SYSTEM, 
                    'TR_PZM_KONTEN_UMBUCHEN_BUI',
                    -20010);
    pzm_p_lc.raise_app_error(-20010, 'Kombination von Tagesstunden und generelle Stunden nicht zulässig.');
  -- Prüfen das mindestens ein Wert gesetzt ist
  elsif      nvl(:new.buch_wert, 0) = 0
  and :new.buch_wot_mo_wert is NULL
  and :new.buch_wot_di_wert is NULL
  and :new.buch_wot_mi_wert is NULL
  and :new.buch_wot_do_wert is NULL
  and :new.buch_wot_fr_wert is NULL
  and :new.buch_wot_sa_wert is NULL
  and :new.buch_wot_so_wert is NULL
  then
    pzm_p_log.error('Es  nicht zulässig, dass keine Werte erfasst sind.',
                    pzm_p_log.CAT_SYSTEM, 
                    'TR_PZM_KONTEN_UMBUCHEN_BUI',
                    -20010);
    pzm_p_lc.raise_app_error(-20010, 'Es  nicht zulässig, dass keine Werte erfasst sind.');
  else
    pzm_p_log.log_data(
      p_level       => pzm_p_log.LEVEL_INFO,
      p_message     => 'Automatische Umbuchung: Eintrag erfolgreich gespeichert' ||
                       ', SID=' || :new.sid
                        || ', Firma=' || :new.firma_nr
                        || ', Name=' || :new.Name
                        || ', TYP_STATUS=' || :new.typ_status,
      p_category    => pzm_p_log.CAT_SYSTEM,
      p_module      => 'TR_PZM_KONTEN_UMBUCHEN_BUI',
      p_pers_nr     => NULL,
      p_schicht_tag => NULL,
      p_quelle      => pzm_p_zeiterfassung.QUELLE_SYSTEM
    );  
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_UMBUCHEN_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"8583657aff0c25cadb8d585b27740d580c8a5358","type":"TRIGGER","name":"TR_PZM_KONTEN_UMBUCHEN_BUI","schemaName":"DIRKSPZM32","sxml":""}