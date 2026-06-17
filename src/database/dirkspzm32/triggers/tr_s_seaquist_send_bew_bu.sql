
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_SEAQUIST_SEND_BEW_BU" 
  after Update on DIRKSPZM32.S_SeaQuist_SEND_BEW
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
ALTER TRIGGER "DIRKSPZM32"."TR_S_SEAQUIST_SEND_BEW_BU" ENABLE;


-- sqlcl_snapshot {"hash":"348737be5abfa1f53c12ad7836e3477027b1b670","type":"TRIGGER","name":"TR_S_SEAQUIST_SEND_BEW_BU","schemaName":"DIRKSPZM32","sxml":""}