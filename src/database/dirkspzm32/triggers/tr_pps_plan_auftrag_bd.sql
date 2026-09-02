
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PPS_PLAN_AUFTRAG_BD" 
  before delete on pps_plan_auftrag
  for each row
declare

begin
  delete pps_plan_auftrag_stl t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_id = :old.plan_auf_id;

  delete pps_plan_auftrag_ag_stl t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_ag_id  in (select t2.plan_auf_ag_id
                                  from pps_plan_auftrag_ag t2
                                 where t2.sid = :old.sid
                                   and t2.firma_nr = :old.firma_nr
                                   and t2.plan_auf_id = :old.plan_auf_id);

  delete pps_plan_auftrag_ag_res t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_id = :old.plan_auf_id;

  delete pps_plan_auftrag_ag_fhm t
    where t.sid = :old.sid
      and t.firma_nr = :old.firma_nr
      and t.plan_auf_id = :old.plan_auf_id;

  delete pps_plan_auftrag_ag t2
   where t2.sid = :old.sid
     and t2.firma_nr = :old.firma_nr
     and t2.plan_auf_id = :old.plan_auf_id;

end tr_pps_plan_auftrag_bd;


/
ALTER TRIGGER "TR_PPS_PLAN_AUFTRAG_BD" ENABLE;


-- sqlcl_snapshot {"hash":"8337965ba4864a392f0de6b24650f572864aa4e9","type":"TRIGGER","name":"TR_PPS_PLAN_AUFTRAG_BD","schemaName":"DIRKSPZM32","sxml":""}