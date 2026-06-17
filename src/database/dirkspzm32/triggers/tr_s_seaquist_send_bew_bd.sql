
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_SEAQUIST_SEND_BEW_BD" 
  after delete on DIRKSPZM32.S_SeaQuist_SEND_BEW
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
ALTER TRIGGER "DIRKSPZM32"."TR_S_SEAQUIST_SEND_BEW_BD" ENABLE;


-- sqlcl_snapshot {"hash":"c851526122ec67d453fe118708bfa54835889b37","type":"TRIGGER","name":"TR_S_SEAQUIST_SEND_BEW_BD","schemaName":"DIRKSPZM32","sxml":""}