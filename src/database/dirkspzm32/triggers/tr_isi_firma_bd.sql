
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_FIRMA_BD" 
  before delete on DIRKSPZM32.isi_firma
  for each row
declare
  -- local variables here
begin
  delete isi_adressen
  where adress_id = :old.adress_id;
end TR_ISI_FIRMA_BD;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_FIRMA_BD" ENABLE;


-- sqlcl_snapshot {"hash":"82f86b32408d2777fc9c7fbab67a5cebbc391f9e","type":"TRIGGER","name":"TR_ISI_FIRMA_BD","schemaName":"DIRKSPZM32","sxml":""}