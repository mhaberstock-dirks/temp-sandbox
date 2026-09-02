
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LVS_LTE_BI" 
  before insert on lvs_lte
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
ALTER TRIGGER "TR_LVS_LTE_BI" ENABLE;


-- sqlcl_snapshot {"hash":"6adbfea2d6e01c9629f1ac9b26d43077f446bc11","type":"TRIGGER","name":"TR_LVS_LTE_BI","schemaName":"DIRKSPZM32","sxml":""}