
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_SEAQUIST_SEND_BEW_BD" 
  after delete on S_SeaQuist_SEND_BEW
  for each row
declare
begin
  if :old.status = 'L'
  then
    delete s_send_bew
     where s_send_bew.bew_id = :old.BEW_ID;
  end if;
end;


/
ALTER TRIGGER "TR_S_SEAQUIST_SEND_BEW_BD" ENABLE;


-- sqlcl_snapshot {"hash":"b393fbc4f8e73b970e13c0d7126aeb9020760e8d","type":"TRIGGER","name":"TR_S_SEAQUIST_SEND_BEW_BD","schemaName":"DIRKSPZM32","sxml":""}