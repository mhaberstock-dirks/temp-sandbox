
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_VA_ID_SEQ" 
  before insert on DIRKSPZM32.pzm_vertragsarten
  for each row
declare
  -- local variables here
begin
  if :new.va_id is NULL then
     select seq_va_id.nextval into :new.va_id from dual;
  end if;
end tr_va_id_seq;

/
ALTER TRIGGER "DIRKSPZM32"."TR_VA_ID_SEQ" ENABLE;


-- sqlcl_snapshot {"hash":"d43fa08cdb00272bf37155b33209a20b3531420d","type":"TRIGGER","name":"TR_VA_ID_SEQ","schemaName":"DIRKSPZM32","sxml":""}