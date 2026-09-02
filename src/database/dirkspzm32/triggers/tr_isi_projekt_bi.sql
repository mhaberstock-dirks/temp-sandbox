
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_PROJEKT_BI" 
  before insert on isi_project
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);
  v_id        isi_purch_kopf.id%Type;
begin
  if inserting
  then
     if :new.create_date is null
     then
       :new.create_date := Sysdate;
     end if;
  end if;
end;


/
ALTER TRIGGER "TR_ISI_PROJEKT_BI" ENABLE;


-- sqlcl_snapshot {"hash":"10109b714141c8e4fa3fc40820662711c1c85bae","type":"TRIGGER","name":"TR_ISI_PROJEKT_BI","schemaName":"DIRKSPZM32","sxml":""}