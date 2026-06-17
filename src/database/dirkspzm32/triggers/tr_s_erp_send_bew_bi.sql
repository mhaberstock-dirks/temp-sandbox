
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ERP_SEND_BEW_BI" 
  before insert  on DIRKSPZM32.S_ERP_send_bew
  for each row
declare
begin

  if inserting
  then

    If :new.herkunft is null
    then
      :new.herkunft := 'ISI';
    end if;
  end if;
end TR_S_ERP_send_bew_BI;

/
ALTER TRIGGER "DIRKSPZM32"."TR_S_ERP_SEND_BEW_BI" ENABLE;


-- sqlcl_snapshot {"hash":"4234abbe4289c08dc1fdf35d05f1c89e7feedbce","type":"TRIGGER","name":"TR_S_ERP_SEND_BEW_BI","schemaName":"DIRKSPZM32","sxml":""}