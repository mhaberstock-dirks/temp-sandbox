
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_GRUPPE_BI" 
  before insert on DIRKSPZM32.isi_artikel_gruppe
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_ARTIKEL_GRUPPE_BI" ENABLE;


-- sqlcl_snapshot {"hash":"1f27b77640c0f8cf4069057362074530d29ec706","type":"TRIGGER","name":"TR_ISI_ARTIKEL_GRUPPE_BI","schemaName":"DIRKSPZM32","sxml":""}