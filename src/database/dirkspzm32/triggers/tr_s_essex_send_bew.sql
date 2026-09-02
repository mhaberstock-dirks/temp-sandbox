
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_S_ESSEX_SEND_BEW" 
  before insert or update on s_essex_send_bew
  for each row
begin
  if inserting
  then
    select seq_s_send_bew_id.nextval into :new.send_id from dual;
    :new.send_status := 'N';
    :new.send_ts := sysdate;
    :new.firma_nr := 1;
    if :new.lhm_id is NULL
    then
      :new.lhm_id := '0';
    end if;
    if :new.lte_id is NULL
    then
      :new.lte_id := '0';
    end if;

  end if;

end ;


/
ALTER TRIGGER "TR_S_ESSEX_SEND_BEW" ENABLE;


-- sqlcl_snapshot {"hash":"80283c383cee26090bf90e06209ca6b9f9702b6b","type":"TRIGGER","name":"TR_S_ESSEX_SEND_BEW","schemaName":"DIRKSPZM32","sxml":""}