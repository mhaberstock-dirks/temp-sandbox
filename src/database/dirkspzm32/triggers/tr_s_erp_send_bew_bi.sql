
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_ERP_SEND_BEW_BI" 
  before insert  on S_ERP_send_bew
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
ALTER TRIGGER "TR_S_ERP_SEND_BEW_BI" ENABLE;


-- sqlcl_snapshot {"hash":"37d2c8d7dace66aa75fab778600c7c8b4a5e8f46","type":"TRIGGER","name":"TR_S_ERP_SEND_BEW_BI","schemaName":"DIRKSPZM32","sxml":""}