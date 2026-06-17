
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_S_ESSEX_SEND_BEW" 
  before insert or update on DIRKSPZM32.s_essex_send_bew
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
ALTER TRIGGER "DIRKSPZM32"."TR_S_ESSEX_SEND_BEW" ENABLE;


-- sqlcl_snapshot {"hash":"7052de237e8e2b27f07bf3ee5ef14f1d72e7590a","type":"TRIGGER","name":"TR_S_ESSEX_SEND_BEW","schemaName":"DIRKSPZM32","sxml":""}