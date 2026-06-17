
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_REORD_H" 
  before insert on DIRKSPZM32.isi_order_reord_h
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ORDER_REORD_H" ENABLE;


-- sqlcl_snapshot {"hash":"c599adec77067e8d3a8627591d29919176338538","type":"TRIGGER","name":"TR_ISI_ORDER_REORD_H","schemaName":"DIRKSPZM32","sxml":""}