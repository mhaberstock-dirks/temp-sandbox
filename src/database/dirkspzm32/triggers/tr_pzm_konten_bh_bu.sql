
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_BH_BU" 
  before update on DIRKSPZM32.pzm_konten_bh
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
ALTER TRIGGER "DIRKSPZM32"."TR_PZM_KONTEN_BH_BU" ENABLE;


-- sqlcl_snapshot {"hash":"fe8600784600eac1219e7c5acb93794a07fa3c9f","type":"TRIGGER","name":"TR_PZM_KONTEN_BH_BU","schemaName":"DIRKSPZM32","sxml":""}