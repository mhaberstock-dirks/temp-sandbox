
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LVS_LTE_BI" 
  before insert on DIRKSPZM32.lvs_lte
  for each row
declare
  -- local variables here
begin
  delete lvs_lte_hist t
   where t.lte_id = :new.lte_id;
  if  :new.order_auf_id is NULL
  and :old.order_auf_id = -1
  then
    update lvs_lam lam
       set lam.order_pos_auf_id = NULL
     where lam.lte_id = :new.lte_id
       and lam.order_pos_auf_id = -1;
  end if;
  if :new.res_string is NULL
  and :new.lte_akt_lhm = 0         -- c.LEERPAL
  then
    :new.res_string := :new.lte_name;    -- -AG- Fuer Leerbehältereinlagerung und Gleichverteilung
  end if;
end tr_lvs_lte_bi;

/
ALTER TRIGGER "DIRKSPZM32"."TR_LVS_LTE_BI" ENABLE;


-- sqlcl_snapshot {"hash":"f67f8ed2ddf7b262b3c17fe29953bfd1b62ebf7b","type":"TRIGGER","name":"TR_LVS_LTE_BI","schemaName":"DIRKSPZM32","sxml":""}