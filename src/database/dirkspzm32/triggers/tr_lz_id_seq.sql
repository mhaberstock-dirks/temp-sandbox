
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_LZ_ID_SEQ" 
  before insert on DIRKSPZM32."PZM_LOHNARTEN"
  for each row
declare
  -- local variables here
begin
  if :new.lz_id is NULL then
     select seq_lz_id.nextval into :new.lz_id from dual;
  end if;
end tr_lz_id_seq;


/
ALTER TRIGGER "DIRKSPZM32"."TR_LZ_ID_SEQ" ENABLE;


-- sqlcl_snapshot {"hash":"02ee471fe96cd6e4ae4c30587aa5cbb7ddac69a1","type":"TRIGGER","name":"TR_LZ_ID_SEQ","schemaName":"DIRKSPZM32","sxml":""}