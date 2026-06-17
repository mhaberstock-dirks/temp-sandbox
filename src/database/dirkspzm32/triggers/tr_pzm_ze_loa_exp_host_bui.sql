
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_EXP_HOST_BUI" 
  before insert or update on DIRKSPZM32.PZM_ZE_LOA_EXP_HOST
  for each row
declare
begin

  if inserting
  then
    if :new.created_date is NULL
    then
      :new.created_date := sysdate;
    end if;
    :new.created_login_id := nvl(current_isi_user_login_id(), -1);
    :new.created_user := current_isi_user();
  else
    if :new.last_change_date is NULL
    then
      :new.last_change_date := sysdate;
    end if;
    :new.last_change_login_id := nvl(current_isi_user_login_id(), -1);
    :new.last_change_user := current_isi_user();
    if :new.status != :old.status
    then
      update pzm_ze_loa_statistik_exp_host x
         set x.status = :new.status,
             x.ret_code = :new.ret_code,
             x.err_text = :new.err_text,
             x.cycle = :new.cycle,
             x.last_change_date = :new.last_change_date,
             x.last_change_login_id = :new.last_change_login_id,
             x.last_change_user = :new.last_change_user
       where x.pers_nr = :new.pers_nr
         and x.datum = :new.datum
         and x.status != :new.status;
    end if;
  end if;


end;


/
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_ZE_LOA_EXP_HOST_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"3b4964c8df00531b3bd2fbc37c52e592a6973aef","type":"TRIGGER","name":"TR_PZM_ZE_LOA_EXP_HOST_BUI","schemaName":"DIRKSPZM32","sxml":""}