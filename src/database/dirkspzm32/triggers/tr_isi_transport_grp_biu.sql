
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_TRANSPORT_GRP_BIU" 
  before update or insert on ISI_TRANSPORT_GRP
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
ALTER TRIGGER "TR_ISI_TRANSPORT_GRP_BIU" ENABLE;


-- sqlcl_snapshot {"hash":"c284c390743f0a99c0192986f5a02b2a3d869f17","type":"TRIGGER","name":"TR_ISI_TRANSPORT_GRP_BIU","schemaName":"DIRKSPZM32","sxml":""}