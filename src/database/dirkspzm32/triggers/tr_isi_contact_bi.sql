
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_ISI_CONTACT_BI" 
  before insert on isi_contact
  for each row
declare
  -------------------------------------------------------------------------------------------------------
  -- Standard Fehler Felder für Exception
  -------------------------------------------------------------------------------------------------------
  v_error     EXCEPTION;
  v_err_nr    number;
  v_err_text  varchar2(255);
  v_id        isi_contact.contact_id%Type;
begin
  if inserting
  then
     select seq_isi_contact.nextval into v_id from dual;
     :new.contact_Id := v_id;
     if :new.create_date is null
     then
       :new.create_date := Sysdate;
     end if;
  end if;
end;


/
ALTER TRIGGER "TR_ISI_CONTACT_BI" ENABLE;


-- sqlcl_snapshot {"hash":"23d98c6bfd098d0504c7a90a1d3afb39fcefa256","type":"TRIGGER","name":"TR_ISI_CONTACT_BI","schemaName":"DIRKSPZM32","sxml":""}