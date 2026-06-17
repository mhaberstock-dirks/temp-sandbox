
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PPS_PLAN_AUFTRAG_AG_BD" 
  before delete on DIRKSPZM32.pps_plan_auftrag_ag
  for each row
declare

begin

  delete pps_plan_auftrag_ag_stl t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_ag_id = :old.plan_auf_ag_id;

  delete pps_plan_auftrag_ag_res t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_ag_id = :old.plan_auf_ag_id;

  delete pps_plan_auftrag_ag_fhm t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_ag_id = :old.plan_auf_ag_id;

end tr_pps_plan_auftrag_bd;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PPS_PLAN_AUFTRAG_AG_BD" ENABLE;


-- sqlcl_snapshot {"hash":"7098451548a90ec918cc546bec62a85015daca98","type":"TRIGGER","name":"TR_PPS_PLAN_AUFTRAG_AG_BD","schemaName":"DIRKSPZM32","sxml":""}