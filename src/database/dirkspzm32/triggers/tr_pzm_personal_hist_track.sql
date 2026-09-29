
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_PERSONAL_HIST_TRACK" 
  before insert or update
  on pzm_personal 
  for each row
declare
  -- local variables here
begin
  if   nvl(:new.pers_land              ,'#null#')  != nvl(:old.pers_land, '#null#')
    or nvl(:new.pers_region_code       , '#null#') != nvl(:old.pers_region_code, '#null#')
    or nvl(:new.pers_sm_name           , '#null#') != nvl(:old.pers_sm_name, '#null#')
    or nvl(:new.tarif_name             , '#null#') != nvl(:old.tarif_name, '#null#')
    or nvl(:new.pers_pb_id             , -1)!= nvl(:old.pers_pb_id  , -1)
    or nvl(:new.pers_abt_id            , -1)!= nvl(:old.pers_abt_id , -1)
    or nvl(:new.pers_kst_id            , -1)!= nvl(:old.pers_kst_id , -1)
    or nvl(:new.pers_urlaub_anspr_aa_id, -1)!= nvl(:old.pers_urlaub_anspr_aa_id, -1)
    or nvl(:new.pers_eintrittsdatum    , date '0001-01-02')!= nvl(:old.pers_eintrittsdatum, date '0001-01-02')
    or nvl(:new.pers_austrittdatum     , date '0001-01-02')!= nvl(:old.pers_austrittdatum , date '0001-01-02')
    or nvl(:new.pers_befristet_bis     , date '0001-01-02')!= nvl(:old.pers_befristet_bis , date '0001-01-02')
    or nvl(:new.pers_startdatum        , date '0001-01-02')!= nvl(:old.pers_startdatum    , date '0001-01-02')
    or (   nvl(:new.pers_urlaub_anspr_wert , -1) != nvl(:old.pers_urlaub_anspr_wert,-1) 
       and nvl(:new.pers_urlaub_anspr_aa_id, -1) = nvl(:old.pers_urlaub_anspr_aa_id, -1)
       )
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
ALTER TRIGGER "TR_PZM_PERSONAL_HIST_TRACK" ENABLE;


-- sqlcl_snapshot {"hash":"70eda6414638e2f73758a9fc45cb9164e226ce8d","type":"TRIGGER","name":"TR_PZM_PERSONAL_HIST_TRACK","schemaName":"DIRKSPZM32","sxml":""}