
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PPS_ARB_PLAN_AG_BIUD" 
  before insert or update or delete on DIRKSPZM32.pps_arb_plan_ag
  for each row
declare
begin
  if deleting
  then
    delete pps_arb_plan_ag_stl t
      where t.arb_plan_id = :old.arb_plan_id
        and t.arb_plan_pos_id = :old.arb_plan_pos_id
        and t.ag_alternative = :old.ag_alternative;
  end if;
end tr_pps_arb_plan_ag_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PPS_ARB_PLAN_AG_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"c269327e57d96c8895d84887438950817350b332","type":"TRIGGER","name":"TR_PPS_ARB_PLAN_AG_BIUD","schemaName":"DIRKSPZM32","sxml":""}