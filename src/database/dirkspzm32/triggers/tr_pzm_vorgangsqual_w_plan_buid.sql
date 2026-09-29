
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_VORGANGSQUAL_W_PLAN_BUID" 
  before update or insert or delete
  on PZM_VORGANGSQUAL_W_PLAN 
  for each row
declare
  -- local variables here
  v_valide_result                     pzm_vorgangsqual_w_plan_val_ref.valid_ref_kurz%type;
  v_vorgangsqual_w_plan_val_ref       pzm_vorgangsqual_w_plan_val_ref%rowtype;
  
  CURSOR c_vorgangsqual_w_plan_val_ref is
    select *
      from pzm_vorgangsqual_w_plan_val_ref t
     where t.valid_ref_kurz = v_valide_result;
begin
  if inserting or updating
  then
    v_valide_result := pzm_schicht_planung.pruefe_schicht_plan_eintrag(
      in_pers_nr => :new.w_plan_pers_nr,
      in_vq_id => :new.w_plan_vq_id,
      in_schicht_tag => :new.w_plan_datum,
      in_start => :new.w_plan_von_zeit,
      in_ende => :new.w_plan_bis_zeit);
    OPEN c_vorgangsqual_w_plan_val_ref;
    FETCH c_vorgangsqual_w_plan_val_ref into v_vorgangsqual_w_plan_val_ref;
    if c_vorgangsqual_w_plan_val_ref%NOTFOUND
    then
      v_vorgangsqual_w_plan_val_ref.valid_ref_kurz := v_valide_result;
      v_vorgangsqual_w_plan_val_ref.valid_ref_valide := 0;
      v_vorgangsqual_w_plan_val_ref.valid_ref_beschreibung := 'ERROR';
    end if;
    CLOSE c_vorgangsqual_w_plan_val_ref;
  end if;
  
  if updating or inserting
  then
    update pzm_vorgangsqual_w_plan_valide x
        set x.w_plan_v_eintrag_valide = v_vorgangsqual_w_plan_val_ref.valid_ref_valide,             -- v_w_plan_liste v_w_plan_eintrag_valide, 
            x.w_plan_v_valalid_beschreibung_kurz = v_vorgangsqual_w_plan_val_ref.valid_ref_kurz,    -- v_w_plan_valalid_beschreibung_kurz, 
            x.w_plan_v_valalid_beschreibung = v_vorgangsqual_w_plan_val_ref.valid_ref_beschreibung  -- v_w_plan_liste v_w_plan_valalid_beschreibung, 
    where x.w_plan_start = :new.w_plan_start 
      and x.w_plan_vq_id = :new.w_plan_vq_id                                     -- v_w_plan_vq_id, 
      and x.w_plan_datum = :new.w_plan_datum                                     -- v_w_plan_datum, 
      and x.w_plan_schicht = :new.w_plan_schicht                                 -- v_w_plan_schicht, 
      and ((x.w_plan_von_zeit <= :new.w_plan_von_zeit and x.w_plan_bis_zeit >= :new.w_plan_bis_zeit) -- Zeit passt genau onde liegt in der Zeit
        or (x.w_plan_von_zeit <= :new.w_plan_von_zeit and x.w_plan_bis_zeit > :new.w_plan_von_zeit)  -- Zeit ragt nach dem Begin in die Zeit
        or (x.w_plan_von_zeit > :new.w_plan_von_zeit and x.w_plan_von_zeit < :new.w_plan_bis_zeit))  -- Zeit bigint in der Zeit 
      and x.w_plan_einsatz_nr = :new.w_plan_einsatz_nr                               -- v_w_plan_einsatz_nr,
      and x.w_plan_pers_nr = :new.w_plan_pers_nr
      and x.w_plan_v_check_nr = 1
      and x.w_plan_id != :new.w_plan_id;
  end if;
  
  if updating
  then
    :new.last_change_date := sysdate;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    update pzm_vorgangsqual_w_plan_valide x
        set x.w_plan_v_check_nr = x.w_plan_v_check_nr + 1     -- Ggf. für den aktuellen Eintrag alle Valide Saetze in der Check-Nummer eine hochsetzten
      where x.w_plan_id = :new.w_plan_id;
    
    insert into pzm_vorgangsqual_w_plan_valide                -- Neuen Eintrag in dem Valide Check eintragen
    values
      (NULL,                                                  -- ID wird im Trigger gesetzt
       :new.w_plan_id,                                        -- PK des fuehrenden Datensatz
       :new.w_plan_start, 
       :new.w_plan_vq_id,                                     -- v_w_plan_vq_id, 
       :new.w_plan_datum,                                     -- v_w_plan_datum, 
       :new.w_plan_schicht,                                   -- v_w_plan_schicht, 
       :new.w_plan_von_zeit,                                  -- v_w_plan_von_zeit, 
       :new.w_plan_bis_zeit,                                  -- v_w_plan_bis_zeit, 
       :new.w_plan_einsatz_nr,                                -- v_w_plan_einsatz_nr,
       :new.w_plan_pers_nr,
       1,                                                     -- v_w_plan_v_check_nr, 
       v_vorgangsqual_w_plan_val_ref.valid_ref_valide,        -- v_w_plan_liste v_w_plan_eintrag_valide, 
       v_vorgangsqual_w_plan_val_ref.valid_ref_kurz,          -- v_w_plan_valalid_beschreibung_kurz, 
       v_vorgangsqual_w_plan_val_ref.valid_ref_beschreibung,  -- v_w_plan_liste v_w_plan_valalid_beschreibung, 
       sysdate,                                               -- v_created_date, 
       nvl(current_isi_user_login_id(), -1),                  -- v_created_login_id, 
       NULL,                                                  -- v_last_change_date, 
       NULL                                                   -- v_last_change_login_id
       );
  end if;

  if inserting
  then
    select SEQ_PZM_W_PLAN_ID.Nextval into :new.w_plan_id from dual;
    insert into pzm_vorgangsqual_w_plan_valide
    values
      (NULL,                                                  -- ID wird im Trigger gesetzt
       :new.w_plan_id,                                        -- PK des fuehrenden Datensatz
       :new.w_plan_start, 
       :new.w_plan_vq_id,                                     -- v_w_plan_vq_id, 
       :new.w_plan_datum,                                     -- v_w_plan_datum, 
       :new.w_plan_schicht,                                   -- v_w_plan_schicht, 
       :new.w_plan_von_zeit,                                  -- v_w_plan_von_zeit, 
       :new.w_plan_bis_zeit,                                  -- v_w_plan_bis_zeit, 
       :new.w_plan_einsatz_nr,                                -- v_w_plan_einsatz_nr,
       :new.w_plan_pers_nr,
       1,                                                     -- v_w_plan_v_check_nr, 
       v_vorgangsqual_w_plan_val_ref.valid_ref_valide,        -- v_w_plan_liste v_w_plan_eintrag_valide, 
       v_vorgangsqual_w_plan_val_ref.valid_ref_kurz,          -- v_w_plan_valalid_beschreibung_kurz, 
       v_vorgangsqual_w_plan_val_ref.valid_ref_beschreibung,  -- v_w_plan_liste v_w_plan_valalid_beschreibung, 
       sysdate,                                               -- v_created_date, 
       nvl(current_isi_user_login_id(), -1),                  -- v_created_login_id, 
       NULL,                                                  -- v_last_change_date, 
       NULL                                                   -- v_last_change_login_id
       );
  end if;

  if deleting 
  then
    delete pzm_vorgangsqual_w_plan_valide t
      where t.w_plan_id = :old.w_plan_id;
  end if;
end;
/
ALTER TRIGGER "TR_PZM_VORGANGSQUAL_W_PLAN_BUID" ENABLE;


-- sqlcl_snapshot {"hash":"b4141703ad2fba9b141635f60836619a0f215025","type":"TRIGGER","name":"TR_PZM_VORGANGSQUAL_W_PLAN_BUID","schemaName":"DIRKSPZM32","sxml":""}