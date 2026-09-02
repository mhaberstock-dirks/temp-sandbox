
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_LZ_ID_SEQ" 
  before insert on "PZM_LOHNARTEN"
  for each row
declare
  -- local variables here
begin
  if :new.lz_id is NULL then
     select seq_lz_id.nextval into :new.lz_id from dual;
  end if;
end tr_lz_id_seq;



/
ALTER TRIGGER "TR_LZ_ID_SEQ" ENABLE;


-- sqlcl_snapshot {"hash":"2ce292db3ad1d8446fcd3f5a3de7a10d2f34ecb7","type":"TRIGGER","name":"TR_LZ_ID_SEQ","schemaName":"DIRKSPZM32","sxml":""}