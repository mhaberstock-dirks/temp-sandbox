
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_BUI" 
  before insert or update on DIRKSPZM32.isi_artikel
  for each row
declare
  -- local variables here
begin
  if INSERTING
  then
    if nvl(:new.artikel_id, 0) = 0
    then
      select seq_artikel_id.nextval into :new.artikel_id from dual;
    end if;

    if :new.artikel_id = -1
    then
      :new.artikel_id := 0;
    end if;

--  elsif UPDATING
--    Hier kommt die Abhandlung, wenn Äderungen von Artikel gespeichert werden sollen
--    if then
--
--    end if;
  end if;

  if :new.menge_basis = c.BASIS_LHM
  then
    :new.mengeneinheit_basis := :new.lhm_name;
  elsif :new.menge_basis = c.BASIS_LTE
  then
    :new.mengeneinheit_basis := :new.lte_name;
  else
    :new.mengeneinheit_basis := :new.mengeneinheit;
  end if;
end;

/
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_BUI" ENABLE;


-- sqlcl_snapshot {"hash":"c75f95e3a7a94e5db211702fa1b97e8b42636621","type":"TRIGGER","name":"TR_ISI_ARTIKEL_BUI","schemaName":"DIRKSPZM32","sxml":""}