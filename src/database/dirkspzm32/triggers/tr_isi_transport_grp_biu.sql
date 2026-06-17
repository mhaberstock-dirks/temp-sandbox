
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_GRP_BIU" 
  before update or insert on DIRKSPZM32.ISI_TRANSPORT_GRP
  for each row
declare
  -- local variables here
begin
  if updating
  then
    :new.last_change_date := sysdate;
  end if;

end TR_ISI_TRANSPORT_GRP_Biu;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_TRANSPORT_GRP_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"1c10bfd61a25df3e738373342413d31877b46dd2","type":"TRIGGER","name":"TR_ISI_TRANSPORT_GRP_BIU","schemaName":"DIRKSPZM32","sxml":""}