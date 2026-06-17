
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PPS_STUECKLISTE_BIUD" 
  before insert or update or delete on DIRKSPZM32.PPS_STUECKLISTE
  for each row
declare
begin
  if deleting
  then
    delete pps_stueckliste_pos t
      where t.stueckliste_id = :old.stueckliste_id;
  end if;
end tr_pps_stueckliste_biud;

/
ALTER TRIGGER "DIRKSPZM32"."TR_PPS_STUECKLISTE_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"498b66019374c253e7d7eeb73177185c843924ab","type":"TRIGGER","name":"TR_PPS_STUECKLISTE_BIUD","schemaName":"DIRKSPZM32","sxml":""}