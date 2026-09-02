
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_ARTIKEL_GRUPPE_BI" 
  before insert on isi_artikel_gruppe
  for each row
begin
  if INSERTING
  then
    if :new.art_gruppe_id is null or :new.art_gruppe_id = 0
    then
      select seq_artikel_gruppe_id.nextval into :new.art_gruppe_id from dual;
    end if;
  end if;
end;


/
ALTER TRIGGER "TR_ISI_ARTIKEL_GRUPPE_BI" ENABLE;


-- sqlcl_snapshot {"hash":"4bfd1322eb903fb157ac910a1921aca11da504ee","type":"TRIGGER","name":"TR_ISI_ARTIKEL_GRUPPE_BI","schemaName":"DIRKSPZM32","sxml":""}