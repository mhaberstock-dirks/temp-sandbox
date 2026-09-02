
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_SEAQUIST_SEND_BEW_BU" 
  after Update on S_SeaQuist_SEND_BEW
  for each row
declare
begin
  if :new.status = 'L'
  then
    delete s_send_bew
     where s_send_bew.bew_id = :new.BEW_ID;
  end if;
end;


/
ALTER TRIGGER "TR_S_SEAQUIST_SEND_BEW_BU" ENABLE;


-- sqlcl_snapshot {"hash":"8c2b538b2f857b28603bfed27190d3e96432de20","type":"TRIGGER","name":"TR_S_SEAQUIST_SEND_BEW_BU","schemaName":"DIRKSPZM32","sxml":""}