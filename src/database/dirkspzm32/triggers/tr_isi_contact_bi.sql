
  CREATE OR REPLACE EDITIONABLE TRIGGER "DIRKSPZM32"."TR_ISI_CONTACT_BI" 
  before insert on DIRKSPZM32.isi_contact
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
ALTER TRIGGER "DIRKSPZM32"."TR_ISI_CONTACT_BI" ENABLE;


-- sqlcl_snapshot {"hash":"e88f902a2928847d8a6f1fe943264c8cb8c0d745","type":"TRIGGER","name":"TR_ISI_CONTACT_BI","schemaName":"DIRKSPZM32","sxml":""}