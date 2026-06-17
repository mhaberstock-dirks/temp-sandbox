
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_FIRMA_BU" 
  before update on DIRKSPZM32.isi_firma
  for each row
declare
  -- local variables here
begin
  update isi_adressen a
    set a.sid = :new.sid,
        a.firma_nr = :new.firma_nr,
        a.adr_nr = :new.firma_nr
  where a.adress_id = :new.adress_id;
end TR_ISI_FIRMA_BU;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_FIRMA_BU" ENABLE;


-- sqlcl_snapshot {"hash":"c997aa05aed0e30c80bd67843fe1e30d6acd49a1","type":"TRIGGER","name":"TR_ISI_FIRMA_BU","schemaName":"DIRKSPZM32","sxml":""}