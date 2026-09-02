
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_FIRMA_BD" 
  before delete on isi_firma
  for each row
declare
  -- local variables here
begin
  delete isi_adressen
  where adress_id = :old.adress_id;
end TR_ISI_FIRMA_BD;


/
ALTER TRIGGER "TR_ISI_FIRMA_BD" ENABLE;


-- sqlcl_snapshot {"hash":"9a979cbdfcaf02faeb3d1026b02ffe19e7e0fa85","type":"TRIGGER","name":"TR_ISI_FIRMA_BD","schemaName":"DIRKSPZM32","sxml":""}