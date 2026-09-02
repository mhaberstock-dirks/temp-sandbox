
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PPS_STUECKLISTE_BIUD" 
  before insert or update or delete on PPS_STUECKLISTE
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
ALTER TRIGGER "TR_PPS_STUECKLISTE_BIUD" ENABLE;


-- sqlcl_snapshot {"hash":"d8e2e52918aab13c87e4d33aec6be77a6a7bde95","type":"TRIGGER","name":"TR_PPS_STUECKLISTE_BIUD","schemaName":"DIRKSPZM32","sxml":""}