
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_FIRMA_BU" 
  before update on isi_firma
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
ALTER TRIGGER "TR_ISI_FIRMA_BU" ENABLE;


-- sqlcl_snapshot {"hash":"f48b01a49c89dc69c71a50699bd7103b2631c424","type":"TRIGGER","name":"TR_ISI_FIRMA_BU","schemaName":"DIRKSPZM32","sxml":""}