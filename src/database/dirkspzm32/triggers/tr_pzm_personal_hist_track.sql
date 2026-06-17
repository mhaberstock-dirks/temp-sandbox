
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_PERSONAL_HIST_TRACK" 
  before insert or update
  on DIRKSPZM32.pzm_personal 
  for each row
declare
  -- local variables here
begin
  if :new.pers_land != :old.pers_land
    or :new.pers_region_code != :old.pers_region_code
    or :new.pers_pb_id != :old.pers_pb_id
    or :new.pers_abt_id != :old.pers_abt_id
    or :new.pers_kst_id != :old.pers_kst_id
    or :new.pers_eintrittsdatum != :old.pers_eintrittsdatum
    or :new.pers_austrittdatum != :old.pers_austrittdatum
    or :new.pers_sm_name != :old.pers_sm_name
    or :new.pers_befristet_bis != :old.pers_befristet_bis
    or (:new.pers_urlaub_anspr_wert != :old.pers_urlaub_anspr_wert and :new.pers_urlaub_anspr_aa_id = :old.pers_urlaub_anspr_aa_id)
    or :new.pers_urlaub_anspr_aa_id != :old.pers_urlaub_anspr_aa_id
    or :new.pers_startdatum != :old.pers_startdatum
    or :new.tarif_name != :old.tarif_name
    then
      insert into pzm_personal_hist
        (pers_nr, 
         pers_land, 
         pers_region_code, 
         pers_pb_id, 
         pers_abt_id, 
         pers_kst_id, 
         pers_eintrittsdatum, 
         pers_austrittdatum, 
         pers_sm_name, 
         pers_befristet_bis, 
         pers_urlaub_anspr_wert, 
         pers_urlaub_anspr_aa_id, 
         pers_startdatum, 
         tarif_name, 
         old_land, 
         old_region_code, 
         old_pb_id, 
         old_abt_id, 
         old_kst_id, 
         old_eintrittsdatum, 
         old_austrittdatum, 
         old_sm_name, 
         old_befristet_bis, 
         old_urlaub_anspr_wert, 
         old_urlaub_anspr_aa_id, 
         old_startdatum, 
         old_tarif_name, 
         created_date, 
         created_login_id)
      values
        (:new.pers_nr, 
         :new.pers_land, 
         :new.pers_region_code, 
         :new.pers_pb_id, 
         :new.pers_abt_id, 
         :new.pers_kst_id, 
         :new.pers_eintrittsdatum, 
         :new.pers_austrittdatum, 
         :new.pers_sm_name, 
         :new.pers_befristet_bis, 
         :new.pers_urlaub_anspr_wert, 
         :new.pers_urlaub_anspr_aa_id, 
         :new.pers_startdatum, 
         :new.tarif_name, 
         :old.pers_land, 
         :old.pers_region_code, 
         :old.pers_pb_id, 
         :old.pers_abt_id, 
         :old.pers_kst_id, 
         :old.pers_eintrittsdatum, 
         :old.pers_austrittdatum, 
         :old.pers_sm_name, 
         :old.pers_befristet_bis, 
         :old.pers_urlaub_anspr_wert, 
         :old.pers_urlaub_anspr_aa_id, 
         :old.pers_startdatum, 
         :old.tarif_name, 
         sysdate, 
         :new.last_change_login_id);
    end if;
end TR_PZM_PERSONAL_HIST_TRACK;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_PERSONAL_HIST_TRACK" ENABLE;


-- sqlcl_snapshot {"hash":"74dc75b288663e18c84bc0a31afe0071a8066d38","type":"TRIGGER","name":"TR_PZM_PERSONAL_HIST_TRACK","schemaName":"DIRKSPZM32","sxml":""}