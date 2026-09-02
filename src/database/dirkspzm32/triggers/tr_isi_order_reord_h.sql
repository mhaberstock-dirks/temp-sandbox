
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_ORDER_REORD_H" 
  before insert on isi_order_reord_h
  for each row
declare
  -- local variables here
begin
  if inserting
  then
    if :new.reord_id is null
    then
      select seq_reord_id.nextval into :new.reord_id from dual;
    end if;
  end if;
end tr_isi_order_reord_h;


/
ALTER TRIGGER "TR_ISI_ORDER_REORD_H" ENABLE;


-- sqlcl_snapshot {"hash":"3970d32e7d56157c32effe3809d7e979581f2aa8","type":"TRIGGER","name":"TR_ISI_ORDER_REORD_H","schemaName":"DIRKSPZM32","sxml":""}