
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_VA_ID_SEQ" 
  before insert on pzm_vertragsarten
  for each row
declare
  -- local variables here
begin
  if :new.va_id is NULL then
     select seq_va_id.nextval into :new.va_id from dual;
  end if;
end tr_va_id_seq;


/
ALTER TRIGGER "TR_VA_ID_SEQ" ENABLE;


-- sqlcl_snapshot {"hash":"5e056c98ed73f733cd918f252001a04d426fc910","type":"TRIGGER","name":"TR_VA_ID_SEQ","schemaName":"DIRKSPZM32","sxml":""}