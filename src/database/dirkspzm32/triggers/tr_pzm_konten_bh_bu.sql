
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_PZM_KONTEN_BH_BU" 
  before update on pzm_konten_bh
  for each row
declare
  -- Lokale Variablen
begin
  if :new.wert != :new.wert
  then
    raise_application_error(-20000, 'Anpassen eines Buchungswertes ist nicht möglich. Bitte Stornierung oder Korrekturbuchung benutzen.');
  end if;
end tr_pzm_konten_bh_bu;


/
ALTER TRIGGER "TR_PZM_KONTEN_BH_BU" ENABLE;


-- sqlcl_snapshot {"hash":"ab5e7d22bed827d7dc48d31acb0db69883af4a6f","type":"TRIGGER","name":"TR_PZM_KONTEN_BH_BU","schemaName":"DIRKSPZM32","sxml":""}