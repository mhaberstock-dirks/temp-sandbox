
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PPS_STUECKLISTE_POS_BIUD" 
  before insert or update or delete on DIRKSPZM32.pps_stueckliste_pos
  for each row
declare
begin
  if deleting
  then
    delete pps_arb_plan_ag_stl t
      where t.stueckliste_pos_id = :old.stueckliste_pos_id;
  end if;
end tr_pps_stueckliste_pos_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PPS_STUECKLISTE_POS_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"1e6c28e7f591cbcec5b228e294c68cf667772493","type":"TRIGGER","name":"TR_PPS_STUECKLISTE_POS_BIUD","schemaName":"DIRKSPZM32","sxml":""}