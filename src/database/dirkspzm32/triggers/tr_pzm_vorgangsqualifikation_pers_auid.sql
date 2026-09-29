
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_VORGANGSQUALIFIKATION_PERS_AUID" 
  after update or insert or delete
  on PZM_VORGANGSQUALIFIKATION_PERS 
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    update pzm_vorgangsqual_w_plan x
       set x.last_change_date = sysdate,
           x.last_change_login_id = nvl(current_isi_user_login_id(), -1)
     where x.w_plan_pers_nr = :old.pers_nr
       and x.w_plan_vq_id = :old.pers_vq_id;
  end if;
end;
/
ALTER TRIGGER "TR_PZM_VORGANGSQUALIFIKATION_PERS_AUID" ENABLE;


-- sqlcl_snapshot {"hash":"923eb8e6b67386fdbd9424083d8dc2c67cdf3cdc","type":"TRIGGER","name":"TR_PZM_VORGANGSQUALIFIKATION_PERS_AUID","schemaName":"DIRKSPZM32","sxml":""}