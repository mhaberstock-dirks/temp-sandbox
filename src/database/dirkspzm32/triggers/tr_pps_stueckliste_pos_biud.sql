
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PPS_STUECKLISTE_POS_BIUD" 
  before insert or update or delete on pps_stueckliste_pos
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
ALTER TRIGGER "TR_PPS_STUECKLISTE_POS_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"cd6764d96925d4788440e8ad51dd54366d5364f9","type":"TRIGGER","name":"TR_PPS_STUECKLISTE_POS_BIUD","schemaName":"DIRKSPZM32","sxml":""}